records.func <- function(dat = dat, 
                         weekly = T, 
                         season = F, 
                         statcat = 'All',
                         playoffs = F,
                         best = T,
                         numshow = 5){
  
  dat <- dat %>% filter(AllStar == 0)
  
  if(!weekly){
    dat <- dat %>%
      group_by(Season, Team) %>%
      summarize(Poop = 1)
  } else{ 
    if(statcat == 'All'){
      if(playoffs){
        ranks <- data.frame(Team = dat$Team[dat$Playoffs == 1], 
                            Season = dat$Season[dat$Playoffs == 1], 
                            Week = dat$Week[dat$Playoffs == 1], 
                            sapply(dat %>% filter(dat$Playoffs == 1) %>% 
                                     select(R:SV), rank), 
                            sapply(dat %>% filter(dat$Playoffs == 1) %>% 
                                     select(ERA, WHIP), function(x) nrow(dat) + 1 - rank(x)))
        ranks[['Score']] <- apply(ranks %>% select(R:WHIP), 1, sum)
        return(ranks %>% 
                 arrange_(ifelse(best, 'desc(Score)', 'Score')) %>%
                 filter(row_number() <= numshow) %>%
                 select(Team, Season, Week, Score) %>% 
                 left_join(dat %>% 
                             select(Team, Season, Week, TeamOwner, R:WHIP), 
                           c('Team', 'Season', 'Week')) %>%
                 mutate(WinPct = Score / (nrow(dat) * 12)) %>%
                 select(-Score))  
      }else{
        ranks <- data.frame(Team = dat$Team[dat$Playoffs == 0], 
                            Season = dat$Season[dat$Playoffs == 0], 
                            Week = dat$Week[dat$Playoffs == 0], 
                            sapply(dat %>% filter(dat$Playoffs == 0) %>% 
                                     select(R:SV), rank), 
                            sapply(dat %>% filter(dat$Playoffs == 0) %>% 
                                     select(ERA, WHIP), function(x) nrow(dat) + 1 - rank(x)))
        ranks[['Score']] <- apply(ranks %>% select(R:WHIP), 1, sum)
        return(ranks %>% 
                 arrange_(ifelse(best, 'desc(Score)', 'Score')) %>%
                 filter(row_number() <= numshow) %>%
                 select(Team, Season, Week, Score) %>% 
                 left_join(dat %>% 
                             select(Team, Season, Week, TeamOwner, R:WHIP), 
                           c('Team', 'Season', 'Week')) %>%
                 mutate(WinPct = Score / (nrow(dat) * 12)) %>%
                 select(-Score))
      }
      
    } else{
      if(playoffs){
        return(dat %>% 
                 filter(dat$Playoffs == 1) %>%
                 select_(.dots = c('Team', 'Season', 'Week', statcat)) %>%
                 arrange_(ifelse((statcat %in% c('WHIP', 'ERA') & best) | (!(statcat %in% c('WHIP', 'ERA')) & !best), statcat, paste0('desc(', statcat, ')'))) %>%
                 filter(row_number() <= numshow))
      }else{
        return(dat %>% 
                 filter(dat$Playoffs == 0) %>%
                 select_(.dots = c('Team', 'Season', 'Week', statcat)) %>%
                 arrange_(ifelse((statcat %in% c('WHIP', 'ERA') & best) | (!(statcat %in% c('WHIP', 'ERA')) & !best), statcat, paste0('desc(', statcat, ')'))) %>%
                 filter(row_number() <= numshow))
      }
    }
  }
}

# records.func(data = dat, 
#              weekly = T, 
#              statcat = 'All',
#              playoffs = F,
#              best = T,
#              numshow = 5)