# Business Clicker — refonte 1.2

Jeu iPhone natif en français, iOS 17+, SwiftUI / MVVM, SceneKit, SpriteKit, SwiftData, Swift Charts et AVFoundation. Aucun compte, serveur, publicité ou achat intégré. Les règles de la cible figurent dans le [cahier des charges 1.2](docs/CAHIER_DES_CHARGES.md).

**État de livraison :** les fonctionnalités ci-dessous sont implémentées et le moteur est testé sous Linux. La compilation et le rendu iOS doivent encore être vérifiés dans Xcode sur Mac. **Les 32 photographies commerciales restent à intégrer** ; les emplacements manquants affichent explicitement « Photographie indisponible ». Voir [la validation](docs/VALIDATION.md) et [les ressources photographiques manquantes](docs/media/PHOTOGRAPHS.md).

## Ouvrir le projet

Sur Mac avec Xcode 16 ou ultérieur, ouvrir **BusinessClicker.xcodeproj**, choisir le schéma partagé **BusinessClicker** et un simulateur iPhone iOS 17+. Lancer avec **⌘R**, tester avec **⌘U**. Pour un appareil physique, sélectionner votre équipe dans Signing & Capabilities ; aucune équipe n’est imposée dans le dépôt.

```sh
xcodebuild test -project BusinessClicker.xcodeproj -scheme BusinessClicker \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO
```

Adapter le simulateur à ceux listés par `xcrun simctl list devices available`. Les tests UI utilisent une sauvegarde Debug distincte de la partie normale.

## Ce qui change dans cette version

- **Établissements multiples.** Quarante types d’activités, plusieurs instances du même type et consolidation par enseigne. Chaque adresse a son nom, son quartier, sa parcelle, son niveau, son équipe, son manager, son tarif, ses horaires et sa réserve. Les cafés voisins se partagent une partie de la demande. Les synergies ne se multiplient pas par le nombre de copies.
- **Ville 3D SceneKit.** Cinq quartiers, 120 parcelles économiques et 16 emplacements immobiliers. Façades pastel, vitrines, auvents, food truck, routes, passages piétons, trottoirs, arbres, lampadaires, ombres et voitures décoratives. Glisser pour déplacer la caméra, pincer pour zoomer et toucher une adresse pour ouvrir sa fiche. Les parcelles occupées ne peuvent pas être achetées deux fois. La géométrie est originale et procédurale ; le rendu exact demande une revue sur iPhone.
- **Boutiques.** Dix catégories, deux enseignes par catégorie et 32 articles, avec des assortiments différenciés. Entrée dans un intérieur 3D, vitrines ou présentations sélectionnables, fiche article, prix, confirmation, puis collection. Les pièces uniques ne peuvent pas être rachetées dans une autre enseigne ; plusieurs véhicules ou logements personnels peuvent être possédés avec des identifiants distincts. Le statut d’un même modèle n’est pas crédité plusieurs fois.
- **Personnage.** Icône de portrait en haut à gauche des cinq écrans principaux, fiche statistique, finances, réputation, patrimoine, contacts, situation familiale et compteur d’actions. Les 36 portraits sont des illustrations originales de style 3D cartoon, conservées dans un atlas local.
- **Entourage initial.** Pour les nouvelles parties : mère, père, frère et ex-femme uniquement. Les autres contacts arrivent après des rencontres, jamais automatiquement à une date de déblocage. Les parties migrées conservent leurs anciennes identités et leurs contacts effectivement accessibles ou déjà référencés.
- **Actions.** Vie → Actions ou raccourci depuis Personnage. Un site de rencontre fictif hors ligne et une sortie au bar partagent trois actions par journée simulée. Une tentative sans événement consomme aussi son point. Les interactions directes utilisent la même réserve ; les rendez-vous réservent un point à leur date. Aucun cumul des points inutilisés et aucune sortie exécutée automatiquement pendant l’absence.
- **Événements probabilistes.** Une nouvelle connaissance, une conversation, un investisseur potentiel, une trouvaille de 100 €, une opportunité ou rien. Les résultats sont sauvegardés avec l’action ; redémarrer ne relance pas le tirage et ne recrédite pas le gain. Rencontrer Sofia ne verse aucun financement : une proposition ultérieure et son acceptation restent nécessaires. Les catégories sans résultat éligible deviennent une tentative sans événement.
- **Boutons et sensations.** Cadres biseautés à coins coupés, double bordure lumineuse, états pressé/désactivé, couleurs d’action et zones tactiles de 44 points minimum. Variations de clics, sons d’achat, succès, entrée et refus, haptiques distincts, dix ambiances de boutiques et volumes indépendants. Le mode silencieux est respecté. Les effets sonores et visuels sont désactivables.

## Première partie

L’introduction conserve le départ de Tasty Crousty : 100 €, food truck déjà payé, logement narratif et stocks de départ. Le clic sur les billets termine une journée ; il ne distribue pas directement d’argent.

