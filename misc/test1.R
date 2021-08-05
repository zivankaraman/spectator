
library(maps)
library(sf)

pos <- GetAllSatellites(positions = TRUE)

map("world", fill = TRUE, col = "lightgrey")
# open data satellites in green
plot(st_geometry(subset(pos, open == TRUE)), add = TRUE, col = "green", pch = 15)
# others in red
plot(st_geometry(subset(pos, open == FALSE)), add = TRUE, col = "red", pch = 16)
# add labels
xy <- st_coordinates(pos)
# shift labels up to be able to read them
xy[, 2] <- xy[, 2] + 2 
text(xy, labels = pos$name, cex = 0.5)


sat <- "SPOT-6"
traj <- GetTrajectory(satellite = sat)
pos <- GetSatellite(satellite = sat, positions = TRUE)

map("world", fill = TRUE, col = "lightgrey")
plot(st_geometry(st_as_sf(traj)), lwd = 2, col = "red", add = TRUE)
plot(st_geometry(pos), pch = 15, col = "green", cex = 1.5, add = TRUE)
title(main = sprintf("current %s trajectory & position", sat))

