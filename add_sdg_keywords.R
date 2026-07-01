#!/usr/bin/env Rscript
# add_sdg_keywords.R
# -------------------------------------------------------------------
# Adds 'keywords' field to papers.bib entries for SDG page rendering.
# Run from the root of the new_website repo:
#   Rscript add_sdg_keywords.R
#   Rscript add_sdg_keywords.R --dry-run
# -------------------------------------------------------------------

library(tidyverse)

# ── Configuration ──────────────────────────────────────────────────
bib_path   <- "_bibliography/papers.bib"
backup     <- TRUE
dry_run    <- "--dry-run" %in% commandArgs(trailingOnly = TRUE)

# ── SDG mapping table ─────────────────────────────────────────────
# Each row maps a paper to one or more SDG keywords.
# match_type: "doi" matches on the doi field, "title" matches a
#             substring in the title field (case-insensitive).
# match_value: the DOI string (without https://doi.org/) or title
#              substring to search for.
# sdg: comma-separated SDG tags to assign.

sdg_map <- tribble(
  ~match_type, ~match_value, ~sdg, ~note,

  # ── SDG 3: Good Health and Well-being ───────────────────────────

  # Existing (from old page)
  "doi", "10.1016/j.yhbeh.2025.105719",
    "sdg3, sdg5", "Shiramizu 2025 — OC use/sexual satisfaction",
  "doi", "10.1155/2024/5513833",
    "sdg3", "Murphy-Morgan 2024 — hoarding/housing older adults",
  "doi", "10.5817/CP2024-1-3",
    "sdg3", "Roberts 2024 — Instagram/mental well-being",
  "doi", "10.1016/j.paid.2023.112474",
    "sdg3", "Delaney 2024 — involuntary celibates well-being",
  "doi", "10.1007/s12144-023-04697-9",
    "sdg3", "Thompson 2024 — loneliness older adults",
  "doi", "10.22330/he/37/036-045",
    "sdg3, sdg5", "Bainbridge 2022 — gender diff mask wearing",
  "doi", "10.1080/09638237.2022.2069695",
    "sdg3", "Rippon 2022 — social support/mental health",
  "doi", "10.1080/21642850.2021.1951272",
    "sdg3", "Cheyne 2021 — Type 1 diabetes/social support",
  "title", "attitudinal and perceptual body image",
    "sdg3", "Cornelissen 2019 — body image adaptation",
  "title", "3D visualisation of psychometric",
    "sdg3", "Mohamed 2021 — ideal male body image",
  "title", "Engagement with fat talk",
    "sdg3", "Pollet 2021 — fat talk/body image",
  "doi", "10.5817/CP2021-2-6",
    "sdg3", "Brown 2021 — loneliness/Facebook network",
  "title", "Experienced demand does not affect subsequent sleep",
    "sdg3", "Elder 2020 — sleep/stress/cortisol",
  "title", "Prevalence of depression and posttraumatic stress",
    "sdg3, sdg16", "Morina 2018 — PTSD war survivors",
  "title", "Interventions for children and adolescents with posttraumatic",
    "sdg3, sdg16", "Morina 2016 — PTSD interventions youth",

  # Suggested additions to SDG 3
  "doi", "10.1371/journal.pone.0348816",
    "sdg3, sdg4, sdg10", "Pollet 2026 — college adaptation/well-being",
  "doi", "10.1017/S0144686X22000666",
    "sdg3", "Thompson 2022 — friendships/loneliness/well-being older adults",

  # ── SDG 4: Quality Education ────────────────────────────────────

  # Existing (from old page)
  "doi", "10.22330/001c.147268",
    "sdg4, sdg5, sdg10", "Pollet 2025 — women in evo psych textbooks",
  "doi", "10.1371/journal.pone.0297075",
    "sdg4", "Linden 2024 — publication bias/sample size",
  "doi", "10.1080/03075079.2023.2284808",
    "sdg4", "Pollet 2024 — NSS binning mid-point",
  "doi", "10.1080/0309877X.2022.2060069",
    "sdg4", "Pollet 2022 — NSS subscale structure",
  "doi", "10.1007/s12144-022-03336-z",
    "sdg4", "Bilali\\u0107 2022 — intelligence/practice/academic performance",
  "doi", "10.1007/s40806-019-00192-2",
    "sdg4, sdg10", "Pollet 2019 — WEIRD sample diversity",
  "doi", "10.1016/j.bodyim.2024.101714",
    "sdg4, sdg10", "Pollet 2024 — sample generalisability Body Image",

  # Suggested additions to SDG 4
  "doi", "10.31234/osf.io/fdkj5",
    "sdg4", "Pollet 2026 preprint — UK university rankings",
  "title", "Optimising Cross-Institutional Comparisons",
    "sdg4", "Grugan 2026 preprint — NSS cross-institutional",
  "doi", "10.31234/osf.io/d4y7g",
    "sdg4, sdg10", "Pollet 2025 preprint — first-gen students",

  # ── SDG 5: Gender Equality ──────────────────────────────────────

  # Existing (from old page) — many already tagged above with sdg5
  "doi", "10.1111/gwao.70067",
    "sdg5", "Cook 2025 — women comedians professional image",
  # Pollet 2025 Human Ethol already tagged sdg4, sdg5, sdg10 above
  # Shiramizu 2025 already tagged sdg3, sdg5 above
  "doi", "10.1037/aca0000604",
    "sdg5", "Cook 2025 — acting gender role conformity",
  "doi", "10.1177/00187267221137996",
    "sdg5, sdg10", "Cook 2023 — women impression management stand-up",
  # Bainbridge 2022 already tagged sdg3, sdg5 above
  "doi", "10.1371/journal.pone.0266167",
    "sdg5", "Pollet 2022 — loneliness measurement gender equivalence",
  "doi", "10.1080/19419899.2021.1984982",
    "sdg5", "Lloyd 2021 — sexual self-esteem women meta-analysis",

  # ── SDG 10: Reduced Inequalities ────────────────────────────────

  # Most already tagged above with sdg10
  "doi", "10.1002/ijop.12834",
    "sdg10", "Metcalfe 2022 — autism/emotion recognition/context",

  # Suggested addition to SDG 10
  "title", "Emotion recognition from body movement and gesture",
    "sdg10", "Metcalfe 2019 — autism/emotion recognition children",

  # ── SDG 16: Peace, Justice and Strong Institutions ──────────────

  # Morina 2018 and 2016 already tagged sdg3, sdg16 above
  "title", "Political Extremism Predicts Belief in Conspiracy",
    "sdg16", "Van Prooijen 2015 — political extremism/conspiracies"
)


