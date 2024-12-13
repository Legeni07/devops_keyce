### Projet build

1. Forker le projet github [suivant](https://github.com/heroku/alpinehelloworld)
2. Modifier le fichier Dockerfile avec celui ci https://eazytraining.fr/wp-content/uploads/2023/12/Dockerfile.txt 
2. Dans Jenkins, créer ***un projet freestyle*** qui s'appelle **Build**
	###### Procédure: **new item** → **nom = build** → **freestylejob** → **OK**
	-  Description → Ce build a des paramètres → String parameter → Rajouter trois string 
         - **IMAGE_NAME**: *alpinehelloworld*
         - **IMAGE_TAG**: *latest*
         - **Votre_ID_Github**: *Legeni07*
	- Ne pas cocher de gestionnaire de versionning
	- Dans la partie **build**, ***executer un script shell*** et mettre le code suivant: 
		```bash 
		 #!/bin/bash
		git clone https://github.com/${Votre_ID_Github}/alpinehelloworld.git
		cd alpinehelloworld
		docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
		```
	- Appuyer sur **save**
	- Appuyer sur **Build with parameters** , puis sur **Build**