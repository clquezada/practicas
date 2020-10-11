#TPtoSimmr
#
#Genera una lista de objetos de la clase Simmr_Input analizando un marco de valores de isotopos estables,
#analizados para un consumidor y uno o mas lineas de baselines, el filtro puede ser una o mas Estudios, Localidades,SPP,etc.
#
#@param df: dataframe que contiene datos de isótopos sin procesar, con una o más agrupaciones variables.
#el archivo necesariamnte debe estar en la carpeta extdata de TrophicPosition
#solo se aceptan archivos con extension csv o xlsx.
#@param filtro: lista con los datos que se procederan a filtrar en el dataframe.
#@param columnass: vector con nombres de las columnas que se utilizaran para filtrar en el dataframe.
#@param mixture: consumidor a buscar en el dataframe.
#@param baselines: vector con una o mas baselinesa buscar en el dataframe.
#@param baseColumn: columna del dataframe en la cual buscar las baselines.
#@param mixtureColumn: columna del dataframe en la cual buscar el consumidor.
#@param ColumnC: columna del dataframe que contiene los isotopos d13C.
#@param ColumnN: columna del dataframe que contiene los isotopos d15N.
#@param correctionsMeans: matriz promedio con los datos de correcciones de los isotopos.
#@param correctionsSD: matriz desviacion estandar con los datos de correcciones de los isotopos.
#@param columnGroup: columna del dataframe la cual se utilizara para crear grupos.

#@function funcionData(): retorna un dataframe con los datos filtrados, la funcion se ejecutara siempre y cuando
#exista el valor buscado en la columna seleccionada, sino la funcion terminara.

#@function bases(): retorna una lista de listas, cada lista dentro de la lista contiene los datos filtrados
#por la correspondiente baseline, los valores de carbono y nitrogeno, los promedios y desviacion estandar
#de carbono y nitrogeno de los isotopos, el codigo se ejecutara siempre y cuando exista la columna
#seleccionada en el dataframe y el baseline exista en la columna.

#@function sources(): recibe como argumento la lista de bases, se encarga de retornar una lista con
#la matriz promedio y la matriz desviacion estandar de todas las baselines juntas.

#@function funcionCorrections(): crea dos matrices con las dimensiones de la media y desviacion estandar
#producidos por la funcion sources, si las filas de la matriz creada son mayores o iguales
#que la matriz ingresada por el usuario, se registran los valores en la nueva matriz, si existen valores
#NULL o NA  se cambian por los valores que entrega la funcion TDF() de Trophic Position, la matriz ingresada
#por el usuario no puede tener mas filas que la creada por la funcion.

#@return una lista de la clase Simmr_input

#librerias necesarias

# simmr
# tRophicPosition
# tidyverse
# xlsx


#argumentos de ejemplo

# filtro1="MEC"#STUDY
# #filtro2=c("Coquimbo","Tocopilla")#LOCATION
# filtro2=NULL
# filtro3=NULL  #SPP
# filtro4= NULL#NS
# lista<-list(filtro1,filtro2,filtro3,filtro4)
# 
# column1="Study"
# column2="Location"
# column3="Spp"
# column4="NS"
# columnas<-c(column1,column2,column3,column4)
# columnas
# 
# var<-matrix(ncol = 2,nrow=2) 
# var[1,1]<-8
# var[1,2]<-8
# var[2,1]<-8
# var[2,2]<-8
# 
# 
# df="Bilagay_for_tRophicPosition.csv",
# filtro=lista,
# columnass=columnas,
# mixture= "Bilagay",
# baselines=c("Pelagic_BL","Benthic_BL"),
# baseColumn="FG",
# mixtureColumn="FG",
# ColumnC="d13C",
# ColumnN="d15N",
# correctionsMeans=var,
# correctionsSD=var,
# columnGroup="Spp"

# ruta=system.file("extdata","Bilagay_for_tRophicPosition.xlsx", 
#                  package = "tRophicPosition")
# datos2<-read.xlsx(ruta,1)

TPtoSimmr<-function(datos=datos2,
                    filtro=lista,
                    columnass=columnas,
                    mixture= "Bilagay",
                    baselines=c("Pelagic_BL","Benthic_BL"),
                    baseColumn="FG",
                    mixtureColumn="FG",
                    ColumnC="d13C",
                    ColumnN="d15N",
                    correctionsMeans=var,
                    correctionsSD=var,
                    columnGroup="Spp"
                    
                    
                    
)




