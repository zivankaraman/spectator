
#' @title Gets a satellite trajectory
#' @description Gets the current trajectory for the specified satellite.
#' @param satellite character name of the satellite for which to retrieve the trajectory. 
#' The satellite name is not case sensitive, and can be abbreviated as long as an unambiguous match can be obtained.
#' Only one satellite can be queried at a time.
#' @return Object of class '\code{sf}' with '\code{LINESTRING}' geometry type
# @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
# @seealso 
#  \code{\link[httr]{GET}}, \code{\link[htt]{content}}
#  \code{\link[geojsonsf]{geojson_sf}}
#' @export 
#' @source \url{https://api.spectator.earth/#trajectories}
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
