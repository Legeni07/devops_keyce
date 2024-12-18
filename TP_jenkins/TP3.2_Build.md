### Projet build

1. Forker le projet github [suivant](https://github.com/Legeni07/alpinehelloworld)
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

	##### Correction des Erreurs ######
	- Intaller les plugins de docker
	- entrer dans le conteneur jenkins en cmd avec la cmd :
		sudo docker exec -it -u root  jenkins-install_jenkins_1 bash
	
	puis executer les cmd :
		##Add the jenkins user to the docker group #
		apt-get update
		apt-get install -y docker.io
		groupadd -f docker
		usermod -aG docker jenkins


		# Verify group membership
		groups jenkins
	Sur la machine Hote
	sudo chmod 666 /var/run/docker.sock
	Pour lundi : installer MINIKUBE

	TP :
	- Installation de de wordpress avec docker compose
	- Installation de Odoo16 avec Docker compose 
	- Creer un Job pour faire build et deploy de l'application webapp du precedent TP 
	