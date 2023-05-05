geo_schools <- read_rds("data/geocoded_wi_schools_2022-23.rda")
s <- schools |> 
  filter(school_year == "2021-22")

m <- geo_schools |> 
  filter(!dpi_true_id %in% s$dpi_true_id)

geo_schools_fixed <- read_csv("../000_data_temp/geocoded_mke_schools.csv")


w_fixed <- m |> 
  left_join(geo_schools_fixed |> 
              left_join(schools |> filter(school_year == "2020-21") |> 
                          select(dpi_true_id, school_name)) |> 
              select(dti = dpi_true_id,
                     school_name)) |> 
  filter(!is.na(dti)) |> 
  mutate(dpi_true_id = dti) |> 
  select(-dti)

new <- bind_rows(w_fixed, 
          geo_schools |> 
            filter(!dpi_true_id %in% w_fixed$dpi_true_id))

saveRDS(new, "data/geocoded_wi_schools_fixed.rda")
