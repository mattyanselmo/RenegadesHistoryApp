standings.func <- function(dat = dat,
                           season = 2017,
                           week = 'Regular season',
                           type = 'Actual',
                           cumulative = T){
  
  func.data <- dat %>%
    filter(Season == season)
  
  
  if(week != 'Regular season'){
    func.data <- func.data %>%
      filter(Week == week)
    
    if(cumulative){
      return.dat <- func.data %>% select_(.dots = c('Team', 
                                                    ifelse(type == 'Actual', 'Wins.cum', 
                                                           ifelse(type == 'Schedule-adjusted', 'xWins.cum', 'Borda.cum'))))
      names(return.dat) <- c('Team', 'CumulativeWins')
      return(return.dat %>% arrange(desc(CumulativeWins)))
    } else{
      return.dat <- func.data %>% select_(.dots = c('Team', 
                                                    ifelse(type == 'Actual', 'Wins', 
                                                           ifelse(type == 'Schedule-adjusted', 'xWins', 'BordaWins'))))
      names(return.dat) <- c('Team', 'Wins')
      
      return(return.dat %>% arrange(desc(Wins)))
    }
  } else{
    func.data <- func.data %>%
      filter(Playoffs == 0)
    if(type == 'Actual'){
      ggplot(func.data,
             aes(Week, Wins.cum, color = Team)) +
        geom_line(size = 1.5) + 
        scale_color_manual(values = colorRampPalette(c('black', 'blue', 'green', 'yellow', 'orange', 'red', 'purple'))(12)) +
        ylab('Cumulative Actual Wins')
    }
    
    else if(type == 'Schedule-adjusted'){
      ggplot(func.data,
             aes(Week, xWins.cum, color = Team)) +
        geom_line(size = 1.5) + 
        scale_color_manual(values = colorRampPalette(c('black', 'blue', 'green', 'yellow', 'orange', 'red', 'purple'))(12)) +
        ylab('Cumulative Schedule Adjusted Wins')
    }
    
    else {
      ggplot(func.data,
             aes(Week, Borda.cum, color = Team)) +
        geom_line(size = 1.5) + 
        scale_color_manual(values = colorRampPalette(c('black', 'blue', 'green', 'yellow', 'orange', 'red', 'purple'))(12)) +
        ylab('Cumulative Rotisserie Score')
    }
  }
  
}
