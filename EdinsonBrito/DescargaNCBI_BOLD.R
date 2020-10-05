#definimos la direccion en donde trabajar
setwd("/home/claudio/Escritorio/BaseFinal")
#cargamos la libreria PrimerMiner, esto permitira descargar en primera instancia la base de datos completa (la BOLD,NCBI y juntarlas)
library("PrimerMiner")
setwd("PrimerMiner-master/Sample_Data")
batch_config("config.txt") #se crea la configuracion, sin consultas, esto permite descargar todos los archivos de la base de datos

batch_download("taxa_small.csv", "config.txt") # aca estamos descargando la base de datos completa desde bold y ncbi

#Llamamos ala funcion Query_Fecha que permite obtener la fecha actual y 1 mes antes, con el fin de mantenter el margen de la base ncbi
Query = Query_Fecha()
#con la funcion config_act creamos los parametros de descarga para la actualizacion mensual de la base de datos
config_act("act_config.txt", Query)

# Esta funcion solo descarga la actualizacion mensual de la base de datos GB
# las guarda con el nombre "Taxon"_GB_Act.fasta para que no sea igual que el original que descarga
Nombre = Actualizacion_ncbi("taxa_small.csv", "act_config.txt") 

Subfamilia = Nombre[[2]]
Familia = Nombre[[1]]
wd= "/home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/"
Vsearch(Familia, Subfamilia, wd)

setwd("/home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data")
#descargamos la taxonomia de NCBI
#Comentario CQR: Hay que guardar en un registro la fecha de la descarga de la taxonomía, para ver si vale la pena descargarla de nuevo
#Al descargarla envía este error: "In dir.create("NCBI_Taxon") : 'NCBI_Taxon' ya existe"
Descarga_NCBI_Taxon()

#script que permite obtener la taxonomia solo de los datos solicitados
wd= "/home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/"
NCBI_Taxon(Familia,Subfamilia, wd)

