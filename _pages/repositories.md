---
layout: page
permalink: /repositories/
title: repositories
description: GitHub repositories for Shiny apps, talks, course materials, and other projects.
nav: true
nav_order: 4
---

## GitHub

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
{% for user in site.data.repositories.github_users %}
  {% include repository/repo_user.liquid username=user %}
{% endfor %}
</div>

---

{% if site.data.repositories.shiny_apps.size > 0 %}
## Shiny Apps

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
{% for repo in site.data.repositories.shiny_apps %}
  {% include repository/repo.liquid repository=repo %}
{% endfor %}
</div>

---

{% endif %}

{% if site.data.repositories.talks.size > 0 %}
## Talks & Presentations

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
{% for repo in site.data.repositories.talks %}
  {% include repository/repo.liquid repository=repo %}
{% endfor %}
</div>

---

{% endif %}

{% if site.data.repositories.courses.size > 0 %}
## Course Materials

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
{% for repo in site.data.repositories.courses %}
  {% include repository/repo.liquid repository=repo %}
{% endfor %}
</div>

---

{% endif %}

{% if site.data.repositories.other.size > 0 %}
## Other

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
{% for repo in site.data.repositories.other %}
  {% include repository/repo.liquid repository=repo %}
{% endfor %}
</div>
{% endif %}
