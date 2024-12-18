#!/bin/bash

# Mise à jour des packages
apt-get update

# Installation de Java 8
apt-get install -y openjdk-8-jdk

# Vérification de la version de Java
java -version

# Installation de vim
apt-get install -y vim
alias vi=vim

# Création du fichier .bash_profile
mkdir -p ~/.bash_profile

# Configuration des variables d'environnement Java
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bash_profile
echo "export JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre" >> ~/.bash_profile

# Rechargement du profil
source ~/.bash_profile
source /root/.bash_profile

# Affichage du JAVA_HOME
echo $JAVA_HOME

# Installation de wget
apt-get install -y wget

# Installation des dépendances
apt-get install -y software-properties-common

# Ajout du dépôt Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Mise à jour des packages après l'ajout du dépôt
apt-get update

# Installation de Jenkins
apt-get install -y jenkins

# Installation de Nginx
apt-get install -y nginx

# Nettoyage
apt-get clean
rm -rf /var/lib/apt/lists/*