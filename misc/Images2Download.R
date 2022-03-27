images <- images[grep("^[[:upper:]][[:upper:]|[:digit:]]{2}.jp2$",images$path), ]
cat(images$path[grep("^[A-Z][[:upper:]|[:digit:]]{2}.jp2",images$path)], sep = ", ")
