### README.md

# Traffic_Aerien_RProject

This repository contains a comprehensive analysis and reporting application for air traffic data using R and Shiny.

## Table of Contents
- [Traffic\_Aerien\_RProject](#traffic_aerien_rproject)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Setup Instructions](#setup-instructions)
  - [Data Cleaning and Preparation](#data-cleaning-and-preparation)
    - [Database Dump](#database-dump)
    - [Web Application](#web-application)
      - [Overview](#overview)
      - [Detailed Description of Tabs](#detailed-description-of-tabs)
        - [Prediction Model](#prediction-model)

## Project Overview

This project analyzes air traffic data to identify patterns, delays, and peak traffic times. The data is cleaned, stored in a SQL database, and visualized using a Shiny application for interactive reporting and analysis.

## Setup Instructions

1. **Clone the repository**:
    ```sh
    git clone https://github.com/NadimHipssi/Traffic_Aerien_RProject.git
    cd Traffic_Aerien_RProject
    ```

2. **Build and run the Docker container**:
    ```sh
    docker-compose up --build
    ```

3. **Access the Shiny application**:
    Open your browser and go to `http://localhost:3838` to access the application.

## Data Cleaning and Preparation

The `clean.ipynb` script cleans and prepares the dataset for SQL database injection.

### Database Dump

In the `dump_database` folder, there is a file named `aeroport_db.sql`. This file contains SQL commands to create and populate the database with cleaned data. It includes the schema and data for the following five tables:

1. **Flights**
2. **Airports**
3. **Carriers**
4. **Planes**
5. **Weather**

### Web Application

The web application is built using Shiny and provides an interactive interface for reporting and predictive analysis of air traffic data. Below is an overview of the various tabs and their functionalities.

#### Overview

The application is divided into several tabs, each focusing on a specific aspect of the air traffic data analysis:

1. **Familiarization**
2. **Delay Analysis**
   - Departure Delays
   - Arrival Delays
3. **Traffic Peak**
4. **Predictive Analysis**

#### Detailed Description of Tabs

1. **Familiarization**

    - **Objective**: To give users an overview of the dataset.
    - **Features**:
        - **Data Summary**: Displays key statistics such as the number of flights, average delay, and other summary statistics.
        - **Data Table**: Shows a sample of the dataset in a table format for quick inspection.

2. **Delay Analysis**

    - **Objective**: To analyze delays in air traffic, both at departure and arrival.
    - **Sub-tabs**:
        - **Departure Delays**:
            - **Average Delay by Carrier**: Bar chart showing the average departure delay per airline.
            - **Delay Distribution**: Histogram showing the distribution of departure delays.
        - **Arrival Delays**:
            - **Average Delay by Carrier**: Bar chart showing the average arrival delay per airline.
            - **Delay Distribution**: Histogram showing the distribution of arrival delays.

3. **Traffic Peak**

    - **Objective**: To identify peak traffic periods.
    - **Features**:
        - **Hourly Traffic**: Line chart showing the number of flights per hour.
        - **Daily Traffic**: Line chart showing the number of flights per day of the week.
        - **Monthly Traffic**: Line chart showing the number of flights per month.

4. **Predictive Analysis**

    - **Objective**: To provide predictive insights using the available data.
    - **Features**:
        - **Delay Prediction**: A model to predict flight delays based on historical data.
        - **Feature Importance**: Bar chart showing the importance of different features in the prediction model.


##### Prediction Model

- **Flight Delay Prediction:** This tab allows users to input flight details such as departure delay, carrier, origin, destination, date and time details, and other flight-specific parameters to predict if a flight will be delayed or not.
- **Prediction Results:** Displays the prediction result as a binary outcome where 1 indicates a delay and 0 indicates no delay.


---

For further details on setting up and running the web application, refer to the [Setup Instructions](#setup-instructions) section above.



