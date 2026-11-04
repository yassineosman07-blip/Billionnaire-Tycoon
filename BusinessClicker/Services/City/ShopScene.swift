import SceneKit
import UIKit

@MainActor enum ShopSceneBuilder {
    static func make(_ shop: Shop) -> SCNScene {
        let scene = SCNScene(); let root = scene.rootNode
        let premium = shop.theme % 2 == 1
        let hues: [UIColor] = [.systemCyan,.systemOrange,.systemPink,.systemBlue,.systemPurple,.systemTeal,.systemYellow,.systemBrown,.systemMint,.systemIndigo]
        let accent = hues[shop.category]
        let wall = CitySceneBuilder.material(premium ? UIColor(white:0.09,alpha:1) : UIColor(red:0.88,green:0.86,blue:0.81,alpha:1))
        let floor = CitySceneBuilder.material(premium ? UIColor(white:0.17,alpha:1) : UIColor(white:0.73,alpha:1),shiny: true)
        let metal = CitySceneBuilder.material(premium ? .init(red:0.70,green:0.52,blue:0.26,alpha:1) : .init(white:0.92,alpha:1),shiny:true)
        let glass = CitySceneBuilder.material(accent.withAlphaComponent(0.28),shiny:true)
        func box(_ w: CGFloat,_ h: CGFloat,_ d: CGFloat,_ x: Float,_ y: Float,_ z: Float,_ m: SCNMaterial) { CitySceneBuilder.box(root,w,h,d,SCNVector3(x,y,z),m,bevel:0.03) }
        box(18,0.15,14,0,-0.1,0,floor); box(18,7,0.2,0,3.4,-5,wall)
        box(0.2,7,14,-9,3.4,0,wall);box(0.2,7,14,9,3.4,0,wall)
        if premium {
            for i in 0..<12 { box(0.06,6,0.2,Float(i)*1.5-8,3,-4.8,metal) }
        } else {
            for i in 0..<12 { box(18,0.01,0.04,0,0.01,Float(i)-5,metal) }
        }
        let text=SCNText(string:shop.name,extrusionDepth:0.015);text.font=UIFont.systemFont(ofSize:0.7,weight:.semibold);text.flatness=0.2;text.materials=[metal]
        let sign=SCNNode(geometry:text);sign.position=SCNVector3(-6,5.25,-4.7);root.addChildNode(sign)
        for (index,item) in shop.offers.enumerated() {
            let display = SCNNode(); display.name="item-\(item)"; display.position=SCNVector3(Float(index)*6-Float(shop.offers.count-1)*3,0,0)
            CitySceneBuilder.box(display,4.6,0.3,4.2,SCNVector3(0,0.15,0),metal,bevel:0.12)
            switch shop.category {
            case 0,1:
                CitySceneBuilder.box(display,3.5,0.8,1.7,SCNVector3(0,0.95,0),CitySceneBuilder.material(accent),bevel:0.2)
                CitySceneBuilder.box(display,1.8,0.65,1.5,SCNVector3(0,1.62,0),glass,bevel:0.18)
                for x:Float in [-1.2,1.2] { for z:Float in [-0.85,0.85] { CitySceneBuilder.box(display,0.5,0.6,0.2,SCNVector3(x,0.7,z),CitySceneBuilder.dark,bevel:0.1) } }
            case 2,3,7:
                CitySceneBuilder.box(display,2.3,1.1,1.6,SCNVector3(0,0.85,0),wall)
                CitySceneBuilder.box(display,2.3,1,1.6,SCNVector3(0,1.9,0),glass)
                let ring=SCNTorus(ringRadius:0.35,pipeRadius:0.05);ring.materials=[metal]
                let object=SCNNode(geometry:ring);object.position=SCNVector3(0,1.65,0);object.eulerAngles.x=Float.pi/2;display.addChildNode(object)
            case 4:
                CitySceneBuilder.box(display,2.5,0.08,0.08,SCNVector3(0,3,0),metal)
                for x:Float in [-1,1] { CitySceneBuilder.box(display,0.08,2.7,0.08,SCNVector3(x,1.6,0),metal) }
                for i in 0..<4 { CitySceneBuilder.box(display,0.45,1.3,0.45,SCNVector3(Float(i)*0.55-0.8,2,0),CitySceneBuilder.material(CitySceneBuilder.colors[(shop.theme+i)%5]),bevel:0.06) }
            case 6:
                CitySceneBuilder.box(display,3,0.15,0.15,SCNVector3(0,0.45,0),metal)
                CitySceneBuilder.box(display,2.5,3,0.2,SCNVector3(0,2.4,0),metal)
                CitySceneBuilder.box(display,2.2,2.7,0.05,SCNVector3(0,2.4,0.15),CitySceneBuilder.material(accent))
            default:
                CitySceneBuilder.box(display,2.5,1,2.5,SCNVector3(0,0.8,0),wall)
                CitySceneBuilder.box(display,1.8,1,1.8,SCNVector3(0,1.8,0),CitySceneBuilder.material(accent),bevel:0.12)
            }
            root.addChildNode(display)
        }
        if shop.category==8 { box(18,0.02,4,0,0.03,5,CitySceneBuilder.material(.systemTeal,shiny:true)) }
        if shop.category==9 { for x:Float in [-5,5] { box(0.06,0.01,10,x,0.02,0,metal) } }
        let light=SCNNode();light.light=SCNLight();light.light?.type = .ambient;light.light?.intensity=500;root.addChildNode(light)
        for x:Float in [-5,0,5] {
            box(3,0.1,0.5,x,6,-1,CitySceneBuilder.material(accent))
            let spot=SCNNode();spot.position=SCNVector3(x,6,2);spot.light=SCNLight();spot.light?.type = .omni;spot.light?.intensity=premium ? 550 : 900;spot.light?.attenuationEndDistance=20;spot.light?.color=premium ? UIColor(red:1,green:0.83,blue:0.62,alpha:1) : UIColor.white;root.addChildNode(spot)
        }
        let camera=SCNNode();camera.name="shopCamera";camera.camera=SCNCamera();camera.camera?.fieldOfView=58;camera.position=SCNVector3(premium ? 1.3 : -1.3,4.2,11.5);camera.look(at:SCNVector3(0,2,0));root.addChildNode(camera)
        scene.background.contents=premium ? UIColor.black : UIColor(white:0.75,alpha:1)
        return scene
    }
}
