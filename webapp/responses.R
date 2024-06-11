library(dplyr)
library(ggplot2)
library(DT)

# Définir les fonctions pour les réponses


# Fonction pour transformer les colonnes de temps en datetime et les supprimer ensuite
transform_datetime <- function(flights) {
  flights <- flights %>%
    mutate(
      sched_dep_time = make_datetime(year, month, day, hour, minute),
      dep_time = make_datetime(year, month, day, dep_time %/% 100, dep_time %% 100),
      arr_time = make_datetime(year, month, day, arr_time %/% 100, arr_time %% 100),
      sched_arr_time = make_datetime(year, month, day, sched_arr_time %/% 100, sched_arr_time %% 100)
    ) %>%
    select(-year, -month, -day, -hour, -minute)
  return(flights)
}


# 1. Combien y-a-t-il :
total_airports <- function(airports) {
  paste("Total d'aéroports :", nrow(airports))
}

no_dst_airports <- function(airports) {
  no_dst_count <- nrow(filter(airports, dst == "N"))
  paste("Nombre d'aéroports sans heure d'été :", no_dst_count)
}

time_zones <- function(airports) {
  time_zones_count <- length(unique(airports$tzone))
  paste("Nombre de fuseaux horaires :", time_zones_count)
}

counts <- function(airlines, planes, flights) {
  num_companies <- nrow(as.data.frame(airlines))
  num_planes <- nrow(planes)
  num_cancelled_flights <- nrow(filter(flights, is.na(dep_time) & is.na(arr_time)))
  paste("Nombre de compagnies :", num_companies, "\n",
        "Nombre d'avions :", num_planes, "\n",
        "Nombre de vols annulés :", num_cancelled_flights)
}

# 2. Aéroport et destinations
busiest_departure <- function(flights) {
  busiest_airport <- flights %>%
    group_by(origin) %>%
    summarise(total_flights = n()) %>%
    arrange(desc(total_flights)) %>%
    slice(1) %>%
    pull(origin)
  paste("Aéroport de départ le plus emprunté :", busiest_airport)
}

top_10_destinations <- function(flights) {
  flights %>%
    group_by(dest) %>%
    summarise(total_flights = n()) %>%
    arrange(desc(total_flights)) %>%
    head(10) %>%
    datatable()
}

bottom_10_destinations <- function(flights) {
  flights %>%
    group_by(dest) %>%
    summarise(total_flights = n()) %>%
    arrange(total_flights) %>%
    head(10) %>%
    datatable()
}

top_10_planes <- function(flights) {
  flights %>%
    group_by(tailnum) %>%
    summarise(total_flights = n()) %>%
    arrange(desc(total_flights)) %>%
    head(10) %>%
    datatable()
}

# 3. Compagnies et destinations
company_destinations <- function(flights) {
  flights %>%
    group_by(carrier, dest) %>%
    summarise(total_flights = n()) %>%
    group_by(carrier) %>%
    summarise(destinations = n()) %>%
    datatable()
}

company_origin_destinations <- function(flights) {
  flights %>%
    group_by(carrier, origin, dest) %>%
    summarise(total_flights = n()) %>%
    group_by(carrier, origin) %>%
    summarise(destinations = n()) %>%
    datatable()
}

company_destinations_plot <- function(flights) {
  company_destinations <- flights %>%
    group_by(carrier, dest) %>%
    summarise(total_flights = n()) %>%
    group_by(carrier) %>%
    summarise(destinations = n())
  ggplot(company_destinations, aes(x = carrier, y = destinations)) +
    geom_bar(stat = "identity") +
    labs(title = "Nombre de destinations par compagnie", x = "Compagnie", y = "Nombre de destinations")
}

company_origin_destinations_plot <- function(flights) {
  company_origin_destinations <- flights %>%
    group_by(carrier, origin, dest) %>%
    summarise(total_flights = n()) %>%
    group_by(carrier, origin) %>%
    summarise(destinations = n())
  ggplot(company_origin_destinations, aes(x = carrier, y = destinations, fill = origin)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Nombre de destinations par compagnie et aéroport d’origine", x = "Compagnie", y = "Nombre de destinations")
}

# 4. Vols spécifiques
flights_to_houston <- function(flights) {
  flights_to_houston <- nrow(filter(flights, dest %in% c("IAH", "HOU")))
  paste("Nombre de vols ayant atterri à Houston :", flights_to_houston)
}

nyc_to_seattle <- function(flights) {
  nyc_to_seattle <- nrow(filter(flights, origin %in% c("JFK", "LGA", "EWR") & dest == "SEA"))
  paste("Nombre de vols de NYC vers Seattle :", nyc_to_seattle)
}

seattle_companies <- function(flights) {
  seattle_companies <- flights %>%
    filter(origin %in% c("JFK", "LGA", "EWR") & dest == "SEA") %>%
    summarise(companies = n_distinct(carrier)) %>%
    pull(companies)
  paste("Nombre de compagnies desservant Seattle :", seattle_companies)
}

seattle_planes <- function(flights) {
  seattle_planes <- flights %>%
    filter(origin %in% c("JFK", "LGA", "EWR") & dest == "SEA") %>%
    summarise(planes = n_distinct(tailnum)) %>%
    pull(planes)
  paste("Nombre d’avions uniques desservant Seattle :", seattle_planes)
}

# 5. Vols par destination
flights_by_destination <- function(flights, airports) {
  flights_by_dest <- flights %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    group_by(dest, name) %>%
    summarise(total_flights = n()) %>%
    arrange(desc(total_flights))
  datatable(flights_by_dest)
}

# 6. Compagnies et aéroports
incomplete_companies <- function(flights) {
  incomplete_companies <- flights %>%
    group_by(carrier, origin) %>%
    summarise(destinations = n_distinct(dest)) %>%
    group_by(carrier) %>%
    summarise(origins = n()) %>%
    filter(origins < n_distinct(flights$origin)) %>%
    datatable()
}

complete_companies <- function(flights) {
  complete_companies <- flights %>%
    group_by(carrier) %>%
    summarise(destinations = n_distinct(dest)) %>%
    filter(destinations == n_distinct(flights$dest)) %>%
    datatable()
}

orig_dest_by_company <- function(flights) {
  flights %>%
    select(carrier, origin, dest) %>%
    distinct() %>%
    datatable()
}

# 7. Destinations exclusives
exclusive_destinations <- function(flights) {
  exclusive_destinations <- flights %>%
    group_by(dest) %>%
    summarise(companies = n_distinct(carrier)) %>%
    filter(companies == 1) %>%
    datatable()
}

# 8. Vols par compagnies spécifiques
specific_company_flights <- function(flights) {
  specific_company_flights <- flights %>%
    filter(carrier %in% c("UA", "AA", "DL")) %>%
    datatable()
}
