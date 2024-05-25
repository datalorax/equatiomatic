#' Display equations in shiny apps
#' 
#' `r lifecycle::badge("experimental")`
#' These are a set of functions designed to help render equations in 
#' [shiny][shiny] applications (see the vignette about Shiny).
#'
#' @param expr An R expression, specifically a call to [extract_eq()]
#' @param outputId The identifier of the output from the server. Should be
#'   passed as a string.
#' @param env The environment
#' @param quoted Is the expresion quoted?
#' @param outputArgs list of output arguments
#' 
#' @return Render the equation in a suitable way for Shiny for [renderEq()] in
#'   an [eqOutput()] equation output element that can be included in a panel.
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
