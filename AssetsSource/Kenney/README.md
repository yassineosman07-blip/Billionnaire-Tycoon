# Kenney — ressources fournies par le créateur

Sources originales : Kenney (https://kenney.nl), City Kit Commercial 2.1 et Animated Characters Retro 1.1. Les archives fournies sont conservées sans modification, avec SHA-256 dans provenance.json. Licences CC0-1.0, autorisant l’usage commercial. Les textes de licence d’origine sont également embarqués dans Resources/Kenney.

L’application embarque les 41 modèles OBJ, leurs MTL et palette du pack commercial. Pour les passants uniquement : deux textures humaines et quatre Collada (homme/femme × idle/run), convertis depuis le rig et les animations du pack rétro. Les zombies restent uniquement dans l’archive source et ne sont pas copiés dans l’application. Les portraits des personnages importants sont indépendants.

Conversion reproductible : Blender 4.3 avec import/export FBX et libassimp 5.4.3 installé, puis `blender --background --factory-startup --python scripts/convert-kenney-pedestrians.py`. La conversion conserve 58 articulations et 59 canaux d’animation par fichier. `python3 scripts/validate-kenney.py` contrôle les empreintes, les références de matériaux et textures, les riggings et l’exclusion des zombies à l’exécution.

Le pack ne fournit pas de cycle nommé walk : le cycle run est ralenti pour les déplacements ambiants ; idle sert au mode réduit. L’affichage et les animations doivent être vérifiés dans SceneKit. L’import FBX seul ou la validité XML ne certifient pas le rendu Apple.
