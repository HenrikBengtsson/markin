#' The Markdown Injector (MDI)
#'
#' @param file The Markdown file
#'
#' @param verbose If TRUE, verbose messages are outputted, otherwise not.
#'
#' @return (invisible; character vector)
#' The Markdown file content with updated lines.
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils file_test
#' @export
mdi <- function(file, verbose = FALSE) {
  stopifnot(file_test("-f", file))
  barefile <- file_path_sans_ext(file)

  if (verbose) {
    message("File: ", file)
    message("Bare file: ", barefile)
  }

  lines <- readLines(file, warn = FALSE)
  mdi_inject(lines, barefile = barefile, verbose = verbose)
}


#' @param lines (character) The Markdown lines to be processed.
#'
#' @param barefile (character string) The bare file without the filename extension.
#'
#' @return (character) The updated Markdown lines.
#'
#' @rdname mdi
#' @importFrom utils file_test
#' @export
mdi_inject <- function(lines, barefile, verbose = FALSE) {
  stopifnot(is.character(lines), !anyNA(lines))
  stopifnot(is.character(barefile), length(barefile) == 1L, !is.na(barefile))
  path <- dirname(barefile)
  stopifnot(file_test("-d", path))
  
  pattern <- "(.*)<!--[[:space:]]+(code-block)([[:space:]](.*))?[[:space:]]+-->(.*)"
  idxs <- grep(pattern, lines)
  nlines <- length(lines)
  
  if (verbose) {
    message("Bare file: ", barefile)
    message("Number of lines: ", nlines)
    message("Number of MDI declarations: ", length(idxs))
  }

  chunk_idx <- 1L
  for (kk in seq_along(idxs)) {
    idx <- idxs[kk]
    line <- lines[idx]
    prefix <- gsub(pattern, "\\1", line)
    command <- gsub(pattern, "\\2", line)
    args <- gsub(pattern, "\\4", line)
    suffix <- gsub(pattern, "\\5", line)
    if (verbose) {
      message("MDI declaration: ", sQuote(line))
      message("Prefix: ", sQuote(prefix))
      message("Command: ", sQuote(command))
      message("Arguments: ", sQuote(args))
      message("Suffix: ", sQuote(suffix))
    }
  
    ## Parse arguments
    if (nzchar(args)) {
      ## - <filename>
      ## - <filename>#<label>
      ## - #<label>
      args_pattern <- "^([^#]*)(|#([^#]+))$"
      if (!grepl(args_pattern, args)) {
        stop(sprintf("Syntax error: Unknown %s arguments: %s",
             sQuote(command), sQuote(args)))
      }
      args <- list(
        filename = gsub(args_pattern, "\\1", args),
        label    = gsub(args_pattern, "\\3", args)
      )
      for (name in names(args)) {
        if (!nzchar(args[[name]])) args[[name]] <- NULL
      }
    } else {
      args <- NULL
    }

    ## Peform command
    if (verbose) {
      message("*** ", command)
      for (name in names(args)) {
        message(sprintf(" - %s: %s", name, sQuote(args[[name]])))
      }
    }
    if (command == "code-block") {
      ## Find Markdown code block
      cidxs <- idx + grep("```", lines[-seq_len(idx)])[1:2]
      stopifnot(!anyNA(cidxs))
      ats <- cidxs[1]:cidxs[2]
      block <- lines[ats]
      
      language <- gsub("^```([a-z]+)?", "\\1", block[1])
      
      if (is.null(args$filename)) {
        chunk_file <- barefile
      } else {
        chunk_file <- file.path(path, args$filename)
      }
      
      if (is.null(args$label)) {
        chunk_label <- kk
      } else {
        chunk_label <- args$label
      }

      file_to_inject_prefix <- sprintf("%s.%s.%s", basename(chunk_file), language, command)
      if (grepl("^[0-9]+$", chunk_label)) {
        fmtstr <- "^%s.%s(|.label=[[:alnum:]_-]+)$"
      } else {
        fmtstr <- "^%s.[0-9]+(|.label=%s)$"
      }
      file_pattern <- sprintf(fmtstr, file_to_inject_prefix, chunk_label)
      file_to_inject <- dir(path = path, pattern = file_pattern)
      if (length(file_to_inject) == 0L) {
        stop(sprintf("No such %s file with label %s (path: %s, pattern: %s)", sQuote(command), sQuote(chunk_label), sQuote(path), sQuote(file_pattern)))
      } else if (length(file_to_inject) > 1L) {
        stop(sprintf("More than %s file with label %s (path: %s, pattern: %s): [n=%d] %s", sQuote(command), sQuote(chunk_label), sQuote(path), sQuote(file_pattern), length(file_to_inject), paste(sQuote(file_to_inject), collapse = ", ")))
      }
      file_to_inject <- file.path(path, file_to_inject)
      if (verbose) message("File to inject: ", sQuote(file_to_inject))
      if (!file_test("-f", file_to_inject)) {
        stop("No such file: ", sQuote(file_to_inject))
      }
      bfr <- readLines(file_to_inject, warn = FALSE)
      bfr <- paste(bfr, collapse = "\n")
      lines[ats[1]] <- sprintf("%s\n%s", lines[ats[1]], bfr)
      if (length(ats) >= 3L) {
        drop <- ats[2:(length(ats)-1L)]
        lines[drop] <- NA_character_
      }
    }
  }

  if (verbose) message("Number of lines: ", length(lines))
  stopifnot(length(lines) == nlines)
  
  lines <- lines[!is.na(lines)]
  if (verbose) message("Number of lines: ", length(lines))

  lines <- paste(c(lines, ""), collapse = "\n")
  lines <- strsplit(lines, split = "\n", fixed = TRUE)
  lines <- unlist(lines, use.names = FALSE)

  if (verbose) message("Number of lines: ", length(lines))

  lines
}
