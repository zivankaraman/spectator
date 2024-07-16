#' @title Search Spectator database for available images
#' @description Returns the list of available images for an area of interest, specified time interval and selected satellites.
#' @param aoi '\code{sf}' (or '\code{Spatial*}') object defining the area of interest.
#'  Can be of any geometry as only the bounding box is used.
#' @param satellites character vector, if specified only the listed satellites will be retrieved,
#'  if \code{NULL} (default value) the acquisition plans for all possible satellites will be retrieved.
#'  For simplicity, the satellites names can be abbreviated to
#'  "S-1A", "S-1B", "S-2A", "S-2B", "L-8", "L-9" or "S1A", "S1B", "S2A", "S2B", "L8", "L9". Default: NULL
#' @param date_from date or character convertible to date by \code{as.Date}, indicating the earliest image date. Default: NULL
#' @param date_to date or character convertible to date by \code{as.Date}, indicating the latest image date. Default: NULL
#' @param footprint logical indicating if the polygons describing the image tiles should be returned. Default: FALSE
#' @param api_key character containing your API key. Default: \code{Sys.getenv("spectator_earth_api_key")}
#' @return Either a data frame (if '\code{footprint}' is '\code{FALSE}') or 
#' an object of class '\code{sf}' with '\code{POLYGON}' geometry type (if '\code{footprint}' is '\code{TRUE}'). 
#' @details The data frame contains some useful attributes: \code{id} which enables to download images 
#' using the functions \code{\link[spectator]{GetImageryFilesList}} or 
#' \code{\link[spectator]{GetHighResolutionImage}}, 
#'  \code{cloud_cover_percentage} (for the whole image tile), \code{satellite} (name), 
#'  \code{begin_position_date} and \code{end_position_date} indicating when the image was taken.
#' @examples 
#' if(interactive()){ 
#'  library(sf)
#'  my_key <- Sys.getenv("spectator_earth_api_key")
#'  # get the New York City Central Park shape as area of interest
#'  dsn <- system.file("extdata", "centralpark.geojson", package = "spectator")
#'  boundary <- sf::read_sf(dsn, as_tibble = FALSE)
#'  # search for May 2021 Sentinel 2 images 
#'  catalog <- SearchImages(aoi = boundary, satellites = "S2", 
#'      date_from = "2021-05-01", date_to = "2021-05-30", 
#'      footprint = FALSE, api_key = my_key)
#'  }
# @seealso 
#  \code{\link[sf]{st_as_sf}},\code{\link[sf]{st_bbox}},\code{\link[sf]{st}},\code{\link[sf]{sfc}},\code{\link[sf]{sf}}
#  \code{\link[httr]{GET}},\code{\link[httr]{content}}
#' @export 
#' @source \url{https://api.spectator.earth/#searching-for-images}
#' @importFrom sf st_as_sf st_bbox st_polygon st_sfc st_sf
#' @importFrom httr GET content
SearchImages <- 
function(aoi, satellites = NULL, date_from = NULL, date_to = NULL, footprint = FALSE, 
         api_key = Sys.getenv("spectator_earth_api_key")) 
{
    if (inherits(aoi, "Spatial")) {
        aoi <- sf::st_as_sf(aoi)
    }
    if (!inherits(aoi, "sf")) {
        stop("aoi argument must be a 'Spatial*' or 'sf' (simple feature) object")
    }

    endpoint <- "https://api.spectator.earth/imagery/"
    bbox <- paste(as.numeric(sf::st_bbox(aoi)), collapse = ",")
    qry <- list(api_key = api_key, bbox = bbox)

    if (!is.null(date_from)) {
        date_from <- sprintf("%s", as.Date(date_from))
        qry <- c(qry, date_from = date_from)
    }
    if (!is.null(date_to)) {
        date_to <- sprintf("%s", as.Date(date_to))
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
        koords <- lapply(geometry, FUN = function(x) list(matrix(unlist(x), ncol = 2, byrow = TRUE)))
        poly <- lapply(koords, sf::st_polygon)
        geom <- sf::st_sfc(poly, crs = 4326)
        out <- sf::st_sf(cbind(catalogue, geom))
    } else {
        out <- catalogue
    }
    
    return(out)
}
