

library(rcmdcheck)

chk <- rcmdcheck::rcmdcheck()

chk <- rcmdcheck::rcmdcheck(args = "--as-cran", repos = "https://cloud.r-project.org/")



