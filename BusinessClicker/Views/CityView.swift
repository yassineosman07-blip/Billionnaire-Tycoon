import SwiftUI
import SceneKit

struct CityView: View {
    @EnvironmentObject private var game: GameViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedBranch: Int? = 0
    @State private var selectedPlot: Int? = nil
    @State private var chosenType = 2
    @State private var selectedProperty: Int?
    var body: some View {
        Screen {
            Text("Une ville en mouvement. Votre réseau prend vie.").foregroundStyle(.secondary)
            CityViewport(businesses: game.world.businesses, properties: game.world.properties, active: game.active, reduced: reduceMotion || game.world.settings.reducedMotion) { branch, plot, property in
                selectedBranch = branch; selectedPlot = plot; selectedProperty = property; game.feedback.play("click", settings: game.world.settings)
            }.frame(height: 410).clipShape(RoundedRectangle(cornerRadius: 24)).overlay(alignment: .bottomLeading) {
                Label("Glisser · déplacer    Pincer · zoomer", systemImage: "hand.draw").font(.caption2.bold()).padding(12).background(.ultraThinMaterial, in: Capsule()).padding(10)
            }.accessibilityLabel("Ville 3D. Glisser pour déplacer, pincer pour zoomer, toucher un bâtiment pour le sélectionner.")
            if let id = selectedBranch, let b = game.world.businesses.first(where: { $0.id == id }) {
                Panel(b.name) {
                    HStack { IconBadge(symbol: Catalog.businesses[b.definitionID].symbol); Metric(label: Catalog.districts[b.districtID].name, value: "Niveau \(b.level)") }
                    LineItem(label: "Parcelle", value: "\((b.plot ?? 0) % 24 + 1)")
                    NavigationLink { BusinessDetailView(id: b.id) } label: { Label("Gérer cet établissement", systemImage: "building.2") }
                }
            } else if let plot = selectedPlot {
                Panel("Parcelle \(plot % 24 + 1) · \(Catalog.districts[plot / 24].name)") {
                    Text("Une adresse pour votre prochain projet. Les bâtiments de ce terrain seront remplacés à l’ouverture de votre établissement.").font(.caption).foregroundStyle(.secondary)
                    Picker("Activité", selection: $chosenType) { ForEach(Catalog.businesses) { Text($0.name).tag($0.id) } }
                    NavigationLink { OpenBusinessView(type: chosenType, suggestedDistrict: plot / 24, suggestedPlot: plot) } label: { Label("Ouvrir à cette adresse", systemImage: "plus.circle") }
                }
            }
            if let property = selectedProperty {
                Panel(Catalog.properties[property].name) {
                    Text("Quartier résidentiel · \(Catalog.properties[property].kind)").font(.subheadline).foregroundStyle(.secondary)
                    NavigationLink("Consulter et gérer ce bien") { PropertyDetailView(id: property) }
                }
            }
            Panel("Vos adresses · accès accessible") {
                ForEach(game.world.businesses) { b in NavigationLink { BusinessDetailView(id: b.id) } label: { HStack { Text(b.name); Spacer(); Text("Niv. \(b.level)").foregroundStyle(.secondary) }.font(.subheadline) }.buttonStyle(.plain) }
            }
            ForEach(Catalog.districts) { district in
                Panel(district.name) {
                    LineItem(label: "Popularité / concurrence", value: "\(Int(district.popularity * 100)) / \(Int(district.competition * 100))")
                    ForEach(Catalog.properties.filter { $0.district == district.id }) { property in NavigationLink(property.name) { PropertyDetailView(id: property.id) } }
                }
            }
        }.navigationTitle("Votre ville")
    }
}
struct CityViewport: UIViewRepresentable {
    let businesses: [Business]
    let properties: [Property]
    var active = true
    var reduced: Bool
    var select: (Int?, Int?, Int?) -> Void
    func makeCoordinator() -> Coordinator { Coordinator(select: select) }
    func makeUIView(context: Context) -> SCNView {
        let view = PausableCityView(frame: .zero, options: nil); view.backgroundColor = .clear; view.antialiasingMode = .multisampling2X; view.preferredFramesPerSecond = 30
        view.isPlaying = true; view.autoenablesDefaultLighting = false; view.allowsCameraControl = false
        view.addGestureRecognizer(UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.pan(_:))))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.pinch(_:))))
        view.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tap(_:))))
        return view
    }
    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.select = select
        view.isPlaying = active && view.window != nil; view.scene?.isPaused = !active || view.window == nil
        let signature = businesses.map { "\($0.id):\($0.plot ?? -1):\($0.definitionID):\($0.level)" }.joined(separator: ",") + properties.map { "p\($0.id):\($0.renovations)" }.joined(separator: ",") + "\(reduced)"
        if signature != context.coordinator.signature {
            let oldRig = view.scene?.rootNode.childNode(withName: "cameraRig", recursively: false)?.position
            let oldZoom = view.pointOfView?.camera?.orthographicScale
            do {
                view.scene = try CitySceneBuilder.make(businesses, properties: properties, reduced: reduced)
                view.viewWithTag(7281)?.removeFromSuperview()
            } catch {
                view.scene = nil
                let label = UILabel(frame: view.bounds); label.tag = 7281; label.numberOfLines = 0
                label.text = error.localizedDescription; label.textColor = .white; label.textAlignment = .center
                label.autoresizingMask = [.flexibleWidth, .flexibleHeight]; view.addSubview(label)
                context.coordinator.signature = ""; return
            }
            view.pointOfView = view.scene?.rootNode.childNode(withName: "camera", recursively: true)
            if let oldRig { view.scene?.rootNode.childNode(withName: "cameraRig", recursively: false)?.position = oldRig }
            if let oldZoom { view.pointOfView?.camera?.orthographicScale = oldZoom }
            context.coordinator.signature = signature
        }
    }
    static func dismantleUIView(_ uiView: SCNView, coordinator: Coordinator) { uiView.isPlaying = false; uiView.scene = nil }
    @MainActor final class Coordinator: NSObject {
        var select: (Int?, Int?, Int?) -> Void
        var signature = ""
        init(select: @escaping (Int?, Int?, Int?) -> Void) { self.select = select }
        @objc func pan(_ gesture: UIPanGestureRecognizer) {
            guard let view = gesture.view as? SCNView, let rig = view.scene?.rootNode.childNode(withName: "cameraRig", recursively: false) else { return }
            let t = gesture.translation(in: view); let scale = Float(view.pointOfView?.camera?.orthographicScale ?? 78) / 350
            rig.position.x = max(-95, min(95, rig.position.x - Float(t.x + t.y * 0.5) * scale))
            rig.position.z = max(-70, min(70, rig.position.z + Float(t.x * 0.5 - t.y) * scale))
            gesture.setTranslation(.zero, in: view)
        }
        @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
            guard let view = gesture.view as? SCNView, let camera = view.pointOfView?.camera else { return }
            camera.orthographicScale = max(16, min(125, camera.orthographicScale / Double(gesture.scale))); gesture.scale = 1
        }
        @objc func tap(_ gesture: UITapGestureRecognizer) {
            guard let view = gesture.view as? SCNView else { return }
            for hit in view.hitTest(gesture.location(in: view), options: nil) {
                var node: SCNNode? = hit.node
                while let current = node {
                    if let name = current.name, name.hasPrefix("branch-"), let id = Int(name.dropFirst(7)) { select(id, nil, nil); return }
                    if let name = current.name, name.hasPrefix("plot-"), let id = Int(name.dropFirst(5)) { select(nil, id, nil); return }
                    if let name = current.name, name.hasPrefix("property-"), let id = Int(name.dropFirst(9)) { select(nil, nil, id); return }
                    node = current.parent
                }
            }
        }
    }
}

@MainActor final class PausableCityView: SCNView {
    override func didMoveToWindow() {
        super.didMoveToWindow(); isPlaying = window != nil; scene?.isPaused = window == nil
    }
}
