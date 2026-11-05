# BUSINESS CLICKER
## Cahier des charges fonctionnel, narratif, graphique et technique

**Version :** 1.5 — Révision du 5 novembre 2026 : ressources Kenney validées et passants humains décoratifs
**Plateforme :** iOS (iPhone)  
**Environnement :** Xcode  
**Langage :** Swift  
**Technologies :** SwiftUI, SceneKit, SpriteKit, SwiftData, Swift Charts
**Architecture :** MVVM  
**Modèle économique :** Gratuit, sans publicité ni achats intégrés  
**Genre :** Simulation de vie, gestion d'entreprise, idle clicker, stratégie économique  
**Mode :** Solo, entièrement jouable hors connexion

---

> Cette version définit la cible à réaliser. Les nouvelles exigences ne sont pas encore implémentées dans le jeu actuel. Les références visuelles fournies dans la conversation guident la direction artistique ; elles ne constituent pas des ressources intégrées au projet.

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
- Exactement quatre contacts connus : sa mère, son père, son frère et son ex-femme.
- Aucun ami, investisseur, partenaire professionnel ou autre contact déjà débloqué.
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

Les opérations de préparation économique sont illimitées : stocks, tarifs, horaires et consultation des comptes. Les activités personnelles et de prospection de la page Actions disposent, elles, d’un budget commun de **trois actions par journée simulée**, défini au chapitre 10. Ce budget ne limite pas les clics de navigation et ne se confond pas avec les passages au lendemain.

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

## 6.1. Types d’activités et établissements multiples

Le catalogue comporte au minimum **40 types d’activités** répartis en secteurs. Ce minimum porte sur les types disponibles, pas sur une limite de 40 établissements possédés.

Le joueur peut créer ou acquérir **plusieurs établissements du même type** : deux cafés dans un quartier, cinq cafés répartis dans la ville, plusieurs restaurants ou concessions, par exemple. Posséder un café ne doit jamais supprimer la possibilité d’en ouvrir un autre.

Distinguer explicitement :

- **Type d’activité** : modèle réutilisable définissant les règles, coûts et améliorations d’un café, restaurant, hôtel, etc.
- **Établissement** : instance indépendante, avec identifiant unique, nom personnalisable, emplacement, finances, employés, manager, niveau et réputation propres.
- **Enseigne ou réseau** : regroupement facultatif d’établissements permettant de suivre une chaîne et ses résultats consolidés.

Les noms d’enseignes créées par le jeu restent fictifs. Un nouvel établissement n’est pas une copie gratuite du premier : son ouverture demande un emplacement disponible, les fonds d’acquisition ou de création, les frais d’installation et un fonds de roulement affichés avant confirmation.

**Exemple attendu :** le joueur ouvre « Café Brume — Centre » puis « Café Brume — Jardins ». Il peut fixer des prix différents, améliorer l’un sans améliorer l’autre et recruter deux équipes distinctes. Les bilans individuels et le résultat total du réseau sont consultables.

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

Chaque établissement possède une fiche détaillée comprenant :

- Identifiant unique de l’établissement et référence à son type d’activité.
- Nom personnalisable, enseigne et éventuel réseau.
- Adresse ou parcelle précise sur la carte.
- Statut : préparation, ouverture, activité ou fermeture temporaire.

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

## 6.10. Clientèle et habitudes de consommation

La demande distingue au minimum employés de bureau, étudiants, familles et touristes. Chaque segment possède des habitudes de fréquentation, une sensibilité au prix et des préférences de produits, influencées par le quartier, les horaires, le jour de la semaine, la saison et les événements locaux.

Exemples : les bureaux favorisent le déjeuner, les étudiants certaines soirées, les familles les périodes de repos et les touristes les zones et saisons attractives. Ces habitudes sont expliquées sur la fiche du quartier et dans une estimation de fréquentation avant l’ouverture du service.

Le moteur calcule la demande de ces segments dans la journée simulée. Leur somme respecte la clientèle disponible, la concurrence locale, les stocks et la capacité de service ; une même clientèle ne doit pas être intégralement attribuée à chaque café voisin. Les passants affichés dans la ville représentent cette activité sans ajouter de nouvelles ventes au calcul économique.

## 6.11. Réputation locale et avis des clients

Chaque établissement possède sa propre réputation locale et un historique d’avis fictifs. Les commentaires reposent sur des causes calculées : attente, disponibilité des produits, prix, qualité, accueil ou confort. Ils ne sont pas tirés au hasard indépendamment des performances réelles.

Afficher une note accompagnée de raisons compréhensibles et de pistes concrètes : « Attente élevée : former l’équipe », « Produit souvent épuisé : augmenter la réserve », « Prix appréciés ». Une variation de note doit pouvoir s’expliquer ; améliorer un commerce ne modifie pas automatiquement la note des autres établissements du réseau.

La réputation agit progressivement sur la demande. Elle reste distincte de la fortune et de la réputation personnelle du protagoniste. Les avis ne constituent ni un réseau social réel ni un service connecté.

## 6.12. Concurrents identifiables

Ajouter plusieurs enseignes rivales fictives, reconnaissables dans la ville et dans les informations de quartier. Elles possèdent un positionnement économique lisible : prix bas, service rapide, qualité ou gamme premium.

Les rivaux peuvent ouvrir un établissement ou lancer une promotion selon des règles simulées et sauvegardées. Le joueur peut répondre par son offre, ses horaires, la qualité ou le service ; il ne doit pas être obligé de copier systématiquement le prix le plus bas.

Les caractéristiques de base d’un quartier restent fixes. L’arrivée d’un concurrent et une promotion ajoutent des modificateurs identifiés, bornés et datés à la concurrence effective, sans réécrire arbitrairement l’indice de base. Les concurrents n’occupent pas les parcelles déjà acquises et leurs décisions ne changent pas rétroactivement un résultat quotidien enregistré.

## 6.13. Gestion rapide d’un empire

Prévoir une vue comparant les établissements : bénéfice net, stocks, fréquentation, satisfaction et alertes, avec filtres par quartier, activité et réseau. Le joueur doit pouvoir identifier les commerces en difficulté sans ouvrir vingt fiches.

Les actions groupées permettent de préparer des commandes de fournitures pour plusieurs adresses et de déléguer aux managers. Avant confirmation : afficher les établissements ciblés, les quantités, le coût total, les livraisons prévues et les exclusions. Aucun achat n’est validé au-delà de la trésorerie disponible ; un plan groupé non finançable demande un ajustement explicite, sans exécution partielle silencieuse.

Les managers respectent des politiques visibles : seuil de stock, budget maximal et règles d’ouverture. Le joueur conserve la reprise manuelle. Ces opérations économiques ne consomment pas les trois actions personnelles de la journée et ne multiplient pas les revenus lors de la consolidation.

## 6.14. Création et gestion d’un réseau

Depuis Empire, une action « Ouvrir un établissement » reste disponible pour les types d’activités déjà possédés. Le parcours présente le type, l’emplacement, le nom, les coûts détaillés, les charges prévues et la trésorerie restante avant confirmation.

Chaque parcelle possède une capacité et des activités compatibles. Deux établissements peuvent partager un quartier, mais pas occuper la même parcelle. L’ouverture d’un nouvel établissement ajoute son bâtiment à la ville 3D et crée un état économique indépendant.

L’écran Empire propose une vue par secteur, type d’activité et réseau, ainsi qu’une liste de tous les établissements. Les vues consolidées additionnent les comptes individuels sans simuler ni verser les revenus une seconde fois.

La concurrence tient compte de la proximité d’établissements similaires, y compris ceux du joueur : plusieurs cafés se partagent une partie de la demande locale. Les bénéfices d’une chaîne proviennent de la couverture géographique, des achats groupés et des synergies, plutôt que d’une multiplication sans limite de la même clientèle.

Les synergies se calculent selon les secteurs et conditions définies ; ouvrir dix établissements identiques ne doit pas appliquer dix fois un bonus prévu comme unique. Le niveau maximal de 100 s’applique séparément à chaque établissement. Les recrutements, stocks, commandes et missions ciblent un identifiant d’établissement.

---

# 7. CARTE DE LA VILLE ET QUARTIERS

## 7.1. Principe : la ville est le cœur du jeu

**La ville vivante devient l’écran principal obligatoire après l’introduction et à la réouverture de la partie.** Le joueur gère son parcours depuis cet espace : il voit les quartiers, ses commerces, les bâtiments disponibles, son immobilier et les lieux de vie. La ville n’est plus une carte secondaire insérée dans un écran de statistiques.

La nouvelle référence fournie par le créateur est une **ville de gestion dans l’esprit de SimCity**, vue en perspective isométrique, dense, détaillée et lisible. Elle remplace la référence précédente de petite ville low poly comme objectif de rendu final. L’inspiration concerne la richesse urbaine, la composition, les hauteurs et la lisibilité ; elle ne demande pas de reprendre la marque, les modèles ou les textures du jeu de référence.

Chaque quartier conserve ses caractéristiques économiques distinctes. Le moteur de simulation reste la source des comptes ; l’apparence animée de la ville représente son état sans calculer des revenus supplémentaires.

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

