

GetHighResolutionImage <- 
function(aoi, id, bands, width, height, file = "image.jpg", api_key = Sys.getenv("spectator_earth_api_key")) 
{
    if (inherits(aoi, "Spatial")) {
        aoi <- sf::st_as_sf(aoi)
    }
    if (!inherits(aoi, "sf")) {
        stop("aoi argument must be a 'Spatial*' or 'sf' (simple feature) object")
    }
    
    # id <- 21529552
    # id <- 21529497
    # 
    # 
    # api_key = Sys.getenv("spectator_earth_api_key")
    # 
    # # aoi <- sf::read_sf(system.file("extdata", "luxembourg.geojson", package = "spectator"))
    # aoi <- readRDS("C:/Datoteka/Fichiers/_AgNum/R/agrility/Mons/Data/fields.rds")
    # width <- 1024
    # height <- 758
    # 
    # width <- 4096
    # height <- 4096
    # bands <- c(4, 3, 2)

    endpoint <- sprintf("https://api.spectator.earth/imagery/%d/preview/", id)
    
    bbox <- paste(as.numeric(sf::st_bbox(aoi)), collapse = ",")
    bands <- paste(bands, collapse = ",")
    
    qry <- list(api_key = api_key, bbox = bbox, bands = bands, width = width, height = height)

    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    cnt <- httr::content(resp)
    writeBin(cnt, con = file)    
    return()
}



