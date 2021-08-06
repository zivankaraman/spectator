library(sp)
wgs84 <- sp::CRS("+proj=longlat +datum=WGS84")
save(wgs84, file = "data/wgs84.rda")


usethis::use_data(wgs84, internal = TRUE)

