library(tidyverse)
library(sf)
library(wisconsink12)
library(tigris)

leges_sf <- read_rds("data/electeds_with_sf_2024.rda") |> 
  filter(title != "Director")

mke_county <- counties(state = "WI", cb = TRUE, resolution = "500k") |> 
  filter(NAME == "Milwaukee") |> 
  rename()

# mke_county |> 
#   ggplot() +
#   geom_sf()


sbds <- tribble(
  ~district, ~title, ~name,
  "Milwaukee County", "County Executive", "David Crowley"
)


electeds_sf <- mke_county |> 
  transmute(district = NAMELSAD,
            geometry) |> 
  left_join(sbds) |> 
  mutate(house = "Milwaukee County",
         title = "County Executive") |> 
  st_transform(crs = st_crs(leges_sf)) |> 
  bind_rows(leges_sf |> 
              mutate(district = as.character(district)))

saveRDS(electeds_sf, "data/electeds_with_sf_2024.rda")
