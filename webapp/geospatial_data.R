geospatialDataUI <- function() {
  tabPanel("Gestion des données géospatiales",
           tagList(
             h3("Gestion des données géospatiales"),
             
             h4("Carte des États-Unis avec flèches origine-destination"),
             plotOutput("us_map_plot"),
             
             h4("Lignes aériennes les plus empruntées"),
             plotOutput("top_routes_plot")
           )
  )
}

geospatialDataServer <- function(input, output, session, flights, airports) {
  
  # Jointure entre flights et airports pour obtenir les coordonnées
  flights_geo <- flights %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    rename(origin_lat = lat, origin_lon = lon) %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    rename(dest_lat = lat, dest_lon = lon)
  
  # Dessiner la carte des États-Unis avec les flèches origine-destination
  output$us_map_plot <- renderPlot({
    ggplot() +
      borders("state", colour = "gray50", fill = "gray50") +
      geom_segment(data = flights_geo, aes(x = origin_lon, y = origin_lat, xend = dest_lon, yend = dest_lat),
                   arrow = arrow(length = unit(0.2, "cm")), color = "black", alpha = 0.5) +
      labs(title = "Lignes Aériennes les Plus Empruntées aux États-Unis", x = "Longitude", y = "Latitude")
  })
  
  # Lignes aériennes les plus empruntées
  top_routes <- flights %>%
    group_by(origin, dest) %>%
    summarise(num_flights = n()) %>%
    arrange(desc(num_flights)) %>%
    head(100) %>%
    left_join(airports, by = c("origin" = "faa")) %>%
    rename(origin_lat = lat, origin_lon = lon) %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    rename(dest_lat = lat, dest_lon = lon)
  
  output$top_routes_plot <- renderPlot({
    ggplot() +
      borders("state", colour = "gray50", fill = "gray50") +
      geom_segment(data = top_routes, aes(x = origin_lon, y = origin_lat, xend = dest_lon, yend = dest_lat),
                   arrow = arrow(length = unit(0.2, "cm")), color = "blue", alpha = 0.5) +
      labs(title = "Top 100 Lignes Aériennes les Plus Empruntées", x = "Longitude", y = "Latitude")
  })
}
