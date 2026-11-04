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
