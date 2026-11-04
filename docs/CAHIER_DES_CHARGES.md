# BUSINESS CLICKER
## Cahier des charges fonctionnel, narratif, graphique et technique

**Version :** 1.0 — Cahier des charges consolidé  
**Plateforme :** iOS (iPhone)  
**Environnement :** Xcode  
**Langage :** Swift  
**Technologies :** SwiftUI, SpriteKit, SwiftData, Swift Charts  
**Architecture :** MVVM  
**Modèle économique :** Gratuit, sans publicité ni achats intégrés  
**Genre :** Simulation de vie, gestion d'entreprise, idle clicker, stratégie économique  
**Mode :** Solo, entièrement jouable hors connexion

---

# 1. VISION GLOBALE

## 1.1. Concept

Business Clicker est un jeu mobile de simulation de vie et d'entrepreneuriat dans lequel le joueur incarne un jeune homme qui a abandonné son emploi pour réaliser son rêve : devenir entrepreneur.

Après avoir investi dans un food truck nommé **Tasty Crousty**, il connaît des difficultés économiques et personnelles.

Son entreprise ne fonctionne pas aussi bien qu'espéré et sa femme décide de le quitter.

C'est à ce moment que le joueur prend le contrôle.

Il doit gérer son commerce, développer son patrimoine, construire un réseau de relations et prendre des décisions pour améliorer progressivement sa situation.

Le joueur peut notamment :

- Gérer ses propres entreprises.
- Créer un empire commercial.
- Investir dans l'immobilier.
- Acheter des biens de luxe.
- Développer des relations personnelles.
- Rencontrer de nouveaux personnages.
- Fonder une famille.
- Recruter des employés et des managers.
- Faire des investissements stratégiques.
- Débloquer de nouveaux quartiers, villes et marchés.
- Devenir millionnaire, milliardaire, puis dépasser ces niveaux de richesse.

Le jeu repose sur une progression longue, exponentielle et continue.

Il ne possède aucun système de prestige : le joueur conserve ses entreprises, son patrimoine et sa progression.

## 1.2. Philosophie du gameplay

Le jeu commence de manière relativement simple avec la gestion d'un food truck.

De nouvelles mécaniques deviennent disponibles progressivement.

Au début, le joueur gère personnellement presque toutes les opérations : stocks, prix, horaires et achats.

À mesure qu'il s'enrichit, il peut engager des employés, déléguer ses responsabilités, acquérir de nouveaux commerces, investir dans l'immobilier et gérer plusieurs secteurs économiques.

Les premières heures privilégient la gestion détaillée d'une petite activité.

Le milieu de partie développe les entreprises, la vie sociale et le patrimoine.

La fin de partie s'oriente vers les multinationales, les investissements de grande ampleur et l'expansion internationale.

Le jeu doit conserver des décisions intéressantes, même lorsque le joueur devient extrêmement riche.

## 1.3. Objectifs de conception

1. Proposer un gameplay accessible immédiatement.
2. Permettre une progression sur plusieurs jours ou semaines.
3. Récompenser les décisions économiques intelligentes.
4. Rendre le développement personnel aussi intéressant que la richesse financière.
5. Créer des interactions entre économie, patrimoine et relations sociales.
6. Offrir une interface iPhone premium et satisfaisante.
7. Faire évoluer visuellement l'univers en fonction de la réussite du joueur.
8. Garantir une simulation cohérente, sauvegardée et jouable sans serveur.

---

# 2. SCÉNARIO ET COMMENCEMENT

## 2.1. Le protagoniste

Le personnage principal est un jeune homme qui décide de quitter son emploi salarié.

Il utilise ses économies pour acheter un food truck nommé Tasty Crousty.

Son projet ne connaît pas le succès attendu.

Ses dépenses sont importantes, ses bénéfices insuffisants et ses relations personnelles se dégradent.

Sa femme finit par le quitter.

Le joueur prend le contrôle au lendemain de cette séparation.

## 2.2. Situation initiale

Le joueur possède :

- Un food truck Tasty Crousty.
- Un capital disponible de 100 €.
- Un petit logement de départ.
- Une réputation professionnelle faible.
- Un nombre limité de relations personnelles et professionnelles.
- Une activité commerciale qui nécessite une intervention quotidienne.

Le food truck est déjà acquis. Ses coûts d'acquisition passés ne doivent pas être déduits du capital initial.

Une situation économique difficile mais récupérable doit être prévue.

Le joueur doit pouvoir progresser dès les premières journées sans se retrouver bloqué par un manque définitif de liquidités.

## 2.3. Introduction narrative

Le début du jeu présente brièvement :

1. La décision de quitter son emploi.
2. L'acquisition du food truck.
3. Les difficultés commerciales.
4. La séparation.
5. La reprise en main de sa vie.

Cette introduction peut utiliser des illustrations, des transitions animées et de courts dialogues.

Elle ne doit pas être trop longue.

Après l'introduction, le joueur accède au gameplay principal.

Le scénario de départ est fixe, mais la suite de l'histoire fonctionne sous forme de sandbox narratif.

---

# 3. SYSTÈME DE TEMPS ET CALENDRIER

## 3.1. Principe fondamental

Le temps est organisé en journées simulées.

Chaque journée représente un cycle économique complet.

Le joueur peut faire avancer le calendrier manuellement ou laisser le temps réel produire de nouvelles journées.

**Règle validée : 30 minutes réelles correspondent à une journée dans le jeu.**

## 3.2. Progression manuelle

Le joueur dispose d'une commande permettant de passer au jour suivant.

Il peut également faire défiler rapidement plusieurs journées.

Avant de passer au lendemain, il peut :

