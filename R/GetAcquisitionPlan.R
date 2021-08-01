#' @title Get acquisition plan
#' @description Get acquisition plan
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
#'  \code{\link[geojsonio]{geojson_sp}}
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom httr GET content
#' @importFrom geojsonio geojson_sp
GetAcquisitionPlan <- 
function(satellites = NULL, date = NULL) 
{
    endpoint <- "https://api.spectator.earth/acquisition-plan/"
    
    if (!is.null(satellites)) {
        # allow shorthand spelling
        allowed.satellites <- c("Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8",
                                "S-1A", "S-1B", "S-2A", "S-2B", "L-8",
                                "S1A", "S1B", "S2A", "S2B", "L8")
        names(allowed.satellites) <- c("Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8",
                                       "Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8",
                                       "Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8")
        satellites <- paste(unique(names(allowed.satellites)[grep(satellites, allowed.satellites)]), collapse = ",")
        if (length(satellites) == 0)  {
            stop()
        }
    }
    
    if (!is.null(date)) {
        date <- sprintf("%sT12:00:00", as.Date(date))
    }
    
    date <- sprintf("%sT12:00:00", Sys.Date() + 1)
    satellites <- c("Sentinel-2A,Sentinel-1B,Landsat-8")

    qry <- list(satellites = satellites, datetime = date)
    
    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    
    cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
    plan <- geojsonio::geojson_sp(cnt)

    return(plan)
}
