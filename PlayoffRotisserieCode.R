## Playoff Scoreboard Scraper

## User Inputs ####
#season = 2018

# if(file.exists("C:/Users/Matthias")){
#   setwd("C:/Users/Matthias/Google Drive/Baseball Projects/Fantasy Baseball/Renegades Player Valuation")
# }else if(file.exists("C:/Users/Matthias.Kullowatz")){
#   setwd("C:/Users/Matthias.Kullowatz/Google Drive/Baseball Projects/Fantasy Baseball/Renegades Player Valuation")
# }

library(dplyr)
library(rvest)
library(XML)

## Scrape recent weeks ####

playoff.scrape <- function(season, week, matchup.id){
  week.id <- ifelse(week == 21, 154, 169)
  weekdata <- htmlParse(paste0("http://games.espn.com/flb/boxscorefull?leagueId=52888&teamId=", matchup.id, "&scoringPeriodId=", week.id, "&seasonId=", season, "&view=matchup&version=full"))
  stats <- as.numeric(sapply(getNodeSet(weekdata, "//tr[@class = 'playerTableBgRowTotals']/td[contains(@class, 'playertableStat')]"), xmlValue))
  statnames <- sapply(getNodeSet(weekdata, "//td[@class = 'playertableStat']/span"), xmlValue)
  statnames[c(11, 13)] <- c("H.P", "BB.P")
  seeds <- sapply(sapply(getNodeSet(weekdata, "//td[@class = 'teamName']"), xmlValue), function(x) na.omit(as.numeric(unlist(strsplit(x, "[^[:digit:]]"))))[1])
  teamname <- sapply(getNodeSet(weekdata, "//tr[@class = 'playerTableBgRowHead tableHead playertableTableHeader']"), xmlValue)[1]
  teamname <- trimws(unlist(strsplit(teamname, "Box Score")))
  stattable <- data.frame(Team = teamname, Seed = seeds[1], Week = week, matrix(stats, 1, 19, byrow = TRUE))
  names(stattable) <- c("Team", "Seed", "Week", statnames[1:19])
  rownames(stattable) <- 1:dim(stattable)[1]
  stattable
}

playoff.data <- data.frame()
for(week in weeks.need){
  for(matchup.id in 1:12){
    playoff.data <- rbind(playoff.data, playoff.scrape(season, week, matchup.id))
  }
}
playoff.data
## Consolation Bracket ####

cons.data <- playoff.data %>%
  mutate(IP = floor(IP) + (IP - floor(IP))*10/3) %>%
  filter(Seed > 4) %>%
  group_by(Team) %>%
  summarize(R = sum(R), HR = sum(HR), RBI = sum(RBI), SB = sum(SB),
            OBP = sum(OBP*(AB + BB))/sum(AB + BB), SLG = sum(SLG*AB)/sum(AB),
            K = sum(K), QS = sum(QS), W = sum(W), SV = sum(SV), 
            ERA = sum(IP*ERA)/sum(IP), WHIP = sum(IP*WHIP)/sum(IP)) %>%
  ungroup()

rot.score1 <- data.frame(Team = cons.data$Team, 
                        apply(cons.data[,2:11], 2, rank),
                        apply(cons.data[,12:13], 2, function(x) 9 - rank(x)))
rot.score1[["Score"]] <- apply(rot.score1[,-1], 1, sum)
arrange(rot.score1, desc(Score))
arrange(cons.data, desc(rot.score1$Score))
saveRDS(arrange(rot.score1, desc(Score)), paste0("ConsolationPlayoffRankings - ", season, '.RDS'))

# All playoff teams ####
cons.data <- playoff.data %>%
  mutate(IP = floor(IP) + (IP - floor(IP))*10/3) %>%
  group_by(Team) %>%
  summarize(R = sum(R), HR = sum(HR), RBI = sum(RBI), SB = sum(SB),
            OBP = sum(OBP*(AB + BB))/sum(AB + BB), SLG = sum(SLG*AB)/sum(AB),
            K = sum(K), QS = sum(QS), W = sum(W), SV = sum(SV), 
            ERA = sum(IP*ERA)/sum(IP), WHIP = sum(IP*WHIP)/sum(IP)) %>%
  ungroup()

rot.score2 <- data.frame(Team = cons.data$Team, 
                        apply(cons.data[,2:11], 2, rank),
                        apply(cons.data[,12:13], 2, function(x) 13 - rank(x)))
rot.score2[["Score"]] <- apply(rot.score2[,-1], 1, sum)
arrange(rot.score2, desc(Score))
saveRDS(arrange(rot.score2, desc(Score)), paste0("AllPlayoffRankings - ", season, '.RDS'))
