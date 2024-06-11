library(shiny)
library(DT)
library(leaflet)

# Inclure les fichiers UI
source("accueil.R")
source("familiarisation.R")
source("traffic_peak.R")
source("delays.R")
source("retard_distance.R")
source("vols_annules.R")
source("calcul_duree.R")
source("geospatial_data.R")

# Interface Utilisateur
ui <- fluidPage(
  navbarPage("AIR TRAFFIC",
             accueilUI(),
             tabPanel("Aéroports",
                      h2("Données des Aéroports"),
                      dataTableOutput("airports_table"),
                      leafletOutput("airports_map")
             ),
             tabPanel("Compagnies",
                      h2("Données des Compagnies"),
                      dataTableOutput("airlines_table")
             ),
             tabPanel("Météo",
                      h2("Données Météo"),
                      dataTableOutput("weather_table")
             ),
             tabPanel("Avions",
                      h2("Données des Avions"),
                      dataTableOutput("planes_table")
             ),
             tabPanel("Vols",
                      h2("Données des Vols"),
                      dataTableOutput("flights_table")
             ),
             tabPanel("Réponses aux questions",
                      tabsetPanel(
                        familiarisationUI(),
                        tabPanel("Pic de trafic aéroportuaire",
                                 uiOutput("traffic_peak_ui")
                        ),
                        tabPanel("Retard à l’arrivée et/ou au départ",
                                 uiOutput("delays_ui")
                        ),
                        retardDistanceUI(),
                        volsAnnulesUI(),
                        calculDureeUI(),
                        geospatialDataUI()
                      )
             )
  )
)
