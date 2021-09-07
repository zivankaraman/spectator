api_key = Sys.getenv("spectator_earth_api_key")

satellites <- c("Sentinel-2A,Sentinel-2B")

aoi = readRDS("C:/Datoteka/Fichiers/_AgNum/R/agrility/Mons/Data/fields.rds")

width = 4096
height = 4096
bands = c(4, 3, 2)

width = 1024
height = 768


id = 21529552
id = 21529497
bands = 2:6

fic <- paste0(tempfile(), ".jpg")
HighResolutionImage(aoi = aoi, id = id, bands = bands, width = width, 
                    height = height, file = fic, 
                    api_key = Sys.getenv("spectator_earth_api_key")) 
cat(fic, "\n")


for (i in 1:12) {
    bands <- i
    fic <- sprintf("%s/Band%2.2d.jpg", tempdir(), i)
    HighResolutionImage(aoi = aoi, id = id, bands = bands, width = width, 
                        height = height, file = fic, 
                        api_key = Sys.getenv("spectator_earth_api_key")) 
    cat(fic, "\n")
}


bands = "8A"
fic <- sprintf("%s/Band8A.jpg", tempdir())
HighResolutionImage(aoi = aoi, id = id, bands = bands, width = width, 
                    height = height, file = fic, 
                    api_key = Sys.getenv("spectator_earth_api_key")) 

fic <- paste0(tempfile(), ".jpg")
HighResolutionImage(aoi = aoi, id = id, bands = bands, width = width, 
                    height = height, file = fic, 
                    api_key = Sys.getenv("spectator_earth_api_key")) 

