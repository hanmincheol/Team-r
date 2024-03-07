# 필요한 library 설치
# install.packages("plumber")

# 필요한 library 호출
library(plumber)

pr  <- Plumber$new()
db <- Plumber$new("D:/Team-Proj/Team-r/database_connection.R")
report <- Plumber$new("D:/Team-Proj/Team-r/report.R")
pr$mount("/api", db)
pr$mount("/api", report)
pr$run(port=8000, swagger=FALSE)
