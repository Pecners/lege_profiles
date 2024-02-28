library(rnaturalearth)
library(glue)

mke <- places("wi") |> 
  filter(NAME == "Milwaukee")

l <- ne_download(type = "lakes", category = "physical", scale = "small")  %>%
  st_as_sf(., crs = st_crs(states))

lakes <- c("Lake Michigan")

gl <- l %>%
  filter(name %in% lakes) %>%
  st_transform(crs = st_crs(mke)) |> 
  st_union()

mke_skinny <- st_difference(mke, gl)

mke_skinny |> 
  ggplot() +
  geom_sf()


leges_sf <- read_rds("data/leges_with_sf_2023_1.rda")

these <- c("Lena Taylor")

walk(these, function(t) {
  this_lege <- leges_sf |> 
    filter(name == t)
  
  mke_skinny |> 
    ggplot() +
    geom_sf() +
    geom_sf(data = this_lege, fill = cfc_darkblue, color = NA) +
    geom_sf(fill = NA, color = cfc_orange) +
    theme_void()
  
  ggsave(glue("maps/{this_lege$name}.png"), bg = "transparent")
  
})
