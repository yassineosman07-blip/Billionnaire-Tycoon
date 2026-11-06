import SwiftUI
import SceneKit

enum CitySelection: Identifiable {
    case business(Int), property(Int), plot(Int)
    var id: String { switch self { case .business(let id): return "b-\(id)"; case .property(let id): return "p-\(id)"; case .plot(let id): return "plot-\(id)" } }
}
struct CityView: View {
    @EnvironmentObject private var game: GameViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selection: CitySelection?
    @State private var listOpen = false
    @State private var journalOpen = false
    @State private var focusToken = 0
    var body: some View {
        ZStack(alignment: .top) {
            CityViewport(businesses: game.world.businesses, properties: game.world.properties,
                active: game.active, reduced: reduceMotion || game.world.settings.reducedMotion,
                notices: CityStatus.notices(game.world), focusToken: focusToken, openEvent: { game.openEvent($0) }) { branch, plot, property in
                    if let branch { selection = .business(branch) }
                    else if let property { selection = .property(property) }
                    else if let plot { selection = .plot(plot) }
                    game.feedback.play("click", settings: game.world.settings)
                }.accessibilityElement(children: .contain).accessibilityIdentifier("city-viewport")
                .accessibilityLabel("Ville 3D. Déplacez avec un doigt, pincez pour zoomer, touchez un bâtiment ou sa bulle.")
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("JOUR \(game.world.day)").font(.caption.bold()).tracking(2).accessibilityIdentifier("city-day")
                        Text(game.world.gameDate, format: .dateTime.day().month(.wide)).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(game.value(game.world.cash)).font(.system(.title2,design:.rounded,weight:.bold)).minimumScaleFactor(0.6).lineLimit(1)
                        Text("Prévu : \(game.value(game.forecast))").font(.caption).foregroundStyle(Palette.mint)
                    }
                }.padding(15).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                HStack {
                    NavigationLink { ActionsView() } label: { Label("\(Engine.actionsRemaining(game.world))/3 actions", systemImage: "sparkles").font(.caption.bold()) }
                    Spacer()
                    Button { journalOpen = true } label: { Label("Journal \(game.world.events.filter { !$0.resolved }.count)", systemImage: "envelope.badge").font(.caption.bold()) }.accessibilityIdentifier("city-journal")
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Button { focusToken += 1 } label: { Image(systemName: "scope").font(.title2).frame(width: 44,height: 44) }.accessibilityLabel("Recentrer sur Tasty Crousty")
                        Button { listOpen = true } label: { Image(systemName: "list.bullet").font(.title2).frame(width: 44,height: 44) }.accessibilityLabel("Liste des lieux")
                    }.buttonStyle(.plain).padding(8).background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius:18))
                }
            }.padding(.horizontal,14).padding(.top,8).padding(.bottom,10)
        }.background(Palette.background)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 6) {
                if let message = game.dayMessage { Text(message).font(.caption).foregroundStyle(Palette.mint).lineLimit(2).accessibilityIdentifier("day-result") }
                ActionButton(title: game.busy ? "Simulation…" : "Passer au lendemain", symbol: "sunrise.fill", accent: .orange) { Task { await game.advance() } }
                    .frame(maxWidth: 390).disabled(game.busy || game.activeEvent != nil).accessibilityIdentifier("advance-day")
                HStack { Text("Prochain service : jour \(game.world.day + 1)"); Spacer(); Button("Bilan") { game.showReport = true }.disabled(game.world.reports.isEmpty) }.font(.caption2)
            }.padding(.horizontal,18).padding(.top,10).padding(.bottom,8).background(.ultraThinMaterial)
        }
        .navigationTitle("Votre ville").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { NavigationLink { SettingsView() } label: { Image(systemName: "slider.horizontal.3") }.accessibilityLabel("Paramètres") } }
        .sheet(item: $selection) { value in
            NavigationStack {
                CityPlaceView(selection: value).toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fermer") { selection = nil } } }
            }.environmentObject(game).preferredColorScheme(.dark)
        }
        .sheet(isPresented: $listOpen) { NavigationStack { CityPlacesList().toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fermer") { listOpen = false } } } }.environmentObject(game).preferredColorScheme(.dark) }
        .sheet(isPresented: $journalOpen) { NavigationStack { CityJournalView().toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fermer") { journalOpen = false } } } }.environmentObject(game).preferredColorScheme(.dark) }
    }
}
struct CityPlaceView: View {
    @EnvironmentObject private var game: GameViewModel
    let selection: CitySelection
    @State private var type = 2
    var body: some View {
        switch selection {
        case .business(let id): BusinessDetailView(id:id)
        case .property(let id): PropertyDetailView(id:id)
        case .plot(let plot):
            Screen {
                Panel("Parcelle \(plot % 24 + 1)") {
                    Text(Catalog.districts[plot/24].name).font(.title2.bold())
                    Text("Choisissez l’activité de votre nouvelle adresse.").foregroundStyle(.secondary)
                    Picker("Activité",selection:$type) { ForEach(Catalog.businesses) { Text($0.name).tag($0.id) } }
                    NavigationLink { OpenBusinessView(type:type,suggestedDistrict:plot/24,suggestedPlot:plot) } label: { Label("Ouvrir un établissement",systemImage:"plus.circle.fill") }
                }
            }.navigationTitle("Une nouvelle adresse")
        }
    }
}
struct CityPlacesList: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View { Screen {
        ForEach(Catalog.districts) { d in Panel(d.name) {
            LineItem(label:"Popularité / concurrence",value:"\(Int(d.popularity*100)) / \(Int(d.competition*100))")
            ForEach(game.world.businesses.filter { $0.districtID == d.id }) { b in NavigationLink(b.name) { BusinessDetailView(id:b.id) } }
            ForEach(Catalog.properties.filter { $0.district == d.id }) { p in NavigationLink(p.name) { PropertyDetailView(id:p.id) } }
        } }
    }.navigationTitle("Lieux et quartiers") }
}
struct CityJournalView: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View { Screen {
        NavigationLink("Bilans quotidiens") { ReportView() }
        if game.world.events.isEmpty { ContentUnavailableView("La ville vous réserve des surprises",systemImage:"sparkles",description:Text("Chaque journée a une chance de déclencher un événement.")) }
        ForEach(game.world.events.reversed()) { event in NavigationLink { EventDetailView(id:event.id) } label: {
            Panel(event.title) { Text(event.result ?? event.text).font(.caption).foregroundStyle(.secondary);Label(event.resolved ? "Traité" : "Choix en attente",systemImage:event.resolved ? "checkmark.circle" : "envelope.badge").font(.caption) }
        }.buttonStyle(.plain) }
    }.navigationTitle("Journal de ville") }
}
struct CityViewport: UIViewRepresentable {
    let businesses: [Business]
    let properties: [Property]
    var active = true
    var reduced: Bool
    var notices: [CityNotice] = []
    var focusToken = 0
    var openEvent: (Int) -> Void = { _ in }
    var select: (Int?, Int?, Int?) -> Void
    func makeCoordinator() -> Coordinator { Coordinator(select: select) }
    func makeUIView(context: Context) -> SCNView {
        let view = PausableCityView(frame: .zero, options: nil); view.backgroundColor = .clear; view.antialiasingMode = .multisampling2X; view.preferredFramesPerSecond = 30
        view.isPlaying = true; view.autoenablesDefaultLighting = false; view.allowsCameraControl = false
        let pan=UIPanGestureRecognizer(target:context.coordinator,action:#selector(Coordinator.pan(_:)))
        let pinch=UIPinchGestureRecognizer(target:context.coordinator,action:#selector(Coordinator.pinch(_:)))
        let tap=UITapGestureRecognizer(target:context.coordinator,action:#selector(Coordinator.tap(_:)))
        let gestures: [UIGestureRecognizer] = [pan,pinch,tap]
        for gesture in gestures { gesture.delegate=context.coordinator;view.addGestureRecognizer(gesture) }
        return view
    }
    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.select = select
        context.coordinator.openEvent = openEvent
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
            if oldRig == nil { context.coordinator.recenter(view) }
        }
        context.coordinator.updateNotices(notices, view: view)
        if context.coordinator.focusToken != focusToken { context.coordinator.focusToken = focusToken; context.coordinator.recenter(view) }
    }
    static func dismantleUIView(_ uiView: SCNView, coordinator: Coordinator) { coordinator.displayLink?.invalidate(); coordinator.displayLink=nil; uiView.isPlaying = false; uiView.scene = nil }
    @MainActor final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var select: (Int?, Int?, Int?) -> Void
        var signature = ""
        var focusToken = 0
        var openEvent: (Int) -> Void = { _ in }
        weak var view: SCNView?
        var displayLink: CADisplayLink?
        var notices: [CityNotice] = []
        var bubbles: [String:UIButton] = [:]
        var districtLabels: [UILabel] = []
        init(select: @escaping (Int?, Int?, Int?) -> Void) { self.select = select }
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            var target=touch.view
            while let current=target { if current is UIControl { return false };target=current.superview }
            return true
        }
        func recenter(_ view: SCNView) {
            let origin = CitySceneBuilder.location(0)
            view.scene?.rootNode.childNode(withName:"cameraRig",recursively:false)?.position = SCNVector3(origin.x,0,origin.z)
            view.pointOfView?.camera?.orthographicScale = 31
        }
        func updateNotices(_ items: [CityNotice], view: SCNView) {
            self.view=view;notices=Array(items.prefix(12))
            let ids=Set(notices.map(\.id))
            for key in Array(bubbles.keys) where !ids.contains(key) { bubbles.removeValue(forKey:key)?.removeFromSuperview() }
            for item in notices {
                let button=bubbles[item.id] ?? UIButton(type:.system)
                button.accessibilityIdentifier=item.id;button.accessibilityLabel=item.title
                button.setTitle(" \(item.title) ",for:.normal);button.setImage(UIImage(systemName:item.symbol),for:.normal)
                button.tintColor = .white;button.setTitleColor(.white,for:.normal)
                button.titleLabel?.font=UIFont.preferredFont(forTextStyle:.caption1);button.titleLabel?.adjustsFontForContentSizeCategory=true
                button.backgroundColor = item.priority == 0 ? UIColor.systemOrange.withAlphaComponent(0.95) : UIColor.systemIndigo.withAlphaComponent(0.94)
                button.layer.cornerRadius=15;button.layer.borderColor=UIColor.white.withAlphaComponent(0.65).cgColor;button.layer.borderWidth=1
                button.sizeToFit();button.frame.size.width=max(105,button.frame.width+18);button.frame.size.height=44
                if bubbles[item.id]==nil { button.addTarget(self,action:#selector(bubbleTapped(_:)),for:.touchUpInside);view.addSubview(button);bubbles[item.id]=button }
            }
            if districtLabels.isEmpty {
                for d in Catalog.districts {
                    let label=UILabel();label.text=d.name.uppercased();label.font=UIFont.systemFont(ofSize:11,weight:.bold);label.textColor = .white
                    label.textAlignment = .center;label.backgroundColor=UIColor.black.withAlphaComponent(0.5);label.layer.cornerRadius=9;label.clipsToBounds=true
                    label.sizeToFit();label.frame.size.width += 18;label.frame.size.height=27;view.addSubview(label);districtLabels.append(label)
                }
            }
            if displayLink==nil { let link=CADisplayLink(target:self,selector:#selector(projectNotices));link.preferredFramesPerSecond=30;link.add(to:.main,forMode:.common);displayLink=link }
            projectNotices()
        }
        @objc func projectNotices() {
            guard let view,view.window != nil,let scene=view.scene,!scene.isPaused else { return }
            var occupied: [CGRect] = []
            for item in notices {
                guard let button=bubbles[item.id] else { continue }
                let name: String
                switch item.target { case .business(let id): name="branch-\(id)";case .property(let id):name="property-\(id)";case .event: name="branch-0" }
                guard let node=view.scene?.rootNode.childNode(withName:name,recursively:false) else { button.isHidden=true;continue }
                let height=node.boundingBox.max.y
                let location=node.convertPosition(SCNVector3(0,height+2,0),to:nil);let point=view.projectPoint(location)
                button.center=CGPoint(x:CGFloat(point.x),y:CGFloat(point.y)-10)
                let box=button.frame.insetBy(dx:-5,dy:-6)
                let obscured = point.z < 0 || point.z > 1 || !view.bounds.insetBy(dx:8,dy:90).contains(button.center) || occupied.contains { $0.intersects(box) }
                button.isHidden=obscured;if !obscured { occupied.append(box) }
            }
            for (id,label) in districtLabels.enumerated() {
                let center=CitySceneBuilder.centers[id];let point=view.projectPoint(SCNVector3(center.0,0.5,center.1-21))
                label.center=CGPoint(x:CGFloat(point.x),y:CGFloat(point.y))
                label.isHidden = (view.pointOfView?.camera?.orthographicScale ?? 0)<45 || point.z<0 || point.z>1 || !view.bounds.insetBy(dx:15,dy:100).contains(label.center)
            }
        }
        @objc func bubbleTapped(_ sender: UIButton) {
            guard let item=notices.first(where: { $0.id == sender.accessibilityIdentifier }) else { return }
            switch item.target {case .business(let id):select(id,nil,nil);case .property(let id):select(nil,nil,id);case .event(let id):openEvent(id)}
        }
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
