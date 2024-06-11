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
  # Les fonctions associées doivent être définies dans "responses.R"
  output$counts <- renderText({
    paste(total_airports(airports), "\n",
          no_dst_airports(airports), "\n",
          time_zones(airports), "\n",
          counts(airlines, planes, flights))
  })
  
  output$busiest_departure <- renderText({
    busiest_departure(flights)
  })
  
  output$top_10_destinations <- renderDataTable({
    top_10_destinations(flights)
  })
  
  output$bottom_10_destinations <- renderDataTable({
    bottom_10_destinations(flights)
  })
  
  output$company_destinations <- renderDataTable({
    company_destinations(flights)
  })
  
  output$company_origin_destinations <- renderDataTable({
    company_origin_destinations(flights)
  })
  
  output$company_destinations_plot <- renderPlot({
    company_destinations_plot(flights)
  })
  
  output$company_origin_destinations_plot <- renderPlot({
    company_origin_destinations_plot(flights)
  })
  
  output$flights_to_houston <- renderText({
    flights_to_houston(flights)
  })
  
  output$nyc_to_seattle <- renderText({
    nyc_to_seattle(flights)
  })
  
  output$seattle_companies <- renderText({
    seattle_companies(flights)
  })
  
  output$seattle_planes <- renderText({
    seattle_planes(flights)
  })
  
  output$flights_by_destination <- renderDataTable({
    flights_by_destination(flights, airports)
  })
  
  output$incomplete_companies <- renderDataTable({
    incomplete_companies(flights)
  })
  
  output$complete_companies <- renderDataTable({
    complete_companies(flights)
  })
  
  output$orig_dest_by_company <- renderDataTable({
    orig_dest_by_company(flights)
  })
  
  output$exclusive_destinations <- renderDataTable({
    exclusive_destinations(flights)
  })
  
  output$specific_company_flights <- renderDataTable({
    specific_company_flights(flights)
  })
}
