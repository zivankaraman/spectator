
library(maps)
library(sp)

sat <- c("Sentinel-2A", "Sentinel-2B")
day <- Sys.Date()
day <- "2021-08-15"

plan <- GetAcquisitionPlan(satellites = sat, date = day)

map("world", fill = TRUE, col = "lightgrey")
plot(plan, border = "red", add = TRUE)
title(main = sprintf("%s acquisition plan for %s", paste(sat, collapse = "/"), day))
