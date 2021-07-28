
#' @title Safe null
#' @description Safe null
#' @param x PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @export 
#' @source \url{http://somewhere.important.com/}
SafeNull <-
function(x)
{
    ifelse(is.null(x), NA, x)
}
