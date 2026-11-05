import Foundation
import SceneKit
import ModelIO
import UIKit

/// Runtime resources supplied by the creator, under Kenney's CC0 license.
@MainActor enum KenneyAssets {
    enum AssetError: LocalizedError {
        case missing(String), invalid(String)
        var errorDescription: String? {
            switch self {
            case .missing(let path): return "Ressource de ville manquante : \(path)"
            case .invalid(let path): return "Modèle de ville invalide : \(path)"
            }
        }
    }
    private static var buildings: [String: SCNNode] = [:]
    static func url(_ filename: String, folder: String) throws -> URL {
        guard let url = Bundle.main.resourceURL?.appendingPathComponent("Kenney/\(folder)/\(filename)"), FileManager.default.fileExists(atPath: url.path) else { throw AssetError.missing("\(folder)/\(filename)") }
        return url
    }
    static func buildingName(type: Int, level: Int, seed: Int) -> String {
        if ["Technologie", "Finance", "Cloud", "Télécom", "IA"].contains(Catalog.businesses[type].sector) {
            return "building-skyscraper-\(["a","b","c","d","e"][seed % 5])"
        }
        // Cafés remain small commercial buildings at every level.
        let letter = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n"][seed % 14]
        return (level < 15 && type > 5 ? "low-detail-building-" : "building-") + letter
    }
    static func building(named name: String) throws -> SCNNode {
        if let template = buildings[name] { return template.clone() }
        let asset = MDLAsset(url: try url(name + ".obj", folder: "City")); asset.loadTextures()
        guard asset.count > 0 else { throw AssetError.invalid(name) }
        let scene = SCNScene(mdlAsset: asset)
        let content = SCNNode()
        for child in scene.rootNode.childNodes { content.addChildNode(child) }
        let b = content.boundingBox
        let width = b.max.x - b.min.x, depth = b.max.z - b.min.z
        guard width.isFinite, depth.isFinite, max(width, depth) > 0.001 else { throw AssetError.invalid(name) }
        content.position = SCNVector3(-(b.max.x+b.min.x)/2, -b.min.y, -(b.max.z+b.min.z)/2)
        let container = SCNNode(); container.addChildNode(content)
        let scale = min(4.2 / max(width,0.01), 5.2 / max(depth,0.01)); container.scale = SCNVector3(scale,scale,scale)
        container.position.y = 0.13
        content.enumerateChildNodes { node, _ in
            for material in node.geometry?.materials ?? [] {
                material.lightingModel = .physicallyBased; material.roughness.contents = 0.82
                material.diffuse.magnificationFilter = .nearest; material.diffuse.minificationFilter = .linear
            }
        }
        buildings[name] = container
        return container.clone()
    }
    /// Each pedestrian loads an independent skeleton. Skinned-node clones can share bone references.
    static func pedestrian(female: Bool, moving: Bool) throws -> SCNNode {
        let name = "\(female ? "female" : "male")-\(moving ? "run" : "idle").dae"
        let scene = try SCNScene(url: url(name, folder: "Pedestrians"), options: [.animationImportPolicy: SCNSceneSource.AnimationImportPolicy.playRepeatedly])
        let content = SCNNode()
        for child in scene.rootNode.childNodes { content.addChildNode(child) }
        let b = content.boundingBox; let height = b.max.y - b.min.y
        guard height.isFinite, height > 0.001 else { throw AssetError.invalid(name) }
        content.position = SCNVector3(-(b.max.x+b.min.x)/2,-b.min.y,-(b.max.z+b.min.z)/2)
        let container = SCNNode(); container.addChildNode(content)
        let scale = Float(1.65) / height; container.scale = SCNVector3(scale,scale,scale)
        content.enumerateChildNodes { node, _ in
            for key in node.animationKeys {
                if let player = node.animationPlayer(forKey: key) { player.animation.repeatCount = .greatestFiniteMagnitude; player.speed = moving ? 0.65 : 1; player.play() }
            }
            for material in node.geometry?.materials ?? [] {
                material.isDoubleSided = true; material.diffuse.magnificationFilter = .nearest
            }
        }
        return container
    }
    static func addPedestrians(to root: SCNNode, reduced: Bool) throws {
        // Sidewalk routes beside horizontal roads, with no building or road crossings.
        for index in 0..<(reduced ? 2 : 8) {
            let carrier = SCNNode(); carrier.name = "ambient-pedestrian-\(index)"
            let figure = try pedestrian(female: index % 2 == 1, moving: !reduced)
            carrier.addChildNode(figure)
            let district = index / 2; let c = CitySceneBuilder.centers[district]
            let z = c.1 + 17.95
            let startX: Float = index % 2 == 0 ? -20 : 4
            let endX: Float = index % 2 == 0 ? -4 : 20
            let start = SCNVector3(c.0 + startX,0.16,z), end = SCNVector3(c.0 + endX,0.16,z)
            carrier.position = index % 2 == 0 ? start : end
            figure.eulerAngles.y = index % 2 == 0 ? -.pi/2 : .pi/2
            if !reduced {
                let duration = Double(36 + index * 2)
                carrier.runAction(.repeatForever(.sequence([
                    .move(to: index % 2 == 0 ? end : start, duration: duration),
                    .run { _ in figure.eulerAngles.y += .pi },
                    .move(to: index % 2 == 0 ? start : end, duration: duration),
                    .run { _ in figure.eulerAngles.y += .pi }
                ])))
            }
            root.addChildNode(carrier)
        }
    }
}
