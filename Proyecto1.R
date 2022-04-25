#Cargo paquetes
pacman::p_load(rnaturalearth, rnaturalearthdata,sp,dplyr,readxl,tidyverse,tmap,viridis,ggplot2,sf,mapview,leafpop,tmaptools,spdep)

#Abro ayuda de rnaturaleartg
vignette("rnaturalearth", package = "rnaturalearth")

#creo dataframe de los países y se plotea
world = ne_countries(scale='medium', type='map_units',returnclass = "sf")
sp::plot(ne_countries())

life = read_excel("data/API_SP.DYN.LE00.IN_DS2_en_excel_v2_3930593.xls", col_names=TRUE)

#Data creada para el mapview y la realización del análisis
data = merge(world[,c("name_long","economy","brk_a3")],life[,c("2020","brk_a3")], by = "brk_a3")

#Data creada para el tmap(sin Rusia ni Fiji)
data1= data[-c(60,155),]

#Se limpian las datas 
data=na.omit(data)

data1=na.omit(data1)

data1 = sf::st_make_valid(data1)

#paleta para los colores
paleta = viridis(n=length(unique(data["2020"])), direction = -1)

paleta1 = inferno(n=length(unique(data["economy"])), direction = -1)

#Se ven las dos variables que se evaluaran y como estas varían dependiendo del país. Se crea una dataframe "data1" limpiando Rusia y Fiji, ya que, se expanden por el mapa.

tmap_options(check.and.fix = TRUE)

tm_shape(data1) + tm_polygons(col = ("2020"), palette = paleta, title = "Life Expectancy")+ tm_basemap("Stamen.Watercolor") + 
  tm_shape(data1) + tm_dots( col = "economy",palette = paleta1 ,title = "Desarrollo", popup.vars = TRUE,size=0.05) 


#De esta forma se puede interactuar con el mapa para luego seleccionar cual data queremos ver y el fondo de esta, para utilizamos data.
mapview(data, zcol = "2020",layer.name = "Life Expectancy") + 
  mapview(data, zcol= "economy",layer.name = "Desarrollo")

#Imprimimos información 
head(data)
summary(data)
