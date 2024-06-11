library(tidyverse)
library(sf)
library(wisconsink12)

mke <- st_read("../shapefiles/Milwaukee/City Limits/citylimit.shp")

leges_sf <- read_rds("data/electeds_with_sf_2024.rda") |> 
  filter(title != "Mayor")

may <- read_csv("data/electeds_june_2024.csv") |> 
  filter(house %in% "City of Milwaukee") |> 
  transmute(title,
            district,
            name,
            party_aff,
            official_phone,
            official_email,
            house)


electeds_sf <- mke |> 
  transmute(house = "City of Milwaukee",
            geometry) |> 
  left_join(may) |> 
  st_transform(crs = st_crs(leges_sf)) |> 
  bind_rows(leges_sf |> 
              mutate(district = as.character(district))) |> 
  mutate(official_phone = str_remove(official_phone, "^\\(") |> 
           str_replace("\\) ", "-") |> 
           str_trim())


saveRDS(electeds_sf, "data/electeds_with_sf_2024.rda")

file.copy("data/electeds_with_sf_2024.rda", "../school_profiles/data", overwrite = TRUE)
file.copy("data/electeds_with_sf_2024.rda", "../school_reps_shiny", overwrite = TRUE)
