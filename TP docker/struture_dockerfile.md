Voici les instructions les plus courantes utilisées dans un fichier Dockerfile :

1. FROM : Spécifie l'image de base pour la nouvelle image.
2. MAINTAINER : Spécifie le nom et l'adresse e-mail du mainteneur de l'image.
3. RUN : Exécute une commande shell pendant la construction de l'image.
4. COPY : Copie des fichiers depuis le répertoire courant vers l'image.
5. ADD : Copie des fichiers depuis le répertoire courant vers l'image, en décompressant les archives si nécessaire.
6. ENV : Définit une variable d'environnement pour l'image.
7. EXPOSE : Spécifie les ports que le conteneur écoute.
8. CMD : Spécifie la commande par défaut à exécuter lorsque le conteneur est démarré.
9. ENTRYPOINT : Spécifie la commande à exécuter lorsque le conteneur est démarré, en remplacement de la commande par défaut.
10. VOLUME : Spécifie un répertoire qui doit être monté comme un volume dans le conteneur.
11. WORKDIR : Spécifie le répertoire de travail pour les instructions suivantes.
12. USER : Spécifie l'utilisateur qui doit être utilisé pour exécuter les instructions suivantes.
