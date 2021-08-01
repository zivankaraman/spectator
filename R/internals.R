
SafeNull <-
function(x)
{
    # replace NULL elements in lists with NA, so they don't get dropped
    # sapply(lst, FUN = function(x) SafeNull(x$some_property))
    # lst <- list(list(id = 1, some_property = "abc"), list(id = 2, some_property = NULL), list(id = 3))
    # sapply(lst, FUN = function(x) SafeNull(x$some_property))
    # [1] "abc" NA    NA 
    # unlist(sapply(lst, FUN = function(x) x$some_property))
    # [1] "abc"
    ifelse(is.null(x), NA, x)
}


FindSatellite <-
function(x)
{
    idx <- charmatch(toupper(x), toupper(satellites$name), nomatch = NA_integer_)
    if (is.na(idx)) {
     stop(sprintf("satellite named '%s' not found", x))
    }
    if (idx == 0) {
     stop(sprintf("satellite name '%s' is ambigous, provide an unambigous name", x))
    }
    return(satellites$id[idx])    
}

CheckResponseSatus <- 
function(resp)
{
    if (resp$status_code != 200) {
        cnt <- httr::content(resp)
        msg <- sprintf("Request '%s' returned status code %d - '%s'",
                       resp$url, resp$status_code, cnt$error)
        stop(msg)
    }
}
