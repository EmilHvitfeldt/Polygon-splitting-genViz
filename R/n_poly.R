# Not working yet
n_poly <- function(n, radius = 1, center = c(0, 0), theta = 0) {
  
  x <- y <- numeric(n)
  
  for(i in seq_len(n)) {
    x[i] <- radius * cos(2 * pi * i / n + theta) + center[1]
    y[i] <- radius * sin(2 * pi * i / n + theta) + center[2]
  }
  data.frame(x = c(x, x[1]),
             y = c(y, y[1]),
             id = "1",
             stringsAsFactors = FALSE)
}