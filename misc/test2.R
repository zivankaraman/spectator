
library(maps)
library(sf)

sat <- c("Sentinel-2A", "Sentinel-2B")
sat <- "Landsat-8"
day <- Sys.Date()
day <- "2021-08-01"

plan <- GetAcquisitionPlan(satellites = sat, date = day)
plan <- GetAcquisitionPlan()

map("world", fill = TRUE, col = "lightgrey")
plot(st_geometry(plan), border = "red", add = TRUE)
title(main = sprintf("%s acquisition plan for %s", paste(sat, collapse = "/"), day))
