# Guide de réalisation et de build pour Codex

Ce guide accompagne le [cahier des charges 1.5](CAHIER_DES_CHARGES.md). Il décrit le travail à réaliser et les preuves attendues. Sa rédaction ne signifie pas que les nouvelles fonctionnalités sont implémentées ou que le build iOS est validé.

## 1. Établir l’état réel du projet

- Lire les éventuels `AGENTS.md`, le cahier des charges, le README, les tests et les scripts avant modification.
- Lire [l’état de réalisation](ETAT_REALISATION.md) et [les résultats de validation](VALIDATION.md). Le commit `57c9a66` fournit déjà la ville principale, les bulles et les événements quotidiens ; conserver ces fonctions et partir des lacunes constatées.
- Utiliser le checkout existant. Une tâche cloud est déjà isolée : ne pas créer de worktree sauf demande explicite.
- Vérifier `git status`, conserver les changements de l’utilisateur et identifier ce qui est déjà implémenté, incomplet ou seulement décrit.
- Examiner les versions de Xcode et Swift, la cible iOS, les ressources et les migrations. Le projet actuel cible iOS 17+, utilise Swift 6 pour le package et le mode de langage Swift 5 pour l’application.
- Le projet Xcode est `BusinessClicker.xcodeproj`, son schéma partagé est `BusinessClicker`. Le moteur portable est défini dans `Package.swift`.
- Vérifier les outils réellement disponibles. Une machine Linux ne possède pas le SDK iOS : Docker et Swift sous Linux ne remplacent pas Xcode.

## 2. Ordre de réalisation

| Étape | Résultat concret attendu | Validation avant de poursuivre |
|---|---|---|
| A. Données et sauvegarde | Modèles des nouveaux systèmes, migrations sans perte et séparation simulation/rendu | Tests des anciennes sauvegardes, des identifiants et de la précision financière |
| B. Ville centrale | Scène urbaine détaillée, quartiers et lieux sélectionnables, caméra, bulles et bouton de journée en bas au centre | Exécution de la navigation et première revue visuelle sur simulateur ou appareil |
| C. Vie économique visible | Segments de clients, capacités, équipements visibles, avis et réputation locale | Tests de demande, stocks, délais, coûts et effets des améliorations |
| D. Vie de quartier | Tirage quotidien, pop-up de choix, événements locaux, météo, saisons et rivaux | Déterminisme, sauvegarde des choix, délais, effets bornés et absence de doublons |
| E. Intérieurs et relations | Commerces, logement et garage visitables, rencontres dans la ville, boutiques et médias | Parcours d’acquisition, inventaire, budget d’actions et vérification des ressources |
| F. Accessibilité et empire | Tutoriel, objectif choisi, gestion groupée et délégation | Départ avec 100 €, plans groupés finançables, VoiceOver et grandes tailles de texte |
| G. Livraison | Application compilée, tests exécutés, scènes examinées et résultats consignés | Rapport distinguant vérifié, échoué, non exécuté et bloqué |

Toutes les fonctionnalités du cahier des charges restent dans la cible. Ne pas remplacer une étape par une grille d’écrans de démonstration, un fond de ville ou une commande sans effet réel.

## 3. Contraintes de conception et de ressources

Les revenus, stocks, avis, événements, prévisions et actions appartiennent au moteur. Les modèles 3D, véhicules et passants ne calculent pas une deuxième économie. Une décision, une récompense ou une commande possède une identité et des effets enregistrés une seule fois.

Conserver les caractéristiques économiques de base des quartiers. Les saisons, manifestations et promotions concurrentes appliquent des modificateurs séparés et bornés. Les activités sociales partagent trois actions quotidiennes ; les préparatifs économiques restent hors de ce budget.

Créer ou intégrer des modèles, textures, portraits, photos et sons avec provenance documentée. Les photographies doivent correspondre aux articles et permettre la distribution hors ligne. Consulter `media/PHOTOGRAPHS.md` et le manifeste avant de qualifier les médias de complets. Un emplacement manquant ou une image générée ne valide pas une exigence de photographie réelle.

Le choix du moteur 3D doit être compatible avec le SDK retenu et permettre la qualité visuelle attendue. Si un changement technologique est nécessaire, documenter la raison et préserver les systèmes de jeu plutôt que réduire silencieusement la ville.

## 4. Vérifications portables sous Linux ou sur Mac

Depuis la racine du dépôt, utiliser le Swift installé :

```sh
swift --version
swift test --jobs 4
```

Dans l’environnement cloud sans Swift natif, utiliser le script existant et le démon Docker géré :

```sh
./scripts/test-core.sh
```

