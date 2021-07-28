library(spectator)
satellites <- GetAllSatellites()
save(satellites, file = "data/satellites.rda")
