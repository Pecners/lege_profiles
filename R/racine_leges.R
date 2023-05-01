library(tidyverse)
library(wisconsink12)
library(tigris)
library(sf)

# all wisconsin schools geocoded
geo_schools <- read_rds("../wi_schools/data/geocoded_wi_schools_2022-23.rda")
leges_sf <- read_rds("data/leges_with_sf_2023.rda")

# get districts that overlap with Racine County

wi_counties <- counties("WI", year = 2022)

rac <- wi_counties |> 
  filter(NAME == "Racine")

rac_leges <- st_join(leges_sf, rac, left = FALSE)

rac_leges |> 
  filter(house == "Senate") |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = rac, color = "red", fill = NA, linetype = 2)