Respecter les instructions de l’environnement pour l’accès au socket, au proxy et aux certificats. Ne pas désactiver TLS ni modifier les checksums d’une image ou d’un artefact pour contourner un échec.

Vérifier également les ressources :

```sh
python3 scripts/validate-assets.py
python3 scripts/validate-assets.py --require-photos
```

Le second contrôle doit réussir pour annoncer les photographies terminées. Un échec dû à des photos manquantes reste un blocage média, même si les tests économiques passent.

Avec un Swift natif disponible, vérifier la structure du projet :

```sh
swift scripts/validate-project.swift
```

Une analyse avec `swiftc -frontend -parse` peut détecter les erreurs de syntaxe, mais ne vérifie pas les types SwiftUI, SceneKit, SwiftData ou UIKit. Elle ne vaut pas compilation iOS.

## 5. Préparer Xcode sur Mac

Utiliser Xcode 16 ou ultérieur avec un SDK et un simulateur iPhone compatibles iOS 17+. Vérifier :

```sh
xcodebuild -version
xcrun swift --version
xcodebuild -list -project BusinessClicker.xcodeproj
xcodebuild -showdestinations -project BusinessClicker.xcodeproj -scheme BusinessClicker
xcrun simctl list devices available
```

Si `xcodebuild` désigne uniquement les Command Line Tools, sélectionner l’installation complète de Xcode dans les réglages Locations de Xcode. Installer un runtime iOS depuis Xcode s’il n’existe aucun simulateur approprié.

Le projet est livré dans Git : ne pas le régénérer systématiquement. Si des sources ou ressources ont été ajoutées, examiner `scripts/generate_project.py` et les personnalisations du `.pbxproj` avant d’exécuter :

```sh
python3 scripts/generate_project.py
git diff -- BusinessClicker.xcodeproj
python3 scripts/validate-assets.py
```

Le générateur remplace le projet et le schéma. Préserver notamment les réglages de signature, configurations et ajouts manuels existants. Aucun secret ne doit être ajouté aux sources.

## 6. Compiler puis tester sur simulateur

Ouvrir un terminal à la racine du dépôt. Le bloc suivant choisit un simulateur iPhone déjà installé et conserve les logs et résultats dans un nouveau dossier temporaire :

```sh
set -euo pipefail

BUSINESS_CLICKER_SIMULATOR_ID="$(xcrun simctl list devices available --json | python3 -c '
import json, sys
runtimes = json.load(sys.stdin)["devices"]
phones = [device for runtime, devices in runtimes.items() if "iOS" in runtime
          for device in devices if device["name"].startswith("iPhone") and device.get("isAvailable", True)]
if not phones:
    sys.exit("Aucun simulateur iPhone disponible : installer un runtime iOS dans Xcode.")
print(phones[0]["udid"])
')"
BUSINESS_CLICKER_RESULTS_DIR="$(mktemp -d "${TMPDIR:-/tmp}/business-clicker-validation.XXXXXX")"

xcodebuild build \
  -project BusinessClicker.xcodeproj \
  -scheme BusinessClicker \
  -destination "platform=iOS Simulator,id=$BUSINESS_CLICKER_SIMULATOR_ID" \
  -derivedDataPath DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  2>&1 | tee "$BUSINESS_CLICKER_RESULTS_DIR/build.log"

xcodebuild test \
  -project BusinessClicker.xcodeproj \
  -scheme BusinessClicker \
  -destination "platform=iOS Simulator,id=$BUSINESS_CLICKER_SIMULATOR_ID" \
  -derivedDataPath DerivedData \
  -parallel-testing-enabled NO \
  -resultBundlePath "$BUSINESS_CLICKER_RESULTS_DIR/Tests.xcresult" \
  CODE_SIGNING_ALLOWED=NO \
  2>&1 | tee "$BUSINESS_CLICKER_RESULTS_DIR/tests.log"

printf 'Résultats : %s\n' "$BUSINESS_CLICKER_RESULTS_DIR"
```

`pipefail` conserve l’échec de `xcodebuild` même avec `tee`. Le même DerivedData permet de réutiliser les sorties valides entre compilation et tests. Pour cibler un appareil particulier, remplacer la sélection automatique par son UDID issu de `simctl`.

Examiner les logs et ouvrir le `.xcresult` dans Xcode. Vérifier quels tests ont réellement été exécutés, les échecs et les tests ignorés ; un résultat sans tests ne valide pas le jeu. Corriger les erreurs de compilation ou de test et relancer les contrôles affectés. Ne pas désactiver un test ou une assertion pour obtenir artificiellement un résultat vert.

## 7. Exécuter et examiner l’application

