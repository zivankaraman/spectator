
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param aoi PARAM_DESCRIPTION
#' @param satellites PARAM_DESCRIPTION, Default: NULL
#' @param from PARAM_DESCRIPTION, Default: NULL
#' @param date_to PARAM_DESCRIPTION, Default: NULL
#' @param footprint PARAM_DESCRIPTION, Default: FALSE
#' @param api_key PARAM_DESCRIPTION, Default: Sys.getenv("spectator_earth_api_key")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[sf]{st_as_sf}},\code{\link[sf]{st_bbox}},\code{\link[sf]{st}},\code{\link[sf]{sfc}},\code{\link[sf]{sf}}
#'  \code{\link[httr]{GET}},\code{\link[httr]{content}}
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom sf st_as_sf st_bbox st_polygon st_sfc st_sf
#' @importFrom httr GET content
SearchImages <- 
function(aoi, satellites = NULL, from = NULL, date_to = NULL, footprint = FALSE, api_key = Sys.getenv("spectator_earth_api_key")) 
{
    if (inherits(aoi, "Spatial")) {
        aoi <- sf::st_as_sf(aoi)
    }
    if (!inherits(aoi, "sf")) {
        stop("aoi argument must be a 'Spatial*' or 'sf' (simple feature) object")
    }

    # aoi <- sf::read_sf(system.file("extdata", "luxembourg.geojson", package = "spectator"))
    from <- "2020-10-01"
    to <- "2020-12-31"
    satellites <- c("Sentinel-2A,Sentinel-1B,Landsat-8")
    satellites <- c("Sentinel-2A,Sentinel-2B")
    
    endpoint <- "https://api.spectator.earth/imagery/"
    bbox <- paste(as.numeric(sf::st_bbox(aoi)), collapse = ",")
    qry <- list(api_key = api_key, bbox = bbox)

    if (!is.null(from)) {
        date_from <- sprintf("%s", as.Date(from))
        qry <- c(qry, date_from = date_from)
    }
    if (!is.null(to)) {
        date_to <- sprintf("%s", as.Date(to))
        qry <- c(qry, date_to = date_to)
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
    # arrange some columns
    catalogue$cloud_cover_percentage <- as.numeric(catalogue$cloud_cover_percentage)
    catalogue$ingestion_date <- as.POSIXct(gsub("Z$", "", gsub("T", " ", catalogue$ingestion_date)), tz = "UTC")
    catalogue$begin_position_date <- as.POSIXct(gsub("Z$", "", gsub("T", " ", catalogue$begin_position_date)), tz = "UTC")
    catalogue$end_position_date <- as.POSIXct(gsub("Z$", "", gsub("T", " ", catalogue$end_position_date)), tz = "UTC")
    
    if (footprint) {
        geometry <- sapply(results, FUN = function(x) SafeNull(x$geometry$coordinates))
        # saveRDS(catalogue, "misc/catalogue.rds")
        # saveRDS(geometry, "misc/geometry.rds")
        koords <- lapply(geometry, FUN = function(x) list(matrix(unlist(x), ncol = 2, byrow = TRUE)))
        poly <- lapply(koords, sf::st_polygon)
        geom <- sf::st_sfc(poly, crs = 4326)
        out <- sf::st_sf(cbind(catalogue, geom))
    } else {
        out <- catalogue
    }
    
    return(out)
}



