import SwiftUI

struct IntroductionView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var page = 0
    @State private var name = "Alex"
    @State private var avatar = "person.crop.circle.fill"
    private let titles = ["Tout quitter.\nPour commencer.", "Un rêve sur\nquatre roues.", "Les jours\nplus difficiles.", "La suite\nvous appartient."]
    private let copy = ["Vous avez quitté votre emploi pour construire quelque chose à vous.", "Toutes vos économies sont passées dans Tasty Crousty. Votre premier food truck. Votre pari sur l’avenir.", "Les factures s’accumulent, les clients se font rares. Votre femme est partie. Mais votre histoire ne s’arrête pas ici.", "100 € en poche. Un petit logement. Un food truck déjà payé. Et une nouvelle journée pour tout changer."]
    private let icons = ["sunrise.fill", "takeoutbag.and.cup.and.straw.fill", "cloud.rain.fill", "sparkles"]
    var body: some View {
        Screen {
            HStack { Text("BUSINESS CLICKER").font(.caption.weight(.heavy)).tracking(3); Spacer(); Text("0\(page + 1) / 04").font(.caption.monospacedDigit()).foregroundStyle(.secondary) }.padding(.top, 20)
            Image(systemName: icons[page]).font(.system(size: 90, weight: .ultraLight)).foregroundStyle(Palette.accent).frame(maxWidth: .infinity).frame(height: 170)
            Text(titles[page]).font(.system(size: 40, weight: .bold, design: .rounded)).fixedSize(horizontal: false, vertical: true)
            Text(copy[page]).font(.title3).foregroundStyle(.secondary).lineSpacing(6)
            if page == 3 {
                Panel("Votre nouveau départ") {
                    TextField("Prénom", text: $name).textFieldStyle(.roundedBorder).textContentType(.givenName)
                    HStack { ForEach(["person.crop.circle.fill", "person.crop.square.fill", "person.circle.fill"], id: \.self) { icon in Button { avatar = icon } label: { Portrait(person: icon == "person.crop.square.fill" ? 20 : icon == "person.circle.fill" ? 24 : 33, size: 64).padding(4).overlay { if avatar == icon { RoundedRectangle(cornerRadius: 18).stroke(Palette.mint, lineWidth: 2) } } }.accessibilityLabel("Portrait \(icon)") } }
                }
            }
            HStack(spacing: 6) { ForEach(0..<4) { i in Capsule().fill(i == page ? Palette.accent : Palette.surface).frame(width: i == page ? 30 : 8, height: 6) } }.padding(.vertical)
            ActionButton(title: page == 3 ? "Ouvrir Tasty Crousty" : "Continuer") {
                if page < 3 { withAnimation { page += 1 } } else { game.finishIntro(name: name, avatar: avatar) }
            }
            Text("Hors connexion · Sans publicité · Sans achats intégrés").font(.caption2).foregroundStyle(.secondary).frame(maxWidth: .infinity)
        }
    }
}