## 7.4. Direction visuelle : ville de gestion détaillée

La scène représente une **véritable ville 3D navigable**, avec caméra inclinée et projection isométrique ou orthographique adaptée à l’iPhone. La direction visuelle privilégie une architecture urbaine crédible, des silhouettes variées et un rendu soigné plutôt qu’une série de blocs uniformes.

Éléments obligatoires :

- Un centre urbain avec immeubles de bureaux, tours et bâtiments de hauteurs différentes.
- Des quartiers résidentiels avec maisons, petits immeubles et espaces verts.
- Des rues commerçantes où cafés, restaurants et autres commerces sont reconnaissables par leurs façades, vitrines, enseignes ou terrasses.
- Des zones d’activités et de logistique adaptées aux entreprises concernées.
- Des routes reliées, intersections, passages piétons, trottoirs, stationnements, mobilier urbain, arbres et parcs.
- Des façades, fenêtres, toitures, matériaux et détails architecturaux cohérents ; les bâtiments ne partagent pas tous le même modèle simplement recoloré.
- Un éclairage, des ombres et une palette permettant de distinguer les volumes et les voies sans masquer les informations de gestion.

La ville doit être intéressante visuellement dès le début, même lorsque le joueur ne possède que Tasty Crousty. Les bâtiments ambiants représentent des activités de la ville ; ils ne deviennent pas automatiquement la propriété du joueur. Ses acquisitions sont identifiables sans donner l’impression qu’il possède tous les immeubles visibles.

Une image de fond, un rendu généré non interactif, une grille de cartes ou quelques volumes génériques ne satisfont pas cette exigence. La conformité visuelle doit être examinée dans une version exécutée, en comparaison avec la référence du créateur.

## 7.5. Quartiers, commerces et sélection

Chaque quartier possède un nom visible à une échelle adaptée et une identité architecturale. En vue éloignée, les noms et zones facilitent l’orientation ; en zoom rapproché, les commerces et leurs alertes deviennent prioritaires. Éviter l’empilement de tous les libellés à toutes les échelles.

Chaque établissement possédé correspond à une adresse sélectionnable. Deux cafés du même réseau apparaissent à deux emplacements distincts et ouvrent leurs fiches respectives. Les propriétés immobilières et les parcelles disponibles disposent également d’une représentation et d’une sélection cohérentes.

Toucher un bâtiment le met en évidence et ouvre une fiche compacte superposée ou un panneau inférieur, sans obliger à quitter immédiatement la ville. Cette fiche montre le nom, le type, le quartier, le niveau, le statut utile et une commande « Gérer ». Les réglages détaillés s’ouvrent ensuite à la demande. Fermer la fiche restitue la position de caméra précédente.

Toucher un quartier permet de consulter ses caractéristiques et ses opportunités. Des filtres permettent de mettre en évidence les établissements du joueur, les biens immobiliers, les opportunités ou les alertes. Une liste accessible des adresses reste disponible en parallèle de la scène 3D.

## 7.6. Ville vivante

Des voitures empruntent les routes et respectent leurs trajectoires ; elles ne traversent pas les bâtiments. Des piétons circulent sur les trottoirs et fréquentent les zones commerciales. Prévoir des détails contextualisés : clients près d’un commerce ouvert, livraison à une adresse concernée, terrasse animée ou chantier visible pendant une rénovation.

La progression modifie concrètement la ville : nouvel établissement, façade améliorée, enseigne, chantier puis travaux terminés. Un café ne doit pas devenir arbitrairement un gratte-ciel parce qu’il augmente de niveau ; son évolution reste cohérente avec son activité.

Ces animations donnent de la vie à l’espace et reflètent les états du jeu. Elles restent décoratives : une voiture ou un passant affiché ne crée pas une deuxième vente en plus de celle déjà simulée par le moteur. Les animations peuvent être ralenties ou réduites sans modifier l’économie.

## 7.7. Bulles interactives au-dessus des lieux

Les bulles sont ancrées aux bâtiments et se déplacent avec eux à l’écran lors du déplacement ou du zoom. Elles indiquent un fait réel de la sauvegarde, avec une icône et un libellé court :

| Bulle | Condition | Action au toucher |
|---|---|---|
| Stocks bas ou épuisés | Réserve sous le seuil de l’établissement | Ouvrir les stocks de cette adresse |
| Livraison attendue ou arrivée | Commande réelle et date correspondante | Consulter cette livraison |
| Travaux en cours ou terminés | Chantier ou fin de chantier enregistrés | Ouvrir le bien et son état de travaux |
| Opportunité | Offre ou événement éligible lié au lieu | Afficher la fiche ou les choix |
| Message ou rendez-vous | Interaction disponible au lieu concerné | Ouvrir le message ou l’agenda |
| Résultat de journée | Bilan nouvellement calculé | Consulter ce bilan, sans verser à nouveau les gains |

Une bulle d’argent ne signifie jamais « toucher pour créer de l’argent » : les revenus sont déjà comptabilisés par la simulation. Une alerte n’apparaît pas si sa condition n’est plus vraie. Les informations résolues ou consultées disparaissent ou changent d’état selon leur fonction.

Prioriser les alertes importantes, regrouper les bulles qui se chevauchent et adapter leur nombre au zoom. Plusieurs messages d’une même adresse peuvent être regroupés avec un compteur. Aucune pluie de bulles ne doit masquer les rues, le bouton de journée ou les commandes de navigation. Les bulles restent identifiables sans dépendre uniquement de la couleur, avec des zones tactiles accessibles.

## 7.8. Caméra, lisibilité et performance

Prévoir déplacement tactile, zoom borné, sélection et bouton de recentrage sur le commerce principal ou l’élément choisi. La caméra reste dans les limites de la ville et ne traverse pas le décor. L’interface permet de comprendre la sélection même lorsqu’un grand immeuble pourrait cacher le bâtiment visé.

L’image 3D occupe l’essentiel de l’écran. Le texte superposé reste limité, contrasté et lisible. Les boutons de gestion restent accessibles avec les grandes tailles de texte et VoiceOver grâce à une alternative en liste. Le bouton de fin de journée reste fixé à l’écran pendant les mouvements de caméra.

La technologie de rendu doit être choisie selon le SDK iOS retenu et la capacité à atteindre cette direction visuelle. SceneKit intégré à SwiftUI reste la base envisagée, à confirmer avec les recommandations Apple ; le choix technique ne doit pas réduire silencieusement l’ambition de la ville. Le rendu est séparé du moteur économique et des données persistantes.

Optimiser les modèles, les matériaux, les niveaux de détail, les objets hors champ et le nombre de voitures et de passants. Viser 60 images/s sur l’appareil de référence retenu et au moins 30 images/s en mode réduit, à mesurer sur appareil avant validation. Suspendre les animations hors écran et en arrière-plan. Une dégradation réglable réduit les détails et le trafic, en conservant les quartiers, commerces et interactions nécessaires au jeu.

## 7.9. Améliorations visibles et visite des commerces

Les améliorations modifient réellement l’établissement, à l’extérieur ou à l’intérieur : terrasse, devanture, machine, comptoir, cuisine, décoration ou mobilier. La fiche d’achat explique le coût, les effets estimés, les conditions, la durée éventuelle et la limite de capacité concernée.

Exemples : machine plus rapide, terrasse augmentant la capacité lorsqu’elle est exploitable, décoration favorisant le confort, formation améliorant le service. Les bénéfices prévus sont présentés comme des estimations soumises à la demande et aux stocks. Ils ne sont pas garantis par la seule dépense.

Le joueur peut entrer dans ses commerces pour voir leur aménagement, leurs équipements et leur personnel. Un établissement fermé ou en travaux présente un état visuel cohérent. Les modèles et variantes restent adaptés au type d’activité ; une amélioration de café n’ajoute pas arbitrairement une tour de bureaux.

## 7.10. Événements de quartier

Marché, concert, festival, travaux routiers et fermeture temporaire d’une rue peuvent modifier la fréquentation ou l’accessibilité d’une zone pour plusieurs jours. Ces événements ont un quartier, une date de début, une date de fin et des effets économiques explicites.

Une annonce et un calendrier permettent d’anticiper les stocks et les horaires. Les événements prévisibles sont annoncés avant leur effet ; les imprévus restent limités et compréhensibles. La ville les matérialise : stands, foule, barrières, chantier ou rue fermée. Les véhicules et piétons adaptent leurs parcours visuels.

Les effets locaux se combinent selon des règles documentées et bornées avec la météo, les segments de clients et la concurrence. Les caractéristiques économiques de base du quartier restent fixes. La fermeture d’une rue ne supprime pas définitivement une entreprise et ne permet pas de louer deux fois la même clientèle disponible.

## 7.11. Météo, saisons et prévisions

La météo suit le calendrier du jeu et fonctionne hors connexion. Les saisons et les jours de la semaine proviennent de la date simulée, jamais d’une API météo réelle ni du jour réel du téléphone. Les prévisions et événements climatiques sont déterministes à état et graine identiques, conservés lors d’un redémarrage et cohérents lors de la simulation d’une absence.

