wiggle <- function(data, sd) {
  data %>%
    base::split(.$id) %>%
    map_df(~ .x %>%
             mutate(x = x + rnorm(1, sd = sd),
                    y = y + rnorm(1, sd = sd)))
}

rotate_one <- function(data, theta) {
  P <- data %>%
    .[, 1:2] %>%
    as.matrix() %>%
    t()
  
  center <- rowMeans(P)
  
  R <- matrix(c(cos(theta), sin(theta), -sin(theta), cos(theta)), nrow = 2)
  
  out <- as.data.frame(t(R %*% (P - center) + center)) %>%
    mutate(id = data$id[1])
  
  colnames(out) <- colnames(data)
  out
}

rotate <- function(data, theta) {
  data %>%
    base::split(.$id) %>%
    map2_df(.y = theta, ~ rotate_one(.x, theta = .y)) 
}