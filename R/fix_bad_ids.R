library(tidyverse)
library(wisconsink12)

geo_schools <- read_rds("../lege_profiles/data/geocoded_wi_schools_2022-23.rda")
geo2 <- read_rds("../lege_profiles/data/geocoded_wi_schools_fixed.rda")
s <- schools |> 
  filter(school_year == "2021-22")

m <- geo_schools |> 
  filter(!dpi_true_id %in% s$dpi_true_id)

geo_schools_fixed <- read_csv("../000_data_temp/geocoded_mke_schools.csv")


one <- geo_schools_fixed |> 
  left_join(schools |> filter(school_year == "2020-21") |> 
              select(dpi_true_id, school_name)) |> 
  select(dti = dpi_true_id,
         school_name)

w_fixed <- m |> 
  left_join(geo_schools_fixed |> 
              left_join(schools |> filter(school_year == "2020-21") |> 
                          select(dpi_true_id, school_name)) |> 
              select(dti = dpi_true_id,
                     school_name)) |> 
  filter(!is.na(dti)) |> 
  mutate(dpi_true_id = dti)

new <- bind_rows(w_fixed, 
          geo_schools |> 
            filter(!dpi_true_id %in% w_fixed$dpi_true_id))  |> 
  group_by(school_year, district_name, school_name, school_type) |> 
  mutate(n = n()) |> 
  ungroup() |> 
  filter(!(n > 1 & is.na(dti)))

saveRDS(new, "../000_data_temp/geocoded_wi_schools_fixed.rda")
