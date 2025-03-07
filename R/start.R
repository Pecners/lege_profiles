f <- list.files("R")
f <- f[order(f)]
f <- f[which(str_detect(f, "^\\d"))]
ff <- paste0("R/", f)
lapply(ff, source)
