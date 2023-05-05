library(tidyverse)
library(wisconsink12)
library(tigris)
library(sf)
library(glue)
library(quarto)

# all wisconsin schools geocoded
geo_schools <- read_rds("data/geocoded_wi_schools_2022-23.rda")
leges_sf <- read_rds("data/leges_with_sf_2023.rda")

# get districts that overlap with Racine County

wi_places <- places("WI", year = 2022)

rac <- wi_places |> 
  filter(NAME == "Racine")

saveRDS(rac, "data/rac_cl.rda")

rac_leges <- st_join(leges_sf, rac, left = FALSE)

rac_leges |> 
  filter(house == "Senate") |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = rac, color = "red", fill = NA, linetype = 2)


walk(1:nrow(rac_leges), function(i) {
  this <- rac_leges[i,]
  
  outfile <- glue("compiled_reports/{this$title} {this$name}-District {this$district}.pdf")
  
  quarto_render(
    input = "template_report/template_report.qmd",
    execute_params = list("district" = unique(this$district),
                          "representative" = unique(this$name),
                          "honorific" = unique(this$title)),
    output_file = outfile
  )
})
