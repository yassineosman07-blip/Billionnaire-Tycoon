# Vérification de la refonte 1.2 — 4 novembre 2026

## Résultats exécutés sur Linux

| Contrôle | Résultat |
|---|---|
| Compilation du moteur, Swift 6.0.3 officiel | Réussie |
| XCTest portables | **51 tests exécutés, zéro échec** |
| Syntaxe des fichiers Swift iOS, scènes et tests | Vérifiée avec `swiftc -frontend -parse` |
| Projet Xcode OpenStep, références et schéma partagé | Vérifiés |
| Atlas de portraits | PNG 1254 × 1254, grille 6 × 6, intégré aux ressources |
| Sons et ambiances | 19 WAV locaux valides |
| Icône, couleurs et manifeste de confidentialité | Valides |
| Photographies des articles | **0/32 intégrées : vérification de livraison médias bloquée** |

Les commandes utilisées sont `./scripts/test-core.sh`, `python3 scripts/validate-assets.py` et un passage syntaxique de l’ensemble des sources avec le compilateur Swift officiel. Le conteneur est épinglé à `swift:6.0.3-jammy@sha256:95f6ef898992dc840b35517e780f6f6db9661432775ab0b33cc0a531ea749bdb`. Le message séparé de Swift Testing indiquant zéro test concerne le framework non utilisé ; les 51 tests XCTest ont effectivement terminé.

## Couverture économique et temporelle

Les trente tests précédents restent présents et sont adaptés aux règles modifiées : ventes, recettes, stocks, fournisseurs, qualité, commandes datées, paiement unique, prix, déterminisme, trois heures d’absence, rendement de 50 % avec charges complètes, absence de revenus dupliqués, fractions de journée, recul de l’horloge, absence de 800 jours, synergies, niveau 100, managers, salaires, formations, rénovations différées, vacance, loyers, revente, relations, rendez-vous, famille, événements, récompenses, secours et dettes, corruption, grands nombres et 40 entreprises avec 16 chantiers sur 400 jours.

Un parcours de trente journées utilise uniquement les 100 € et stocks initiaux, commande ses fournitures et acquiert une deuxième entreprise sans dette. Il ne certifie pas l’équilibrage de plusieurs semaines sur iPhone.

## Vingt et un tests de refonte

Ils couvrent les quatre contacts initiaux et l’absence de déblocage automatique, le budget commun entre site de rencontre et bar, le refus sans mutation de la quatrième action, les tentatives sans événement, la remise à trois points sans cumul, les réservations de rendez-vous, les interactions directes utilisant la même réserve, les contacts inconnus et la famille, le déterminisme et la conservation des tirages, les probabilités sur 5 000 premières sorties indépendantes, l’absence de financement automatique après une rencontre d’investisseur et l’absence de gains financiers sur le site de rencontre.

Ils vérifient aussi deux cafés avec identifiants, parcelles, équipes et paramètres indépendants, le refus d’une parcelle occupée avant paiement, les synergies non cumulées, la concurrence locale, les fournitures réservées à une seule adresse, deux boutiques distinctes par catégorie, la couverture du catalogue par les offres, les pièces uniques entre enseignes, les véhicules achetables en plusieurs exemplaires et leur statut non dupliqué.

Enfin, ils vérifient la migration du payload v1 vers v2, les identités des anciens contacts, les parcelles, les montants de précision élevée sans passage par Double, la relecture exacte d’une sauvegarde récente et le rejet de données incohérentes sans accès à un index invalide.

## Préparé pour Xcode, non exécuté ici

- Deux tests SwiftData : sauvegarde dans un fichier puis réouverture, et récupération de la copie précédente après corruption.
- Trois parcours UI : première partie et réouverture, consommation de trois actions et persistance après relance, puis navigation catégorie → boutique → intérieur → fiche article.
- Workflow GitHub Actions prévu pour tests Swift sous Linux et `xcodebuild test` sous macOS. Une compilation distante ne doit être considérée validée que lorsque son résultat est effectivement disponible.

## Validation Apple requise

Cette machine est sous Linux, sans Xcode, SDK iOS ni simulateur. L’analyse syntaxique ne résout pas les types Apple ; elle ne garantit donc pas que l’interface et les services iOS compilent. Ouvrir le projet sur Mac, exécuter **⌘U**, puis **⌘R**. Examiner les erreurs éventuelles du compilateur Apple avant de qualifier cette version de prête sur iPhone.

