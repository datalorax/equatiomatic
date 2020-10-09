#' A subset of the full 1982 High School and Beyond Survey
#'
#' This is the dataset used throughout Raudenbush & Bryk (2002). 
#'
#' @format A tibble with 7185 rows and 8 variables:
#' \describe{
#'   \item{sch.id}{An integer denoting the school identification number. There are 160 unique schools.}
#'   \item{math}{Individual students' math score.}
#'   \item{size}{The number of students in the school.}
#'   \item{sector}{A dummy variable (integer) denoting whether the school is public (sector = 0) or catholic (sector = 1). There are 90 public schools and 70 catholic.}
#'   \item{meanses}{A group-mean centered SES variable at the school level}
#'   \item{minority}{A dummy variable indicating if the student was coded as white (minority = 0) or not (minority = 1).}
#'   \item{female}{A dummy variable indicating if the student was coded as female (female = 1) or not (female = 0).}
#'   \item{ses}{A student-level composite variable indicating the students' socio-economic status.}
#' }
"hsb"
