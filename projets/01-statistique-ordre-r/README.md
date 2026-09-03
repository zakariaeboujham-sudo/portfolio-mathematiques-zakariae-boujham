# Statistique d'ordre et identification d'une loi avec R

Projet académique réalisé en 2020 dans le cadre du Master *Analyse mathématique, statistique, géométrie et applications*, sous l'encadrement de M. Mohammed El Arrouchi.

## Problème

À partir d'un échantillon de 500 observations, déterminer quelle loi classique décrit le mieux la variable aléatoire étudiée. Le travail combine une analyse de statistiques d'ordre avec une démarche d'ajustement et de comparaison de lois.

## Approche

1. Statistiques descriptives et étude des records successifs.
2. Comparaison des lois bêta, logistique, gamma, normale, log-normale, Weibull, Pareto et Cauchy.
3. Histogrammes, fonctions de répartition empiriques, densités et QQ-plots.
4. Estimation des paramètres et test d'adéquation de Kolmogorov-Smirnov.

## Résultat du rapport initial

Les analyses graphiques et le test effectué conduisent à retenir une loi log-normale pour représenter les observations. Cette conclusion concerne ce jeu de données et ne constitue pas une propriété générale.

## Amélioration méthodologique

Le script publié sépare clairement chargement, estimation, visualisation et test. Comme les paramètres sont estimés sur le même échantillon, il propose un bootstrap paramétrique avec réestimation pour évaluer la distance de Kolmogorov-Smirnov.

## Reproductibilité

- `scripts/analyse_statistique.R` analyse un CSV contenant une colonne numérique `x`.
- `scripts/demo_simulation.R` crée un échantillon simulé uniquement destiné à tester le programme.
- Les données universitaires originales ne sont pas publiées, leurs droits de diffusion n'étant pas établis.

## Compétences mobilisées

Programmation R, statistiques descriptives et d'ordre, estimation paramétrique et non paramétrique, comparaison de distributions, tests d'adéquation et interprétation prudente des résultats.
