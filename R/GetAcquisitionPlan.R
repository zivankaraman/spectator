
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
#'  \code{\link[geojsonsf]{geojson_sf}}
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom httr GET content
#' @importFrom geojsonsf geojson_sf
GetAcquisitionPlan <- 
function(satellites = NULL, date = NULL) 
{
    endpoint <- "https://api.spectator.earth/acquisition-plan/"
    
    if (!is.null(date)) {
        date <- sprintf("%sT12:00:00", as.Date(date))
    }
        
    if (!is.null(satellites)) {
        satellites <- FindSatelliteName(satellites)
    }
    
    # date <- sprintf("%sT12:00:00", Sys.Date() + 1)
    # satellites <- c("Sentinel-2A,Sentinel-1B,Landsat-8")

    qry <- list(satellites = satellites, datetime = date)
    
    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    
    cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
    plan <- geojsonsf::geojson_sf(cnt)
    # convert datetime strings to POSIX format
    if (!is.null(plan$begin_time)) {
        plan$begin_time <- as.POSIXct(gsub("Z", "", gsub("T", " ", plan$begin_time)), tz = "GMT")
    }
    if (!is.null(plan$end_time)) {
        plan$end_time <- as.POSIXct(gsub("Z", "", gsub("T", " ", plan$end_time)), tz = "GMT")
    }
    return(plan)
}
