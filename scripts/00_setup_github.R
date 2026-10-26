# 只需运行一次：把本项目初始化为 git 仓库并推送到 GitHub
# 前提：已有 GitHub 账号，并配置好 PAT（个人访问令牌）
#   usethis::create_github_token()   # 浏览器里生成 token（勾选 repo 权限）
#   gitcreds::gitcreds_set()         # 把 token 粘贴进去
library(usethis)

use_git()                           # 初始化 git 并做首次提交
use_github(private = FALSE)         # 在 GitHub 创建同名仓库、关联并推送
# 若老师要求私有仓库，改成 use_github(private = TRUE)
