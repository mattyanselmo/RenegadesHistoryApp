shinyServer(function(input, output) {
  
  output$recordstable1 <- renderTable({
    
    records.func(dat = dat, 
                 weekly = T, 
                 season = input$records_seasonw,
                 statcat = input$records_statw,
                 playoffs = ifelse(input$records_playoffsw == 'Playoffs', T, F),
                 best = ifelse(input$records_bestw == 'Best', T, F),
                 numshow = input$records_showtopnumw)
  }, digits = 3, rownames = T)
  
  output$recordstable2 <- renderTable({
    
    records.func(dat = dat, 
                 weekly = F, 
                 season = input$records_seasons,
                 statcat = input$records_stats,
                 playoffs = ifelse(input$records_playoffss == 'Playoffs', T, F),
                 best = ifelse(input$records_bests == 'Best', T, F),
                 numshow = input$records_showtopnums)
  }, digits = 3, rownames = T)
  
  output$recordstable3 <- renderTable({
    
    records.func(dat = dat,
                 franchisefilter = input$records_franchise,
                 weekly = ifelse(input$records_timeperiodf == 'Week', T, F), 
                 season = input$records_seasonf,
                 statcat = ifelse(input$records_statf == 'All' & input$records_timeperiodf == 'Season',
                                  'Luck',
                                  input$records_statf),
                 playoffs = ifelse(input$records_playoffsf == 'Playoffs', T, F),
                 best = ifelse(input$records_bestf == 'Best', T, F),
                 numshow = input$records_showtopnumf)
  }, digits = 3, rownames = T)
  
  output$recordstable4 <- renderTable({
    
    records.func(dat = dat,
                 ownerfilter = input$records_owner,
                 weekly = ifelse(input$records_timeperiodo == 'Week', T, F), 
                 season = input$records_seasono,
                 statcat = ifelse(input$records_stato == 'All' & input$records_timeperiodo == 'Season',
                                  'Luck',
                                  input$records_stato),
                 playoffs = ifelse(input$records_playoffso == 'Playoffs', T, F),
                 best = ifelse(input$records_besto == 'Best', T, F),
                 numshow = input$records_showtopnumo)
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