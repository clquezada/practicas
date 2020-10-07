#@classfunction
#
#toma una lista de la clase Simmr_input y la devuelve en formato IsotopeData
#@param datos: lista en formato Simmr_input.
#Function meanSD(): crea valores aleatorios con una media y desviacion estandar dada.

classfunction<-function(datos=x)
{
  #Funcion MEAN SD
  meanSD <- function(x, mean, sd) {
    
    set.seed(seed = 3)
    x <- stats::rnorm(x, mean, sd)
    X <- x
    MEAN <- mean
    SD <- sd
    Z <- (((X - mean(X, na.rm = TRUE))/sd(X, na.rm = TRUE))) * SD
    MEAN + Z
  }
  
  
  
  
  
  
  
  
  
  if(!is.list(datos))
  {
    stop("el argumento ingresado no es una lista")
    return (NULL)
  }
  
  if(!class(datos)=="simmr_input")
  {
    stop("el argumento ingresado no pertenece a la clase simmr_input")
    return (NULL)
  }
  
  if(datos$n_sources<=0)
    
  {
    stop("la lista no contiene sources")
    return (NULL)
  }
  
  
  superdata<-list()
  
  var_names <- paste("dNb", 1:datos$n_sources, sep="")
  var_names2 <- paste("dCb", 1:datos$n_sources, sep="")
  var_names3 <- paste("deltaNb", 1:datos$n_sources, sep="")
  var_names4 <- paste("deltaCb", 1:datos$n_sources, sep="")
  for (i in 1:datos$n_sources)
  {
    superdata[var_names[i]]<-list(meanSD(25,datos$source_means[i,2],datos$source_sds[i,2]))
    
    superdata[var_names2[i]]<-list(meanSD(25,datos$source_means[i,1],datos$source_sds[i,1]))
    
    superdata[var_names3[i]]<-list(meanSD(25,datos$correction_means[i,2],datos$correction_sds[i,2]))
    
    superdata[var_names4[i]]<-list(meanSD(25,datos$correction_means[i,1],datos$correction_sds[i,1]))
    
  }
  
  superdata$dNc<-datos$mixtures[,2]
  superdata$dCc<-datos$mixtures[,1]
  
  attr(superdata,"class")<-"isotopeData"
  attr(superdata,"consumer")<-"consumer"
  
  var_names7 <- paste("baseline", 1:datos$n_sources, sep="")
  for (i in 1:datos$n_sources)
  {
    attr(superdata,var_names7[i])<-datos$source_names[i]
  }
  
  
  return(superdata)
}
