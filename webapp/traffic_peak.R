library(dplyr)
library(ggplot2)
library(lubridate)
library(DT)

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

# Fonction pour créer un histogramme de transformation de datetime
plot_datetime_transformation <- function(flights) {
  ggplot(flights, aes(x = sched_dep_time)) +
    geom_histogram(binwidth = 86400) +  # Bin width of one day
    labs(title = "Distribution des vols par date de départ prévue", x = "Date de départ prévue", y = "Nombre de vols")
}

# Fonction pour visualiser le trafic mensuel par aéroport d'origine
plot_monthly_traffic <- function(flights) {
  flights %>%
    mutate(month = floor_date(sched_dep_time, "month")) %>%
    group_by(origin, month) %>%
    summarise(num_flights = n(), .groups = 'drop') %>%
    ggplot(aes(x = month, y = num_flights, color = origin)) +
    geom_line() +
    geom_hline(aes(yintercept = mean(num_flights)), linetype = "dashed") +
    facet_wrap(~ origin, scales = "free_y") +
    labs(title = "Trafic Mensuel par Aéroport d'Origine", x = "Mois", y = "Nombre de Vols")
}

# Fonction pour visualiser la courbe du taux d'accroissement mensuel
plot_growth_rate <- function(flights) {
  flights %>%
    mutate(month = floor_date(sched_dep_time, "month")) %>%
    group_by(origin, month) %>%
    summarise(num_flights = n(), .groups = 'drop') %>%
    group_by(origin) %>%
    mutate(monthly_avg = mean(num_flights), 
           growth_rate = (num_flights - lag(num_flights)) / lag(num_flights)) %>%
    ggplot(aes(x = month, y = num_flights)) +
    geom_line() +
    geom_line(aes(y = growth_rate * monthly_avg), color = "red") +
    geom_hline(aes(yintercept = monthly_avg), linetype = "dashed") +
    facet_wrap(~ origin, scales = "free_y") +
    labs(title = "Trafic Mensuel par Aéroport avec Taux d'Accroissement", x = "Mois", y = "Nombre de Vols")
}

# Fonction pour obtenir le top 3 des aéroports d'origine et de destination
get_top_3_airports <- function(flights) {
  top_origin_airports <- flights %>%
    group_by(origin) %>%
    summarise(total_flights = n(), .groups = 'drop') %>%
    arrange(desc(total_flights)) %>%
    head(3) %>%
    mutate(type = "Origin")
  
  top_dest_airports <- flights %>%
    group_by(dest) %>%
    summarise(total_flights = n(), .groups = 'drop') %>%
    arrange(desc(total_flights)) %>%
    head(3) %>%
    mutate(type = "Destination")
  
  colnames(top_origin_airports) <- c("airport", "total_flights", "type")
  colnames(top_dest_airports) <- c("airport", "total_flights", "type")
  
  combined_airports <- rbind(top_origin_airports, top_dest_airports)
  
  datatable(combined_airports)
}

# Fonction pour filtrer les vols pour des dates spécifiques
get_specific_dates_flights <- function(flights) {
  vols_1er_janvier <- flights %>%
    filter(month(sched_dep_time) == 1 & day(sched_dep_time) == 1)
  
  vols_nov_dec <- flights %>%
    filter(month(sched_dep_time) %in% c(11, 12))
  
  jours_speciaux <- flights %>%
    filter(
      (month(sched_dep_time) == 12 & day(sched_dep_time) == 25) |
        (month(sched_dep_time) == 1 & day(sched_dep_time) == 1) |
        (month(sched_dep_time) == 7 & day(sched_dep_time) == 4) |
        (month(sched_dep_time) == 11 & day(sched_dep_time) == 29)
    )
  
  vols_ete <- flights %>%
    filter(month(sched_dep_time) %in% c(7, 8, 9))
  
  vols_minuit_6h <- flights %>%
    filter(hour(sched_dep_time) >= 0 & hour(sched_dep_time) <= 6)
  
  data.frame(
    Date = c("1er Janvier", "Novembre et Décembre", "Jours Spéciaux", "Été", "Minuit à 6h"),
    Vols = c(nrow(vols_1er_janvier), nrow(vols_nov_dec), nrow(jours_speciaux), nrow(vols_ete), nrow(vols_minuit_6h))
  ) %>% datatable()
}

# Interface utilisateur pour l'onglet Pic de trafic aéroportuaire
trafficPeakUI <- function() {
  tabPanel("Pic de trafic aéroportuaire",
           tagList(
             h3("3.1 Pic de trafic aéroportuaire"),
             h4("1. Reconstitution de l’information sched_dep_time"),
             plotOutput("datetime_transformation"),
             
             h4("2. Visualisation mensuelle du trafic par aéroport d'origine"),
             plotOutput("monthly_traffic"),
             
             h4("3. Courbe du taux d'accroissement mensuel"),
             plotOutput("growth_rate_plot"),
             
             h4("4. Top 3 des aéroports d'origine et de destination avec le plus de trafic"),
             dataTableOutput("top_3_airports"),
             
             h4("5. Filtrage des vols pour des dates spécifiques"),
             dataTableOutput("specific_dates_flights")
           )
  )
}

# Serveur pour l'onglet Pic de trafic aéroportuaire
trafficPeakServer <- function(input, output, session, flights) {
  output$datetime_transformation <- renderPlot({
    plot_datetime_transformation(flights)
  })
  
  output$monthly_traffic <- renderPlot({
    plot_monthly_traffic(flights)
  })
  
  output$growth_rate_plot <- renderPlot({
    plot_growth_rate(flights)
  })
  
  output$top_3_airports <- renderDataTable({
    get_top_3_airports(flights)
  })
  
  output$specific_dates_flights <- renderDataTable({
    get_specific_dates_flights(flights)
  })
}
