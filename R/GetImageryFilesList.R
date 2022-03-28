#' @title List of downloadable files
#' @description List of files that can be downloaded directly (separate files for every spectral band)
#' for the given image.
#' @param id integer indicating the image id (from \code{SearchImages})
#' @param all logical indicating if the auxiliary files should be included. Default: FALSE
#' @param api_key character containing your API key. Default: \code{Sys.getenv("spectator_earth_api_key")}
#' @return A data frame with attributes
#' \describe{
#'   \item{\code{name}}{character, name of the file}
#'   \item{\code{path}}{character, path (relative) to download the file}
#'   \item{\code{size}}{integer, size of the file (in bytes)}
#'}
#' @details Besides the raw images (\code{jp2} files) as single bands, various auxiliary files are also available.
#'  These include image thumbnails, metadata, etc. By default, only the full-sized images are returned by the function.  
#'  To download the files, all the paths should be prepended with 
#'  \code{https://api.spectator.earth/imagery/{id}/files/}.
#'  The raw image files are quite big, if the area of interest is relatively small it might be better to use 
#'  \code{\link[spectator]{GetHighResolutionImage}}.
#'  
#' @examples  
#' if(interactive()){
#'  library(sf)
#'  my_key <- Sys.getenv("spectator_earth_api_key")
#'  # get the New York City Central Park shape as area of interest
#'  dsn <- system.file("extdata", "centralpark.geojson", package = "spectator")
#'  boundary <- sf::read_sf(dsn, as_tibble = FALSE)
#'  # search for May 2021 Sentinel 2 images 
#'  catalog <- SearchImages(aoi = boundary, satellites = "S2", 
#'      date_from = "2021-05-01", date_to = "2021-05-30", 
#'      footprint = FALSE, api_key = my_key)
#'  # get the id of the image with minimal cloud coverage
#'  best_id <- catalog[order(catalog$cloud_cover_percentage), ][1, "id"]
#'  # list all downloadable files for the image with minimal cloud coverage
#'  images <- GetImageryFilesList(best_id, all = FALSE, api_key = my_key)
#'  }
#' @seealso 
#'  \code{\link[spectator]{SearchImages}}, \code{\link[spectator]{GetHighResolutionImage}} 
#' @export 
#' @source \url{https://api.spectator.earth/#imagery-files}
#' @importFrom httr GET content
GetImageryFilesList <- 
function(id, all = FALSE, api_key = Sys.getenv("spectator_earth_api_key")) 
{
    endpoint <- sprintf("https://api.spectator.earth/imagery/%d/files/", id)
    qry <- list(api_key = api_key)
    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)
    cnt <- httr::content(resp)
    out <- data.frame(name = sapply(cnt, "[[", "name"),
                      path = sapply(cnt, "[[", "path"),
                      size = sapply(cnt, "[[", "size"),
                      stringsAsFactors = FALSE, row.names = NULL)
    if (!all) {
        out <- out[grep("^[[:upper:]][[:upper:]|[:digit:]]{2}.jp2$",out$path), ]
    }
    return(out)
}
