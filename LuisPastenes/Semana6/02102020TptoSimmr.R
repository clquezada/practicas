TPtoSimmr<-function(df="Bilagay_for_tRophicPosition.xlsx",
                      filtro=lista,
                      columnass=columnas,
                      mixture= "Bilagay",
                      baselines=c("Pelagic_BL","Benthic_BL","Peces"),
                      baseColumn="FG",
                      mixtureColumn="FG",
                      ColumnC="d13C",
                      ColumnN="d15N",
                      correctionsMeans=var,
                      correctionsSD=var,
                      columnGroup=NULL
                      
                      
      
                    )
  
  
  
  
  {
    
    #llamada de excel
  
    ruta=system.file("extdata", df, 
                package = "tRophicPosition")
  
    #verificador de formato
  nruta<-nchar(ruta)
  verificate<-substr(ruta,start =nruta-3,stop=nruta)
  verificate2<-substr(ruta,start =nruta-2,stop=nruta)
  comprobador=0
  
  if(verificate=="xlsx")
  {
    comprobador=1
  }
  
  if(verificate2=="csv")
  {
    comprobador=2
  }
  
  
  
    
   if( file.exists(ruta))
   {  
      
      if(comprobador==1)
      {

      datos<-read.xlsx(ruta,1)
      }
      else if(comprobador==2)
      {
        datos=read.table(ruta,sep=",",header=TRUE)
      }
     else
     {
       stop("formato del archivo no soportado")
       return (NULL)
     }
      
     
   }
    else
    {
      stop("no existe ningun archivo con el nombre  ", df, "  dentro de tRophicPosition/extdata ")
      return (NULL)
    }

#verificador argumentos
  

  
    
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
    
    
    #TOMAR ARCHIVO GENERICO


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








    #retorna un dataframe con los filtros aplicados

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

    datos<-funcionData(datos,filtro,columnass)




   #retorna una lista con las filas de la base seleccionada, los valores, promedio y desviacion estandar de carbono y nitrogeno
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

  Sourcess<-sources(bases)



    #corrections function

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
