# "C:\Program Files\R\R-4.1.1\bin\Rscript.exe" PostGIS_bug.R >log 2>&1
options(echo = TRUE)

Sys.getenv("PROJ_LIB")
require(rgdal)
Sys.getenv("PROJ_LIB")
sessionInfo()
sp::CRS("+init=epsg:4326")
