# examples for overpasses over an area of interest
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites
# this functionality requires an api_key, will try to use default value Sys.getenv("spectator_earth_api_key"),
# if not set, will prompt the user to enter it

# first check that we have the api_key
key <- Sys.getenv("spectator_earth_api_key")
if (key == "") {
    key <- readline("This demo requires a Spectator Earth api_key, please enter your API key here: ")
}
if (key == "") {
    stop("This demon can't run without an api_key, aborting")
}


library(sf)

# get the Luxembourg country shape as area of interest
dsn <- system.file("extdata", "luxembourg.geojson", package = "spectator")
boundary <- read_sf(dsn, as_tibble = FALSE)

# look for Sentinel-2 A and B, use shorthand notation, default time frame
pass <- GetOverpasses(aoi = boundary, satellites = "S-2", acquisitions = TRUE, api_key = key)

# do some nice graphs
library(maps)
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg", "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))

# look for Sentinel-1 A, use shorthand notation, last week  
pass <- GetOverpasses(boundary, satellites = "S-1A", days_before = 7, days_after = 0, acquisitions = TRUE)

# do some nice graphs
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg", "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))