Contrôler visuellement la ville (façades, parcelles, circulation, déplacements et sélection), les magasins et leur différenciation, l’icône Personnage sur chaque onglet, les grandes tailles de texte et VoiceOver. Profiler SceneKit avec un réseau développé ; vérifier l’arrêt des animations en arrière-plan, la synchronisation des sons, le mode silencieux, les réglages audio, les vibrations sur appareil, les notifications et une absence réelle de plus de trente minutes.

Les scènes utilisent des modèles procéduraux originaux et non les modèles 3D de la référence. Les portraits sont des illustrations 3D cartoon originales générées pour le projet. Aucun rendu capturé sur iPhone n’est fourni dans cette instance Linux.

## Blocage des photographies

L’accès à Wikimedia Commons a été refusé par la politique réseau avec un HTTP 403. Les deux domaines nécessaires ont été enregistrés dans le brouillon d’environnement ; cela ne les active pas et ne publie pas l’environnement. Il faut une activation par le workflow de paramètres de l’environnement avant de reprendre l’acquisition des sources.

`python3 scripts/validate-assets.py --require-photos` échoue actuellement de manière attendue et explicite : les 32 photographies autorisées manquent. Le manifeste, l’importateur avec contrôle de provenance et les crédits sont préparés ; aucune photo générée ou d’un autre modèle n’est présentée comme une photographie réelle du produit. Voir [PHOTOGRAPHS.md](media/PHOTOGRAPHS.md). La conformité visuelle complète au cahier des charges reste donc non validée.

## Intégration Kenney — 5 novembre 2026

Le créateur a fourni City Kit Commercial 2.1 et Animated Characters Retro 1.1, puis confirmé que les modèles rétro servent uniquement aux passants. Les archives et leurs empreintes sont conservées dans AssetsSource/Kenney ; leurs licences CC0 sont embarquées avec les ressources.

Vérifications exécutées :

- 41 modèles OBJ avec MTL et palette, références des textures présentes.
- Deux apparences humaines, aucun fichier zombie dans les ressources de l’application.
- Conversion par Blender 4.3.2 et la bibliothèque Assimp installée (paquet libassimp5 5.4.3+ds-2 ; API annonçant 5.4.0).
- Quatre Collada homme/femme × idle/run, chacun conservant 58 articulations et 59 canaux.
- Réimport des quatre Collada par Assimp : un maillage, un matériau et une animation pour chaque fichier.
- Contrôle des durées : 16/24 s pour run et 32/24 s pour idle. Correction de l’unité de temps issue de l’export Collada.
- Contrôle de déformation après réimport d’un personnage animé dans Blender : les poses à deux instants diffèrent réellement ; la figure n’est pas simplement translatée sans animation.
- 51 tests portables exécutés sans échec ; projet OpenStep à 142 objets et syntaxe Swift vérifiés.

Les tests iOS `KenneyAssetTests` ont été ajoutés pour le chargement ModelIO/SceneKit, les squelettes et animations ainsi que le rôle purement décoratif des passants. Ils ne sont pas exécutés sous Linux. Le cycle fourni est run, ralenti pour les déplacements ; aucun cycle walk absent du pack n’est inventé.

Le workflow macOS sépare compilation, tests unitaires natifs et tests UI ; il conserve le `.app` de simulateur dans un ZIP si la compilation réussit. L’utilisateur a explicitement autorisé l’envoi le 5 novembre et l’intégration a été poussée sur `main`.

Le run [42020020366](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42020020366), commit `25d54db`, a exécuté le compilateur Apple et relevé l’absence de l’import de pont `SceneKit.ModelIO`. Cette erreur a été corrigée dans `dae8736`. La vérification de ce correctif est suivie dans le [run 42020297001](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42020297001). Le runner ARM est resté en attente ; le contrôle a été repris sur le runner officiel `macos-15-intel`.

Le [run 42020774343](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42020774343), commit `bc2a6ea`, a réussi la compilation de l’application iOS. Ses tests ont été interrompus volontairement pour améliorer le diagnostic et borner la durée des tests.

