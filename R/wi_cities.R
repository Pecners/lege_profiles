library(tidycensus)

v22 <- load_variables(2021, "acs5", cache = TRUE)

wip <- get_acs(geography = "place", state = "WI", variable = "B01001_001", 
               geometry = TRUE)

lower <- c("Janesville", "Kenosha", "Waukesha")


wip10 <- wip |> 
  arrange(desc(estimate)) |> 
  head(10) |> 
  st_centroid() |> 
  mutate(NAME = str_remove(NAME, " city, Wisconsin"),
         nudge_x = case_when(
           NAME == "Milwaukee" ~ 0,
           NAME == "Racine" ~ 0,
           TRUE ~ .5
         ),
         nudge_y = case_when(
           NAME %in% lower ~ 1.75,
           TRUE ~ -.75
         ))

saveRDS(wip10, "data/wi_10_cities.rda")


