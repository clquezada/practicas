Obtener_IDS <- function(file){

  Archivo <- readLines(file)
  g <- grep(">", Archivo, value= TRUE)
  g
  write.table(g, file="IDS_ALL.fasta", row.names = F, quote = F, col.names=FALSE)

}


Obtener_IDS_Actualizacion <- function(file){
  
  Archivo <- readLines(file)
  g <- grep(">", Archivo, value= TRUE)
  g
  write.table(g, file="IDS_GB_Actualizacion.fasta", row.names = F, quote = F, col.names=FALSE, )
  
}





