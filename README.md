
# spectator

Interface to 'Spectator Earth' API

## Description

This package provides interface to Spectator Earth API, mainly for
obtaining the acquisition plans and satellite overpasses for Sentinel-1,
Sentinel-2, Landsat-8 and Landsat-9 satellites. It is also possible to
search the archive for available images over the area of interest for a
given (past) period, get the URL links to download the whole image
tiles, or alternatively to download the image for just the area of
interest based on selected spectral bands. Current position and
trajectory can also be obtained for a much larger set of satellites.

## License

This package is released under
[GPLv3](https://opensource.org/licenses/gpl-3.0.html).

## Installation

You can install the release version of `spectator` from
[CRAN](https://cran.r-project.org/package=spectator)
with:

``` r
install.packages("spectator")
```

You can install the latest development version of `spectator` from
[here](https://zivankaraman.github.io/spectator/spectator_latest.tar.gz)
with:

``` r
install.packages("https://zivankaraman.github.io/spectator/spectator_latest.tar.gz", repos = NULL)
```

## How to use the package

A number of worked examples can be found here
[here](https://zivankaraman.github.io/spectator/UsingSpectator.html).
