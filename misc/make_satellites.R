library(spectator)
satellites <- GetAllSatellites(positions = FALSE)
save(satellites, file = "data/satellites.rda")
