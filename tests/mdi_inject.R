message("*** mdi_inject")

path <- system.file("examples", package = "mdi", mustWork = TRUE)

file <- file.path(path, "intro.md")
truth <- file.path(path, "intro.updated.md")
lines0 <- readLines(truth, warn = FALSE)

file <- file.path(path, "intro.md")
lines <- readLines(file, warn = FALSE)
cat(lines, sep = "\n")

lines2 <- mdi::mdi_inject(lines, barefile = file.path(path, "intro"), verbose = TRUE)
cat(lines2, sep = "\n")

stopifnot(all.equal(lines2, lines0))
