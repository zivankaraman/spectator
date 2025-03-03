library(spectator)
library(sf)
library(maps)

sat <- "Landsat-9"
day <- Sys.Date()  + 2
plan <- GetAcquisitionPlan(satellites = sat, date = day)

png(filename = "./misc/L9.png", width = 640, height = 480)
xl <- c(-170, 170)
yl <- c(-60, 75)
map("world", fill = TRUE, col = "lightgrey", bg = "lightblue", xlim = xl, ylim = yl)
plot(st_geometry(plan), border = "red", add = TRUE)
title(main = sprintf("%s acquisition plan for %s", sat, day))
dev.off()
