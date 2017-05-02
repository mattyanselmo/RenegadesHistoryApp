library(rsconnect)
rsconnect::setAccountInfo(name='renegades-history-app',
                          token='4DBBADF8FD214DDD2BA847EFC50B4185',
                          secret='8TD7M6WPSmrg7e0ECPrZl39X0nt4ONnpQm724/RG')
rsconnect::deployApp(getwd())