Le [run 42022166115](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42022166115), commit `d512ee4`, a également réussi la compilation, le conditionnement et la sauvegarde de l’artefact **BusinessClicker-Simulator-Intel**. Ce ZIP contient le `.app` compilé pour simulateur Intel, non un IPA signé pour iPhone physique. Les étapes de tests unitaires natifs et d’interface doivent encore être suivies séparément ; la présence de l’artefact ne certifie pas leur réussite.

La version antérieure `594ab56` avait également un workflow en échec ; les journaux détaillés étaient inaccessibles avec les accès présents. Les nouvelles annotations du workflow permettent désormais de lire les erreurs de compilation sur la page publique. Une réussite des tests Linux ne remplace ni le chargement Apple de ces fichiers ni la revue du rendu iPhone.

## Correction visible de l’accueil — 6 novembre 2026

Le run `42023352240`, commit `b3fd87a`, a réussi compilation et tests unitaires natifs, dont les trois tests Kenney. Le chargement des modèles, des quatre rigs et des animations est donc vérifié dans SceneKit. Les parcours UI comportaient un échec de recherche du contrôle Concessionnaires ; ce run n’est pas entièrement réussi.

Le commit `57c9a66` modifie réellement l’écran de départ : Ville remplace l’ancien Accueil/Carte, les commandes se superposent à la scène, le bouton de journée est fixé en bas et des bulles projetées ouvrent les données concernées. Le tirage quotidien de 40 % et la fenêtre de décision remplacent le déclenchement systématique tous les trois jours et le bilan forcé.

**57 tests portables passent**. Ils incluent l’enregistrement des jours sans événement, l’impossibilité de relancer un tirage sauvegardé, les décisions uniques, le rattrapage hors ligne et les bulles reliées aux vrais stocks, travaux et événements. Syntaxe Swift, projet Xcode et ressources vérifiés. La compilation Apple, le conditionnement de cette nouvelle interface et ses tests unitaires natifs ont réussi. Les résultats des parcours UI sont suivis séparément dans le [run 42179809019](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42179809019).

La liste explicite des fonctions encore absentes est dans [ETAT_REALISATION.md](ETAT_REALISATION.md). Ne pas confondre cette correction ciblée avec la réalisation intégrale des versions 1.4–1.5 du cahier des charges.

Le run `42179809019` a terminé avec les tests UI en échec et un dépassement du délai global de 25 minutes. Le contrôle du jour cherchait la ville pendant sa modale d’événement ; le contrôle boutique imposait un type Button aux liens SwiftUI. Les requêtes sont corrigées, la sélection Collection est explicitement vérifiée, et les parcours disposent désormais d’un job macOS indépendant. Leurs résultats ne doivent pas être annoncés comme réussis avant la nouvelle exécution. Les échecs conservent une capture, la hiérarchie d’accessibilité et des annotations ciblées.

Le [run 42183108545](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42183108545), commit `7e7f1f0`, a réussi ses jobs `core` et `ios` (compilation, artefact et tests unitaires natifs). Le job `ios-ui` est distinct ; sa validation ne découle pas de ces deux réussites.

Le job `ios-ui` du run `42183108545` a dépassé sa limite de 25 minutes et a été annulé. Les deux autres jobs sont entièrement réussis. La vérification des parcours UI reste donc non validée ; aucune réussite globale ni revue visuelle sur appareil n’est annoncée.

Le diagnostic final du job UI relève des délais de capture d’accessibilité dès l’ouverture de la ville (lignes 25 et 55 du test), avant les parcours proprement dits. La scène est corrigée pour exposer uniquement ses marqueurs interactifs et éviter les mises à jour UIKit à chaque image quand la caméra et le cadrage sont immobiles. Chaque parcours est désormais lancé séparément pour conserver son propre diagnostic. Cette correction de rendu nécessite une nouvelle vérification native.

Le run `42187105833` compile la correction. Son premier parcours arrive sur la ville et conserve `JOUR 1` dans son diagnostic, mais la requête du bouton de journée expire encore. Le rendu SceneKit est donc entièrement retiré de l’arbre d’accessibilité ; les mêmes actions de stocks, travaux et événements sont accessibles dans la liste des lieux. Les interactions visuelles dans la scène restent en place. Cette correction nécessite sa propre vérification native.
