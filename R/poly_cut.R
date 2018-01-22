poly_cut <- function(poly, sep_line_info, id_match) {
  inside_poly <- poly %>% 
    filter(id == id_match) %>%
    select(x, y) %>%
    as.matrix() %>%
    Polygon() %>%
    list() %>%
    Polygons(ID = "polygon") %>%
    list() %>%
    SpatialPolygons()
  
  inside_line <- cbind(c(0, 1), 
                       sep_line_info$intercept + c(0, sep_line_info$slope)) %>%
    Line() %>%
    list() %>%
    Lines(ID = "line") %>%
    list() %>%
    SpatialLines()
  
  lpi <- gIntersection(inside_poly, inside_line)
  blpi <- gBuffer(lpi, width = 0.000001)
  dpi <- gDifference(inside_poly, blpi)
  
  suppressWarnings(
    bind_rows(
      dpi@polygons[[1]]@Polygons[[1]]@coords %>%
        as.data.frame() %>%
        mutate(id = paste0(id_match, "1")),
      dpi@polygons[[1]]@Polygons[[2]]@coords %>%
        as.data.frame() %>%
        mutate(id = paste0(id_match, "2")),
      poly %>% 
        filter(id != id_match)
    )
  )
}