Dans **Empire → Tasty Crousty**, régler le menu, les prix et les horaires, puis commander les quatre ingrédients auprès des trois fournisseurs. Une commande du Marché local passée au jour 1 arrive au début du service du jour 2. Les autres établissements utilisent chacun leur réserve de fournitures, commandable dans leur propre fiche. Un manager commande automatiquement lorsque les stocks deviennent insuffisants et que les fonds le permettent.

Dans Empire, **Ouvrir une nouvelle adresse** reste disponible pour une activité déjà possédée. Le parcours affiche acquisition, installation, fonds de roulement, parcelle et solde restant avant confirmation. L’ouverture fait apparaître le bâtiment correspondant dans la ville.

Les propriétés locatives conservent les loyers réglables, la vacance, les charges, cinq rénovations différées et la revente avec bilan complet et frais de 5 %. Elles sont distinctes des logements personnels vendus en boutique.

## Temps, finances et sauvegarde

Une journée correspond à 30 minutes réelles. La simulation hors ligne utilise le même moteur avec un rendement de 50 % sur ventes et loyers, sans réduire les charges ni les stocks consommés. Le passage manuel règle le temps réel écoulé puis recale l’horodatage pour éviter les doublons. Une horloge reculée ne crée pas de revenu.

Les comptes utilisent `Decimal`, avec arrondi au centime pour les flux. Les fournitures sont payées à la commande puis rattachées au bilan sans deuxième débit. Les dépenses d’investissement sont distinctes de la variation pendant la simulation. L’historique financier garde 730 journées et les compteurs de carrière restent conservés. Les comptes sont bornés à 10³⁰ € ; `Magnitude` fournit séparément une notation mantisse/exposant. Une avance de secours de 40 € par journée sous 20 € de trésorerie devient une dette remboursable depuis Finances.

Le payload de sauvegarde passe en version 2 ; le modèle physique SwiftData reste compatible. Le décodeur migre les anciennes instances vers des parcelles distinctes, garde les identités antérieures des contacts, les relations et les montants exacts, sans conversion des finances via `Double`. Une action est appliquée à une copie, enregistrée, puis publiée à l’interface. Une copie précédente sert à la récupération ; une erreur ne réinitialise pas la partie sans confirmation.

## Développement et validation

```sh
# Swift 6 installé :
swift test --jobs 4
# Ou conteneur Swift officiel épinglé, dans cet environnement Linux :
./scripts/test-core.sh
python3 scripts/validate-assets.py
# Contrôle strict des photographies, actuellement bloqué par les ressources manquantes :
python3 scripts/validate-assets.py --require-photos
```

L’accès au démon Docker géré peut demander l’escalade du bac à sable de l’outil d’exécution. Le moteur ne dépend d’aucun framework graphique Apple. Les scènes 3D sont dans `Services/City/`, les règles révisées dans `Core/Social.swift` et `Core/Shops.swift`, les écrans dans `Views/` et les composants dans `Components/ArcadeUI.swift`.

Le projet Xcode est livré et peut être régénéré avec `python3 scripts/generate_project.py`. Cette commande remplace le projet et le schéma ; préserver toute personnalisation avant usage. La configuration CI prévoit Swift sous Linux et `xcodebuild test` sur macOS. Les tâches cloud utilisent le checkout existant, sans worktree supplémentaire.

La revue iPhone doit couvrir la compilation avec les frameworks Apple, le rendu et les performances de SceneKit, les grandes tailles de texte, VoiceOver, la synchronisation sonore, les notifications, les haptiques et la réouverture réelle. Les tests du moteur ne certifient pas ces points. Les prix du jeu et le rythme de progression restent à équilibrer par des sessions de jeu.

## Modèles Kenney fournis le 5 novembre 2026

Les bâtiments commerciaux utilisent désormais les OBJ/MTL/textures de **Kenney City Kit Commercial 2.1**. Les passants utilisent uniquement les apparences humaines du pack **Animated Characters Retro**, converties avec leur rig et leurs animations en Collada. Ils n’ajoutent aucun contact ni revenu ; les portraits des personnages importants restent inchangés. Aucun zombie n’est embarqué.

Les fichiers sont livrés dans `BusinessClicker/Resources/Kenney`, conservé comme dossier de ressources pour respecter les chemins relatifs. Les archives CC0 et la provenance figurent dans `AssetsSource/Kenney`. Contrôle local : `python3 scripts/validate-kenney.py`. La conversion requiert Blender et Assimp uniquement pour régénérer les modèles ; l’application ne dépend pas de ces outils.

Le cahier des charges est passé à la version 1.5. Les évolutions décrites comme cibles dans les dernières révisions ne doivent pas toutes être considérées comme déjà implémentées par cette intégration de ressources. Voir `docs/VALIDATION.md` pour les vérifications effectivement exécutées et le build Apple encore bloqué par l’autorisation d’envoi GitHub.
