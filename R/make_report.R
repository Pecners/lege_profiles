library(tidyverse)
library(quarto)
library(glue)

leges_sf <- read_rds("data/electeds_with_sf_2023.rda")

rep <- "Jonathan Brostoff"
rind <- which(leges_sf$name == rep)
district <- leges_sf[[rind,"district"]] 
hon <- leges_sf[[rind,"title"]] 
house <- leges_sf[[rind,"house"]] 
  

quarto::quarto_render("template_report/template_report.qmd", 
                      execute_params = list("representative" = rep,
                                            "district" = district,
                                            "honorific" = hon,
                                            "house" = house), 
                      output_file = glue("{rep} - District {district}.pdf"))


dsleges_sf |> 
  filter(house == params$house & district == params$district)


leaflet(dist) |> 
  addMapboxTiles(style_id = "light-v11",
                 username = "mapbox", scaling_factor = "x") |> 
  addPolygons(weight = 2) |> 
  addPolygons(data = st_transform(mke, crs = st_crs(dist)),
              color = cfc_orange, fillOpacity = .1,
              weight = 2) |> 
  
