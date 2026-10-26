# 第一次运行：安装所需 R 包
pkgs <- c("gapminder", "plotly", "dplyr", "tidyr", "readr", "htmlwidgets",
          "here", "rmarkdown", "knitr", "htmltools", "usethis", "gitcreds")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)
