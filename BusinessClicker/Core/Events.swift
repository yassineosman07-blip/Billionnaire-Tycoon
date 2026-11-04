import Foundation

public enum EventCategory: String, Codable, Sendable { case trade = "Commerce", investment = "Investissement", supply = "Fournisseurs", social = "Rencontre", family = "Famille", crisis = "Imprévu", property = "Immobilier", culture = "Culture", expansion = "Expansion" }
public struct EventDefinition: Identifiable, Sendable {
    public var id: Int; public var title: String; public var category: EventCategory; public var text: String
    public var cost: Money; public var minReputation: Double = 0; public var minWorth: Money = 0
    public var requiresProperty = false; public var minBusinesses = 1; public var minStatus = 0
    public var oneShot = false
    public func eligible(_ w: World) -> Bool {
        (category != .investment || w.social.known.contains(4)) && w.reputation >= minReputation && w.netWorth >= minWorth && (!requiresProperty || !w.properties.isEmpty) && w.businesses.count >= minBusinesses && w.status >= minStatus
    }
}
extension Catalog {
    public static let story: [EventDefinition] = [
        EventDefinition(id: 0, title: "Une place au marché", category: .trade, text: "L’association des commerçants réserve un emplacement pour Tasty Crousty. Préparer une offre découverte peut attirer de nouveaux clients.", cost: 20),
        EventDefinition(id: 1, title: "Le repas des voisins", category: .social, text: "Jules organise un repas dans la cour. Apportez un plat et prenez le temps de rencontrer le voisinage.", cost: 15),
        EventDefinition(id: 2, title: "Un fournisseur débordé", category: .supply, text: "Votre fournisseur anticipe une semaine chargée. Financer une tournée supplémentaire aiderait les petits commerces du quartier.", cost: 25),
        EventDefinition(id: 3, title: "L’anniversaire de Marie", category: .family, text: "Marie aimerait réunir la famille autour d’un repas. Un peu de préparation rendrait cette journée mémorable.", cost: 20),
        EventDefinition(id: 4, title: "Un article local", category: .trade, text: "Inès souhaite raconter votre nouveau départ dans le journal du quartier. Préparez une dégustation pour sa visite.", cost: 30, minReputation: 12),
        EventDefinition(id: 5, title: "Un contrôle qualité", category: .crisis, text: "Un contrôle est annoncé. Une révision des équipements et un nettoyage approfondi peuvent rassurer les clients.", cost: 35),
        EventDefinition(id: 6, title: "Un concours culinaire", category: .trade, text: "Le concours des saveurs ouvre ses inscriptions. Votre cuisine pourrait gagner en visibilité.", cost: 45, minReputation: 15),
        EventDefinition(id: 7, title: "La soirée du musée", category: .culture, text: "Camille vous invite au vernissage d’une exposition. Votre intérêt pour les créations locales sera apprécié.", cost: 25, minStatus: 1),
        EventDefinition(id: 8, title: "Une commande d’entreprise", category: .trade, text: "Un bureau voisin cherche un partenaire pour ses déjeuners. Une dégustation préparée peut amorcer une collaboration.", cost: 50, minReputation: 18),
        EventDefinition(id: 9, title: "Un dossier prometteur", category: .investment, text: "Sofia étudie votre activité. Avec un dossier solide, elle peut accorder une avance remboursable de 500 €, sans abandonner le contrôle de votre entreprise.", cost: 40, minReputation: 20, oneShot: true),
        EventDefinition(id: 10, title: "Une panne de matériel", category: .crisis, text: "Le matériel montre des signes de fatigue. Une maintenance préventive aiderait à conserver la confiance de vos clients.", cost: 30),
        EventDefinition(id: 11, title: "Le pique-nique familial", category: .family, text: "Karim propose une journée au parc. Préparer le panier sera une belle manière de retrouver la famille.", cost: 15),
        EventDefinition(id: 12, title: "Le festival des saveurs", category: .trade, text: "Le festival rassemble les restaurateurs de la ville. Un stand soigné peut faire découvrir votre cuisine.", cost: 100, minWorth: 10000),
        EventDefinition(id: 13, title: "Un partenariat logistique", category: .supply, text: "Une entreprise de livraison propose une opération commune. Préparez un essai pour synchroniser vos équipes.", cost: 80, minBusinesses: 2),
        EventDefinition(id: 14, title: "Les portes ouvertes", category: .property, text: "Votre agence propose une visite de votre patrimoine. Une présentation soignée peut renforcer votre réseau professionnel.", cost: 100, requiresProperty: true),
        EventDefinition(id: 15, title: "Une vitrine à louer", category: .property, text: "Un propriétaire vous demande conseil sur son local vacant. Une rencontre préparée vous rapprochera des acteurs immobiliers.", cost: 75, minWorth: 20000),
        EventDefinition(id: 16, title: "Le prix de l’engagement", category: .social, text: "Les habitants souhaitent distinguer votre implication dans le quartier. Participez à une initiative solidaire.", cost: 60, minReputation: 30),
        EventDefinition(id: 17, title: "Un salon professionnel", category: .expansion, text: "Vos activités attirent l’attention d’autres dirigeants. Un stand commun permettrait de présenter vos savoir-faire.", cost: 250, minBusinesses: 3),
        EventDefinition(id: 18, title: "Un mécène curieux", category: .culture, text: "Un collectionneur veut découvrir les créations de Camille. Votre collection peut servir de point de départ à une nouvelle rencontre.", cost: 150, minStatus: 8),
        EventDefinition(id: 19, title: "La fête du quartier", category: .social, text: "Le quartier célèbre ses commerçants. Apportez votre contribution pour partager votre parcours avec les habitants.", cost: 20),
        EventDefinition(id: 20, title: "Un nouvel horizon", category: .expansion, text: "Un réseau de dirigeants internationaux vous invite à sa rencontre annuelle. Présentez votre vision et vos prochains projets.", cost: 1000, minWorth: 1000000, minBusinesses: 5),
        EventDefinition(id: 21, title: "Le club des bâtisseurs", category: .property, text: "Des propriétaires partagent leurs expériences de rénovation. Un dossier de vos travaux nourrira les échanges.", cost: 200, requiresProperty: true),
        EventDefinition(id: 22, title: "Une recommandation précieuse", category: .investment, text: "Un partenaire souhaite vous présenter à un financeur. Votre réputation professionnelle ouvre cette porte.", cost: 150, minReputation: 40, minBusinesses: 3),
        EventDefinition(id: 23, title: "Les retrouvailles", category: .family, text: "La famille souhaite fêter le chemin parcouru depuis vos débuts. Organisez un repas pour ceux qui vous ont accompagné.", cost: 50, minWorth: 10000)
    ]
}
extension StoryEvent {
    public var definition: EventDefinition? {
        guard key.hasPrefix("template-"), let id = Int(key.dropFirst(9)) else { return nil }
        return Catalog.story.first { $0.id == id }
    }
    public var participationCost: Money { definition?.cost ?? 20 }
    public var consequence: String {
        switch definition?.category {
        case .investment: return "Avance remboursable de 500 €, demande +20 % pendant 3 jours, réputation +2."
        case .family, .social, .culture: return "Confiance et affinité d’un proche +5, demande +20 % pendant 3 jours, réputation +2."
        default: return "Demande +20 % pendant 3 journées, réputation +2."
        }
    }
}
