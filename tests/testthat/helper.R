equation_class <- function(x) {
  class(x) <- c("equation", "character")
  x
}

# remove all white space from the equation so the tests focus on the important
# parts of the equation generator
rm_ws <- function(x) {
  gsub("\\s", "", x)
}
