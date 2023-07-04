
#' @title Satellites database
#' @description List all the satellites available in the Spectator Earth database with main attributes
#' @format A data frame with 48 rows and 8 variables:
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
#' @details The information in this data frame is a local cache of the list of all the satellites 
#' available in the Spectator Earth database. It enables the fast retrieval of some data 
#' by satellite name instead of id.
#' The current up-to-date list of satellites described in Spectator Earth database can be obtained by 
#' \code{GetAllSatellites(positions = FALSE)}
#' 
#' @seealso 
#'  \code{\link[spectator]{GetAllSatellites}} 
#'
#' @source \url{https://api.spectator.earth/#satellites}
#'
"satellites_db"
