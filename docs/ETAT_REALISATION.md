# État réel de l’application — 6 novembre 2026

Le cahier des charges définit une cible. Il ne constitue pas une liste de fonctions toutes déjà livrées. Le commit `57c9a66` corrige notamment l’ancien accueil qui ne reflétait pas la direction de ville principale.

| Fonction | État constaté dans le code | Validation |
|---|---|---|
| Ville comme écran principal, scène occupant l’espace, bouton de journée en bas | Implémenté dans `57c9a66` | Compilation Xcode réussie ; parcours UI non validés (délai CI dépassé) |
| Quartiers, commerces sélectionnables, recentrage et liste des lieux | Implémenté | Revue visuelle de la nouvelle interface à effectuer |
| Modèles commerciaux Kenney | Intégrés avec textures | Chargement natif validé dans les runs `42023352240` et `42179809019` |
| Passants Kenney humains, sans zombies, distincts des personnages importants | Intégrés et animés | Tests natifs de squelettes et animations réussis dans les runs `42023352240` et `42179809019` |
| Bulles de stocks, livraisons, travaux, location et événement | Implémentées dans `57c9a66`, calculées depuis la sauvegarde | Règles testées sous Linux ; gestes et projection à contrôler sur iPhone |
| Tirage d’événement chaque jour avec possibilité de ne rien obtenir | Implémenté, taux de 40 %, résultat conservé | Tests déterministes, probabilité, absence et doublons exécutés |
| Fenêtre de choix, choix gratuit, report et journal | Implémentés dans `57c9a66` | Décisions enregistrées via le moteur ; parcours UI non validés |
| Plusieurs établissements du même type | Implémenté | Tests de parcelles, stocks, paramètres et équipes indépendants |
| Personnage, portraits, quatre contacts initiaux et trois actions quotidiennes | Implémenté | Tests du moteur ; le parcours d’actions précédent est passé sur iOS |
| Catégories, boutiques et achat d’articles | Implémenté, avec intérieurs stylisés | Un ancien test de navigation échouait ; identifiants d’accessibilité corrigés dans `57c9a66` |
| Photographies commerciales | **Non intégrées : 0/32** | Contrôle strict des photos en échec attendu ; visuels marqués indisponibles |
| Habitudes détaillées par segment de clientèle | **À réaliser** | Les règles actuelles de demande ne constituent pas encore ce système |
| Avis clients expliqués et concurrents nommés | **À réaliser** | Aucune validation correspondante ne peut être annoncée |
| Météo, saisons économiques et événements de quartier matérialisés | **À réaliser** | Le tirage quotidien ne remplace pas ces systèmes |
| Commerces personnels, logement et garage visitables avec équipements visibles | **À compléter** | Les intérieurs de boutiques ne constituent pas ces intérieurs personnels |
| Rencontres localisées dans la ville | **À réaliser** | La page Actions existe, mais ne remplace pas la mise en scène de ces rencontres |
| Objectif personnel sélectionnable et premier service guidé | **À réaliser** | Introduction, missions et succès existent séparément |
| Commandes groupées et politiques détaillées de managers | **À réaliser** | Les commandes individuelles et le réapprovisionnement automatique existent |

## Vérifications disponibles

- **57 tests portables réussis**, dont six ajoutés pour les tirages quotidiens et les bulles.
- Le [run 42023352240](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42023352240) compile la version précédente, passe les tests unitaires natifs dont Kenney, mais échoue sur une navigation boutique. Il ne faut pas le présenter comme entièrement vert.
- La nouvelle interface a réussi la compilation Xcode, le conditionnement de son `.app` de simulateur et les tests unitaires natifs ; les parcours UI sont suivis dans le [run 42179809019](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42179809019). Ce run a échoué sur deux contrôles UI et dépassé son délai global. Les requêtes et l’isolation du job UI sont corrigées pour la prochaine exécution ; les parcours restent à valider.

- Les contrôles corrigés sont suivis dans le [run 42183108545](https://github.com/yassineosman07-blip/Billionnaire-Tycoon/actions/runs/42183108545), commit `7e7f1f0`, avec un job de parcours UI indépendant. La compilation, les tests portables et les tests unitaires natifs ont réussi. Le job `ios-ui` a été annulé après dépassement de sa limite de 25 minutes ; ses parcours ne sont pas validés.

La maquette générée précédemment est une référence de direction artistique, pas une capture d’application. Aucun rendu « pixel par pixel » ni niveau de fluidité sur iPhone n’est certifié par ce document.
