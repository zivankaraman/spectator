# examples for acquisition plans
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites

library(sf)
# get plans for all eligible satellites for today
plans <- GetAcquisitionPlan()
# explore the content of the data frame, you'll see that the available attributes vary with the satellite

# focus on Sentinel 2
sat <- c("Sentinel-2A", "Sentinel-2B")
# day after tomorrow
day <- Sys.Date()  + 2
plan <- GetAcquisitionPlan(satellites = sat, date = day)

# do some nice graphs
library(maps)
map("world", fill = TRUE, col = "lightgrey")
plot(st_geometry(plan), border = "red", add = TRUE)
title(main = sprintf("%s acquisition plan for %s", paste(sat, collapse = "/"), day))
