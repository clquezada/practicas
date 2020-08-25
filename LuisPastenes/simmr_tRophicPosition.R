# simmr
library(simmr)

# Para identificar un archivo excel de entrada
system.file("extdata", "geese_data.xls", package = "simmr")

# Para cargarlo en R
library(readxl)
path = system.file("extdata", "geese_data.xls", package = "simmr")
geese_data = lapply(excel_sheets(path), read_excel, path = path)

# La estructura del objeto geese_data
str(geese_data)

# Cada pestaña del archivo excel en un objeto por separado
targets = geese_data[[1]]
sources = geese_data[[2]]
TEFs = geese_data[[3]]
concdep = geese_data[[4]]

# Y ahora se crea un objeto simmr_input
geese_simmr = simmr_load(mixtures = as.matrix(targets[, 1:2]),
                         source_names = sources$Sources,
                         source_means = as.matrix(sources[,2:3]),
                         source_sds = as.matrix(sources[,4:5]),
                         correction_means = as.matrix(TEFs[,2:3]),
                         correction_sds = as.matrix(TEFs[,4:5]),
                         group = as.factor(paste('Day', targets$Time)
                         ))

# graficamos. Por defecto se ocupa el método plot.simmr_input 
# (si miras el código fuente del paquete simmr)
plot(geese_simmr, group = 1:8)

# tRophicPosition es algo similar
library(tRophicPosition)

# Ocupamos un archivo csv como entrada
# (Puedes importarlo en Excel para ver la estructura)
system.file("extdata", "Bilagay_for_tRophicPosition.csv", 
            package = "tRophicPosition")

# como es un archivo externo (extdata) podemos ocupar el método data
data("Bilagay")

# Y vemos la estructura
str(Bilagay)

# Y lo manipulamos un poco (hay que instalar la librería dplyr)
library(dplyr)
Bilagay <- Bilagay %>% mutate(Community = paste(Study,"-", Location, sep = ""))

# Y ordenamos según una columna
Bilagay <- Bilagay %>% arrange(NS)

# Esta función extrae los valores (en el fondo filtra los datos según la columna
# "Community")
BilagayList <- extractIsotopeData(Bilagay, b1 = "Pelagic_BL", b2 = "Benthic_BL",
                                  baselineColumn = "FG", consumersColumn = "Spp",
                                  groupsColumn = "Community",
                                  d13C = "d13C", d15N = "d15N")
# Aquí vemos la estructura
str(BilagayList)

# Y nos quedamos con el primer objeto de la lista
Coquimbo <- BilagayList[[1]]

# Y lo graficamos
plot(Coquimbo)
