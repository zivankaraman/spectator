# examples for satellite imagery
# works only for Sentinel-2, Landsat-8 and Sentinel-1 satellites

my_key <- Sys.getenv("spectator_earth_api_key")

library(sf)

# get the New York City Central Park shape as area of interest
dsn <- system.file("extdata", "centralpark.geojson", package = "spectator")
boundary <- read_sf(dsn, as_tibble = FALSE)

# search for May 2021 Sentinel 2 images 
catalog <- SearchImages(aoi = boundary, satellites = "S2", 
                        date_from = "2021-05-01", date_to = "2021-05-30", 
                        footprint = FALSE, api_key = my_key)

# get the id of the image with minimal cloud coverage
best_id <- catalog[order(catalog$cloud_cover_percentage), ][1, "id"]

# list all downloadable files for the image with minimal cloud coverage
images <- GetImageryFilesList(best_id, api_key = my_key)

# get the high resolution image of the Central Park
img <- GetHighResolutionImage(aoi = boundary, id = best_id, bands = c(4, 3, 2), 
                              width = 1024, height = 1024,
                              file = tempfile(pattern = "img", fileext = ".jpg"), 
                              api_key = my_key)


# if (length(grep("windows", sessionInfo()$running, ignore.case = TRUE)) > 0) {
#     shell.exec(img)
# }
system2("open", img)


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


