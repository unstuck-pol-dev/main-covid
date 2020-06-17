library(here)
source("code/covid19/jhuanalyze/GenStatePlots.R")

tib7 <- calc_7day(dfTots)
tib7Cases <- calc_7day(dfCaseTots)

z2 <- get_merged_7day(tib7)
z22 <- get_merged_7day(tib7Cases)

today <- Sys.Date()
generate_state_plots(state_abbrs, state_names, z2, z22,
                     format(today, "%Y"), format(today, "%m"), format(today, "%d"))
