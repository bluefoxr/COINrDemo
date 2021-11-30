# Demo

#### READ DATA, BUILD COIN

# read in data
library(readxl)
IndData <- read_excel("ASEM_input_sheets.xlsx", sheet = "IndData")
IndMeta <- read_excel("ASEM_input_sheets.xlsx", sheet = "IndMeta")
AggMeta <- read_excel("ASEM_input_sheets.xlsx", sheet = "AggMeta")

# build a COIN
library(COINr)
ASEM <- assemble(IndData = IndData, IndMeta = IndMeta, AggMeta = AggMeta)

#### INITIAL VISUALISATION

# plot framework
plotframework(ASEM)

# statistics of raw data
ASEM <- getStats(ASEM, dset = "Raw", out2 = "COIN")

# plot single indicator distribution
plotIndDist(ASEM, dset = "Raw", icodes = "LPI", type = "Histogram")

# plot group of distributions (physical)
plotIndDist(ASEM, dset = "Raw", icodes = "Physical", aglev = 1, type = "Violindot")

# bar plot of indicator (CO2)
iplotBar(ASEM, dset = "Raw", isel = "CO2", usel = "ITA", aglev = 1,
         from_group = list(Group_EurAsia = "Europe"))

#### BUILD INDEX

# impute using GDP group median
ASEM <- impute(ASEM, dset = "Raw", imtype = "indgroup_median",
               groupvar = "Group_GDP")

# treat outliers
ASEM <- treat(ASEM, dset = "Imputed")

# check what's going on (call COIN, indDash() )
ASEM
indDash(ASEM)

# check summary of treated data
ASEM$Analysis$Treated$TreatSummary

# normalise data: minmax between 1 and 100
ASEM <- normalise(ASEM, dset = "Treated", ntype = "minmax",
                  npara = list(minmax = c(1,100)))

# aggregate using simple arithmetic mean
ASEM <- aggregate(ASEM, agtype = "arith_mean", dset = "Normalised")

# check COIN
ASEM

#### View results

# results table NOTE: out2 = "COIN"!
ASEM <- getResults(ASEM, tab_type = "Full", out2 = "COIN")
ASEM$Results$FullScore

# resultsDash
resultsDash(ASEM)

# export to Excel

#### Analyse

# plot correlation
plotCorr(ASEM, dset = "Normalised", icodes = "Sust", grouplev = 0, box_level = 2,
         showvals = F, flagcolours = T)

# play with weights and correlations
rew8r(ASEM)

# copy index and adjust (rank normalisation)
ASEM_rank <- ASEM
ASEM_rank$Method$normalise$ntype <- "rank"
ASEM_rank <- regen(ASEM_rank)

# comparison table
compTable(ASEM, ASEM_rank, dset = "Aggregated", isel = "Index")

# sensitivity analysis, removing indicators (see doc)

# country profile
getUnitReport(ASEM, usel = "ITA")
