library(tidyverse)
library(wisconsink12)
library(tigris)
library(rnaturalearth)
library(sf)


# state senate and assembly district shapefiles
wi_ass <- st_read("data/Wisconsin_Assembly_Districts_(2024)/Wisconsin_Assembly_Districts_(2024).shp")
wi_sen <- st_read("data/Wisconsin_Senate_Districts_(2024)/Wisconsin_Senate_Districts_(2024).shp")

# Get lake michigan to erase from boundaries
l <- ne_download(type = "lakes", category = "physical", scale = "large",
                 returnclass = "sf") |> 
  st_as_sf(crs = st_crs(states))

lakes <- c("Lake Michigan")

gl <- l %>%
  filter(name %in% lakes) %>%
  st_transform(crs = st_crs(wi_sen)) |> 
  st_union()

lege_sf <- wi_sen |> 
  transmute(
    district = as.numeric(OBJECTID),
    house = "Senate"
  ) |> 
  st_difference(gl) |> 
  bind_rows(
    wi_ass |> 
      transmute(
        district = as.numeric(OBJECTID),
        house = "Assembly"
      ) |> 
      st_difference(gl)
  )

# all leges
# this chunk is old, started using unified spreadsheet
# r <- read_csv("data/state_legislature_2023.csv") |> 
#   mutate(name = str_remove_all(name, " \\(i\\)"),
#          house = ifelse(title == "Senator", "Senate", "Assembly"))

reps <- read_csv("data/electeds_june_2024.csv") |> 
  filter(house %in% c("Assembly", "Senate")) |> 
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

# saveRDS(lege_named_sf, "data/leges_with_sf_2023_1.rda")

saveRDS(lege_named_sf, "data/leges_with_sf_2024.rda")

# Code from sra_pullout repo, not sure I'll need it here
#
# rep_skinny <- reps |> 
#   # select(title:name) |> 
#   filter(title == "Representative") 
# 
# cross <- read_csv("data/assembly_senate_dist_crosswalk.csv")
# 
# sen_skinny <- left_join(reps |> 
#                           filter(title == "Senator"),
#                         cross, by = c("district" = "SEN2021"))

