volsAnnulesUI <- function() {
  tabPanel("Vols annulés et données manquantes",
           tagList(
             h3("Vols annulés et gestion des données manquantes"),
             h4("1. Proportion des données manquantes"),
             dataTableOutput("missing_data_proportions"),
             
             h4("2. Nombre de vols annulés"),
             dataTableOutput("cancelled_flights_summary"),
             
             h4("3. Trier les vols par heure de départ et retard de départ (NA en premier)"),
             dataTableOutput("sorted_by_dep_delay"),
             
             h4("4. Trier les vols par retard de départ et heure de départ (NA en premier)"),
             dataTableOutput("sorted_by_dep_delay_and_time")
           )
  )
}

volsAnnulesServer <- function(input, output, session, flights) {
  # 1. Proportion des données manquantes
  output$missing_data_proportions <- renderDataTable({
    na_proportions <- sapply(flights, function(x) sum(is.na(x)) / length(x))
    data.frame(Column = names(na_proportions), NA_Proportion = na_proportions)
  })
  
  # 2. Nombre de vols annulés
  output$cancelled_flights_summary <- renderDataTable({
    cancelled_flights <- flights %>%
      filter(is.na(dep_time) & is.na(arr_time)) %>%
      summarise(count = n(), .groups = 'drop')
    
    cancelled_by_dest <- flights %>%
      filter(is.na(dep_time) & is.na(arr_time)) %>%
      group_by(dest) %>%
      summarise(count = n(), .groups = 'drop')
    
    cancelled_by_carrier <- flights %>%
      filter(is.na(dep_time) & is.na(arr_time)) %>%
      group_by(carrier) %>%
      summarise(count = n(), .groups = 'drop')
    
    rbind(
      data.frame(Type = "Total Cancelled Flights", Destination = NA, Carrier = NA, Count = cancelled_flights$count),
      data.frame(Type = "Cancelled by Destination", Destination = cancelled_by_dest$dest, Carrier = NA, Count = cancelled_by_dest$count),
      data.frame(Type = "Cancelled by Carrier", Destination = NA, Carrier = cancelled_by_carrier$carrier, Count = cancelled_by_carrier$count)
    )
  })
  
  # 3. Trier les vols par heure de départ et retard de départ (NA en premier)
  output$sorted_by_dep_delay <- renderDataTable({
    flights %>%
      arrange(is.na(dep_delay), desc(dep_delay))
  })
  
  # 4. Trier les vols par retard de départ et heure de départ (NA en premier)
  output$sorted_by_dep_delay_and_time <- renderDataTable({
    flights %>%
      arrange(is.na(dep_delay), desc(dep_delay), dep_time)
  })
}
