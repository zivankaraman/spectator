#' @title Gets all referenced satellites info
#' @description Gets the information about all the satellites known in the Spectator Earth database, 
#' and possibly their current positions.
#' @param positions logical indicating if the current position should be included. Default: TRUE
#' @return If \code{positions} is \code{FALSE}, a data frame with following attributes:
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
#' If \code{positions} is \code{TRUE}, object of class '\code{sf}' with '\code{POINT}' geometry type, 
#' with the same attributes as above.
# @details DETAILS
#' @examples 
#' if(interactive()){
#'  library(sf)
#'  # get all satellites withe their positions
#'  pos <- GetAllSatellites(positions = TRUE)
#'  # do some nice graphs
#'  library(maps)
#'  map("world", fill = TRUE, col = "lightgrey")
#'  # show open data satellites in green
#'  plot(st_geometry(subset(pos, open == TRUE)), add = TRUE, col = "green", pch = 15)
#'  # show others in red
#'  plot(st_geometry(subset(pos, open == FALSE)), add = TRUE, col = "red", pch = 16)
#'  # add labels
#'  xy <- st_coordinates(pos)
#'  # shift labels up to be able to read them
#'  xy[, 2] <- xy[, 2] + 2 
#'  text(xy, labels = pos$name, cex = 0.5)
#'  }
#' @seealso 
#'  \code{\link[spectator]{GetSatellite}} 
#' @export 
#' @source \url{https://api.spectator.earth/#satellites}
#' @importFrom httr GET content
#' @importFrom geojsonsf geojson_sf
GetAllSatellites <- 
function(positions = TRUE) 
{
    endpoint <- "https://api.spectator.earth/satellite/"
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp)
    features <- cnt$features
    prop <- sapply(features, FUN = function(x) (x$properties))
    tab <- data.frame(id = sapply(features, "[[", "id"),
                      name = unlist(prop[1, ]),
                      norad_id = unlist(prop[2, ]),
                      # sensors = sapply(prop[3, ], FUN = function(x) x[[1]]$type),
                      sensor_name = sapply(prop[3, ], FUN = function(x) ifelse(length(x) == 0L, NA, x[[1]]$name)),
                      sensor_swath = sapply(prop[3, ], FUN = function(x) ifelse(length(x) == 0L, NA, x[[1]]$swath)),
                      sensor_type = sapply(prop[3, ], FUN = function(x) ifelse(length(x) == 0L, NA, x[[1]]$sensor_type)),
                      open = unlist(prop[4, ]),
                      platform = sapply(prop[5, ], SafeNull),
                      stringsAsFactors = FALSE, row.names = NULL)
    tab <- tab[order(tab$name), ]
    row.names(tab) <- NULL
    if (positions) {
        cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
        out <- geojsonsf::geojson_sf(cnt)
        # IDs of features are lost in this operation, must retrieve them by norad_id
        out$id <- tab$id[match(out$norad_id, tab$norad_id)]
        # open is not logical anymore, get it back
        out$open <- as.logical(as.integer(out$open))
        out$sensor_name <- tab$sensor_name
        out$sensor_swath <- tab$sensor_swath
        out$sensor_type <- tab$sensor_type
        # out <- out[order(out$name), c("id", "name", "norad_id", "open", "platform", 
        #                               "sensor_name", "sensor_swath", "sensor_type", "modes", "geometry")]
        out <- out[order(out$name), c("id", "name", "norad_id", "open", "platform", "sensor_name", 
                                      "sensor_swath", "sensor_type", "geometry")]
        row.names(out) <- NULL
    } else {
        out <- tab
    }
    
    return(out)
}
