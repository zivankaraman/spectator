SafeNull <- function(x) {
    # replace NULL elements in lists with NA, so they don't get dropped
    # sapply(lst, FUN = function(x) SafeNull(x$some_property))
    # lst <- list(list(id = 1, some_property = "abc"), list(id = 2, some_property = NULL), list(id = 3))
    # sapply(lst, FUN = function(x) SafeNull(x$some_property))
    # [1] "abc" NA    NA 
    # unlist(sapply(lst, FUN = function(x) x$some_property))
    # [1] "abc"
    ifelse(is.null(x), NA, x)
}

FindSatelliteId <- function(x) {
    # finds a satellite id from the internal satellite table
    idx <- charmatch(toupper(x), toupper(spectator::satellites_db$name), nomatch = NA_integer_)
    if (is.na(idx)) {
        stop(sprintf("satellite named '%s' not found", x))
    }
    if (idx == 0) {
        stop(sprintf("satellite name '%s' is ambigous, provide an unambigous name", x))
    }
    return(spectator::satellites_db$id[idx])
}

FindSatelliteName <- function(x) {
    # allow shorthand spellings, return official full name
    allowed.satellites <- c("Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8", "Landsat-9",
                            "S-1A", "S-1B", "S-2A", "S-2B", "L-8", "L-9",
                            "S1A", "S1B", "S2A", "S2B", "L8", "L9")
    names(allowed.satellites) <- c("Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8", "Landsat-9",
                                   "Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8", "Landsat-9",
                                   "Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8", "Landsat-9")
    # satellite.names <- paste(unique(names(allowed.satellites)[grep(x, allowed.satellites)]), collapse = ",")
    satellite.names <- paste(unique(names(allowed.satellites)[sapply(x, grep, allowed.satellites)]), collapse = ",")
    
    if (length(satellite.names) == 0)  {
        stop(sprintf("invalid satellite(s) requested '%s'", paste(as.character(x), collapse = ",")))
    }
    return(satellite.names)    
}

CheckResponseSatus <- function(resp) {
    # check if httr request succeeded
    if (resp$status_code != 200) {
        cnt <- httr::content(resp)
        msg <- sprintf("Request '%s' returned status code %d - '%s'",
                       resp$url, resp$status_code, cnt$error)
        stop(msg)
    }
}
