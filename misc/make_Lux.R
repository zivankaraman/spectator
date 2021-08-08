library(sf)
url = "https://download.data.public.lu/resources/limites-administratives-du-grand-duche-de-luxembourg/20180806-153458/communes4326.geojson"
x = sf::read_sf(url)
y = sf::st_union(x)
sf::write_sf(y, "inst/extdata/luxembourg.geojson")
