data_gen_polygon <- function(polygon, n, type = "uniform", tolerance = 0.1, 
                             centers = NULL, ...) {
  
  out_x <- numeric()
  out_y <- numeric()
  
  x_range <- range(starting_polygon$x)
  y_range <- range(starting_polygon$y)
  
  if(type == "uniform") {
    x_gen_fun <- function(n) runif(n = n, min = x_range[1], max = x_range[2])
    y_gen_fun <- function(n) runif(n = n, min = y_range[1], max = y_range[2])
  }
  if(type == "normal") {
    if(is.null(centers)) {
      x_mid <- mean(starting_polygon$x)
      y_mid <- mean(starting_polygon$y)
      warning(paste0("This type requires specified centers. \n",
                     "midcoordinates are set to (", x_mid, ", ", y_mid, ")."))
    } else {
      x_mid <- centers[1]
      y_mid <- centers[2]
    }
    x_gen_fun <- function(n) rnorm(n = n, mean = x_mid, ...)
    y_gen_fun <- function(n) rnorm(n = n, mean = y_mid, ...)
  }
    
  
  x <- x_gen_fun(n)
  y <- y_gen_fun(n)
  
  which <- in.out(
    bnd = as.matrix(starting_polygon[, 1:2]),
    x = cbind(x, y)
  )
  
  hitrate <- mean(which)
  
  out_x <- c(out_x, x[which])
  out_y <- c(out_y, y[which])
  
  while(length(out_x) < n) {
    n_sim <- ceiling((n - length(out_x)) / hitrate * (1 + tolerance))
    x <- x_gen_fun(n_sim)
    y <- y_gen_fun(n_sim)
    
    which <- in.out(
      bnd = as.matrix(starting_polygon[, 1:2]),
      x = cbind(x, y)
    )
    out_x <- c(out_x, x[which])
    out_y <- c(out_y, y[which])
  }
  data.frame(X = out_x[seq_len(n)],
             Y = out_y[seq_len(n)],
             id = "1", 
             stringsAsFactors = FALSE)
}