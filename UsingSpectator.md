---
title: "Using spectator - worked examples"
output:
  html_document:
    df_print: paged
    toc: yes
    toc_float: yes
    theme: flatly
vignette: >
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteIndexEntry{Worked examples of using spectator}
  %\VignetteEncoding{UTF-8}    
params:
  extra1: 'style="background-color: #ECF0F1; padding: 1px; display: inline-block;"'
---





# Introduction

The spectator package for R was developed to allow access to 
[Spectator Earth](https://spectator.earth/) API from R. Spectator Earth offers a Web app providing Earth Observation imagery, mainly from open data satellites like the Sentinel and the Landsat family. These features are also exposed through an API, and the goal of the spectator package is to provide easy access to this functionality from R.

The main functions allow to retrieve the acquisition plans for Sentinel-1, Sentinel-2 and Landsat-8 satellites and to get the past or (near)future overpasses over an area of interest for these satellites. It is also possible to search the archive for available images over the area of interest for a given (past) period, get the URL links to download the whole image tiles, or alternatively to download the image for just the area of interest based on selected spectral bands.

One can also get a current position and trajectory for a much larger set of satellites.

Other functions might be added in subsequent releases of the package.

# API key
Some of the functions (mainly those specific to Sentinel and Landsat satellites) require to pass an API key as a parameter to the function (because the underlying API endpoint requires it). The API key is automatically generated for every registered user at https://app.spectator.earth. You can find it under 'Your profile' (bottom left button) and copy it to clipboard. The functions in the spectator package by default retrieve the API key from the environment variable "spectator_earth_api_key". You can choose any other way of providing it, but keep in mind that for security reasons it is NOT recommended to hard-code (include it as clear text) it in your scripts.



# Satellites

We can get the list of all the satellites referenced in the [Spectator Earth](https://spectator.earth/) database and their current positions.


```r
pos <- GetAllSatellites(positions = TRUE)
head(pos, n = 20L)
#> Simple feature collection with 20 features and 6 fields (with 10 geometries empty)
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -95.15792 ymin: -61.67737 xmax: 113.4846 ymax: 77.64934
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>    id                              name norad_id sensors  open platform                    geometry
#> 1  36                            ALOS-2    39766     SAR FALSE     <NA>     POINT (25.47162 8.3314)
#> 2  25                              Aqua    27424 OPTICAL  TRUE     <NA>   POINT (43.22324 31.63429)
#> 3  63 CartoSat 2 (IRS P7, CartoSat 2AT)    29710 UNKNOWN FALSE     <NA>                 POINT EMPTY
#> 4  65                       CartoSat 2B    36795 UNKNOWN FALSE     <NA>                 POINT EMPTY
#> 5  66                       CartoSat 2C    41599 UNKNOWN FALSE     <NA>                 POINT EMPTY
#> 6  67                       CartoSat 2D    41948 UNKNOWN FALSE     <NA>                 POINT EMPTY
#> 7  68                       CartoSat 2E    42767 UNKNOWN FALSE     <NA>                 POINT EMPTY
#> 8  69                       CartoSat 2F    43111 UNKNOWN FALSE     <NA>                 POINT EMPTY
#> 9  38                           CBERS-4    40336 OPTICAL  TRUE     <NA> POINT (-14.99341 -61.67737)
#> 10 81                Coriolis (Windsat)    27640 UNKNOWN FALSE     <NA>                 POINT EMPTY
```

We can now plot the current positions of all the satellites on the world map.



























































