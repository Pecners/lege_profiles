library(tigris)
library(tidyverse)
library(sf)
library(cityforwardcollective)
library(glue)

wi <- counties(state = "WI") %>%
  st_transform(., crs = st_crs(4326))

l <- rnaturalearth::ne_download(type = "lakes", category = "physical", scale = "large")  %>%
  st_as_sf(., crs = st_crs(4326))

gl <- l %>% 
  filter(name %in% c("Lake Michigan", "Lake Superior")) %>%
  st_union()

wi_trim <- st_difference(wi, gl)

dist |> 
  ggplot() +
  geom_sf(data = wi_trim, color = NA) +
  geom_sf(fill = cfc_darkblue, color = NA) +
  theme_void()

ggsave(filename = "../000_data_temp/jagler_district.png", background = "none")

sens <- c(
  
)

walk(sens, function(s) {
  dist <- leges_sf |> 
    filter(str_detect(name, s))
  
  dist |> 
    ggplot() +
    geom_sf(data = wi_trim, color = NA) +
    geom_sf(fill = cfc_darkblue, color = NA) +
    theme_void()
  
  ggsave(filename = glue("../000_data_temp/{s}_district.png"), 
         background = "none")
  
})
