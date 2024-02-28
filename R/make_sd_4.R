library(mapboxapi)
library(leaflet)

dist <- leges_sf |> 
  filter(name == "Lena Taylor")

cent <- dist |> 
  st_centroid() |> 
  st_coordinates()

this <- leaflet(dist, options = leafletOptions(zoomSnap = .1,
                                               zoomControl = FALSE)) |> 
  addMapboxTiles(style_id = "light-v11",
                 username = "mapbox", 
                 scaling_factor = "0.5x") |> 
  addPolygons(weight = 2) |> 
  addPolygons(data = st_transform(mke, crs = st_crs(dist)),
              color = cfc_orange, fillOpacity = 0,
              weight = 2) |> 
  setView(lng = cent[[1]], lat = cent[[2]], zoom = 12)
this

htmlwidgets::saveWidget(this, file = "maps/Senate District 4.html")
webshot::webshot("maps/Senate District 4.html", 
                 file = "maps/Senate District 4.png",
                 cliprect = "viewport")
