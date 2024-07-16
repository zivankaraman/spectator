.onLoad <- function(libname, pkgname) {
    cat("Updating satellites database from Spectator Earth API ... ", file = stderr())
    satellites_db <- GetAllSatellites(positions = FALSE)
    assign("satellites_db", satellites_db, envir = parent.env(environment()))
    cat("done.", sep = "\n", file = stderr())
}
