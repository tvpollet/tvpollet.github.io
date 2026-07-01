# fix_blog_image_paths.R
# Batch replace image paths in migrated blog posts.
# Replaces /img/ references with /assets/img/ and
# converts full-URL image references to relative paths.
#
# Run from the root of the new_website repository.
# Usage: Rscript fix_blog_image_paths.R [--dry-run]

library(stringr)
library(purrr)
library(tibble)
library(dplyr)
library(readr)

# --- Configuration -----------------------------------------------------------

setwd("~/Documents/GitHub/new_website")

# Directory containing blog posts
posts_dir <- "_posts"

# Set to TRUE for a preview without writing changes
dry_run <- "--dry-run" %in% commandArgs(trailingOnly = TRUE)

if (dry_run) {
  message("=== DRY RUN MODE — no files will be modified ===\n")
}

# --- Collect post files -------------------------------------------------------

post_files <- list.files(
  posts_dir,
  pattern = "\\.(md|markdown)$",
  full.names = TRUE,
  recursive = TRUE
)

if (length(post_files) == 0) {
  stop("No markdown files found in '", posts_dir, "'. ",
       "Are you running this from the repository root?")
}

message("Found ", length(post_files), " post file(s) in '", posts_dir, "'.\n")

# --- Define replacement rules -------------------------------------------------
# Order matters: apply the most specific patterns first.

replacements <- tribble(

  ~pattern,                                      ~replacement,           ~description,
  # 0. Rename Beautiful Jekyll 'image:' field to al-folio 'thumbnail:'
  #    Anchored to start-of-line so it only hits YAML front matter keys.
  "(?m)^image:",                                  "thumbnail:",          "YAML image: -> thumbnail:",
  # 1. Full-URL image refs in body text (markdown / HTML)
  "https?://tvpollet\\.github\\.io/img/",        "/assets/img/",        "Full URL -> relative /assets/img/",
  # 2. Root-relative /img/ paths (YAML front matter + body)
  "(?<![/\\w])/img/",
                                                  "/assets/img/",        "Root-relative /img/ -> /assets/img/",
)

# --- Helper: apply all replacements to one file -------------------------------

process_file <- function(filepath, replacements, dry_run = FALSE) {
  original <- read_file(filepath)
  modified <- original

  changes <- character()

  for (i in seq_len(nrow(replacements))) {
    pat  <- replacements$pattern[i]
    repl <- replacements$replacement[i]
    desc <- replacements$description[i]

    hits <- str_count(modified, pat)
    if (hits > 0) {
      modified <- str_replace_all(modified, pat, repl)
      changes <- c(changes, paste0("  [", hits, "x] ", desc))
    }
  }

  if (length(changes) == 0) {
    return(tibble(
      file    = filepath,
      status  = "no_change",
      details = "No /img/ references found"
    ))
  }

  if (!dry_run) {
    write_file(modified, filepath)
  }

  tibble(
    file    = filepath,
    status  = if (dry_run) "would_change" else "changed",
    details = paste(changes, collapse = "\n")
  )
}

# --- Run across all posts -----------------------------------------------------

results <- map_dfr(post_files, process_file,
                   replacements = replacements,
                   dry_run      = dry_run)

# --- Report -------------------------------------------------------------------

changed <- results |> filter(status %in% c("changed", "would_change"))
unchanged <- results |> filter(status == "no_change")

message("--- Summary ---")
message("Files with replacements: ", nrow(changed))
message("Files unchanged:         ", nrow(unchanged))

if (nrow(changed) > 0) {
  message("\nDetails of replacements:")
  walk(seq_len(nrow(changed)), function(i) {
    row <- changed[i, ]
    message("\n", row$file)
    message(row$details)
  })
}

# --- Additional audit: flag potential issues ----------------------------------

message("\n--- Audit: checking for remaining /img/ references ---")

remaining <- map_dfr(post_files, function(filepath) {
  content <- read_file(filepath)
  # Look for any leftover /img/ that wasn't already converted to /assets/img/
  leftover <- str_extract_all(content, "[^\\s\"'(]*?(?<!assets)/img/[^\\s\"')]*")[[1]]
  if (length(leftover) > 0) {
    tibble(file = filepath, reference = leftover)
  } else {
    tibble(file = character(), reference = character())
  }
})

if (nrow(remaining) > 0) {
  message("WARNING: ", nrow(remaining), " leftover /img/ reference(s) found:")
  walk(seq_len(nrow(remaining)), function(i) {
    message("  ", remaining$file[i], " -> ", remaining$reference[i])
  })
} else {
  message("All clear — no remaining /img/ references.")
}

# --- Audit: flag GIF files used in YAML image: field -------------------------

message("\n--- Audit: GIF files in YAML 'thumbnail:' field ---")

gif_in_yaml <- map_dfr(post_files, function(filepath) {
  content <- read_file(filepath)
  # Extract YAML front matter

  yaml_match <- str_match(content, "(?s)^---\\n(.*?)\\n---")
  if (is.na(yaml_match[1, 1])) return(tibble())


  yaml_block <- yaml_match[1, 2]
  img_line <- str_extract(yaml_block, "(thumbnail|image):\\s*.*\\.gif")
  if (!is.na(img_line)) {
    tibble(file = filepath, yaml_image = img_line)
  } else {
    tibble()
  }
})

if (nrow(gif_in_yaml) > 0) {
  message(
    "Found ", nrow(gif_in_yaml),
    " post(s) using a .gif in the YAML thumbnail/image field."
  )
  message("al-folio may not render these as expected (see notes below).")
  walk(seq_len(nrow(gif_in_yaml)), function(i) {
    message("  ", gif_in_yaml$file[i], " -> ", gif_in_yaml$yaml_image[i])
  })
} else {
  message("No GIF files in YAML thumbnail/image fields.")
}

message("\n--- Done ---")
