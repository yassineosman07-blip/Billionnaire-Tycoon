import XCTest
import SceneKit
import ModelIO
import UIKit
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
    func testLiveCityRendersMovementAndPedestrianRouteTurns() async throws {
        let scene=try CitySceneBuilder.make(World().businesses,properties:[],reduced:false)
        let car=try XCTUnwrap(scene.rootNode.childNode(withName:"ambient-car-0",recursively:false))
        let pedestrian=try XCTUnwrap(scene.rootNode.childNode(withName:"ambient-pedestrian-0",recursively:false))
        let moving=scene.rootNode.childNodes.filter { $0.action(forKey:"ambient-route") != nil }
        moving.forEach { $0.isPaused=true }
        let host=try XCTUnwrap(UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first)
        let previous=host.windows.first { $0.isKeyWindow }
        let window=UIWindow(windowScene:host);window.frame=host.coordinateSpace.bounds
        let view=PausableCityView(frame:window.bounds,options:nil)
        view.ambientAnimationEnabled=true;view.preferredFramesPerSecond=30;view.scene=scene
        view.pointOfView=scene.rootNode.childNode(withName:"camera",recursively:true)
        scene.rootNode.childNode(withName:"cameraRig",recursively:false)?.position=SCNVector3(-70,0,30)
        view.pointOfView?.camera?.orthographicScale=45
        let firstFrame=expectation(description:"Premier rendu natif de la ville")
        let turn=expectation(description:"Demi-tour natif du passant")
        let probe=CityFrameProbe(first:firstFrame,turn:turn,pedestrian:pedestrian)
        view.delegate=probe
        let controller=UIViewController();controller.view=view;window.rootViewController=controller
        window.makeKeyAndVisible()
        defer { view.delegate=nil;view.isPlaying=false;scene.isPaused=true;window.isHidden=true;window.rootViewController=nil;previous?.makeKeyAndVisible() }
        await fulfillment(of:[firstFrame],timeout:30)
        let initialCar=car.presentation.position
        var bones:[SCNNode]=[]
        pedestrian.enumerateChildNodes { node,_ in if bones.isEmpty,let skin=node.skinner { bones=skin.bones } }
        XCTAssertFalse(bones.isEmpty)
        let poses=bones.map { $0.presentation.transform }
        // Accelerate only this test's routes so a real native turn runs within seconds.
        moving.forEach { $0.action(forKey:"ambient-route")?.speed=16;$0.isPaused=false }
        await fulfillment(of:[turn],timeout:15)
        XCTAssertGreaterThan(abs(car.presentation.position.x-initialCar.x),1)
        XCTAssertGreaterThan(pedestrian.presentation.worldFront.z,0.8)
        XCTAssertTrue(zip(bones,poses).contains { !SCNMatrix4EqualToMatrix4($0.0.presentation.transform,$0.1) },"Le squelette doit bouger, indépendamment de la translation du passant.")
        withExtendedLifetime(probe) {}
    }
}

private final class CityFrameProbe: NSObject,SCNSceneRendererDelegate {
    private let first:XCTestExpectation
    private let turn:XCTestExpectation
    private let pedestrian:SCNNode
    private let lock=NSLock()
    private var firstSent=false
    private var turnSent=false
    init(first:XCTestExpectation,turn:XCTestExpectation,pedestrian:SCNNode) { self.first=first;self.turn=turn;self.pedestrian=pedestrian }
    func renderer(_ renderer:SCNSceneRenderer,didRenderScene scene:SCNScene,atTime time:TimeInterval) {
        let turned=pedestrian.presentation.worldFront.z>0.8
        lock.lock()
        let sendFirst = !firstSent;firstSent=true
        let sendTurn = turned && !turnSent;if sendTurn { turnSent=true }
        lock.unlock()
        if sendFirst { first.fulfill() }
        if sendTurn { turn.fulfill() }
    }
}
