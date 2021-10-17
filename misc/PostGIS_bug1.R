options(echo = TRUE)

# before installing PostGIS

Sys.getenv("PROJ_LIB")
# [1] ""

require(rgdal)
# Loading required package: rgdal
# Loading required package: sp
# Please note that rgdal will be retired by the end of 2023,
# plan transition to sf/stars/terra functions using GDAL and PROJ
# at your earliest convenience.
# 
# rgdal: version: 1.5-27, (SVN revision 1148)
# Geospatial Data Abstraction Library extensions to R successfully loaded
# Loaded GDAL runtime: GDAL 3.2.1, released 2020/12/29
# Path to GDAL shared files: C:/Program Files/R/R-4.1.1/library/rgdal/gdal
# GDAL binary built with GEOS: TRUE 
# Loaded PROJ runtime: Rel. 7.2.1, January 1st, 2021, [PJ_VERSION: 721]
# Path to PROJ shared files: C:/Program Files/R/R-4.1.1/library/rgdal/proj
# PROJ CDN enabled: FALSE
# Linking to sp version:1.4-5
# To mute warnings of possible GDAL/OSR exportToProj4() degradation,
# use options("rgdal_show_exportToProj4_warnings"="none") before loading sp or rgdal.
# Overwritten PROJ_LIB was C:/Program Files/R/R-4.1.1/library/rgdal/proj

Sys.getenv("PROJ_LIB")
# [1] "C:/Program Files/R/R-4.1.1/library/rgdal/proj"

sessionInfo()

sp::CRS("+init=epsg:4326")
#  CRS arguments: +proj=longlat +datum=WGS84 +no_defs 


# after installing PostGIS

Sys.getenv("PROJ_LIB")
# [1] "C:\\Program Files\\PostgreSQL\\13\\share\\contrib\\postgis-3.1\\proj"

require(rgdal)
# Loading required package: rgdal
# Loading required package: sp
# Please note that rgdal will be retired by the end of 2023,
# plan transition to sf/stars/terra functions using GDAL and PROJ
# at your earliest convenience.
# 
# rgdal: version: 1.5-27, (SVN revision 1148)
# Geospatial Data Abstraction Library extensions to R successfully loaded
# Loaded GDAL runtime: GDAL 3.2.1, released 2020/12/29
# Path to GDAL shared files: C:/Program Files/R/R-4.1.1/library/rgdal/gdal
# GDAL binary built with GEOS: TRUE 
# Loaded PROJ runtime: Rel. 7.2.1, January 1st, 2021, [PJ_VERSION: 721]
# Path to PROJ shared files: C:/Program Files/R/R-4.1.1/library/rgdal/proj
# PROJ CDN enabled: FALSE
# Linking to sp version:1.4-5
# To mute warnings of possible GDAL/OSR exportToProj4() degradation,
# use options("rgdal_show_exportToProj4_warnings"="none") before loading sp or rgdal.
# Overwritten PROJ_LIB was C:/Program Files/R/R-4.1.1/library/rgdal/proj

Sys.getenv("PROJ_LIB")
# [1] "C:/Program Files/R/R-4.1.1/library/rgdal/proj"

sp::CRS("+init=epsg:4326")
# Error in sp::CRS("+init=epsg:4326") : NA

sessionInfo()
# R version 4.1.1 (2021-08-10)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 19043)
# 
# Matrix products: default
# 
# locale:
# [1] LC_COLLATE=French_France.1252  LC_CTYPE=French_France.1252   
# [3] LC_MONETARY=French_France.1252 LC_NUMERIC=C                  
# [5] LC_TIME=French_France.1252    
# 
# attached base packages:
# [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
# [1] rgdal_1.5-27 sp_1.4-5    
# 
# loaded via a namespace (and not attached):
# [1] compiler_4.1.1  tools_4.1.1     grid_4.1.1      lattice_0.20-45