- Commander des stocks.
- Modifier les prix.
- Choisir les horaires.
- Recruter des employés.
- Acheter des biens.
- Investir.
- Organiser des rendez-vous.
- Prendre des décisions stratégiques.

Les actions de préparation sont illimitées.

Toutefois, les événements liés à une date, les livraisons et les rendez-vous ne peuvent être exécutés plusieurs fois durant une même journée.

## 3.3. Passage automatique du temps

Une journée s'écoule automatiquement toutes les 30 minutes réelles.

Ce mécanisme fonctionne pendant que le jeu est ouvert et lors des périodes d'absence, par calcul différé lors de la réouverture.

Exemple :

Le joueur ferme l'application pendant 3 heures.

Lorsqu'il revient, le jeu simule 6 journées supplémentaires et présente un récapitulatif.

## 3.4. Simulation hors ligne

Le système doit :

- Enregistrer la date réelle de la dernière simulation.
- Calculer le nombre de journées écoulées.
- Simuler les ventes et les dépenses.
- Déduire les stocks consommés.
- Traiter les commandes et livraisons.
- Calculer les loyers immobiliers.
- Déduire les salaires et autres charges.
- Faire progresser les travaux.
- Actualiser les relations et événements éligibles.
- Enregistrer le nouvel état du monde.

Les revenus hors ligne restent réduits conformément au choix précédent.

**Proposition d'équilibrage :** appliquer un rendement de 50 % aux revenus d'exploitation simulés pendant l'absence, sans supprimer les dépenses fixes ou les obligations économiques.

Ce pourcentage doit être paramétrable dans le moteur du jeu.

La progression hors ligne ne doit pas permettre de dupliquer des revenus en combinant l'avancement manuel et l'avancement automatique.

## 3.5. Bilan quotidien

Après chaque journée, un résumé affiche :

- Date du jeu.
- Chiffre d'affaires.
- Dépenses.
- Bénéfice net.
- Revenus immobiliers.
- Évolution de la trésorerie.
- Événements importants.
- Messages et rendez-vous disponibles.
- Travaux terminés.
- Nouvelles opportunités.

Un historique des journées doit être consultable.

---

# 4. ÉCONOMIE GÉNÉRALE

## 4.1. Monnaie

La monnaie est l'euro (€).

Les montants doivent être formatés de manière lisible.

Exemples :

- 1 250 €
- 125 000 €
- 4,5 M€
- 2,8 Md€

Pour les montants extrêmement élevés, prévoir une notation compacte adaptée à une économie exponentielle.

## 4.2. Sources de richesse

Le joueur peut gagner de l'argent grâce :

- Aux bénéfices des entreprises.
- À la production automatisée.
- Aux revenus locatifs.
- À la vente de biens immobiliers.
- Aux investissements stratégiques.
- Aux bonus temporaires.
- Aux événements.
- Aux récompenses d'objectifs.
- À l'expansion de ses activités.

## 4.3. Dépenses

Les dépenses peuvent comprendre :

- Achats de stocks.
- Salaires.
- Loyers commerciaux.
- Charges de fonctionnement.
- Frais d'installation.
- Travaux immobiliers.
- Entretien du patrimoine.
- Achats personnels.
- Formations.
- Investissements.
- Remboursements de dettes.

## 4.4. Gestion du patrimoine

Le jeu distingue :

**Trésorerie disponible :** argent immédiatement utilisable.

**Valeur des entreprises :** estimation de la valeur des activités détenues.

**Patrimoine immobilier :** valeur des bâtiments et terrains.

**Patrimoine personnel :** véhicules, objets de collection et autres biens.

**Dettes :** engagements financiers restant à rembourser.

**Fortune nette :** valeur totale des actifs moins les dettes.

Ces indicateurs doivent être présentés séparément dans le tableau de bord.

## 4.5. Progression

La progression économique est lente et exponentielle.

Les coûts des améliorations augmentent à chaque niveau.

Les entreprises disposent d'un niveau maximal de 100.

Les revenus peuvent continuer à progresser après ce niveau grâce :

- Aux synergies.
- Aux managers.
- Aux investissements.
- Aux expansions.
- Aux multiplicateurs.
- Aux innovations.
- Aux bonus permanents de progression, sans remise à zéro.

---

# 5. GESTION DU FOOD TRUCK TASTY CROUSTY

## 5.1. Présentation

Tasty Crousty représente le premier véritable défi économique.

Le joueur doit apprendre à transformer une activité peu rentable en commerce prospère.

## 5.2. Menu et produits

Le joueur peut créer et personnaliser son menu à partir d'une sélection de produits disponibles.

Chaque produit possède :

- Un nom.
- Un prix de vente.
- Un coût de fabrication.
- Une liste d'ingrédients.
- Une popularité.
- Une satisfaction moyenne.
- Un temps de préparation.
- Une marge estimée.

Le joueur peut modifier les prix.

Des prix élevés augmentent la marge unitaire, mais peuvent réduire la demande.

## 5.3. Gestion des stocks

Chaque ingrédient possède :

- Un identifiant.
- Un nom.
- Une quantité.
- Une unité de mesure.
- Un prix d'achat.
- Un seuil d'alerte.
- Un fournisseur associé.

La fabrication des produits consomme les ingrédients nécessaires.

Une rupture de stock empêche la vente des produits concernés.

## 5.4. Fournisseurs

Plusieurs fournisseurs doivent être disponibles.

Ils se différencient par :

- Leurs prix.
- Leur qualité.
- Leurs délais de livraison.
- Leurs quantités minimales.
- Leur fiabilité.

Les commandes doivent être enregistrées et livrées à une date prévue.

## 5.5. Horaires

Le joueur peut définir ses heures d'ouverture et de fermeture.

Les horaires influencent :

