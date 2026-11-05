---
layout: page
permalink: /publications/
title: publications
description: Publications in reversed chronological order.
nav: false
nav_order: 3
---

<p class="post-description">
  The list below contains {% bibliography_count %} entries (papers, preprints, and book chapters), of which {% bibliography_count --query @article %} are journal articles.
  My ResearcherID is <a href="https://www.webofscience.com/wos/author/record/H-3397-2012">H-3397-2012</a>, and my publications are also listed on my <a href="https://scholar.google.com/citations?user=T2fYknYAAAAJ">Google Scholar profile</a>.
</p>

<div class="publications">
{% include bib_search.liquid %}
{% bibliography %}
</div>