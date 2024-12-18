# TP 4.2 : Création d’un Pod sous Kubernetes
# Objectif :Créer un Pod unique à partir d’un fichier YAML et vérifier son état.

Étapes : Créer un fichier YAML pour le Pod :

# Exemple de fichier pod.yaml :
# 
# Copier le code
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: myapp
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
      ports:
        - containerPort: 80
# Appliquer la configuration du Pod :
kubectl apply -f pod.yaml
# Vérifier l’état du Pod :

kubectl get pods
kubectl describe pod my-pod

# Accéder au Pod (Optionnel) : Si vous souhaitez accéder à l’application hébergée dans le Pod :

kubectl port-forward pod/my-pod 8080:80
# Accédez ensuite à http://localhost:8080.

### TP 4.3 : Création d’un Déploiement, Service, et Réplicas
# Objectif : Déployer une application avec des réplicas et exposer le service. 

# Étapes :
# Créer un fichier YAML pour le déploiement : Exemple de fichier deployment.yaml :

# Copier le code suivant dans le ficher deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80

# Créer un fichier YAML pour le service :

# Exemple de fichier service.yaml :
# Copier le code
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: myapp
  ports:
    - port: 80
      targetPort: 80
  type: NodePort

# Executer les cmd kubectl suivant pour Appliquer les fichiers YAML :

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
Vérifications :

# Vérifiez les déploiements, les Pods, et les services :

kubectl get deployments
kubectl get pods
kubectl get services
# Accéder au service :

minikube service my-service --url

###
<!-- TP 4.4 : Déploiement de l’application WebApp
Objectif :
Déployer l’application WebApp sur le port 8180 avec Kubernetes. -->
###
# Étapes :
# Créer un fichier YAML pour le déploiement : Exemple de fichier webapp-deployment.yaml :

apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
        - name: webapp-container
          image: legeni/webapp:v1
          ports:
            - containerPort: 80

# Créer un fichier YAML pour le service : Exemple de fichier webapp-service.yaml :

apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webapp
  ports:
    - port: 8180
      targetPort: 80
  type: NodePort

# Appliquer les fichiers YAML :

kubectl apply -f webapp-deployment.yaml
kubectl apply -f webapp-service.yaml
Accéder à l’application WebApp :

# Utilisez la commande suivante si vous êtes sur Minikube :

minikube service webapp-service --url

<!-- TP 4.5 : Déploiement de WordPress avec Kubernetes
Objectif :
Déployer WordPress avec Kubernetes. -->

# Étapes :
# Créer un fichier YAML pour MySQL : Exemple de fichier mysql-deployment.yaml :

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: "rootpassword"

# Créer un fichier YAML pour WordPress : Exemple de fichier wordpress-deployment.yaml :

apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
        - name: wordpress
          image: wordpress:latest
          env:
            - name: WORDPRESS_DB_HOST
              value: mysql
            - name: WORDPRESS_DB_PASSWORD
              value: "rootpassword"
          ports:
            - containerPort: 80
# Créer un service pour WordPress : 

apiVersion: v1
kind: Service
metadata:
  name: wordpress-service
spec:
  selector:
    app: wordpress
  ports:
    - port: 80
      targetPort: 80
  type: NodePort

# Appliquer les configurations :

kubectl apply -f mysql-deployment.yaml
kubectl apply -f wordpress-deployment.yaml
Accéder à WordPress :

# Utilisez Minikube pour obtenir l’URL :

minikube service wordpress-service --url

<!-- TP 4.6 : Déploiement de WordPress avec un Playbook Ansible
Objectif :
Automatiser le déploiement de WordPress via un playbook Ansible. -->

# Étapes :
# Installer Ansible et configurer Kubernetes :

# Assurez-vous qu’Ansible est installé et que le cluster Kubernetes est accessible.
# Créer un playbook Ansible : Exemple de fichier wordpress-playbook.yaml :

- name: Deploy WordPress
  hosts: localhost
  tasks:
    - name: Deploy MySQL
      kubernetes.core.k8s:
        definition: "{{ lookup('file', 'mysql-deployment.yaml') }}"
    - name: Deploy WordPress
      kubernetes.core.k8s:
        definition: "{{ lookup('file', 'wordpress-deployment.yaml') }}"
    - name: Expose WordPress Service
      kubernetes.core.k8s:
        definition: "{{ lookup('file', 'wordpress-service.yaml') }}"

# Exécuter le playbook :
ansible-playbook wordpress-playbook.yaml

# Vérifier l’état des ressources :
kubectl get all

# Accéder à WordPress : Vérifiez le service exposé et accédez à WordPress.