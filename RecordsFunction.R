# dat <- read.csv('RenegadesHistoryFormatted.csv')
# weekly = F
# Season = c(2016, 2017)
# statcat = 'HR'
# playoffs = F
# best = T
# numshow = 10
# ownerfilter = 'All'
# franchisefilter = 'All'


records.func <- function(dat = dat, 
                         weekly = T, 
                         season = c(2011:2017), 
                         statcat = 'All',
                         playoffs = F,
                         best = T,
                         numshow = 5,
                         ownerfilter = 'All',
                         franchisefilter = 'All'){
  
  dat <- dat %>% filter(AllStar == 0) %>%
    mutate(Luck = Wins - xWins)
  
  dat <- dat %>% filter(ifelse(rep(ownerfilter, nrow(dat)) == 'All',
                               TRUE, 
                               TeamOwner == ownerfilter))
  dat <- dat %>% filter(ifelse(rep(franchisefilter, nrow(dat)) == 'All',
                               TRUE, 
                               CurrentName == franchisefilter))
 
    if(!weekly){
    dat <- dat %>%
      filter(Playoffs == as.numeric(playoffs)) %>%
      group_by(Season, Team) %>%
      summarize(Owner = TeamOwner[1],
                R = sum(R),
                HR = sum(HR),
                RBI = sum(RBI),
                SB = sum(SB),
                OBP = mean(OBP),
                SLG = mean(SLG),
                K = sum(K),
                QS = sum(QS),
                W = sum(W), 
                SV = sum(SV),
                ERA = mean(ERA),
                WHIP = mean(WHIP),
                Luck = sum(Luck)) %>%
      ungroup()
    
    return(dat %>% 
             select_(.dots = c('Team', 'Season', 'Owner', statcat)) %>%
             arrange_(ifelse((statcat %in% c('WHIP', 'ERA') & best) | (!(statcat %in% c('WHIP', 'ERA')) & !best), statcat, paste0('desc(', statcat, ')'))) %>%
             filter(Season %in% season) %>%
             filter(row_number() <= numshow))
    
  } else{ 
    if(statcat == 'All'){
      if(playoffs){
        ranks <- data.frame(Team = dat$Team[dat$Playoffs == 1 & dat$Season %in% season], 
                            Season = dat$Season[dat$Playoffs == 1 & dat$Season %in% season], 
                            Week = dat$Week[dat$Playoffs == 1 & dat$Season %in% season], 
                            sapply(dat %>% filter(Playoffs == 1 & Season %in% season) %>% 
                                     select(R:SV), rank), 
                            sapply(dat %>% filter(dat$Playoffs == 1) %>% 
                                     select(ERA, WHIP), function(x) nrow(dat) + 1 - rank(x)))
        ranks[['Score']] <- apply(ranks %>% select(R:WHIP), 1, sum)
        return(ranks %>% 
                 arrange_(ifelse(best, 'desc(Score)', 'Score')) %>%
                 filter(row_number() <= numshow) %>%
                 select(Team, Season, Week, Score) %>% 
                 left_join(dat %>% 
                             select(Team, Season, Week, Owner = TeamOwner, R:WHIP), 
                           c('Team', 'Season', 'Week')) %>%
                 mutate(WinPct = Score / (nrow(dat[dat$Playoffs == as.numeric(playoffs) & dat$Season %in% season,]) * 12)) %>%
                 select(-Score))  
      }else{
        ranks <- data.frame(Team = dat$Team[dat$Playoffs == 0 & dat$Season %in% season], 
                            Season = dat$Season[dat$Playoffs == 0 & dat$Season %in% season], 
                            Week = dat$Week[dat$Playoffs == 0 & dat$Season %in% season], 
                            sapply(dat %>% filter(Playoffs == 0 & Season %in% season) %>% 
                                     select(R:SV), rank), 
                            sapply(dat %>% filter(Playoffs == 0 & Season %in% season) %>% 
                                     select(ERA, WHIP), function(x) nrow(dat[dat$Playoffs == as.numeric(playoffs) & dat$Season %in% season,]) + 1 - rank(x)))
        ranks[['Score']] <- apply(ranks %>% select(R:WHIP), 1, sum)
        return(ranks %>% 
                 arrange_(ifelse(best, 'desc(Score)', 'Score')) %>%
                 filter(row_number() <= numshow) %>%
                 select(Team, Season, Week, Score) %>% 
                 left_join(dat %>% 
                             select(Team, Season, Week, Owner = TeamOwner, R:WHIP), 
                           c('Team', 'Season', 'Week')) %>%
                 mutate(WinPct = Score / (nrow(dat[dat$Playoffs == as.numeric(playoffs) & dat$Season %in% season,]) * 12)) %>%
                 select(-Score))
      }
      
    } else{
      if(playoffs){
        return(dat %>% 
                 filter(Playoffs == 1 & Season %in% season) %>%
                 select_(.dots = c('Team', 'Season', 'Week', statcat)) %>%
                 arrange_(ifelse((statcat %in% c('WHIP', 'ERA') & best) | (!(statcat %in% c('WHIP', 'ERA')) & !best), statcat, paste0('desc(', statcat, ')'))) %>%
                 filter(row_number() <= numshow))
      }else{
        return(dat %>% 
                 filter(Playoffs == 0 & Season %in% season) %>%
                 select_(.dots = c('Team', 'Season', 'Week', statcat)) %>%
                 arrange_(ifelse((statcat %in% c('WHIP', 'ERA') & best) | (!(statcat %in% c('WHIP', 'ERA')) & !best), statcat, paste0('desc(', statcat, ')'))) %>%
                 filter(row_number() <= numshow))
      }
    }
  }
}

# records.func(dat = dat,
#              weekly = T,
#              Season = 2016,
#              statcat = 'R',
#              playoffs = F,
#              best = T,
#              numshow = 5)