La pluie peut diminuer la fréquentation d’une terrasse et renforcer certaines activités intérieures. Une période estivale favorise certains marchés touristiques. Les effets dépendent du secteur et de l’équipement : la météo ne doit pas appliquer le même bonus ou malus à toute l’économie.

Afficher les prévisions des trois prochaines journées, les effets attendus et les possibilités d’adaptation. Les changements purement graphiques ne consomment pas une action. Les effets restent modérés et bornés, sans créer une punition financière imprévisible ni un blocage définitif de début de partie.

La représentation graphique de la pluie ou des saisons peut être réduite sans supprimer les informations utiles ou modifier les résultats de simulation.


## 7.12. Ressources Kenney fournies et rôle des passants

Le créateur a fourni les archives `kenney_city-kit-commercial_2.1.zip` et `kenney_animated-characters-retro.zip`. Leurs licences CC0 sont conservées dans le projet avec les fichiers d’origine et leur provenance.

**City Kit Commercial 2.1** fournit la base des commerces, immeubles et gratte-ciel : utiliser les modèles et textures du pack plutôt que remplacer leur géométrie par des blocs génériques. Compléter les rues, espaces verts, véhicules et zones résidentielles pour constituer une ville cohérente. L’approbation de ce pack fixe les ressources de base ; elle ne constitue pas à elle seule une validation de la composition finale ou d’un rendu identique à une référence.

**Animated Characters Retro 1.1 est réservé aux passants ambiants, et à eux seuls.** Utiliser uniquement les apparences humaines masculine et féminine. Exclure les zombies des ressources embarquées. Conserver le rig et les animations fournies lors de leur conversion vers le format natif choisi ; ne pas présenter une translation d’un personnage figé comme une animation de marche.

Ces passants ne sont ni le protagoniste ni les membres de sa famille, les amis ou les investisseurs. Ils ne créent aucun contact, événement, revenu ou statistique sociale. Les personnages importants et leurs fiches conservent leurs portraits 3D cartoon distincts. La nouvelle partie garde exactement ses quatre contacts initiaux.

Les passants empruntent les trottoirs, restent hors des bâtiments et s’arrêtent avec la scène en arrière-plan. Limiter leur nombre et les simplifier en mode réduit. Documenter toute conversion de modèles, vérifier les textures, les os et les animations, puis tester leur chargement et leur rendu réels dans l’application iOS.


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

# 9. PATRIMOINE PERSONNEL ET QUARTIER DES BOUTIQUES

## 9.1. Organisation par catégories et boutiques

Patrimoine distingue les investissements immobiliers, les biens personnels déjà possédés et un espace commercial organisé en catégories. Chaque catégorie regroupe **plusieurs boutiques**, avec leur propre assortiment et leur propre identité.

Le parcours obligatoire est : **Patrimoine → catégorie → choix de la boutique → entrée dans le magasin → sélection d’un article → fiche → confirmation d’achat → collection personnelle**.

Le quartier des boutiques permet de consommer et de collectionner. Il ne faut pas le confondre avec les entreprises que le joueur exploite dans Empire : acheter une voiture chez un concessionnaire ne signifie pas acquérir sa concession.

## 9.2. Catégories et assortiment initial

Le catalogue doit proposer au moins deux boutiques distinctes par catégorie, avec des gammes et ambiances différentes. Les noms suivants sont des propositions d’enseignes fictives :

| Catégorie | Boutique et ambiance 1 | Boutique et ambiance 2 |
|---|---|---|
| Concessionnaires automobiles | Garage Avenue : urbain, béton clair, véhicules accessibles | Prestige Motors : showroom sombre, lumière architecturale, sportives et luxe |
| Motos | Atelier Sillage : mécanique, métal, esprit garage | Route Libre : roadsters, bois et univers voyage |
| Bijouteries | Maison Aster : pierre claire, vitrines champagne | Éclat Nocturne : noir, verre et accents rubis |
| Horlogeries | Orbe Atelier : bois, cuir et détails mécaniques | Temps Moderne : lignes techniques et éclairage froid |
| Mode | Studio Urbain : streetwear et néons | Maison Velours : matières chaudes, élégance et cabines soignées |
| Logements personnels | Habiter : appartements et maisons de ville | Rive d’Or Résidences : villas et demeures d’exception |
| Art et décoration | Galerie Aube : espace blanc et œuvres mises en scène | Cabinet Singularités : ambiance feutrée et objets rares |
| Collections | Comptoir des Curieux : objets historiques et vitrines | Éditions Rares : collections contemporaines et séries limitées |
| Nautisme | Escale Marine : voiliers et bateaux de plaisance | Ondine Yachts : marina et yachts haut de gamme |
| Aviation privée | Altitude Aviation : hangar clair et avions de tourisme | Horizon Executive : lounge et jets privés |

Les bijoux et les montres disposent de catalogues identifiables, même si certaines enseignes peuvent couvrir les deux catégories. Les logements personnels restent séparés des biens destinés à la location.

## 9.3. Entrer dans un magasin

Cliquer sur une boutique ouvre **un espace intérieur dédié**, avec une transition d’entrée, une enseigne, un décor, un éclairage et une présentation des produits propres à cette boutique. Il ne suffit pas de changer la couleur d’une grille générique.

L’intérieur peut employer un décor photographique ou une scène 3D selon le magasin, avec des zones de présentation sélectionnables : véhicules exposés, vitrines de bijoux, portants, tableaux ou postes de consultation. Une liste accessible des articles reste disponible pour faciliter la navigation.

Chaque boutique possède une fiche de direction artistique : palette, matériaux, typographie secondaire, éclairage, cadrage, ambiance sonore et mobilier. Les commandes d’achat, de retour et de navigation restent reconnaissables entre les magasins.

Le joueur peut consulter les articles, filtrer le catalogue, ouvrir leurs fiches, acheter et revenir à la catégorie précédente. L’entrée dans un magasin ne facture rien et n’engage aucun achat.

## 9.4. Photographies réelles et ambiance des articles

**Chaque article achetable doit être illustré par au moins une vraie photographie correspondant à cet article**, en haute qualité et utilisable dans l’application. Un pictogramme, une illustration générée ou une photo approximative d’un autre modèle ne constituent pas un visuel final acceptable.

Pour une voiture réelle, par exemple une Porsche, la fiche présente une photographie du modèle et de la version annoncés, avec une mise en ambiance cohérente avec la concession : showroom, route ou cadre architectural. La carrosserie, la couleur et les informations affichées doivent correspondre au visuel. Plusieurs vues sont recommandées pour les articles majeurs : extérieur, intérieur, détails et mise en situation.

Le nom réel d’une marque ou d’un modèle peut être utilisé pour un article lorsque sa présentation et ses ressources sont autorisées. Les enseignes des boutiques restent fictives. Les photographies doivent être acquises auprès de sources autorisées, commandées ou fournies avec les droits nécessaires ; une image trouvée sur Google ou sur le site d’un constructeur n’est pas automatiquement réutilisable.

Conserver pour chaque ressource : auteur ou fournisseur, source, licence ou autorisation, usages autorisés, attribution éventuelle et référence du fichier local. Les ressources livrées doivent autoriser leur intégration et distribution hors ligne. Aucun téléchargement à l’ouverture d’une boutique n’est requis pour jouer.

Les photos sont embarquées localement, optimisées pour iPhone et chargées progressivement depuis le stockage. Préserver les proportions, éviter les recadrages qui coupent l’objet, fournir un texte alternatif et prévoir des vignettes distinctes des grandes images. Une ressource manquante ou non autorisée reste un élément à fournir ; elle ne doit pas être remplacée silencieusement par une image générée et présentée comme finale.

## 9.5. Fiche article et achat

Chaque article possède un identifiant de catalogue indépendant de la boutique qui le vend, une catégorie, un nom, une marque et un modèle éventuels, une description, un prix, des photographies et leurs métadonnées de droits, ainsi que ses effets sur le confort, le statut ou la progression.

La boutique possède une offre commerciale : référence à l’article, prix, disponibilité et éventuelles conditions de déblocage. Un même article peut être présenté dans plusieurs boutiques sans devenir deux objets de catalogue incohérents.

La confirmation affiche l’article exact, son prix, les effets obtenus et le solde restant. L’achat débite une seule fois la trésorerie et ajoute une instance possédée à l’inventaire. Pour les biens achetables en plusieurs exemplaires, chaque exemplaire a son propre identifiant ; les pièces uniques empêchent explicitement les achats répétés.

Une animation, un son d’acquisition et un retour haptique confirment uniquement un achat réellement enregistré. Une trésorerie insuffisante déclenche un retour bref et lisible, sans son de réussite.

## 9.6. Effets des achats et collection personnelle

Les biens servent à la collection, au confort, à la personnalisation, au patrimoine et à certaines opportunités. Ils peuvent modifier le garage, le logement ou les espaces de collection visibles du joueur. Les photos restent consultables après l’achat.

La richesse matérielle ne procure jamais automatiquement l’amitié ou l’affection d’un personnage. Toute dépense récurrente, restriction ou valeur de revente doit être indiquée avant l’achat si cette mécanique s’applique.
## 9.7. Logement et garage personnels visitables

