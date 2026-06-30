library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggthemes)
library(wesanderson)
library(plotly)  # For interactive plot

ui <- fluidPage(
  titlePanel("Elo Rating Simulation"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("k_factor", "K-factor (rating adjustment sensitivity):",
                  min = 5, max = 50, value = 20),
      numericInput("ratingA", "Player A Starting Elo (1000 - 2000):",
                   min = 1000, max = 2000, value = 1500),
      numericInput("ratingB", "Player B Starting Elo (1000 - 2000):",
                   min = 1000, max = 2000, value = 1500),
      numericInput("sim_games", "Number of Games to Simulate (max. 10,000):", 
                   value = 100, min = 10, max = 10000),
      sliderInput("win_prob", "Probability Player A Wins (%):",
                  min = 0, max = 100, value = 50,
                  post = "%"),
      numericInput("seed", "Random Seed (for reproducibility):",
                   value = 123),
      actionButton("simulate", "Run Simulation")
    ),
    mainPanel(
      plotlyOutput("rating_plot"),  # Changed to plotlyOutput for interactivity
      hr(),
      h4("Current Ratings:"),
      tableOutput("rating_table"),
      h4("Last Game Result:"),
      textOutput("last_result")
    )
  )
)

server <- function(input, output, session) {
  ratings <- reactiveValues(
    playerA = 1500,
    playerB = 1500,
    history = data.frame(Game = integer(), 
                         PlayerA = numeric(), 
                         PlayerB = numeric()),
    last_result = NULL
  )
  
  # Custom Elo calculation function
  calculate_elo <- function(winner_rating, loser_rating, k_factor) {
    expected_win <- 1 / (1 + 10^((loser_rating - winner_rating)/400))
    change <- k_factor * (1 - expected_win)
    list(winner = winner_rating + change,
         loser = loser_rating - change)
  }
  
  observeEvent(input$simulate, {
    # Set seed for reproducibility
    set.seed(input$seed)
    
    # Reset ratings with user-specified starting values
    ratings$playerA <- input$ratingA
    ratings$playerB <- input$ratingB
    ratings$history <- data.frame(Game = integer(), 
                                  PlayerA = numeric(), 
                                  PlayerB = numeric())
    ratings$last_result <- NULL
    
    # Record initial ratings
    ratings$history <- rbind(ratings$history, 
                             data.frame(Game = 0, 
                                        PlayerA = ratings$playerA, 
                                        PlayerB = ratings$playerB))
    
    # Simulate games
    for (i in 1:input$sim_games) {
      # Determine outcome based on win probability
      outcome <- ifelse(runif(1) < (input$win_prob/100), 1, 0)
      
      # Calculate new ratings
      if (outcome == 1) {  # Player A wins
        new_ratings <- calculate_elo(ratings$playerA, ratings$playerB, input$k_factor)
        ratings$playerA <- new_ratings$winner
        ratings$playerB <- new_ratings$loser
        last_res <- "Player A won"
      } else {  # Player B wins
        new_ratings <- calculate_elo(ratings$playerB, ratings$playerA, input$k_factor)
        ratings$playerB <- new_ratings$winner
        ratings$playerA <- new_ratings$loser
        last_res <- "Player B won"
      }
      
      # Record history
      ratings$history <- rbind(ratings$history, 
                               data.frame(Game = i, 
                                          PlayerA = ratings$playerA, 
                                          PlayerB = ratings$playerB))
      
      # Store last result for display
      if (i == input$sim_games) {
        ratings$last_result <- last_res
      }
    }
  })
  
  output$rating_plot <- renderPlotly({
    req(nrow(ratings$history) > 1)
    
    plot_data <- ratings$history %>%
      pivot_longer(cols = c(PlayerA, PlayerB), 
                   names_to = "Player", 
                   values_to = "Rating") %>%
      mutate(Player = factor(Player, levels = c("PlayerA", "PlayerB"),
                             labels = c("Player A", "Player B")))
    
    colors <- wes_palette("GrandBudapest1")[c(1,5)]
    
    p <- ggplot(plot_data, aes(x = Game, y = Rating, color = Player, 
                               text = paste("Game:", Game, "<br>",
                                            "Player:", Player, "<br>",
                                            "Rating:", round(Rating, 1)))) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 1, alpha = 0.6) +  # Add points for better clicking
      scale_color_manual(values = colors) +
      labs(title = "Elo Rating Progression",
           y = "Rating",
           x = "Game Number",
           color = "Player") +
      theme_tufte(base_size = 14) +
      theme(legend.position = "bottom",
            plot.title = element_text(hjust = 0.5),
            panel.grid.major.y = element_line(color = "gray90", linewidth = 0.3))
    
    ggplotly(p, tooltip = "text") %>%  # Convert to interactive plot
      layout(hoverlabel = list(bgcolor = "white")) %>%
      config(displayModeBar = FALSE)  # Hide plotly mode bar
  })
  
  
  output$rating_table <- renderTable({
    req(nrow(ratings$history) > 0)
    data.frame(
      Player = c("Player A", "Player B"),
      Rating = c(round(ratings$playerA, 1), round(ratings$playerB, 1))
    )
  })
  
  output$last_result <- renderText({
    req(ratings$last_result)
    ratings$last_result
  })
}

shinyApp(ui, server)