# Driver file to create plots, etc.
# code and data dirctories should be present and synced to the desired date

library(here)
source(here("code/covid19/jhuanalyze/ReadUSCovidData.R"))

tib7 <- calc_7day(dfTots)
tib7Cases <- calc_7day(dfCaseTots)

# Middlesex, MA
autoplot(tib7[1231,]$rolling_avg_7day[[1]])

# Maricopa, AZ
autoplot(tib7[109,]$rolling_avg_7day[[1]])

# New York City
autoplot(tib7["1864",]$rolling_avg_7day[[1]])

# Middlesex, MA
plot7death(tib7, "Middlesex, Massachusetts, US")
# Maricopa, AZ
plot7death(tib7, "Maricopa, Arizona, US")
# New York City
plot7death(tib7, "New York City, New York, US")

# Plot some graphs out of the merged zoo
z2 <- get_merged_7day(tib7)
z22 <- get_merged_7day(tib7Cases)
zCumDeaths <- get_merged_cumulative(tib7)
zCumCases <- get_merged_cumulative(tib7Cases)

# Deaths
autoplot(z2[,grep("Am", names(z2), value=FALSE)])
autoplot(z2[,grep("Massachusetts", names(z2), value=FALSE)])
autoplot(z2[,grep("Middlesex", names(z2), value=FALSE)])
autoplot(z2[,grep("New York City", names(z2), value=FALSE)])
autoplot(z2[,grep("Middlesex|New York City", names(z2), value=FALSE)])

# Cases
autoplot(z22[,grep("Am", names(z2), value=FALSE)])
autoplot(z22[,grep("Massachusetts", names(z2), value=FALSE)])
autoplot(z22[,grep("Middlesex, Ma", names(z2), value=FALSE)])
autoplot(z22[,grep("New York City", names(z2), value=FALSE)])
autoplot(z22[,grep("Middlesex|New York City", names(z2), value=FALSE)])

# Plot sum of several graphs
# TODO: Fix axis labels
# All of MA
autoplot(zoo(rowSums(z2[,grep("Massachusetts", names(z2), value=FALSE)])))
autoplot(zoo(rowSums(z22[,grep("Massachusetts", names(z22), value=FALSE)])))

# Everything except New York
# z3 <- z2[,grep("New York, US", names(z2), invert=TRUE, value=FALSE)]
# autoplot(zoo(rowSums(z3)))

# New York vs. Rest of U.S. on same plot
# z4 <- merge(z3, zoo(rowSums(z2[,grep("New York, US", names(z2), invert=FALSE, value=FALSE)])))
z3 <- zoo(rowSums(z2[,grep("New York, US", names(z2), invert=TRUE, value=FALSE)]))
z4 <- zoo(rowSums(z2[,grep("New York, US", names(z2), invert=FALSE, value=FALSE)]))
z23 <- zoo(rowSums(z22[,grep("New York, US", names(z2), invert=TRUE, value=FALSE)]))
z24 <- zoo(rowSums(z22[,grep("New York, US", names(z2), invert=FALSE, value=FALSE)]))
z5 <- merge(z3, z4, z23, z24)
names(z5) <- c("Rest of U.S. Deaths", "New York Deaths", "Rest of U.S. Cases", "New York Cases")
autoplot(z5, facets=NULL)
autoplot(log10(z5), facets=NULL) +
  labs(x="Days since 1/20/20", y="Log10(7-day average)", title="New York and Rest of U.S. Cases and Deaths")


# Top 50 counties by population
dfDeathsBigCounties = dfCovidUSDeaths[order(-dfCovidUSDeaths$Population),]
dfBigCountyTots <- dfDeathsBigCounties %>% .[,c(11,13:ncol(.))]
tibBigCounty7 <- calc_7day(dfBigCountyTots[1:50,])
zc <- get_merged_relations(tibBigCounty7)
autoplot(zc[,grep("Los", names(zc), invert=FALSE)])

# FL, GA, AL, MS, LA, TX, SC
z9 <- zoo(rowSums(z2[,grep("Florida, US", names(z2), invert=FALSE, value=FALSE)]))
z10 <- zoo(rowSums(z2[,grep("Georgia, US", names(z2), invert=FALSE, value=FALSE)]))
z11 <- zoo(rowSums(z2[,grep("Alabama, US", names(z2), invert=FALSE, value=FALSE)]))
z12 <- zoo(rowSums(z2[,grep("Mississippi, US", names(z2), invert=FALSE, value=FALSE)]))
z13 <- zoo(rowSums(z2[,grep("Louisiana, US", names(z2), invert=FALSE, value=FALSE)]))
z14 <- zoo(rowSums(z2[,grep("Texas, US", names(z2), invert=FALSE, value=FALSE)]))
z17 <- zoo(rowSums(z2[,grep("South Carolina, US", names(z2), invert=FALSE, value=FALSE)]))
z15 <- merge(z9, z10, z11, z12, z13, z14, z17, drop=FALSE)
names(z15) <- c("FL Deaths", "GA Deaths", "AL Deaths", "MS Deaths", "LA Deaths", "TX Deaths", "SC Deaths")
z16 <- merge(z15, zoo(rowSums(z15)))
names(z16) <- c("Total Deaths", names(z15))
autoplot(z16, facets=NULL)
autoplot(log10(z16), facets=NULL)


# FL, GA, AL, MS, LA, TX, SC

z29 <- zoo(rowSums(z22[,grep("Florida, US", names(z22), invert=FALSE, value=FALSE)]))
z30 <- zoo(rowSums(z22[,grep("Georgia, US", names(z22), invert=FALSE, value=FALSE)]))
z31 <- zoo(rowSums(z22[,grep("Alabama, US", names(z22), invert=FALSE, value=FALSE)]))
z32 <- zoo(rowSums(z22[,grep("Mississippi, US", names(z22), invert=FALSE, value=FALSE)]))
z33 <- zoo(rowSums(z22[,grep("Louisiana, US", names(z22), invert=FALSE, value=FALSE)]))
z34 <- zoo(rowSums(z22[,grep("Texas, US", names(z22), invert=FALSE, value=FALSE)]))
z37 <- zoo(rowSums(z22[,grep("South Carolina, US", names(z22), invert=FALSE, value=FALSE)]))
z35 <- merge(z29, z30, z31, z32, z33, z34, z37)
names(z35) <- c("FL Cases", "GA Cases", "AL Cases", "MS Cases", "LA Cases", "TX Cases", "SC Cases")
z36 <- merge(z35, zoo(rowSums(z35)))
names(z36) <- c("Total Cases", names(z35))
autoplot(z36, facets=NULL)
autoplot(log10(z36), facets=NULL)
plotZCasesAndDeaths(z10, z30, "Georgia")
plotZCasesAndDeaths(z15, z35, "Selected southern states")
plotZCasesAndDeaths(z16, z36, "Selected southern states")


zVA <- getStateCasesAndDeaths(z2, z22, "Virginia")
autoplot(log10(zVA), facets=NULL) +
  labs(x="Days since 1/20/20", y="Log(7-day average)", title="Virginia")
autoplot(zVA, facets=NULL) +
  labs(x="Days since 1/20/20", y="7-day average", title="Virginia")

