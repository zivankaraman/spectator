#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param id PARAM_DESCRIPTION
#' @param api_key PARAM_DESCRIPTION, Default: Sys.getenv("spectator_earth_api_key")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[httr]{GET}},\code{\link[httr]{content}}
#' @export 
#' @source \url{http://somewhere.important.com/}
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
