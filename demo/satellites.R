# examples for using satellites related functions
# works for all satellites referenced in the in the Spectator Earth database

library(sf)

# get all satellites withe their positions
pos <- GetAllSatellites(positions = TRUE)

# do some nice graphs
library(maps)
map("world", fill = TRUE, col = "lightgrey")
# show open data satellites in green
plot(st_geometry(subset(pos, open == TRUE)), add = TRUE, col = "green", pch = 15)
# show others in red
plot(st_geometry(subset(pos, open == FALSE)), add = TRUE, col = "red", pch = 16)
# add labels
xy <- st_coordinates(pos)
# shift labels up to be able to read them
xy[, 2] <- xy[, 2] + 2 
text(xy, labels = pos$name, cex = 0.5)

# get trajectory and current position for a selected satellite
sat <- "SPOT-7"
traj <- GetTrajectory(satellite = sat)
pos <- GetSatellite(satellite = sat, positions = TRUE)

# do some nice graphs
map("world", fill = TRUE, col = "lightgrey")
plot(st_geometry(traj), lwd = 2, col = "red", add = TRUE)
plot(st_geometry(pos), pch = 15, col = "green", cex = 1.5, add = TRUE)
alt <- round(st_coordinates(pos)[, "Z"] / 1000.0)
title(main = sprintf("current %s trajectory & position", sat), sub = sprintf("current altitude %.0f km", alt))

