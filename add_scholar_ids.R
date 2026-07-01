#!/usr/bin/env Rscript
# =============================================================================
# add_scholar_ids.R
#
# Fetches Google Scholar publication IDs (pubid) using the `scholar` package
# and adds them to papers.bib as google_scholar_id fields.
#
# Run locally — Google Scholar blocks server/CI requests.
#
# Usage:
#   Rscript add_scholar_ids.R
#
# Requirements:
#   install.packages(c("scholar", "tidyverse", "bibtex"))
# =============================================================================

library(tidyverse)
library(scholar)

# --- Configuration -----------------------------------------------------------

# Your Google Scholar profile ID (from the URL: ?user=THIS_BIT)
scholar_id <- "T2fYknYAAAAJ"

# Path to your papers.bib (adjust if needed)
bib_path <- "_bibliography/papers.bib"

# Output path for the updated .bib
out_path <- "_bibliography/papers.bib"

# --- Step 1: Fetch publications from Google Scholar --------------------------

message("Fetching publications from Google Scholar...")
message("(If this fails with a 429/captcha error, wait 5 mins and try again)")

pubs <- get_publications(scholar_id)

message(sprintf("Retrieved %d publications from Google Scholar", nrow(pubs)))

# Clean up the Scholar data
scholar_df <- pubs |>
  select(title, pubid, cid, cites, year) |>
  mutate(
    # Normalise title for matching: lowercase, strip punctuation
    title_norm = title |>
      str_to_lower() |>
      str_replace_all("[^a-z0-9\\s]", "") |>
      str_squish()
  )

# --- Step 2: Read the .bib file as text --------------------------------------

message(sprintf("Reading %s...", bib_path))
bib_lines <- read_lines(bib_path)
bib_text <- paste(bib_lines, collapse = "\n")

# --- Step 3: Extract entries and their titles from the .bib ------------------

# Find all entry keys and titles
entry_pattern <- "@\\w+\\{([^,]+),"
title_pattern <- "title\\s*=\\s*\\{([^}]+)\\}"

# Get all entry blocks (split on @)
entries <- str_split(bib_text, "(?=@\\w+\\{)")[[1]]
entries <- entries[entries != ""]

bib_df <- tibble(
  block = entries
) |>
  mutate(
    key = str_extract(block, "@\\w+\\{([^,]+),", group = 1),
    title_raw = str_extract(block, "title\\s*=\\s*\\{([^}]+)\\}", group = 1)
  ) |>
  filter(!is.na(key), !is.na(title_raw)) |>
  mutate(
    # Normalise bib title for matching
    title_norm = title_raw |>
      str_replace_all("\\\\[a-zA-Z]+\\{[^}]*\\}", "") |>  # Remove LaTeX accents
      str_replace_all("[\\{\\}\\\\`']", "") |>
      str_to_lower() |>
      str_replace_all("[^a-z0-9\\s]", "") |>
      str_squish(),
    has_scholar_id = str_detect(block, "google_scholar_id")
  )

message(sprintf("Found %d entries in .bib, %d already have google_scholar_id",
                nrow(bib_df), sum(bib_df$has_scholar_id)))

# --- Step 4: Match by normalised title ---------------------------------------

# Use a fuzzy word-overlap approach for robustness
match_titles <- function(bib_title, scholar_titles) {
  bib_words <- str_split(bib_title, "\\s+")[[1]]
  bib_words <- bib_words[nchar(bib_words) > 3]

  if (length(bib_words) < 3) return(NA_integer_)

  overlaps <- map_dbl(scholar_titles, function(st) {
    s_words <- str_split(st, "\\s+")[[1]]
    s_words <- s_words[nchar(s_words) > 3]
    if (length(s_words) == 0) return(0)
    length(intersect(bib_words, s_words)) / length(bib_words)
  })

  best_idx <- which.max(overlaps)
  if (overlaps[best_idx] > 0.6) return(best_idx) else return(NA_integer_)
}

bib_df <- bib_df |>
  mutate(
    scholar_idx = map_int(title_norm, ~match_titles(.x, scholar_df$title_norm)),
    pubid = if_else(!is.na(scholar_idx), scholar_df$pubid[scholar_idx], NA_character_),
    scholar_cites = if_else(!is.na(scholar_idx), scholar_df$cites[scholar_idx], NA_integer_)
  )

matched <- bib_df |> filter(!is.na(pubid), !has_scholar_id)
already <- bib_df |> filter(has_scholar_id)
unmatched <- bib_df |> filter(is.na(pubid), !has_scholar_id)

message(sprintf("\nMatched: %d", nrow(matched)))
message(sprintf("Already had ID: %d", nrow(already)))
message(sprintf("Unmatched: %d", nrow(unmatched)))

if (nrow(unmatched) > 0) {
  message("\nUnmatched entries (may need manual checking):")
  walk(unmatched$key, ~message(sprintf("  %s", .x)))
}

# --- Step 5: Add google_scholar_id to the .bib text -------------------------

# Helper: escape special regex characters
regex_escape <- function(x) {
  str_replace_all(x, "([\\[\\]\\(\\)\\{\\}\\\\\\^\\$\\.\\|\\?\\*\\+])", "\\\\\\1")
}

updated_bib <- bib_text

for (i in seq_len(nrow(matched))) {
  key <- matched$key[i]
  pid <- matched$pubid[i]

  # Find the entry by key and add google_scholar_id before the closing }
  old_pattern <- sprintf("(@\\w+\\{%s,[\\s\\S]*?)(\\n\\})", regex_escape(key))
  match_result <- str_match(updated_bib, old_pattern)

  if (!is.na(match_result[1, 1])) {
    new_entry <- paste0(
      match_result[1, 2],
      sprintf(",\n  google_scholar_id = {%s}", pid),
      match_result[1, 3]
    )
    updated_bib <- str_replace(updated_bib, fixed(match_result[1, 1]), new_entry)
  }
}

# --- Step 6: Write the updated .bib -----------------------------------------

write_lines(updated_bib, out_path)
message(sprintf("\nWrote updated .bib to %s", out_path))
message(sprintf("Added google_scholar_id to %d entries", nrow(matched)))

# --- Step 7: Summary report --------------------------------------------------

message("\n=== Summary ===")
message(sprintf("Google Scholar publications: %d", nrow(scholar_df)))
message(sprintf("Bib entries: %d", nrow(bib_df)))
message(sprintf("Matched + ID added: %d", nrow(matched)))
message(sprintf("Already had ID: %d", nrow(already)))
message(sprintf("Unmatched: %d", nrow(unmatched)))

# Save a CSV of the matching for manual verification
match_report <- bib_df |>
  select(key, title_norm, pubid, scholar_cites, has_scholar_id) |>
  arrange(desc(!is.na(pubid)), key)

write_csv(match_report, "scholar_id_matching_report.csv")
message("\nMatching report saved to scholar_id_matching_report.csv")
message("Check this file to verify matches before pushing the .bib")
