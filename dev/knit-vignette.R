# create HTML vignette
rmarkdown::render(input = "C:/GitHub/spectator/vignettes2/UsingSpectator.Rmd", output_file = "UsingSpectator.html")
# rename vignettes folders to build
file.rename("vignettes", "vignettes1")
file.rename("vignettes2", "vignettes")
# remove previous spectator_latest.tar.gz
if (file.exists("spectator_latest.tar.gz")) file.remove("spectator_latest.tar.gz")
# build with real vignette
tgz <- devtools::build()
# extract updated vignette files for doc
chemin <- gsub("\\\\", "/", tempfile("dir"))
untar(tgz, files = "spectator/inst/doc", exdir = chemin)
dirfrom <- paste0(chemin, "/spectator/inst/doc")
file.copy(from = list.files(dirfrom,full.names = TRUE), to = "./documentation/", overwrite = TRUE)
# rename vignettes folders after build to get dummy vignette
file.rename("vignettes", "vignettes2")
file.rename("vignettes1", "vignettes")
# build with fake vignette
devtools::build()
# fix the tar file
bkp <- sub("tar.gz", "bkp.tar.gz", tgz, fixed = TRUE)
file.copy(from = tgz, to = bkp, overwrite = TRUE)
chemin <- gsub("\\\\", "/", tempfile("dir"))
untar(tgz, exdir = chemin)
dirto <- paste0(chemin, "/spectator/inst/doc")
fic <- list.files(dirto)
dirfrom <- "./documentation/"
file.copy(from = paste0(dirfrom, fic), to = dirto, overwrite = TRUE)
oldwd <- getwd()
setwd(chemin)
tar(tarfile = tgz, files = "spectator", compression = "gzip")
setwd(oldwd)
# re-install
detach("package:spectator", unload = TRUE)
install.packages(tgz, repos = NULL, type = "source")
# copy package archive to latest
file.copy(from = tgz, to = "spectator_latest.tar.gz", overwrite = TRUE)

# check on rhub
chk <- rhub::check_for_cran(tgz, show_status = FALSE)
