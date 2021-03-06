#SimmrtoTP
#
#recoge los datos de un archivo para generar una lista de la clase isotopeData con los datos de los consumidores y sources.
#
#@param df: dataframe que contiene datos de isótopos sin procesar, con una o más agrupaciones variables.
#el archivo necesariamente debe estar en la carpeta extdata de simmr.
#@param numpestanatotal: numero total de pestañas que contiene el archivo.
#@param columnCc: columna de carbono del consumidor.
#@param columnNc: columna de nitrogeno del consumidor.
#@param ubipestcolumnCN: indica en que pestañas se encuentran las columnas de carbono y nitrogeno de los consumidores.
#@param Sources: vector con los recursos disponibles.
#@param columnSources: columna  donde se ubican los recursos.
#@param ubipestcolumnSources: indica en que pestaña se encuentra la columna de sources.
#@param ubipestTefs: indica en que pestaña se encuentra los tefs.
#@param ubipestConcDep: indica enq ue pestaña se encuentra los concDep.
#@param meancolumnC: nombre de la columna que contiene los valores de los promedios de carbono de los sources.
#@param meancolumnN: nombre de la columna que contiene los valores de los promedios de nitrogeno de los sources.
#@param sdcolumnC: nombre de la columna que contiene los valores de las desviaciones estandar de carbono de los sources.
#@param sdcolumnN: nombre de la columna que contiene los valores de las desviaciones estandar de nitrogeno de los sources.
#@param meanteftcolumnC: nombre de la columna que contiene los valores de los promedios de carbono de los teft.
#@param meanteftcolumnN: nombre de la columna que contiene los valores de los promedios de nitrogeno de los teft.
#@param sdteftcolumnC: nombre de la columna que contiene los valores de las desviaciones estandar de carbono de los teft.
#@param sdteftcolumnN: nombre de la columna que contiene los valores de las desviaciones estandar de nitrogeno de los teft.
#librerias necesarias:
  # library(tRophicPosition)
  # library(readxl)
  # library(tidyverse)
  # library(xlsx)


library(tRophicPosition)
library(readxl)
library(tidyverse)
library(xlsx)


SimmrtoTP<-function(df="geese_data.xls",
                    numpestanatotal=4,
                    columnCc="d13C_Pl",
                    columnNc="d15N_Pl",
                    ubipestcolumnCN=1,
                    Sources=c("Zostera","Grass"),
                    columnSources="Sources",
                    ubipestcolumnSources=2,
                    ubipestTefs=3,
                    ubipestConcDep=4,
                    meancolumnC="meand13CPl",
                    meancolumnN="meand15NPl",
                    sdcolumnC="SDd13C",
                    sdcolumnN="SDd15N",
                    meanteftcolumnC="meand13CPl" ,
                    meanteftcolumnN= "meand15NPl",
                    sdteftcolumnC="SDd13C" ,
                    sdteftcolumnN= "SDd15N"
                  
                    
                    
  
                    )
  
