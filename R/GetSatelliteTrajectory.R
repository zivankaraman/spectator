
#' @title Get satellite trajectory
#' @description Get satellite trajectory
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
#'  \code{\link[geojsonio]{geojson_sp}}
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom httr GET content
#' @importFrom geojsonio geojson_sp
GetSatelliteTrajectory <- 
function(satellite)
{
    id <- FindSatellite(satellite)
    endpoint <- sprintf("https://api.spectator.earth/satellite/%d/trajectory/", id)
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
    trajectory <- geojsonio::geojson_sp(cnt)
    
    return(trajectory)
}
