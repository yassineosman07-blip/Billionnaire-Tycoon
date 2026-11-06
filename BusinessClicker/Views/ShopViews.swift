import SwiftUI
import SceneKit

struct ShoppingDistrictView: View {
    var body: some View {
        Screen {
            Text("Des lieux à découvrir. Des objets à vous approprier.").font(.title3).foregroundStyle(.secondary)
            ForEach(ShopCatalog.categories) { category in
                NavigationLink { ShopCategoryView(category: category.id) } label: {
                    Panel {
                        HStack { IconBadge(symbol: category.symbol, color: .orange); VStack(alignment: .leading, spacing: 6) { Text(category.name).font(.title3.bold()); Text("Deux adresses · deux univers").font(.caption).foregroundStyle(.secondary) }; Spacer(); Image(systemName: "arrow.up.right") }
                    }
                }.buttonStyle(.plain)
            }
        }.navigationTitle("Quartier des boutiques")
    }
}
struct ShopCategoryView: View {
    let category: Int
    var body: some View {
        Screen {
            ForEach(ShopCatalog.shops.filter { $0.category == category }) { shop in
                NavigationLink { ShopInteriorView(shopID: shop.id) } label: {
                    Panel {
                        HStack { IconBadge(symbol: ShopCatalog.categories[category].symbol, color: shop.theme % 2 == 0 ? .cyan : .orange); Text(shop.name).font(.title2.bold()); Spacer(); Image(systemName: "door.left.hand.open") }
                        Text(shop.subtitle).font(.subheadline).foregroundStyle(.secondary)
                        Text("Entrer dans le magasin").font(.caption.bold()).foregroundStyle(.orange)
                    }
                }.buttonStyle(.plain).accessibilityIdentifier("shop-\(shop.id)")
            }
        }.navigationTitle(ShopCatalog.categories[category].name)
    }
}
struct ShopInteriorView: View {
    @EnvironmentObject private var game: GameViewModel
    let shopID: Int
    @State private var selectedItem: Int?
    private var shop: Shop { ShopCatalog.shops[shopID] }
    var body: some View {
        Screen {
            Text(shop.subtitle).font(.subheadline).foregroundStyle(.secondary)
            ShopRoom(shop: shop) { selectedItem = $0 }.frame(height: 290).clipShape(RoundedRectangle(cornerRadius: 22)).accessibilityHidden(true)
            Text("Touchez une présentation pour consulter son article.").font(.caption).foregroundStyle(.secondary)
            ForEach(shop.offers, id: \.self) { id in
                NavigationLink { ItemDetailView(shopID: shopID, itemID: id) } label: {
                    Panel {
                        ArticlePhoto(itemID: id).frame(height: 175).clipped()
                        HStack { Text(Catalog.luxuries[id].name).font(.headline); Spacer(); Text(game.value(shop.price(id))).font(.subheadline.bold()) }
                        if game.world.owns(id) { Label("Dans votre collection", systemImage: "checkmark.seal.fill").font(.caption).foregroundStyle(Palette.mint) }
                    }
                }.buttonStyle(.plain).accessibilityIdentifier("shop-item-\(id)")
            }
        }.navigationTitle(shop.name).navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedItem) { ItemDetailView(shopID: shopID, itemID: $0) }
            .onAppear { game.feedback.enterShop(shopID, settings: game.world.settings) }
            .onDisappear { game.feedback.leaveShop(settings: game.world.settings) }
    }
}
struct ArticlePhoto: View {
    var itemID: Int
    var thumbnail = true
    var body: some View {
        if let url = Bundle.main.url(forResource: "item-\(itemID)\(thumbnail ? "-thumb" : "")", withExtension: "jpg"), let image = UIImage(contentsOfFile: url.path) {
            Image(uiImage: image).resizable().scaledToFit().frame(maxWidth: .infinity).accessibilityLabel(Catalog.luxuries[itemID].name)
        } else {
            VStack(spacing: 10) { Image(systemName: "photo").font(.largeTitle); Text("Photographie indisponible").font(.caption) }.foregroundStyle(.secondary).frame(maxWidth: .infinity, minHeight: 150).background(Palette.background, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
struct ItemDetailView: View {
    @EnvironmentObject private var game: GameViewModel
    let shopID: Int; let itemID: Int
    @State private var confirm = false
    @State private var receipt: String?
    private var shop: Shop { ShopCatalog.shops[shopID] }
    private var item: Luxury { Catalog.luxuries[itemID] }
    var body: some View {
        Screen {
            ArticlePhoto(itemID: itemID, thumbnail: false).frame(minHeight: 240)
            Panel(item.name) {
                Text(shop.name + " · " + item.category).font(.subheadline).foregroundStyle(.secondary)
                LineItem(label: "Prix", value: game.value(shop.price(itemID)))
                LineItem(label: "Statut", value: "+\(item.status) lors de la première acquisition")
                LineItem(label: "Solde après achat", value: game.value(game.world.cash - shop.price(itemID)))
                Text(ShopCatalog.repeatable(itemID) ? "Plusieurs exemplaires autorisés. Chaque exemplaire rejoint votre inventaire personnel." : "Pièce unique. Un seul exemplaire dans votre collection.").font(.caption).foregroundStyle(.secondary)
                ActionButton(title: "Acheter · \(game.value(shop.price(itemID)))", symbol: "cart.fill", accent: .orange) { confirm = true }
                    .disabled(game.world.cash < shop.price(itemID) || !ShopCatalog.repeatable(itemID) && game.world.owns(itemID))
                if let receipt { Label(receipt, systemImage: "checkmark.seal.fill").foregroundStyle(Palette.mint) }
            }
        }.navigationTitle(item.name).navigationBarTitleDisplayMode(.inline)
            .onAppear { game.feedback.enterShop(shopID, settings: game.world.settings) }
            .confirmationDialog("Confirmer l’achat de \(item.name) ?", isPresented: $confirm, titleVisibility: .visible) {
                Button("Payer \(game.value(shop.price(itemID)))") {
                    if game.perform(sound: "purchase", { _ = try Engine.purchase(&$0, item: itemID, shop: shopID) }) { receipt = "Achat enregistré dans votre collection." }
                }
            } message: { Text("Votre solde sera de \(game.value(game.world.cash - shop.price(itemID))).") }
    }
}
struct PersonalCollectionView: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View {
        Screen {
            if game.world.collectionCount == 0 { ContentUnavailableView("Votre collection commence ici", systemImage: "diamond", description: Text("Vos acquisitions apparaîtront ici après votre visite des boutiques.")) }
            ForEach(game.world.ownedItems.reversed()) { owned in
                Panel(Catalog.luxuries[owned.definition].name) { ArticlePhoto(itemID: owned.definition).frame(height: 190); LineItem(label: ShopCatalog.shops[owned.shop].name, value: game.value(owned.paid)); Text("Acquis au jour \(owned.day) · exemplaire \(owned.id)").font(.caption).foregroundStyle(.secondary) }
            }
            ForEach(game.world.luxuries, id: \.self) { id in Panel(Catalog.luxuries[id].name) { ArticlePhoto(itemID: id).frame(height: 190); Text("Votre collection d’origine").font(.caption).foregroundStyle(.secondary) } }
        }.navigationTitle("Ma collection")
    }
}
struct ShopRoom: UIViewRepresentable {
    let shop: Shop; var select: (Int) -> Void
    func makeCoordinator() -> Coordinator { Coordinator(select: select) }
    func makeUIView(context: Context) -> SCNView {
        let view=SCNView(frame: .zero, options: nil);view.antialiasingMode = .multisampling2X;view.preferredFramesPerSecond=30
        view.isAccessibilityElement=false;view.accessibilityElementsHidden=true
        view.scene=ShopSceneBuilder.make(shop);view.pointOfView=view.scene?.rootNode.childNode(withName:"shopCamera",recursively:false)
        if GameRuntime.isUITesting { view.isPlaying=false;view.scene?.isPaused=true }
        view.addGestureRecognizer(UITapGestureRecognizer(target:context.coordinator,action:#selector(Coordinator.tap(_:))))
        return view
    }
    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.select=select
        if context.coordinator.shopID != shop.id { view.scene=ShopSceneBuilder.make(shop);view.pointOfView=view.scene?.rootNode.childNode(withName:"shopCamera",recursively:false);context.coordinator.shopID=shop.id }
        if GameRuntime.isUITesting { view.isPlaying=false;view.scene?.isPaused=true }
    }
    static func dismantleUIView(_ view: SCNView, coordinator: Coordinator) { view.scene=nil }
    @MainActor final class Coordinator: NSObject {
        var select: (Int)->Void
        var shopID = -1
        init(select:@escaping(Int)->Void){self.select=select}
        @objc func tap(_ gesture: UITapGestureRecognizer) {
            guard let view=gesture.view as? SCNView else{return}
            for hit in view.hitTest(gesture.location(in:view),options:nil){
                var node:SCNNode?=hit.node
                while let n=node {
                    if let name=n.name,name.hasPrefix("item-"),let id=Int(name.dropFirst(5)){select(id);return}
                    node=n.parent
                }
            }
        }
    }
}

struct MediaCreditsView: View {
    private var entries: [[String: String]] {
        guard let url = Bundle.main.url(forResource: "media-manifest", withExtension: "json"), let data = try? Data(contentsOf: url), let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let articles = object["articles"] as? [[String: Any]] else { return [] }
        return articles.filter { ($0["status"] as? String) == "ready" }.map { entry in entry.compactMapValues { $0 as? String } }
    }
    var body: some View {
        Screen {
            Panel("Créations du jeu") {
                Text("Bâtiments commerciaux et passants : Kenney, City Kit Commercial 2.1 et Animated Characters Retro 1.1, licence CC0. Rues, décors et intérieurs complémentaires : géométrie originale du projet. Portraits : illustrations 3D cartoon originales générées pour Business Clicker. Sons et ambiances : synthèse locale originale.").font(.subheadline)
            }
            ForEach(Array(entries.enumerated()), id: \.offset) { _, entry in
                Panel(entry["name"] ?? "Photographie") {
                    Text(entry["author"] ?? "").font(.headline)
                    Text(entry["license"] ?? "").font(.caption)
                    if let source = entry["source_page"], let url = URL(string: source) { Link("Source de la photographie", destination: url) }
                    if let license = entry["license_url"], let url = URL(string: license) { Link("Texte de la licence", destination: url) }
                    Text("Photographie redimensionnée et compressée pour l’application.").font(.caption).foregroundStyle(.secondary)
                }
            }
        }.navigationTitle("Crédits des ressources")
    }
}
