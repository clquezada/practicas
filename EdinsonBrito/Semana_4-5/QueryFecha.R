Query_Fecha <- function(){

  Actual = Sys.Date()
  FechaActual= format(Actual, "%Y/%m/%d") #obtiene la fecha y la transforma con el formato correcto
  Pasada= seq(Sys.Date(), length = 2, by = "-1 months")[2] 
  FechaPasada= format(Pasada, "%Y/%m/%d") #obtiene la fecha 1 mes atras con el formato correcto
  Query= (c('("',FechaPasada,"[PDAT]:",FechaActual,'[PDAT]")'))
  QueryFinal = noquote(Query)
  QueryFinal
  return(QueryFinal)


}

