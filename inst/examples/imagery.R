# examples for satellite imagery
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites
# this functionality requires an api_key, will try to use default value Sys.getenv("spectator_earth_api_key"),
# if not set, will prompt the user to enter it

# first check that we have the api_key
my_key <- Sys.getenv("spectator_earth_api_key")
if (my_key == "") {
    my_key <- readline("This demo requires a Spectator Earth api_key, please enter your API key here: ")
}
if (my_key == "") {
    stop("This demon can't run without an api_key, aborting")
}

library(sf)

# get the New York City Central Park shape as area of interest
dsn <- system.file("extdata", "centralpark.geojson", package = "spectator")
boundary <- sf::read_sf(dsn, as_tibble = FALSE)

# search for May 2021 Sentinel 2 images 
catalog <- SearchImages(aoi = boundary, satellites = "S2", 
                        date_from = "2024-05-01", date_to = "2024-05-31", 
                        footprint = FALSE, api_key = my_key)

# get the id of the image with minimal cloud coverage
best_id <- catalog[order(catalog$cloud_cover_percentage), ][1, "id"]

# list all downloadable files for the image with minimal cloud coverage
images <- GetImageryFilesList(best_id, all = FALSE, api_key = my_key)

# get the high resolution image of the Central Park
img <- GetHighResolutionImage(aoi = boundary, id = best_id, bands = c(4, 3, 2), 
                              width = 600, height = 950,
                              file = tempfile(pattern = "img", fileext = ".jpg"), 
                              api_key = my_key)

# view the image file with default application
if (length(grep("linux", sessionInfo()$platform, ignore.case = TRUE)) > 0) {
    cmd <- "xdg-open"
} else {
    cmd <- "open"
}
system2(command = cmd, args = img)


# download the whole band 4 image tile for the image with minimal cloud coverage
size <- as.integer(subset(images, path == "B04.jp2", "size"))
msg <- sprintf("This is a very big file - %s bytes, are you sure you want to download it [y/N]?", 
               format(size, big.mark = " "))
ans <- readline(prompt = msg)
if (substring(toupper(ans), 1, 1) == "Y") {
    from <- paste0(catalog[order(catalog$cloud_cover_percentage), ][1, "download_url"], "B04.jp2")
    to <- "B04.jp2"
    library(httr)
    resp <- httr::GET(url = from, query = list(api_key = my_key))
    writeBin(httr::content(resp), con = to)
}


