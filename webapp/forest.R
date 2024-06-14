# Install necessary packages
install.packages(c("dplyr", "caret", "randomForest", "e1071"))

# Load required libraries
library(dplyr)
library(caret)
library(randomForest)
library(e1071)

# Load the dataset
flights <- read.csv("data/cleaned_flights.csv")

# Data Preprocessing
flights <- na.omit(flights) # Remove rows with NA values

# Convert necessary columns to factors
flights$carrier <- as.factor(flights$carrier)
flights$origin <- as.factor(flights$origin)
flights$dest <- as.factor(flights$dest)
flights$tailnum <- as.factor(flights$tailnum)

# Select relevant columns
flights_model <- flights %>%
  select(year, month, day, dep_time, sched_dep_time, dep_delay, 
         arr_time, sched_arr_time, carrier, flight, tailnum, 
         origin, dest, air_time, distance, hour, minute, 
         arr_delay)

# Train-test split
set.seed(123)
trainIndex <- createDataPartition(flights_model$arr_delay, p = .8, list = FALSE, times = 1)
flightsTrain <- flights_model[trainIndex, ]
flightsTest <- flights_model[-trainIndex, ]

# Train the Random Forest model
print("Training Random Forest model...")
rf_model <- randomForest(arr_delay ~ ., data = flightsTrain, ntree = 500, mtry = 4, importance = TRUE)
print("Model training completed.")

# Predict on the test set
predictions <- predict(rf_model, newdata = flightsTest)

# Evaluate the model
rmse <- sqrt(mean((predictions - flightsTest$arr_delay)^2))
cat("RMSE: ", rmse, "\n")

# Save the model
saveRDS(rf_model, file = "models/flight_delay_rf_model.rds")

print("Random Forest model saved as 'flight_delay_rf_model.rds'")
