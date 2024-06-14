# Installer les packages (à faire une seule fois)
install.packages(c("dplyr", "ggplot2", "caret", "randomForest", "e1071"))

# Charger les packages
library(dplyr)
library(ggplot2)
library(caret)
library(randomForest)
library(e1071)

# Charger le dataset ( si déjà chargé c'est inutile)
flights <- read.csv("GitHub/Traffic_Aerien_RProject/data/clean/cleaned_flights.csv")

# Explorer le dataset
head(flights)
summary(flights)

# Préparation des données
flights <- na.omit(flights)

# Conversion des colonnes en facteurs
flights$carrier <- as.factor(flights$carrier)
flights$origin <- as.factor(flights$origin)
flights$dest <- as.factor(flights$dest)
flights$tailnum <- as.factor(flights$tailnum)

# Créer une colonne binaire pour les retards à l'arrivée
flights$arr_delay_binary <- ifelse(flights$arr_delay > 0, 1, 0)

# Sélectionner les colonnes pertinentes pour le modèle
flights_model <- flights %>% select(year, month, day, dep_time, sched_dep_time, dep_delay, 
                                    arr_time, sched_arr_time, carrier, flight, tailnum, 
                                    origin, dest, air_time, distance, hour, minute, 
                                    arr_delay_binary)

# Afficher les premières lignes pour vérifier les modifications
head(flights_model)

# Vérifier la structure des données
str(flights_model)

# Diviser les données en ensembles d'entraînement et de test
set.seed(123)
trainIndex <- createDataPartition(flights_model$arr_delay_binary, p = .8, list = FALSE, times = 1)
flightsTrain <- flights[1:1000,]
flightsTest <- flights[1:1000,]

# Utiliser la fonction glm directement pour entraîner le modèle
print("Starting model training with glm...")
model <- glm(arr_delay_binary ~ ., data = flightsTrain, family = binomial)
print("Model training completed with glm.")

# Afficher le modèle entraîné
summary(model)

# Prédire sur l'ensemble de test
predictions <- predict(model, newdata = flightsTest, type = "response")
predictions <- ifelse(predictions > 0.5, 1, 0)

# Évaluer le modèle
conf_matrix <- confusionMatrix(as.factor(predictions), as.factor(flightsTest$arr_delay_binary))

# Afficher la matrice de confusion
print(conf_matrix)

# Sauvegarder le modèle dans un répertoire spécifique
if (!dir.exists("models")) {
  dir.create("models")
}

file_path <- "GitHub/Traffic_Aerien_RProject/models/flight_delay_model_glm.rds"
saveRDS(model, file = file_path)

# Charger le modèle depuis le fichier .rds
loaded_model <- readRDS(file_path)

# Afficher le modèle chargé pour vérification
print(loaded_model)

