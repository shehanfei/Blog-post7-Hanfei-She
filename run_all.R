# 一键复现：依次运行所有脚本并 knit 文章
source("scripts/00_install_packages.R")
source("scripts/01_prepare_data.R")
source("scripts/02_make_plot.R")
rmarkdown::render("index.Rmd")
