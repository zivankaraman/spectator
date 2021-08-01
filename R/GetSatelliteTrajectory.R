
GetSatelliteTrajectory <- 
function(satellite)
{
    id <- FindSatellite(satellite)
    endpoint <- sprintf("https://api.spectator.earth/satellite/%d/trajectory/", id)
    
    resp <- httr::GET(url = endpoint)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
    trajectory <- geojsonio::geojson_sp(cnt)
    
    return(trajectory)
}
