library(tidyverse)
library(sf)
library(wisconsink12)

leges_sf <- read_rds("data/leges_with_sf_2023.rda")

ald <- st_read("data/alderboundaries2024/AlderBoundaries2024.shp")

alds <- tribble(
    ~district, ~title, ~name,
    1, "Alderwoman", "Andrea Pratt",
    2, 	"Alderman", "Mark Chambers Jr.",
    3, "Alderman", "Jonathan Brostoff",
    4, 	"Alderman", "Robert Bauman"	,
    5, 	"Alderman", "Lamont T. Westmoreland"	,
    6, 	"Alderwoman", "Milele A. Coggs",
    7, 	"Alderman", "Khalif J. Rainey",	
    8, 	"Alderwoman", "JoCasta Zamarripa",	
    9, 	"Alderwoman", "Larresa Taylor"	,
    10, 	"Alderman", "Michael J. Murphy",	
    11, 	"Alderman", "Mark A. Borkowski"	,
    12, 	"Alderman", "José G. Pérez"	,
    13, 	"Alderman", "Scott Spiker"	,
    14, 	"Alderwoman", "Marina Dimitrijevic",	
    15, 	"Alderman", "Russell W. Stamper"
)

electeds_sf <- ald |> 
  select(district = DISTRICT,
         geometry) |> 
  mutate(house = "Common Council") |> 
  left_join(alds) |> 
  st_transform(crs = st_crs(leges_sf)) |> 
  bind_rows(leges_sf)

saveRDS(electeds_sf, "data/electeds_with_sf_2023.rda")