- La clientèle potentielle.
- Les dépenses.
- Les besoins en personnel.
- La satisfaction.
- La rentabilité.

Une ouverture prolongée peut augmenter les ventes, mais également les charges.

## 5.6. Demande des clients

La demande quotidienne dépend notamment :

- De la popularité du quartier.
- De la réputation commerciale.
- Du prix des produits.
- De la satisfaction des clients.
- Du niveau de concurrence.
- De la capacité de production.
- Des stocks disponibles.
- Des horaires d'ouverture.

La simulation doit être déterministe lorsque les données et la graine aléatoire sont identiques, afin de permettre des tests fiables.

## 5.7. Développement

Le food truck peut être amélioré jusqu'au niveau 100.

Les améliorations concernent notamment :

- L'équipement de cuisine.
- La capacité de préparation.
- Le stockage.
- La rapidité du service.
- Le confort des employés.
- La qualité.
- La visibilité commerciale.

À terme, le joueur peut recruter un manager pour automatiser une grande partie de sa gestion.

---

# 6. ENTREPRISES ET EMPIRE COMMERCIAL

## 6.1. Nombre d'entreprises

Le jeu doit proposer au minimum 40 entreprises distinctes dans sa première version complète.

Elles sont réparties en plusieurs secteurs économiques.

Les noms commerciaux sont fictifs, avec des identités inspirées de différents types d'entreprises réelles.

## 6.2. Secteurs économiques

Prévoir notamment :

1. Restauration.
2. Commerce de proximité.
3. Hôtellerie et tourisme.
4. Immobilier professionnel.
5. Transports et logistique.
6. Industrie.
7. Technologie.
8. Intelligence artificielle.
9. Cloud et infrastructures numériques.
10. Finance et assurances.
11. Énergie.
12. Luxe.
13. Télécommunications.
14. Biotechnologies.
15. Spatial.

Certains secteurs sont accessibles rapidement.

D'autres se débloquent selon la richesse, les entreprises détenues et les grands objectifs atteints.

## 6.3. Fiches d'entreprise

Chaque entreprise possède une fiche détaillée comprenant :

- Nom et logo fictif.
- Secteur.
- Description.
- Localisation.
- Niveau.
- Valeur estimée.
- Chiffre d'affaires journalier.
- Charges.
- Bénéfice.
- Nombre d'employés.
- Productivité.
- Réputation.
- Manager éventuel.
- Améliorations disponibles.
- Synergies actives.

## 6.4. Gestion des niveaux

Le joueur peut augmenter le niveau des entreprises de 1 à 100.

Chaque niveau améliore les capacités de l'entreprise.

Le prix du niveau suivant augmente selon une formule exponentielle propre à l'activité.

La progression doit être équilibrée pour éviter qu'une entreprise bon marché reste toujours supérieure à des investissements beaucoup plus importants.

## 6.5. Synergies automatiques

Certaines entreprises produisent des bonus lorsqu'elles sont possédées simultanément.

Exemples :

- Une société de livraison améliore la rentabilité des restaurants.
- Un data center améliore les revenus des entreprises technologiques.
- Une agence de publicité améliore la demande des commerces.
- Une société d'énergie diminue certains coûts de production.
- Une compagnie aérienne améliore le secteur touristique.

Les synergies sont automatiquement activées lorsque leurs conditions sont remplies.

Elles doivent être visibles dans les fiches d'entreprise.

## 6.6. Employés

Les entreprises peuvent recruter des employés avec :

- Un salaire.
- Un niveau de compétence.
- Une efficacité.
- Une spécialisation.
- Des possibilités de formation.

Les employés augmentent la capacité opérationnelle, mais génèrent des coûts.

## 6.7. Managers

Les managers permettent progressivement d'automatiser la gestion des entreprises.

Ils peuvent notamment :

- Commander des stocks.
- Ajuster certains prix.
- Organiser les horaires.
- Superviser les employés.
- Maintenir la production.

Le joueur conserve la possibilité de reprendre le contrôle manuel.

## 6.8. Concurrence

Le jeu comporte une concurrence simulée.

Les concurrents influencent la demande disponible et les prix du marché.

Cette concurrence ne nécessite pas une simulation détaillée de chaque entreprise rivale.

## 6.9. Difficultés économiques

Une entreprise peut connaître des pertes.

Le joueur peut alors :

- Réduire les horaires.
- Modifier les prix.
- Changer de fournisseur.
- Réduire les charges.
- Réorganiser le personnel.
- Demander un financement.
- Vendre certains actifs.
- Mettre en place un plan de redressement.

Une difficulté financière ne doit pas entraîner systématiquement une perte définitive de la partie.

---

# 7. CARTE DE LA VILLE ET QUARTIERS

## 7.1. Principe

Le jeu intègre une carte interactive permettant de visualiser l'empire économique.

Chaque quartier possède des caractéristiques économiques distinctes.

## 7.2. Caractéristiques d'une zone

Chaque zone possède :

- Un identifiant.
- Un nom.
- Une popularité.
- Une clientèle potentielle.
- Un niveau de richesse.
- Un coût d'installation.
- Un loyer commercial.
- Un prix immobilier de référence.
- Un indice de concurrence.
- Une attractivité sectorielle.

Ces caractéristiques sont fixes conformément au choix validé.

La réputation et les performances des entreprises peuvent toutefois évoluer individuellement.

## 7.3. Influence économique

Une zone populaire attire davantage de clients, mais implique généralement des coûts plus élevés.

Exemple illustratif :

| Quartier | Popularité | Installation | Potentiel |
|---|---:|---:|---|
| Périphérie | 25/100 | 500 € | Faible |
| Résidentiel | 50/100 | 2 000 € | Moyen |
| Centre-ville | 80/100 | 12 000 € | Élevé |
| Quartier premium | 95/100 | 50 000 € | Très élevé |