Le protagoniste peut visiter son logement et son garage, en complément des intérieurs de commerces et de boutiques. Les biens achetés apparaissent dans des emplacements cohérents : véhicules au garage, objets et œuvres dans le logement ou une collection.

L’inventaire demeure la source de propriété. Placer, déplacer ou consulter un objet ne crée ni nouvel exemplaire ni nouvelle valeur patrimoniale. Les biens dont le nombre dépasse l’espace visible restent consultables dans la collection, sans être supprimés. Le logement personnel ne génère pas de loyer comme un investissement locatif tant qu’aucune conversion explicite n’est prévue.


---

# 10. PERSONNAGES ET RELATIONS SOCIALES

## 10.1. Personnages secondaires

Prévoir entre 30 et 50 personnages secondaires dans le catalogue complet. Ils ne sont pas tous connus au départ.

**Le réseau initial contient exactement quatre personnes : la mère, le père, le frère et l’ex-femme.** L’ex-femme est la personne de la séparation racontée dans l’introduction ; il ne s’agit pas d’ajouter une deuxième ex. Aucun ami, connaissance, employé-contact ou investisseur n’est préajouté à la messagerie ou au carnet d’adresses.

Les autres personnages sont rencontrés grâce aux actions, événements et introductions par un contact déjà connu. Le passage du temps seul ne révèle pas automatiquement une liste de nouveaux contacts. Un recrutement économique peut créer un contact lié à cet employé au moment où il survient, sans fabriquer rétroactivement un ami de départ.

Le carnet d’adresses n’affiche que les personnes réellement rencontrées. Les personnages inconnus ne doivent pas apparaître par leur nom ou leur portrait dans une liste de contacts verrouillés. Chaque découverte conserve sa date, son origine et la nature de la relation. Une connaissance peut devenir un ami ou un partenaire selon les interactions ; une rencontre ne donne pas immédiatement un niveau élevé de confiance.

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
- Une apparence et un portrait illustré 3D cartoon propre au personnage.
- Un état connu/inconnu, une date de rencontre et une origine de découverte.
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

Un ami rencontré au cours du jeu présente au joueur un investisseur intéressé par son commerce. Cette possibilité n’est pas disponible dès le départ sans rencontre préalable.

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

## 10.9. Portraits des personnages

Chaque personnage, protagoniste compris, possède un portrait dans le style de la référence fournie : **personnage 3D cartoon soigné**, visage expressif, grands yeux, formes douces, cheveux et vêtements détaillés, éclairage doux et silhouette lisible. La référence donne un style ; elle ne doit pas être intégrée avec son filigrane ni reproduite à l’identique sans les droits nécessaires.

Les portraits forment une série cohérente, avec des identités distinctes : âge adulte adapté au rôle, morphologie, coiffure, tenue, posture et expression. Les parents, le frère et l’ex-femme possèdent chacun leur propre visuel. Prévoir un cadrage visage/buste pour les icônes et fiches de contacts, ainsi qu’une version plus large pour les pages de personnage lorsque nécessaire.

Utiliser des rendus de modèles 3D ou des illustrations autorisées de ce style, optimisés et stockés localement, avec une provenance documentée. Les pictogrammes système ou initiales ne constituent pas les portraits finaux. Ces portraits illustrés sont distincts des photographies réelles obligatoires pour les articles de boutique : les deux exigences ne doivent pas être confondues.

## 10.10. Page Actions et budget quotidien

Créer une page dédiée **« Actions »**, accessible depuis une commande clairement visible dans Vie et par un raccourci dans la fiche du protagoniste. La navigation principale conserve ses cinq onglets. La page affiche en permanence **« Actions restantes : 3/3 »**, puis 2/3, 1/3 ou 0/3 selon les utilisations de la journée.

Les deux activités minimales sont :

- **Site de rencontre** : simulation fictive intégrée au jeu, entièrement hors connexion, permettant de consulter des profils adultes fictifs et de lancer une recherche ou une prise de contact. Aucune inscription réelle, aucun navigateur externe, aucun vrai utilisateur et aucun abonnement payant.
- **Aller au bar** : sortie dans un lieu du jeu, avec son ambiance visuelle et sonore, permettant de rencontrer des connaissances, de discuter avec un professionnel ou de découvrir une opportunité.

Chaque activité validée consomme **une action** du même budget commun, qu’elle déclenche ou non un événement. Trois recherches sur le site, trois sorties au bar ou une combinaison des deux épuisent donc les trois actions. Visiter l’écran, consulter une description ou annuler avant confirmation ne consomme rien. À zéro, les activités sont désactivées et le jeu indique qu’il faut attendre la prochaine journée.

Le solde remonte à trois au changement de **journée du jeu**, manuel ou automatique, jamais à minuit réel ni en relançant l’application. Les actions non utilisées ne s’accumulent pas. Pendant une absence, le calendrier avance mais aucune sortie et aucune recherche ne sont effectuées à la place du joueur ; au retour, seule la réserve de la journée courante est disponible.

Par défaut, ces deux activités restent accessibles gratuitement pour éviter de bloquer la vie sociale en cas de difficultés économiques. Si une variante payante est ajoutée ultérieurement, son coût doit être annoncé et confirmé ; une action non exécutable ne débite ni argent ni point. La consommation du point, le tirage et son résultat sont enregistrés dans une même transaction.

Les interactions sociales volontaires lancées ailleurs doivent utiliser ce même budget lorsqu’elles déclenchent une recherche, une rencontre ou un rendez-vous ; elles ne peuvent pas servir à contourner la limite. Une rencontre planifiée réserve son point pour sa journée d’exécution et le planning refuse plus de trois réservations sur une date. Le compteur indique les points déjà réservés ; leur exécution ne les décompte pas une seconde fois. Les réponses purement narratives à un message ou à un événement déjà obtenu ne consomment pas un nouveau point, sauf coût explicitement annoncé.

## 10.11. Probabilités et résultats des actions

Chaque activité possède sa propre table d’événements pondérés. Une action peut ne produire aucun événement notable. Le résultat dépend d’un tirage sauvegardé et peut être pondéré par la réputation, les contacts connus, la situation familiale et les conditions de l’événement. La richesse seule ne garantit ni une rencontre ni un financement.

**Proposition initiale d’équilibrage, à ajuster après essais :**

| Résultat principal | Site de rencontre | Sortie au bar |
|---|---:|---:|
| Aucun événement notable | 40 % | 40 % |
| Nouvelle connaissance | 45 % | 30 % |
| Conversation avec un contact déjà connu | 10 % | 10 % |
| Rencontre d’un investisseur potentiel | 0 % | 10 % |
| Trouvaille de 100 € | 0 % | 5 % |
| Autre opportunité narrative | 5 % | 5 % |
| **Total** | **100 %** | **100 %** |

La trouvaille reprend l’exemple du créateur « 100 $ par terre », converti en **100 €** pour conserver la monnaie unique du jeu. Elle doit être présentée comme un événement narratif et financier identifié, distinct du chiffre d’affaires des entreprises.

Une rencontre d’investisseur débloque un contact et une proposition éventuelle, **pas un versement automatique**. L’obtention d’un financement dépend ensuite d’un dossier, de conditions et de l’accord du joueur ; une dette ou une prise de participation éventuelle est annoncée avant acceptation. Les rencontres amoureuses concernent uniquement des personnages adultes fictifs, hors famille et hors relations incompatibles.

Les probabilités ne doivent jamais produire un personnage ou une situation incohérente. Si aucun résultat d’une catégorie n’est éligible, son poids est reporté sur « Aucun événement notable ». Les tables normalisées doivent toujours totaliser 100 %. Prévoir de nombreuses variantes de dialogues, des délais de réapparition et des conséquences cohérentes pour limiter la répétition. Les événements déjà uniques ne peuvent pas être tirés à nouveau.

Pour chaque action, créer un identifiant unique, enregistrer la journée, l’activité, le point consommé, la graine ou l’état aléatoire et le résultat avant sa présentation. Fermer, rouvrir, revenir en arrière ou appuyer deux fois ne permet ni de relancer le tirage ni de recevoir deux fois les 100 €. Une interruption après validation reprend le même résultat à la réouverture.

La page présente une courte animation et un son adapté, puis le résultat avec ses conséquences. En l’absence d’événement : retour explicite comme « Une sortie tranquille, rien de particulier aujourd’hui ». Consulter ensuite l’historique des actions et événements reste gratuit.
## 10.12. Relations présentes dans la ville

Les contacts connus peuvent proposer une rencontre dans un lieu concret : un café, un parc, un bar ou un établissement à visiter. Un investisseur peut demander à découvrir un commerce ; le frère peut proposer une sortie. L’agenda indique la date, le lieu et la préparation requise, et la ville peut afficher une bulle sur ce lieu.

La scène de rencontre présente le portrait, un contexte et des choix cohérents avec l’historique. Les personnages conservent la mémoire des engagements et échanges importants. La relation progresse par étapes lisibles : connaissance, confiance, amitié, relation professionnelle ou vie de couple selon le contexte.

