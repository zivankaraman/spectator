# examples for overpasses over an area of interest
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites
# this functionality requires an api_key, here we use default value Sys.getenv("spectator_earth_api_key")

library(sf)

# get the Luxembourg country shape as area of interest
dsn <- system.file("extdata", "luxembourg.geojson", package = "spectator")
dsn <- system.file("extdata", "centralpark.geojson", package = "spectator")

boundary <- sf::read_sf(dsn, as_tibble = FALSE)

# look for Sentinel-2 A and B, use shorthand notation, get maximal time frame, ignore acquisition attribute
pass <- GetOverpasses(boundary, satellites = "S2", days_before = 99, days_after = 99, acquisitions = FALSE)

# fix NA acquisitions based on the time of the day
# must first convert to local time
library(lutz)
if (FALSE) {
    koords <- sf::st_coordinates(sf::st_centroid(boundary, of_largest_polygon = FALSE))
    tz <- lutz::tz_lookup_coords(lat = koords[, "Y"], lon = koords[, "X"], method = "accurate")
} else { # this is simpler way of doing it
    tz <- lutz::tz_lookup(sf::st_centroid(sf::st_geometry(boundary)), method = "accurate")
}
localtime <- lubridate::local_time(pass$date, tz = tz, units = "hours")
pass$acquisition <- localtime > 6 & localtime < 18
pass <- subset(pass, acquisition == TRUE)

# plot nice overpasses calendar
library(calendR)
library(lubridate)

time_span <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
first_date <- lubridate::floor_date(lubridate::ymd(time_span[1]), unit = "month") 
last_date <- lubridate::ceiling_date(lubridate::ymd(time_span[2]), unit = "month") - 1
days <- first_date:last_date
passes <- as.Date(pass$date)
events <- rep(NA, length(days))
events[passes - first_date + 1] <- pass$satellite

calendR::calendR(from = first_date, to = last_date, 
                 title = "Sentinel 2 overpasses calendar",
                 special.days = events,
                 special.col = 2:(length(satellites) + 1),
                 col = "grey",
                 mbg.col = 4,               # Color of the background of the names of the months
                 months.col = "white",      # Color text of the names of the months        
                 bg.col = "#f4f4f4",        # Background color
                 start = "M",               # Start the weeks on Monday
                 legend.pos = "right")