Les valeurs définitives seront calibrées par le moteur économique.

## 7.4. Fonctionnement de la carte

Le joueur doit pouvoir visualiser les zones, sélectionner un quartier, consulter son attractivité et examiner les entreprises ou biens immobiliers présents.

La carte doit représenter l'expansion de l'empire.

Les commerces achetés apparaissent progressivement.

L'apparence des bâtiments peut évoluer selon les niveaux.

**Proposition d'implémentation :** une carte isométrique 2D interactive, avec déplacement, zoom et sélection des bâtiments. Ce choix graphique précis n'avait pas encore été définitivement validé.

---

# 8. INVESTISSEMENT IMMOBILIER

## 8.1. Objectif

L'immobilier doit constituer un véritable système de gestion économique indépendant des entreprises traditionnelles.

Le joueur peut :

- Acheter des logements.
- Louer des biens à des locataires.
- Fixer les loyers.
- Rénover les propriétés.
- Augmenter leur valeur.
- Améliorer leur attractivité.
- Revendre avec une plus-value éventuelle.
- Constituer un portefeuille immobilier.
- Développer progressivement un empire immobilier.

## 8.2. Types de biens

Prévoir :

- Studios.
- Appartements.
- Maisons individuelles.
- Immeubles résidentiels.
- Villas.
- Résidences de luxe.
- Locaux commerciaux.
- Immeubles de bureaux.

## 8.3. Caractéristiques d'un bien

Chaque propriété possède au minimum :

- Identifiant.
- Nom ou adresse fictive.
- Type.
- Quartier.
- Surface.
- État général.
- Valeur marchande.
- Prix d'achat.
- Niveau de rénovation.
- Attractivité locative.
- Loyer demandé.
- Charges journalières.
- Statut d'occupation.
- Date d'acquisition.
- Travaux en cours.
- Revenus cumulés.
- Historique des dépenses.

## 8.4. Achat

Le joueur sélectionne un bien sur la carte ou dans une agence immobilière virtuelle.

Il peut consulter :

- Le prix demandé.
- L'emplacement.
- L'état du logement.
- Le loyer de marché estimé.
- Les coûts d'entretien.
- La rentabilité locative potentielle.
- Le potentiel de valorisation.

Après achat, le bien rejoint son portefeuille immobilier.

## 8.5. Gestion locative

Le joueur peut choisir le montant du loyer.

Un loyer faible favorise l'occupation, mais diminue les revenus.

Un loyer excessif augmente le risque de vacance.

Le système calcule la probabilité de trouver ou conserver un locataire selon :

- Le quartier.
- La qualité du logement.
- Le montant du loyer.
- La demande locale.
- L'attractivité du bien.

Les loyers sont perçus à intervalles réguliers du calendrier simulé.

Le système doit empêcher de percevoir un loyer lorsqu'aucun locataire n'occupe le bien.

## 8.6. Rénovations

Le joueur peut entreprendre des travaux pour augmenter la valeur ou l'attractivité d'un bien.

Exemples :

- Peinture.
- Cuisine.
- Salle de bains.
- Isolation.
- Équipements.
- Aménagement intérieur.
- Rénovation complète.

Chaque rénovation possède :

- Un coût.
- Une durée exprimée en journées.
- Un effet sur l'état du logement.
- Un effet sur la valeur marchande.
- Un effet éventuel sur le loyer potentiel.

**Les rénovations ne sont pas instantanées.**

Exemple :

Un appartement acheté 80 000 € nécessite 15 000 € de travaux.

La rénovation dure 12 jours dans le jeu.

Une fois terminée, le logement peut être valorisé à 110 000 €, selon son quartier et son état.

Ces chiffres sont des exemples, pas une garantie de rentabilité.

## 8.7. Chantier et progression

Un chantier passe par différents états :

1. Planifié.
2. En attente de démarrage.
3. En cours.
4. Terminé.

Le joueur voit le nombre de jours restants.

Les travaux progressent également pendant les périodes hors ligne.

Les bonus immobiliers ne sont appliqués qu'une fois les travaux terminés.

## 8.8. Revente

Le joueur peut vendre une propriété.

Le prix de revente dépend de la valeur du quartier, de l'état, des rénovations et de la valeur marchande du bien.

Le bilan doit afficher :

- Prix d'achat.
- Dépenses de rénovation.
- Charges cumulées.
- Loyers perçus.
- Prix de revente.
- Profit ou perte de l'investissement.

## 8.9. Gestion du portefeuille

Un tableau de bord immobilier doit présenter :

- Nombre de propriétés.
- Valeur totale.
- Loyers journaliers ou périodiques.
- Charges.
- Revenus nets.
- Taux d'occupation.
- Travaux en cours.
- Rentabilité de chaque bien.

## 8.10. Cohérence économique

Le système doit éviter les stratégies de gains illimités sans risque.

En particulier :

- Les rénovations coûtent de l'argent et du temps.
- Les valeurs ne peuvent pas augmenter indéfiniment par répétition d'un même travail.
- Un logement vacant ne rapporte aucun loyer.
- Les charges restent dues.
- Le loyer demandé influence l'occupation.
- La revente doit tenir compte de l'historique réel du bien.
- Les revenus immobiliers ne doivent pas être comptabilisés deux fois.

---

# 9. PATRIMOINE PERSONNEL ET MAGASIN

## 9.1. Magasin

Le jeu possède une boutique dédiée à la consommation personnelle.

Elle est séparée des entreprises et des investissements immobiliers professionnels.

## 9.2. Catégories

Prévoir notamment :

