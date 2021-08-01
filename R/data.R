
#' @title Satellites
#' @description List all the satellites available in the Spectator Earth database with main attributes
#' @format A data frame with 45 rows and 6 variables:
#' \describe{
#'   \item{\code{id}}{integer identifier}
#'   \item{\code{name}}{character satellite name}
#'   \item{\code{norad_id}}{integer satellite catalog number}
#'   \item{\code{sensors}}{character type of sensors available on the satellite (SAR or Optical)}
#'   \item{\code{open}}{logical whether the data produced by the satellite is freely accessible}
#'   \item{\code{platform}}{character platform name}
#'}
#' @details The information in this data frame enables the retrieval of some data by satellite name instead of id.
#'
#' @source \url{https://api.spectator.earth/#satellites}
#'
"satellites"