{
  
  
  #verificador argumentos
  
  if(!is.data.frame(datos))
  {
    stop("el argumento datos no tiene el formato DataFrame")
    return (NULL)
  }
  
  
  if(!is.matrix(correctionsMeans)||ncol(correctionsMeans)!=2)
  {
    stop("corrections means no tiene el formato matrix o el numero de columnas no es igual a 2")
    return (NULL)
  }
  if(!is.matrix(correctionsSD)||ncol(correctionsSD)!=2)
  {
    stop("corrections SD no tiene el formato matrix o el numero de columnas no es igual a 2")
    return (NULL)
  }
  
    
  
  
  #verificar columnas del filtro en el dataframe
  
  column<-names(datos)
  
  for (i in columnass)
  {
    if(!is.null(i))
    {
      
      if(!(has_element(column,i)))
      {
        
        
        stop("La columna ", i," no fue encontrada en el dataframe")
        return (NULL)
      }
    }
  }
  
  
  
  
  
  
  
  
  #funcionData es una funcion que retorna un dataframe con los filtros aplicados
  #los argumentos de la funcion son el dataframe, la variable a filtrar y en que columna se encuentra.
  
  funcionData<- function(dataframe, item, Columnas)
  {
    
    
    
    for (i in 1:length(item))
    {
      
      
      if(!is.null(item[[i]]))
        
      {
        
        
        if(any(dataframe[,Columnas[i]]  %in% item[[i]]))
        {
          
          
          # dataframe<-dataframe %>% filter(dataframe[,i]  %in% item[[i]])
          dataframe<-dataframe %>% filter(dataframe[,Columnas[i]]  %in% item[[i]])
          
          
        }
        else
        {
          stop("No se ha encontrado  ", item[[i]],"  en la columna  ", Columnas[i])
          return (NULL)
        }
        
        
        
      }
      
      
    }
    
    
    
    
    
    
    return(dataframe)
  }
 # llamamos a la funcion funcionData y el resultado lo asignamos a la variable "datos".
  datos<-funcionData(datos,filtro,columnass)
  
  
  
  
  #retorna una lista con las filas de la base seleccionada, los valores, promedio y desviacion estandar de carbono y nitrogeno
  #los argumentos que requiere esta funcion son el dataframe, el baseline, la columna donde se encuentra el baseline, el nombre de la columna de Carbono y nitrogeno.
  bases<- function(dataframe, base, baseColumn,ColumnC,ColumnN)
  {
    var<-names(dataframe)
    listaaa<-list()
    
    
    for (i in base)
    {
      
      if(has_element(var,baseColumn))
      {
        if(any(dataframe[,baseColumn]  %in% i))
        {
          data<-dataframe %>% filter(dataframe[,baseColumn] %in% i)
          CN<-select(data,ColumnC,ColumnN)
          
          promvalores<-as.numeric(summarise(CN,meand13C=mean(CN[,1]),meand15N=mean(CN[,2])))
          sdvalores<- as.numeric(summarise(CN,sdd13C=sd(CN[,1]),sdd15N=sd(CN[,2])))
          
          listaa<-list(datos=data,CarbonoNitrogeno=CN,promedio=promvalores,SD=sdvalores)
          listaaa<-append(listaaa,list(listaa))
        }
        else
          
        {
          stop("No se ha encontrado  ", i,"  en la columna  ", baseColumn)
          return (NULL)
        }
        
        
        
      }
      else
      {
        stop("La columna ", baseColumn," no fue encontrada en el dataframe")
        return (NULL)
      }
      
      
      
    }
    
    return(listaaa)
  }
  
  
  #bases
  mixture<-bases(datos,mixture,mixtureColumn,ColumnC,ColumnN)
  bases<-bases(datos,baselines,baseColumn,ColumnC,ColumnN)
  
  
  
  
  #Nombres
  
  Nombres<- baselines
  
  #sourceMeans y sourceSD
 # recibe como argumento la lista de bases, se encarga de retornar una lista con
#la matriz promedio y la matriz desviacion estandar de todas las baselines juntas.
  sources<-function(bases)
  {
    sourceMeans<-matrix(ncol = 2,nrow=length(bases))
    sourceSD<-matrix(ncol = 2,nrow=length(bases))
    
    for (i in 1:length(bases))
    {
      for (j in 1:2)
      {
        sourceMeans[i,j]<-bases[[i]][[3]][j]
        sourceSD[i,j]<-bases[[i]][[4]][j]
      }
    }
    return(list(Means=sourceMeans,SD=sourceSD))
  }
  #llamamos a la funcion sources y el resultado lo asignamos a la variable Sourcess.
  Sourcess<-sources(bases)
  
  
  
  #corrections function
  
 #crea dos matrices con las dimensiones de la media y desviacion estandar
#producidos por la funcion sources, si las filas de la matriz creada son mayores o iguales
#que la matriz ingresada por el usuario, se registran los valores en la nueva matriz, si existen valores
#NULL o NA  se cambian por los valores que entrega la funcion TDF() de Trophic Position, la matriz ingresada
#por el usuario no puede tener mas filas que la creada por la funcion.
  
  funcionCorrections<- function(correctionsMeans,correctionsSD,Sourcess)
  {
    datMeans<-matrix(nrow=nrow(Sourcess[[1]]), ncol=2)
    datSD<-matrix(nrow=nrow(Sourcess[[1]]), ncol=2)
    tdfmeans<-sapply(TDF(), mean)
    tdfsd<-sapply(TDF(), sd)
    if(nrow(datMeans)>=nrow(correctionsMeans))
    {
      for (i in 1:nrow(datMeans))
      {
        for (j in 1:ncol(datMeans))
        {
          datMeans[i,j]<-correctionsMeans[i,j]
          
          
        }
      }
    }
    else
    {
      stop("Corrections Means no puede tener mas filas que el numero de bases colocadas")
      return (NULL)
    }
    
    
    if(nrow(datSD)>=nrow(correctionsSD))
    {
      for (i in 1:nrow(datSD))
      {
        for (j in 1:ncol(datSD))
        {
          datSD[i,j]<-correctionsSD[i,j]
          
          
        }
      }
    }
    else
    {
      stop("Corrections SD no puede tener mas filas que el numero de bases colocadas")
      return (NULL)
    }
    
    
    
    
    
    for (i in 1:nrow(datMeans))
    {
      if(is.na(datMeans[i,1]) || is.null(datMeans[i,1]))
      {
        datMeans[i,1]<-tdfmeans[2]
      }
      if(is.na(datMeans[i,2]) || is.null(datMeans[i,2]))
      {
        datMeans[i,2]<-tdfmeans[1]
      }
      
    }
    
    
    for (i in 1:nrow(datSD))
    {
      if(is.na(datSD[i,1]) || is.null(datSD[i,1]))
      {
        datSD[i,1]<-tdfsd[2]
      }
      if(is.na(datSD[i,2]) || is.null(datSD[i,2]))
      {
        datSD[i,2]<-tdfsd[1]
      }
      
    }
    
    colnames(datMeans)<-c("d13C","d15N")
    colnames(datSD)<-c("d13C","d15N")
    return(list(correctionsMeans=datMeans,correctionsSD=datSD))
  }
  
  #
  corrections=funcionCorrections(correctionsMeans,correctionsSD,Sourcess)
  #
  #
  #     #group
  colmix<-names(mixture[[1]]$datos)
  mix<-as.matrix(mixture[[1]][[2]])
  
  if(!is.null(columnGroup))
  {
    if(has_element(colmix,columnGroup))
    {
      
      
      
      
      gr<-select(mixture[[1]]$datos,columnGroup)
      
      
      
      
    }
    else
    {
      stop("no existe ninguna columna con el nombre  ", columnGroup, " dentro del dataframe ")
      return (NULL)
    }
    
    
    fact<-c()
    for (i in gr)
    {
      fact<-append(fact,i)
    }
    
    gr2<-factor(fact)
  }
  else
  {
    
    lplp<-rep(1,nrow(as.matrix(mixture[[1]][[2]])))
    
    gr2<-factor(lplp)
  }
  
  
  
  
  
  #
  #
  #
  #
  #
  
  #simmr_load crea una lista de la clase simmr_input con los datos de los mixtures y baselines ya calculadas.
  
  geese_simmr = simmr_load(mixtures = mix,
                           source_names = Nombres,
                           source_means = Sourcess[[1]],
                           source_sds = Sourcess[[2]],
                           correction_means = corrections[[1]],
                           correction_sds = corrections[[2]],
                           group = gr2
                           
  )
  
  
  
  
  
  return(geese_simmr)
  #return(filtro2)
  
  
}