- Voitures.
- Motos.
- Appartements personnels.
- Maisons et villas.
- Vêtements.
- Montres.
- Bijoux.
- Objets de collection.
- Œuvres d'art.
- Yachts.
- Jets privés.

## 9.3. Effets des achats

Les achats peuvent avoir plusieurs fonctions :

- Collection.
- Amélioration du confort.
- Personnalisation visuelle.
- Augmentation du patrimoine.
- Accès à certains événements.
- Amélioration du statut social.
- Déblocage de nouvelles interactions.

Toutefois, la richesse matérielle ne doit pas permettre d'obtenir automatiquement l'amitié ou l'affection d'un personnage.

## 9.4. Évolution du niveau de vie

Les acquisitions du joueur influencent progressivement son environnement.

Son logement, sa garde-robe et certains espaces de collection peuvent évoluer visuellement.

Le magasin doit être présenté sous forme de catégories et de fiches illustrées.

Les marques commerciales du jeu sont de préférence fictives.

---

# 10. PERSONNAGES ET RELATIONS SOCIALES

## 10.1. Personnages secondaires

Prévoir entre 30 et 50 personnages secondaires.

Ils peuvent appartenir aux catégories suivantes :

- Parents et famille.
- Amis.
- Connaissances.
- Relations professionnelles.
- Employés.
- Investisseurs.
- Concurrents.
- Partenaires potentiels.
- Personnages rencontrés lors d'événements.

## 10.2. Personnalité

Chaque personnage important possède :

- Un prénom.
- Une apparence.
- Un rôle.
- Une personnalité.
- Des préférences.
- Une relation initiale avec le protagoniste.
- Une humeur.
- Un niveau de confiance.
- Un niveau d'affinité.
- Des événements disponibles.

Ces caractéristiques évoluent selon les interactions.

## 10.3. Types de relations

Le joueur peut développer :

- Des amitiés.
- Des relations familiales.
- Des contacts professionnels.
- Des partenariats commerciaux.
- Des relations amoureuses.

Les relations amoureuses peuvent évoluer vers une vie de couple, un mariage et la possibilité de fonder une famille.

Les interactions doivent rester narratives et non explicites.

## 10.4. Messagerie

Le personnage dispose d'un smartphone virtuel.

Il peut y recevoir :

- Des messages personnels.
- Des invitations.
- Des propositions d'investissement.
- Des demandes d'aide.
- Des informations professionnelles.
- Des rappels de rendez-vous.

Certains messages proposent plusieurs réponses.

## 10.5. Agenda

Le joueur peut programmer :

- Des rendez-vous.
- Des sorties.
- Des repas.
- Des rencontres professionnelles.
- Des événements familiaux.
- Des activités personnelles.

Les rendez-vous se déclenchent lorsqu'une journée éligible est atteinte.

## 10.6. Événements liés aux relations

Exemple :

Un ami présente au joueur un investisseur intéressé par son commerce.

Le joueur reçoit un message et dispose de plusieurs possibilités :

- Préparer un dossier.
- Étudier ses finances.
- Demander conseil.
- Se présenter sans préparation.

Le résultat dépend de la préparation, de la réputation et des décisions prises.

Les conséquences sont principalement temporaires, conformément au choix validé.

Certaines réussites peuvent néanmoins produire des changements persistants de progression, comme l'acquisition d'un financement ou l'ouverture d'une nouvelle activité.

## 10.7. Famille

Le jeu comprend :

- Relations avec les parents.
- Rencontres et vie de couple.
- Événements familiaux.
- Mariage.
- Possibilité d'avoir des enfants.
- Anniversaires.
- Dépenses familiales.
- Activités et événements partagés.

Le système doit rester accessible et compatible avec le rythme accéléré du calendrier.

## 10.8. Réputation

La richesse et la réputation sont deux dimensions distinctes.

Une fortune importante peut ouvrir certaines opportunités financières.

Mais la confiance, la qualité des relations et les décisions personnelles influencent également les interactions.

---

# 11. ÉVÉNEMENTS ET NARRATION SANDBOX

## 11.1. Principe

Après l'introduction, le jeu n'impose pas une histoire entièrement linéaire.

Les événements apparaissent en fonction de la situation actuelle.

## 11.2. Déclencheurs

Un événement peut dépendre :

- Du nombre de jours écoulés.
- De la richesse.
- De la réputation.
- Des relations.
- Des entreprises possédées.
- Des investissements.
- Du quartier.
- Du patrimoine personnel.
- D'un événement précédent.

## 11.3. Catégories d'événements

Prévoir :

- Opportunités commerciales.
- Propositions d'investissement.
- Problèmes de fournisseurs.
- Rencontres sociales.
- Réunions professionnelles.
- Événements familiaux.
- Crises commerciales.
- Opportunités immobilières.
- Célébrations.
- Bonus temporaires.

## 11.4. Choix

Chaque événement comporte un contexte, un ou plusieurs choix et des conséquences.

Les choix peuvent coûter de l'argent, nécessiter une préparation ou dépendre de certaines caractéristiques du joueur.

Le système doit conserver l'historique des événements résolus.

Il doit également empêcher qu'un événement unique soit exploité plusieurs fois.

## 11.5. Variété

Les événements doivent être suffisamment nombreux pour limiter la répétition.

Des délais de réapparition, des conditions de déclenchement et des variantes narratives doivent être prévus.

---

# 12. MISSIONS, OBJECTIFS ET RÉCOMPENSES

Le jeu comprend des missions quotidiennes et des objectifs permanents.

## 12.1. Missions quotidiennes

Exemples :

- Servir un certain nombre de clients.
- Réaliser un bénéfice.
- Commander des stocks.
- Améliorer une entreprise.
- Participer à une activité sociale.

