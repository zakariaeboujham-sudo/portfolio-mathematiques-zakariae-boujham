# Statistique d'ordre et identification d'une loi avec R

Projet académique réalisé en 2020 dans le cadre du Master *Analyse mathématique, statistique, géométrie et applications*, sous l'encadrement de M. Mohammed El Arrouchi.

## Problème

À partir d'un échantillon de 500 observations, déterminer quelle loi classique décrit le mieux la variable aléatoire étudiée. Le travail combine une analyse de statistiques d'ordre avec une démarche d'ajustement et de comparaison de lois.

## Approche

1. Calcul des paramètres descriptifs : minimum, quartiles, médiane, moyenne, variance, écart-type, étendue et écart interquartile.
2. Étude des records successifs, de leurs indicatrices et du nombre de records observés.
3. Comparaison de plusieurs familles : bêta, logistique, gamma, normale, log-normale, Weibull, Pareto et Cauchy.
4. Comparaison graphique par histogramme, densité, fonction de répartition empirique et QQ-plots.
5. Estimation des paramètres des lois candidates.
6. Vérification par un test d'adéquation de Kolmogorov-Smirnov.

## Résultat du rapport initial

Les analyses graphiques et le test effectué dans le rapport conduisent à retenir une loi log-normale pour représenter les observations. Cette conclusion est présentée comme le résultat de ce jeu de données, pas comme une propriété générale.

## Document original

- [`rapport-statistique-ordre-complet.pdf`](rapport-statistique-ordre-complet.pdf) est le rapport universitaire original de 27 pages.
- Le numéro APOGEE figurant sur la couverture a été masqué avant la mise en ligne publique ; le contenu scientifique n'a pas été réécrit.
- Le jeu de données universitaire original n'est pas publié, ses droits de diffusion n'étant pas établis.

## Compétences mobilisées

- programmation scientifique sous R ;
- statistiques descriptives et statistiques d'ordre ;
- estimation paramétrique et non paramétrique ;
- comparaison graphique de distributions ;
- tests d'adéquation et interprétation prudente des résultats.

## Limites

- les données originales ne sont pas disponibles dans ce dépôt ;
- le rapport de 2020 présente une implémentation pédagogique réalisée dans le cadre du module ;
- la sélection finale d'un modèle doit aussi considérer la qualité des données, les hypothèses métier et la validation hors échantillon.
