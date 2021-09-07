#' @title List of downloadable files
#' @description List of files that can be downloaded directly (separate files for every spectral band)
#' for the given image.
#' @param id integer indicating the image id (from \code{SearchImages})
#' @param api_key character containing your API key. Default: \code{Sys.getenv("spectator_earth_api_key")}
#' @return A data frame with attributes
#' \describe{
#'   \item{\code{name}}{character, name of the file}
#'   \item{\code{path}}{character, path (relative) to download the file}
#'   \item{\code{size}}{integer, size of the file (in bytes)}
#'}
#' @details Besides the raw images (\code{jp2} files) as single bands, various auxiliary files are also available.
#'  To download the files, all the paths should be prepended with 
#'  \code{https://api.spectator.earth/imagery/{id}/files/}.
#'  The raw image files are quite big, if the area of interest is relatively small it might be better to use 
#'  \code{\link[spectator]{GetHighResolutionImage}}.
#'  
#' @examples  
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[spectator]{SearchImages}}, \code{\link[spectator]{GetHighResolutionImage}} 
#' @export 
#' @source \url{https://api.spectator.earth/#imagery-files}
#' @importFrom httr GET content
GetImageryFilesList <- 
function(id, api_key = Sys.getenv("spectator_earth_api_key")) 
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
    return(out)
}
