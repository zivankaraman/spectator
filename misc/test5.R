# get the high resolution image of the Central Park

aoi <- sf::st_buffer(boundary, dist = 100)

bb <- st_bbox(aoi)
bb
st_bbox(boundary)

bb["ymin"] <- bb["ymin"] - 0.01
zone <- aoi
zone$geometry <- st_as_sfc(bb)
img <- GetHighResolutionImage(aoi = zone, id = best_id, bands = c(4, 3, 2), 
                              width = 164, height = 180,
                              file = tempfile(pattern = "img", fileext = ".jpg"), 
                              api_key = my_key)

library(raster)
ras <- raster::stack(img)
raster::extent(ras) = raster::extent(zone)
raster::crs(ras) <- sp::CRS("+proj=longlat +datum=WGS84")
plot(ras)
plot(ras[[1]])
plot(boundary, add = TRUE)


a = st_as_sfc(st_bbox(boundary))
b = st_buffer(a, dist = 10)

x = st_buffer(st_as_sfc(st_bbox(boundary)), dist = 100)

              endCapStyle = "FLAT", joinStyle = "BEVEL")
plot(st_as_sfc(st_bbox(x)))
plot(boundary, add = TRUE)

plot(st_as_sfc(st_bbox(boundary)), col = "blue", add = TRUE)
