# Blog Post 7: Interactive Data Visualization with Plotly

**Course:** Computational Methods for Economists

**Question:** How has the relationship between GDP per capita and life expectancy changed between 1952 and 2007, and which countries deviate most from it?

**Final post:** `blog_post_7.Rmd` (knits to `blog_post_7.html`)

## Repository structure

```
blog7-plotly/
├── README.md
├── blog7-plotly.Rproj
├── run_all.R                    # one-click replication
├── blog_post_7.Rmd              # final blog post
├── data/
│   ├── raw/                     # raw copy of the gapminder dataset
│   └── processed/               # cleaned data + summary tables (created by script 01)
├── scripts/
│   ├── 00_install_packages.R    # installs required packages
│   ├── 00_setup_github.R        # one-time git/GitHub setup (usethis)
│   ├── 01_prepare_data.R        # data cleaning and summary tables
│   └── 02_make_plot.R           # interactive Plotly figures -> results/figures/
└── results/
    └── figures/                 # saved interactive HTML figures
```

## Replication instructions

Requires R (>= 4.1) and RStudio (RStudio includes pandoc, which is needed to save self-contained HTML widgets).

1. Open `blog7-plotly.Rproj` in RStudio.
2. Run everything at once: `source("run_all.R")`

   Or step by step:
   1. `source("scripts/00_install_packages.R")`
   2. `source("scripts/01_prepare_data.R")`
   3. `source("scripts/02_make_plot.R")`
   4. Knit `blog_post_7.Rmd` (Knit button, or `rmarkdown::render("blog_post_7.Rmd")`)

All tables and figures are generated programmatically; nothing is copied manually.

## Data source

Gapminder Foundation, accessed via the R package `gapminder`: <https://CRAN.R-project.org/package=gapminder>.
Variables used: `country`, `continent`, `year`, `lifeExp`, `pop`, `gdpPercap`.

## Interactive features

- Year slider and play button for Figure 1 (relationship over time)
- Hover labels with country name and exact values
- Legend click to hide or isolate continents
- Zoom and pan on all figures

## Viewing the figures

Open any file in `results/figures/` in a web browser, or open the knitted `blog_post_7.html`.
