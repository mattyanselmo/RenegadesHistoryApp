library(dplyr)
library(shiny)
library(ggplot2)
library(knitr)

source('RecordsFunction.R')
source('StandingsFunction.R')
dat <- read.csv('RenegadesHistoryFormatted.csv')
playoffs.cons <- readRDS("ConsolationPlayoffRankings - 2018.RDS")
playoffs.all <- readRDS("AllPlayoffRankings - 2018.RDS")

