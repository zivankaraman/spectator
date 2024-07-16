.onLoad <- function(libname, pkgname) {
    satellites_db <- GetAllSatellites(positions = FALSE)
    assign("satellites_db", satellites_db, envir = parent.env(environment()))
}
