#### Projet test-acceptance
1. Installer le plugin **HTTP request** pour faire le test. 
###### Procédure: 
Dans la partie **administration jenkins**, faire ceci:	→ **gestion des plugins** → ***installer le plugin HTTP request***

2. Créer un projet freestyle qui s'appelle  **test-acceptance**
###### Procédure:
Dans jenkins → **new item** → **nom = test-acceptance** → **freestylejob** → OK
:warning: vous puvez aussi créer ce nouveau job en copiant le précédent pour aller vite
- **Description** → **Ce build a des paramètres** → **String parameter** → 
	○ Rajouter deux string 
  - **IMAGE_NAME** :  *alpinehelloworld*
  - **IMAGE_TAG** : *latest*
  - **Votre_ID_GIT** : ...
- Dans la partie **Gestion de code source**
	Cocher le versionning git et spécifier l'url https://github.com/${Votre_ID_GIT}/alpinehelloworld.git
- Dans la partie **build**, créer une nouvelle step de type **executer un script shell** et mettre le code suivant :  
	```bash
	#!/bin/bash
	docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
	docker rm -f ${IMAGE_NAME}
	docker run -d -p 80:5000 -e PORT=5000 --name ${IMAGE_NAME} ${IMAGE_NAME}:${IMAGE_TAG} 
	sleep 5
	```	

3. Toujours dans la partie **build**, ajouter une nouvelle étape de test (la deuxième) qui utilise le plugin **http-request**
   - Http mode: GET 
   - URL: http://172.17.0.1
   - Dans avancé, mettre le code **200** dans la plage de code réponse attendu et laisser les autres paramètres par défaut

4. Toujours dans la partie **build**, ajouter une nouvelle étape (la troisième) qui **execute un script shell** et mettre le code suivant :  
	```bash
	#!/bin/bash
	#curl http://172.17.0.1 | grep -q "Hello world!"
	docker stop ${IMAGE_NAME}
	docker rm  ${IMAGE_NAME}
	```