La présence d’un personnage dans la ville ne débloque pas automatiquement son contact. La mère, le père, le frère et l’ex-femme restent les quatre seules personnes connues d’une nouvelle partie. Les sorties et rencontres volontaires respectent le budget commun de trois actions ; ouvrir la ville ou consulter une bulle ne crée pas un nouveau point de budget.


---

# 11. ÉVÉNEMENTS ET NARRATION SANDBOX

## 11.1. Principe

Après l'introduction, le jeu n'impose pas une histoire entièrement linéaire.

Les événements apparaissent en fonction de la situation actuelle.

## 11.2. Déclencheurs

Un événement peut dépendre :

- Du nombre de jours écoulés.
- Du type d’action personnelle choisie et de son tirage enregistré.
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

## 11.6. Tirage quotidien d’un événement de ville

**Chaque journée simulée comporte une probabilité de déclencher un événement**, indépendamment des actions personnelles du site de rencontre et du bar. Cette règle remplace un déclenchement systématique tous les trois jours. Une journée peut se terminer sans événement.

Proposition initiale d’équilibrage : **40 % de probabilité par journée**, paramétrable et à ajuster après essais. Ce pourcentage est une proposition, pas une valeur déjà imposée par le créateur. Le moteur effectue au maximum un tirage quotidien et ne choisit que parmi les événements compatibles avec l’état du joueur, leurs délais de réapparition et les événements uniques déjà traités.

Exemples : proposition de prestation pour un café, problème de fournisseur, visite d’un investisseur déjà rencontré, invitation d’un proche, petite trouvaille, occasion immobilière ou incident technique. Les résultats économiques et narratifs doivent être variés et reliés aux règles des systèmes existants.

Enregistrer la journée, l’état aléatoire ou la graine, le résultat du tirage, l’identifiant de l’événement obtenu ou l’absence d’événement. Relancer l’application ou consulter plusieurs fois le bilan ne doit pas produire un nouveau tirage pour la même journée. S’il n’existe aucun événement éligible, enregistrer une journée sans événement.

## 11.7. Pop-up d’événement et décisions

Lorsqu’un événement quotidien se déclenche pendant une journée jouée, une **fenêtre de choix apparaît au-dessus de la ville** après la simulation. Elle présente un titre, un visuel ou portrait adapté, le contexte, les personnes ou lieux concernés et les choix possibles. Chaque événement comprend au moins deux choix cohérents, dont une possibilité gratuite lorsque l’événement est facultatif et que le joueur pourrait manquer d’argent.

Les choix précisent leurs coûts, conditions et effets connus. Un choix indisponible est désactivé avec une explication. Les issues incertaines sont annoncées comme telles ; aucune promesse de bénéfice garanti ne doit être affichée si le résultat dépend d’un tirage.

Une seule fenêtre d’événement s’affiche à la fois. Le bilan quotidien, les messages et les autres événements ne doivent pas ouvrir plusieurs modales simultanément. Le bilan demeure consultable après les choix ou depuis l’historique. Le passage au jour suivant est temporairement désactivé tant que la fenêtre ouverte attend une décision ; si l’événement peut être reporté, une commande explicite permet de le ranger dans le journal et de reprendre le jeu.

La fermeture ou le report ne vaut jamais acceptation d’un choix. Une interruption ou un redémarrage conserve l’événement et la décision encore attendue. L’application enregistre le choix et ses conséquences dans une transaction unique ; un double appui ne débite, ne crédite et ne débloque rien une deuxième fois.

Un événement lié à une adresse peut aussi créer une bulle sur le bâtiment concerné. Toucher cette bulle ouvre l’événement existant ; cela ne déclenche pas un nouveau tirage.

## 11.8. Absence et file d’événements

Les journées calculées lors d’une absence suivent les mêmes tirages quotidiens. Les événements demandant un choix rejoignent une file persistante, sans réponse automatique à la place du joueur. Les dépenses ordinaires de simulation continuent selon les règles économiques ; aucune conséquence propre à un choix non effectué n’est appliquée comme s’il avait été accepté.

Au retour, afficher un récapitulatif et le nombre d’événements en attente. Proposer leur consultation un par un et leur journal, plutôt qu’une succession incontrôlée de fenêtres bloquant la navigation. Les règles d’expiration éventuelles sont définies par événement, présentées explicitement et ne permettent pas de recréer une récompense déjà obtenue. Une longue absence ne doit pas bloquer la simulation ni supprimer silencieusement les choix en attente.

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
## 12.5. Objectif personnel choisi par le joueur

Le joueur peut sélectionner un objectif principal parmi plusieurs parcours : ouvrir trois cafés, acheter sa première maison, développer ses relations ou constituer un portefeuille immobilier. Le suivi indique la prochaine étape réalisable, la progression et les conditions utiles, sans imposer une histoire linéaire.

Un seul objectif principal est épinglé dans l’interface de ville pour préserver sa lisibilité. Le joueur peut changer son objectif suivi sans perdre les étapes déjà accomplies. Les récompenses demeurent uniques : changer d’objectif ou le sélectionner à nouveau ne permet pas de les recevoir une deuxième fois.

Les objectifs personnels complètent les missions quotidiennes et les succès, avec des conditions utilisant les mêmes données de sauvegarde et sans compteur de progression fictif.


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

L’interface adopte une direction **jeu de gestion premium avec boutons arcade lumineux**, inspirée de la planche de référence fournie : contours biseautés, angles coupés ou formes hexagonales selon l’action, matière sombre ou métallique, liserés lumineux colorés, icônes lisibles et libellés courts en français.

La ville suit désormais la direction de ville de gestion détaillée, inspirée de SimCity et décrite au chapitre 7. La scène urbaine prime visuellement sur les cadres et les panneaux ; les boutons arcade restent concentrés sur les actions importantes. Les boutiques ont chacune leur décor, leur palette et leur ambiance. Les articles utilisent des photographies réelles. Ces trois univers doivent être articulés par une interface commune cohérente.

Le fond violet sombre `#171326`, l’accent `#9568EA` et la lavande `#EDE5FF` restent des repères de navigation. Des accents cyan, vert, ambre et magenta distinguent les familles d’actions. Les couleurs locales des boutiques ne sont pas limitées au violet.

La référence de boutons sert de guide visuel, pas de feuille de sprites à copier. Créer des composants originaux et adaptables aux tailles d’écran. Les encadrements ne doivent pas nuire à la lecture des comptes et des prix.

## 15.2. Navigation

L’accueil et la carte sont regroupés dans une seule destination principale : **Ville**. Après l’introduction et à la réouverture, le joueur y accède directement.

Organisation cible des cinq onglets :

1. Ville.
2. Empire.
3. Vie.
4. Patrimoine.
5. Finances.

Le tableau de bord financier existant rejoint Finances ; les fonctions de l’ancien accueil restent accessibles depuis l’interface de ville, la fiche Personnage et le journal. Les fonctionnalités économiques et sociales antérieures sont conservées.

Le portrait du protagoniste reste **en haut à gauche**, ouvrant la page Personnage. Sur les écrans secondaires, préserver la commande Retour. Les autres commandes de navigation ne recouvrent ni les bulles importantes ni le bouton de journée.

## 15.3. Écran principal Ville et bouton de journée

La scène urbaine remplit l’espace principal, sans être enfermée dans une petite carte au milieu d’une liste de panneaux. L’interface superposée reste légère :

- Portrait du protagoniste en haut à gauche.
- Jour, date et trésorerie lisibles en haut.
- Bénéfice prévu et actions restantes consultables sans encombrer la scène ; les comptes détaillés restent dans Finances.
- Bulles contextuelles au-dessus des lieux.
- Commandes de recentrage, filtres et accès au journal.
- Fiche compacte lorsqu’un commerce, une propriété ou un quartier est sélectionné.
- **Bouton « Passer au lendemain » fixé en bas au centre**, dans une zone stable au-dessus de la barre d’onglets et de la zone de sécurité de l’iPhone.

Le bouton de journée reste visible pendant le déplacement et le zoom. Son appui exécute une seule journée complète, puis met à jour la ville, les stocks, les comptes, les travaux et les bulles. Il ne génère jamais d’argent directement. Pendant le calcul, son état indique « Simulation… » et refuse les appuis supplémentaires.

En cas d’événement quotidien, la fenêtre de choix apparaît au-dessus de la ville selon le chapitre 11. Sinon, un retour visuel et sonore bref confirme la nouvelle journée ; le bilan reste accessible sans forcer une fenêtre à chaque passage.

La pile de billets peut rester un motif du bouton ou de l’identité graphique. Elle n’est plus tenue d’occuper le centre de l’accueil et ne remplace pas la ville. Toute avance de plusieurs jours est une action secondaire explicitement choisie, avec traitement cohérent de la file d’événements.

## 15.4. Écran Empire

Cet écran regroupe les secteurs, les types d’activités, les réseaux et les établissements individuels. Le bouton « Ouvrir un établissement » permet notamment de créer un nouveau café lorsqu’un café est déjà possédé.

Le joueur peut consulter les fiches d'entreprise, gérer leurs paramètres, recruter des employés et acheter des améliorations.

## 15.5. Navigation dans la ville et accès rapide

