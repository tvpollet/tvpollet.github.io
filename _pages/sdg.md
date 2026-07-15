---
layout: page
permalink: /sdg/
title: sustainable development goals
description: Research papers contributing to the UN Sustainable Development Goals.
nav: false
---

<style>
.publications ol.bibliography li .hidden {
  display: block !important;
}
</style>

<img src="{{ '/assets/img/the-global-goals-grid-color.png' | relative_url }}" alt="UN Sustainable Development Goals" class="img-fluid" style="max-width:500px; display:block; margin-bottom:1.5rem;">

My work contributes to the following [United Nations Sustainable Development Goals](https://sdgs.un.org/goals) (in particular: 3, 4, 5, 10, 16). This is not an exhaustive list.

---

## SDG 3: Good Health and Well-being

<img src="{{ '/assets/img/TheGlobalGoals_Icons_Color_Goal_3.png' | relative_url }}" alt="SDG 3: Good Health and Well-being" class="img-fluid" style="max-width:150px; display:block; margin-bottom:1rem;">

<div class="publications">
{% bibliography -f papers -q @*[keywords ~= sdg3] %}
</div>

---

## SDG 4: Quality Education

<img src="{{ '/assets/img/TheGlobalGoals_Icons_Color_Goal_4.png' | relative_url }}" alt="SDG 4: Quality Education" class="img-fluid" style="max-width:150px; display:block; margin-bottom:1rem;">

<div class="publications">
{% bibliography -f papers -q @*[keywords ~= sdg4] %}
</div>

---

## SDG 5: Gender Equality

<img src="{{ '/assets/img/TheGlobalGoals_Icons_Color_Goal_5.png' | relative_url }}" alt="SDG 5: Gender Equality" class="img-fluid" style="max-width:150px; display:block; margin-bottom:1rem;">

<div class="publications">
{% bibliography -f papers -q @*[keywords ~= sdg5] %}
</div>

---

## SDG 10: Reduced Inequalities

<img src="{{ '/assets/img/TheGlobalGoals_Icons_Color_Goal_10.png' | relative_url }}" alt="SDG 10: Reduced Inequalities" class="img-fluid" style="max-width:150px; display:block; margin-bottom:1rem;">

<div class="publications">
{% bibliography -f papers -q @*[keywords ~= sdg10] %}
</div>

---

## SDG 16: Peace, Justice and Strong Institutions

<img src="{{ '/assets/img/TheGlobalGoals_Icons_Color_Goal_16.png' | relative_url }}" alt="SDG 16: Peace, Justice and Strong Institutions" class="img-fluid" style="max-width:150px; display:block; margin-bottom:1rem;">

<div class="publications">
{% bibliography -f papers -q @*[keywords ~= sdg16] %}
</div>
