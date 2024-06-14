install.packages("DBI")
install.packages("RSQLite")  # Pour SQLite, changez selon votre base de données
install.packages("RMariaDB")  # Installer le package si nécessaire

library(DBI)
library(RSQLite)  # Pour SQLite, changez selon votre base de données
library(RMariaDB)

con <- dbConnect(MariaDB(), user = "hamimid", password = "hamimid1234&",
                 dbname = "hamimid_airports", host = "mysql-hamimid.alwaysdata.net")
# Requête SQL
query <- "SELECT * FROM airlines"

# Exécuter la requête et fetch les résultats dans un data frame
df <- dbGetQuery(con, query)

# Afficher les premières lignes du data frame
head(df)
