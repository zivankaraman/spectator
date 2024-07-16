#' @title Gets a satellite acquisition plan
#' @description Retrieves the acquisition plans for the Sentinel 1 & 2 and Landsat 8 & 9 satellites.
#' @param satellites character vector, if specified only the listed satellites will be retrieved, 
#'  if \code{NULL} (default value) the acquisition plans for all possible satellites will be retrieved. 
#'  For simplicity, the satellites names can be abbreviated to 
#'  "S-1A", "S-1B", "S-2A", "S-2B", "L-8", "L-9" or "S1A", "S1B", "S2A", "S2B", "L8", "L9". Default: NULL
#' @param date date or character convertible to date by \code{as.Date},
#'  indicating the day for which the acquisition plans are requested. 
#'  If \code{NULL} (default value), today's date is used. 
#'  If too far in the future, will return empty data set. 
#'  Default: NULL
#' @return Object of class '\code{sf}' with '\code{POLYGON}' geometry type.
#'  The attributes of the output will vary, depending on the satellite. 
#'  For more information check out acquisition plan file descriptions for 
#'  \href{https://sentinel.esa.int/web/sentinel/missions/sentinel-1/observation-scenario/acquisition-segments}{Sentinel-1}, 
#'  \href{https://sentinel.esa.int/web/sentinel/missions/sentinel-2/acquisition-plans}{Sentinel-2}, 
#'  \href{https://landsat.usgs.gov/landsat_acq}{Landsat-8, Landsat-9}
#' @details For Sentinels the acquisition plans usually have a range of 10-15 days, while for Landsat 8 and 9 it is 2-4 days.
#'  The time range that you can view is limited to 24 hours due to a large number of polygons.
#' @section Data source:
#'  Based on the files provided by ESA (Sentinel-1, Sentinel-2) 
#'  and USGS (Landsat-8, Landsat-9), more information available on the above mentioned web pages.
#' @examples 
#' if(interactive()){
#'  library(sf)
#'  # get plans for all eligible satellites for today
#'  plans <- GetAcquisitionPlan()
#'  # explore the content of the data frame, 
#'  # -> you'll see that the available attributes vary with the satellite
#'  # focus on Sentinel 2
#'  sat <- c("Sentinel-2A", "Sentinel-2B")
#'  # day after tomorrow
#'  day <- Sys.Date()  + 2
#'  plan <- GetAcquisitionPlan(satellites = sat, date = day)
#'  # do some nice graphs
#'  library(maps)
#'  map("world", fill = TRUE, col = "lightgrey")
#'  plot(st_geometry(plan), border = "red", add = TRUE)
#'  title(main = sprintf("%s acquisition plan for %s", paste(sat, collapse = "/"), day))
#'  }
# @seealso 
#  \code{\link[httr]{GET}}, \code{\link[httr]{content}}
#  \code{\link[geojsonsf]{geojson_sf}}
#' @export 
#' @source \url{https://api.spectator.earth/#acquisition-plan}
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
    
    qry <- list(satellites = satellites, datetime = date)
    
    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    
    cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
    plan <- geojsonsf::geojson_sf(cnt)
    plan <- sf::st_wrap_dateline(plan)
    # convert datetime strings to POSIX format
    if (!is.null(plan$begin_time)) {
        plan$begin_time <- as.POSIXct(gsub("Z", "", gsub("T", " ", plan$begin_time)), tz = "GMT")
    }
    if (!is.null(plan$end_time)) {
        plan$end_time <- as.POSIXct(gsub("Z", "", gsub("T", " ", plan$end_time)), tz = "GMT")
    }
    return(plan)
}
