#' @title Get all satellites
#' @description Get all satellites
#' @param satellites PARAM_DESCRIPTION. Default: NULL
#' @param date PARAM_DESCRIPTION. Default: NULL
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
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom httr GET content
GetAllSatellites <- 
function(satellites = NULL, date = NULL) 
{
    endpoint <- "https://api.spectator.earth/satellite/"
    
    resp <- httr::GET(url = endpoint)
    if (resp$status_code != 200) {
        stop()
    }

    cnt <- httr::content(resp)
    features <- cnt$features
    prop <- sapply(features, FUN = function(x) (x$properties))
    out <- data.frame(id = sapply(features, "[[", "id"),
                      name = unlist(prop[1, ]),
                      norad_id = unlist(prop[2, ]),
                      sensors = sapply(prop[3, ], length),
                      open = unlist(prop[4, ]),
                      platform = sapply(prop[5, ], SafeNull),
                      stringsAsFactors = FALSE, row.names = NULL)
    return(out)
}
