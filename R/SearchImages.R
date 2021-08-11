
SearchImages <- 
function(aoi, satellites = NULL, from = NULL, date_to = NULL, api_key = Sys.getenv("spectator_earth_api_key")) 
{
    if (inherits(aoi, "Spatial")) {
        aoi <- sf::st_as_sf(aoi)
    }
    if (!inherits(aoi, "sf")) {
        stop("aoi argument must be a sf (simple feature) object")
    }

    # aoi <- sf::read_sf(system.file("extdata", "luxembourg.geojson", package = "spectator"))
    # from <- "2020-05-01"
    # to <- "2021-05-01"
    # satellites <- c("Sentinel-2A,Sentinel-1B,Landsat-8")
    # satellites <- c("Sentinel-2A,Sentinel-2B")
    
    endpoint <- "https://api.spectator.earth/imagery/"
    bbox <- paste(as.numeric(sf::st_bbox(aoi)), collapse = ",")
    qry <- list(api_key = api_key, bbox = bbox)

    if (!is.null(from)) {
        date_from <- sprintf("%s", as.Date(from))
        qry <- c(qry, date_from = date_from)
    }
    if (!is.null(to)) {
        date_to <- sprintf("%s", as.Date(to))
        qry <- c(qry, date_from = date_to)
    }
    
    if (!is.null(satellites)) {
        satellites <- FindSatelliteName(satellites)
        qry <- c(qry, satellites = satellites)
    }
    
    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    cnt <- httr::content(resp)
    results <- cnt$results
    while (!is.null(cnt$`next`)) {
        resp <- httr::GET(url = cnt$`next`)
        # CheckResponseSatus(resp)
        cnt <- httr::content(resp)
        results <- c(results, cnt$results)
    }
    
    # saveRDS(results, "misc/results.rds")
    catalogue <- data.frame(id = sapply(results, FUN = function(x) SafeNull(x$id)),
                    uuid = sapply(results, FUN = function(x) SafeNull(x$uuid)),
                    identifier = sapply(results, FUN = function(x) SafeNull(x$identifier)),
                    ingestion_date = sapply(results, FUN = function(x) SafeNull(x$ingestion_date)),
                    begin_position_date = sapply(results, FUN = function(x) SafeNull(x$begin_position_date)),
                    end_position_date = sapply(results, FUN = function(x) SafeNull(x$end_position_date)),
                    download_url = sapply(results, FUN = function(x) SafeNull(x$download_url)),
                    satellite = sapply(results, FUN = function(x) SafeNull(x$satellite)),
                    scene_id = sapply(results, FUN = function(x) SafeNull(x$scene_id)),
                    cloud_cover_percentage = sapply(results, FUN = function(x) SafeNull(x$cloud_cover_percentage)),
                    product_type = sapply(results, FUN = function(x) SafeNull(x$product_type)),
                    stringsAsFactors = FALSE, row.names = NULL)
    catalogue$cloud_cover_percentage <- as.numeric(catalogue$cloud_cover_percentage)
    
    catalogue$ingestion_date <- as.POSIXct(gsub("Z$", "", gsub("T", " ", catalogue$ingestion_date)), tz = "UTC")
    catalogue$begin_position_date <- as.POSIXct(gsub("Z$", "", gsub("T", " ", catalogue$begin_position_date)), tz = "UTC")
    catalogue$end_position_date <- as.POSIXct(gsub("Z$", "", gsub("T", " ", catalogue$end_position_date)), tz = "UTC")
    
    geometry <- sapply(results, FUN = function(x) SafeNull(x$geometry$coordinates))
    saveRDS(catalogue, "misc/catalogue.rds")
    saveRDS(geometry, "misc/geometry.rds")
    
    return(catalogue)
}



