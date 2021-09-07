
#' @title Gets overpasses for an area of interest
#' @description Retrieves the footprint polygons of past and/or (near)future overpasses
#'  of specified satellites over an area of interest.
#' @param aoi '\code{sf}' (or '\code{Spatial*}') object defining the area of interest.
#'  Can be of any geometry as only the bounding box is used.
#' @param satellites character vector, if specified only the listed satellites will be retrieved,
#'  if \code{NULL} (default value) the acquisition plans for all possible satellites will be retrieved.
#'  For simplicity, the satellites names can be abbreviated to
#'  "S-1A", "S-1B", "S-2A", "S-2B", "L-8" or "S1A", "S1B", "S2A", "S2B", "L8". Default: NULL
#' @param days_before integer indicating the number of days before the current date for which
#'  overpasses should be computed. Default: 0
#' @param days_after integer indicating the number of days after the current date for which
#'  overpasses should be computed. Default: 7
#' @param acquisitions logical indicating if only the overpasses when the data acquisition
#'  will take place should be reported. Default: TRUE
#' @param api_key character containing your API key. Default: \code{Sys.getenv("spectator_earth_api_key")}
#' @return Object of class '\code{sf}' with '\code{POLYGON}' geometry type and attributes 
#' \describe{
#'   \item{\code{id}}{integer identifier}
#'   \item{\code{acquisitions}}{logical whether the overpass collects the data}
#'   \item{\code{date}}{POSIXct timestamp of the overpass (UTC - to be checked)}
#'   \item{\code{satellite}}{character satellite name}
#'}
#' @details
#'  This function requires an API key that is automatically generated for every registered account at
#'  \url{https://app.spectator.earth}. You can find it under 'Your profile' (bottom left button).
#'  By default, the API key is retrieved from the environment variable \code{spectator_earth_api_key},
#'  but you can choose any other way of providing it (it is recommended **NOT** to include it in your scripts). 
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  library(sf)
#'  # get the Luxembourg country shape as area of interest
#'  boundary <- read_sf(system.file("extdata", "luxembourg.geojson", package = "spectator"))
#'  # look for Sentinel-2 A and B, use shorthand notation, default time frame
#'  pass <- GetOverpasses(boundary, satellites = "S-2", acquisitions = TRUE)
#'  # do some nice graphs
#'  library(maps)
#'  days <- range(as.Date(pass$date))
#'  satellites <- sort(unique(pass$satellite))
#'  map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg",
#'      "France", "Switzerland"), col = "lightgrey", fill = TRUE)
#'  plot(sf::st_geometry(boundary), add = TRUE, col = "red", border = FALSE)
#'  plot(sf::st_geometry(pass), add = TRUE)
#'  title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
#'                       paste(days, collapse = ":")))
#'  }
#' }
# @seealso 
#  \code{\link[sf]{st_as_sf}}, \code{\link[sf]{st_bbox}}
#' @export 
#' @source \url{https://api.spectator.earth/#satellite-overpasses}
#' @importFrom sf st_as_sf st_bbox st_polygon st_sfc st_sf
#' @importFrom httr GET content
GetOverpasses <- 
function(aoi, satellites = NULL, days_before = 0, days_after = 7, acquisitions = TRUE, api_key = Sys.getenv("spectator_earth_api_key"))
{
    if (inherits(aoi, "Spatial")) {
        aoi <- sf::st_as_sf(aoi)
    }
    if (!inherits(aoi, "sf")) {
        stop("aoi argument must be a 'Spatial*' or 'sf' (simple feature) object")
    }
    # days_before = 0
    # days_after = 7 
    # api_key = Sys.getenv("api_key")
    # bbox <- "19.59,49.90,20.33,50.21"
    
    endpoint <- "https://api.spectator.earth/overpass/"
    bbox <- paste(as.numeric(sf::st_bbox(aoi)), collapse = ",")

    qry <- list(api_key = api_key, bbox = bbox, days_before = days_before, days_after = days_after)
    
    if (!is.null(satellites)) {
        # # allow shorthand spelling
        # allowed.satellites <- c("Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8",
        #                         "S-1A", "S-1B", "S-2A", "S-2B", "L-8",
        #                         "S1A", "S1B", "S2A", "S2B", "L8")
        # names(allowed.satellites) <- c("Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8",
        #                                "Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8",
        #                                "Sentinel-1A", "Sentinel-1B", "Sentinel-2A", "Sentinel-2B", "Landsat-8")
        # satellites <- paste(unique(names(allowed.satellites)[grep(satellites, allowed.satellites)]), collapse = ",")
        # if (length(satellites) == 0)  {
        #     stop()
        # }
        # satellites <- c("Sentinel-2A,Sentinel-2B")
        satellites <- FindSatelliteName(satellites)
        qry <- c(qry, satellites = satellites)
    }

    resp <- httr::GET(url = endpoint, query = qry)
    CheckResponseSatus(resp)

    cnt <- httr::content(resp)
    overpasses <- cnt$overpasses
    # saveRDS(overpasses, "misc/overpasses.rds")
    
    # get attributes
    df <- data.frame(id = sapply(overpasses, "[[", "id"),
                     # acquisition = sapply(overpasses, "[[", "acquisition"),
                     acquisition = sapply(overpasses, FUN = function(x) SafeNull(x$acquisition)),
                     date = sapply(overpasses, "[[", "date"),
                     satellite = sapply(overpasses, "[[", "satellite"),
                     stringsAsFactors = FALSE)
    row.names(df) <- df$id
    # convert datetime strings to POSIX format
    df$date <- as.POSIXct(gsub("Z", "", gsub("T", " ", df$date)), tz = "GMT")
    
    # # get footprint / polygons
    # koords <- sapply(overpasses, FUN = function(x) x$footprint$coordinates)
    # koords2 <- lapply(koords, FUN = function(x)  t(sapply(x, unlist)))
    # poly <- vector(mode = "list", length = length(koords2))
    # for (i in 1:length(koords2)) {
    #     poly[[i]] <- sp::Polygons(list(sp::Polygon(koords2[[i]], hole = FALSE)), ID = df$id[i])
    # }
    # # spoly <- sp::SpatialPolygons(poly, proj4string = sp::CRS("+proj=longlat +datum=WGS84"))
    # spoly <- sp::SpatialPolygons(poly, proj4string = wgs84)
    # 
    # spolydf <- sp::SpatialPolygonsDataFrame(spoly, data = df)
    # if (acquisitions) {
    #     spolydf <- subset(spolydf, spolydf$acquisition == TRUE)
    # }
    # out <- sf::st_as_sf(spolydf)

    # get geometry / centroids
    # mat <- t(sapply(overpasses, FUN = function(x) x$geometry$coordinates))
    # pts <- data.frame(long = unlist(mat[, 1]), lat = unlist(mat[, 2]))
    # sp::coordinates(pts) <- ~ long + lat
    # sp::proj4string(pts) <- sp::CRS("+proj=longlat +datum=WGS84")
    # sptsdf <- sp::SpatialPointsDataFrame(pts, data = df)
    # out <- list(footprint = spolydf, centroids = sptsdf)
    
    # get footprint / polygons
    koords <- lapply(overpasses, FUN = function(x) list(matrix(unlist(x$footprint$coordinates), ncol = 2, byrow = TRUE)))
    poly <- lapply(koords, sf::st_polygon)
    geom <- sf::st_sfc(poly, crs = 4326)
    out <- sf::st_sf(cbind(df, geom))
    
    # get data acquisition overpasses only? 
    if (acquisitions) {
        out <- subset(out, out$acquisition == TRUE)
    }
    
    return(out)
}
