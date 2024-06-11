retardDistanceUI <- function() {
  tabPanel("Retard et distance",
           tagList(
             h3("Relation entre retard à l’arrivée et distance"),
             h4("1. Regrouper les vols par destination"),
             dataTableOutput("group_by_dest"),
             
             h4("2. Calculer le retard moyen par destination"),
             dataTableOutput("delay_by_dest"),
             
             h4("3. Harmoniser la distance"),
             dataTableOutput("harmonize_distance"),
             
             h4("4. Exclusion de HNL comme outlier"),
             dataTableOutput("exclude_hnl"),
             
             h4("Fig : relation entre la distance et le retard moyen"),
             plotOutput("distance_delay_plot"),
             
             h4("6. Destinations les plus touchées et compagnies concernées"),
             dataTableOutput("affected_dest_companies"),
             
             h4("7. Résumé statistique des retards"),
             dataTableOutput("delay_summary"),
             
             h4("8. Aéroport avec le retard moyen le plus faible"),
             dataTableOutput("lowest_avg_delay_airport"),
             
             h4("9. Relation entre heure de décollage et retard"),
             plotOutput("takeoff_time_delay_plot")
           )
  )
}

retardDistanceServer <- function(input, output, session, flights) {
  # 1. Regrouper les vols par destination
  output$group_by_dest <- renderDataTable({
    flights %>%
      group_by(dest) %>%
      summarise(count = n())
  })
  
  # 2. Calculer le retard moyen par destination
  output$delay_by_dest <- renderDataTable({
    flights %>%
      group_by(dest) %>%
      summarise(delay_moy = mean(arr_delay, na.rm = TRUE))
  })
  
  # 3. Harmoniser la distance
  output$harmonize_distance <- renderDataTable({
    flights %>%
      group_by(dest) %>%
      summarise(dist_moy = mean(distance, na.rm = TRUE))
  })
  
  # 4. Exclusion de HNL comme outlier
  output$exclude_hnl <- renderDataTable({
    flights %>%
      filter(dest != "HNL")
  })
  
  # 5. Relation entre distance et retard moyen
  output$distance_delay_plot <- renderPlot({
    flights_filtered <- flights %>%
      filter(dest != "HNL")
    
    ggplot(flights_filtered, aes(x = distance, y = arr_delay)) +
      geom_point() +
      geom_smooth(method = "lm") +
      labs(title = "Relation entre Distance et Retard Moyen", x = "Distance (miles)", y = "Retard Moyen (minutes)")
  })
  
  # 6. Destinations les plus touchées et compagnies concernées
  output$affected_dest_companies <- renderDataTable({
    flights %>%
      group_by(dest, carrier) %>%
      summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
      arrange(desc(avg_arr_delay))
  })
  
  # 7. Résumé statistique des retards
  output$delay_summary <- renderDataTable({
    data.frame(
      Summary = c("Arrivée", "Départ"),
      Mean = c(mean(flights$arr_delay, na.rm = TRUE), mean(flights$dep_delay, na.rm = TRUE)),
      Median = c(median(flights$arr_delay, na.rm = TRUE), median(flights$dep_delay, na.rm = TRUE)),
      SD = c(sd(flights$arr_delay, na.rm = TRUE), sd(flights$dep_delay, na.rm = TRUE))
    )
  })
  
  # 8. Aéroport avec le retard moyen le plus faible
  output$lowest_avg_delay_airport <- renderDataTable({
    flights %>%
      group_by(dest) %>%
      summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
      arrange(avg_arr_delay) %>%
      head(1)
  })
  
  # 9. Relation entre heure de décollage et retard
  output$takeoff_time_delay_plot <- renderPlot({
    ggplot(flights, aes(x = hour(sched_dep_time), y = arr_delay)) +
      geom_point() +
      geom_smooth(method = "lm") +
      labs(title = "Relation entre Heure de Décollage et Retard à l'Arrivée", x = "Heure de Décollage", y = "Retard à l'Arrivée (minutes)")
  })
}
