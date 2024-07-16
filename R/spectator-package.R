#' @name spectator-package
#" @aliases spectator-package spectator
#' @aliases spectator
#' @author Zivan Karaman <zivan.karaman@gmail.com>
# @seealso \link{ca630}, \code{\link{sp1}, \link{sp2}, \link{sp3}, \link{sp4}, \link{sp5}}
#' 
#' @title Package providing interface to the 'Spectator Earth' API 
#' 
#' @description
#'
#' The \code{spectator} package for R was developed to allow access to
#' '[Spectator Earth](https://spectator.earth/)' API from R.
#' Spectator Earth offers a Web app providing Earth Observation imagery,
#' mainly from open data satellites like the Sentinel and the Landsat family.
#' These features are also exposed through an [API](https://api.spectator.earth/),
#' and the goal of the \code{spectator} package is to provide easy access to
#' this functionality from R.
#' 
#' The main functions allow to retrieve the acquisition plans for Sentinel-1, Sentinel-2,
#' Landsat-8 and Landsat-9 satellites and to get the past or (near)future overpasses over 
#' an area of interest for these satellites. It is also possible to search the archive
#' for available images over the area of interest for a given (past) period, get the URL 
#' links to download the whole image tiles, or alternatively to download the image for 
#' just the area of interest based on selected spectral bands.  
#' 
#' One can also get a current position and trajectory for a much larger set of satellites.
#' 
#' Other functions might be added in subsequent releases of the package. 
#'
#' Demos: \code{demo(package = "spectator")}
#'
#'
#' @section API key:
#' Some of the functions (mainly those specific to Sentinel and Landsat satellites) 
#' require to pass an API key as a parameter to the function
#' (because the underlying API endpoint requires it).
#' The API key is automatically generated for every registered user at
#' \url{https://app.spectator.earth}. You can find it under 'Your profile' (bottom left button)
#' and copy it to clipboard.
#' The functions in the \code{spectator} package by default retrieve the API key 
#' from the environment variable "\code{spectator_earth_api_key}".
#' You can choose any other way of providing it, but keep in mind that for security reasons 
#' it is **NOT** recommended to hard-code (include it as clear text) it in your scripts. 
#' 
#' 
# [Project homepage](https://github.com/zivankaraman/spectator)
# [For bug reports and feature requests please use the tracker](https://github.com/zivankaraman/spectator)
#' 
# @section Issues:
# For bug reports and feature requests please use the tracker:
# \url{https://github.com/zivankaraman/spectator}.
#'
#'    
#' 
## @keywords internal
##"_PACKAGE"
NULL
