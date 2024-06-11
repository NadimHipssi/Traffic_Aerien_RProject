familiarisationUI <- function() {
  tabPanel("Familiarisation avec les données",
           tagList(
             h3("Familiarisation avec les données"),
             h4("1. Nombre d'aéroports, de compagnies, d'avions et de vols annulés"),
             verbatimTextOutput("counts"),
             
             h4("2. Aéroports les plus empruntés"),
             verbatimTextOutput("busiest_departure"),
             dataTableOutput("top_10_destinations"),
             dataTableOutput("bottom_10_destinations"),
             
             h4("3. Nombre de destinations desservies par chaque compagnie"),
             dataTableOutput("company_destinations"),
             dataTableOutput("company_origin_destinations"),
             plotOutput("company_destinations_plot"),
             plotOutput("company_origin_destinations_plot"),
             
             h4("4. Vols vers Houston et de NYC vers Seattle"),
             verbatimTextOutput("flights_to_houston"),
             verbatimTextOutput("nyc_to_seattle"),
             verbatimTextOutput("seattle_companies"),
             verbatimTextOutput("seattle_planes"),
             
             h4("5. Vols par destination"),
             dataTableOutput("flights_by_destination"),
             
             h4("6. Compagnies ne desservant pas tous les aéroports d'origine et desservant toutes les destinations"),
             dataTableOutput("incomplete_companies"),
             dataTableOutput("complete_companies"),
             dataTableOutput("orig_dest_by_company"),
             
             h4("7. Destinations exclusives à certaines compagnies"),
             dataTableOutput("exclusive_destinations"),
             
             h4("8. Vols des compagnies spécifiques"),
             dataTableOutput("specific_company_flights")
           )
  )
}

familiarisationServer <- function(input, output, session, airports, flights, planes, weather, airlines) {
  # Code de traitement et de rendu pour les questions de familiarisation
}
