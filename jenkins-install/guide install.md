# Modify the Jenkins Container User:
# If you're running Jenkins in a Docker container, you need to ensure the Jenkins user has the correct # permissions to access the Docker socket.

# bashCopy# While inside the Jenkins container, switch to root
docker exec -u root -it jenkins /bin/bash

# Add the jenkins user to the docker group
groupadd -f docker
usermod -aG docker jenkins

# Verify group membership
groups jenkins

# Ensure Correct Socket Permissions: 
# On the host machine
sudo chmod 666 /var/run/docker.sock


---

### **Commandes principales de Docker Compose :**

1. **`docker-compose build`**  
   - Construit ou reconstruit les images des services définis dans le fichier `docker-compose.yml`.  
   - Exemple : `docker-compose build`

2. **`docker-compose up`**  
   - Démarre les services définis dans `docker-compose.yml`.  
   - Options courantes :
     - `-d` : Mode détaché (en arrière-plan).  
     - `--build` : Reconstruit les images avant de démarrer.  
   - Exemple : `docker-compose up -d`

3. **`docker-compose down`**  
   - Arrête les conteneurs et supprime les réseaux, volumes et images créés.  
   - Options courantes :
     - `--volumes` : Supprime les volumes associés.  
     - `--rmi` : Supprime les images (`local` ou `all`).  
   - Exemple : `docker-compose down --volumes`

4. **`docker-compose start`**  
   - Démarre les conteneurs existants (ne les recrée pas).  
   - Exemple : `docker-compose start`

5. **`docker-compose stop`**  
   - Arrête les conteneurs en cours d'exécution.  
   - Exemple : `docker-compose stop`

6. **`docker-compose restart`**  
   - Redémarre un ou plusieurs services.  
   - Exemple : `docker-compose restart service_name`

7. **`docker-compose ps`**  
   - Affiche l'état des conteneurs gérés par Docker Compose.  
   - Exemple : `docker-compose ps`

8. **`docker-compose logs`**  
   - Affiche les journaux des services.  
   - Options courantes :
     - `-f` : Mode suivi en temps réel.  
   - Exemple : `docker-compose logs -f service_name`

9. **`docker-compose exec`**  
   - Exécute une commande dans un conteneur en cours d'exécution.  
   - Exemple : `docker-compose exec service_name bash`

10. **`docker-compose run`**  
    - Exécute une commande dans un nouveau conteneur temporaire.  
    - Exemple : `docker-compose run service_name command`

11. **`docker-compose pull`**  
    - Télécharge les images spécifiées dans le fichier `docker-compose.yml`.  
    - Exemple : `docker-compose pull`

12. **`docker-compose push`**  
    - Pousse les images des services vers un registre distant.  
    - Exemple : `docker-compose push`

13. **`docker-compose rm`**  
    - Supprime les conteneurs arrêtés.  
    - Options courantes :
      - `-f` : Forcer la suppression.  
    - Exemple : `docker-compose rm -f`

14. **`docker-compose config`**  
    - Vérifie la syntaxe du fichier `docker-compose.yml` et l’affiche.  
    - Exemple : `docker-compose config`

15. **`docker-compose scale`**  
    - Définit le nombre de conteneurs pour un service (remplacé par `up --scale` dans les nouvelles versions).  
    - Exemple : `docker-compose scale service_name=3`

16. **`docker-compose version`**  
    - Affiche la version de Docker Compose.  
    - Exemple : `docker-compose version`

---

### **Commandes avancées :**

1. **`docker-compose up --scale`**  
   - Définit le nombre de réplicas pour un service lors du démarrage.  
   - Exemple : `docker-compose up --scale service_name=3`

2. **`docker-compose top`**  
   - Affiche les processus en cours dans les conteneurs.  
   - Exemple : `docker-compose top`

3. **`docker-compose port`**  
   - Affiche le port public correspondant à un port exposé d’un service.  
   - Exemple : `docker-compose port service_name 80`

4. **`docker-compose events`**  
   - Stream des événements des conteneurs en temps réel.  
   - Exemple : `docker-compose events`

5. **`docker-compose kill`**  
   - Arrête brutalement les conteneurs (force kill).  
   - Exemple : `docker-compose kill`

