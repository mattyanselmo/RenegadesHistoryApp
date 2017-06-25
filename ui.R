library(shiny)
library(shinyjs)

shinyUI(
  navbarPage('Renegades History',
  theme = 'flatly.css',
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
             and overall stats score (sometimes referred to as a Rotisserie score). You
             will be able to select which season you'd like to look at, and then filter in or out
             the teams/owners that you want to compare. The plots show the trajectory of each team's
             placement in the selected type of standings.")
              ),                      
  
  tabPanel(title = 'Records',
           tabsetPanel(
             
             tabPanel(title = 'General',
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     selectInput('records_timeperiod',
                                                 label = 'By season or week:',
                                                 choices = c('Season', 'Week'),
                                                 selected = 'Week'),
                                     numericInput('records_showtopnum',
                                                  label = 'Show the top how many:',
                                                  min = 5, max = 50, value = 10, step = 1),
                                     checkboxGroupInput('records_season',
                                                        label = 'Explore weeks within which season:',
                                                        choices = sort(unique(dat$Season)),
                                                        selected = sort(unique(dat$Season))),
                                     selectInput('records_stat',
                                                 label = 'Filter by stat category:',
                                                 choices = c('All', 'HR', 'R', 'RBI', 'SB',
                                                             'OBP', 'SLG', 'K', 'QS', 'W',
                                                             'SV', 'ERA', 'WHIP', 'Luck'),
                                                 selected = 'All'),
                                     selectInput('records_best',
                                                 label = 'Show best or worst:',
                                                 choices = c('Best', 'Worst'),
                                                 selected = 'Best'),
                                     selectInput('records_playoffs',
                                                 label = 'Playoffs or regular season:',
                                                 choices = c('Playoffs', 'Regular season'),
                                                 selected = 'Regular season')),
                        
                        mainPanel(
                          tableOutput('recordstable1'))
                      )),
             
             tabPanel(title = 'By Franchise',
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     selectInput('records_franchise',
                                                 label = 'Select franchise:',
                                                 choices = sort(unique(dat$CurrentName)),
                                                 selected = sort(unique(dat$CurrentName))[1]),
                                     selectInput('records_timeperiodf',
                                                 label = 'By season or week:',
                                                 choices = c('Season', 'Week'),
                                                 selected = 'Week'),
                                     numericInput('records_showtopnumf',
                                                  label = 'Show the top how many:',
                                                  min = 5, max = 50, value = 10, step = 1),
                                     checkboxGroupInput('records_seasonf',
                                                        label = 'Explore weeks within which season:',
                                                        choices = sort(unique(dat$Season)),
                                                        selected = sort(unique(dat$Season))),
                                     selectInput('records_statf',
                                                 label = 'Filter by stat category:',
                                                 choices = c('All', 'HR', 'R', 'RBI', 'SB',
                                                             'OBP', 'SLG', 'K', 'QS', 'W',
                                                             'SV', 'ERA', 'WHIP', 'Luck'),
                                                 selected = 'All'),
                                     selectInput('records_bestf',
                                                 label = 'Show best or worst:',
                                                 choices = c('Best', 'Worst'),
                                                 selected = 'Best'),
                                     selectInput('records_playoffsf',
                                                 label = 'Playoffs or regular season:',
                                                 choices = c('Playoffs', 'Regular season'),
                                                 selected = 'Regular season')),
                        
                        mainPanel(
                          tableOutput('recordstable2'))
                      )),
             
             tabPanel(title = 'By Owner',
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     selectInput('records_owner',
                                                 label = 'Select owner:',
                                                 choices = sort(unique(dat$TeamOwner)),
                                                 selected = sort(unique(dat$TeamOwner))[1]),
                                     selectInput('records_timeperiodo',
                                                 label = 'By season or week:',
                                                 choices = c('Season', 'Week'),
                                                 selected = 'Week'),
                                     numericInput('records_showtopnumo',
                                                  label = 'Show the top how many:',
                                                  min = 5, max = 50, value = 10, step = 1),
                                     checkboxGroupInput('records_seasono',
                                                        label = 'Explore weeks within which season:',
                                                        choices = sort(unique(dat$Season)),
                                                        selected = sort(unique(dat$Season))),
                                     selectInput('records_stato',
                                                 label = 'Filter by stat category:',
                                                 choices = c('All', 'HR', 'R', 'RBI', 'SB',
                                                             'OBP', 'SLG', 'K', 'QS', 'W',
                                                             'SV', 'ERA', 'WHIP', 'Luck'),
                                                 selected = 'All'),
                                     selectInput('records_besto',
                                                 label = 'Show best or worst:',
                                                 choices = c('Best', 'Worst'),
                                                 selected = 'Best'),
                                     selectInput('records_playoffso',
                                                 label = 'Playoffs or regular season:',
                                                 choices = c('Playoffs', 'Regular season'),
                                                 selected = 'Regular season')),
                        
                        mainPanel(
                          tableOutput('recordstable3'))
                      )))),

              tabPanel(title = 'Standings',
                       sidebarLayout(
                         sidebarPanel(
                           
                           selectInput('standings_season',
                                       label = 'Select season:',
                                       choices = sort(unique(dat$Season)),
                                       selected = max(dat$Season)),
                           selectInput('standings_week',
                                       label = 'Select week:',
                                       choices = c('Regular season', 1:22),
                                       selected = 'Regular season'),
                           selectInput('standings_type',
                                       label = 'Select type of standings:',
                                       choices = c('Actual', 'Schedule-adjusted', 'Rotisserie'),
                                       selected = 'Actual')
                         ),
                         
                         mainPanel(
                           tags$style(type="text/css",
                                      ".shiny-output-error { visibility: hidden; }",
                                      ".shiny-output-error:before { visibility: hidden; }"
                           ),
                           fluidRow(
                             splitLayout(cellWidths = c("50%", "50%"), tableOutput('standingstable1'), tableOutput('standingstable2'))),
                           plotOutput('standingsplot')))
              )
            )
)