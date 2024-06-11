accueilUI <- function() {
  tabPanel("Accueil",
           h1("TRAFFIC AÉRIEN"),
           p("Le projet comporte une liste progressive et détaillée de questions qui permet de monter progressivement en compétence."),
           p("Vous pouvez naviguer entre les différents onglets pour visualiser les données et les graphiques :"),
           tags$ul(
             tags$li("Aéroports : Affiche les données des aéroports et une carte interactive des aéroports."),
             tags$li("Compagnies : Affiche les données des compagnies aériennes."),
             tags$li("Météo : Affiche les données météorologiques."),
             tags$li("Avions : Affiche les données des avions."),
             tags$li("Vols : Affiche les données des vols."),
             tags$li("Graphiques : Affiche des graphiques personnalisés des données des vols."),
             tags$li("Réponses aux questions : Affiche les réponses aux questions du projet.")
           )
  )
}
