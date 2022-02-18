#' Access the DeGAUSS color palette
#'
#' @param n which DeGAUSS color(s): 1-darkblue, 2-lightblue, 3-pink, 4-lightgrey, 5-purple, 6-teal)
#'
#' @return a named character string or vector of named character strings containing RGB colors in hexadecimal
#' @export
#'
#' @examples
#' degauss_colors(2)
#' degauss_colors(1:4)
#' plot(1:6, rep(1, 6), col = degauss_colors(1:6), pch = 19, cex = 10)

degauss_colors <- function(n) {
  stopifnot(n > 0, n < 7)
  colors <- c("#072B67", "#469FC2", "#C2326B", "#E0E5E7", "#6C4370", "#83C3C3")
  return(colors[n])
}
