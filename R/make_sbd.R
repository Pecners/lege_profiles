library(tidyverse)
library(sf)
library(wisconsink12)

leges_sf <- read_rds("data/electeds_with_sf_2023.rda") |> 
  filter(title != "Director")

sbd <- st_read("data/schoolboarddistricts2022/SchoolboardDistricts2022.shp") |> 
  mutate(SCHOOL = as.character(SCHOOL))

mke <- st_read("../shapefiles/Milwaukee/City Limits/citylimit.shp")
mke <- st_transform(mke, st_crs(sbd))
al <- tibble(
  SCHOOL = "At-Large",
  geometry = mke$geometry
)
sbdal <- bind_rows(sbd, al)

sbds <- tribble(
  ~district, ~title, ~name,
  "1", "Alderwoman", "Marva Herndon",
  "2", 	"Alderman", "Erika Siemsen",
  "3", "Alderman", "Darryl L. Jackson",
  "4", 	"Alderman", "Aisha Carr"	,
  "5", 	"Alderman", "Jilly Gokalgandhi"	,
  "6", 	"Alderwoman", "Marcela (Xela) Garcia",
  "7", 	"Alderman", "Henry Leanard",	
  "8", 	"Alderwoman", "Megan O'Halloran",	
  "At-Large", 	"Alderwoman", "Missy Zombor"	,
)

electeds_sf <- sbdal |> 
  transmute(district = SCHOOL,
         geometry) |> 
  left_join(sbds) |> 
  mutate(house = "MPS School Board",
         title = "Director") |> 
  st_transform(crs = st_crs(leges_sf)) |> 
  bind_rows(leges_sf |> 
              mutate(district = as.character(district)))

saveRDS(electeds_sf, "data/electeds_with_sf_2023.rda")
