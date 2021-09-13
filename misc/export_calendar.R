# example of writing  an overpasses calendar in an iCalander ".ics" file
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites
# this functionality requires an api_key, here we use default value Sys.getenv("spectator_earth_api_key")

my_key <- Sys.getenv("spectator_earth_api_key")

library(sf)

# get the Luxembourg country shape as area of interest
dsn <- system.file("extdata", "luxembourg.geojson", package = "spectator")
dsn <- system.file("extdata", "centralpark.geojson", package = "spectator")

boundary <- sf::read_sf(dsn, as_tibble = FALSE)

# look for Sentinel-2 A and B, use shorthand notation, get maximal time frame, ignore acquisition attribute
pass <- GetOverpasses(boundary, satellites = "S2", days_before = 99, days_after = 99, acquisitions = FALSE, api_key = my_key)

# fix NA acquisitions based on the time of the day
# must first convert to local time
library(lutz)
library(lubridate)

if (FALSE) {
    koords <- sf::st_coordinates(sf::st_centroid(boundary, of_largest_polygon = FALSE))
    tz <- lutz::tz_lookup_coords(lat = koords[, "Y"], lon = koords[, "X"], method = "accurate")
} else { # this is simpler way of doing it
    tz <- lutz::tz_lookup(sf::st_centroid(sf::st_geometry(boundary)), method = "accurate")
}
localtime <- lubridate::local_time(pass$date, tz = tz, units = "hours")
pass$acquisition <- localtime > 6 & localtime < 18
pass <- subset(pass, acquisition == TRUE)


# # convert to local time
# library(lutz)
# library(lubridate)
# tz <- lutz::tz_lookup(sf::st_centroid(sf::st_geometry(boundary)), method = "accurate")
# pass$date <- lubridate::with_tz(pass$date, tzone = tz)


# create overpasses calendar
library(calendar)

N <- nrow(pass)
lst <- vector(mode = "list", length = N)
for (i in 1:nrow(pass)) {
    x <- pass[i, ]
    lst[[i]] <- ic_event(uid = ic_guid(), start_time = x$date, end_time = x$date, summary = x$satellite)
} 

cal <- ical(do.call(rbind, lst))
# cal[, "TZID"] <- tz
koords <- sf::st_coordinates(sf::st_centroid(sf::st_geometry(boundary, of_largest_polygon = FALSE)))
cal[, "LOCATION"] <- sprintf("(LAT:%f;LONG:%f)", koords[, "Y"], koords[, "X"])
ic_write(cal, "misc/overpasses.ics")

