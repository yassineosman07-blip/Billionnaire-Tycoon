import SwiftUI
import UIKit

struct CutCornerShape: Shape {
    var cut: CGFloat = 10
    func path(in r: CGRect) -> Path {
        let c = min(cut, r.width / 4, r.height / 4)
        return Path { p in
            p.move(to: CGPoint(x: c, y: 0)); p.addLine(to: CGPoint(x: r.width-c, y: 0)); p.addLine(to: CGPoint(x: r.width, y: c))
            p.addLine(to: CGPoint(x: r.width, y: r.height-c)); p.addLine(to: CGPoint(x: r.width-c, y: r.height)); p.addLine(to: CGPoint(x: c, y: r.height))
            p.addLine(to: CGPoint(x: 0, y: r.height-c)); p.addLine(to: CGPoint(x: 0, y: c)); p.closeSubpath()
        }
    }
}
struct ArcadeButtonStyle: ButtonStyle {
    var accent: Color = .cyan
    @Environment(\.isEnabled) private var enabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @EnvironmentObject private var game: GameViewModel
    func makeBody(configuration: Configuration) -> some View {
        let color: Color = configuration.role == .destructive ? .red : accent
        return configuration.label
            .font(.system(.subheadline, design: .rounded, weight: .bold))
            .foregroundStyle(enabled ? .white : .gray).padding(.horizontal, 15).padding(.vertical, 13).frame(minWidth: 44, minHeight: 44)
            .background { CutCornerShape().fill(LinearGradient(colors: [color.opacity(configuration.isPressed ? 0.35 : 0.24), Palette.background], startPoint: .top, endPoint: .bottom)) }
            .overlay { CutCornerShape().stroke(color.opacity(enabled ? 0.95 : 0.2), lineWidth: 1.5) }
            .overlay { CutCornerShape(cut: 8).stroke(.white.opacity(configuration.isPressed ? 0.04 : 0.18), lineWidth: 1).padding(4) }
            .shadow(color: color.opacity(enabled && !configuration.isPressed ? 0.25 : 0), radius: 6, y: 2)
            .offset(y: configuration.isPressed && !reduceMotion && !game.world.settings.reducedMotion ? 2 : 0)
            .onChange(of: configuration.isPressed) { _, pressed in if pressed && enabled { game.feedback.play("click", settings: game.world.settings) } }
    }
}
@MainActor enum PortraitCache {
    static let atlas = UIImage(named: "Portraits")?.cgImage
    static var cells: [Int: UIImage] = [:]
    static func image(_ id: Int) -> UIImage? {
        let index = max(0, min(35, id))
        if let image = cells[index] { return image }
        guard let atlas else { return nil }
        let width = CGFloat(atlas.width) / 6, height = CGFloat(atlas.height) / 6
        let rect = CGRect(x: CGFloat(index % 6) * width + 1, y: CGFloat(index / 6) * height + 1, width: width - 2, height: height - 2).integral
        guard let crop = atlas.cropping(to: rect) else { return nil }
        let image = UIImage(cgImage: crop); cells[index] = image; return image
    }
}
struct Portrait: View {
    var person: Int
    var size: CGFloat = 64
    var body: some View {
        Group {
            if let image = PortraitCache.image(person) { Image(uiImage: image).resizable().scaledToFill() }
            else { Rectangle().fill(Palette.surface).overlay(Text("Portrait indisponible").font(.caption2)) }
        }.frame(width: size, height: size).clipShape(RoundedRectangle(cornerRadius: size * 0.22))
            .overlay { RoundedRectangle(cornerRadius: size * 0.22).stroke(Palette.accent.opacity(0.6), lineWidth: 1) }
            .accessibilityHidden(true)
    }
}
struct CharacterAccess: ViewModifier {
    @EnvironmentObject private var game: GameViewModel
    func body(content: Content) -> some View {
        content.toolbar { ToolbarItem(placement: .topBarLeading) {
            NavigationLink { CharacterView() } label: { Portrait(person: game.portraitID, size: 34) }.accessibilityLabel("Mon personnage")
        } }
    }
}
