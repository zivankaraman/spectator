library(spectator)
satellites_db <- GetAllSatellites(positions = FALSE)
save(satellites_db, file = "data/satellites_db.rda")
