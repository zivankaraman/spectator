#' @title Get image limited to an area of interest
#' @description Provides you with a high resolution image for the area within the acquisition boundaries, 
#' if you're not interested in downloading the whole image.
#' @param aoi '\code{sf}' (or '\code{Spatial*}') object defining the area of interest.
#'  Can be of any geometry as only the bounding box is used.
#' @param id integer, \code{id} of the image from the \code{\link[spectator]{SearchImages}} result
#' @param bands integer vector of length 1 or 3 indicating the spectral bands to use for creating the image 
#' (typically the bands corresponding to Red, Green and Blue)
#' @param width integer indicating the width of the image (in pixels)
#' @param height integer indicating the height of the image (in pixels)
#' @param file character indicating the name of the image file to create. Default: 'image.jpg'
#' @param api_key character containing your API key. Default: \code{Sys.getenv("spectator_earth_api_key")}
#' @return The name of the image file is returned invisibly.
#' @details As a side effect, the image file is written to the provided path.
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
#'  # get the id of the image with minimal cloud coverage
#'  best_id <- catalog[order(catalog$cloud_cover_percentage), ][1, "id"]
#'  # get the high resolution image of the Central Park
#'  img <- GetHighResolutionImage(aoi = boundary, id = best_id, bands = c(4, 3, 2), 
#'      width = 1024, height = 1024,
#'      file = tempfile(pattern = "img", fileext = ".jpg"), 
#'      api_key = my_key)
#'  }
#' @seealso 
#'  \code{\link[spectator]{SearchImages}}
#' @export 
#' @source \url{https://api.spectator.earth/#high-resolution-image}
#' @importFrom sf st_as_sf st_bbox
#' @importFrom httr GET content
GetHighResolutionImage <- 
function(aoi, id, bands, width, height, file = "image.jpg", api_key = Sys.getenv("spectator_earth_api_key")) 
{
    if (inherits(aoi, "Spatial")) {
        aoi <- sf::st_as_sf(aoi)
    }
    if (!inherits(aoi, "sf")) {
        stop("aoi argument must be a 'Spatial*' or 'sf' (simple feature) object")
    }
    
    endpoint <- sprintf("https://api.spectator.earth/imagery/%d/preview/", id)
    
    bbox <- paste(as.numeric(sf::st_bbox(aoi)), collapse = ",")
    bands <- paste(bands, collapse = ",")
    
    qry <- list(api_key = api_key, bbox = bbox, bands = bands, width = width, height = height)

    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    cnt <- httr::content(resp)
    writeBin(cnt, con = file)    
    invisible(file)
}
