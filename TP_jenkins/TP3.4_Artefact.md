##### Projet Artefact
1. Créer un compte sur le [dockerhub](https://hub.docker.com/)
2. Installer le plugin **docker-build-step**
3. Configurer le plugin **docker-build-step** pour qu'il puisse communiquer avec Docker
	###### Procédure:
	- **Manage jenkins** → **Configure system** → **Docker Builder** → **renseigner la socket unix** (```unix:///var/run/docker.sock```)
	- Tester la connectivité
4. Définir un crédential dans Jenkins qui va représenter nos identifiants docker
	**Manage jenkins** → **Security** → **Manage credentials** → **global** → **add credentials** → **username/password**	
5. Créer un job **freestyle** ou utiliser celui déja existant. Ce job devra faire tout ce que faisait le job précédent, mais avec une étape supplémentaire qui est **l'envoie de l'image dans le registre dockerhub**
   -  Pour envoyer une image dans **dockerhub**, elle doit etre ***préfixée de votre login dockerhub***. Pour celà, modifier l'étape de build qui créé l'image et qui lance le container. On aura ceci:
		```bash			
		#!/bin/bash
		docker build -t ${votre_id_dockerhub}/${IMAGE_NAME}:${IMAGE_TAG} .
		docker run -d -p 80:5000 -e PORT=5000 --name ${IMAGE_NAME} ${votre_id_dockerhub}/${IMAGE_NAME}:${IMAGE_TAG} 
		sleep 5
		```

   - En plus des paramètres précédents, le job aura un **paramètre string** supplémentaire nommé ```dockerhub_id```, qui contiendra votre id dockerhub.

   
   - Aussi, dans votre Job, rajouter une nouvelle **étape de build** qui utilise le plugin **Docker** installé (**Exécuter une commande docker**) comme suit: 
     - **command**: push image
     - **name**: **${DOCKERHUB}/\${IMAGE_NAME}**
     - **Tag**: **${IMAGE_TAG}**
     - **Docker registry URL**: https://index.docker.io/v2/
     - **registry credentials**: ***secret nouvelle créé***
   - Lancer le Build et une fois terminée, vérifier que l'image est disponible sur **dockerhub**