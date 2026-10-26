# 02_make_plot.R
# 作用：读取清洗后的数据，生成交互式 Plotly 图，并保存为 html 到 results/figures/
# 生成对象：p1（动画散点图）、p2（大洲时间序列）、p3（1952 vs 2007 散点图）

library(plotly)
library(readr)
library(dplyr)
library(tidyr)
library(htmlwidgets)
library(here)

dir.create(here("results", "figures"), recursive = TRUE, showWarnings = FALSE)

df <- read_csv(here("data", "processed", "gapminder_clean.csv"),
               show_col_types = FALSE)

# 固定大洲颜色，保证各图一致
cont_cols <- c(Africa = "#E15759", Americas = "#4E79A7", Asia = "#59A14F",
               Europe = "#B07AA1", Oceania = "#F28E2B")

# ---- 图 1：GDP vs 预期寿命，随年份动画 -------------------------------
p1 <- plot_ly(
  data = df,
  x = ~gdpPercap, y = ~lifeExp,
  size = ~pop, sizes = c(8, 60),
  color = ~continent, colors = cont_cols,
  frame = ~year,
  ids = ~country,
  text = ~hover_text, hoverinfo = "text",
  type = "scatter", mode = "markers",
  marker = list(opacity = 0.7, sizemode = "area",
                line = list(width = 0.5, color = "white"))
) |>
  layout(
    title = "GDP per Capita and Life Expectancy, 1952–2007",
    xaxis = list(title = "GDP per capita (US$, log scale)", type = "log",
                 range = c(log10(200), log10(120000))),
    yaxis = list(title = "Life expectancy (years)", range = c(20, 90))
  ) |>
  animation_opts(frame = 700, transition = 400, redraw = FALSE) |>
  animation_slider(currentvalue = list(prefix = "Year: "))

saveWidget(p1, here("results", "figures", "gdp_lifeexp_interactive.html"),
           selfcontained = TRUE)

# ---- 图 2：各大洲人口加权平均预期寿命 --------------------------------
cont <- df |>
  group_by(continent, year) |>
  summarise(lifeExp = weighted.mean(lifeExp, pop), .groups = "drop")

p2 <- plot_ly(
  cont, x = ~year, y = ~lifeExp, color = ~continent, colors = cont_cols,
  type = "scatter", mode = "lines+markers",
  hovertemplate = "%{x}: %{y:.1f} years<extra>%{fullData.name}</extra>"
) |>
  layout(
    title = "Population-weighted life expectancy by continent",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Life expectancy (years)")
  )

saveWidget(p2, here("results", "figures", "lifeexp_by_continent.html"),
           selfcontained = TRUE)

# ---- 图 3：1952 vs 2007 每个国家的寿命（对角线以下 = 进步较小） --------
chg <- df |>
  filter(year %in% c(1952, 2007)) |>
  select(country, continent, year, lifeExp) |>
  pivot_wider(names_from = year, values_from = lifeExp, names_prefix = "y") |>
  mutate(change = y2007 - y1952) |>
  arrange(change)

write_csv(chg, here("data", "processed", "lifeexp_change_1952_2007.csv"))

p3 <- plot_ly(
  chg, x = ~y1952, y = ~y2007, color = ~continent, colors = cont_cols,
  type = "scatter", mode = "markers",
  text = ~paste0("<b>", country, "</b><br>1952: ", round(y1952, 1),
                 "<br>2007: ", round(y2007, 1),
                 "<br>Change: ", round(change, 1), " years"),
  hoverinfo = "text", marker = list(size = 9, opacity = 0.8)
) |>
  layout(
    title = "Life expectancy by country: 1952 vs 2007",
    xaxis = list(title = "Life expectancy in 1952 (years)", range = c(25, 85)),
    yaxis = list(title = "Life expectancy in 2007 (years)", range = c(25, 85)),
    shapes = list(list(type = "line", x0 = 25, y0 = 25, x1 = 85, y1 = 85,
                       line = list(dash = "dash", color = "grey")))
  )

saveWidget(p3, here("results", "figures", "lifeexp_1952_vs_2007.html"),
           selfcontained = TRUE)

message("Done: interactive figures saved to results/figures/")
