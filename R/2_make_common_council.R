library(tidyverse)
library(sf)
library(wisconsink12)

leges_sf <- read_rds("data/leges_with_sf_2024.rda")

ald <- st_read("data/alderboundaries2024/AlderBoundaries2024.shp")

# started using unified spreadsheet
# alds <- tribble(
#     ~district, ~title, ~name,
#     1, "Alderwoman", "Andrea Pratt",
#     2, 	"Alderman", "Mark Chambers Jr.",
#     3, "Alderman", "Jonathan Brostoff",
#     4, 	"Alderman", "Robert Bauman"	,
#     5, 	"Alderman", "Lamont T. Westmoreland"	,
#     6, 	"Alderwoman", "Milele A. Coggs",
#     7, 	"Alderman", "DiAndre Jackson ",	
#     8, 	"Alderwoman", "JoCasta Zamarripa",	
#     9, 	"Alderwoman", "Larresa Taylor"	,
#     10, 	"Alderwoman", "Sharlene P. Moore ",	
#     11, 	"Alderman", "Peter Burgelis "	,
#     12, 	"Alderman", "José G. Pérez"	,
#     13, 	"Alderman", "Scott Spiker"	,
#     14, 	"Alderwoman", "Marina Dimitrijevic",	
#     15, 	"Alderman", "Russell W. Stamper"
# )

alds <- read_csv("data/electeds_june_2024.csv") |> 
  filter(house %in% "Common Council") |> 
  transmute(title,
            district = as.numeric(district),
            name,
            party_aff,
            official_phone,
            official_email,
            house)

lege_named_sf <- left_join(
  lege_sf,
  reps,
  by = c("district", "house")
)

electeds_sf <- ald |> 
  select(district = DISTRICT,
         geometry) |> 
  mutate(house = "Common Council") |> 
  left_join(alds) |> 
  st_transform(crs = st_crs(leges_sf)) |> 
  bind_rows(leges_sf)

saveRDS(electeds_sf, "data/electeds_with_sf_2024.rda")
