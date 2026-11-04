# Vérifications de livraison — 4 novembre 2026

## Exécuté dans l’environnement Linux

| Contrôle | Résultat |
|---|---|
| Compilation du package Swift, Swift 6.0.3 officiel | Réussie |
| XCTest du moteur | **30 tests exécutés, 0 échec** |
| Analyse syntaxique de tous les fichiers Swift, y compris iOS et tests | Réussie |
| Lecture du projet Xcode comme plist OpenStep avec Foundation | Réussie, 88 objets et références de fichiers existantes |
| Schéma Xcode partagé et appartenance des sources | Valides |
| Icône opaque RGB 1024×1024, catalogue de couleurs, cinq fichiers WAV | Valides |
| Manifeste de confidentialité XML | Valide |
| Syntaxe du script shell et compilation des scripts Python | Réussies |
| Contrôle des espaces avec `git diff --check` | Réussi |

Commande réellement utilisée : `./scripts/test-core.sh`, avec accès au démon Docker géré. L’image `swift:6.0.3-jammy` est épinglée au digest `sha256:95f6ef898992dc840b35517e780f6f6db9661432775ab0b33cc0a531ea749bdb`. Les 30 tests XCTest ont terminé ; le message supplémentaire du runner Swift Testing indiquant zéro test concerne l’autre framework, non utilisé ici.

## Scénarios couverts par les 30 tests

État initial, contenu minimal, ventes et recettes, consommation des ingrédients, rupture de stock, sensibilité aux prix, qualité fournisseur, commandes datées, paiement et comptabilisation sans doublon, commandes invalides, déterminisme, trois heures d’absence, rendement hors ligne de 50 % avec charges complètes, avance manuelle et automatique combinée, conservation des fractions de journée, recul de l’horloge, 800 journées en lots, synergies, progression au niveau 100, expansion, managers, salaires et formation, rénovations différées, limitation des travaux, vacance avec loyers excessifs, charges immobilières, loyers et bilan de revente, interactions sociales, réponses uniques, rendez-vous datés, couple et famille, conditions d’événements et financement unique, récompenses uniques, dette et aide de secours, sérialisation complète, données corrompues et identifiants réordonnés, 40 entreprises avec 16 chantiers et 400 journées, grands nombres et bornes comptables.

Un scénario de 30 jours utilise uniquement les 100 € et les stocks initiaux, commande normalement et acquiert une deuxième entreprise. Il termine sans dette et avec une trésorerie supérieure au montant initial. Il confirme une trajectoire de départ récupérable ; il ne démontre pas l’équilibrage de plusieurs semaines sur appareil.

## Ajouté mais non exécuté ici

- Deux tests iOS SwiftData : enregistrement dans un fichier et réouverture avec conservation de l’état, récupération de la copie précédente après corruption.
- Un parcours XCTest UI : introduction, premier service, lecture du bilan, écran Empire, fermeture et réouverture. Il utilise une sauvegarde de test distincte en Debug et joint une capture au résultat Xcode.
- Workflow GitHub Actions : moteur sous Linux et tests iOS sous macOS. Aucun envoi ni déclenchement distant n’a été effectué.

## Validation Apple encore nécessaire

Cette machine est sous Linux et n’a ni Xcode, SDK iOS ni simulateur. L’analyse syntaxique ne résout pas les types des frameworks Apple et ne remplace donc pas une compilation iOS. Le projet n’est pas certifié compilé ou exécuté sur iPhone.

Sur Mac : ouvrir `BusinessClicker.xcodeproj`, sélectionner un simulateur iPhone iOS 17+, puis lancer **⌘U** et **⌘R**. Vérifier les cinq onglets, les très grandes tailles de texte, le défilement et le zoom de la carte, le rappel local avec permission accordée/refusée, la musique, le mode silencieux, les vibrations sur appareil et la réouverture après une absence réelle. Le README fournit une commande `xcodebuild test` reproductible.

## Choix et limites explicites

La première livraison utilise une carte stylisée, des portraits SF Symbols et des ressources audio locales de remplacement. Les managers automatisent le stock et la productivité ; ils ne modifient pas les tarifs ni les horaires choisis par le joueur. Le menu se personnalise parmi deux recettes initiales. Les activités familiales restent narratives. Les transactions ordinaires utilisent Decimal, avec un plafond explicite de 10³⁰ € ; l’utilitaire mantisse/exposant est séparé et n’étend pas ce plafond comptable. Les migrations futures doivent être ajoutées lors d’un changement de format. Les constantes économiques et la variété narrative restent à ajuster par des sessions de jeu sur iPhone.
