# Business Clicker

Jeu iPhone hors connexion, en français, basé sur le [cahier des charges](docs/CAHIER_DES_CHARGES.md). Projet natif **iOS 17+**, **Swift / SwiftUI**, architecture **MVVM**, **SwiftData**, **SpriteKit**, **Charts**, **AVFoundation** et retours haptiques UIKit. Aucun service distant, compte, publicité, achat intégré ou dépendance applicative externe.

## Ouvrir et jouer

1. Sur Mac, ouvrir **`BusinessClicker.xcodeproj`** avec Xcode 16 ou ultérieur.
2. Choisir le schéma partagé **BusinessClicker**, puis un simulateur iPhone sous iOS 17 ou ultérieur.
3. Lancer avec **⌘R**. Sur un iPhone physique, sélectionner votre équipe dans *Signing & Capabilities* ; aucun identifiant d’équipe n’est imposé dans le dépôt.
4. Exécuter **⌘U** pour les tests du moteur, de SwiftData et le parcours UI.

L’interface iOS et SwiftData n’ont pas pu être compilés ou exécutés sur la machine Linux utilisée pour cette livraison. Leur syntaxe et les références du projet ont été vérifiées ; la validation Apple reste à effectuer. Voir [les vérifications et leurs limites](docs/VALIDATION.md).

## Première partie

Après quatre écrans d’introduction, personnalisez votre prénom et votre portrait. Vous possédez Tasty Crousty, un petit logement narratif, des stocks de départ et **100 €**, sans dette d’acquisition.

- **Accueil** : la pile de billets et « Passer au lendemain » terminent le service. Le clic simule l’économie ; il ne distribue pas directement d’argent. L’estimation du prochain bénéfice utilise une copie du moteur, hors du thread principal.
- **Empire → Tasty Crousty** : choisissez les plats actifs, leurs prix et les horaires. Commandez des ingrédients avant la rupture. Le Marché local livre le lendemain : une commande passée au jour 1 est disponible au début du service du jour 2.
- Le menu comprend deux recettes utilisant quatre ingrédients, trois fournisseurs et leurs contraintes de prix, qualité, minimum, délai et fiabilité. Une commande est payée immédiatement et comptabilisée une seule fois dans le prochain bilan.
- Recrutez des employés, formez-les et engagez un manager. Le manager du food truck commande les stocks manquants s’il dispose des fonds nécessaires ; les autres managers améliorent la productivité. Les prix et horaires restent sous contrôle du joueur.
- Une avance de secours de 40 €, une fois par journée sous 20 € de trésorerie, permet de financer le redémarrage. Cette somme devient une dette remboursable dans Finances.
- **Carte** : déplacez la carte dans les deux axes, réglez son zoom et sélectionnez un des cinq quartiers. Les entreprises possédées et leur niveau modifient les bâtiments. Les fiches permettent les acquisitions et la gestion.
- **Patrimoine** : achetez des biens, fixez leurs loyers et suivez l’occupation. Les rénovations coûtent de l’argent et plusieurs jours ; les avantages sont appliqués une fois les travaux terminés. La revente conserve un bilan complet et prélève 5 % de frais.
- **Vie** : développez la confiance et l’affinité de vos contacts, répondez aux messages et préparez des rendez-vous. Les liens peuvent évoluer vers un couple, un mariage puis une famille ; les étapes sont conditionnées et génèrent des charges.
- **Objectifs** : récupérez les récompenses permanentes. Une mission quotidienne verse automatiquement 10 € pour 15 clients servis.

## Contenu et règles

- **40 entreprises**, niveau 1 à 100, dans 17 secteurs ; équipements et productivité progressent exponentiellement. Synergies de secteurs automatiques, recherche permanente et trois expansions internationales prolongent la progression. Aucun prestige.
- **16 propriétés**, huit types, cinq niveaux de rénovation, location, vacance, entretien et revente.
- **36 personnages** avec rôles, traits, préférences, humeur, confiance et affinité ; rencontres débloquées progressivement.
- **12 objets personnels** dans onze catégories, dont logements, véhicules, art, bijoux, yachts et jets. Leur statut ouvre certains événements, sans acheter l’affection.
- **24 événements écrits** avec conditions de richesse, réputation, collection, entreprises ou immobilier. Délais de réapparition de 45 jours et financement unique. Les conséquences proposées sont explicites avant le choix.
- Sons, courte ambiance musicale en boucle, icône et illustrations géométriques créés localement ; les pictogrammes utilisent les SF Symbols du système. Pas de ressources téléchargées ni de marques commerciales réelles.

