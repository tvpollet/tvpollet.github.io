# DOI Checker Shiny App
# Place this app.R in a folder with your PDFs and run it
# Required packages: shiny, bslib, pdftools, rcrossref, stringr, DT
# I have built this with Claude.AI - no warranties... .
# See the disclaimer.

# install.packages(c("shiny", "bslib", "pdftools", "rcrossref", "stringr", "DT"))

library(shiny)
library(bslib)
library(pdftools)
library(rcrossref)
library(stringr)
library(DT)

# --- Helper functions ---

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || is.na(x[1])) y else x

extract_dois <- function(pdf_path) {
  tryCatch({
    text <- pdf_text(pdf_path) |> paste(collapse = " ")
    
    # Normalise whitespace: remove line breaks and collapse spaces
    # This rejoins DOIs that were split across lines
    text <- str_replace_all(text, "\\r?\\n", " ")
    text <- str_replace_all(text, "\\s+", " ")
    
    # Also try removing hyphens followed by spaces (soft hyphenation at line breaks)
    # e.g., "10.1007/s10508-008-\n9460-8" becomes "10.1007/s10508-008- 9460-8"
    # This pattern rejoins them: "10.1007/s10508-008-9460-8"
    text <- str_replace_all(text, "-\\s+(?=[0-9])", "-")
    
    doi_pattern <- "10\\.\\d{4,}/[^\\s\"<>]+"
    dois <- str_extract_all(text, doi_pattern)[[1]] |>
      str_remove_all("[.,;:)\\]]+$") |>
      unique()
    return(dois)
  }, error = function(e) {
    return(character(0))
  })
}

validate_doi <- function(doi) {
  tryCatch({
    result <- cr_works(dois = doi)
    if (is.null(result$data) || nrow(result$data) == 0) {
      return(list(valid = FALSE, doi = doi, title = NA, authors = NA, 
                  journal = NA, year = NA, error = "Not found in CrossRef"))
    }
    meta <- result$data
    list(
      valid = TRUE, doi = doi,
      title = meta$title[1] %||% NA,
      authors = paste(meta$author[[1]]$family, collapse = ", ") %||% NA,
      journal = meta$container.title[1] %||% NA,
      year = substr(meta$published.print[1] %||% meta$published.online[1] %||% 
                      meta$created[1] %||% NA, 1, 4),
      error = NA
    )
  }, error = function(e) {
    list(valid = FALSE, doi = doi, title = NA, authors = NA, 
         journal = NA, year = NA, error = e$message)
  })
}

# --- UI ---

ui <- page_sidebar(
  title = "PDF DOI Checker",
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#2c3e50",
    "navbar-bg" = "#2c3e50"
  ),
  
  sidebar = sidebar(
    width = 280,
    
    card(
      card_header(class = "bg-primary text-white", "Status"),
      card_body(verbatimTextOutput("status"))
    ),
    
    actionButton("scan", "Scan for PDFs", 
                 class = "btn-primary w-100 mb-2", 
                 icon = icon("folder-open")),
    
    actionButton("check", "Check All DOIs", 
                 class = "btn-success w-100 mb-3",
                 icon = icon("check-circle")),
    
    card(
      card_header(class = "bg-secondary text-white", "Export"),
      card_body(
        downloadButton("export_all", "Full Results", 
                       class = "btn-outline-primary w-100 mb-2"),
        downloadButton("export_errors", "Errors Only", 
                       class = "btn-outline-danger w-100")
      )
    ),
    
    hr(),
    checkboxInput("show_errors_only", "Show only errors", FALSE)
  ),
  
  navset_card_tab(
    nav_panel(
      title = "PDFs Found",
      icon = icon("file-pdf"),
      card_body(DTOutput("pdf_table"))
    ),
    nav_panel(
      title = "DOI Results", 
      icon = icon("link"),
      card_body(DTOutput("doi_table"))
    ),
    nav_panel(
      title = "Summary",
      icon = icon("chart-bar"),
      card_body(verbatimTextOutput("summary"))
    )
  ),
  
  # Footer
  tags$footer(
    class = "text-center text-muted py-3 mt-4",
    style = "border-top: 1px solid #dee2e6;",
    HTML('Built with Shiny | <a href="https://tvpollet.github.io/disclaimer/" target="_blank">Disclaimer</a>')
  )
)

# --- Server ---

