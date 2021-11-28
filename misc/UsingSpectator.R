setwd(rstudioapi::getActiveProject())
outdir <- paste0(getwd(), "/vignettes/data/")

## ----label = "knitr options", include = FALSE-----------------------------------------------------------------
knitr::opts_chunk$set(
    fig.width = 7, 
    fig.height = 5,
    out.width = "100%",
    fig.align = "center",
    collapse = TRUE,
    comment = "#>"
)
knitr::opts_knit$set(global.device = TRUE)
options(width = 999)


## ----label = "setup", include = FALSE-------------------------------------------------------------------------
library(spectator)


## ----label = "get satellites"---------------------------------------------------------------------------------
pos <- GetAllSatellites(positions = TRUE)
head(pos, n = 20L)
saveRDS(pos, paste0(outdir, "pos.rds"))

## ----label = "plot satellites"--------------------------------------------------------------------------------
library(sf)
library(maps)
maps::map("world", fill = TRUE, col = "lightgrey")


## ----label = "satellite positions"----------------------------------------------------------------------------
plot(sf::st_geometry(subset(pos, open == TRUE)), add = TRUE, col = "green", pch = 15)
plot(sf::st_geometry(subset(pos, open == FALSE)), add = TRUE, col = "red", pch = 16)


## ----label = "satellite names"--------------------------------------------------------------------------------
xy <- sf::st_coordinates(pos)
xy[, 2] <- xy[, 2] + 3 
text(xy, labels = pos$name, cex = 0.5)


## ----label = "turn off global device", include = FALSE--------------------------------------------------------
knitr::opts_knit$set(global.device = FALSE)


## ----label = "get trajectories"-------------------------------------------------------------------------------
sat <- "SPOT-7"
traj <- GetTrajectory(satellite = sat)
pos <- GetSatellite(satellite = sat, positions = TRUE)
saveRDS(traj, paste0(outdir, "traj.rds"))


## ----label = "plot trajectories"------------------------------------------------------------------------------
map("world", fill = TRUE, col = "lightgrey")
plot(sf::st_geometry(traj), lwd = 2, col = "red", add = TRUE)
plot(sf::st_geometry(pos), pch = 15, col = "green", cex = 1.5, add = TRUE)
title(main = sprintf("current %s trajectory & position", sat))



## ----label = "acquisition plans"------------------------------------------------------------------------------
plans <- GetAcquisitionPlan()
head(plans, n = 20L)
saveRDS(plans, paste0(outdir, "plans.rds"))

## ----label = "acquisition plans Sentinel 2"-------------------------------------------------------------------
sat <- c("Sentinel-2A", "Sentinel-2B")
day <- Sys.Date()  + 2
plan <- GetAcquisitionPlan(satellites = sat, date = day)
head(plan)
saveRDS(plan, paste0(outdir, "plan.rds"))

## ----label = "plot acquisition plans"-------------------------------------------------------------------------
library(maps)
maps::map("world", fill = TRUE, col = "lightgrey")
plot(sf::st_geometry(plan), border = "red", add = TRUE)
title(main = sprintf("%s acquisition plan for %s", paste(sat, collapse = "/"), day))


## ----label = "Luxembourg boundary"----------------------------------------------------------------------------
roi <- system.file("extdata", "luxembourg.geojson", package = "spectator")
boundary <- sf::read_sf(roi, as_tibble = FALSE)



## ----label = "API key"----------------------------------------------------------------------------------------
my_key <- Sys.getenv("spectator_earth_api_key")


## ----label = "get Sentinel 2 overpasses"----------------------------------------------------------------------
pass <- GetOverpasses(boundary, satellites = "S-2", acquisitions = TRUE, api_key = my_key)
saveRDS(pass, paste0(outdir, "passS2.rds"))

## ----label = "plot Sentinel 2 overpasses"---------------------------------------------------------------------
library(maps)
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
maps::map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg",
            "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))



## ----label = "get Sentinel 1 overpasses"----------------------------------------------------------------------
pass <- GetOverpasses(boundary, satellites = "S-1",
                      days_before = 7, days_after = 0, acquisitions = TRUE)
head(pass)
saveRDS(pass, paste0(outdir, "passS1.rds"))

## ----label = "plot Sentinel 1 overpasses"---------------------------------------------------------------------
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
maps::map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg",
            "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))


## ----label = "API key 2"--------------------------------------------------------------------------------------
my_key <- Sys.getenv("spectator_earth_api_key")


## ----label = "Central Park boundary"--------------------------------------------------------------------------
roi <- system.file("extdata", "centralpark.geojson", package = "spectator")
boundary <- sf::read_sf(roi, as_tibble = FALSE)


## ----label = "serch Central Park images"----------------------------------------------------------------------
catalog <- SearchImages(aoi = boundary, satellites = "S2", 
                        date_from = "2021-05-01", date_to = "2021-05-30", 
                        footprint = FALSE, api_key = my_key)
head(catalog, n = 20L)
saveRDS(catalog, paste0(outdir, "catalog.rds"))



## ----label = "minimal cloud coverage"-------------------------------------------------------------------------
best_id <- catalog[order(catalog$cloud_cover_percentage), ][1, "id"]


## ----label = "list imagery files"-----------------------------------------------------------------------------
images <- GetImageryFilesList(best_id, api_key = my_key)
head(images, n = 20L)
saveRDS(images, paste0(outdir, "images.rds"))

## ----label = "file size", include = FALSE---------------------------------------------------------------------
size <- as.integer(subset(images, path == "B04.jp2", "size"))


## ----label = "download the big file", eval = FALSE------------------------------------------------------------
## from <- paste0(catalog[order(catalog$cloud_cover_percentage), ][1, "download_url"], "B04.jp2")
## to <- "B04.jp2"
## library(httr)
## resp <- httr::GET(url = from, query = list(api_key = my_key))
## writeBin(httr::content(resp), con = to)


## ----label = "high resolution image", eval = FALSE------------------------------------------------------------
## img <- GetHighResolutionImage(aoi = boundary, id = best_id, bands = c(4, 3, 2),
##                               width = 1024, height = 1024,
##                               file = tempfile(pattern = "img", fileext = ".jpg"),
##                               api_key = my_key)

## ----label = "high resolution image file name", include = FALSE-----------------------------------------------
fichier <- normalizePath("data/CentralPark.jpg")

