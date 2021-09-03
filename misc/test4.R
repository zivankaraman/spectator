api_key = Sys.getenv("spectator_earth_api_key")
aoi <- sf::read_sf(system.file("extdata", "luxembourg.geojson", package = "spectator"))
from <- "2020-05-01"
to <- "2021-05-01"
satellites <- c("Sentinel-2A,Sentinel-1B,Landsat-8")
satellites <- c("Sentinel-2A,Sentinel-2B")




writeBin(cnt, "img.jpg")
library(raster)
ras = stack("img.jpg")
extent(ras) = extent(aoi)

crs(ras) = sp::CRS("+proj=longlat +datum=WGS84")
plot(ras[[1]])
plot(aoi, add = TRUE)

plotRGB(ras, margins = TRUE)
plot(aoi, lwd = 5, border = "orange", add = TRUE)

    
buf = units::set_units(10, m)
plot(st_geometry(st_buffer(as(aoi, "sf"), dist = buf)))

p = as(aoi, "sf")

plot(st_geometry(st_buffer(p, dist = 10)), add = TRUE)
st_union(as(aoi, "sf"))
