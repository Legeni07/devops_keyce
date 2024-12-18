FROM ubuntu:22.04

LABEL Name="BOGNI-DANCHI"
LABEL email="thomslegeni@gmail.com"

# Éviter les interactions durant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    git \
    curl \
    openjdk-17-jdk \
    nodejs \
    npm \
    unzip \
    software-properties-common \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer Git LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install -y git-lfs

# Installer Heroku CLI
RUN npm install -g heroku

# Installer Docker
RUN curl -fsSL https://get.docker.com/ | sh

# Installer Nginx
RUN apt-get update && apt-get install -y nginx

# Configuration systemd (similaire à l'original)
ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

# Préparer les répertoires et scripts
RUN mkdir /jenkins
COPY . /jenkins

# Exécuter le script d'installation de Jenkins
RUN sh /jenkins/jenkins-install.sh

# Configuration Nginx
RUN cp /jenkins/jenkins.conf /etc/nginx/conf.d/jenkins.conf

EXPOSE 80
EXPOSE 8080

VOLUME /var/lib/jenkins
VOLUME /usr/local/jenkins

# Activer les services
RUN systemctl enable docker
RUN usermod -aG docker jenkins
RUN systemctl enable nginx.service
RUN systemctl enable jenkins

CMD ["/usr/sbin/init"]