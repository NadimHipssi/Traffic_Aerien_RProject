# Traffic_Aerien_RProject

Ce dépôt contient une analyse complète et une application de reporting pour les données de trafic aérien utilisant R et Shiny.

## Liens Vers Trello, Git, Powerpoint

- [GitHub Repository](https://github.com/NadimHipssi/Traffic_Aerien_RProject)
- [Trello](https://trello.com/invite/b/3EqL5UvW/ATTIee36219c9e8bd9f7ce9ee86b7f58bba8EDA39755/traffic-aerien)
- [Support de Présentation](https://view.genially.com/652511638718a5001161f794/guide-traffic-aerien)

## Table des matières
- [Traffic\_Aerien\_RProject](#traffic_aerien_rproject)
  - [Liens Vers Trello, Git, Powerpoint](#liens-vers-trello-git-powerpoint)
  - [Table des matières](#table-des-matières)
  - [Aperçu du projet](#aperçu-du-projet)
  - [Instructions de configuration](#instructions-de-configuration)
  - [Nettoyage et préparation des données](#nettoyage-et-préparation-des-données)
    - [Dump de la base de données](#dump-de-la-base-de-données)
    - [Application Web](#application-web)
      - [Aperçu](#aperçu)
      - [Description détaillée des onglets](#description-détaillée-des-onglets)
        - [Modèle de prédiction](#modèle-de-prédiction)
  - [Livrables](#livrables)

## Aperçu du projet

Ce projet analyse les données de trafic aérien pour identifier les motifs, les retards et les périodes de pointe du trafic. Les données sont nettoyées, stockées dans une base de données SQL, et visualisées à l'aide d'une application Shiny pour un reporting et une analyse interactifs.

## Instructions de configuration

1. **Cloner le dépôt** :
    ```sh
    git clone https://github.com/NadimHipssi/Traffic_Aerien_RProject.git
    cd Traffic_Aerien_RProject
    ```

2. **Construire et exécuter le conteneur Docker** :
    ```sh
    docker-compose up --build
    ```

3. **Accéder à l'application Shiny** :
    Ouvrez votre navigateur et allez sur `http://localhost:3838` pour accéder à l'application.

## Nettoyage et préparation des données

Le script `clean.ipynb` nettoie et prépare le jeu de données pour l'injection dans la base de données SQL. Les étapes incluent :
- Suppression des lignes avec des valeurs nulles dans les colonnes clés.
- Suppression des doublons.
- Identification et ajout des valeurs manquantes.

### Dump de la base de données

Dans le dossier `dump_database`, il y a un fichier nommé `traffic_aerien_db.sql`. Ce fichier contient des commandes SQL pour créer et remplir la base de données avec les données nettoyées. Il inclut le schéma et les données pour les cinq tables (nettoyées) suivantes :

1. **Flights**
2. **Airports**
3. **Carriers**
4. **Planes**
5. **Weather**

### Application Web

L'application web est construite en utilisant Shiny et fournit une interface interactive pour le reporting et l'analyse prédictive des données de trafic aérien. Voici un aperçu des différents onglets et de leurs fonctionnalités.

#### Aperçu

L'application est divisée en plusieurs onglets, chacun se concentrant sur un aspect spécifique de l'analyse des données de trafic aérien :

1. **Familiarisation**
2. **Analyse des retards**
   - Retards au départ
   - Retards à l'arrivée
3. **Pic de trafic**
4. **Analyse prédictive**

#### Description détaillée des onglets

1. **Familiarisation**

    - **Objectif** : Donner aux utilisateurs une vue d'ensemble du jeu de données.
    - **Fonctionnalités** :
        - **Résumé des données** : Affiche des statistiques clés telles que le nombre de vols, le retard moyen, et d'autres statistiques de synthèse.
        - **Tableau de données** : Affiche un échantillon du jeu de données sous forme de tableau pour une inspection rapide.

2. **Analyse des retards**

    - **Objectif** : Analyser les retards dans le trafic aérien, à la fois au départ et à l'arrivée.
    - **Sous-onglets** :
        - **Retards au départ** :
            - **Retard moyen par compagnie** : Diagramme à barres montrant le retard moyen au départ par compagnie aérienne.
            - **Distribution des retards** : Histogramme montrant la distribution des retards au départ.
        - **Retards à l'arrivée** :
            - **Retard moyen par compagnie** : Diagramme à barres montrant le retard moyen à l'arrivée par compagnie aérienne.
            - **Distribution des retards** : Histogramme montrant la distribution des retards à l'arrivée.

3. **Pic de trafic**

    - **Objectif** : Identifier les périodes de pointe du trafic.
    - **Fonctionnalités** :
        - **Trafic horaire** : Diagramme en courbes montrant le nombre de vols par heure.
        - **Trafic journalier** : Diagramme en courbes montrant le nombre de vols par jour de la semaine.
        - **Trafic mensuel** : Diagramme en courbes montrant le nombre de vols par mois.

4. **Analyse prédictive**

    - **Objectif** : Fournir des insights prédictifs en utilisant les données disponibles.
    - **Fonctionnalités** :
        - **Prédiction des retards** : Un modèle pour prédire les retards des vols en se basant sur les données historiques.
        - **Importance des caractéristiques** : Diagramme à barres montrant l'importance des différentes caractéristiques dans le modèle de prédiction.

##### Modèle de prédiction

- **Prédiction des retards de vol** : Cet onglet permet aux utilisateurs de saisir les détails d'un vol, tels que le retard au départ, la compagnie aérienne, l'origine, la destination, les détails de date et heure, et d'autres paramètres spécifiques au vol pour prédire si un vol sera retardé ou non.
- **Résultats de la prédiction** : Affiche le résultat de la prédiction sous forme de résultat binaire où 1 indique un retard et 0 indique aucun retard.

## Livrables

- **Notebooks** :
  - `clean.ipynb` : Nettoyage des données.
  - `EDA.ipynb` : Visualisation des données via Pandas.
  - `Flight_Data_Analysis.ipynb` : Analyse des données via Spark.
- **Script de nettoyage** : `data/clean/cleaning.txt` explique les étapes de nettoyage.
- **WebApp** : Dossier `WebApp` contenant le code en R pour la webapp.
