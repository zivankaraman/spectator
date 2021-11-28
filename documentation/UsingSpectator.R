params <-
list(extra1 = "style=\"background-color: #9ecff7; padding: 2px; display: inline-block;\"")

## ----label = "knitr options", include = FALSE-------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
    fig.width = 7, 
    fig.height = 4,
    out.width = "100%",
    fig.align = "center",
    collapse = TRUE,
    comment = "#>"
)
knitr::opts_knit$set(global.device = TRUE)
options(width = 999)


## ----label = "setup", include = FALSE---------------------------------------------------------------------------------------------------
library(spectator)


## ----label = "get satellites"-----------------------------------------------------------------------------------------------------------
pos <- GetAllSatellites(positions = TRUE)
head(pos, n = 20L)


## ----label = "plot satellites", out.extra = params$extra1-------------------------------------------------------------------------------
library(sf)
library(maps)
maps::map("world", fill = TRUE, col = "lightgrey", mar = rep(0.5, 4))


## ----label = "satellite positions", out.extra = params$extra1---------------------------------------------------------------------------
plot(sf::st_geometry(subset(pos, open == TRUE)), add = TRUE, col = "green", pch = 15)
plot(sf::st_geometry(subset(pos, open == FALSE)), add = TRUE, col = "red", pch = 16)


## ----label = "satellite names", out.extra = params$extra1-------------------------------------------------------------------------------
xy <- sf::st_coordinates(pos)
xy[, 2] <- xy[, 2] + 3 
text(xy, labels = pos$name, cex = 0.5)


## ----label = "turn off global device", include = FALSE----------------------------------------------------------------------------------
knitr::opts_knit$set(global.device = FALSE)


## ----label = "get trajectories"---------------------------------------------------------------------------------------------------------
sat <- "SPOT-7"
traj <- GetTrajectory(satellite = sat)
pos <- GetSatellite(satellite = sat, positions = TRUE)



## ----label = "plot trajectories", out.extra = params$extra1-----------------------------------------------------------------------------
maps::map("world", fill = TRUE, col = "lightgrey", mar = c(0.5, 0.5, 3, 0.5))
plot(sf::st_geometry(traj), lwd = 2, col = "red", add = TRUE)
plot(sf::st_geometry(pos), pch = 15, col = "green", cex = 1.5, add = TRUE)
title(main = sprintf("current %s trajectory & position", sat))



## ----label = "acquisition plans"--------------------------------------------------------------------------------------------------------
plans <- GetAcquisitionPlan()
head(plans, n = 20L)


## ----label = "acquisition plans Sentinel 2"---------------------------------------------------------------------------------------------
sat <- c("Sentinel-2A", "Sentinel-2B")
day <- Sys.Date()  + 2
plan <- GetAcquisitionPlan(satellites = sat, date = day)
head(plan)


## ----label = "plot acquisition plans", out.extra = params$extra1------------------------------------------------------------------------
library(maps)
maps::map("world", fill = TRUE, col = "lightgrey", mar = c(0.5, 0.5, 3, 0.5))
plot(sf::st_geometry(plan), border = "red", add = TRUE)
title(main = sprintf("%s acquisition plan for %s", paste(sat, collapse = "/"), day))


## ----label = "Luxembourg boundary"------------------------------------------------------------------------------------------------------
roi <- system.file("extdata", "luxembourg.geojson", package = "spectator")
boundary <- sf::read_sf(roi, as_tibble = FALSE)



## ----label = "API key"------------------------------------------------------------------------------------------------------------------
my_key <- Sys.getenv("spectator_earth_api_key")


## ----label = "get Sentinel 2 overpasses"------------------------------------------------------------------------------------------------
pass <- GetOverpasses(boundary, satellites = "S-2", acquisitions = TRUE, api_key = my_key)


## ----label = "plot Sentinel 2 overpasses", out.extra = params$extra1--------------------------------------------------------------------
library(maps)
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
maps::map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg",
            "France", "Switzerland"), col = "lightgrey", fill = TRUE, mar = c(0.5, 0.5, 4, 0.5))
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))



## ----label = "get Sentinel 1 overpasses"------------------------------------------------------------------------------------------------
pass <- GetOverpasses(boundary, satellites = "S-1",
                      days_before = 7, days_after = 0, acquisitions = TRUE)
head(pass)


## ----label = "plot Sentinel 1 overpasses", , out.extra = params$extra1------------------------------------------------------------------
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
maps::map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg",
            "France", "Switzerland"), col = "lightgrey", fill = TRUE, mar = c(0.5, 0.5, 4, 0.5))
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))