**Temps** : une journée toutes les 30 minutes réelles. Le moteur rattrape l’intervalle réel avant une avance manuelle, puis recale son horodatage pour éviter les doublons. Les fractions d’intervalle sont conservées en mode automatique. Un recul de l’horloge ne produit pas de journées supplémentaires.

**Absence** : même pipeline de simulation, par lots de 365 jours exécutés en arrière-plan. Le rendement des ventes et loyers est de 50 % ; les charges et stocks consommés restent entiers. Les livraisons, travaux et rendez-vous sont traités aux dates prévues. Le taux est configurable dans `World.offlineYield`.

**Comptabilité** : montants ordinaires en `Decimal`, flux arrondis au centime. Les achats de stocks sont enregistrés au paiement puis rattachés au bilan du service sans seconde déduction. Les investissements et préparatifs sont distincts de la variation de trésorerie pendant la simulation. Les impayés deviennent des dettes. Fenêtre financière de 730 journées, compteurs de carrière conservés. Pour protéger les opérations, les comptes sont bornés à 10³⁰ € et le calendrier à dix millions de jours. `Magnitude` fournit séparément une représentation mantisse/exposant ; les comptes ne sont donc pas présentés comme arbitrairement infinis.

**Sauvegarde** : un état `World` Codable validé dans un modèle SwiftData versionné, plus la copie précédente. Chaque action est appliquée à une copie, enregistrée, puis publiée à l’interface : une erreur de sauvegarde n’affiche pas un état non enregistré. Un chargement invalide n’écrase pas les données ; l’écran propose une récupération ou un recommencement avec confirmation. La première version du schéma est enregistrée ; toute évolution nécessitera une migration explicite du schéma et/ou du payload.

## Architecture et tests

```text
BusinessClicker/
  App/            Point d’entrée et cycle de vie iOS
  Core/           Modèles Codable, catalogue, événements, moteur, validation
  Models/         Modèle et stockage SwiftData versionnés
  ViewModels/     État observable, commandes, transactions et simulation asynchrone
  Views/          Accueil, Empire, Carte, Vie, Patrimoine et écrans secondaires
  Components/     Palette, cartes, composants et scène SpriteKit
  Services/       Audio, haptiques et notifications facultatives
  Resources/      Icône, couleurs, sons, musique et manifeste de confidentialité
  Tests/          Tests portables et tests SwiftData spécifiques iOS
  UITests/        Parcours iPhone de première partie et réouverture
```

Le moteur ne dépend d’aucun framework Apple d’interface. Avec Swift 6 installé :

```sh
swift test --jobs 4
```

Ou, dans cet environnement Linux avec le démon Docker géré :

```sh
./scripts/test-core.sh
python3 scripts/validate-assets.py
```

Le script utilise une image Swift officielle épinglée par digest. L’accès au socket Docker peut nécessiter l’escalade du bac à sable de l’outil d’exécution. Il n’installe pas Xcode. Le projet ne nécessite aucun secret. Les tâches cloud utilisent le checkout existant ; aucun worktree supplémentaire n’est nécessaire.

Le projet Xcode est livré et reproductible : `python3 scripts/generate_project.py`. Cette commande réécrit le projet et le schéma ; conservez d’abord toute personnalisation Xcode. Le pipeline `.github/workflows/validate.yml` prévoit les tests Swift sous Linux et `xcodebuild test` sur macOS. Il n’a pas été exécuté à distance pendant cette mission.

## Validation sur Mac

Après sélection d’un simulateur installé :

```sh
xcodebuild test \
  -project BusinessClicker.xcodeproj \
  -scheme BusinessClicker \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -parallel-testing-enabled NO \
  CODE_SIGNING_ALLOWED=NO
```

Adaptez le nom à `xcrun simctl list devices available`. Vérifiez également le rendu avec les grandes tailles de texte, la permission de notifications, les haptiques, le mode silencieux et une réouverture après 30 minutes. Ces contrôles matériels et d’interface ne sont pas remplacés par les tests du moteur.

Les valeurs économiques, la profondeur narrative et le rythme de fin de jeu demandent une phase de jeu sur appareil. La carte est une représentation stylisée de ville et les portraits sont des pictogrammes ; les variations familiales restent narratives et ne constituent pas une simulation individuelle de chaque enfant.
