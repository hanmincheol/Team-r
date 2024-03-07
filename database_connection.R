# 필요 library 설치
# install.packages("rJava")
# install.packages("RJDBC")
# install.packages("dplyr")
# install.packages("dbplyr")

library(rJava)
library(RJDBC)
library(dplyr)
library(dbplyr)


dbConnection <- function(.) {
  #DB 연결 설정
  jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver",
                     classPath = "C://ojdbc8.jar")
  # "C://Users/ict2-04/.m2/repository/org/springframework/spring-jdbc/6.1.1/spring-jdbc-6.1.1.jar"
  
  con <- dbConnect(jdbcDriver,
                    "jdbc:oracle:thin:@192.168.0.99:1521/XEPDB1", "TEAM", "TEAM")
  
  return(con)
}

# /db라는 엔드포인트로 요청받을 경우, 응답 함수
#' @serializer unboxedJSON
#' @get /db
db_example <- function(userid, con) {
  con = dbConnection()

  query <- paste0("SELECT COUNT(*) FROM MEMBER WHERE ID = '", userid, "'")
  r <- dbGetQuery(con, query)
  
  dbDisconnect(con)
  return(list(result=r))
  
}


dbSafeNames = function(names) {
  names = gsub('[^a-z0-9]+','_',tolower(names))
  names = make.names(names, unique=TRUE, allow_=TRUE)
  names = gsub('.','_',names, fixed=TRUE)
  names
}

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}
