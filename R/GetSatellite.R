
GetSatellite <- 
function(id = 17, positions = TRUE) 
{
    endpoint <- sprintf("https://api.spectator.earth/satellite/%d/", id)
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp)
    prop <- cnt$properties
    tab <- data.frame(id = cnt$id,
                      name = prop$name,
                      norad_id = prop$norad_id,
                      sensors = prop$sensors[[1]]$type,
                      open = prop$open,
                      platform = SafeNull(prop$platform),
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