Les anciennes fonctions Carte sont intégrées à Ville. Le joueur doit pouvoir repérer les quartiers, sélectionner ses commerces et propriétés, identifier les emplacements disponibles et retrouver rapidement un établissement précis par recherche ou liste.

La sélection d’un lieu affiche sa fiche compacte au-dessus de la ville ; le détail de gestion s’ouvre à la demande et revient ensuite au même cadrage. Les bulles et le journal sont des accès à des états et événements existants, sans duplication de revenus ni de décisions.

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
- Catégories de boutiques et choix des magasins.
- Intérieurs immersifs et catalogues photographiques.
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

## 15.9. Système de boutons arcade

Créer une bibliothèque de boutons commune à tout le jeu, avec icône, libellé, rôle et états cohérents. Les boutons courants sont rectangulaires à coins coupés et bordure biseautée ; quelques actions majeures peuvent utiliser une forme hexagonale. Un relief discret et une double bordure produisent l’effet de cadre lumineux de la référence.

Proposition de correspondance : vert pour confirmer ou continuer, ambre pour acheter et entrer en boutique, cyan pour naviguer ou consulter l’inventaire, violet pour les paramètres et actions secondaires, magenta pour les succès et événements. Les actions destructives utilisent le rouge et demandent confirmation lorsque nécessaire.

Prévoir les états normal, pressé, sélectionné, désactivé, indisponible financièrement et en cours de traitement. À l’appui : léger enfoncement, diminution du relief et variation brève du liseré, avec son et haptique selon les paramètres. Une commande en cours ne peut pas se déclencher une deuxième fois.

Les zones tactiles mesurent au minimum 44 × 44 points. Les libellés s’adaptent à Dynamic Type ; l’icône et le texte permettent de comprendre l’action sans dépendre de la couleur. Les lueurs restent contenues : aucun clignotement permanent ni effet stroboscopique. La réduction de mouvement conserve un changement d’état immédiat et lisible.

## 15.10. Page Personnage

La page est accessible par l’icône en haut à gauche. Elle présente le portrait 3D cartoon du protagoniste, son prénom personnalisable et une synthèse de sa situation. La fiche de chaque autre personnage est ouverte depuis ses contacts, avec son propre portrait et ses statistiques relationnelles.

Pour le protagoniste, afficher au minimum :

- Jour et date du jeu.
- Trésorerie, fortune nette et dettes, clairement séparées.
- Réputation professionnelle et statut social.
- Nombre d’établissements, de propriétés et de biens personnels.
- Nombre de contacts réellement connus, situation de couple et famille.
- Clients servis, bénéfices cumulés et objectifs ou succès obtenus.
- Budget d’actions restant et éventuelles réservations de la journée.

Les statistiques proviennent de la sauvegarde et des calculs du jeu ; aucun indicateur de démonstration ne doit être inventé. La page fournit des raccourcis vers Actions, Finances, Relations et la personnalisation du personnage. Les grandes tailles de texte et VoiceOver restent utilisables.

## 15.11. Présentation de la page Actions

Afficher une carte illustrée pour le site de rencontre et une autre pour le bar, un bouton arcade de lancement, le coût d’une action et le compteur restant. Préciser qu’un événement n’est pas garanti. Les détails peuvent présenter les probabilités indicatives et les conditions d’éligibilité de l’activité.

Un résultat s’affiche dans une fiche dédiée, avec portrait en cas de rencontre, choix narratifs éventuels et résumé des effets. Une nouvelle connaissance apparaît immédiatement dans les contacts après enregistrement. La fermeture de cette fiche ne supprime pas un résultat en attente de choix. Un historique daté permet de revoir les rencontres, les occasions manquées et les gains obtenus.
## 15.12. Premières minutes et apprentissage progressif

Après l’introduction narrative, un premier service guidé accompagne cinq étapes : régler un prix, préparer une commande d’ingrédients, terminer un service, lire son bénéfice puis choisir une première activité personnelle. Les explications sont courtes, contextuelles et reliées aux vraies commandes de jeu.

L’apprentissage doit pouvoir se terminer avec les 100 € et les stocks initiaux. Il prend en compte le délai réel de livraison : une commande n’est pas livrée instantanément pour faire réussir une étape. Il ne demande pas d’acheter une amélioration ou un bien inaccessible au joueur débutant.

Présenter les systèmes avancés au moment où ils deviennent utiles. Une aide consultable et une commande permettant de passer les explications évitent de bloquer les joueurs expérimentés ; leurs actions et leur progression restent conservées.

L’interface de ville doit répondre rapidement à « Que puis-je faire maintenant ? » : alerte de stock, préparation du service, action personnelle disponible ou prochain objectif. Les détails de gestion restent accessibles à la demande, sans multiplication de panneaux permanents.


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

SwiftUI gère les interfaces, les boutons arcade et les transitions. SceneKit gère la ville 3D et les éventuels intérieurs 3D, sans exécuter la simulation économique.

SpriteKit est utilisé pour les animations de particules et les éléments visuels plus complexes.

## 16.3. Audio et sensations tactiles

Les interactions doivent donner un retour **satisfaisant, précis et varié**. Utiliser des sons courts, propres et préchargés, synchronisés avec l’appui ou la validation effective de l’action.

| Interaction | Son attendu | Retour tactile |
|---|---|---|
| Appui sur un bouton ou sélection | Clic net et discret | Léger |
| Entrée dans une boutique | Transition courte, adaptée à son univers | Léger, facultatif |
| Achat enregistré | Confirmation riche et courte, adaptée au type d’article | Confirmation distincte |
| Ouverture d’un établissement | Signature de réussite plus marquée | Succès |
| Amélioration, objectif ou déblocage | Montée sonore brève et gratifiante | Succès |
| Fonds insuffisants ou action refusée | Son bref et feutré, sans agressivité | Avertissement |
| Passage de journée | Transition douce, puis bilan | Léger |

Chaque boutique peut disposer d’une ambiance discrète propre à son style : atelier automobile, showroom feutré, bijouterie, galerie ou marina. Les transitions sonores se fondent entre elles et ne superposent pas plusieurs musiques.

Les variations évitent la répétition mécanique lors des appuis rapides. Limiter les voix simultanées et la fréquence des sons ; l’avance de plusieurs journées produit un retour synthétique et non une rafale de notifications. Précharger les effets pour éviter un délai perceptible et tester leur synchronisation sur iPhone.

Prévoir des réglages indépendants pour la musique, les ambiances, les effets et les vibrations, avec niveaux sonores ajustables. Respecter le mode silencieux et les interruptions audio du système. Aucun son ne doit être indispensable à la compréhension d’une action. Les fichiers doivent avoir une provenance et des droits documentés, comme les photographies.

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

- Personnage et référence de son portrait.
- Jour du budget d’actions, points utilisés, réservations datées et historique des tirages.
- État connu/inconnu, date et origine de rencontre de chaque contact.
- Date actuelle.
- Trésorerie.
- Fortune.
- Types d’activités, réseaux, établissements identifiés et parcelles occupées.
- Boutiques, offres, instances d’articles possédés et références des photographies locales.
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
- Événements, résultats des tirages quotidiens et file des choix en attente.
- Segments de clientèle, réputation locale et avis des établissements.
- Enseignes rivales, promotions et implantations simulées.
- Événements locaux datés, météo et prévisions enregistrées.
- Équipements visibles, disposition des biens personnels, objectif suivi et progression du tutoriel.
- Politiques des managers et plans économiques groupés confirmés.
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
- SceneKit pour la ville 3D, sous réserve de vérification du SDK retenu.
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
11. Déclencher les événements éligibles, en conservant un seul tirage quotidien. Les prévisions, événements de quartier, promotions et segments de clientèle doivent avoir été actualisés avant le calcul de la demande ; les avis sont calculés à partir du service réellement exécuté.
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

Séparer les modèles `BusinessType`, `BusinessInstance`, `BusinessNetwork`, `CityPlot`, `ShopCategory`, `Shop`, `ShopOffer`, `ItemDefinition`, `OwnedItem` et `MediaAsset`. Un identifiant de type ne doit plus servir d’identifiant unique d’établissement. Les références de parcelle, de personnel, de commandes et de bilans visent l’instance appropriée.

Ajouter les modèles `CharacterProfile`, `KnownContact`, `DailyActionBudget`, `ActionReservation`, `ActionDefinition`, `ActionOutcome` et `ActionRecord`. Les portraits sont des ressources référencées ; les quatre contacts initiaux sont définis explicitement. Les résultats aléatoires et leurs récompenses sont idempotents et persistés, pas recalculés par l’interface. Pour une partie déjà commencée, préserver les contacts et événements existants lors de la migration ; la règle des quatre contacts concerne les nouvelles parties.

Les styles de boutiques et de boutons sont définis dans des composants et données réutilisables. Le moteur ne dépend ni de SceneKit ni des photographies. Prévoir une migration de la sauvegarde existante : chaque entreprise actuelle devient un établissement du type correspondant ; les biens personnels sont convertis en instances possédées, sans perte de progression ni duplication d’actifs.

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

## 19.5. Validation de la refonte

