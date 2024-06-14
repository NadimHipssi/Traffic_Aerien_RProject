library(dplyr)
library(lubridate)

# Function to load model and make predictions
predict_delays <- function(data) {
  # Load the pre-trained model
  model <- readRDS("models/flight_delay_model_glm.rds")
  
  # Ensure all necessary columns are present and correctly typed
  required_columns <- c("year", "month", "day", "dep_time", "sched_dep_time", 
                        "dep_delay", "arr_time", "sched_arr_time", "carrier", 
                        "flight", "tailnum", "origin", "dest", "air_time", 
                        "distance", "hour", "minute", "arr_delay", "time_hour", "id")
  
  # Ensure all required columns are in the data
  for (col in required_columns) {
    if (!(col %in% names(data))) {
      data[[col]] <- NA
    }
  }
  
  # Get levels of factors from model
  model_levels <- lapply(model$xlevels, levels)
  
  data <- data %>%
    mutate(across(all_of(required_columns), as.character)) %>%
    mutate(across(c(year, month, day, dep_time, sched_dep_time, dep_delay, 
                    arr_time, sched_arr_time, flight, air_time, distance, 
                    hour, minute, arr_delay, id), as.numeric),
           time_hour = factor(time_hour, levels = model_levels[["time_hour"]]),  
           carrier = factor(carrier, levels = model_levels[["carrier"]]),
           tailnum = factor(tailnum, levels = model_levels[["tailnum"]]),
           origin = factor(origin, levels = model_levels[["origin"]]),
           dest = factor(dest, levels = model_levels[["dest"]]))
  
  # Predict the delay
  predictions <- predict(model, newdata = data, type = "response")
  predictions <- ifelse(predictions > 0.5, 1, 0)
  
  # Add predictions to the dataframe
  data$predicted_delay <- predictions
  data
}

# Sample preset data
preset_data <- data.frame(
  year = c(2021, 2021, 2021),
  month = c(1, 1, 1),
  day = c(1, 1, 1),
  dep_time = c(517, 533, 542),
  sched_dep_time = c(515, 529, 540),
  dep_delay = c(2, 4, 2),
  arr_time = c(830, 850, 923),
  sched_arr_time = c(819, 830, 850),
  arr_delay = c(11, 20, 33),
  carrier = c("UA", "UA", "AA"),
  flight = c(1545, 1714, 1141),
  tailnum = c("N14228", "N24211", "N619AA"),
  origin = c("EWR", "LGA", "JFK"),
  dest = c("IAH", "IAH", "MIA"),
  air_time = c(227, 227, 160),
  distance = c(1400, 1416, 1089),
  hour = c(5, 5, 5),
  minute = c(17, 29, 40),
  time_hour = as.character(c("2021-01-01 05:00:00", "2021-01-01 05:00:00", "2021-01-01 05:00:00")),  # Convert to character
  id = c(1, 2, 3),
  stringsAsFactors = FALSE
)

# Function to create sample predictions
get_sample_predictions <- function() {
  delayed_flight <- preset_data[1, ]
  on_time_flight <- preset_data[2, ]
  early_flight <- preset_data[3, ]
  
  list(
    delayed = predict_delays(delayed_flight),
    on_time = predict_delays(on_time_flight),
    early = predict_delays(early_flight)
  )
}

sample_predictions <- get_sample_predictions()

# Create UI for prediction
predictionUI <- function() {
  fluidPage(
    titlePanel("Flight Delay Prediction"),
    sidebarLayout(
      sidebarPanel(
        actionButton("predict_delayed", "Delayed Flight"),
        actionButton("predict_on_time", "On Time Flight"),
        actionButton("predict_early", "Early Flight")
      ),
      mainPanel(
        tableOutput("prediction_results")
      )
    )
  )
}

# Create server function for prediction
predictionServer <- function(input, output, session) {
  observeEvent(input$predict_delayed, {
    output$prediction_results <- renderTable({
      cat("Predicting delayed flight...\n")  
      sample_predictions$delayed
    })
  })
  
  observeEvent(input$predict_on_time, {
    output$prediction_results <- renderTable({
      cat("Predicting on time flight...\n")  
      sample_predictions$on_time
    })
  })
  
  observeEvent(input$predict_early, {
    output$prediction_results <- renderTable({
      cat("Predicting early flight...\n")  
      sample_predictions$early
    })
  })
}
