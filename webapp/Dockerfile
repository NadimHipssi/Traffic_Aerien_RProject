# Utiliser l'image de base officielle R avec Shiny Server préinstallé
FROM rocker/shiny:latest

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copier le code de l'application Shiny dans le répertoire de l'application Shiny Server
COPY app /srv/shiny-server/app

# Installer les paquets R nécessaires
RUN R -e "install.packages(c('shiny', 'ggplot2', 'jsonlite', 'leaflet', 'lubridate', 'dplyr', 'DT'), repos='http://cran.rstudio.com/')"

# Exposer le port utilisé par Shiny Server
EXPOSE 3838

# Lancer Shiny Server
CMD ["/usr/bin/shiny-server"]
