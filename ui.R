library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage("League History",
  
  tabPanel(title = 'Overview',
           h1('Application Overview'),
           p('Each tab in this app is explained below:'),
           br(),
           p("The ", strong("Records"), " tab allows you to see the best and worst
             individual weeks in this league's history. You can filter by playoff weeks
             vs. non-playoff weeks, best vs. worst weeks, and a single stat 
             category vs. all 12 at once. When looking at all 12 stat categories
             at once, the individual weeks are ranked by how they would have done head-to-head
             against all the other weeks in the dataset."),
           br(),
           p("The ", strong("Standings"), " tab allows you to look at three types of 
             current or historical standings: actual wins, schedule-adjusted wins,
             and overall stats score (sometimes referred to as a Borda count). You
             can select which season you'd like to look at, and then filter in or out
             the teams you want to compare. To plots show the trajectory of each team's
             placement in the selected type of standings.")
           ),
  tabPanel(title = 'Records',
           
             # selectInput('records_timeperiod',
             #             label = 'By season or week:',
             #             choices = c('Season', 'Week'), 
             #             selected = 'Season'),
             selectInput('records_stat',
                         label = 'Filter by stat category:',
                         choices = c('All', 'HR', 'R', 'RBI', 'SB',
                                     'OBP', 'SLG', 'K', 'QS', 'W', 
                                     'SV', 'ERA', 'WHIP'),
                         selected = 'All'),
             selectInput('records_best',
                         label = 'Show best or worst:',
                         choices = c('Best', 'Worst'),
                         selected = 'Best'),
             selectInput('records_playoffs',
                         label = 'Playoffs or regular season:',
                         choices = c('Playoffs', 'Regular season'),
                         selected = 'Regular season'),
             sliderInput('records_showtopnum',
                         label = 'Show the top how many:',
                         min = 5, max = 20, value = 5, step = 1),
             
             tableOutput('recordstable')
  ),
  
  tabPanel(title = 'Standings',
           selectInput('standings_season',
                       label = 'Select season:',
                       choices = sort(unique(dat$Season)),
                       selected = max(dat$Season)),
           selectInput('standings_week',
                       label = 'Select week:',
                       choices = c('Regular', 1:22),
                       selected = 'Regular'),
           selectInput('standings_type',
                       label = 'Select type of standings:',
                       choices = c('Actual', 'Schedule-adjusted', 'Rotisserie'),
                       selected = 'Actual'),
           
           tableOutput('standingstable1'),
           tableOutput('standingstable2'),
           plotOutput('standingsplot'))
)
)
