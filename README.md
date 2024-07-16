
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

## Installation

### Stable version

You can install the current stable version of `spectator` from [CRAN](https://cran.r-project.org/package=spectator) via:

``` r
install.packages("spectator")
```

Windows and MacOS binary packages are available from here.

### Development version

You can install the latest development version of `spectator` from GitHub with:

``` r
require(remotes)
install_github("zivankaraman/spectator")
```

## License

This package is released under
[GPLv3](https://opensource.org/licenses/gpl-3.0.html).


## How to use the package

You can read the package vignette, and/or run the demo examples.
You can also directly consult (without installing the package) a number of worked examples
[here](https://zivankaraman.github.io/spectator/UsingSpectator.html).
