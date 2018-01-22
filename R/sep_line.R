sep_line <- function(data, id_match) {
  fit <- data %>%
    filter(id == id_match) %>%
    kmeans_df(~ ., centers = 2)
  
  p1 <- fit$centers[1, 1:2]
  p2 <- fit$centers[2, 1:2]
  
  p1["X"]
  
  slope <- unname((p1["X"] - p2["X"]) / (p2["Y"] - p1["Y"]))
  intercept <- unname((p1["Y"] + p2["Y"]) / 2 - slope * (p1["X"] + p2["X"]) / 2)
  
  suppressWarnings(
    data <- bind_rows(
      data %>%
        filter(id == id_match) %>%
        mutate(id = paste0(id, fit$cluster)),
      data %>%
        filter(id != id_match)
    )
  )
  
  list(line = list(slope = slope, intercept = intercept), 
       data = data)
}