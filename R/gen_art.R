gen_art <- function(starts_data, start_poly, steps = 2) {
  
  pb <- progress_estimated(steps)
  
  data <- starts_data
  poly <- start_poly
  
  for (i in seq_len(steps)) {
    pb$tick()$print()
    sample_id <- sample(x = data$id, prob = str_length(data$id) ^ 4, size = 1)
    
    cut_line <- sep_line(data = data, id_match = sample_id)
    
    data <- cut_line$data
    
    poly <- poly_cut(poly = poly, 
                     sep_line_info = cut_line$line, 
                     id_match = sample_id)
    
    check_points <- in.out(
      bnd = filter(poly, id == paste0(sample_id, "1"))[, 1:2] %>% as.matrix(), 
      x = filter(data, id == paste0(sample_id, "1"))[1, 1:2] %>% as.matrix()
    )
    
    if(!check_points) {
      poly <- poly %>%
        mutate(id = case_when(id == paste0(sample_id, "1") ~ paste0(sample_id, "2"),
                              id == paste0(sample_id, "2") ~ paste0(sample_id, "1"),
                              TRUE ~ id))
    }
  }
  poly
}