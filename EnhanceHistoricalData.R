# if(file.exists('C:/Users/Matthias.Kullowatz')){
#   setwd("C:/Users/Matthias.Kullowatz/Google Drive/Baseball Projects/Fantasy Baseball/RenegadesHistoryApp")
# } else{
#   setwd("C:/Users/Matthias/Google Drive/Baseball Projects/Fantasy Baseball/RenegadesHistoryApp")
# }

dat <- read.csv('weeklyscoreboard.csv')
# dat <- read.csv('RenegadesHistory.csv')
teammap <- read.csv('TeamMapping.csv')

library(dplyr)

dat <- dat %>%
  group_by(Season, Week) %>%
  mutate(Matchup = c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6)) %>%
  ungroup()

allstar <- read.csv('AllStarWeeks.csv')

dat <- dat %>%
  left_join(allstar %>% mutate(AllStar = 1)) %>%
  mutate(Team = gsub('\\#[0-9]+ ', '', Team),
         Playoffs = ifelse(Week > 20 | (Season == 2013 & Week == 20), 1, 0),
         AllStar = ifelse(is.na(AllStar), 0, 1)) %>%
  left_join(teammap %>% select(-Season), by = c('Team'))

## Assess SOS luck ####
standings <- data.frame()
for(j in sort(unique(dat$Season))){
  for(i in 1:max(dat$Week[dat$Season == j])){
    standings <- rbind(standings, data.frame(Team = (dat %>% filter(Season == j, Week == i))$Team,
                                             Season = j,
                                             Week = i,
                                             xWins = (10*apply(apply(filter(dat, Season == j, Week == i) %>% select(R:SV), 2, rank) - 1, 1, mean) +
                                                        2*apply(12 - apply(filter(dat, Season == j, Week == i) %>% select(WHIP, ERA), 2, rank), 1, mean))/11,
                                             Wins = 0))
  }
}

# Record actual wins
for(i in seq(1, dim(dat)[1], 2)){
  standings$Wins[i] <- sum(dat[i, 5:14] > dat[i+1, 5:14]) + 
    0.5 * sum(dat[i, 5:14] == dat[i+1, 5:14]) + 
    sum(dat[i, 15:16] < dat[i+1, 15:16])
  standings$Wins[i+1] <- 12 - standings$Wins[i]
}

standings <- standings %>%
  group_by(Season, Team) %>%
  arrange(Week) %>%
  mutate(xWins.cum = cumsum(xWins),
         Wins.cum = cumsum(Wins))

# Records borda within week
standings$BordaWins <- standings$xWins*11 + 12

# Records cumulative borda
cumstats <- dat %>%
  group_by(Season, Team) %>%
  arrange(Week) %>%
  mutate_at(.vars = vars(c(R:WHIP)), .funs = funs(cumsum)) %>%
  mutate(OBP = OBP/Week,
         SLG = SLG/Week,
         ERA = ERA/Week,
         WHIP = WHIP/Week) %>%
  select(Season, Week, Team, R:WHIP) %>%
  ungroup() %>%
  group_by(Season, Week) %>%
  mutate(Borda.cum = rank(R) + rank(HR) + rank(RBI) + rank(SB) +
           rank(OBP) + rank(SLG) + rank(K) + rank(QS) +
           rank(W) + rank(SV) + 26 - rank(ERA) - rank(WHIP))

standings <- standings %>%
  left_join(cumstats %>%
              select(Season, Team, Week, Borda.cum), by = c('Season', 'Week', 'Team'))

dat <- dat %>%
  left_join(standings, by = c('Team', 'Season', 'Week'))
write.csv(dat, 'RenegadesHistoryFormatted.csv')
