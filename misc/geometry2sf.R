library(sf)

geometry <- readRDS("C:/GitHub/spectator/misc/geometry.rds")
catalogue <- readRDS("C:/GitHub/spectator/misc/catalogue.rds")

koords <- lapply(geometry, FUN = function(x) list(matrix(unlist(x), ncol = 2, byrow = TRUE)))
poly <- lapply(koords, st_polygon)
geom <- st_sfc(poly, crs = 4326)
N <- length(geom)
dat <- data.frame(a = 1:N, b = sample(LETTERS, size = N, replace = TRUE), stringsAsFactors = FALSE)
out <- st_sf(cbind(catalogue, geom))
plot(out)
print(out, n = 3)
attributes(out)


overpasses <- readRDS("C:/GitHub/spectator/misc/overpasses.rds")
koords <- lapply(overpasses, FUN = function(x) list(matrix(unlist(x$footprint$coordinates), ncol = 2, byrow = TRUE)))
poly <- lapply(koords, st_polygon)
geom <- st_sfc(poly, crs = 4326)
N <- length(geom)
dat <- data.frame(a = 1:N, b = LETTERS[1:N], stringsAsFactors = FALSE)
out <- st_sf(cbind(dat, geom))
plot(out)
print(out, n = 3)
attributes(out)
