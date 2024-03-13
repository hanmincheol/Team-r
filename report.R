library(plumber)
library(rmarkdown)


# R문서 실행시킬 수 있는 값으로 응답하는 함수
#' @get /htmlfile2
function() {
  html_file_path <- "D:/Team-Proj/Team-r/user_report.html"
  html_content <- readLines(html_file_path, warn = FALSE)
  return(list(content = paste(html_content, collapse="\n")))
}


#' #' @get /htmlfile000
#' function(userid) {
#' 
#'   # 사용자가 요청한 userid 값을 가져오기
#'   print(paste("받은 params -",userid))
#' 
#'   # R Markdown 파일 경로
#'   rmd_file_path <- "D:/Team-Proj/Team-r/user_report.Rmd"
#' 
#'   # R Markdown 파일 내용 읽기
#'   rmd_content <- readLines(rmd_file_path, warn = FALSE)
#' 
#'   # title에 userid 값 삽입
#'   for (i in seq_along(rmd_content)) {
#'     if (grepl("^title:", rmd_content[i])) {
#'       rmd_content[i] <- paste0("title: \"", userid, "- report\"")
#'       break
#'     }
#'   }
#' 
#'   # 수정된 R Markdown 파일 내용을 HTML로 렌더링하여 문자열로 저장
#'   html_content <- rmarkdown::render(input = paste(rmd_content, collapse="\n"),
#'                                     output_format = "html_document",
#'                                     params = list(userid = userid))
#' 
#'   # HTML 내용을 응답으로 반환
#'   return(list(content = html_content))
#' }

# '/htmlfile' 엔드포인트 정의
#' @get /htmlfile
function(req, res, userid) {
  # 사용자가 요청한 userid 값을 가져오기
  print(paste("받은 params -", userid))
  # R Markdown 파일 경로
  rmd_file_path <- "D:/Team-Proj/Team-r/user_report.Rmd"
  # R Markdown 파일 내용 읽기
  rmd_content <- readLines(rmd_file_path, warn = FALSE)
  # title에 userid 값 삽입
  for (i in seq_along(rmd_content)) {
    if (grepl("^title:", rmd_content[i])) {
      rmd_content[i] <- paste0("title: \"", userid, "- report\"")
      break
    }
  }
  # 수정된 R Markdown 내용을 임시 파일로 저장
  temp_file_path <- tempfile(fileext = ".Rmd")
  writeLines(rmd_content, temp_file_path)
  # 임시 R Markdown 파일을 HTML로 렌더링
  output_file_path <- tempfile(fileext = ".html")
  rmarkdown::render(input = temp_file_path,
                    output_file = output_file_path,
                    output_format = "html_document",
                    params = list(userid = userid),
                    quiet = TRUE)
  # 생성된 HTML 파일 내용 읽기
  html_content <- readLines(output_file_path, warn = FALSE)
  # HTML 내용을 응답으로 반환
  res$body <- paste(html_content, collapse = "\n")
  res$setHeader("Content-Type", "text/html")
  return(res)
}




# CORS 에러 해결해주는 함수
#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}