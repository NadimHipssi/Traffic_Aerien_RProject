# Traffic_Aerien_RProject

Ce dépôt contient une application complète d'analyse et de reporting des données du trafic aérien en utilisant R et Shiny.

## Table des Matières
- [Traffic\_Aerien\_RProject](#traffic_aerien_rproject)
  - [Table des Matières](#table-des-matières)
  - [Présentation du Projet](#présentation-du-projet)
  - [Instructions d'Installation](#instructions-dinstallation)
  - [Nettoyage et Préparation des Données](#nettoyage-et-préparation-des-données)
    - [Dump de la Base de Données](#dump-de-la-base-de-données)
    - [Application Web](#application-web)
      - [Aperçu](#aperçu)
      - [Description Détaillée des Onglets](#description-détaillée-des-onglets)
        - [Modèle de Prédiction](#modèle-de-prédiction)
    - [Lien Vers Trello, Git, Powerpoint](#lien-vers-trello-git-powerpoint)

## Présentation du Projet

Ce projet analyse les données du trafic aérien pour identifier des motifs, des retards et des pics de trafic. Les données sont nettoyées, stockées dans une base de données SQL, et visualisées à l'aide d'une application Shiny pour un reporting interactif et des analyses prédictives.

## Instructions d'Installation

1. **Cloner le dépôt** :
    ```sh
    git clone https://github.com/NadimHipssi/Traffic_Aerien_RProject.git
    cd Traffic_Aerien_RProject
    ```

2. **Construire et lancer le conteneur Docker** :
    ```sh
    docker-compose up --build
    ```

3. **Accéder à l'application Shiny** :
    Ouvrez votre navigateur et allez sur `http://localhost:3838` pour accéder à l'application.

## Nettoyage et Préparation des Données

Le script `clean.ipynb` nettoie et prépare le jeu de données pour l'injection dans la base de données SQL.

### Dump de la Base de Données

Dans le dossier `dump_database`, il y a un fichier nommé `traffic_aerien_db.sql`. Ce fichier contient les commandes SQL pour créer et peupler la base de données avec les données nettoyées. Il inclut le schéma et les données pour les cinq tables suivantes (nettoyées) :

1. **Flights**
2. **Airports**
3. **Carriers**
4. **Planes**
5. **Weather**

### Application Web

L'application web est construite en utilisant Shiny et fournit une interface interactive pour le reporting et l'analyse prédictive des données du trafic aérien. Voici un aperçu des différents onglets et de leurs fonctionnalités.

#### Aperçu

L'application est divisée en plusieurs onglets, chacun se concentrant sur un aspect spécifique de l'analyse des données du trafic aérien :

1. **Familiarisation**
2. **Analyse des Retards**
   - Retards au Départ
   - Retards à l'Arrivée
3. **Pics de Trafic**
4. **Analyse Prédictive**

#### Description Détaillée des Onglets

1. **Familiarisation**

    - **Objectif** : Donner aux utilisateurs un aperçu du jeu de données.
    - **Fonctionnalités** :
        - **Résumé des Données** : Affiche des statistiques clés telles que le nombre de vols, le retard moyen, et d'autres statistiques récapitulatives.
        - **Tableau de Données** : Montre un échantillon du jeu de données sous forme de tableau pour une inspection rapide.

2. **Analyse des Retards**

    - **Objectif** : Analyser les retards dans le trafic aérien, tant au départ qu'à l'arrivée.
    - **Sous-onglets** :
        - **Retards au Départ** :
            - **Retard Moyen par Compagnie** : Diagramme en barres montrant le retard moyen au départ par compagnie aérienne.
            - **Distribution des Retards** : Histogramme montrant la distribution des retards au départ.
        - **Retards à l'Arrivée** :
            - **Retard Moyen par Compagnie** : Diagramme en barres montrant le retard moyen à l'arrivée par compagnie aérienne.
            - **Distribution des Retards** : Histogramme montrant la distribution des retards à l'arrivée.

3. **Pics de Trafic**

    - **Objectif** : Identifier les périodes de pic de trafic.
    - **Fonctionnalités** :
        - **Trafic Horaire** : Diagramme en ligne montrant le nombre de vols par heure.
        - **Trafic Quotidien** : Diagramme en ligne montrant le nombre de vols par jour de la semaine.
        - **Trafic Mensuel** : Diagramme en ligne montrant le nombre de vols par mois.

4. **Analyse Prédictive**

    - **Objectif** : Fournir des insights prédictifs à partir des données disponibles.
    - **Fonctionnalités** :
        - **Prédiction des Retards** : Un modèle pour prédire les retards de vols basés sur des données historiques.
        - **Importance des Variables** : Diagramme en barres montrant l'importance des différentes variables dans le modèle de prédiction.

##### Modèle de Prédiction

- **Prédiction des Retards de Vols** : Cet onglet permet aux utilisateurs de saisir les détails du vol tels que le retard au départ, la compagnie, l'origine, la destination, les détails de la date et de l'heure, et d'autres paramètres spécifiques au vol pour prédire si un vol sera retardé ou non.
- **Résultats de la Prédiction** : Affiche le résultat de la prédiction sous forme de résultat binaire où 1 indique un retard et 0 indique aucun retard.

### Lien Vers Trello, Git, Powerpoint

- [Lien vers le git](https://github.com/NadimHipssi/Traffic_Aerien_RProject)
- [Lien vers le Trello](https://trello.com/invite/b/3EqL5UvW/ATTIee36219c9e8bd9f7ce9ee86b7f58bba8EDA39755/traffic-aerien)
- [Lien vers le PowerPoint](https://view.genially.com/652511638718a5001161f794/guide-traffic-aerien)