Les missions dépendent du calendrier du jeu.

## 12.2. Objectifs permanents

Exemples :

- Atteindre 10 000 € de fortune.
- Acquérir sa deuxième entreprise.
- Devenir propriétaire.
- Acheter dix biens immobiliers.
- Atteindre un million d'euros.
- Débloquer un nouveau secteur.

## 12.3. Récompenses

Les récompenses peuvent comprendre :

- Argent.
- Améliorations.
- Multiplicateurs.
- Déblocages.
- Éléments cosmétiques.
- Objets exclusifs.

## 12.4. Succès

Prévoir un écran recensant les succès obtenus, leur progression et les récompenses associées.

---

# 13. BOOSTS ET AMÉLIORATIONS

## 13.1. Améliorations permanentes

Le joueur peut acheter des améliorations de productivité, d'efficacité ou de rentabilité.

Elles sont conservées définitivement.

## 13.2. Boosts temporaires

Les événements et récompenses peuvent activer des boosts limités dans le temps.

Exemples :

- Augmentation temporaire des ventes.
- Réduction des coûts.
- Productivité renforcée.
- Bonus sur les bénéfices.

La durée doit être exprimée clairement en temps réel ou en journées du jeu.

## 13.3. Équilibrage

Les bonus ne doivent pas permettre de contourner entièrement les stocks, les charges et les règles de la simulation.

---

# 14. EXPANSIONS ET FIN DE JEU

## 14.1. Absence de prestige

Aucune remise à zéro volontaire de progression n'est prévue.

Le joueur conserve ses biens, ses entreprises et sa fortune.

## 14.2. Expansion

Une fois l'empire suffisamment développé, le joueur peut accéder à de nouveaux marchés.

L'expansion peut intégrer :

- De nouvelles villes.
- De nouveaux quartiers.
- De nouvelles régions.
- Des marchés internationaux.
- Des entreprises de secteurs avancés.

## 14.3. Évolution de la difficulté

La difficulté passe progressivement de la gestion d'un commerce individuel à la direction d'un ensemble d'entreprises.

Les managers permettent de réduire les tâches répétitives.

Les nouveaux marchés et investissements maintiennent l'intérêt stratégique.

---

# 15. INTERFACE UTILISATEUR

## 15.1. Direction artistique

Style : minimaliste, moderne et premium.

Palette principale :

- Violet très sombre : `#171326`
- Violet accent : `#9568EA`
- Lavande claire : `#EDE5FF`

Prévoir des surfaces contrastées, des cartes élégantes, des typographies lisibles et une hiérarchie visuelle claire.

## 15.2. Navigation

La navigation se fait par onglets.

**Organisation proposée :**

1. Accueil.
2. Empire.
3. Carte.
4. Vie.
5. Patrimoine.

Les fonctionnalités secondaires sont accessibles à l'intérieur de ces sections.

## 15.3. Écran d'accueil

L'écran principal affiche :

- Le personnage ou un visuel représentatif.
- La pile de billets cliquable.
- La date actuelle.
- Le solde.
- Le bénéfice journalier estimé.
- La fortune nette.
- Un bouton permettant d'avancer au lendemain.
- Les événements importants.
- Les notifications internes.

La pile de billets doit rester un élément central de l'identité visuelle.

Son interaction sert à avancer le cycle économique, et non à créer de l'argent sans justification économique.

## 15.4. Écran Empire

Cet écran regroupe les secteurs et les entreprises.

Le joueur peut consulter les fiches d'entreprise, gérer leurs paramètres, recruter des employés et acheter des améliorations.

## 15.5. Écran Carte

La carte affiche les quartiers, les commerces, les biens immobiliers et les extensions débloquées.

## 15.6. Écran Vie

Il rassemble :

- Personnages.
- Relations.
- Messages.
- Agenda.
- Événements personnels.

## 15.7. Écran Patrimoine

Il rassemble :

- Immobilier.
- Magasin.
- Garage.
- Logements.
- Collections.
- Inventaire personnel.

## 15.8. Dashboard financier

Le tableau de bord comprend :

- Solde.
- Fortune nette.
- Revenus.
- Charges.
- Bénéfices.
- Valeur des entreprises.
- Valeur immobilière.
- Revenus locatifs.
- Dettes.
- Historique financier.

Les graphiques sont réalisés avec Swift Charts.

---

# 16. ANIMATIONS, AUDIO ET RETOURS VISUELS

## 16.1. Animations

L'expérience doit être visuellement satisfaisante.

Prévoir :

- Animation de la pile de billets.
- Particules.
- Montants flottants.
- Transitions entre journées.
- Célébrations de réussite.
- Déblocages animés.
- Animations d'acquisition.
- Évolution des bâtiments.
- Effets de progression des rénovations.

## 16.2. Technologie

SwiftUI gère les interfaces et transitions.

SpriteKit est utilisé pour les animations de particules et les éléments visuels plus complexes.

## 16.3. Audio

Prévoir :

- Sons de clic.
- Sons d'achat.
- Sons de réussite.
- Sons de notification interne.
- Musique d'ambiance.
- Retours haptiques.

Les différents effets doivent pouvoir être désactivés.

## 16.4. Performance

Les animations doivent rester fluides sur iPhone.

Prévoir un réglage permettant de réduire leur intensité.

Le système doit éviter de générer un nombre excessif de particules lors des passages rapides de journées.

---

# 17. SAUVEGARDE ET DONNÉES

## 17.1. SwiftData

La progression est enregistrée localement avec SwiftData.

Aucun compte n'est nécessaire.

La sauvegarde doit être automatique.

## 17.2. Données persistantes

Enregistrer notamment :