Dans Xcode, sélectionner le schéma BusinessClicker et le même iPhone, puis **⌘R**. Utiliser **⌘U** pour lancer les tests depuis l’interface. Sur un iPhone physique, sélectionner une équipe de signature dans Signing & Capabilities ; `CODE_SIGNING_ALLOWED=NO` est destiné au simulateur et ne prépare pas une distribution signée.

Parcours de revue minimum :

1. Nouvelle partie avec 100 €, quatre contacts et apprentissage réalisable.
2. Ville principale, quartier lisible, caméra, commerce sélectionné et bouton de journée en bas au centre.
3. Deux cafés indépendants, équipement visible, préparation des stocks, service et avis expliqués.
4. Bulle de stock ou de chantier, résolution et mise à jour sans gain dupliqué.
5. Événement quotidien, choix, interruption puis réouverture de la même décision.
6. Événement local, prévision météo, effets datés et situation redevenue normale à la fin.
7. Sortie ou rendez-vous localisé utilisant le budget des trois actions.
8. Boutique, article photographié, achat confirmé et objet visible dans la collection ou l’intérieur approprié.
9. Plan de commandes groupées avec prix total, refus d’un plan non finançable et délégation vérifiable.
10. Fermeture, réouverture, simulation d’absence, sauvegarde et reprise des événements en attente.

Effectuer une comparaison visuelle avec la référence de ville : diversité des bâtiments, densité et composition des quartiers, façades, routes, circulation, bulles et lisibilité. Conserver des captures et une courte vidéo de navigation. La scène exécutée, et non une image fabriquée à part, doit démontrer le résultat.

Avec Instruments ou les outils Xcode, mesurer la fluidité et la mémoire avec un empire développé, puis en mode réduit. Vérifier VoiceOver, les grandes tailles de texte, le contraste, le mode silencieux, les sons et haptiques, et l’arrêt des animations en arrière-plan. Le simulateur ne remplace pas la vérification tactile et de performance sur iPhone.

## 8. CI et rapport de livraison

Le dépôt contient `.github/workflows/validate.yml`, avec tests du moteur sous Linux et `xcodebuild test` sur macOS. Un workflow écrit n’est pas un workflow exécuté. Ne déclarer un passage CI réussi qu’après lecture de son résultat et des suites réellement exécutées.

À la livraison, indiquer : fonctionnalités réalisées, migrations, commande et résultat du build, tests passés/échoués/ignorés, simulateur ou appareil utilisé, ressources encore manquantes, performances mesurées et captures de la ville. Sous Linux, mentionner explicitement les contrôles Apple non exécutés. Ne pas annoncer une publication App Store ou d’environnement à partir d’un commit ou d’un build local.

## Instruction prête à donner à Codex

> Lis `docs/CAHIER_DES_CHARGES.md` version 1.5 et `docs/CODEX_BUILD.md`. Examine l’application existante et conserve la progression ainsi que les changements de l’utilisateur. Réalise tous les systèmes décrits, en commençant par la ville principale détaillée dans l’esprit de la référence, ses quartiers, commerces, bulles et bouton de journée en bas au centre. Implémente les systèmes dans le moteur et la sauvegarde, puis leurs représentations et parcours réels. N’utilise pas d’écrans factices pour représenter une fonction absente. Travaille jusqu’à obtenir les fonctionnalités attendues et les validations disponibles ; corrige les erreurs détectées. Sur Mac, compile avec Xcode, exécute les tests et examine la ville sur simulateur puis sur appareil lorsque disponible. Sous Linux, exécute les contrôles portables sans présenter la syntaxe Swift comme une compilation iOS. Fournis les preuves de build, de tests et de rendu, ainsi qu’une liste précise des blocages réels et ressources manquantes. Ne publie pas automatiquement l’application ou l’environnement.

## Ressources Kenney approuvées

La version 1.5 du cahier des charges ajoute les deux packs fournis par le créateur. Consulter `AssetsSource/Kenney/README.md` et exécuter `python3 scripts/validate-kenney.py`. Les OBJ/MTL/textures et les Collada humains convertis sont livrés dans `BusinessClicker/Resources/Kenney`, copié en dossier dans l’application pour préserver les chemins relatifs. Blender et Assimp servent uniquement à régénérer ces ressources, pas à compiler ou exécuter l’application.

Les modèles rétro sont réservés aux passants décoratifs. Aucun zombie embarqué, aucun changement des portraits ni des contacts. Les tests `KenneyAssetTests` vérifient le chargement ModelIO/SceneKit, les squelettes, les animations et le rôle décoratif. La CI sépare maintenant compilation, tests unitaires natifs et parcours UI, puis conserve le `.app` de simulateur compilé dans un ZIP avec les logs et résultats. Cette application non signée pour simulateur n’est ni un IPA pour iPhone physique ni une publication App Store.
