# create HTML vignette
rmarkdown::render(input = "C:/GitHub/spectator/vignettes2/UsingSpectator.Rmd", output_file = "UsingSpectator.html")
# rename vignettes folders to build
file.rename("vignettes", "vignettes1")
file.rename("vignettes2", "vignettes")
# build with real vignette
devtools::build()
# extract updated vignette files for doc
chemin <- gsub("\\\\", "/", tempfile("dir"))
tgz <- "C:/GitHub/spectator_0.1.0.tar.gz"
untar(tgz, files = "spectator/inst/doc", exdir = chemin)
dirfrom <- paste0(chemin, "/spectator/inst/doc")
file.copy(from = list.files(dirfrom,full.names = TRUE), to = "./documentation/", overwrite = TRUE)
# rename vignettes folders after build to get dummy vignette
file.rename("vignettes", "vignettes2")
file.rename("vignettes1", "vignettes")
# build with fake vignette
devtools::build()
# fix the tar file
source("dev/fixtar.R")
# re-install
detach("package:spectator", unload = TRUE)
install.packages(tgz, repos = NULL, type = "source")

# check on rhub
chk <- rhub::check_for_cran(tgz, show_status = FALSE)
