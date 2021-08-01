
GetAllSatellites <- 
function(positions = TRUE) 
{
    endpoint <- "https://api.spectator.earth/satellite/"
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp)
    features <- cnt$features
    prop <- sapply(features, FUN = function(x) (x$properties))
    tab <- data.frame(id = sapply(features, "[[", "id"),
                      name = unlist(prop[1, ]),
                      norad_id = unlist(prop[2, ]),
                      sensors = sapply(prop[3, ], FUN = function(x) x[[1]]$type),
                      open = unlist(prop[4, ]),
                      platform = sapply(prop[5, ], SafeNull),
                      stringsAsFactors = FALSE, row.names = NULL)
    if (positions) {
        cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
        out <- geojsonio::geojson_sf(cnt)
        out$sensors <- tab$sensors
        out <- out[order(out$name), ]
        row.names(out) <- NULL
    } else {
        out <- tab
    }
    
    return(out)
}