- Personnage.
- Date actuelle.
- Trésorerie.
- Fortune.
- Entreprises.
- Employés.
- Managers.
- Stocks.
- Commandes.
- Quartiers débloqués.
- Biens immobiliers.
- Travaux.
- Contrats locatifs.
- Patrimoine personnel.
- Relations.
- Messages.
- Agenda.
- Événements.
- Missions.
- Succès.
- Paramètres.
- Historique financier.

## 17.3. Sauvegardes sûres

Prévoir :

- Enregistrement régulier.
- Transactions cohérentes.
- Protection contre les doublons.
- Validation des données chargées.
- Gestion des erreurs.
- Migration des modèles lors des mises à jour.

## 17.4. Réinitialisation

Le joueur peut recommencer une partie depuis les paramètres, avec une confirmation explicite.

---

# 18. ARCHITECTURE TECHNIQUE

## 18.1. Technologies obligatoires

- Swift.
- SwiftUI.
- SpriteKit.
- SwiftData.
- Swift Charts.
- AVFoundation.
- UIKit pour les retours haptiques.
- Xcode.
- Architecture MVVM.

Cible minimale proposée : iOS 17.

Application iPhone en mode portrait.

## 18.2. Organisation du projet

Structure recommandée :

```text
BusinessClicker/
├── App/
├── Core/
│   ├── Economy/
│   ├── Time/
│   ├── Events/
│   ├── Persistence/
│   └── Utilities/
├── Models/
│   ├── Player/
│   ├── Businesses/
│   ├── RealEstate/
│   ├── Relationships/
│   ├── Inventory/
│   └── Events/
├── ViewModels/
├── Views/
│   ├── Home/
│   ├── Empire/
│   ├── Map/
│   ├── Life/
│   ├── Patrimony/
│   ├── Statistics/
│   └── Settings/
├── Components/
├── SpriteKit/
├── Services/
├── Resources/
└── Tests/
```

## 18.3. Moteur de simulation

La logique économique doit être séparée de l'interface graphique.

Créer un moteur central responsable du passage du temps.

Chaque journée est exécutée dans un ordre cohérent :

1. Actualiser les livraisons.
2. Actualiser les travaux.
3. Déterminer les activités ouvertes.
4. Calculer la demande.
5. Simuler les ventes.
6. Consommer les stocks.
7. Appliquer les revenus.
8. Appliquer les charges.
9. Calculer les loyers et occupations.
10. Mettre à jour les statistiques.
11. Déclencher les événements éligibles.
12. Actualiser le calendrier.
13. Sauvegarder la progression.

Le moteur doit fonctionner de la même manière pour un jour manuel et pour les jours simulés lors d'une absence.

## 18.4. Gestion des très grands nombres

L'économie exponentielle peut dépasser les capacités des types numériques classiques.

Prévoir une représentation numérique adaptée aux très grandes valeurs, avec une précision suffisante pour les opérations financières.

Séparer les besoins comptables ordinaires du système de progression exponentielle.

## 18.5. Modularité

Les entreprises, objets, événements et biens immobiliers doivent être définis à partir de modèles de données réutilisables.

Il doit être possible d'ajouter du contenu sans réécrire le moteur économique.

---

# 19. TESTS ET QUALITÉ

## 19.1. Tests économiques

Vérifier notamment :

- Calcul des ventes.
- Déduction des stocks.
- Paiement des charges.
- Revenus immobiliers.
- Variations des loyers.
- Achat et vente des biens.
- Calcul des travaux.
- Synergies.
- Augmentation des niveaux.
- Effets des managers.

## 19.2. Tests temporels

Tester :

- Passage d'une journée.
- Passage de plusieurs journées.
- Progression hors ligne.
- Livraison différée.
- Travaux terminés.
- Rendez-vous programmés.
- Changements de date.
- Absence prolongée.
- Absence de revenus dupliqués.

## 19.3. Tests de sauvegarde

Tester :

- Fermeture normale.
- Fermeture inattendue.
- Réouverture.
- Chargement des propriétés.
- Conservation des stocks.
- Conservation des relations.
- Conservation de l'historique.

## 19.4. Tests extrêmes

Tester :

- Très grandes fortunes.
- Grand nombre d'entreprises.
- Multiples propriétés.
- Plusieurs chantiers simultanés.
- Nombreux événements en attente.
- Passage rapide de centaines de jours.
- Trésorerie insuffisante.
- Entreprises déficitaires.
- Données incomplètes ou invalides.

## 19.5. Performances

Le jeu doit rester réactif avec toutes les entreprises débloquées, un patrimoine important et de nombreuses relations actives.

Les calculs de longues absences doivent être optimisés.

Les interfaces SwiftUI ne doivent pas effectuer directement les calculs économiques lourds.

---

# 20. PARAMÈTRES ET ACCESSIBILITÉ

Prévoir au minimum :

- Activation de la musique.
- Activation des effets sonores.
- Activation des vibrations.
- Réduction des animations.
- Format compact des nombres.
- Gestion des notifications quotidiennes.
- Réinitialisation de la sauvegarde.

L'application doit respecter la taille de texte et les préférences de réduction de mouvement lorsque c'est possible.

Les notifications doivent être facultatives et nécessiter l'autorisation de l'utilisateur.

---

# 21. CONTENU MINIMAL DE LA VERSION COMPLÈTE

La première version complète demandée à Codex doit contenir :

