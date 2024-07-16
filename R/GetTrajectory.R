#' @title Gets a satellite trajectory
#' @description Gets the current trajectory for the specified satellite.
#' @param satellite character name of the satellite for which to retrieve the trajectory. 
#' The satellite name is not case sensitive, and can be abbreviated as long as an unambiguous match can be obtained.
#' Only one satellite can be queried at a time.
#' @return Object of class '\code{sf}' with '\code{LINESTRING}' geometry type
# @details DETAILS
#' @examples 
#' if(interactive()){
#'  library(sf)
#'  # get trajectory and current position for a selected satellite
#'  sat <- "SPOT-7"
#'  traj <- GetTrajectory(satellite = sat)
#'  pos <- GetSatellite(satellite = sat, positions = TRUE)
#'  # do some nice graphs
#'  library(maps)
#'  map("world", fill = TRUE, col = "lightgrey")
#'  plot(st_geometry(traj), lwd = 2, col = "red", add = TRUE)
#'  plot(st_geometry(pos), pch = 15, col = "green", cex = 1.5, add = TRUE)
#'  title(main = sprintf("current %s trajectory & position", sat))
#'  }
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
