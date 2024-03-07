#' #' @get /markdown
#' function() {
#'   markdown_content <- readLines("D:/Team-Proj/Team-r/user_report.Rmd", warn = FALSE)
#'   return(list(content = paste(markdown_content, collapse="\n")))
#' }


#' # R Markdown 파일을 HTML로 렌더링하여 응답하는 함수
#' #' @get /markdown2
#' function() {
#'   # R Markdown 파일 경로
#'   rmd_file <- "D:/Team-Proj/Team-r/user_report.Rmd"
#' 
#'   # R Markdown 파일을 HTML로 렌더링
#'   html_content <- rmarkdown::render(rmd_file, output_format = "html_document")
#' 
#'   # HTML 내용을 응답으로 반환
#'   return(list(content = html_content))
#' }

#' @get /markdown
function(req) {
  # 사용자가 전달한 userid 값 가져오기
  userid <- req$QUERY$userid
  
  # R Markdown 파일 경로
  rmd_file <- "D:/Team-Proj/Team-r/user_report.Rmd"
  
  # R Markdown 파일 내용 읽기
  rmd_content <- readLines(rmd_file, warn = FALSE)
  
  # title에 userid 값 삽입
  for (i in seq_along(rmd_content)) {
    if (grepl("^title:", rmd_content[i])) {
      rmd_content[i] <- paste0("title: \"user_report - ", userid, "\"")
      break
    }
  }
  
  # 수정된 R Markdown 파일 내용을 HTML로 렌더링하여 문자열로 저장
  html_content <- rmarkdown::render(input = paste(rmd_content, collapse="\n"), output_format = "html_document")
  
  # HTML 내용을 응답으로 반환
  return(list(content = html_content))
}


# R문서 실행시킬 수 있는 값으로 응답하는 함수
#' @get /htmlfile
function() {
  html_file_path <- "D:/Team-Proj/Team-r/user_report.html"
  html_content <- readLines(html_file_path, warn = FALSE)
  return(list(content = paste(html_content, collapse="\n")))
}


# CORS 에러 해결해주는 함수
#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}