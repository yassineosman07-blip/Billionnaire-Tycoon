import SceneKit
import UIKit

/// Kenney commercial models, original streets and decorative traffic. No economic simulation here.
@MainActor enum CitySceneBuilder {
    static let centers: [(Float, Float)] = [(-60,30),(0,30),(-60,-25),(0,-25),(60,0)]
    static func location(_ plot: Int) -> SCNVector3 {
        let center = centers[max(0, min(4, plot / 24))]; let n = plot % 24
        return SCNVector3(center.0 + Float(n % 6) * 8 - 20, 0, center.1 + Float(n / 6) * 10 - 15)
    }
    static func material(_ color: UIColor, shiny: Bool = false) -> SCNMaterial {
        let m = SCNMaterial(); m.lightingModel = .physicallyBased; m.diffuse.contents = color; m.roughness.contents = shiny ? 0.25 : 0.85; m.metalness.contents = shiny ? 0.15 : 0; return m
    }
    static let road = material(UIColor(red: 0.25, green: 0.29, blue: 0.30, alpha: 1))
    static let pavement = material(UIColor(red: 0.84, green: 0.84, blue: 0.79, alpha: 1))
    static let white = material(UIColor(red: 0.96, green: 0.95, blue: 0.89, alpha: 1))
    static let glass = material(UIColor(red: 0.35, green: 0.77, blue: 0.86, alpha: 1), shiny: true)
    static let dark = material(UIColor(red: 0.13, green: 0.19, blue: 0.21, alpha: 1))
    static let colors: [UIColor] = [.init(red: 0.94, green: 0.48, blue: 0.42, alpha: 1), .init(red: 0.93, green: 0.76, blue: 0.47, alpha: 1), .init(red: 0.46, green: 0.73, blue: 0.77, alpha: 1), .init(red: 0.77, green: 0.62, blue: 0.81, alpha: 1), .init(red: 0.90, green: 0.88, blue: 0.74, alpha: 1)]
    @discardableResult static func box(_ parent: SCNNode, _ width: CGFloat, _ height: CGFloat, _ length: CGFloat, _ at: SCNVector3, _ m: SCNMaterial, bevel: CGFloat = 0) -> SCNNode {
        let g = SCNBox(width: width, height: height, length: length, chamferRadius: bevel); g.materials = [m]
        let n = SCNNode(geometry: g); n.position = at; parent.addChildNode(n); return n
    }
    static func make(_ businesses: [Business], properties: [Property], reduced: Bool) throws -> SCNScene {
        let scene = SCNScene(); scene.background.contents = UIColor(red: 0.72, green: 0.87, blue: 0.93, alpha: 1)
        scene.fogColor = UIColor(red: 0.72, green: 0.87, blue: 0.93, alpha: 1); scene.fogStartDistance = 200; scene.fogEndDistance = 400
        box(scene.rootNode, 210, 0.6, 145, SCNVector3(0,-0.5,0), material(UIColor(red: 0.45, green: 0.66, blue: 0.46, alpha: 1)))
        let ambient = SCNNode(); ambient.light = SCNLight(); ambient.light?.type = .ambient; ambient.light?.intensity = 650; ambient.light?.color = UIColor(red: 0.83, green: 0.89, blue: 1, alpha: 1); scene.rootNode.addChildNode(ambient)
        let sun = SCNNode(); sun.light = SCNLight(); sun.light?.type = .directional; sun.light?.intensity = 1200; sun.eulerAngles = SCNVector3(-Float.pi / 3,-Float.pi / 4,0)
        sun.light?.castsShadow = !reduced; sun.light?.shadowMode = .deferred; sun.light?.shadowRadius = 3; sun.light?.shadowColor = UIColor.black.withAlphaComponent(0.18); sun.light?.shadowMapSize = CGSize(width: 1024, height: 1024); scene.rootNode.addChildNode(sun)
        for district in 0..<5 { streets(scene.rootNode, district: district) }
        for plot in 0..<120 {
            let point = location(plot); let owned = businesses.first { $0.plot == plot }
            let parcel = SCNNode(); parcel.position = point; parcel.name = owned.map { "branch-\($0.id)" } ?? "plot-\(plot)"
            box(parcel, 7.4, 0.18, 7, SCNVector3(0,0.02,0), pavement)
            if let owned { try building(parcel, type: owned.definitionID, level: owned.level, seed: plot) }
            else if plot % 4 != 0 {
                let district = plot / 24
                let type = district == 2 ? (plot % 3 == 0 ? 24 : 18) : district == 4 ? 20 : plot % 12 + 1
                try building(parcel, type: type, level: plot % 35 + 1, seed: plot)
            }
            else {
                box(parcel, 5.5, 0.08, 6.5, SCNVector3(0,0.16,0), material(UIColor(red: 0.54, green: 0.74, blue: 0.48, alpha: 1)))
                tree(parcel, at: SCNVector3(-1.5,0.2,0)); tree(parcel, at: SCNVector3(1.5,0.2,1))
            }
            if plot % 2 == 0 { tree(parcel, at: SCNVector3(-3,0.2,3)) }
            let flattened = parcel.flattenedClone(); flattened.name = parcel.name; scene.rootNode.addChildNode(flattened)
        }
        for z: Float in [10,-45,59] { box(scene.rootNode,170,0.08,3,SCNVector3(-5,0,z),road) }
        for definition in Catalog.properties {
            let parcel = SCNNode(); parcel.name = "property-\(definition.id)"; parcel.position = SCNVector3(-80 + Float(definition.id) * 10,0,65)
            box(parcel,7.4,0.18,7,SCNVector3(0,0.02,0),pavement)
            let owned = properties.first { $0.id == definition.id }
            try building(parcel,type:3,level:20 + (owned?.renovations ?? 0) * 15,seed:definition.id + 2)
            let clone = parcel.flattenedClone(); clone.name=parcel.name;scene.rootNode.addChildNode(clone)
        }
        if !reduced {
            for i in 0..<10 {
                let vehicle = car(i); let z: Float = i % 2 == 0 ? 10 : -45
                vehicle.position = SCNVector3(-85 + Float(i * 10),0.65,z)
                vehicle.runAction(.repeatForever(.sequence([.move(to: SCNVector3(28,0.65,z), duration: Double(22 + i)), .run { node in node.position.x = -85 }])))
                scene.rootNode.addChildNode(vehicle)
            }
        }
        try KenneyAssets.addPedestrians(to: scene.rootNode, reduced: reduced)
        let rig = SCNNode(); rig.name = "cameraRig"
        let camera = SCNNode(); camera.name = "camera"; camera.camera = SCNCamera(); camera.camera?.usesOrthographicProjection = true; camera.camera?.orthographicScale = 78
        camera.camera?.zNear = 0.1; camera.camera?.zFar = 600; camera.position = SCNVector3(90,110,125); camera.look(at: SCNVector3(0,0,0)); rig.addChildNode(camera); scene.rootNode.addChildNode(rig)
        return scene
    }
    private static func streets(_ root: SCNNode, district: Int) {
        let c = centers[district]
        let group = SCNNode(); group.position = SCNVector3(c.0,0,c.1)
        for z: Float in [-20,0,20] {
            box(group, 56, 0.08, 3, SCNVector3(0,0,z), road)
            for x in stride(from: -25, through: 25, by: 5) { box(group, 2.4, 0.015, 0.10, SCNVector3(Float(x),0.055,z), white) }
        }
        for x: Float in [-25,0,25] {
            box(group, 3, 0.09, 44, SCNVector3(x,0.005,0), road)
            for z in stride(from: -18, through: 18, by: 6) { box(group, 0.1, 0.015, 2.5, SCNVector3(x,0.065,Float(z)), white) }
            for z: Float in [-17,3] {
                for i in 0..<5 { box(group, 0.35, 0.02, 2.6, SCNVector3(x + Float(i) * 0.6 - 1.2,0.08,z), white) }
                lamp(group, at: SCNVector3(x + 2.4,0,z + 2))
            }
        }
        root.addChildNode(group.flattenedClone())
    }
    private static func building(_ parent: SCNNode, type: Int, level: Int, seed: Int) throws {
        if type == 0 { truck(parent); return }
        let name = KenneyAssets.buildingName(type: type, level: level, seed: seed)
        parent.addChildNode(try KenneyAssets.building(named: name))
    }
    private static func tree(_ parent: SCNNode, at point: SCNVector3) {
        let node = SCNNode(); node.position = point
        let trunk = SCNCylinder(radius: 0.12, height: 1.5); trunk.radialSegmentCount = 6; trunk.materials = [material(.brown)]
        let stem = SCNNode(geometry: trunk); stem.position.y = 0.75; node.addChildNode(stem)
        for i in 0..<2 {
            let cone = SCNCone(topRadius: 0, bottomRadius: CGFloat(0.9 - Double(i)*0.18), height: 1.8); cone.radialSegmentCount = 7
            cone.materials = [material(UIColor(red: 0.17+CGFloat(i)*0.05,green:0.5+CGFloat(i)*0.08,blue:0.33,alpha:1))]
            let leaves = SCNNode(geometry: cone); leaves.position.y = 1.7 + Float(i)*0.7; node.addChildNode(leaves)
        }
        parent.addChildNode(node)
    }
    private static func lamp(_ parent: SCNNode, at p: SCNVector3) {
        box(parent,0.08,3.5,0.08,SCNVector3(p.x,1.8,p.z),white)
        box(parent,0.8,0.08,0.08,SCNVector3(p.x+0.35,3.5,p.z),white)
        box(parent,0.4,0.07,0.3,SCNVector3(p.x+0.65,3.45,p.z),material(.systemYellow))
    }
    private static func truck(_ parent: SCNNode) {
        let body = material(UIColor(red:0.12,green:0.65,blue:0.85,alpha:1))
        box(parent,5,2.3,2.7,SCNVector3(0,1.6,0),body,bevel:0.12)
        box(parent,1.2,1.3,2.5,SCNVector3(-2,1.8,0),glass,bevel:0.1)
        box(parent,2.4,1,0.08,SCNVector3(0.6,1.9,1.4),dark)
        box(parent,3.2,0.12,1.3,SCNVector3(0.5,2.5,1.8),material(.systemRed))
        box(parent,2.8,0.12,0.6,SCNVector3(0.5,1.3,1.7),white)
        for x: Float in [-1.7,1.7] { for z: Float in [-1.4,1.4] {
            let g=SCNCylinder(radius:0.45,height:0.25);g.radialSegmentCount=10;g.materials=[dark];let n=SCNNode(geometry:g);n.eulerAngles.x=Float.pi/2;n.position=SCNVector3(x,0.6,z);parent.addChildNode(n)
        } }
    }
    private static func car(_ seed: Int) -> SCNNode {
        let car = SCNNode(); box(car,2.8,0.6,1.35,SCNVector3Zero,material(colors[seed%colors.count]),bevel:0.15)
        box(car,1.45,0.55,1.16,SCNVector3(0,0.5,0),glass,bevel:0.12)
        for x: Float in [-0.9,0.9] { for z: Float in [-0.7,0.7] { box(car,0.38,0.5,0.18,SCNVector3(x,-0.2,z),dark,bevel:0.08) } }
        return car.flattenedClone()
    }
}
