

#' @title Get overpasses
#' @description Get overpasses
#' @param aoi PARAM_DESCRIPTION
#' @param satellites PARAM_DESCRIPTION. Default: NULL
#' @param days_before PARAM_DESCRIPTION. Default: 0
#' @param days_after PARAM_DESCRIPTION. Default: 7
#' @param acquisitions PARAM_DESCRIPTION. Default: TRUE
#' @param api_key PARAM_DESCRIPTION. Default: Sys.getenv("spectator_earth_api_key")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[sp]{bbox-methods}}, \code{\link[sp]{c("SpatialPolygons", "polygons")}}, \code{\link[sp]{SpatialPolygons}}, \code{\link[sp]{CRS-class}}, \code{\link[sp]{coordinates}}, \code{\link[sp]{is.projected}}, \code{\link[sp]{SpatialPoints}}
#'  \code{\link[httr]{GET}}, \code{\link[httr]{content}}
#' @export 
#' @source \url{http://somewhere.important.com/}
#' @importFrom sp bbox Polygons Polygon SpatialPolygons CRS SpatialPolygonsDataFrame coordinates proj4string SpatialPointsDataFrame
#' @importFrom httr GET content
GetOverpasses <- 
function(aoi, satellites = NULL, days_before = 0, days_after = 7, acquisitions = TRUE, api_key = Sys.getenv("spectator_earth_api_key"))
{
    if (!inherits(aoi, "Spatial")) {
        stop("aoi argument must be a Spatial* object")
    }
    # days_before = 0
    # days_after = 7 
    # api_key = Sys.getenv("api_key")
    # bbox <- "19.59,49.90,20.33,50.21"
    
    endpoint <- "https://api.spectator.earth/overpass/"
    bbox <- paste(as.numeric(sp::bbox(aoi)), collapse = ",")

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
    # get attributes
    df <- data.frame(id = sapply(overpasses, "[[", "id"),
                     # acquisition = sapply(overpasses, "[[", "acquisition"),
                     acquisition = sapply(overpasses, FUN = function(x) SafeNull(x$acquisition)),
                     date = sapply(overpasses, "[[", "date"),
                     satellite = sapply(overpasses, "[[", "satellite"),
                     stringsAsFactors = FALSE)
    row.names(df) <- df$id
    # get footprint / polygons
    koords <- sapply(overpasses, FUN = function(x) x$footprint$coordinates)
    koords2 <- lapply(koords, FUN = function(x)  t(sapply(x, unlist)))
    poly <- vector(mode = "list", length = length(koords2))
    for (i in 1:length(koords2)) {
        poly[[i]] <- sp::Polygons(list(sp::Polygon(koords2[[i]], hole = FALSE)), ID = df$id[i])
    }
    spoly <- sp::SpatialPolygons(poly, proj4string = sp::CRS("+proj=longlat +datum=WGS84"))
    spolydf <- sp::SpatialPolygonsDataFrame(spoly, data = df)
    if (acquisitions) {
        spolydf <- subset(spolydf, acquisition == TRUE)
    }
    
    # get geometry / centroids
    if (FALSE) {
        mat <- t(sapply(overpasses, FUN = function(x) x$geometry$coordinates))
        pts <- data.frame(long = unlist(mat[, 1]), lat = unlist(mat[, 2]))
        sp::coordinates(pts) <- ~ long + lat
        sp::proj4string(pts) <- sp::CRS("+proj=longlat +datum=WGS84")
        sptsdf <- sp::SpatialPointsDataFrame(pts, data = df)
    }
    # out <- list(footprint = spolydf, centroids = sptsdf)
    out <- spolydf
    return(out)
}