# ── Consolidate: merge rows for the same paper into one keyword set ──
# Some papers appear in multiple rows (tagged from different SDG sections).
# We need to merge all their sdg values.

consolidate_sdg <- function(sdg_map) {
  # Create a unique key for each paper (match_type + match_value)
  sdg_map |>
    mutate(paper_key = str_c(match_type, "||", match_value)) |>
    group_by(paper_key, match_type, match_value) |>
    summarise(
      sdg = str_split(str_c(sdg, collapse = ", "), ",\\s*") |>
        map(unique) |>
        map_chr(~ str_c(sort(.x), collapse = ", ")),
      note = first(note),
      .groups = "drop"
    ) |>
    select(-paper_key)
}

sdg_consolidated <- consolidate_sdg(sdg_map)


# ── Functions ─────────────────────────────────────────────────────

read_bib <- function(path) {
  readr::read_lines(path)
}

# Split bib file into individual entries (preserving inter-entry text)
split_entries <- function(lines) {
  # Find lines starting with @
  entry_starts <- which(str_detect(lines, "^@"))

  entries <- list()
  for (i in seq_along(entry_starts)) {
    start <- entry_starts[i]
    end <- if (i < length(entry_starts)) entry_starts[i + 1] - 1 else length(lines)
    entries[[i]] <- list(
      start = start,
      end   = end,
      text  = lines[start:end]
    )
  }
  entries
}

# Extract a field value from a bib entry's text lines
extract_field <- function(entry_text, field_name) {
  # Match field = {value} or field = {{value}} across lines
  joined <- str_c(entry_text, collapse = "\n")
  pattern <- str_c("(?i)", field_name, "\\s*=\\s*\\{+([^}]*)\\}+")
  match <- str_match(joined, pattern)
  if (!is.na(match[1, 2])) {
    str_trim(match[1, 2])
  } else {
    NA_character_
  }
}

