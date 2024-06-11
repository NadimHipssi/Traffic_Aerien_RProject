# Charger les fonctions de réponses
source("responses.R")
source("traffic_peak.R")
source("delays.R")
source("retard_distance.R")
source("vols_annules.R")
source("calcul_duree.R")
source("geospatial_data.R")  # Ajouter cette ligne

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
      tabPanel("Gestion des données géospatiales",  # Ajouter cet onglet
               uiOutput("geospatial_data_ui")
      )
    )
  })
  
  # Onglet Pic de trafic aéroportuaire
  output$traffic_peak_ui <- renderUI({
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
  })
  
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
  
  # Onglet Retard à l’arrivée et/ou au départ
  output$delays_ui <- renderUI({
    tagList(
      h3("Retard à l’arrivée et/ou au départ"),
      h4("1. Vols les plus retardés"),
      dataTableOutput("most_delayed_arrival"),
      dataTableOutput("most_delayed_departure"),
      dataTableOutput("most_delayed_both"),
      
      h4("2. Retard moyen au départ"),
      textOutput("overall_avg_dep_delay"),
      dataTableOutput("daily_avg_dep_delay"),
      
      h4("3. Vols arrivés avec plus de 2 heures de retard, mais partis à l’heure"),
      dataTableOutput("flights_2hr_delay"),
      dataTableOutput("flights_no_2hr_delay"),
      
      h4("4. Vols partis ou arrivés plus tôt que prévu"),
      dataTableOutput("early_departure"),
      dataTableOutput("early_arrival"),
      
      h4("5. Vols partis avec une heure de retard ou plus, mais ayant rattrapé plus de 30 minutes"),
      dataTableOutput("catch_up_flights"),
      
      h4("6. Gain par heure"),
      dataTableOutput("gain_per_hour"),
      
      h4("7. Trier les vols selon leur vitesse"),
      dataTableOutput("flights_speed"),
      dataTableOutput("longest_flight"),
      dataTableOutput("shortest_flight")
    )
  })
  
  # Fonctions pour l'onglet Retard à l’arrivée et/ou au départ
  delayed_flights <- most_delayed_flights(flights)
  output$most_delayed_arrival <- renderDataTable({ delayed_flights$delayed_arrival })
  output$most_delayed_departure <- renderDataTable({ delayed_flights$delayed_departure })
  output$most_delayed_both <- renderDataTable({ delayed_flights$delayed_both })
  
  avg_delay <- average_departure_delay(flights)
  output$overall_avg_dep_delay <- renderText({ avg_delay$overall_avg_delay })
  output$daily_avg_dep_delay <- renderDataTable({ avg_delay$daily_avg_delay })
  
  two_hr_delay <- two_hour_delay(flights)
  output$flights_2hr_delay <- renderDataTable({ two_hr_delay$flights_2hr_delay })
  output$flights_no_2hr_delay <- renderDataTable({ two_hr_delay$flights_no_2hr_delay })
  
  early_flight <- early_flights(flights)
  output$early_departure <- renderDataTable({ early_flight$early_departure })
  output$early_arrival <- renderDataTable({ early_flight$early_arrival })
  
  output$catch_up_flights <- renderDataTable({ catch_up_flights(flights) })
  
  output$gain_per_hour <- renderDataTable({ calculate_gain_per_hour(flights) })
  
  sorted_flights <- sort_by_speed(flights)
  output$flights_speed <- renderDataTable({ sorted_flights$flights_speed })
  output$longest_flight <- renderDataTable({ sorted_flights$longest_flight })
  output$shortest_flight <- renderDataTable({ sorted_flights$shortest_flight })
  
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