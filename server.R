shinyServer(function(input, output) {
  
  output$recordstable <- renderTable({
    
    records.func(dat = dat, 
                 weekly = T, 
                 statcat = input$records_stat,
                 playoffs = ifelse(input$records_playoffs == 'Playoffs', T, F),
                 best = ifelse(input$records_best == 'Best', T, F),
                 numshow = input$records_showtopnum)
  }, digits = 3)
})