Tester l’ouverture de plusieurs établissements identiques, l’indépendance des paramètres et stocks, l’occupation exclusive des parcelles, les effets de concurrence locale, les consolidations sans doublon et les synergies non cumulées abusivement. Tester également la migration d’une sauvegarde de la version précédente.

Pour les boutiques : valider les catégories, les catalogues, la navigation entrée/retour, l’identité visuelle de chaque intérieur, les achats répétés autorisés ou interdits, les doubles appuis, les débits uniques et la collection après redémarrage. Vérifier la présence d’une photographie autorisée et correctement associée à chaque article, le chargement hors ligne et l’usage mémoire lors de l’ouverture successive de plusieurs magasins.

Sur iPhone : vérifier les gestes de caméra, la sélection des bâtiments, les performances de la ville, les boutons en grande taille de texte, le contraste, l’absence de dépendance à la couleur, les sons lors d’appuis rapides, le mode silencieux et la désactivation des effets et haptiques. Une revue visuelle doit comparer la ville et les boutons aux références de direction artistique ; de simples tests économiques ne valident pas ce rendu.

## 19.6. Tests du personnage et des actions

Vérifier la présence de quatre contacts exactement dans une nouvelle partie et l’absence des autres dans le carnet, les messages et l’agenda. Vérifier les portraits et les statistiques de la fiche Personnage, ainsi que l’accès en haut à gauche sur les cinq écrans principaux.

Tester trois actions successives et le refus de la quatrième ; mélanger les deux activités ; compter une action sans événement ; ne rien décompter en cas d’annulation ou d’échec avant validation. Tester le changement manuel et automatique de journée, les journées hors ligne, l’absence de cumul, les réservations de rendez-vous et l’impossibilité de contourner la limite depuis une autre page.

Avec une graine fixe, vérifier le déterminisme des résultats et l’exclusion des événements incompatibles, puis contrôler statistiquement les poids sur de nombreux tirages avec une tolérance définie. Vérifier la somme de 100 %, les catégories vides reportées sur l’absence d’événement et les événements uniques.

Simuler une interruption avant et après l’enregistrement : une action payée conserve son résultat, une nouvelle rencontre ne duplique pas le personnage et une trouvaille de 100 € n’est créditée qu’une fois. Vérifier qu’une rencontre d’investisseur ne débloque pas un financement sans acceptation. Tester le tout sans réseau.

## 19.7. Validation de la ville principale et des événements quotidiens

Vérifier l’arrivée directe dans Ville après introduction et réouverture, la présence du bouton en bas au centre avec les zones de sécurité et les grandes tailles de texte, la conservation de la caméra lors des sélections, ainsi que l’alternative en liste et VoiceOver.

Tester les bulles avec des stocks réellement bas, une livraison, des travaux et un événement ; vérifier leur suppression ou mise à jour après résolution, leur regroupement au dézoom et l’absence de revenus supplémentaires au toucher. Contrôler l’identification distincte des cafés d’un même réseau et des biens immobiliers.

Pour les événements quotidiens : vérifier un seul tirage par journée, un résultat déterministe à graine fixe, les journées sans événement, les conditions d’éligibilité, les délais de réapparition, les événements uniques et la distinction avec les trois actions personnelles. Tester les choix indisponibles, le report, les doubles appuis, la fermeture pendant la sauvegarde et la reprise de la même décision après redémarrage.

Simuler plusieurs journées et une longue absence : aucune avalanche de fenêtres, aucun choix automatique, aucune récompense dupliquée et aucune perte silencieuse d’événement en attente. Vérifier la file de présentation entre récapitulatif d’absence, événement et bilan.

Une revue visuelle sur appareil doit comparer l’expérience exécutée à la référence : diversité des volumes et façades, densité, quartiers reconnaissables, routes continues, circulation cohérente, sélection et lisibilité. Mesurer les performances au niveau de détail maximal puis en mode réduit, avec un empire développé. Une validation du moteur seul ou une capture statique ne suffit pas.

## 19.8. Tests des systèmes enrichis de la ville

Vérifier les variations de demande par segment, horaire, jour et saison, la répartition de la clientèle entre établissements, les contraintes de capacité et de stocks, ainsi que les causes réelles des avis. Les améliorations visibles doivent correspondre aux équipements acquis et à leurs effets actifs.

Tester les dates d’événements locaux, les routes fermées et leur réouverture, les prévisions météo, les secteurs affectés et le maintien des valeurs de base des quartiers. Avec une même graine, un passage manuel et une absence doivent produire les mêmes conditions journalières avant application du rendement hors ligne.

Tester les enseignes rivales, leurs promotions bornées et les parcelles réservées, sans double calcul de concurrence ou mutation rétroactive des journées. Pour la gestion groupée : contrôler la prévisualisation, le budget total, l’unicité des commandes, les délais de livraison et le refus sans exécution partielle silencieuse lorsque le plan est invalide.

Vérifier les rencontres localisées et leur budget d’actions, les étapes de relations, les objets placés dans les intérieurs sans duplication patrimoniale, le changement d’objectif sans récompense répétée et le premier service guidé avec le capital initial réel. Les animations réduites doivent conserver exactement les mêmes résultats économiques.

## 19.9. Performances

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
- Volume indépendant de la musique, des ambiances de boutiques et des effets.
- Réinitialisation de la sauvegarde.

L'application doit respecter la taille de texte et les préférences de réduction de mouvement lorsque c'est possible.

Les notifications doivent être facultatives et nécessiter l'autorisation de l'utilisateur.

---

# 21. CONTENU MINIMAL DE LA VERSION COMPLÈTE

La première version complète demandée à Codex doit contenir :

- Une introduction narrative fonctionnelle.
- Un personnage principal personnalisable avec sa fiche statistique accessible en haut à gauche.
- Un portrait 3D cartoon distinct pour chaque personnage.
- Exactement quatre contacts initiaux : mère, père, frère et ex-femme.
- Une page Actions comprenant un site de rencontre fictif et un bar.
- Trois actions maximum par journée, avec événements probabilistes, historique et protections contre les doublons.
- Le food truck Tasty Crousty jouable.
- Un calendrier quotidien.
- La progression automatique et hors ligne.
- Un moteur économique opérationnel.
- Au moins 40 types d’activités répartis en secteurs.
- Plusieurs établissements indépendants d’un même type, notamment plusieurs cafés, et gestion des réseaux.
- Des entreprises améliorables jusqu'au niveau 100.
- Des synergies automatiques.
- Des employés et managers.
- Une ville 3D de gestion détaillée inspirée de SimCity, utilisée comme écran principal.
- Des quartiers et commerces reconnaissables, des propriétés sélectionnables, du trafic et des piétons.
- Des bulles interactives ancrées aux bâtiments et un bouton de journée fixé en bas au centre.
- Un tirage probabiliste quotidien d’événement, une fenêtre avec choix et une file persistante pour les absences.
- Des quartiers avec des caractéristiques fixes.
- Des biens immobiliers achetables.
- Un système locatif avec choix des loyers.
- Des rénovations et travaux différés.
- La revente immobilière.
- Un espace de boutiques regroupées par catégorie, avec plusieurs magasins par catégorie.
- Des intérieurs et une direction artistique distincts pour chaque magasin.
- Des photographies réelles et autorisées pour chaque article, consultables hors ligne.
- Des boutons arcade biseautés et lumineux, ainsi que des sons tactiles satisfaisants.
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
- Des clients aux habitudes différenciées et des avis liés aux performances réelles.
- Des améliorations visibles et des commerces, logements et garages visitables.
- Des événements de quartier, une météo et des saisons avec prévisions et effets bornés.
- Des concurrents identifiables et une gestion rapide des réseaux.
- Des rencontres localisées, un objectif personnel suivi et un apprentissage progressif.
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
6. Intégrer la ville 3D avec SceneKit selon le SDK retenu, et SpriteKit pour les effets avancés.
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

Si certains éléments nécessitent des ressources externes indisponibles, des ressources locales de remplacement peuvent servir au développement, avec leurs limites signalées. Pour les photographies réelles d’articles, les remplacements ne satisfont pas la livraison finale : identifier les visuels et autorisations encore manquants.
## 22.1. Réalisation et build à suivre par Codex

Le protocole détaillé est fourni dans **[CODEX_BUILD.md](CODEX_BUILD.md)** : état des lieux du dépôt, ordre de réalisation, ressources nécessaires, validations du moteur, build Xcode, tests sur simulateur et revue visuelle sur appareil.

Les priorités de réalisation sont : ville principale et lisibilité, clientèle et améliorations visibles, événements de quartier, puis intérieurs, relations localisées et outils de gestion d’empire. Les dix enrichissements acceptés restent tous dans la cible ; cet ordre ne les transforme pas en fonctionnalités facultatives.