# Check whether entry matches a row in the mapping table
entry_matches <- function(entry_text, match_type, match_value) {
  if (match_type == "doi") {
    doi_val <- extract_field(entry_text, "doi")
    if (is.na(doi_val)) return(FALSE)
    # Normalise: strip any https://doi.org/ prefix, compare case-insensitively
    doi_clean <- str_remove(doi_val, "^https?://doi\\.org/") |> str_to_lower()
    match_clean <- str_remove(match_value, "^https?://doi\\.org/") |> str_to_lower()
    return(str_detect(doi_clean, fixed(match_clean)))
  }

  if (match_type == "title") {
    title_val <- extract_field(entry_text, "title")
    if (is.na(title_val)) return(FALSE)
    return(str_detect(str_to_lower(title_val), fixed(str_to_lower(match_value))))
  }

  FALSE
}

# Add or update keywords field in a bib entry
add_keywords <- function(entry_text, new_keywords) {
  joined <- str_c(entry_text, collapse = "\n")

  # Check if keywords field already exists
  if (str_detect(joined, regex("keywords\\s*=", ignore_case = TRUE))) {
    # Update existing keywords — merge with new ones
    existing <- extract_field(entry_text, "keywords")
    if (!is.na(existing)) {
      all_kw <- c(
        str_split(existing, ",\\s*")[[1]],
        str_split(new_keywords, ",\\s*")[[1]]
      ) |>
        unique() |>
        sort()
      merged <- str_c(all_kw, collapse = ", ")
      # Replace in text
      entry_text <- str_replace(
        entry_text,
        regex("keywords\\s*=\\s*\\{[^}]*\\}", ignore_case = TRUE),
        str_c("keywords = {", merged, "}")
      )
    }
  } else {
    # Insert keywords before the closing brace
    # Find the last line with content before the closing }
    closing <- max(which(str_detect(entry_text, "^\\}")))
    if (!is.na(closing) && closing > 1) {
      # Ensure previous line has a trailing comma
      prev_line <- closing - 1
      if (!str_detect(entry_text[prev_line], ",\\s*$") &&
          !str_detect(entry_text[prev_line], "^\\s*$")) {
        entry_text[prev_line] <- str_c(entry_text[prev_line], ",")
      }
      # Insert keywords line before closing brace
      kw_line <- str_c("  keywords = {", new_keywords, "}")
      entry_text <- c(
        entry_text[1:(closing - 1)],
        kw_line,
        entry_text[closing:length(entry_text)]
      )
    }
  }
  entry_text
}


# ── Main ──────────────────────────────────────────────────────────

if (!file.exists(bib_path)) {
  cli::cli_abort("Cannot find {bib_path}. Run this script from the repo root.")
}

lines <- read_bib(bib_path)
entries <- split_entries(lines)

cat(str_c("Read ", length(entries), " entries from ", bib_path, "\n"))

matched   <- character(0)
unmatched <- character(0)

for (i in seq_len(nrow(sdg_consolidated))) {
  row <- sdg_consolidated[i, ]
  found <- FALSE

  for (j in seq_along(entries)) {
    if (entry_matches(entries[[j]]$text, row$match_type, row$match_value)) {
      entries[[j]]$text <- add_keywords(entries[[j]]$text, row$sdg)
      matched <- c(matched, row$note)
      found <- TRUE
      break
    }
  }

  if (!found) {
    unmatched <- c(unmatched, str_c(row$match_type, ": ", row$match_value,
                                     " (", row$note, ")"))
  }
}

cat(str_c("\nMatched:   ", length(matched), " / ", nrow(sdg_consolidated), "\n"))
if (length(unmatched) > 0) {
  cat("Unmatched:\n")
  walk(unmatched, ~ cat(str_c("  - ", .x, "\n")))
}

# Reassemble the file
new_lines <- character(0)
# Include any preamble before the first entry
if (entries[[1]]$start > 1) {
  new_lines <- lines[1:(entries[[1]]$start - 1)]
}

for (j in seq_along(entries)) {
  new_lines <- c(new_lines, entries[[j]]$text)
}

if (dry_run) {
  cat("\n[DRY RUN] No files modified. Preview of matched entries:\n")
  walk(matched, ~ cat(str_c("  ✓ ", .x, "\n")))
} else {
  if (backup) {
    backup_path <- str_c(bib_path, ".bak_sdg")
    file.copy(bib_path, backup_path, overwrite = TRUE)
    cat(str_c("Backup saved to: ", backup_path, "\n"))
  }
  readr::write_lines(new_lines, bib_path)
  cat(str_c("Updated ", bib_path, " with SDG keywords.\n"))
}

cat("\nDone.\n")
