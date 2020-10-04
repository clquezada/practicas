#@classfunction2
#
#toma una lista de la clase IsotopeData y la devuelve en formato Simmr_input
#@param datos: lista en formato isotopeData.
#Function meanSD(): crea valores aleatorios con una media y desviacion estandar dada.

classfunction2<-function(datos=juju)
{
  if(!is.list(datos))
  {
    stop("el argumento ingresado no es una lista")
    return (NULL)
  }
  if(!class(datos)=="isotopeData")
  {
    stop("el argumento ingresado no pertenece a la clase isotopeData")
    return (NULL)
  }
  #calculando la cantidad de sources
  cont2<-attributes(datos)
  cont<-names(cont2)
  cantsources=0
  for (i in 1:length(cont))
  {
    if(substr(cont[i],1,8)=="baseline")
    {
      cantsources=cantsources+1
    }
  }
  #listaa
  superdata<-list()
  
  #mixtures
  superdata$mixtures<-matrix(c(datos$dCc,datos$dNc),nrow = length(datos$dCc),ncol = 2)
  colnames(superdata$mixtures)<-c("d13C","d15N")
  
  #source_names
  source_names=c()
  sources <- paste("baseline", 1:cantsources, sep="")
  for (i in sources)
  {
    source_names=append(source_names,cont2[[i]])
  }
  superdata$source_names<-source_names
  #source means y source sd
  
  source_means=matrix(ncol=2,nrow=cantsources)
  source_sds=matrix(ncol=2,nrow=cantsources)
  correction_means=matrix(ncol=2,nrow=cantsources)
  correction_sds=matrix(ncol=2,nrow=cantsources)
  concentration_means=matrix(ncol=2,nrow=cantsources)
  
  
  var_names <- paste("dNb", 1:cantsources, sep="")
  var_names2 <- paste("dCb", 1:cantsources, sep="")
  var_names3 <- paste("deltaNb", 1:cantsources, sep="")
  var_names4 <- paste("deltaCb", 1:cantsources, sep="")
  
  
  for(i in 1:cantsources)
  {
    
    #souce_means
    source_means[i,2]=mean(datos[[var_names[i]]])
    source_means[i,1]=mean(datos[[var_names2[i]]])
    #source_sds
    source_sds[i,2]=sd(datos[[var_names[i]]])
    source_sds[i,1]=sd(datos[[var_names2[i]]])
    
    #corrections_means
    correction_means[i,2]=mean(datos[[var_names3[i]]])
    correction_means[i,1]=mean(datos[[var_names4[i]]])
    #corrections_sds
    correction_sds[i,2]=sd(datos[[var_names3[i]]])
    correction_sds[i,1]=sd(datos[[var_names4[i]]])
    #concentration_means
    
    concentration_means[i,2]=1
    concentration_means[i,1]=1
  }
  
  superdata$source_means<-source_means
  superdata$source_sds<-source_sds
  superdata$correction_means<-correction_means
  superdata$correction_sds<-correction_sds
  superdata$concentration_means<-concentration_means
  colnames(superdata$correction_means)<-c("d13C","d15N")
  colnames(superdata$correction_sds)<-c("d13C","d15N")
  
  #group
  lplp<-rep(1,nrow(superdata$mixtures))
  superdata$group<-factor(lplp)
  superdata$group_int<-c(lplp)
  superdata$n_obs<-nrow(superdata$mixtures)
  superdata$n_tracers<-2
  superdata$n_sources<-cantsources
  superdata$n_groups<-1
  
  attr(superdata,"class")<-"simmr_input"
  
  return(superdata)
}
