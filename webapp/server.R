# Charger les fonctions de réponses
source("responses.R")
source("traffic_peak.R")
source("delays.R")
source("retard_distance.R")
source("vols_annules.R")
source("calcul_duree.R")
source("geospatial_data.R")

# Serveur
server <- function(input, output, session) {
  # Lire les fichiers nettoyés
  airports <- read.csv("data/cleaned_airports.csv")
  flights <- read.csv("data/cleaned_flights.csv")
  planes <- read.csv("data/cleaned_planes.csv")
  weather <- read.csv("data/cleaned_weather.csv")
  airlines <- fromJSON("data/cleaned_airlines.json")
  
  # Transformer les colonnes de temps en datetime
  flights <- transform_datetime(flights)
  
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
  
  # Réponses aux questions
  output$responses <- renderUI({
    tabsetPanel(
      tabPanel("Familiarisation avec les données",
               uiOutput("familiarisation_ui")
      ),
      tabPanel("Pic de trafic aéroportuaire",
               uiOutput("traffic_peak_ui")
      ),
      tabPanel("Retard à l’arrivée et/ou au départ",
               uiOutput("delays_ui")
      ),
      tabPanel("Retard et distance",
               uiOutput("retard_distance_ui")
      ),
      tabPanel("Vols annulés et données manquantes",
               uiOutput("vols_annules_ui")
      ),
      tabPanel("Calcul de durée",
               uiOutput("calcul_duree_ui")
      ),
      tabPanel("Gestion des données géospatiales",
               uiOutput("geospatial_data_ui")
      )
    )
  })
  
  # Onglet Familiarisation avec les données
  output$familiarisation_ui <- renderUI({
    familiarisationUI()
  })
  
  familiarisationServer(input, output, session, airports, flights, planes, weather, airlines)
  
  # Onglet Pic de trafic aéroportuaire
  output$traffic_peak_ui <- renderUI({
    trafficPeakUI()
  })
  
  trafficPeakServer(input, output, session, flights)
  
  # Onglet Retard à l’arrivée et/ou au départ
  output$delays_ui <- renderUI({
    delaysUI()
  })
  
  delaysServer(input, output, session, flights)
  
  # Onglet Retard et distance
  output$retard_distance_ui <- renderUI({
    retardDistanceUI()
  })
  
  retardDistanceServer(input, output, session, flights)
  
  # Onglet Vols annulés et données manquantes
  output$vols_annules_ui <- renderUI({
    volsAnnulesUI()
  })
  
  volsAnnulesServer(input, output, session, flights)
  
  # Onglet Calcul de durée
  output$calcul_duree_ui <- renderUI({
    calculDureeUI()
  })
  
  calculDureeServer(input, output, session, flights)
  
  # Onglet Gestion des données géospatiales
  output$geospatial_data_ui <- renderUI({
    geospatialDataUI()
  })
  
  geospatialDataServer(input, output, session, flights, airports)
}

shinyApp(ui = ui, server = server)