{
 ruta= system.file("extdata",df, package = "simmr")
  ruta
  
  
  
  if( file.exists(ruta))
  {
    datos<-list()
    
   if(numpestanatotal<=length(excel_sheets(ruta)))
   {
     for (i in 1:numpestanatotal)
     {
       datos<-append(datos,list(read_xls(ruta,i)) )
     }
     for (i in 1:numpestanatotal)
     {
       datos[[i]]<-as.data.frame(datos[[i]])
     }
   }
  else
    
  {
    stop("el numero de pestañas seleccionadas es mayor al numero de pestañas que tiene el archivo ")
    return (NULL)
  }
    

    
   
  }
  else
  {
    stop("no existe ningun archivo con el nombre  ", df, "  dentro de simmr/extdata ")
    return (NULL)
  }
  
  CN<-select(datos[[ubipestcolumnCN]],columnCc,columnNc)
  
  sources<-function(datos,Sources,columnSources,ubipestcolumnSources)
  {
     if(ubipestcolumnSources<=length(excel_sheets(ruta)))
     {
       column<-names(datos[[ubipestcolumnSources]])
       
       if(has_element(column,columnSources))
       {
         data<-list()
         for(i in Sources)
         {
           dataa<-datos[[ubipestcolumnSources]] %>% filter(datos[[ubipestcolumnSources]][,columnSources] %in% i)
            data[[i]]<-dataa
         }
         
        
       }
       
       else
       {
         stop("la columna ", columnSources ," no fue encontrada en la pestaña numero " , ubipestcolumnSources , " del archivo")
         return (NULL)
       }
     }
      else
      {
        stop("el numero de pestañas seleccionadas de ubipestcolumnSources es mayor al numero de pestañas que tiene el archivo ")
        return (NULL)
      }
    
    return(data)
  }
  
 recursos<-sources(datos,Sources,columnSources,ubipestcolumnSources)
 
 
 
 
 
 
 teft<-function(datos,Sources,columnSources,ubipestTefs)
 {
   if(ubipestTefs<=length(excel_sheets(ruta)))
   {
     column<-names(datos[[ubipestTefs]])
     
     if(has_element(column,columnSources))
     {
      data<-list()
       for(i in Sources)
       {
         dataa<-datos[[ubipestTefs]] %>% filter(datos[[ubipestTefs]][,columnSources] %in% i)
         data[[i]]<-dataa
         
       }
       
       
     }
     
     else
     {
       stop("la columna ", columnSources ," no fue encontrada en la pestaña numero " , ubipestTefs , " del archivo")
       return (NULL)
     }
   }
   else
   {
     stop("el numero de pestañas seleccionadas de ubipestcolumnSources es mayor al numero de pestañas que tiene el archivo ")
     return (NULL)
   }
   
   return(data)
 }
 
 rec<-teft(datos,Sources,columnSources,ubipestTefs)
 
 
 Condep<-function(datos,Sources,columnSources, ubipestConcDep)
 {
   if( ubipestConcDep<=length(excel_sheets(ruta)))
   {
     column<-names(datos[[ ubipestConcDep]])
     
     if(has_element(column,columnSources))
     {
       data<-list()
       for(i in Sources)
       {
         dataa<-datos[[ ubipestConcDep]] %>% filter(datos[[ ubipestConcDep]][,columnSources] %in% i)
         data[[i]]<-dataa
         
       }
       
       
     }
     
     else
     {
       stop("la columna ", columnSources ," no fue encontrada en la pestaña numero " , ubipestTefs , " del archivo")
       return (NULL)
     }
   }
   else
   {
     stop("el numero de pestañas seleccionadas de ubipestcolumnSources es mayor al numero de pestañas que tiene el archivo ")
     return (NULL)
   }
   
   return(data)
 }
 
 condep<-Condep(datos,Sources,columnSources,ubipestConcDep)
 
 if(!has_element(names(recursos[[1]]),meancolumnC))
 {
    stop("Columna ", meancolumnC, " no existe en la pestaña ", ubipestcolumnSources, " del archivo" )
    return (NULL)
 }
 
 if(!has_element(names(recursos[[1]]),meancolumnN))
 {
    stop("Columna ", meancolumnN, " no existe en la pestaña ", ubipestcolumnSources, " del archivo" )
    return (NULL)
 }

 if(!has_element(names(recursos[[1]]),sdcolumnC))
 {
    stop("Columna ", sdcolumnC, " no existe en la pestaña ", ubipestcolumnSources, " del archivo" )
    return (NULL)
 }

 if(!has_element(names(recursos[[1]]),sdcolumnN))
 {
    stop("Columna ", sdcolumnN, " no existe en la pestaña ", ubipestcolumnSources, " del archivo" )
    return (NULL)
 }
 
 if(!has_element(names(rec[[1]]), meanteftcolumnC))
 {
    stop("Columna ",  meanteftcolumnC, " no existe en la pestaña ", ubipestTefs, " del archivo" )
    return (NULL)
 }
 
 if(!has_element(names(rec[[1]]), meanteftcolumnN))
 {
    stop("Columna ",  meanteftcolumnN, " no existe en la pestaña ", ubipestTefs, " del archivo" )
    return (NULL)
 }
 if(!has_element(names(rec[[1]]), sdteftcolumnC))
 {
    stop("Columna ",  sdteftcolumnC, " no existe en la pestaña ", ubipestTefs, " del archivo" )
    return (NULL)
 }
 if(!has_element(names(rec[[1]]), sdteftcolumnN))
 {
    stop("Columna ",  sdteftcolumnN, " no existe en la pestaña ", ubipestTefs, " del archivo" )
    return (NULL)
 }
 
  positionMeanC=which(names(recursos[[1]])== meancolumnC)
  positionSDC=which(names(recursos[[1]])==sdcolumnC)
  positionMeanN=which(names(recursos[[1]])==meancolumnN)
  positionSDN=which(names(recursos[[1]])==sdcolumnN)
 
 
 if(length(Sources)==2)
 {
   #estupides
   
   
  
    dCb1<-c( recursos[[1]][,positionMeanC]+ recursos[[1]][,positionSDC]+rec[[1]][, positionMeanC]+rec[[1]][,positionSDC],
             recursos[[1]][,positionMeanC]-recursos[[1]][,positionSDC]+rec[[1]][, positionMeanC]-rec[[1]][,positionSDC])
    dNb1<-c(recursos[[1]][,positionMeanN]+recursos[[1]][,positionSDN]+rec[[1]][, positionMeanN]+rec[[1]][,positionSDN],
            recursos[[1]][,positionMeanN]-recursos[[1]][,positionSDN]+rec[[1]][, positionMeanN]-rec[[1]][,positionSDN])
   
   
    dCb2<-c( recursos[[2]][,positionMeanC]+ recursos[[2]][,positionSDC]+rec[[2]][, positionMeanC]+rec[[2]][,positionSDC],
             recursos[[2]][,positionMeanC]-recursos[[2]][,positionSDC]+rec[[2]][, positionMeanC]-rec[[2]][,positionSDC])
    dNb2<-c(recursos[[2]][,positionMeanN]+recursos[[2]][,positionSDN]+rec[[2]][, positionMeanN]+rec[[2]][,positionSDN],
            recursos[[2]][,positionMeanN]-recursos[[2]][,positionSDN]+rec[[2]][, positionMeanN]-rec[[2]][,positionSDN])
    
   positionMeanC=which(names(rec[[1]])==meanteftcolumnC)
   positionSDC=which(names(rec[[1]])==sdteftcolumnC)
   positionMeanN=which(names(rec[[1]])==meanteftcolumnN)
   positionSDN=which(names(rec[[1]])==sdteftcolumnN) 
   
   deltaN<-c(rec[[1]][, positionMeanN],rec[[1]][,positionSDN])
   
   deltaC<-c(rec[[1]][, positionMeanC],rec[[1]][,positionSDC])
   
   #superdata<-list(dNc=CN[,2],dCc=CN[,1],Baselines=recursos,DeltaBases=rec,Condep=condep)
   superdata<-list(dNb1=dNb1,
                   dCb1=dCb1, 
                   dNb2=dNb2,
                   dCb2=dCb2,
                   deltaN=deltaN,
                   deltaC=deltaC, 
                   dNc=CN[,2],
                   dCc=CN[,1])
   attr(superdata,"class")<-"isotopeData"
   attr(superdata,"consumer")<-"consumer"
   attr(superdata,"baseline1")<-Sources[1]
   attr(superdata,"baseline2")<-Sources[2]
 }
 else if(length(Sources)==1)
 {
   #estupides
  
   
   dCb1<-c( recursos[[1]][,positionMeanC]+ recursos[[1]][,positionSDC]+rec[[1]][, positionMeanC]+rec[[1]][,positionSDC],
            recursos[[1]][,positionMeanC]-recursos[[1]][,positionSDC]+rec[[1]][, positionMeanC]-rec[[1]][,positionSDC])
   dNb1<-c(recursos[[1]][,positionMeanN]+recursos[[1]][,positionSDN]+rec[[1]][, positionMeanN]+rec[[1]][,positionSDN],
           recursos[[1]][,positionMeanN]-recursos[[1]][,positionSDN]+rec[[1]][, positionMeanN]-rec[[1]][,positionSDN])
   
   #rnorm(10,recursos[[1]]$meand15NPl,recursos[[1]]$SDd15N)
   

   
   positionMeanC=which(names(rec[[1]])==meanteftcolumnC)
   positionSDC=which(names(rec[[1]])==sdteftcolumnC)
   positionMeanN=which(names(rec[[1]])==meanteftcolumnN)
   positionSDN=which(names(rec[[1]])==sdteftcolumnN) 
   
   deltaN<-c(rec[[1]][, positionMeanN],rec[[1]][,positionSDN])
   
   deltaC<-c(rec[[1]][, positionMeanC],rec[[1]][,positionSDC])
  
   
   #superdata<-list(dNc=CN[,2],dCc=CN[,1],Baselines=recursos,DeltaBases=rec,Condep=condep)
   superdata<-list(dNb1=dNb1,
                   dCb1=dCb1, 
                  deltaN=deltaN,
                   deltaC=deltaC, 
                   dNc=CN[,2],
                   dCc=CN[,1])
   attr(superdata,"class")<-"isotopeData"
   attr(superdata,"consumer")<-"consumer"
   attr(superdata,"baseline1")<-Sources[1]
  
 }
 else
 {
   stop("el argumento Sources no puede ser de tamaño igual a cero o mayor que dos")
   return (NULL)
 }

 
  return(superdata)
}

