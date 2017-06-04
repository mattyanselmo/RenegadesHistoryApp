shinyServer(function(input, output) {
  
  output$recordstable <- renderTable({
    
    records.func(dat = dat, 
                 weekly = ifelse(input$records_timeperiod == 'Week', T, F), 
                 season = input$records_season,
                 statcat = ifelse(input$records_stat == 'All' & input$records_timeperiod == 'Season',
                                  'Luck',
                                  input$records_stat),
                 playoffs = ifelse(input$records_playoffs == 'Playoffs', T, F),
                 best = ifelse(input$records_best == 'Best', T, F),
                 numshow = input$records_showtopnum)
  }, digits = 3, rownames = T)
  
  output$standingstable1 <- renderTable({
    
    standings.func(dat = dat, 
                 season = input$standings_season, 
                 week = input$standings_week,
                 type = input$standings_type,
                 cumulative = F)
  }, digits = 3, rownames = T)
  
  output$standingstable2 <- renderTable({
    
    standings.func(dat = dat, 
                   season = input$standings_season, 
                   week = input$standings_week,
                   type = input$standings_type,
                   cumulative = T)
  }, digits = 3, rownames = T)
  
  output$standingsplot <- renderPlot({
    standings.func(dat = dat, 
                   season = input$standings_season, 
                   week = input$standings_week,
                   type = input$standings_type,
                   cumulative = T)
  })
})