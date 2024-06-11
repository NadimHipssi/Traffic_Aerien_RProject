library(dplyr)
library(ggplot2)
library(DT)

# Fonction pour trouver les vols les plus retardés
most_delayed_flights <- function(flights) {
  delayed_arrival <- flights %>%
    arrange(desc(arr_delay)) %>%
    head(10)
  
  delayed_departure <- flights %>%
    arrange(desc(dep_delay)) %>%
    head(10)
  
  delayed_both <- flights %>%
    arrange(desc(dep_delay + arr_delay)) %>%
    head(10)
  
  list(
    delayed_arrival = datatable(delayed_arrival),
    delayed_departure = datatable(delayed_departure),
    delayed_both = datatable(delayed_both)
  )
}

# Fonction pour calculer le retard moyen au départ
average_departure_delay <- function(flights) {
  overall_avg_delay <- mean(flights$dep_delay, na.rm = TRUE)
  
  daily_avg_delay <- flights %>%
    group_by(date = as.Date(sched_dep_time)) %>%
    summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE), .groups = 'drop')
  
  list(
    overall_avg_delay = overall_avg_delay,
    daily_avg_delay = datatable(daily_avg_delay)
  )
}

# Fonction pour trouver les vols avec plus de 2 heures de retard à l’arrivée, mais partis à l’heure
two_hour_delay <- function(flights) {
  flights_2hr_delay <- flights %>%
    filter(arr_delay > 120 & dep_delay <= 0)
  
  flights_no_2hr_delay <- flights %>%
    filter(arr_delay <= 120 & dep_delay <= 120)
  
  list(
    flights_2hr_delay = datatable(flights_2hr_delay),
    flights_no_2hr_delay = datatable(flights_no_2hr_delay)
  )
}

# Fonction pour trouver les vols partis ou arrivés plus tôt que prévu
early_flights <- function(flights) {
  early_departure <- flights %>%
    filter(dep_delay < 0)
  
  early_arrival <- flights %>%
    filter(arr_delay < 0)
  
  list(
    early_departure = datatable(early_departure),
    early_arrival = datatable(early_arrival)
  )
}

# Fonction pour trouver les vols partis avec une heure de retard ou plus mais ayant rattrapé plus de 30 minutes
catch_up_flights <- function(flights) {
  flights_catchup <- flights %>%
    filter(dep_delay >= 60 & (arr_delay - dep_delay) < -30)
  
  datatable(flights_catchup)
}

# Fonction pour calculer le gain par heure
calculate_gain_per_hour <- function(flights) {
  flights <- flights %>%
    mutate(
      gain = arr_delay - dep_delay,
      gain_per_hour = gain / (air_time / 60)
    )
  
  datatable(flights)
}

# Fonction pour trier les vols selon leur vitesse
sort_by_speed <- function(flights) {
  flights <- flights %>%
    mutate(speed = distance / (air_time / 60))
  
  flights_speed <- flights %>%
    arrange(desc(speed))
  
  longest_flight <- flights %>%
    arrange(desc(distance)) %>%
    head(1)
  
  shortest_flight <- flights %>%
    arrange(distance) %>%
    head(1)
  
  list(
    flights_speed = datatable(flights_speed),
    longest_flight = datatable(longest_flight),
    shortest_flight = datatable(shortest_flight)
  )
}
