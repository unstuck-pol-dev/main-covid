library(here)
source("code/covid19/jhuanalyze/GenStatePlots.R")

tib7 <- calc_7day(dfTots)
tib7Cases <- calc_7day(dfCaseTots)

z2 <- get_merged_7day(tib7)
z22 <- get_merged_7day(tib7Cases)

zCumDeaths <- get_merged_cumulative(tib7)
zCumCases <- get_merged_cumulative(tib7Cases)

today <- Sys.Date()
generate_state_plots(state_abbrs, state_names, z2, z22,
#                     "2020", "06", "17")
                     format(today, "%Y"), format(today, "%m"), format(today, "%d"))

# Generate trend maps for U.S.
source(here("code/covid19/jhuanalyze/GenerateTrendMap.R"))

generate_case_trend_map(z2, z22, zCumCases)
generate_death_trend_map(z2, z22, zCumDeaths)
