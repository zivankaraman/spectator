# fic <- "C:/GitHub/spectator/vignettes/UsingSpectator2/0/api.spectator.earth/acquisition-plan.json"
# lst <- jsonlite::fromJSON(fic)
# idx <- 1:100
# lst[[2]]$type <- lst[[2]]$type[idx]
# lst[[2]]$geometry <- lst[[2]]$geometry[idx, ]
# lst[[2]]$properties <- lst[[2]]$properties[idx, ]
# json <- jsonlite::toJSON(lst, pretty = TRUE)
# tmp <- tempfile()
# cat(json, file = tmp)
# geojsonsf::geojson_sf(tmp)

text <- readLines(fic)
idx <- grep("        {", text, fixed = TRUE)
text2 <- text[1:(idx[101] - 2)]
cat(c(text2, tail(text, n = 3L)), file = tmp, sep = "\n")
geojsonsf::geojson_sf(tmp)
cat(c(text2, tail(text, n = 3L)), file = fic, sep = "\n")
geojsonsf::geojson_sf(fic)

