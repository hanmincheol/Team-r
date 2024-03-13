# 필요한 library 설치
# install.packages("gridGraphics")

# 필요한 library 호출
library(plumber)

pr  <- Plumber$new()
report <- Plumber$new("D:/Team-Proj/Team-r/report.R")
pr$mount("/api", report)
pr$run(port=8000, swagger=FALSE)