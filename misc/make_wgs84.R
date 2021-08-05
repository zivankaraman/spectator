library(sp)
wgs84 <- sp::CRS("+proj=longlat +datum=WGS84")
save(wgs84, file = "data/wgs84.rda")
