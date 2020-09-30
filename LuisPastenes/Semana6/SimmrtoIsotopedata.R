classfunction<-function(datos=x,
                        corrections="N")
{
  
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
  
  if(datos$n_sources>2)
    
  {
    stop("no se aceptan datos simmr_input con mas de 2 sources")
    return (NULL)
  }
 
  dCc<-datos$mixtures[,1]
  dNc<-datos$mixtures[,2]
  
  if(corrections=="N")
  {
    if(datos$n_sources==2)
    {
      
      dNb1<-c(datos$source_means[1,2]+datos$source_sds[1,2],datos$source_means[1,2]-datos$source_sds[1,2] )
      dCb1<-c(datos$source_means[1,1]+datos$source_sds[1,1],datos$source_means[1,1]-datos$source_sds[1,1] )
      
      dNb2<-c(datos$source_means[2,2]+datos$source_sds[2,2],datos$source_means[2,2]-datos$source_sds[2,2] )
      dCb2<-c(datos$source_means[2,1]+datos$source_sds[2,1],datos$source_means[2,1]-datos$source_sds[2,1] )
      
      superdata<-list(dNb1=dNb1,dCb1=dCb1,dNb2=dNb2,dCb2=dCb2,dNc=dNc,dCc=dCc)
      
      attr(superdata,"class")<-"isotopeData"
      attr(superdata,"consumer")<-"consumer"
      attr(superdata,"baseline1")<-datos$source_names[1]
      attr(superdata,"baseline2")<-datos$source_names[2]
    }
    
    if(datos$n_sources==1)
    {
      dNb1<-c(datos$source_means[1,2]+datos$source_sds[1,2],datos$source_means[1,2]-datos$source_sds[1,2] )
      dCb1<-c(datos$source_means[1,1]+datos$source_sds[1,1],datos$source_means[1,1]-datos$source_sds[1,1] )
      
      superdata<-list(dNb1=dNb1,dCb1=dCb1,dNc=dNc,dCc=dCc)
      
      attr(superdata,"class")<-"isotopeData"
      attr(superdata,"consumer")<-"consumer"
      attr(superdata,"baseline1")<-datos$source_names[1]
      
    }
    
    
    
  }
  
  if(corrections=="S")
  {
    
    if(datos$n_sources==2)
    {
      
      dNb1<-c(datos$source_means[1,2]+datos$source_sds[1,2]+datos$correction_means[1,2]+datos$correction_sds[1,2],
              datos$source_means[1,2]-datos$source_sds[1,2]++datos$correction_means[1,2]-datos$correction_sds[1,2] )
      dCb1<-c(datos$source_means[1,1]+datos$source_sds[1,1]+datos$correction_means[1,1]+datos$correction_sds[1,1],
              datos$source_means[1,1]-datos$source_sds[1,1]+datos$correction_means[1,1]-datos$correction_sds[1,1])
      
      dNb2<-c(datos$source_means[2,2]+datos$source_sds[2,2]+datos$correction_means[2,2]+datos$correction_sds[2,2],
              datos$source_means[2,2]-datos$source_sds[2,2]++datos$correction_means[2,2]-datos$correction_sds[2,2] )
      dCb2<-c(datos$source_means[2,1]+datos$source_sds[2,1]+datos$correction_means[2,1]+datos$correction_sds[2,1],
              datos$source_means[2,1]-datos$source_sds[2,1]+datos$correction_means[2,1]-datos$correction_sds[2,1])
      
     
      
      superdata<-list(dNb1=dNb1,dCb1=dCb1,dNb2=dNb2,dCb2=dCb2,dNc=dNc,dCc=dCc)
      
      attr(superdata,"class")<-"isotopeData"
      attr(superdata,"consumer")<-"consumer"
      attr(superdata,"baseline1")<-datos$source_names[1]
      attr(superdata,"baseline2")<-datos$source_names[2]
    }
    
    if(datos$n_sources==1)
    {
      dNb1<-c(datos$source_means[1,2]+datos$source_sds[1,2]+datos$correction_means[1,2]+datos$correction_sds[1,2],
              datos$source_means[1,2]-datos$source_sds[1,2]++datos$correction_means[1,2]-datos$correction_sds[1,2] )
      dCb1<-c(datos$source_means[1,1]+datos$source_sds[1,1]+datos$correction_means[1,1]+datos$correction_sds[1,1],
              datos$source_means[1,1]-datos$source_sds[1,1]+datos$correction_means[1,1]-datos$correction_sds[1,1])
      
      superdata<-list(dNb1=dNb1,dCb1=dCb1,dNc=dNc,dCc=dCc)
      
      attr(superdata,"class")<-"isotopeData"
      attr(superdata,"consumer")<-"consumer"
      attr(superdata,"baseline1")<-datos$source_names[1]
      
    }
    
    
    
    
    
  }
  
  
  
  
  
  
 
  return(superdata)
}

nom<-classfunction(datos=x,corrections = "S")
nom
plot(nom)
