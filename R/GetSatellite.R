#' @title Gets info for a satellite
#' @description Gets the information about the specified satellite, and possibly its current position.
#' @param satellite character name of the satellite for which to retrieve the trajectory. 
#' The satellite name is not case sensitive, and can be abbreviated as long as an unambiguous match can be obtained.
#' Only one satellite can be queried at a time.
#' @param positions logical indicating if the current position should be included. Default: TRUE
#' @return If \code{positions} is \code{FALSE}, a single row data frame with following attributes:
#' \describe{
#'   \item{\code{id}}{integer identifier}
#'   \item{\code{name}}{character satellite name}
#'   \item{\code{norad_id}}{integer satellite catalog number}
#'   \item{\code{open}}{logical whether the data produced by the satellite is freely accessible}
#'   \item{\code{platform}}{character platform name}
#'   \item{\code{sensor_name}}{character name of the sensor available on the satellite}
#'   \item{\code{sensor_swath}}{integer swath width of the sensor available on the satellite}
#'   \item{\code{sensor_type}}{character type of the sensor available on the satellite (SAR or Optical)}
#'}
#' If \code{positions} is \code{TRUE}, a single row object of class '\code{sf}' with '\code{POINT}' geometry type, 
#' with the same attributes as above.
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
#' @seealso 
#'  \code{\link[spectator]{GetAllSatellites}} 
#' @export 
#' @source \url{https://api.spectator.earth/#satellites}
#' @importFrom httr GET content
#' @importFrom geojsonsf geojson_sf
GetSatellite <- 
function(satellite, positions = TRUE) 
{
    id <- FindSatelliteId(satellite)
    endpoint <- sprintf("https://api.spectator.earth/satellite/%d/", id)
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp)
    prop <- cnt$properties
    tab <- data.frame(id = cnt$id,
                      name = prop$name,
                      norad_id = prop$norad_id,
                      sensor_name = ifelse(length(prop$modes) == 0L, NA, prop$modes[[1]]$name),
                      sensor_swath = ifelse(length(prop$modes) == 0L, NA, prop$modes[[1]]$swath),
                      sensor_type = ifelse(length(prop$modes) == 0L, NA, prop$modes[[1]]$sensor_type),
                      open = prop$open,
                      platform = SafeNull(prop$platform),
                      stringsAsFactors = FALSE, row.names = NULL)
    if (positions) {
        cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
        out <- geojsonsf::geojson_sf(cnt)
        out$sensor_name <- tab$sensor_name
        out$sensor_swath <- tab$sensor_swath
        out$sensor_type <- tab$sensor_type
        out$id <- tab$id
        # out <- out[, c("name", "norad_id", "open", "platform", "sensor_name", "sensor_swath", 
        #                "sensor_type", "modes", "geometry")]
        out <- out[, c("id", "name", "norad_id", "open", "platform", "sensor_name", "sensor_swath", "sensor_type", "geometry")]
        row.names(out) <- NULL
    } else {
        out <- tab
    }
    
    return(out)
}
