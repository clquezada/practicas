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
#@param CondepC: nombre de la columna que contiene los valores de Carbono de Condep
#@param CondepN: nombre de la columna que contiene los valores de Nitrogeno de Condep
#@function sources(): devuelve una lista de lista con la media y desviacion estandar de carbono y nitrogeno de todos los sources.
#@function teft(): devuelve una lista con la media y desviacion estandar de carbono y nitrogeno de los valores teft de todos los sources.
#@function Condep(): devuelve una lista con los valores de carbono y nitrogeno de los valores Concdep de todos los sources 
#@function meanSD(): crea valores aleatorios con una media y desviacion estandar dada.

#librerias necesarias:
  # library(tRophicPosition)
  # library(readxl)
  # library(tidyverse)
  # library(xlsx)


SimmrtoTP<-function(df="geese_data.xls",
                    numpestanatotal=4,
                    columnCc="d13C_Pl",
                    columnNc="d15N_Pl",
                    ubipestcolumnCN=1,
                    Sources=c("Zostera","Grass","Enteromorpha","U.lactuca"),
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
                    sdteftcolumnN= "SDd15N",
                    CondepC="d13CPl",
                    CondepN="d15NPl"
                  
                    
  
                    )
  
{
  
#ruta del archivo 
 ruta= system.file("extdata",df, package = "simmr")
  ruta


#creo una lista con las pestañas del archivo excel, el nombre de la lista "datos"
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
 # de la lista "datos" selecciono las columnas de Carbono y nitrogeno y las asigno a la variable CN
  CN<-select(datos[[ubipestcolumnCN]],columnCc,columnNc)
 # definimos la funcion sources que esta encargada de devolver una lista de listas con la media y desviacion estandar de carbono y nitrogeno de todos los sources correspondientes.
 # como argumentos recibe la lista de datos, un array con los sources, la columna donde se ubican esos sources y la pestana del excel en la cual se localizan.
 
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
 
  #llamamos a la funcion sources y el resultado se lo asignamos a la variable "recursos"
 recursos<-sources(datos,Sources,columnSources,ubipestcolumnSources)
 
 
 
 
  # definimos la funcion teft que devuelve una lista con la media y desviacion estandar de carbono y nitrogeno de los valores teft de todos los sources.
 # como argumentos recibe la lista de datos, un array con los sources, la columna donde se ubican esos sources y la pestana del excel en la cual se localizan los teftsources.
 
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
  #llamamos a la funcion teft y el resultado se lo asignamos a la variable "rec"
 rec<-teft(datos,Sources,columnSources,ubipestTefs)
 
   # definimos la funcion Condep que devuelve una lista con los valores de carbono y nitrogeno de los valores Concdep de todos los sources.
  # como argumentos recibe la lista de datos, un array con los sources, la columna donde se ubican esos sources y la pestana del excel en la cual se localizan los ConcDep.
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
 #llamamos a la funcion Condep y el resultado se lo asignamos a la variable "condep"
 condep<-Condep(datos,Sources,columnSources,ubipestConcDep)
 
 #verificamos que las columnas Mean (Carbono y Nitrogeno) y SD (Carbono Y Nitrogeno)se encuentren en la pestaña de sources y teft
 
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
 
 if(!has_element(names(condep[[1]]), CondepC))
 {
   stop("Columna ",  CondepC, " no existe en la pestaña ", ubipestConcDep, " del archivo" )
   return (NULL)
 }
 if(!has_element(names(condep[[1]]), CondepN))
 {
   stop("Columna ",  CondepN, " no existe en la pestaña ", ubipestConcDep, " del archivo" )
   return (NULL)
 }
 
 #Funcion MEAN SD encargada de generar datos aleatorios con una media y desviacion estandar dada.
 meanSD <- function(x, mean, sd) {
   
   
   x <- stats::rnorm(x, mean, sd)
   X <- x
   MEAN <- mean
   SD <- sd
   Z <- (((X - mean(X, na.rm = TRUE))/sd(X, na.rm = TRUE))) * SD
   MEAN + Z
 }
 
 #localizo la pocision de carbono y nitrogeno de Mean y SD
  positionMeanC=which(names(recursos[[1]])== meancolumnC)
  positionSDC=which(names(recursos[[1]])==sdcolumnC)
  positionMeanN=which(names(recursos[[1]])==meancolumnN)
  positionSDN=which(names(recursos[[1]])==sdcolumnN)
  #genero variables segun la cantidad de sources ingresadas.
  var_names <- paste("dNb", 1:length(Sources), sep="")
  var_names2 <- paste("dCb", 1:length(Sources), sep="")
  var_names3 <- paste("deltaNb", 1:length(Sources), sep="")
  var_names4 <- paste("deltaCb", 1:length(Sources), sep="")
  var_names5 <- paste("ConcDepCb", 1:length(Sources), sep="")
  var_names6 <- paste("ConcDepNb", 1:length(Sources), sep="")
  
  superdata<-list()
 
  
  for (i in 1:length(Sources))
  {
    #asignacion a dNb
   
  superdata[var_names[i]]<-list(meanSD(25,recursos[[i]][,positionMeanN],recursos[[i]][,positionSDN]))
  
    #asignacion a dCb
  
  superdata[var_names2[i]]<-list(meanSD(25,recursos[[i]][,positionMeanC],recursos[[i]][,positionSDC]))
   
        
    
    #asignacion a deltaN
  
  superdata[var_names3[i]]<-list(meanSD(25,rec[[i]][, positionMeanN],rec[[i]][,positionSDN]))
    
  
    
 
    #asignacion a deltac
  
  superdata[var_names4[i]]<-list(meanSD(25,rec[[i]][, positionMeanC],rec[[i]][,positionSDC]))
    
    
  
    #asignacion a ConcDepC
  superdata[var_names5[i]]<-list(c(condep[[i]][, CondepC])) 
  
  #asignacion a ConcDepN
  superdata[var_names6[i]]<-list(c(condep[[i]][, CondepN])) 
  }
  
  #agregar Carbono y Nitrogeno
 superdata$dNc<-CN[,2]
 superdata$dCc<-CN[,1]
  #atributos
 attr(superdata,"class")<-"isotopeData"
 attr(superdata,"consumer")<-"consumer"
 
 var_names7 <- paste("baseline", 1:length(Sources), sep="")
 for (i in 1:length(Sources))
 {
   #atributo baseline
   attr(superdata,var_names7[i])<-Sources[i]
 }
 
  return(superdata)
 
}
