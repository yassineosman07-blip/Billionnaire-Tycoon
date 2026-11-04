import SwiftUI

struct CityView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var selected = 0
    @State private var zoom = 1.0
    private var district: District { Catalog.districts[selected] }
    var body: some View {
        Screen {
            HStack { Text("Une ville. Votre empreinte.").foregroundStyle(.secondary); Spacer(); Image(systemName: "hand.draw").foregroundStyle(Palette.accent) }
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    Color(red: 0.12, green: 0.17, blue: 0.20)
                    Canvas { context, size in
                        for i in 0..<9 {
                            var a = Path(); a.move(to: CGPoint(x: 0, y: CGFloat(i) * 78)); a.addLine(to: CGPoint(x: 720, y: CGFloat(i) * 78 + 360))
                            context.stroke(a, with: .color(.white.opacity(0.055)), lineWidth: 12)
                            var b = Path(); b.move(to: CGPoint(x: 720, y: CGFloat(i) * 78)); b.addLine(to: CGPoint(x: 0, y: CGFloat(i) * 78 + 360))
                            context.stroke(b, with: .color(.white.opacity(0.055)), lineWidth: 12)
                        }
                    }
                    ForEach(Catalog.districts) { d in
                        districtTile(d).position(position(d.id))
                    }
                    VStack { Spacer(); HStack { Label("BUSINESS CITY", systemImage: "location.north.fill").font(.caption2.weight(.heavy)).tracking(2).foregroundStyle(.white.opacity(0.4)); Spacer() }.padding(24) }
                }.frame(width: 720, height: 580).scaleEffect(zoom, anchor: .topLeading).frame(width: 720 * zoom, height: 580 * zoom, alignment: .topLeading)
            }.frame(height: 350).clipShape(RoundedRectangle(cornerRadius: 24)).accessibilityLabel("Carte de la ville, défilement dans les deux directions")
            HStack { Image(systemName: "minus.magnifyingglass"); Slider(value: $zoom, in: 0.65...1.6); Image(systemName: "plus.magnifyingglass") }.foregroundStyle(Palette.accent).accessibilityLabel("Zoom de la carte")
            Panel(district.name) {
                HStack { Metric(label: "Popularité", value: "\(Int(district.popularity * 100)) / 100", symbol: "person.3.fill"); Metric(label: "Concurrence", value: "\(Int(district.competition * 100)) %", symbol: "chart.bar.fill") }
                LineItem(label: "Niveau de richesse", value: "\(Int(district.wealth * 100)) / 100"); LineItem(label: "Installation", value: game.value(district.installation))
                LineItem(label: "Loyer commercial de base", value: game.value(district.rent))
                let accessible = game.world.netWorth >= district.unlock
                Label(accessible ? "Quartier accessible" : "Découverte à \(game.value(district.unlock)) de fortune", systemImage: accessible ? "checkmark.circle" : "lock.fill").font(.caption).foregroundStyle(accessible ? Palette.mint : .secondary)
            }
            ForEach(Catalog.businesses.filter { $0.district == selected }) { d in NavigationLink { BusinessDetailView(id: d.id) } label: {
                HStack { IconBadge(symbol: d.symbol); VStack(alignment: .leading) { Text(d.name).font(.subheadline.bold()); Text(game.world.businesses.first(where: { $0.id == d.id }).map { "Votre entreprise · niveau \($0.level)" } ?? "À acquérir").font(.caption).foregroundStyle(.secondary) }; Spacer(); Image(systemName: "chevron.right") }.padding(12).background(Palette.surface, in: RoundedRectangle(cornerRadius: 18))
            }.buttonStyle(.plain) }
            ForEach(Catalog.properties.filter { $0.district == selected }) { p in NavigationLink { PropertyDetailView(id: p.id) } label: { HStack { Image(systemName: "house.fill").foregroundStyle(Palette.mint); Text(p.name); Spacer(); Image(systemName: "chevron.right") }.font(.subheadline).padding(16).background(Palette.surface, in: RoundedRectangle(cornerRadius: 18)) }.buttonStyle(.plain) }
        }.navigationTitle("La carte")
    }
    private func position(_ id: Int) -> CGPoint {
        let points = [CGPoint(x: 200, y: 370), CGPoint(x: 360, y: 440), CGPoint(x: 360, y: 250), CGPoint(x: 520, y: 330), CGPoint(x: 510, y: 145)]
        return points[id]
    }
    private func districtTile(_ d: District) -> some View {
        let owned = game.world.businesses.filter { Catalog.businesses[$0.id].district == d.id }
        let level = owned.map(\.level).max() ?? 0
        return Button { selected = d.id } label: {
            VStack(spacing: 3) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(d.id == selected ? Palette.accent.opacity(0.4) : Palette.lavender.opacity(0.06)).frame(width: 146, height: 78).rotationEffect(.degrees(-25))
                    HStack(alignment: .bottom, spacing: 5) {
                        ForEach(0..<3) { i in
                            VStack(spacing: 5) {
                                ForEach(0..<max(1, min(5, 1 + level / 20 + i))) { _ in HStack(spacing: 4) { Rectangle().fill(Palette.mint.opacity(owned.isEmpty ? 0.15 : 0.8)).frame(width: 5, height: 5); Rectangle().fill(Palette.mint.opacity(0.4)).frame(width: 5, height: 5) } }
                            }.padding(8).background(owned.isEmpty ? Palette.surface : Palette.accent.opacity(0.65), in: UnevenRoundedRectangle(topLeadingRadius: 4, topTrailingRadius: 4)).offset(y: -15)
                        }
                    }
                }
                Text(d.name).font(.caption.weight(.semibold)).foregroundStyle(.white)
                Text("\(owned.count) entreprise(s)").font(.caption2).foregroundStyle(Palette.mint)
            }.frame(width: 170)
        }.buttonStyle(.plain).accessibilityLabel("\(d.name), \(owned.count) entreprises possédées")
    }
}
