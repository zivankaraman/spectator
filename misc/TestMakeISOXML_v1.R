Bbox2Poly <- 
function(x) {
    bb <- sp::bbox(x)
    bboxMat <- cbind(bb[1, c(1, 1, 2, 2, 1)], bb[2, c(1, 2, 2, 1, 1)])
    bboxSP <- sp::SpatialPolygons(list(sp::Polygons(list(sp::Polygon(bboxMat)), "bbox")), proj4string = sp::CRS(sp::proj4string(x)))
}

RotateProj <-
function(spobj, angle)
{
    # get bounding box as spatial points object
    boxpts = sp::SpatialPoints(t(sp::bbox(spobj)), proj4string = sp::CRS(sp::proj4string(spobj)))
    # convert to lat-long
    boxLL = sp::bbox(sp::spTransform(boxpts, sp::CRS("+init=epsg:4326")))
    # find the centre
    llc = apply(boxLL, 1, mean)
    # construct the proj4 string
    prj = paste0("+proj=omerc +lat_0=", llc[2], " +lonc=", llc[1], " +alpha=",
                 angle, " +gamma=0.0 +k=1.000000 +x_0=0.000 +y_0=0.000 +ellps=WGS84 +units=m ")
    # return as a CRS:
    sp::CRS(prj)
}

RasterizeMap <-
function(map, field, resolution = 5)
{
    if (is.numeric(field) & length(field) == 1) {
        field <- names(map@data)[field]
    }
    prj <- RotateProj(map, 0.00001)
    map2 <- sp::spTransform(map, prj)
    bb2 <- sp::bbox(map2)
    bb2[, 1] <- floor(bb2[, 1])
    bb2[, 2] <- ceiling(bb2[, 2])
    dims <- apply(bb2, 1, diff)
    n <- ceiling(dims / resolution)
    minX <- bb2[1, 1]
    minY <- bb2[2, 1]
    maxX <- n["x"] * resolution + minX
    maxY <- n["y"] * resolution + minY
    ras2 <- raster::raster(nrows = n["y"], ncols = n["x"], crs = prj)
    raster::extent(ras2) <- raster::extent(minX, maxX, minY, maxY)
    ras3 <- raster::rasterize(map2, ras2, field = field, fun = "first")
    bb3 <- Bbox2Poly(ras3)
    ext3 <- sp::spTransform(bb3,sp::proj4string(map) )
    ras4 <- raster::raster(nrows = n["y"], ncols = n["x"])
    raster::extent(ras4) <- raster::extent(ext3)
    ras <- raster::projectRaster(ras3, ras4)
    return(ras)
}


rds <- "C:/Users/zivan.karaman/Documents/EasyVR_Preco2019/Outputs/EVR00786/EVR00786.rds"
evr <- readRDS(rds)


ras <- RasterizeMap(evr$finalEasyVRMap, "density")
plot(ras, col = rainbow(999, start = 0, end = 1/3))
vals <- raster::values(ras)
summary(vals)
vals[is.na(vals)] <- 0
vals <- as.integer(vals)
nNorth <- ras@nrows
nEast <- ras@ncols
mat <- matrix(vals, nrow = nNorth, ncol = nEast, byrow = TRUE)
mat <- mat[nrow(mat):1, ]
vals <- as.integer(t(mat))
writeBin(vals, "mygrid.bin")




N <- ras@ncols * ras@nrows
vals2 <- readBin("mygrid.bin", what = "integer", n = N + 1000)

scale <- 1
nNorth <- ras@nrows
nEast <- ras@ncols

mat <- matrix(vals2, nrow = nNorth, ncol = nEast, byrow = TRUE)
mat <- mat[nrow(mat):1, ]
ras2 <- raster::raster(nrows = nNorth, ncols = nEast)
#raster::extent(ras2) <- c(startEast, endEast, startNorth, endNorth)
raster::extent(ras2) <- raster::extent(ras)
raster::projection(ras2) <- sp::CRS("+proj=longlat +datum=WGS84")
raster::values(ras2) <- mat * scale
plot(ras2, col = rainbow(999, start = 0, end = 1/3))
ras2[ras2 == 0] <- NA
plot(ras2, col = rainbow(999, start = 0, end = 1/3))

pp <- RotateProj(ras, 0.00001)
ras2 <- raster::projectRaster(from = ras, crs = pp)
print(ras2)



