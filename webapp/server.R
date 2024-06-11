library(shiny)
library(ggplot2)
library(jsonlite)
library(leaflet)

# Serveur
server <- function(input, output, session) {
  # Lire les fichiers nettoyés
  airports <- read.csv("data/cleaned_airports.csv")
  flights <- read.csv("data/cleaned_flights.csv")
  planes <- read.csv("data/cleaned_planes.csv")
  weather <- read.csv("data/cleaned_weather.csv")
  airlines <- fromJSON("data/cleaned_airlines.json")
  
  # Onglet Aéroports
  output$airports_table <- renderDataTable({
    datatable(airports)
  })
  
  output$airports_map <- renderLeaflet({
    leaflet(airports) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~lon, lat = ~lat,
        popup = ~paste("<b>", name, "</b><br/>FAA: ", faa, "<br/>Latitude: ", lat, "<br/>Longitude: ", lon),
        radius = 5,
        fillOpacity = 0.7,
        color = "#FF0000",
        stroke = FALSE
      )
  })
  
  # Onglet Compagnies
  output$airlines_table <- renderDataTable({
    datatable(as.data.frame(airlines))
  })
  
  # Onglet Météo
  output$weather_table <- renderDataTable({
    datatable(weather)
  })
  
  # Onglet Avions
  output$planes_table <- renderDataTable({
    datatable(planes)
  })
  
  # Onglet Vols
  output$flights_table <- renderDataTable({
    datatable(flights)
  })
  
  # Onglet Graphiques
  output$custom_plot <- renderPlot({
    ggplot(flights, aes(x = air_time, y = distance)) +
      geom_point() +
      labs(title = "Temps de Vol vs Distance", x = "Temps de Vol (minutes)", y = "Distance (miles)")
  })
}
