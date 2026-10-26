# 01_prepare_data.R
# 作用：读取 gapminder 数据，保存原始副本，清洗后输出到 data/processed/
# 数据来源：Gapminder Foundation，经 R 包 `gapminder` 提供

library(gapminder)
library(dplyr)
library(readr)
library(here)

dir.create(here("data", "raw"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("data", "processed"), recursive = TRUE, showWarnings = FALSE)

# 1. 保存原始数据副本
raw <- as.data.frame(gapminder)
write_csv(raw, here("data", "raw", "gapminder_raw.csv"))

# 2. 清洗 / 构造变量
clean <- raw |>
  mutate(
    country   = as.character(country),
    continent = as.character(continent),
    log_gdp   = log10(gdpPercap),
    hover_text = paste0(
      "<b>", country, "</b> (", continent, ")<br>",
      "Year: ", year, "<br>",
      "GDP per capita: $", format(round(gdpPercap), big.mark = ","), "<br>",
      "Life expectancy: ", round(lifeExp, 1), " years<br>",
      "Population: ", format(pop, big.mark = ",")
    )
  )
write_csv(clean, here("data", "processed", "gapminder_clean.csv"))

# 3. 1952 与 2007 各大洲汇总表（程序化生成，供文章引用）
summary_tbl <- clean |>
  filter(year %in% c(1952, 2007)) |>
  group_by(year, continent) |>
  summarise(
    n_countries  = n(),
    mean_lifeExp = round(weighted.mean(lifeExp, pop), 1),
    median_gdp   = round(median(gdpPercap)),
    .groups = "drop"
  )
write_csv(summary_tbl, here("data", "processed", "summary_1952_2007.csv"))

# 4. 每年 log10(GDP) 与寿命的相关系数、回归斜率
slopes <- clean |>
  group_by(year) |>
  summarise(
    correlation = round(cor(log_gdp, lifeExp), 3),
    slope       = round(unname(coef(lm(lifeExp ~ log_gdp))[2]), 2),
    intercept   = round(unname(coef(lm(lifeExp ~ log_gdp))[1]), 2),
    .groups = "drop"
  )
write_csv(slopes, here("data", "processed", "yearly_slopes.csv"))

message("Done: data/raw and data/processed written.")
