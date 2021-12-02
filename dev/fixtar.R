chemin <- gsub("\\\\", "/", tempfile("dir"))
tgz <- "C:/GitHub/spectator_0.1.0.tar.gz"
file.copy(from = tgz, to = "C:/GitHub/spectator_0.1.0.bkp.tar.gz", overwrite = TRUE)
untar(tgz, exdir = chemin)
dirto <- paste0(chemin, "/spectator/inst/doc")
fic <- list.files(dirto)
dirfrom <- "./documentation/"
file.copy(from = paste0(dirfrom, fic), to = dirto, overwrite = TRUE)
oldwd <- getwd()
setwd(chemin)
tar(tarfile = tgz, files = "spectator", compression = "gzip")
setwd(oldwd)
