---
layout: page
title: Meta-analysis Course (in R)
description: a minore ad maius
permalink: /meta_analysis_course/
nav: false
---

# Contents
{:.no_toc}

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

## General info.

The course runs for the first time at an [HBES](https://www.hbes.com){:target="_blank"} funded workshop at [Universidade Federal do Rio Grande do Norte in Natal (Brazil)](https://www.lechufrn.com/){:target="_blank"} in Sept. 2019.

I'll aim to make all my materials available via this website. The sources are listed at the end of each lecture as well as embedded. (Please also note the [disclaimer](/disclaimer/)).

This course relies heavily on various tutorials and books, in no particular order, a tutorial by [Harrer on doing meta-analysis](https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/){:target="_blank"}, the [book by Borenstein et al. (2009)](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470743386){:target="_blank"} the [R book by Schwarzer](https://www.springer.com/gp/book/9783319214153){:target="_blank"}, [the book by Chen & Peace on applied meta-analysis in R](https://www.crcpress.com/Applied-Meta-Analysis-with-R/Chen-Peace/p/book/9781466505995){:target="_blank"}, the [book by Mike Cheung on MetaSEM](https://onlinelibrary.wiley.com/doi/book/10.1002/9781118957813){:target="_blank"}, [the metafor package page](https://metafor-project.org/doku.php){:target="_blank"}, [slides by B. Wiernik](https://wiernik.org/wp-content/uploads/2015/04/Wiernik-2015-Meta-analysis-Workshop.pdf){:target="_blank"}, [the handbook of Meta-analysis in Ecology and Evolution by Koricheva and colleagues](https://press.princeton.edu/titles/10045.html){:target="_blank"}, and the workshop materials of [Weiss & Daikeler (2017)](https://www.gesis.org/en/services/events/gesis-training/training-archiv/summer-school/2017/week-3/c9-meta-analysis-in-survey-methodology){:target="_blank"} shared by my colleague. Please see the full citations (and/or hyperlinks) in the course materials.

Please contact [me](mailto:t.v.pollet1981@gmail.com) should you spot any glaring errors, omissions or would like to suggest improvements.

## Prerequisites.

Please have [R](https://cran.r-project.org/){:target="_blank"} and [RStudio](https://www.rstudio.com/products/rstudio/download/){:target="_blank"} installed on your machine.

This short course is aimed at postgraduate level. You should have a basic understanding of statistical concepts, as covered at undergraduate level, such as for example: probability, a probability sample, statistical distributions, a _t_-test, correlation, OLS Regression.

## Outcomes.

In this short course, I'll walk you through all the steps involved in 'carrying out a meta-analysis' in R.

By the end of this course, you should be able to understand published meta-analyses and conduct your own full-blown meta-analysis in R. We'll do our very best to give you the tools to become an expert, but I have no illusion(s) that you'll be an expert after just 6 short sessions. So, it's more of a 'crash course' - I recommend you read the cited sources and if in doubt ask the help of a statistician and/or consult [stats.stackexchange](https://stats.stackexchange.com/){:target="_blank"}

In more detail, in this course, we'll cover what a systematic review vs. a meta-analysis is. We'll then do some baby-steps in R. In the next session, I review common effect size families, such as Pearson _r_ or Cohen's _d_. In the third session, we'll discuss how we can synthesise those effect sizes and the differences between a fixed and random effect meta-analysis. Up until now, we have assumed that everything is hunky-dory, but one key issue which could affect _all_ meta-analyses is publication bias. In session 4, we define the problem and discuss some tests which have been suggested to allow us to detect potential publication bias (and their limitations). In session 5, we explore how we might make sense of observed heterogeneity in meta-analysis via subgroup analysis and/or meta-regression. In the final session (session 6), we will cover advanced topics in meta-analysis, such as multilevel meta-analysis, a very basic structural equation modelling approach and (frequentist) network meta-analysis.

In the interest of time, there are some topics/issues which I will not cover (e.g., Bayesian meta-analyses, complex SEM, more advanced network meta-analyses, phylogenetic meta-analyses) but I can point you in the relevant directions should you need these techniques. Similarly, it should be noted that meta-analyses do have their limitations, in the interest of time, while I touch upon these, I do not discuss these at great length but read more [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1060723/pdf/jepicomh00215-0003.pdf){:target="_blank"} and [here](https://www.sciencedirect.com/science/article/pii/S019724569700024X){:target="_blank"}, for example. The value of meta-analyses versus registered replications has also been discussed (see for example [here](https://www.frontiersin.org/articles/10.3389/fpsyg.2015.01365/full){:target="_blank"}).

## Sessions.

Note that you might require some additional files to run .rmd, so please see the corresponding GitHub site.

Use the arrows to navigate the slides and press F for full screen in your browser. More shortcuts [here](https://github.com/hakimel/reveal.js/wiki/Keyboard-Shortcuts?){:target="_blank"}

1. [Session 1: Introduction to systematic reviews, meta-analysis and R](https://tvpollet.github.io/Meta-analysis_1/Meta-analysis_1.html#1){:target="_blank"} and [.rmd](https://github.com/tvpollet/Meta-analysis_1/blob/master/Meta-analysis_1.Rmd){:target="_blank"}. Files can be found [here](https://github.com/tvpollet/Meta-analysis_1/){:target="_blank"}.

2. [Session 2: All about effect sizes...](https://tvpollet.github.io/Meta-analysis_2/Meta-analysis_2.html#1){:target="_blank"} and zipped [.rmd](https://github.com/tvpollet/Meta-analysis_2/blob/master/Meta-analysis_2.rmd.zip){:target="_blank"}. Files can be found [here](https://github.com/tvpollet/Meta-analysis_2/){:target="_blank"}.

3. [Session 3: Fixed vs. random effects meta-analysis](https://tvpollet.github.io/Meta-analysis_3/Meta-analysis_3.html#1){:target="_blank"} and [.rmd](https://github.com/tvpollet/Meta-analysis_3/blob/master/Meta-analysis_3.Rmd){:target="_blank"}. Files can be found [here](https://github.com/tvpollet/Meta-analysis_3/){:target="_blank"}.

4. [Session 4: Publication bias](https://tvpollet.github.io/Meta-analysis_4/Meta-analysis_4.html#1){:target="_blank"} and [.rmd](https://github.com/tvpollet/Meta-analysis_4/blob/master/Meta-analysis_4.Rmd){:target="_blank"}. Files can be found [here](https://github.com/tvpollet/Meta-analysis_4/){:target="_blank"}.

5. [Session 5: Meta-regression and subgroup analyses](https://tvpollet.github.io/Meta-analysis_5/Meta-analysis_5.html#1){:target="_blank"} and [.rmd](https://github.com/tvpollet/Meta-analysis_5/blob/master/Meta-analysis_5.Rmd){:target="_blank"}. Files can be found [here](https://github.com/tvpollet/Meta-analysis_5/){:target="_blank"}.

6. [Session 6: Advanced topics: Multilevel, basic SEM, basics of network meta-analysis,... .](https://tvpollet.github.io/Meta-analysis_6/Meta-analysis_6.html#1){:target="_blank"} and [.rmd](https://github.com/tvpollet/Meta-analysis_6/blob/master/Meta-analysis_6.Rmd){:target="_blank"}. Files can be found [here](https://github.com/tvpollet/Meta-analysis_6/){:target="_blank"}.

Slides were made with the amazing [xaringan](https://github.com/yihui/xaringan){:target="_blank"} package in R.


## Exercises.

These are the exercises and the solutions, no peeking (ahum). There currently is no exercise for session 6, but I recommend you do some reading instead - it is pretty advanced stuff!

1. [Exercise 1 questions](https://tvpollet.github.io/Meta-analysis_1/Exercise_1_questions.html){:target="_blank"}, [solution](https://tvpollet.github.io/Meta-analysis_1/Exercise_1.html){:target="_blank"}, and [.rmd](https://raw.githubusercontent.com/tvpollet/Meta-analysis_1/master/Exercise_1.Rmd){:target="_blank"}

2. [Exercise 2 questions](https://tvpollet.github.io/Meta-analysis_2/Exercise_2_questions.html){:target="_blank"}, [solution](https://tvpollet.github.io/Meta-analysis_2/Exercise_2.html){:target="_blank"}, and [.rmd](https://raw.githubusercontent.com/tvpollet/Meta-analysis_2/master/Exercise_2.Rmd){:target="_blank"}

3. [Exercise 3 questions](https://tvpollet.github.io/Meta-analysis_3/Exercise_3_questions.html){:target="_blank"}, [solution](https://tvpollet.github.io/Meta-analysis_3/Exercise_3.html){:target="_blank"}, and [.rmd](https://raw.githubusercontent.com/tvpollet/Meta-analysis_3/master/Exercise_3.Rmd){:target="_blank"}

4. [Exercise 4 questions](https://tvpollet.github.io/Meta-analysis_course/Exercise_4_questions.html){:target="_blank"}, [solution](https://tvpollet.github.io/Meta-analysis_course/Exercise_4.html){:target="_blank"}, and [.rmd](https://raw.githubusercontent.com/tvpollet/Meta-analysis_4/master/Exercise_4.Rmd){:target="_blank"}

5. [Exercise 5 questions](https://tvpollet.github.io/Meta-analysis_5/Exercise_5_questions.html){:target="_blank"}, [solution](https://tvpollet.github.io/Meta-analysis_5/Exercise_5.html){:target="_blank"}, and [.rmd](https://raw.githubusercontent.com/tvpollet/Meta-analysis_5/master/Exercise_5.Rmd){:target="_blank"}

## Youtube channel.
Occasional screencasts of my lectures can be found [here](https://www.youtube.com/channel/UCWXTuZsVGQzQTUJPkEjo0YQ/featured?view_as=subscriber){:target="_blank"}.  I'll aim to make screencasts for recurrent questions by students.

## Statistical Glossary.

Struggling with some statistical terms? Have a look [here](/PY_0782/glossary_stats.html)

## Acknowledgments.

Please see the end of each slides. My colleagues have provided generous input to these materials. My funding sources are listed in the slides. The workshop was generously financed by [HBES](https://www.hbes.com){:target="_blank"} and [the postgraduate program in Psychobiology at UFRN](https://www.lechufrn.com/){:target="_blank"}, Brazil.

## Further reading.

**To be added.**

See the slides for all sources used.

##### [Disclaimer](/disclaimer/)
