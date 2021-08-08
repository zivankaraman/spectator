# examples for overpasses over an area of interest
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites
# this functionality requires an api_key, here we use default value Sys.getenv("spectator_earth_api_key")

library(sf)

# get the Luxembourg country shape as area of interest
boundary <- read_sf(system.file("extdata", "luxembourg.geojson", package = "spectator"))

# look for Sentinel-2 A and B, use shorthand notation, default time frame
pass <- GetOverpasses(boundary, satellites = "S-2", acquisitions = TRUE)

# do some nice graphs
library(maps)
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg", "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))

# look for Sentinel-1 A and B, use shorthand notation, last week  
pass <- GetOverpasses(boundary, satellites = "S-1", days_before = 7, days_after = 0, acquisitions = TRUE)

days_before = 0
days_after = 7

# do some nice graphs
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg", "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))