## ----label = "get Sentinel 2 overpasses max time frame"---------------------------------------------------------------------------------
pass <- GetOverpasses(boundary, satellites = "S-2", acquisitions = FALSE, api_key = my_key,
                      days_before = 99, days_after = 99)


## ---------------------------------------------------------------------------------------------------------------------------------------
# we need these packages
library(sf)
library(lutz)
library(lubridate)

tz <- lutz::tz_lookup(sf::st_centroid(sf::st_geometry(boundary)), method = "accurate")
localtime <- lubridate::local_time(pass$date, tz = tz, units = "hours")
pass$acquisition <- localtime > 6 & localtime < 18
pass <- subset(pass, acquisition == TRUE)



## ---------------------------------------------------------------------------------------------------------------------------------------
library(calendR)

time_span <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
first_date <- lubridate::floor_date(lubridate::ymd(time_span[1]), unit = "month") 
last_date <- lubridate::ceiling_date(lubridate::ymd(time_span[2]), unit = "month") - 1
days <- first_date:last_date
passes <- as.Date(pass$date)
events <- rep(NA, length(days))
events[passes - first_date + 1] <- pass$satellite

# will use English month and day of week labels 
ans <- Sys.setlocale(category = "LC_ALL", locale = "English")

calendR::calendR(start_date = first_date, end_date = last_date, 
                 title = "Sentinel 2 overpasses calendar",
                 special.days = events,
                 special.col = 2:(length(satellites) + 1),
                 col = "grey",
                 mbg.col = 4,               # Color of the background of the names of the months
                 months.col = "white",      # Color text of the names of the months        
                 bg.col = "#f4f4f4",        # Background color
                 start = "M",               # Start the weeks on Monday
                 legend.pos = "right")




## ---------------------------------------------------------------------------------------------------------------------------------------
library(calendar)

N <- nrow(pass)
lst <- vector(mode = "list", length = N)
for (i in 1:nrow(pass)) {
    x <- pass[i, ]
    lst[[i]] <- calendar::ic_event(uid = calendar::ic_guid(), start_time = x$date, end_time = x$date, summary = x$satellite)
} 

cal <- calendar::ical(do.call(rbind, lst))
# cal[, "TZID"] <- tz
koords <- sf::st_coordinates(sf::st_centroid(sf::st_geometry(boundary, of_largest_polygon = FALSE)))
cal[, "LOCATION"] <- sprintf("(LAT:%f;LONG:%f)", koords[, "Y"], koords[, "X"])
calFile <- "overpasses.ics"
calendar::ic_write(cal, file = calFile)



## ----label = "Google calendar screenshot", include = FALSE------------------------------------------------------------------------------
fichier <- normalizePath("data/CentralPark.jpg")


## ----label = "API key 2"----------------------------------------------------------------------------------------------------------------
my_key <- Sys.getenv("spectator_earth_api_key")


## ----label = "Central Park boundary"----------------------------------------------------------------------------------------------------
roi <- system.file("extdata", "centralpark.geojson", package = "spectator")
boundary <- sf::read_sf(roi, as_tibble = FALSE)


## ----label = "serch Central Park images"------------------------------------------------------------------------------------------------
catalog <- SearchImages(aoi = boundary, satellites = "S2", 
                        date_from = "2021-05-01", date_to = "2021-05-30", 
                        footprint = FALSE, api_key = my_key)
head(catalog, n = 20L)


## ----label = "minimal cloud coverage"---------------------------------------------------------------------------------------------------
best_id <- catalog[order(catalog$cloud_cover_percentage), ][1, "id"]


## ----label = "list imagery files"-------------------------------------------------------------------------------------------------------
images <- GetImageryFilesList(best_id, api_key = my_key)
head(images, n = 20L)

## ----label = "file size", include = FALSE-----------------------------------------------------------------------------------------------
size <- as.integer(subset(images, path == "B04.jp2", "size"))


## ----label = "download the big file", eval = FALSE--------------------------------------------------------------------------------------
## from <- paste0(catalog[order(catalog$cloud_cover_percentage), ][1, "download_url"], "B04.jp2")
## to <- "B04.jp2"
## library(httr)
## resp <- httr::GET(url = from, query = list(api_key = my_key))
## writeBin(httr::content(resp), con = to)


## ----label = "high resolution image", eval = FALSE--------------------------------------------------------------------------------------
## img <- GetHighResolutionImage(aoi = boundary, id = best_id, bands = c(4, 3, 2),
##                               width = 1024, height = 1024,
##                               file = tempfile(pattern = "img", fileext = ".jpg"),
##                               api_key = my_key)

## ----label = "high resolution image file name", include = FALSE-------------------------------------------------------------------------
fichier <- normalizePath("data/CentralPark.jpg")

