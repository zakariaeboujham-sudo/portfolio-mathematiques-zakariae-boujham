#!/usr/bin/env Rscript

# Jeu de démonstration uniquement. Il ne reproduit pas les données universitaires.
set.seed(2020)
dir.create("data", showWarnings = FALSE, recursive = TRUE)
x <- rlnorm(500, meanlog = 1.1, sdlog = 1.0)
write.csv(data.frame(x = x), "data/demo_observations.csv", row.names = FALSE)
message("Données simulées écrites dans data/demo_observations.csv")

