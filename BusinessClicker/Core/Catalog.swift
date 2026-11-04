import Foundation

public enum Catalog {
    public static let districts: [District] = [
        District(id: 0, name: "Les Faubourgs", popularity: 0.35, wealth: 0.3, installation: 0, rent: 8, competition: 0.15, unlock: 0),
        District(id: 1, name: "Les Jardins", popularity: 0.55, wealth: 0.5, installation: 2000, rent: 20, competition: 0.25, unlock: 5000),
        District(id: 2, name: "Cœur de ville", popularity: 0.8, wealth: 0.7, installation: 12000, rent: 60, competition: 0.4, unlock: 40000),
        District(id: 3, name: "Rive d’Or", popularity: 0.95, wealth: 1, installation: 50000, rent: 150, competition: 0.5, unlock: 250000),
        District(id: 4, name: "Horizon international", popularity: 1, wealth: 1.3, installation: 250000, rent: 500, competition: 0.6, unlock: 5000000)
    ]
    public static let suppliers = [
        Supplier(id: 0, name: "Marché local", factor: 1, quality: 1, delay: 1, minimum: 10, reliability: 1),
        Supplier(id: 1, name: "Crousti Gros", factor: 0.8, quality: 0.85, delay: 2, minimum: 40, reliability: 0.9),
        Supplier(id: 2, name: "Terroir Sélection", factor: 1.25, quality: 1.2, delay: 1, minimum: 20, reliability: 0.98)
    ]
    public static let businesses: [BusinessDefinition] = {
        let rows: [(String, String, String)] = [
            ("Tasty Crousty", "Restauration", "takeoutbag.and.cup.and.straw.fill"),
            ("Miette & Cie", "Restauration", "birthday.cake.fill"), ("Café Brume", "Restauration", "cup.and.saucer.fill"), ("Épicerie Luma", "Commerce", "basket.fill"),
            ("Fleur de Rue", "Commerce", "leaf.fill"), ("Table Auguste", "Restauration", "fork.knife"), ("Atelier Vélo", "Commerce", "bicycle"), ("Studio Noma", "Commerce", "scissors"),
            ("Écho Publicité", "Communication", "megaphone.fill"), ("Colis Nova", "Logistique", "shippingbox.fill"), ("Escapade", "Tourisme", "suitcase.fill"), ("Hôtel Aurore", "Tourisme", "bed.double.fill"),
            ("Bureau Atlas", "Immobilier", "building.2.fill"), ("Entrepôts Axis", "Immobilier", "archivebox.fill"), ("Cargo Bleu", "Logistique", "truck.box.fill"), ("Mobilis", "Transport", "bus.fill"),
            ("Forge Union", "Industrie", "hammer.fill"), ("Textile Onde", "Industrie", "tshirt.fill"), ("Octet Studio", "Technologie", "laptopcomputer"), ("Nexa Logiciels", "Technologie", "curlybraces"),
            ("Cloud Céleste", "Cloud", "cloud.fill"), ("Data Horizon", "Cloud", "server.rack"), ("Neuron Lab", "IA", "brain"), ("Synapse Vision", "IA", "eye.fill"),
            ("Fidélis Banque", "Finance", "banknote.fill"), ("Sérénité Assurances", "Finance", "shield.fill"), ("Solis Énergie", "Énergie", "sun.max.fill"), ("Éolys", "Énergie", "wind"),
            ("Maison Velours", "Luxe", "sparkles"), ("Horlogerie Orbe", "Luxe", "clock.fill"), ("Onde Télécom", "Télécom", "antenna.radiowaves.left.and.right"), ("Fibre Azur", "Télécom", "network"),
            ("Vita Recherche", "Biotech", "cross.case.fill"), ("Genoma", "Biotech", "microbe.fill"), ("Ailes Boréales", "Tourisme", "airplane"), ("Orbitalis", "Spatial", "moon.stars.fill"),
            ("Cosmos Propulsion", "Spatial", "flame.fill"), ("Helios Fusion", "Énergie", "bolt.fill"), ("Quantum Aube", "Technologie", "atom"), ("Nova Mondiale", "Finance", "globe.europe.africa.fill")
        ]
        return rows.enumerated().map { i, row in
            let base = i == 0 ? 1200.0 : 450 * pow(1.72, Double(i))
            let cost = money(base)
            return BusinessDefinition(id: i, name: row.0, sector: row.1, symbol: row.2, price: cost, revenue: money(base * 0.12), costs: money(base * 0.035), unlock: i < 3 ? 0 : money(base * 0.7), district: min(4, i / 8))
        }
    }()
    public static let properties: [PropertyDefinition] = {
        let kinds = ["Studio", "Appartement", "Maison", "Immeuble", "Villa", "Résidence de luxe", "Local commercial", "Bureaux"]
        let names = ["Studio des Lilas", "Appartement Bellevue", "Maison des Ormes", "Résidence des Jardins", "Villa Rive d’Or", "Palais des Lumières", "Arcade du Marché", "Tour Horizon"]
        return (0..<16).map { i in
            let price = money(8000 * pow(1.85, Double(i)))
            return PropertyDefinition(id: i, name: names[i % 8] + (i >= 8 ? " II" : ""), kind: kinds[i % 8], district: min(4, i / 3), area: 24 + i * 38, price: price, marketRent: cents(price * 0.006), charges: cents(price * 0.001))
        }
    }()
    public static let luxuries: [Luxury] = {
        let rows = [("Veste Atelier", "Vêtements", "tshirt.fill"), ("Montre Orbe", "Montres", "clock.fill"), ("Moto Sillage", "Motos", "bicycle"), ("Citadine Alba", "Voitures", "car.fill"), ("Bague Aster", "Bijoux", "circle.hexagongrid.fill"), ("Loft personnel", "Logements", "house.fill"), ("Sculpture Élan", "Art", "paintpalette.fill"), ("Roadster Vela", "Voitures", "car.side.fill"), ("Collection numismatique", "Collections", "seal.fill"), ("Villa personnelle", "Maisons", "house.lodge.fill"), ("Yacht Ondine", "Yachts", "sailboat.fill"), ("Jet Altitude", "Jets", "airplane")]
        return rows.enumerated().map { i, row in Luxury(id: i, name: row.0, category: row.1, symbol: row.2, price: money(150 * pow(3.5, Double(i))), status: i + 1) }
    }()
    public static let people: [PersonDefinition] = {
        let names = ["Marie", "Karim", "Lina", "Jules", "Sofia", "Hugo", "Camille", "Nora", "Adam", "Inès", "Louis", "Maya", "Gabriel", "Sarah", "Émile", "Jade", "Noah", "Alice", "Amir", "Chloé", "Paul", "Yasmine", "Lucas", "Rose", "Elias", "Eva", "Arthur", "Lou", "Rayan", "Zoé", "Oscar", "Mila", "Victor", "Anna", "Sami", "Clara"]
        let roles = ["Mère", "Père", "Amie d’enfance", "Chef cuisinier", "Investisseuse", "Voisin", "Artiste", "Architecte", "Livreur", "Journaliste", "Concurrent", "Partenaire potentielle"]
        let traits = ["Bienveillant", "Pragmatique", "Créatif", "Ambitieux", "Réservé", "Curieux"]
        let preferences = ["Repas", "Culture", "Sport", "Affaires"]
        return names.enumerated().map { i, name in PersonDefinition(id: i, name: name, role: roles[i % 12], personality: traits[i % 6], preference: preferences[i % 4], symbol: ["person.fill", "person.crop.square.fill", "person.circle.fill"][i % 3], unlockDay: i < 4 ? 1 : i * 2) }
    }()
}
