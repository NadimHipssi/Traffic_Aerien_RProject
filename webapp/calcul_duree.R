calculDureeUI <- function() {
  tabPanel("Calcul de durée",
           tagList(
             h3("1.1 Calcul de durée"),
             
             h4("Conversion des heures en minutes écoulées depuis minuit"),
             dataTableOutput("converted_times"),
             
             h4("Comparaison des colonnes dep_time, sched_dep_time et dep_delay"),
             plotOutput("dep_time_comparison"),
             
             h4("Top 10 des vols les plus retardés"),
             dataTableOutput("top_10_delayed_flights"),
             
             h4("Comparaison air_time avec arr_time - dep_time"),
             dataTableOutput("air_time_comparison")
           )
  )
}

calculDureeServer <- function(input, output, session, flights) {
  
  # Conversion des heures en minutes écoulées depuis minuit
  flights <- flights %>%
    mutate(
      dep_time_min = hour(dep_time) * 60 + minute(dep_time),
      sched_dep_time_min = hour(sched_dep_time) * 60 + minute(sched_dep_time)
    )
  
  # 1. Conversion des heures
  output$converted_times <- renderDataTable({
    flights %>%
      select(dep_time, dep_time_min, sched_dep_time, sched_dep_time_min)
  })
  
  # 2. Comparaison des colonnes dep_time, sched_dep_time et dep_delay
  output$dep_time_comparison <- renderPlot({
    ggplot(flights, aes(x = sched_dep_time_min, y = dep_time_min - sched_dep_time_min)) +
      geom_point(alpha = 0.3) +
      labs(title = "Comparaison de dep_time, sched_dep_time et dep_delay",
           x = "Heure de départ prévue (minutes écoulées depuis minuit)",
           y = "Différence entre dep_time et sched_dep_time (minutes)")
  })
  
  # 3. Top 10 des vols les plus retardés
  output$top_10_delayed_flights <- renderDataTable({
    flights %>%
      arrange(desc(dep_delay)) %>%
      mutate(rank = min_rank(desc(dep_delay))) %>%
      head(10) %>%
      select(flight, dep_delay, rank)
  })
  
  # 4. Comparaison air_time avec arr_time - dep_time
  output$air_time_comparison <- renderDataTable({
    flights %>%
      mutate(
        actual_air_time = (hour(arr_time) * 60 + minute(arr_time)) - dep_time_min
      ) %>%
      select(flight, air_time, actual_air_time) %>%
      mutate(difference = actual_air_time - air_time)
  })
}
