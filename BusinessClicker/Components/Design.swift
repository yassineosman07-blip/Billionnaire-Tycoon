import SwiftUI
import SpriteKit

enum Palette {
    static let background = Color(red: 23/255, green: 19/255, blue: 38/255)
    static let surface = Color(red: 34/255, green: 29/255, blue: 53/255)
    static let accent = Color(red: 149/255, green: 104/255, blue: 234/255)
    static let lavender = Color(red: 237/255, green: 229/255, blue: 255/255)
    static let mint = Color(red: 0.57, green: 0.9, blue: 0.72)
}
struct Panel<Content: View>: View {
    var title: String?
    @ViewBuilder var content: Content
    init(_ title: String? = nil, @ViewBuilder content: () -> Content) { self.title = title; self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let title { Text(title).font(.headline).foregroundStyle(Palette.lavender) }
            content
        }.frame(maxWidth: .infinity, alignment: .leading).padding(20).background(Palette.surface, in: RoundedRectangle(cornerRadius: 24))
    }
}
struct Screen<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View { ScrollView { LazyVStack(alignment: .leading, spacing: 20) { content }.padding(20).padding(.bottom, 20) }.background(Palette.background) }
}
struct Metric: View {
    var label: String; var value: String; var symbol: String = "chart.line.uptrend.xyaxis"
    var body: some View { VStack(alignment: .leading, spacing: 10) { Label(label, systemImage: symbol).font(.caption).foregroundStyle(.secondary); Text(value).font(.system(.title3, design: .rounded, weight: .semibold)).minimumScaleFactor(0.5).lineLimit(1) }.frame(maxWidth: .infinity, alignment: .leading) }
}
struct ActionButton: View {
    var title: String; var symbol: String = "arrow.right"; var action: () -> Void
    var body: some View { Button(action: action) { Label(title, systemImage: symbol).font(.subheadline.weight(.semibold)).frame(maxWidth: .infinity).padding(14) }.buttonStyle(.plain).background(Palette.accent, in: RoundedRectangle(cornerRadius: 15)).foregroundStyle(.white) }
}
struct IconBadge: View {
    var symbol: String; var color: Color = Palette.accent
    var body: some View { Image(systemName: symbol).font(.title2).frame(width: 52, height: 52).background(color.opacity(0.16), in: RoundedRectangle(cornerRadius: 16)).foregroundStyle(color) }
}
struct LineItem: View {
    var label: String; var value: String
    var body: some View { HStack(alignment: .firstTextBaseline) { Text(label).foregroundStyle(.secondary); Spacer(); Text(value).multilineTextAlignment(.trailing).fontWeight(.medium) }.font(.subheadline) }
}
final class CelebrationScene: SKScene {
    override func didMove(to view: SKView) { backgroundColor = .clear }
    func burst() {
        guard children.count < 80 else { return }
        for i in 0..<35 {
            let node = SKShapeNode(rectOf: CGSize(width: 4, height: 8), cornerRadius: 1)
            node.fillColor = i.isMultiple(of: 2) ? .systemPurple : .systemMint; node.strokeColor = .clear
            node.position = CGPoint(x: size.width / 2, y: size.height / 2); addChild(node)
            let angle = Double(i) * .pi * 2 / 35
            let move = SKAction.moveBy(x: cos(angle) * 110, y: sin(angle) * 90, duration: 0.8)
            node.run(.sequence([.group([move, .fadeOut(withDuration: 0.8), .rotate(byAngle: 3, duration: 0.8)]), .removeFromParent()]))
        }
    }
}
struct MoneyStack: View {
    var token: Int; var reduced: Bool; var action: () -> Void
    @State private var scene: CelebrationScene = { let s = CelebrationScene(size: CGSize(width: 300, height: 200)); s.scaleMode = .resizeFill; return s }()
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(Palette.accent.opacity(0.12)).frame(width: 180, height: 180)
                ForEach(0..<4) { i in
                    RoundedRectangle(cornerRadius: 10).fill(i == 3 ? Palette.mint : Palette.mint.opacity(0.3 + Double(i) * 0.12))
                        .frame(width: 126, height: 65).overlay { if i == 3 { Image(systemName: "eurosign.circle").font(.system(size: 36, weight: .medium)).foregroundStyle(Palette.background.opacity(0.8)) } }
                        .rotationEffect(.degrees(-15)).offset(x: Double(i) * 3 - 5, y: Double(3 - i) * 11)
                }
                SpriteView(scene: scene, options: [.allowsTransparency]).frame(height: 200).allowsHitTesting(false).accessibilityHidden(true)
            }.frame(maxWidth: .infinity).frame(height: 200)
        }.buttonStyle(.plain).accessibilityLabel("Terminer la journée et simuler les activités")
            .onChange(of: token) { _, _ in if !reduced { scene.burst() } }
    }
}
