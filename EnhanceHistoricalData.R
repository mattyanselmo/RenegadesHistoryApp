dat <- read.csv('RenegadesHistory.csv')
teammap <- read.csv('TeamMapping.csv')

library(dplyr)

dat <- dat %>%
  group_by(Season, Week) %>%
  mutate(Matchup = c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6))

dat <- dat %>%
  left_join(teammap, by = 'Team')

write.csv(dat, 'RenegadesHistoryFormatted.csv')