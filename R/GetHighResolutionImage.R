#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param aoi PARAM_DESCRIPTION
#' @param id PARAM_DESCRIPTION
#' @param bands PARAM_DESCRIPTION
#' @param width PARAM_DESCRIPTION
#' @param height PARAM_DESCRIPTION
#' @param file PARAM_DESCRIPTION, Default: 'image.jpg'
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
#'  \code{\link[sf]{st_as_sf}},\code{\link[sf]{st_bbox}}
#'  \code{\link[httr]{GET}},\code{\link[httr]{content}}
#' @export 
#' @source \url{http://somewhere.important.com/}
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
    return()
}



