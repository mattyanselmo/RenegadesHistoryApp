library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Renegades League History"),
  tabPanel(title = 'Records',

    sidebarLayout(
    sidebarPanel(
      
      selectInput('records_timeperiod',
                  label = 'By season or week:',
                  choices = c('Season', 'Week'), 
                  selected = 'Season'),
      selectInput('records_stat',
                  label = 'Filter by stat category:',
                  choices = c('All', 'HR', 'R', 'RBI', 'SB',
                              'OBP', 'SLG', 'K', 'QS', 'W', 
                              'SV', 'ERA', 'WHIP'),
                  selected = 'All'),
      sliderInput('records_showtopnum',
                  label = 'Show the top how many:',
                  min = 5, max = 20, value = 5, step = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput('recordstable')
    )
    )
  )
))