Codex doit distinguer une source écrite, une syntaxe vérifiée, un moteur testé, une application compilée et une application exécutée et examinée sur iPhone. Il ne peut pas annoncer une ville conforme à la référence sur la seule base de tests économiques. Si la machine est sous Linux, terminer les travaux possibles et rapporter explicitement la validation Apple restant à effectuer.


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
17. Ouvrir deux cafés de même type, avec deux identifiants et deux emplacements distincts ; modifier l’un sans modifier l’autre et consulter un bilan consolidé sans revenus dupliqués.
18. Sélectionner chacun de ces cafés dans la ville 3D, en déplaçant et zoomant la caméra.
19. Parcourir une catégorie de Patrimoine, choisir entre plusieurs boutiques et entrer dans des intérieurs visuellement distincts.
20. Consulter pour chaque article une vraie photographie correspondant au produit, y compris hors connexion, avec provenance documentée.
21. Acheter un article une seule fois par confirmation, le retrouver dans sa collection et bénéficier d’un retour sonore et tactile approprié.
22. Utiliser les boutons arcade dans leurs différents états, désactiver les effets et conserver une interface lisible avec la réduction de mouvement et les grandes tailles de texte.
23. Charger une sauvegarde antérieure à la refonte sans perte de trésorerie, d’établissements, de biens ou de relations.
24. Ouvrir sa fiche Personnage depuis l’icône en haut à gauche et consulter ses statistiques réelles.
25. Commencer avec uniquement sa mère, son père, son frère et son ex-femme dans les contacts, sans aucun ami ni investisseur déjà connu.
26. Voir des portraits 3D cartoon distincts et cohérents pour tous les personnages rencontrés.
27. Effectuer au plus trois actions dans une journée, réparties librement entre le site de rencontre et le bar ; un résultat sans événement consomme aussi une action.
28. Retrouver le même compteur et le même résultat après redémarrage, sans nouveau tirage ni double récompense.
29. Récupérer trois actions au lendemain, sans cumul des actions inutilisées ni exécution automatique de sorties durant l’absence.
30. Découvrir de nouveaux contacts et des opportunités selon des tables d’événements éligibles, avec des gains exceptionnels distincts des ventes des entreprises.
31. Arriver directement dans une ville vivante après l’introduction et à la réouverture, avec quartiers, commerces et silhouettes architecturales lisibles.
32. Utiliser le bouton de journée fixé en bas au centre tout en conservant le cadrage de la ville ; les doubles appuis n’exécutent qu’une simulation.
33. Toucher une bulle pour consulter le bon établissement, chantier, message ou événement, sans créditer une deuxième fois un revenu.
34. Obtenir un événement selon un tirage quotidien sauvegardé, choisir une réponse dans une fenêtre et constater ses conséquences une seule fois.
35. Retrouver après redémarrage les événements en attente et les journées déjà tirées, y compris après une longue absence.
36. Vérifier sur appareil la conformité visuelle de la ville à la direction de la référence et la lisibilité des commandes, bulles et quartiers aux différents niveaux de zoom.
37. Comprendre sa clientèle et les causes de ses avis, puis constater les effets d’un réglage ou d’un équipement acquis.
38. Anticiper un événement de quartier ou une météo prévue et constater leur début et leur fin sans modification des caractéristiques de base du quartier.
39. Identifier des rivaux et comparer ou préparer des commandes pour plusieurs établissements avec un coût total confirmé et sans double achat.
40. Visiter ses commerces, son logement et son garage et y retrouver les acquisitions réellement possédées.
41. Participer à une rencontre dans un lieu de la ville sans contourner le budget de trois actions.
42. Choisir puis changer un objectif personnel sans perdre ses étapes ou répéter une récompense.
43. Terminer le premier parcours guidé avec les 100 € et stocks initiaux, en respectant les délais de livraison.

L'ensemble doit fonctionner sur iPhone, sans connexion Internet obligatoire.

---

# 24. DÉCISIONS CONSOLIDÉES ET ARBITRAGES

Les décisions explicitement validées par le créateur sont prioritaires.

Certains points ont évolué depuis le concept initial :

**Le clic :** initialement source directe de revenus, il sert à faire avancer le calendrier et à déclencher les résultats économiques via le bouton de journée de la ville.

**Les revenus passifs :** ils sont désormais calculés à partir des journées simulées plutôt qu'à partir d'un simple compteur par seconde.

**Le gameplay :** initialement centré sur les améliorations, il inclut maintenant une véritable gestion des entreprises, des stocks et des relations.

**L'immobilier :** ce n'est plus seulement une catégorie de dépenses ou un secteur commercial. C'est un système complet d'investissement locatif et de valorisation.

**La narration :** l'introduction reste scénarisée, puis le joueur évolue librement dans un monde sandbox.

**Le magasin :** les biens de luxe servent à la collection et peuvent aussi débloquer des avantages ou des événements.

**La progression :** elle reste continue, sans prestige, avec des expansions de fin de jeu.

**La première livraison :** le projet complet est demandé en une seule mission Codex. Cela n'empêche pas l'agent d'organiser ses modifications internes par modules pour garantir la cohérence et les tests.

**Établissements multiples :** les 40 entrées minimum définissent des types d’activités. Le joueur peut créer plusieurs établissements du même type et constituer une chaîne.

**Ville :** la nouvelle référence de ville de gestion dans l’esprit de SimCity remplace l’objectif précédent de petite ville low poly. Une vraie scène 3D détaillée devient l’écran principal, avec quartiers, commerces, propriétés, trafic et piétons. Une simple image de fond ou des blocs uniformes ne satisfont pas cette cible.

**Fin de journée :** la commande principale est fixée en bas au centre au-dessus des onglets. Le clic avance la simulation ; la pile de billets reste facultative comme motif et n’occupe plus obligatoirement le centre de l’accueil.

**Bulles et événements de ville :** les lieux possèdent des bulles contextuelles liées à leurs états réels. Chaque journée comporte un tirage d’événement, avec fenêtre de choix si un événement est obtenu. Le taux de 40 % est une proposition d’équilibrage ; le caractère quotidien et probabiliste ainsi que la présentation des choix sont des exigences validées. Ces événements ne consomment pas automatiquement les trois actions personnelles.

**Boutiques :** Patrimoine est organisé en catégories comprenant plusieurs magasins. Chaque magasin possède un intérieur et une direction artistique spécifiques.

**Articles :** les photos réelles correspondant aux produits sont requises ; les modèles et marques réels comme Porsche sont envisageables avec les ressources et droits appropriés. Les enseignes fictives des boutiques restent distinctes des marques des produits.

**Boutons et sensations :** la planche arcade lumineuse remplace le minimalisme strict pour les boutons. Les appuis, achats et succès disposent de sons et retours tactiles adaptés, désactivables.

**Personnage et entourage :** la fiche statistique s’ouvre via le portrait en haut à gauche. Les nouvelles parties commencent uniquement avec la mère, le père, le frère et l’ex-femme. Les autres contacts doivent être rencontrés.

**Portraits :** tous les personnages utilisent des portraits illustrés 3D cartoon dans le style de la référence, avec une identité propre. L’exigence de vraies photographies concerne les articles de boutique, pas les personnages.

**Actions quotidiennes :** le site de rencontre fictif et le bar partagent trois actions par jour de jeu. Chaque action validée déclenche un tirage persistant ; un événement n’est pas garanti. Les probabilités proposées sont des valeurs d’équilibrage, tandis que la limite de trois et les deux activités sont des exigences validées. La monnaie reste l’euro.

**Ville enrichie :** les dix propositions sont intégrées à la cible : habitudes de clientèle, améliorations visibles, événements locaux, avis clients, rivaux, intérieurs visitables, relations dans la ville, objectif personnel, météo et saisons, gestion rapide de plusieurs commerces. Les conditions de base des quartiers restent fixes ; les effets variables sont des modificateurs séparés et sauvegardés.

**Réalisation Codex :** appliquer le protocole de build et de validation sans confondre compilation, tests du moteur et conformité visuelle sur appareil. Le présent travail de documentation ne constitue ni une réalisation de ces nouveautés ni une validation de build.

Les choix non définitivement tranchés, comme le contenu exhaustif des catalogues, les noms des personnages et certaines valeurs d'équilibrage, doivent être résolus par des propositions cohérentes avec ce document, sans supprimer les fonctionnalités validées.

---

# 25. VISION FINALE

Business Clicker doit donner au joueur l'impression de construire progressivement une vie entière.

Il commence avec un petit food truck peu rentable, des ressources limitées et une situation personnelle difficile.

Il apprend à gérer ses finances, à satisfaire ses clients, à développer son réseau et à prendre des décisions.

Il ouvre ensuite des commerces, acquiert des propriétés, investit dans l'immobilier, recrute des collaborateurs et découvre de nouveaux secteurs.

En parallèle, sa vie personnelle évolue. Il rencontre des personnages, développe des amitiés, construit des relations et peut fonder une famille.

Ses choix économiques et personnels influencent les événements qu'il rencontre.

Au fil des jours, son patrimoine grandit et sa ville se transforme.

Le joueur parcourt une ville vivante qui constitue le cœur de l’expérience : quartiers, commerces, lieux de vie et opportunités rendent son évolution visible. Il peut finalement diriger un vaste empire tout en conservant la possibilité de gérer individuellement ses activités.

**L'objectif n'est pas simplement de devenir riche : c'est de simuler le parcours complet d'un entrepreneur, de ses premières difficultés jusqu'à la construction d'un empire économique et personnel.**
