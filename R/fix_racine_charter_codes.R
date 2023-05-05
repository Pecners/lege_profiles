joined <- st_join(geo_schools, leges_sf)

t <- joined |> 
  mutate(dpi_true_id = case_when(
    school_name == "21st Century Preparatory School" ~ "8010_8110",
    school_name == "Kenosha High School of Technology" ~ "8029_8154",
    TRUE ~ dpi_true_id)) |> 
  filter(name %in% rac_leges$name) |> 
  select(dpi_true_id:organisation_type) |> 
  unique() |> 
  left_join(enrollment |> 
              filter(group_by == "All Students" & school_year == "2022-23") |> 
              select(dpi_true_id, student_count)) |> 
  filter(is.na(student_count))

t |> 
  mutate(dpi_true_id = case_when(school_name == "21st Century Preparatory School" ~ "8110_0100",
                                 school_name == "Kenosha High School of Technology" ~ "8029_8154",
                                 TRUE ~ dpi_true_id))

geo_schools |> 
  filter(dpi_true_id == "0000_8722") |> 
  ggplot() +
  geom_sf(data = rac) +
  geom_sf() 
