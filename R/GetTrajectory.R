

#' @title Get trajectory
#' @description Get trajectory
#' @param satellite PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[httr]{GET}}, \code{\link[httr]{content}}
#'  \code{\link[geojsonsf]{geojson_sf}}
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom httr GET content
#' @importFrom geojsonsf geojson_sf
GetTrajectory <- 
function(satellite)
{
    id <- FindSatelliteId(satellite)
    endpoint <- sprintf("https://api.spectator.earth/satellite/%d/trajectory/", id)
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
    trajectory <- geojsonsf::geojson_sf(cnt)
    trajectory$name <- satellite
    trajectory$id <- id
    
    return(trajectory)
}