- Une introduction narrative fonctionnelle.
- Un personnage principal personnalisable.
- Le food truck Tasty Crousty jouable.
- Un calendrier quotidien.
- La progression automatique et hors ligne.
- Un moteur économique opérationnel.
- Au moins 40 entreprises réparties en secteurs.
- Des entreprises améliorables jusqu'au niveau 100.
- Des synergies automatiques.
- Des employés et managers.
- Une carte interactive.
- Des quartiers avec des caractéristiques fixes.
- Des biens immobiliers achetables.
- Un système locatif avec choix des loyers.
- Des rénovations et travaux différés.
- La revente immobilière.
- Un magasin de patrimoine personnel.
- Des catégories de biens de luxe.
- Entre 30 et 50 personnages secondaires.
- Des relations personnelles et professionnelles.
- Une messagerie.
- Un agenda.
- Des événements narratifs avec choix.
- Des missions et succès.
- Des récompenses.
- Des statistiques avec graphiques.
- Une sauvegarde locale automatique.
- Des paramètres audio et graphiques.
- Des tests avancés.

Les systèmes doivent être reliés entre eux et non constitués uniquement d'écrans de démonstration.

---

# 22. EXIGENCES DE RÉALISATION POUR CODEX

Codex doit recevoir l'instruction de réaliser le projet complet, avec un niveau d'autonomie élevé.

Il devra :

1. Examiner le projet Xcode existant, s'il y en a un.
2. Créer une architecture MVVM cohérente.
3. Implémenter les modèles SwiftData.
4. Développer le moteur temporel et économique.
5. Développer les interfaces SwiftUI.
6. Intégrer SpriteKit pour les effets avancés.
7. Utiliser Swift Charts pour les statistiques.
8. Ajouter des données initiales cohérentes.
9. Prévoir des personnages et événements narratifs.
10. Intégrer des ressources graphiques utilisables légalement.
11. Ajouter les sons et retours haptiques.
12. Écrire les tests.
13. Vérifier la compilation lorsque les outils locaux le permettent.
14. Corriger les erreurs détectées.
15. Fournir un projet prêt à être ouvert, exécuté et testé dans Xcode.

Il devra privilégier le code fonctionnel plutôt que des interfaces simulées sans logique réelle.

Aucun écran ne doit prétendre offrir une fonctionnalité qui n'est pas implémentée.

Si certains éléments nécessitent des ressources externes indisponibles, Codex devra utiliser des ressources locales de remplacement, sans masquer les limitations.

---

# 23. CRITÈRES DE RÉUSSITE

Le projet sera considéré comme fonctionnel lorsque le joueur pourra :

1. Commencer une partie après l'histoire de Tasty Crousty.
2. Gérer son commerce et modifier ses paramètres.
3. Passer au lendemain et obtenir un bilan cohérent.
4. Fermer le jeu puis retrouver une progression correctement simulée.
5. Acheter et gérer d'autres entreprises.
6. Engager des employés et managers.
7. Acheter un appartement.
8. Définir son loyer et rechercher des locataires.
9. Effectuer une rénovation prenant plusieurs jours.
10. Revendre un bien et consulter son rendement.
11. Acheter des biens personnels.
12. Interagir avec des personnages.
13. Organiser un rendez-vous.
14. Prendre des décisions lors d'un événement.
15. Consulter son patrimoine et ses statistiques.
16. Conserver sa progression après redémarrage.

L'ensemble doit fonctionner sur iPhone, sans connexion Internet obligatoire.

---

# 24. DÉCISIONS CONSOLIDÉES ET ARBITRAGES

Les décisions explicitement validées par le créateur sont prioritaires.

Certains points ont évolué depuis le concept initial :

**Le clic :** initialement source directe de revenus, il devient principalement un moyen de faire avancer le calendrier et de déclencher les résultats des activités économiques.

**Les revenus passifs :** ils sont désormais calculés à partir des journées simulées plutôt qu'à partir d'un simple compteur par seconde.

**Le gameplay :** initialement centré sur les améliorations, il inclut maintenant une véritable gestion des entreprises, des stocks et des relations.

**L'immobilier :** ce n'est plus seulement une catégorie de dépenses ou un secteur commercial. C'est un système complet d'investissement locatif et de valorisation.

**La narration :** l'introduction reste scénarisée, puis le joueur évolue librement dans un monde sandbox.

**Le magasin :** les biens de luxe servent à la collection et peuvent aussi débloquer des avantages ou des événements.

**La progression :** elle reste continue, sans prestige, avec des expansions de fin de jeu.

**La première livraison :** le projet complet est demandé en une seule mission Codex. Cela n'empêche pas l'agent d'organiser ses modifications internes par modules pour garantir la cohérence et les tests.

Les choix non définitivement tranchés, comme le style exact de la carte, le contenu exhaustif des catalogues, les noms des personnages et certaines valeurs d'équilibrage, doivent être résolus par des propositions cohérentes avec ce document, sans supprimer les fonctionnalités validées.

---

# 25. VISION FINALE

Business Clicker doit donner au joueur l'impression de construire progressivement une vie entière.

Il commence avec un petit food truck peu rentable, des ressources limitées et une situation personnelle difficile.

Il apprend à gérer ses finances, à satisfaire ses clients, à développer son réseau et à prendre des décisions.

Il ouvre ensuite des commerces, acquiert des propriétés, investit dans l'immobilier, recrute des collaborateurs et découvre de nouveaux secteurs.

En parallèle, sa vie personnelle évolue. Il rencontre des personnages, développe des amitiés, construit des relations et peut fonder une famille.

Ses choix économiques et personnels influencent les événements qu'il rencontre.

Au fil des jours, son patrimoine grandit et sa ville se transforme.

Le joueur peut finalement diriger un vaste empire tout en conservant la possibilité de gérer individuellement ses activités.

**L'objectif n'est pas simplement de devenir riche : c'est de simuler le parcours complet d'un entrepreneur, de ses premières difficultés jusqu'à la construction d'un empire économique et personnel.**
