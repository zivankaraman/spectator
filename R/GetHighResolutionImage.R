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
#' @return The name of the image file is returned invisbly.
#' @details As a side effect, the image file is written to the provided path.
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
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
    invisible(file)
}



