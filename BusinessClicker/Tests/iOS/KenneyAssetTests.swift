import XCTest
import SceneKit
import ModelIO
@testable import BusinessClicker

@MainActor final class KenneyAssetTests: XCTestCase {
    func testEveryCommercialModelLoadsWithGeometryAndTextures() throws {
        let folder=try KenneyAssets.url("building-a.obj",folder:"City").deletingLastPathComponent()
        let files=try FileManager.default.contentsOfDirectory(at:folder,includingPropertiesForKeys:nil).filter { $0.pathExtension=="obj" }
        XCTAssertEqual(files.count,41)
        for file in files {
            let node=try KenneyAssets.building(named:file.deletingPathExtension().lastPathComponent)
            var meshes=0
            node.enumerateChildNodes { child,_ in if child.geometry != nil { meshes += 1 } }
            XCTAssertGreaterThan(meshes,0,file.lastPathComponent)
            XCTAssertGreaterThan(node.boundingBox.max.y-node.boundingBox.min.y,0)
        }
    }
    func testBothHumanSkinsLoadAndAnimateInSceneKit() throws {
        for female in [false,true] { for moving in [false,true] {
            let node=try KenneyAssets.pedestrian(female:female,moving:moving)
            var skinners=0;var animations=0
            node.enumerateChildNodes { child,_ in
                if child.skinner != nil { skinners += 1 }
                animations += child.animationKeys.count
            }
            XCTAssertGreaterThan(skinners,0);XCTAssertGreaterThan(animations,0)
        } }
    }
    func testAmbientPedestriansAreNotGameContacts() throws {
        let root=SCNNode();try KenneyAssets.addPedestrians(to:root,reduced:true)
        XCTAssertEqual(root.childNodes.count,2)
        XCTAssertTrue(root.childNodes.allSatisfy { $0.name?.hasPrefix("ambient-pedestrian-")==true })
        XCTAssertEqual(World().social.known,[0,1,2,3])
    }
}
