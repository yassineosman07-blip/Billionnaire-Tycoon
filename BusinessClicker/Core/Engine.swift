import Foundation

public enum Engine {
    public static let daySeconds: TimeInterval = 1800
    public static let maximumBalance: Money = Decimal(string: "1000000000000000000000000000000")!
    public static func validate(_ w: World) throws {
        func unique(_ ids: [Int]) -> Bool { Set(ids).count == ids.count }
        guard w.version == 1, (1...10_000_000).contains(w.day), (1000...Int.max - 10000).contains(w.nextID),
              !w.cash.isNaN, !w.debt.isNaN, w.cash >= 0, w.cash <= maximumBalance, w.debt >= 0, w.debt <= maximumBalance,
              !w.pendingStockCosts.isNaN, w.pendingStockCosts >= 0, w.pendingStockCosts <= maximumBalance,
              w.lastSimulated.timeIntervalSince1970.isFinite, w.lastSimulated.timeIntervalSince1970 >= 0,
              w.reputation.isFinite, (0...100).contains(w.reputation), (0...1).contains(w.offlineYield),
              (0...23).contains(w.opening), (1...24).contains(w.closing), w.closing > w.opening,
              Catalog.suppliers.indices.contains(w.supplier), (0...3).contains(w.market), (0...100).contains(w.innovation),
              w.ingredients.count == 4, w.products.count == 2, w.relationships.count == Catalog.people.count,
              w.businesses.first?.id == 0, unique(w.businesses.map(\.id)), unique(w.ingredients.map(\.id)),
              unique(w.products.map(\.id)), unique(w.properties.map(\.id)), unique(w.relationships.map(\.id)), unique(w.luxuries),
              w.ingredients.enumerated().allSatisfy({ $0.offset == $0.element.id }), w.products.enumerated().allSatisfy({ $0.offset == $0.element.id }), w.relationships.enumerated().allSatisfy({ $0.offset == $0.element.id }),
              unique(w.orders.map(\.id)), unique(w.messages.map(\.id)), unique(w.events.map(\.id)), unique(w.appointments.map(\.id)),
              w.businesses.allSatisfy({ Catalog.businesses.indices.contains($0.id) && (1...100).contains($0.level) && (0...30).contains($0.employees) && (0...10).contains($0.training) && $0.reputation.isFinite && (0...100).contains($0.reputation) }),
              w.ingredients.allSatisfy({ (0..<4).contains($0.id) && (0...1000000).contains($0.quantity) && $0.unitCost > 0 && $0.unitCost <= 100 && $0.quality.isFinite && (0.5...1.5).contains($0.quality) }),
              w.products.allSatisfy({ (0..<2).contains($0.id) && $0.price >= 1 && $0.price <= 100 && $0.referencePrice > 0 && $0.referencePrice <= 100 && $0.popularity.isFinite && (0...5).contains($0.popularity) && $0.preparationMinutes > 0 && !$0.recipe.isEmpty && $0.recipe.allSatisfy { (0..<4).contains($0.key) && (1...10).contains($0.value) } }),
              w.orders.allSatisfy({ (0..<4).contains($0.ingredient) && (1...10000).contains($0.quantity) && $0.due >= 1 && Catalog.suppliers.indices.contains($0.supplier) && $0.cost >= 0 && $0.cost <= maximumBalance }),
              w.properties.allSatisfy({ Catalog.properties.indices.contains($0.id) && (0...5).contains($0.renovations) && $0.askingRent >= 0 && $0.askingRent <= Catalog.properties[$0.id].marketRent * 3 && $0.purchase > 0 && $0.purchase <= maximumBalance && $0.condition.isFinite && (0...100).contains($0.condition) && ($0.due == nil || $0.workStarted != nil) }),
              w.luxuries.allSatisfy({ Catalog.luxuries.indices.contains($0) }),
              w.relationships.allSatisfy({ Catalog.people.indices.contains($0.id) && (0...100).contains($0.affinity) && (0...100).contains($0.trust) }),
              w.messages.allSatisfy({ Catalog.people.indices.contains($0.person) }),
              w.appointments.allSatisfy({ Catalog.people.indices.contains($0.person) && $0.day >= 1 }),
              w.boosts.allSatisfy({ $0.factor.isFinite && (1...2).contains($0.factor) }),
              w.partner == nil || Catalog.people.indices.contains(w.partner!), (0...5).contains(w.children)
        else { throw GameError.invalid("Sauvegarde incohérente ou version non prise en charge. La sauvegarde n’a pas été écrasée.") }
        func amount(_ value: Money) -> Bool { !value.isNaN && value >= 0 && value <= maximumBalance }
        let ids = w.orders.map(\.id) + w.messages.map(\.id) + w.events.map(\.id) + w.appointments.map(\.id) + w.boosts.map(\.id) + w.sales.map(\.id)
        guard ids.allSatisfy({ $0 >= 0 && $0 <= w.nextID }), unique(ids),
              [w.totalCustomers, w.totalOrders, w.totalUpgrades, w.totalSocial].allSatisfy({ (0...1_000_000_000_000_000).contains($0) }),
              !w.lifetimeProfit.isNaN, w.lifetimeProfit >= -maximumBalance, w.lifetimeProfit <= maximumBalance,
              w.reports.count <= 730, unique(w.reports.map(\.id)), Set(w.claimed).count == w.claimed.count,
              w.properties.allSatisfy({ p in
                  (1...w.day).contains(p.acquired) && amount(p.renovationSpent) && amount(p.rents) && amount(p.charges) &&
                  (p.due == nil || (1...10_000_100).contains(p.due!)) && (p.workStarted == nil || (1...w.day).contains(p.workStarted!))
              }),
              w.reports.allSatisfy({ $0.id >= 1 && $0.id < w.day && amount($0.revenue) && amount($0.costs) && amount($0.rent) && amount($0.reward) && amount($0.stockPurchases) && amount($0.closing) && !$0.cashChange.isNaN && $0.customers >= 0 }),
              w.relationships.allSatisfy({ (0...100).contains($0.mood) && (-1...w.day).contains($0.lastInteraction) }),
              w.orders.allSatisfy({ $0.due <= 10_000_100 }), w.appointments.allSatisfy({ $0.day <= 10_000_100 }),
              w.events.allSatisfy({ (1...w.day).contains($0.day) }), w.messages.allSatisfy({ (1...w.day).contains($0.day) })
        else { throw GameError.invalid("Historique ou identifiants de sauvegarde invalides.") }
    }
    static func spend(_ amount: Money, in w: inout World) throws {
        guard !amount.isNaN, amount >= 0, amount <= maximumBalance else { throw GameError.invalid("Montant invalide.") }
        guard w.cash >= amount else { throw GameError.insufficientFunds }; w.cash -= amount
    }
    static func credit(_ amount: Money, in w: inout World) { w.cash = min(maximumBalance, w.cash + max(0, amount)) }
    static func bill(_ amount: Money, in w: inout World) {
        let paid = min(w.cash, amount); w.cash -= paid; w.debt = min(maximumBalance, w.debt + amount - paid)
    }
    static func sample(seed: UInt64, day: Int, salt: Int) -> Double {
        var x = seed &+ UInt64(day) &* 6364136223846793005 &+ UInt64(max(0, salt)) &* 1442695040888963407
        x = (x ^ (x >> 30)) &* 0xbf58476d1ce4e5b9; x = (x ^ (x >> 27)) &* 0x94d049bb133111eb
        return Double((x ^ (x >> 31)) >> 11) / 9007199254740992
    }
    public static func upgradeCost(_ b: Business) -> Money { cents(Catalog.businesses[b.id].price * money(0.12 * pow(1.19, Double(b.level - 1)))) }
    public static func renovationCost(_ p: Property) -> Money { cents(Catalog.properties[p.id].price * money(0.12 + Double(p.renovations) * 0.03)) }
    public static func marketRent(_ p: Property) -> Money { cents(Catalog.properties[p.id].marketRent * money(1 + Double(p.renovations) * 0.1)) }
    public static func recipeCost(_ product: Product, world: World) -> Money { product.recipe.reduce(0) { $0 + world.ingredients[$1.key].unitCost * Decimal($1.value) } }
    public static func order(_ w: inout World, ingredient: Int, quantity: Int, supplier: Int) throws {
        guard w.ingredients.indices.contains(ingredient), Catalog.suppliers.indices.contains(supplier), (1...10000).contains(quantity) else { throw GameError.invalid("Commande invalide.") }
        let s = Catalog.suppliers[supplier]
        guard quantity >= s.minimum, w.orders.count < 200 else { throw GameError.invalid("Respectez le minimum fournisseur et limitez les commandes en attente.") }
        let cost = cents(w.ingredients[ingredient].unitCost * Decimal(quantity) * money(s.factor))
        try spend(cost, in: &w); w.pendingStockCosts += cost
        let id = w.identifier(); let late = sample(seed: w.seed, day: w.day, salt: id) > s.reliability ? 1 : 0
        w.orders.append(Order(id: id, ingredient: ingredient, quantity: quantity, due: w.day + s.delay + late, cost: cost, supplier: supplier)); w.totalOrders += 1
    }
    public static func buyBusiness(_ w: inout World, id: Int) throws {
        guard Catalog.businesses.indices.contains(id), !w.businesses.contains(where: { $0.id == id }) else { throw GameError.invalid("Entreprise déjà acquise ou inconnue.") }
        let d = Catalog.businesses[id]
        guard w.netWorth >= d.unlock, id < 32 || w.market > 0 else { throw GameError.locked }
        try spend(d.price + Catalog.districts[d.district].installation, in: &w); w.businesses.append(Business(id: id))
    }
    public static func upgrade(_ w: inout World, id: Int) throws {
        guard let i = w.businesses.firstIndex(where: { $0.id == id }), w.businesses[i].level < 100 else { throw GameError.invalid("Niveau maximum ou entreprise inconnue.") }
        try spend(upgradeCost(w.businesses[i]), in: &w); w.businesses[i].level += 1; w.totalUpgrades += 1
    }
    public static func hire(_ w: inout World, id: Int, manager: Bool) throws {
        guard let i = w.businesses.firstIndex(where: { $0.id == id }) else { throw GameError.locked }
        if manager {
            guard !w.businesses[i].manager else { throw GameError.invalid("Manager déjà recruté.") }
            try spend(300, in: &w); w.businesses[i].manager = true
        } else {
            guard w.businesses[i].employees < 30 else { throw GameError.invalid("Équipe complète.") }
            try spend(60, in: &w); w.businesses[i].employees += 1
        }
    }
    public static func train(_ w: inout World, id: Int) throws {
        guard let i = w.businesses.firstIndex(where: { $0.id == id }), w.businesses[i].employees > 0, w.businesses[i].training < 10 else { throw GameError.invalid("Recrutez une équipe ; formation limitée à 10 niveaux.") }
        try spend(Decimal(100 * (w.businesses[i].training + 1)), in: &w); w.businesses[i].training += 1
    }
    public static func fire(_ w: inout World, id: Int) throws {
        guard let i = w.businesses.firstIndex(where: { $0.id == id }), w.businesses[i].employees > 0 else { throw GameError.invalid("Aucun employé.") }
        w.businesses[i].employees -= 1
    }
    public static func buyProperty(_ w: inout World, id: Int) throws {
        guard Catalog.properties.indices.contains(id), !w.properties.contains(where: { $0.id == id }) else { throw GameError.invalid("Bien déjà acquis ou inconnu.") }
        let d = Catalog.properties[id]; try spend(d.price, in: &w)
        w.properties.append(Property(id: id, acquired: w.day, purchase: d.price, askingRent: d.marketRent))
    }
    public static func setRent(_ w: inout World, id: Int, rent: Money) throws {
        guard let i = w.properties.firstIndex(where: { $0.id == id }), rent >= 0, rent <= Catalog.properties[id].marketRent * 3 else { throw GameError.invalid("Loyer hors limites.") }
        w.properties[i].askingRent = cents(rent)
        // Excessive rents evict the current tenant; vacancy is simulated next day.
        if rent > marketRent(w.properties[i]) * 1.3 { w.properties[i].occupied = false }
    }
    public static func renovate(_ w: inout World, id: Int) throws {
        guard let i = w.properties.firstIndex(where: { $0.id == id }), w.properties[i].due == nil, w.properties[i].renovations < 5 else { throw GameError.invalid("Travaux en cours ou cinq rénovations déjà réalisées.") }
        let cost = renovationCost(w.properties[i]); try spend(cost, in: &w)
        w.properties[i].renovationSpent += cost; w.properties[i].due = w.day + 3 + w.properties[i].renovations * 2
        w.properties[i].workStarted = w.day; w.properties[i].occupied = false
    }
    public static func sellProperty(_ w: inout World, id: Int) throws {
        guard let i = w.properties.firstIndex(where: { $0.id == id }), w.properties[i].due == nil else { throw GameError.invalid("Terminez les travaux avant de vendre.") }
        let p = w.properties[i]; let proceeds = cents(w.propertyValue(p) * 0.95); credit(proceeds, in: &w)
        let saleID = w.identifier(); w.sales.append(Sale(id: saleID, name: Catalog.properties[id].name, day: w.day, purchase: p.purchase, renovation: p.renovationSpent, charges: p.charges, rents: p.rents, proceeds: proceeds))
        w.properties.remove(at: i)
    }
    public static func buyLuxury(_ w: inout World, id: Int) throws {
        guard Catalog.luxuries.indices.contains(id), !w.luxuries.contains(id) else { throw GameError.invalid("Objet déjà dans la collection.") }
        try spend(Catalog.luxuries[id].price, in: &w); w.luxuries.append(id)
    }
    public static func interact(_ w: inout World, person: Int, activity: String) throws {
        guard w.relationships.indices.contains(person), Catalog.people[person].unlockDay <= w.day, w.relationships[person].lastInteraction != w.day else { throw GameError.invalid("Cette personne est indisponible ou vous avez déjà partagé un moment aujourd’hui.") }
        try spend(5, in: &w)
        let bonus = Catalog.people[person].preference == activity ? 9 : 5
        w.relationships[person].trust = min(100, w.relationships[person].trust + 4)
        w.relationships[person].affinity = min(100, w.relationships[person].affinity + bonus)
        w.relationships[person].mood = min(100, w.relationships[person].mood + 5)
        w.relationships[person].lastInteraction = w.day; w.totalSocial += 1
    }
    public static func reply(_ w: inout World, message: Int, warm: Bool) throws {
        guard let i = w.messages.firstIndex(where: { $0.id == message }), !w.messages[i].answered else { throw GameError.invalid("Message déjà traité.") }
        let p = w.messages[i].person; w.messages[i].answered = true
        w.relationships[p].trust = min(100, w.relationships[p].trust + (warm ? 4 : 1))
    }
    public static func schedule(_ w: inout World, person: Int, inDays: Int, prepared: Bool) throws {
        guard w.relationships.indices.contains(person), Catalog.people[person].unlockDay <= w.day, (1...30).contains(inDays), !w.appointments.contains(where: { !$0.resolved && $0.person == person && $0.day == w.day + inDays }) else { throw GameError.invalid("Rendez-vous invalide ou déjà programmé.") }
        if prepared { try spend(15, in: &w) }
        let id = w.identifier(); w.appointments.append(Appointment(id: id, person: person, day: w.day + inDays, prepared: prepared))
    }
    public static func family(_ w: inout World, person: Int) throws {
        guard person >= 2, w.relationships.indices.contains(person), Catalog.people[person].unlockDay <= w.day else { throw GameError.locked }
        let r = w.relationships[person]
        guard r.affinity >= 70, r.trust >= 65, w.lastFamilyDay != w.day else { throw GameError.invalid("Développez d’abord une relation de confiance (65) et d’affinité (70). Une étape familiale par jour.") }
        if w.partner == nil { w.partner = person }
        else if w.partner == person && !w.married { try spend(500, in: &w); w.married = true }
        else if w.partner == person && w.married && w.children < 5 { try spend(250, in: &w); w.children += 1 }
        else { throw GameError.invalid("Cette étape familiale n’est pas disponible.") }
        w.lastFamilyDay = w.day
    }
    public static func repay(_ w: inout World) throws { let payment = min(w.debt, w.cash); guard payment > 0 else { throw GameError.invalid("Aucune dette remboursable.") }; w.cash -= payment; w.debt -= payment }
    public static func rescue(_ w: inout World) throws {
        let key = "rescue-\(w.day)"
        guard w.cash < 20, !w.claimed.contains(key) else { throw GameError.invalid("Aide réservée aux difficultés de trésorerie, une fois par jour.") }
        // Recoverable working-capital loan, no money creation by repeated tapping.
        w.claimed.append(key); credit(40, in: &w); w.debt += 40
    }
    public static func innovate(_ w: inout World) throws {
        guard w.innovation < 100 else { throw GameError.invalid("Recherche maximale atteinte.") }
        let cost = money(1000 * pow(1.5, Double(w.innovation))); try spend(cost, in: &w); w.innovation += 1
    }
    public static func expand(_ w: inout World) throws {
        guard w.market < 3, w.netWorth >= money(5e6 * pow(10, Double(w.market))) else { throw GameError.locked }
        try spend(money(250000 * pow(10, Double(w.market))), in: &w); w.market += 1
    }
    public static func claim(_ w: inout World, key: String) throws {
        guard !w.claimed.contains(key), let goal = goals(w).first(where: { $0.id == key }), goal.complete else { throw GameError.invalid("Objectif non atteint ou récompense déjà reçue.") }
        w.claimed.append(key); credit(goal.reward, in: &w)
    }
    public static func choose(_ w: inout World, event id: Int, option: Int) throws {
        guard let i = w.events.firstIndex(where: { $0.id == id }), !w.events[i].resolved, (0...2).contains(option) else { throw GameError.invalid("Événement déjà résolu ou choix invalide.") }
        let cost: Money = option == 0 ? w.events[i].participationCost : 0
        try spend(cost, in: &w)
        if option == 0 {
            let boostID = w.identifier(); w.boosts.append(Boost(id: boostID, name: w.events[i].title, until: w.day + 3, factor: 1.2))
            w.reputation = min(100, w.reputation + 2)
            switch w.events[i].definition?.category {
            case .investment: credit(500, in: &w); w.debt += 500
            case .family, .social, .culture:
                let person = w.events[i].definition?.category == .family ? 0 : 2
                w.relationships[person].trust = min(100, w.relationships[person].trust + 5)
                w.relationships[person].affinity = min(100, w.relationships[person].affinity + 5)
            default: break
            }
        } else if option == 1 { w.reputation = min(100, w.reputation + 0.5) }
        w.events[i].resolved = true; w.events[i].choice = option
        w.events[i].result = option == 0 ? w.events[i].consequence : option == 1 ? "Vous échangez avec le quartier : réputation +0,5." : "Vous préservez votre temps et votre trésorerie."
    }
    /// One simulation pipeline. The report's day is the completed day, then the calendar advances.
    @discardableResult public static func advance(_ w: inout World, offline: Bool = false) throws -> DailyReport {
        try validate(w)
        guard w.day < 10_000_000 else { throw GameError.invalid("Limite de calendrier atteinte.") }
        let before = w.cash; var revenue: Money = 0; var costs: Money = 0; var rents: Money = 0; var rewards: Money = 0
        var notes: [String] = []; var customers = 0
        let day = w.day
        for o in w.orders where o.due <= day {
            let old = w.ingredients[o.ingredient].quantity
            let quality = Catalog.suppliers[o.supplier].quality
            w.ingredients[o.ingredient].quality = (Double(old) * w.ingredients[o.ingredient].quality + Double(o.quantity) * quality) / Double(old + o.quantity)
            w.ingredients[o.ingredient].quantity = min(1000000, old + o.quantity)
            notes.append("Livraison : \(o.quantity) \(w.ingredients[o.ingredient].name).")
        }
        w.orders.removeAll { $0.due <= day }
        for i in w.properties.indices {
            if let due = w.properties[i].due, due <= day {
                w.properties[i].due = nil; w.properties[i].workStarted = nil; w.properties[i].renovations += 1
                w.properties[i].condition = min(100, w.properties[i].condition + 9)
                notes.append("Travaux terminés : \(Catalog.properties[w.properties[i].id].name).")
            }
        }
        // Managers only place affordable, dated orders; the same delivery rules apply offline.
        if w.businesses[0].manager {
            for i in w.ingredients.indices where w.ingredients[i].quantity < 20 && !w.orders.contains(where: { $0.ingredient == i }) {
                let count = min(10000, max(40, w.businesses[0].level * 30, Catalog.suppliers[w.supplier].minimum))
                try? order(&w, ingredient: i, quantity: count, supplier: w.supplier)
            }
        }
        let stockPurchases = w.pendingStockCosts; costs += stockPurchases; w.pendingStockCosts = 0
        let efficiency = offline ? w.offlineYield : 1
        let boost = min(2, w.boosts.filter { $0.until > day }.reduce(1.0) { $0 * $1.factor })
        for i in w.businesses.indices {
            let b = w.businesses[i]; let d = Catalog.businesses[b.id]
            let hours = Double(w.closing - w.opening)
            let district = Catalog.districts[d.district]
            let productivity = (1 + Double(b.employees) * 0.14 + Double(b.training) * 0.04) * (b.manager ? 1.1 : 1)
            let growth = pow(1.14, Double(b.level - 1)) * w.synergy * (1 + Double(w.innovation) * 0.1) * (1 + Double(w.market) * 0.2)
            var earned: Money = 0
            if b.id == 0 {
                var capacity = max(1, Int(hours * 60 * productivity * pow(1.025, Double(b.level - 1))))
                for product in w.products where product.enabled {
                    let priceRatio = number(product.referencePrice) / number(product.price)
                    let quality = product.recipe.keys.reduce(0.0) { $0 + w.ingredients[$1].quality } / Double(product.recipe.count)
                    let demand = max(0, Int(quality * (1 - district.competition * 0.3) * (8 + district.popularity * 24 + b.reputation * 0.18) * product.popularity * pow(1.04, Double(b.level - 1)) * pow(priceRatio, 1.6) * hours / 8 * boost * w.synergy * (0.85 + sample(seed: w.seed, day: day, salt: product.id) * 0.3)))
                    let available = product.recipe.map { w.ingredients[$0.key].quantity / $0.value }.min() ?? 0
                    let count = min(demand, capacity / product.preparationMinutes, available); capacity -= count * product.preparationMinutes
                    for (ingredient, amount) in product.recipe { w.ingredients[ingredient].quantity -= amount * count }
                    customers += count; earned += product.price * Decimal(count) * money(efficiency)
                }
            } else {
                earned = d.revenue * money(growth * productivity * boost * efficiency * (0.9 + sample(seed: w.seed, day: day, salt: b.id + 50) * 0.2))
            }
            let operating = b.id == 0 ? money(8 + hours * 0.75) : d.costs * money(pow(1.09, Double(b.level - 1))) + district.rent
            let wages = Decimal(b.employees * 12 + (b.manager ? 18 : 0))
            earned = cents(earned)
            let expense = cents(operating + wages)
            revenue += earned; costs += expense; credit(earned, in: &w); bill(expense, in: &w)
            w.businesses[i].lastRevenue = earned; w.businesses[i].lastCosts = expense
            w.businesses[i].reputation = min(100, max(0, b.reputation + (earned > expense ? 0.3 : -0.15)))
        }
        for i in w.properties.indices {
            let p = w.properties[i]; let d = Catalog.properties[p.id]
            if p.due == nil {
                let ratio = number(p.askingRent / marketRent(p))
                let probability = max(0, min(0.96, 0.65 + Catalog.districts[d.district].popularity * 0.3 + p.condition / 500 - max(0, ratio - 0.85) * 0.9))
                let roll = sample(seed: w.seed, day: day, salt: p.id + 500)
                if !p.occupied { w.properties[i].occupied = roll < probability }
                else if ratio > 1.3 || roll > 0.985 { w.properties[i].occupied = false }
                if w.properties[i].occupied {
                    let rent = cents(p.askingRent * money(efficiency)); rents += rent; credit(rent, in: &w); w.properties[i].rents += rent
                }
            }
            costs += d.charges; bill(d.charges, in: &w); w.properties[i].charges += d.charges
        }
        let familyCosts = Decimal(w.children * 8 + (w.married ? 3 : 0)); costs += familyCosts; bill(familyCosts, in: &w)
        for i in w.appointments.indices where !w.appointments[i].resolved && w.appointments[i].day <= day {
            let a = w.appointments[i]; let success = a.prepared || sample(seed: w.seed, day: day, salt: a.id) < 0.5
            w.relationships[a.person].trust = min(100, max(0, w.relationships[a.person].trust + (success ? 8 : -2)))
            w.relationships[a.person].affinity = min(100, w.relationships[a.person].affinity + (success ? 5 : 0))
            w.appointments[i].resolved = true; notes.append("Rendez-vous avec \(Catalog.people[a.person].name) : \(success ? "une belle rencontre" : "à mieux préparer").")
            let id = w.identifier(); w.messages.append(Message(id: id, person: a.person, day: day, text: success ? "Merci pour ce moment. On se revoit bientôt !" : "Reprenons le temps d’en discuter une autre fois."))
        }
        if day % 3 == 0 && w.events.filter({ !$0.resolved }).count < 12 {
            let eligible = Catalog.story.filter { definition in
                definition.eligible(w) && !w.events.contains { $0.key == "template-\(definition.id)" && (definition.oneShot || day - $0.day < 45) }
            }
            if !eligible.isEmpty {
                let index = Int(sample(seed: w.seed, day: day, salt: 771) * Double(eligible.count))
                let definition = eligible[index]; let id = w.identifier()
                w.events.append(StoryEvent(id: id, key: "template-\(definition.id)", day: day, title: definition.title, text: definition.text))
            }
        }
        if day % 5 == 0 {
            let p = min(Catalog.people.count - 1, day / 5); let id = w.identifier()
            if Catalog.people[p].unlockDay <= day { w.messages.append(Message(id: id, person: p, day: day, text: "J’ai entendu parler de votre aventure. Et si nous prenions le temps d’échanger ?")) }
        }
        if customers >= 15 {
            let key = "daily-\(day)"
            if !w.claimed.contains(key) { rewards = 10; credit(rewards, in: &w); w.claimed.append(key); notes.append("Mission quotidienne : 15 clients servis, +10 €.") }
        }
        if w.ingredients.allSatisfy({ $0.quantity < 1 }) { notes.append("Stocks épuisés : commandez pour relancer le service. Une avance de secours est disponible sous 20 €.") }
        w.totalCustomers += customers; w.reputation = min(100, max(0, w.reputation + (customers > 10 ? 0.2 : 0)))
        let report = DailyReport(id: day, revenue: revenue, costs: costs, rent: rents, reward: rewards, stockPurchases: stockPurchases, cashChange: w.cash - before, closing: w.cash, customers: customers, offline: offline, notes: notes)
        w.lifetimeProfit += report.profit; w.reports.append(report); w.day += 1
        w.boosts.removeAll { $0.until <= w.day }
        w.claimed.removeAll { key in
            if key.hasPrefix("daily-") || key.hasPrefix("rescue-") {
                return (Int(key.split(separator: "-").last ?? "") ?? w.day) < w.day - 730
            }
            return false
        }
        // Keep a bounded financial window; lifetime counters and permanent achievements remain retained.
        if w.reports.count > 730 { w.reports.removeFirst(w.reports.count - 730) }
        return report
    }
    /// Processes a bounded chunk; callers can continue until caught up without blocking the UI.
    @discardableResult public static func catchUp(_ w: inout World, now: Date, offline: Bool, limit: Int = 365) throws -> Int {
        try validate(w)
        guard now >= w.lastSimulated else { return 0 } // Clock rollback never grants income.
        let elapsed = now.timeIntervalSince(w.lastSimulated)
        let count = min(max(0, limit), Int(min(10_000_000, floor(elapsed / daySeconds))))
        for _ in 0..<count { try advance(&w, offline: offline); w.lastSimulated.addTimeInterval(daySeconds) }
        return count
    }
    public static func manual(_ w: inout World, days: Int, now: Date) throws {
        guard (1...365).contains(days) else { throw GameError.invalid("Avance limitée à 365 journées par action.") }
        // Settle real time before a manual command, then re-anchor. Replaying now yields no extra day.
        while try catchUp(&w, now: now, offline: false) > 0 {}
        for _ in 0..<days { try advance(&w) }
        w.lastSimulated = max(now, w.lastSimulated)
    }
}
public struct Goal: Identifiable {
    public var id: String; public var title: String; public var progress: String; public var complete: Bool; public var reward: Money
}
extension Engine {
    public static func goals(_ w: World) -> [Goal] {
        [Goal(id: "first-service", title: "Le premier service", progress: "\(min(15, w.totalCustomers)) / 15 clients", complete: w.totalCustomers >= 15, reward: 40),
         Goal(id: "supplier", title: "Toujours prêt", progress: "\(min(3, w.totalOrders)) / 3 commandes", complete: w.totalOrders >= 3, reward: 50),
         Goal(id: "upgrade", title: "Voir plus grand", progress: "\(min(3, w.totalUpgrades)) / 3 améliorations", complete: w.totalUpgrades >= 3, reward: 100),
         Goal(id: "network", title: "Un entourage solide", progress: "\(min(10, w.totalSocial)) / 10 interactions", complete: w.totalSocial >= 10, reward: 150),
         Goal(id: "ten-thousand", title: "Les premiers 10 000 €", progress: euros(w.netWorth, compact: true), complete: w.netWorth >= 10000, reward: 500),
         Goal(id: "second-business", title: "L’esprit d’empire", progress: "\(w.businesses.count) / 2 entreprises", complete: w.businesses.count >= 2, reward: 250),
         Goal(id: "owner", title: "Les clés de demain", progress: "\(w.properties.count) / 1 bien", complete: !w.properties.isEmpty, reward: 500),
         Goal(id: "ten-properties", title: "Bâtisseur", progress: "\(w.properties.count) / 10 biens", complete: w.properties.count >= 10, reward: 10000),
         Goal(id: "million", title: "Le premier million", progress: euros(w.netWorth, compact: true), complete: w.netWorth >= 1000000, reward: 25000),
         Goal(id: "billion", title: "Sans frontières", progress: euros(w.netWorth, compact: true), complete: w.netWorth >= 1000000000, reward: 10000000)]
    }
}
