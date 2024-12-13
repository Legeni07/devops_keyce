TP Complet : Pipeline CI/CD Jenkins pour Addons Odoo
Préparation de l'Environnement
Étape 0 : Prérequis Système
bashCopy# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation des dépendances de base
sudo apt install -y \
    git \
    curl \
    wget \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release
Étape 1 : Installation de Docker
bashCopy# Installer Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Ajouter l'utilisateur au groupe docker
sudo usermod -aG docker $USER
Étape 2 : Installation de Docker Compose
bashCopy# Télécharger Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Rendre exécutable
sudo chmod +x /usr/local/bin/docker-compose

# Vérifier l'installation
docker-compose --version
Étape 3 : Installation de Java et Jenkins
bashCopy# Installer Java
sudo apt install -y openjdk-11-jdk

# Importer la clé Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# Ajouter le dépôt Jenkins
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Installer Jenkins
sudo apt update
sudo apt install -y jenkins

# Démarrer Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
Configuration Initiale de Jenkins
Étape 4 : Première Connexion

Ouvrir un navigateur à http://localhost:8080
Récupérer le mot de passe initial

bashCopysudo cat /var/lib/jenkins/secrets/initialAdminPassword

Suivre l'assistant d'installation
Installer les plugins recommandés

Étape 5 : Plugins Essentiels
Plugins à installer manuellement :

Git Plugin
GitHub Plugin
Docker Pipeline
Python Plugin
Credentials Plugin

Ou via ligne de commande :
bashCopy# Script d'installation de plugins
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ install-plugin \
    git \
    github \
    docker-workflow \
    python \
    credentials
Étape 6 : Configuration GitHub
6.1 Créer un Token GitHub

GitHub > Settings > Developer Settings
Personal Access Tokens > Generate New Token
Cocher :

repo (contrôle des dépôts privés)
admin:repo_hook
user



6.2 Ajouter les Credentials dans Jenkins

Gérer Jenkins > Manage Credentials
Domaine global > Ajouter des credentials
Type : Secret text
Secret : Coller le token GitHub
ID : github-token

Préparation du Projet Odoo
Étape 7 : Structure du Projet
bashCopymkdir -p odoo-custom-addons/custom_module/tests
cd odoo-custom-addons

# Structure du module
touch custom_module/__init__.py
touch custom_module/__manifest__.py
touch custom_module/models.py
touch custom_module/tests/test_module.py
Étape 8 : Exemple de Module Odoo
custom_module/__manifest__.py
pythonCopy{
    'name': 'Custom Module',
    'version': '15.0.1.0.0',
    'summary': 'Example Custom Odoo Module',
    'author': 'Votre Nom',
    'depends': ['base'],
    'data': [],
    'demo': [],
    'installable': True,
}
custom_module/models.py
pythonCopyfrom odoo import models, fields

class CustomModel(models.Model):
    _name = 'custom.model'
    _description = 'Custom Model'

    name = fields.Char(string='Name', required=True)
custom_module/tests/test_module.py
pythonCopyfrom odoo.tests.common import TransactionCase

class TestCustomModule(TransactionCase):
    def test_create_record(self):
        record = self.env['custom.model'].create({
            'name': 'Test Record'
        })
        self.assertEqual(record.name, 'Test Record')
Étape 9 : Jenkinsfile
Jenkinsfile
groovyCopypipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/votre-nom/odoo-custom-addons.git'
        DOCKER_IMAGE = 'odoo-custom-addons'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-token',
                    url: "${GITHUB_REPO}"
            }
        }

        stage('Lint Python') {
            steps {
                script {
                    sh 'pip3 install pylint'
                    sh '''
                        find . -type f -name "*.py" | grep -v "__init__.py" | xargs pylint \
                        --disable=C0111 \
                        --max-line-length=120
                    '''
                }
            }
        }

        stage('Odoo Addon Tests') {
            steps {
                script {
                    sh '''
                        pip3 install odoo-test-helper
                        for addon in */; do
                            if [ -f "$addon/__manifest__.py" ]; then
                                echo "Testing addon: $addon"
                                python3 -m pytest "$addon/tests/"
                            fi
                        done
                    '''
                }
            }
        }

        stage('Build Odoo Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
    }
}
Étape 10 : Docker Compose pour Odoo
docker-compose.yml
yamlCopyversion: '3.7'
services:
  odoo:
    image: odoo:15.0
    ports:
      - "8069:8069"
    volumes:
      - ./custom_module:/mnt/extra-addons
    depends_on:
      - postgresql
    environment:
      - POSTGRES_HOST=postgresql
      - POSTGRES_PORT=5432
      - POSTGRES_DB=odoo
      - POSTGRES_USER=odoo
      - POSTGRES_PASSWORD=odoo

  postgresql:
    image: postgres:13
    environment:
      - POSTGRES_DB=odoo
      - POSTGRES_USER=odoo
      - POSTGRES_PASSWORD=odoo
    volumes:
      - postgresql-data:/var/lib/postgresql/data

volumes:
  postgresql-data:
Initialisation du Dépôt Git
Étape 11 : Configuration Git
bashCopygit init
git add .
git commit -m "Initial commit of Odoo custom module"
git branch -M main
git remote add origin https://github.com/votre-nom/odoo-custom-addons.git
git push -u origin main
Configuration du Webhook GitHub
Étape 12 : Webhook

Sur GitHub > Dépôt > Settings > Webhooks
Add webhook

Payload URL: http://votre-ip-jenkins:8080/github-webhook/
Content type: application/json
Events: Push, Pull Request



Création du Job Jenkins
Étape 13 : Configuration du Job

Nouveau Job
Type : Pipeline
Cocher :

GitHub hook trigger for GITScm polling


Pipeline script : Sélectionner "Pipeline script from SCM"
SCM : Git
Repository URL : URL de votre dépôt GitHub
Credentials : Sélectionner le token GitHub

Dépannage et Vérifications
bashCopy# Vérifier les logs Jenkins
sudo journalctl -u jenkins

# Statut du service Jenkins
sudo systemctl status jenkins

# Logs Docker
docker logs jenkins
# --------------------------------------------------

Apres installation de junkins 
