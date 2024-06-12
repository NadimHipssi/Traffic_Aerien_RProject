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
flightsTrain <- flights_model[trainIndex,]
flightsTest <- flights_model[-trainIndex,]

# Entraîner un modèle de régression logistique
model <- train(arr_delay_binary ~ ., data = flightsTrain, method = "glm", family = binomial)

# Prédire sur l'ensemble de test
predictions <- predict(model, newdata = flightsTest)

# Évaluer le modèle
confusionMatrix(predictions, flightsTest$arr_delay_binary)

