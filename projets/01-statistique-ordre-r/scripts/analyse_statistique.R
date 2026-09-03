#!/usr/bin/env Rscript

# Analyse reproductible inspirée du projet académique de statistique d'ordre.
# Usage : Rscript scripts/analyse_statistique.R data/observations.csv

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) {
  stop("Usage : Rscript scripts/analyse_statistique.R <fichier.csv>")
}

input_file <- args[[1]]
if (!file.exists(input_file)) stop("Fichier introuvable : ", input_file)

raw <- read.csv(input_file, check.names = FALSE)
if ("x" %in% names(raw)) {
  x <- raw$x
} else {
  numeric_cols <- names(raw)[vapply(raw, is.numeric, logical(1))]
  if (length(numeric_cols) == 0L) stop("Aucune colonne numérique trouvée.")
  x <- raw[[numeric_cols[[1]]]]
}

x <- x[is.finite(x)]
if (length(x) < 30L) stop("Au moins 30 observations valides sont nécessaires.")
if (any(x <= 0)) stop("L'analyse des lois positives exige x > 0.")

dir.create("resultats", showWarnings = FALSE, recursive = TRUE)

descriptif <- c(
  n = length(x), min = min(x), q1 = unname(quantile(x, 0.25)),
  mediane = median(x), moyenne = mean(x), q3 = unname(quantile(x, 0.75)),
  max = max(x), variance = var(x), ecart_type = sd(x),
  etendue = diff(range(x)), iqr = IQR(x)
)
write.csv(as.data.frame(t(descriptif)), "resultats/statistiques_descriptives.csv", row.names = FALSE)

# Records successifs : I_k = 1 si X_k dépasse tous les éléments précédents.
records <- cummax(x)
indicateurs <- c(1L, as.integer(x[-1] > head(records, -1)))
positions_records <- which(indicateurs == 1L)
write.csv(
  data.frame(position = positions_records, valeur = x[positions_records]),
  "resultats/records.csv", row.names = FALSE
)

# Estimation par maximum de vraisemblance.
fit_lnorm <- function(z) {
  mu <- mean(log(z))
  sigma <- sqrt(mean((log(z) - mu)^2))
  list(meanlog = mu, sdlog = sigma)
}

fit_gamma <- function(z) {
  init_shape <- mean(z)^2 / var(z)
  init_rate <- mean(z) / var(z)
  opt <- optim(log(c(init_shape, init_rate)), function(par) {
    shape <- exp(par[1]); rate <- exp(par[2])
    -sum(dgamma(z, shape = shape, rate = rate, log = TRUE))
  })
  list(shape = exp(opt$par[1]), rate = exp(opt$par[2]))
}

fit_weibull <- function(z) {
  opt <- optim(log(c(1, median(z))), function(par) {
    shape <- exp(par[1]); scale <- exp(par[2])
    -sum(dweibull(z, shape = shape, scale = scale, log = TRUE))
  })
  list(shape = exp(opt$par[1]), scale = exp(opt$par[2]))
}

ln <- fit_lnorm(x)
ga <- fit_gamma(x)
we <- fit_weibull(x)

fits <- data.frame(
  loi = c("log-normale", "gamma", "Weibull"),
  parametre_1 = c(ln$meanlog, ga$shape, we$shape),
  parametre_2 = c(ln$sdlog, ga$rate, we$scale),
  log_vraisemblance = c(
    sum(dlnorm(x, ln$meanlog, ln$sdlog, log = TRUE)),
    sum(dgamma(x, ga$shape, rate = ga$rate, log = TRUE)),
    sum(dweibull(x, we$shape, we$scale, log = TRUE))
  )
)
fits$AIC <- -2 * fits$log_vraisemblance + 2 * 2
write.csv(fits, "resultats/ajustements.csv", row.names = FALSE)

# Diagnostics graphiques.
pdf("resultats/diagnostics.pdf", width = 8, height = 8)
par(mfrow = c(2, 2))
hist(x, probability = TRUE, breaks = "FD", main = "Histogramme et densités", xlab = "x")
curve(dlnorm(x, ln$meanlog, ln$sdlog), add = TRUE, col = "#087DB3", lwd = 2)
curve(dgamma(x, ga$shape, rate = ga$rate), add = TRUE, col = "#D97706", lwd = 2)
curve(dweibull(x, we$shape, we$scale), add = TRUE, col = "#1697A6", lwd = 2)
legend("topright", c("log-normale", "gamma", "Weibull"), col = c("#087DB3", "#D97706", "#1697A6"), lwd = 2, bty = "n")

plot(ecdf(x), main = "Fonction de répartition empirique", xlab = "x", ylab = "F(x)")
curve(plnorm(x, ln$meanlog, ln$sdlog), add = TRUE, col = "#087DB3", lwd = 2)
curve(pgamma(x, ga$shape, rate = ga$rate), add = TRUE, col = "#D97706", lwd = 2)
curve(pweibull(x, we$shape, we$scale), add = TRUE, col = "#1697A6", lwd = 2)

qq_theorique <- qlnorm(ppoints(length(x)), ln$meanlog, ln$sdlog)
plot(qq_theorique, sort(x), main = "QQ-plot log-normal", xlab = "Quantiles théoriques", ylab = "Quantiles empiriques")
abline(0, 1, col = "#087DB3", lwd = 2)

plot(density(x), main = "Estimation non paramétrique par noyau", xlab = "x")
dev.off()

# Test KS avec bootstrap paramétrique et réestimation des paramètres.
ks_distance_lnorm <- function(z) {
  fit <- fit_lnorm(z)
  ecdf_z <- ecdf(z)
  grid <- sort(z)
  max(abs(ecdf_z(grid) - plnorm(grid, fit$meanlog, fit$sdlog)))
}

set.seed(2020)
B <- 1000L
D_obs <- ks_distance_lnorm(x)
D_boot <- replicate(B, {
  sim <- rlnorm(length(x), ln$meanlog, ln$sdlog)
  ks_distance_lnorm(sim)
})
p_boot <- (1 + sum(D_boot >= D_obs)) / (B + 1)

writeLines(c(
  sprintf("Distance KS observée : %.6f", D_obs),
  sprintf("p-value bootstrap paramétrique (%d réplications) : %.6f", B, p_boot),
  "Interprétation : une p-value élevée indique que l'écart observé est compatible avec le modèle log-normal ajusté ; elle ne prouve pas que ce modèle est vrai."
), "resultats/test_ks_bootstrap.txt")

message("Analyse terminée. Résultats écrits dans le dossier resultats/.")

