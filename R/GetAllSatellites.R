

#' @title Get all satellites
#' @description Get all satellites
#' @param positions PARAM_DESCRIPTION. Default: TRUE
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
                      sensors = sapply(prop[3, ], FUN = function(x) x[[1]]$type),
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
        out <- out[order(out$name), c("id", "name", "norad_id", "sensors", "open", "platform", "geometry")]
        out$sensors <- tab$sensors
        row.names(out) <- NULL
    } else {
        out <- tab
    }
    
    return(out)
}
