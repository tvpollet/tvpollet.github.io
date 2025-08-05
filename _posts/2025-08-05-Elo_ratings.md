---
layout: post
title: A very basic simulation for ELO ratings
image: /img/simulation.gif
tags:
  - Research
  - R coding
  - Methods
  - Simulation
published: true

For a grant proposal I intend to write, I wanted to play around with a simulation for [ELO ratings](https://en.wikipedia.org/wiki/Elo_rating_system). If you are somewhat familiar with chess (or sport tournaments), you will know this as a way for quantifying skill. It also is used in the study of [animal dominance hierarchies](https://link.springer.com/article/10.1007/s10764-017-9952-2) and you might also know of `[EloRating](https://cran.r-project.org/web/packages/EloRating/index.html)` and `[EloSteepness](https://cran.r-project.org/web/packages/EloSteepness/index.html)`. This is but a basic simulation with just two players, just to give a taster of what happens. I'll save the details for another time - but in a nutshell, we can think of many things as a tournament and we can use the ELO system to describe the agents within that system. And who knows, we might be able to derive some useful insights.

The R file is [here](https://tvpollet.github.io/Files_for_sharing/elo_rating.R) and you can give the Shiny simulation a whirl at [https://tvpollet.shinyapps.io/Elo_Rating/](https://tvpollet.shinyapps.io/Elo_Rating/). Don't do it all at once as it is a basic Shiny account and might stop working ;). Also, I used AI tools to help me with the simulation (it messed up badly on some occasions but all in all a useful experience - mostly used Claude.ai but also looked at DeepSeek).

Enjoy! And I welcome feedback via email.