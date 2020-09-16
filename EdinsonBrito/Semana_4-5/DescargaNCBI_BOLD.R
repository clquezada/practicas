#definimos la direccion en donde trabajar
setwd("/home/claudio/Escritorio/BaseFinal")
#cargamos la libreria PrimerMiner, esto permitira descargar en primera instancia la base de datos completa (la BOLD,NCBI y juntarlas)
library("PrimerMiner")


setwd("PrimerMiner-master/Sample_Data")


batch_config("config.txt") #se crea la configuracion, sin consultas, esto permite descargar todos los archivos de la base de datos


batch_download("taxa_small.csv", "config.txt") # aca estamos descargando la base de datos completa desde bold y ncbi



#no fue tan necesario la funcion obtener IDS,ya que es mejor comparar las secuencias usando vsearch      
#Con la funcion Obtener_IDS sacamos las ids de la base de datos final, cosa de poder comparar solo las id y no todas las cadenas
#Obtener_IDS("Perlidae_all.fasta")



#Llamamos ala funcion Query_Fecha que permite obtener la fecha actual y 1 mes antes, con el fin de mantenter el margen de la base ncbi
Query = Query_Fecha()

#con la funcion config_act creamos los parametros de descarga para la actualizacion mensual de la base de datos
config_act("act_config.txt", Query)

# Esta funcion solo descarga la actualizacion mensual de la base de datos GB
# las guarda con el nombre "Taxon"_GB_Act.fasta para que no sea igual que el original que descarga
Nombre= Actualizacion_ncbi("taxa_small.csv", "act_config.txt") #Se descarga la actualizacion y ademas retorna el nombre  de taxon para hacer consutlas mas automaticas

#setemos la direccion en donde se encuentras los datos
setwd(paste0("/home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/",Nombre))



#comando para sacar las secuencias replicadas de la base de datos bold
system(paste0("vsearch -derep_fulllength ", Nombre,"_BOLD.fasta -output " ,Nombre,"_BOLD_derep.fasta")) 

#comando para sacar las secuencias replicadas de la base de datos GB
system(paste0("vsearch -derep_fulllength " , Nombre,"_GB.fasta -output " , Nombre,"_GB_derep.fasta")) 

#comando para sacar las secuencias replicadas de la base de datos actualizada de GB
system(paste0("vsearch -derep_fulllength " , Nombre,"_GB_Act.fasta -output " , Nombre,"_GB_Act_derep.fasta")) #comando para sacar las secuencias replicadas

#contatenamos los archivos
system(paste0("cat ", Nombre,"_BOLD_derep.fasta " , Nombre,"_GB_derep.fasta ", Nombre,"_GB_Act_derep.fasta > DB_Unida.fasta"))

#dereplicamos la base de datos que contiene todas las secuencias
system("vsearch -derep_fulllength DB_Unida.fasta -output DB_Final.fasta")

#descargamos la taxonomia de BOLD
system(paste0("wget -c http://www.boldsystems.org/index.php/API_Public/specimen?taxon=",Nombre,"&format=tsv"))

#descargamos la taxonomia de NCBI
download.file(paste0("http://www.boldsystems.org/index.php/API_Public/specimen?taxon=",Nombre,"&format=tsv"),destfile=paste0(",Nombre,_Taxom_BOLD.tsv"),method="libcurl")
download.file("ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz", destfile="taxdump.tar.gz",method="libcurl" )
system("tar -zxvf taxdump.tar.gz")
download.file("ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz", destfile="nucl_gb.accession2taxid.gz",method="libcurl" )
system("gunzip nucl_gb.accession2taxid.gz")


#script que permite obtener la taxonomia solo de los datos solicitados
system2("./Taxonomy_NCBI.sh")

#no fue tan necesario la funcion obtener IDS,ya que es mejor comparar las secuencias usando vsearch      
#Obtener_IDS_Actualizacion("Perlidae_GB_Act.fasta") #con esta funcion obtenemos los ids de la actualizacion para luego añadir a la principal





#falta crear el crontab que permita que se ejecute este .R una vez al me

