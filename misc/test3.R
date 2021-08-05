url = "https://download.data.public.lu/resources/limites-administratives-du-grand-duche-de-luxembourg/20180806-153458/communes4326.geojson"
x = sf::read_sf(url)
# class(x)
# sf::st_bbox(x)
# xx = sf::as_Spatial(x)
# xx@bbox

pass <- spectator::GetOverpasses(x, satellites = "S-2", acquisitions = TRUE)
# pass$date <- as.POSIXct(gsub("Z", "", gsub("T", " ", pass$date)), tz = "GMT")
days <- range(as.Date(pass$date))
satellites <- sort(unique(pass$satellite))
library(maps)

map(database = "world", region = c("Belgium", "Netherlands", "Germany", "Luxembourg", "France", "Switzerland"), col = "lightgrey", fill = TRUE)
plot(sf::st_geometry(x), add = TRUE, col = "red", border = FALSE)
plot(sf::st_geometry(pass), add = TRUE)
title(main = sprintf("%s overpasses for period %s", paste(satellites, collapse = "/"), 
                     paste(days, collapse = ":")))




Sys.getenv("GDAL_DATA")
Sys.unsetenv("GDAL_DATA")
Sys.getenv("GDAL_DATA")

crs <- new("CRS")
attr(crs, "projargs") <- "+proj=longlat +datum=WGS84 +no_defs"
attr(crs, "comment") <-  "GEOGCRS[\"unknown\",\n    DATUM[\"World Geodetic System 1984\",\n        ELLIPSOID[\"WGS 84\",6378137,298.257223563,\n            LENGTHUNIT[\"metre\",1]],\n        ID[\"EPSG\",6326]],\n    PRIMEM[\"Greenwich\",0,\n        ANGLEUNIT[\"degree\",0.0174532925199433],\n        ID[\"EPSG\",8901]],\n    CS[ellipsoidal,2],\n        AXIS[\"longitude\",east,\n            ORDER[1],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]],\n        AXIS[\"latitude\",north,\n            ORDER[2],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]]]"



cnt <- httr::content(resp, type = "text", encoding = "UTF-8")
out <- geojsonsf::geojson_sf(cnt)


days_before = 0
days_after = 7
api_key = Sys.getenv("spectator_earth_api_key")
bbox <- "19.59,49.90,20.33,50.21"