server <- function(input, output, session) {
  
  rv <- reactiveValues(
    pdfs = NULL,
    results = NULL,
    status = "Ready.\nClick 'Scan for PDFs' to begin.",
    checking = FALSE
  )
  
  observeEvent(input$scan, {
    app_dir <- getwd()
    pdf_files <- list.files(app_dir, pattern = "\\.pdf$", 
                            ignore.case = TRUE, full.names = TRUE)
    
    rv$pdfs <- data.frame(
      filename = basename(pdf_files),
      path = pdf_files,
      stringsAsFactors = FALSE
    )
    rv$results <- NULL
    rv$status <- paste0("Found ", nrow(rv$pdfs), " PDF(s)\n\n", app_dir)
  })
  
  observeEvent(input$check, {
    req(rv$pdfs, nrow(rv$pdfs) > 0)
    
    rv$checking <- TRUE
    all_results <- list()
    n_pdfs <- nrow(rv$pdfs)
    
    withProgress(message = "Checking DOIs...", value = 0, {
      for (i in seq_len(n_pdfs)) {
        pdf_path <- rv$pdfs$path[i]
        pdf_name <- rv$pdfs$filename[i]
        
        incProgress(1/n_pdfs, detail = pdf_name)
        
        dois <- extract_dois(pdf_path)
        
        if (length(dois) == 0) {
          all_results[[i]] <- data.frame(
            pdf = pdf_name, doi = NA, valid = NA,
            title = NA, authors = NA, journal = NA, year = NA,
            error = "No DOIs found in PDF", stringsAsFactors = FALSE
          )
        } else {
          pdf_results <- lapply(dois, function(d) {
            Sys.sleep(0.3)
            res <- validate_doi(d)
            data.frame(
              pdf = pdf_name, doi = res$doi, valid = res$valid,
              title = res$title, authors = res$authors,
              journal = res$journal, year = res$year,
              error = res$error, stringsAsFactors = FALSE
            )
          })
          all_results[[i]] <- do.call(rbind, pdf_results)
        }
      }
    })
    
    rv$results <- do.call(rbind, all_results)
    rv$checking <- FALSE
    
    n_errors <- sum(!rv$results$valid | is.na(rv$results$valid), na.rm = TRUE)
    rv$status <- paste0("Complete!\n\n", nrow(rv$results), " DOIs checked\n", 
                        n_errors, " error(s) found")
  })
  
  output$status <- renderText({ rv$status })
  
  output$pdf_table <- renderDT({
    req(rv$pdfs)
    datatable(rv$pdfs[, "filename", drop = FALSE], 
              colnames = "PDF Files",
              options = list(pageLength = 15),
              class = "table-striped table-hover")
  })
  
  output$doi_table <- renderDT({
    req(rv$results)
    
    df <- rv$results
    if (input$show_errors_only) {
      df <- df[!df$valid | is.na(df$valid), ]
    }
    
    datatable(df, 
              options = list(pageLength = 20, scrollX = TRUE),
              rownames = FALSE,
              class = "table-striped table-hover") |>
      formatStyle("valid", 
                  backgroundColor = styleEqual(c(TRUE, FALSE), 
                                               c("#d4edda", "#f8d7da")))
  })
  
  output$summary <- renderText({
    req(rv$results)
    
    df <- rv$results
    n_pdfs <- length(unique(df$pdf))
    n_dois <- sum(!is.na(df$doi))
    n_valid <- sum(df$valid, na.rm = TRUE)
    n_invalid <- sum(!df$valid, na.rm = TRUE)
    n_no_dois <- sum(is.na(df$doi))
    
    problem_pdfs <- unique(df$pdf[!df$valid | is.na(df$valid)])
    
    paste0(
      "=== SUMMARY ===\n\n",
      "PDFs scanned: ", n_pdfs, "\n",
      "Total DOIs found: ", n_dois, "\n",
      "Valid DOIs: ", n_valid, "\n",
      "Invalid/Not found: ", n_invalid, "\n",
      "PDFs with no DOIs: ", n_no_dois, "\n\n",
      "=== PDFs WITH ISSUES ===\n\n",
      paste(problem_pdfs, collapse = "\n")
    )
  })
  
  output$export_all <- downloadHandler(
    filename = function() paste0("doi_check_full_", Sys.Date(), ".csv"),
    content = function(file) write.csv(rv$results, file, row.names = FALSE)
  )
  
  output$export_errors <- downloadHandler(
    filename = function() paste0("doi_check_errors_", Sys.Date(), ".csv"),
    content = function(file) {
      errors <- rv$results[!rv$results$valid | is.na(rv$results$valid), ]
      write.csv(errors, file, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)