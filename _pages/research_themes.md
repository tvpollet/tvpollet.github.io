---
layout: page
permalink: /research-themes/
title: research themes
description: An overview of the main research themes in my work.
nav: false
---

<style>
.publications ol.bibliography li .hidden {
  display: block !important;
}
</style>

My work is interdisciplinary, drawing on evolutionary psychology, social network analysis, health psychology, and quantitative methodology. The themes below capture the main strands — papers can appear under more than one theme, reflecting how these areas intersect. For the complete list, see the [full publications page]({{ '/publications/' | relative_url }}).

---

## Social Relationships & Networks

<div class="publications">

A core strand of my research examines the structure and function of people's social networks — from close family ties to broader friendship circles. Drawing on Robin Dunbar's social brain framework and egocentric network methods, this work investigates how personality, technology, and life circumstances shape the number, closeness, and composition of our relationships. Recent work extends this to understand how social networks relate to loneliness, well-being, and adaptation in specific populations including older adults and university students.

{% bibliography -f papers -q @*[keywords ~= theme_social] %}
</div>

---

## Evolutionary Approaches to Human Behaviour

<div class="publications">

Much of my research applies evolutionary theory to human social and reproductive behaviour. This encompasses work on kin investment (grandparental care, sibling relationships), mate choice and jealousy, sex ratio effects on mating markets, and the role of physical characteristics in social and reproductive contexts. A recurring focus is testing whether predictions from evolutionary biology hold when examined with appropriate methods and representative samples.

{% bibliography -f papers -q @*[keywords ~= theme_evo] %}
</div>

---

## Body Image, Attractiveness & Physical Characteristics

<div class="publications">

This line of research investigates how people perceive and evaluate bodies — their own and others'. It spans body size perception and dissatisfaction, the cues people use for attractiveness judgments, and the role of physical characteristics such as height in social and competitive contexts. A methodological concern running through this work is whether findings generalise across diverse samples and measurement approaches.

{% bibliography -f papers -q @*[keywords ~= theme_body] %}
</div>

---

## Methodology, Statistics & Meta-science

<div class="publications">

I maintain an active interest in improving research methods and statistical practice in the behavioural sciences. This includes work on publication bias, the problems of aggregating data across cultures, measurement equivalence, and the diversity (or lack thereof) of research samples. Several of these papers directly address statistical practices that can mislead — from arbitrary binning of survey data to overreliance on p-values in cross-cultural comparisons.

{% bibliography -f papers -q @*[keywords ~= theme_methods] %}
</div>

---

## Gender, Work & Representation

<div class="publications">

In collaboration with Clare Cook and others, I investigate gender dynamics in professional and cultural contexts — particularly how women navigate gendered expectations in comedy, acting, and academia. This extends to examining gender representation in educational materials and measurement equivalence of psychological scales across men and women.

{% bibliography -f papers -q @*[keywords ~= theme_gender] %}
</div>

---

## Health, Well-being & Applied Settings

<div class="publications">

This strand brings together applied work spanning mental health, clinical populations, education, and public health. It includes systematic reviews of PTSD interventions and prevalence, studies of social determinants of well-being in specific groups (older adults, people with diabetes, involuntary celibates), and a growing focus on student experience and satisfaction in higher education.

{% bibliography -f papers -q @*[keywords ~= theme_health] %}
</div>
