#' Display equations in shiny apps
#' 
#' \Sexpr[results=rd, stage=render]{rlang:::lifecycle("experimental")}
#' 
#' These are a set of functions designed to help render equations in 
#' [shiny][shiny] applications. For a complete example see
#'
#' @param expr An R expression, specifically a call to [extract_eq()]
#' @param outputId The identifier of the output from the server. Should be
#'   passed as a string.
#' @param env The environment
#' @param quoted Is the expresion quoted?
#' @param outputArgs list of output arguments
#' @export
#' 

#' @describeIn renderEq Rendering function
renderEq <- function(expr, env = parent.frame(), quoted = FALSE, outputArgs = list()) {
  installExprFunction(expr = expr, name = "func", eval.env = env, quoted = quoted)
  createRenderFunction(func = func, function(value, session, name, ...) {
    as.character(withMathJax(format.equation(x = value)))
  }, eqOutput, outputArgs)
}

#' @describeIn renderEq Output function
#' @export
eqOutput <- function(outputId) {
  htmlOutput(outputId = outputId)
}
