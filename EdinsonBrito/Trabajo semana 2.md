# Trabajo semana 2
---
##### title: "Semana 2 Práctica"
##### author: "Edinson Brito"
##### date: "14/8/2020"
##### output: scrip para automatizar descargas de base de datos
---



Para la semana 2, se estudio y realizaron algunas pruebas para automatizar la descarga de la base de datos de NCBI y BOLD, la idea o meta de esta semana era descargar las base de datos de los sitios ya mencionados y juntarlas en una sola base de datos, esto se realizaria estudiando un paper en el cual en el material suplementario adjunta el scrip a utilizar 
link del paper : https://mbmg.pensoft.net/article/22262/instance/3909914/.

lo que alcanze a hacer fue poder automatizar  las descargas de la base de datos, con el objetivo de tener estas bases actualizadas en todo momento para asi desligarnos de ese tema.

el metodo con el cual trabaje fue hacer un "script cron" (no se si esta bien dicho el termino)
utilizando los comandoos:

```sh
$ crontab -e
```
para editar el cron de default de la maquina, ahi añadi un cron para que el scrip que cree se ejecutara   una vez al mes (el dia 1 de cada mes).
esto me permitiria tener la base actualizada mes a mes (de igual forma se puede cambiar dependiendo de las exigencias que se necesiten)

el script que cree para descargar las base de datos es bastante basico, lo dificil de eso (para mi), fue llegar a ese resultado, busque documentacion y informacion de como poder automatizar este proceso usando las base de datos BOLD y NCBI y descubri que existen api's para cada pagina, la de BOLD fue bastante sencilla, solo con esta url: http://www.boldsystems.org/index.php/API_Public/sequence?taxon=Acanthocephala  y modificando la taxonomia podia obtener los datos ".fasta".
En el caso de la base de datos NCBI fue mas complejo, llegando al resultado de tener que instalar un programa llamado 
Entrez Programming Utilities (E-utilities), link de descarga y documentacion : https://www.ncbi.nlm.nih.gov/books/NBK179288/.
de esta forma seria posible porfin automatizar el tema de las base de datos y asi mantenerlas actualizadas.

como habia dicho anteriormente, el scrip es bastante basico pero cumple con lo propuesto  para la base de datos  BOLD utilizo el comando wget para descargar directamente el .fasta y lo mando a la url que desee.
para el caso de NCBI utilizo la sintaxis de la api (se dejo la documentacion) pero el detalle es que en el caso de NCBI se pueden tener mas detallados los datos que se necesitan, en este caso solo se necesitan datos con el tamaño de bp entre 1 y 1000, por lo cual la consulta se realiza de esa forma (la sintaxis de la consulta se puede obtener de la pagina https://www.ncbi.nlm.nih.gov/).

```sh
#!/bin/bash


wget -c http://www.boldsystems.org/index.php/API_Public/sequence?taxon=Acanthocephala -P /home/edinson/Escritorio/Base



esearch -db nucleotide -query "("Trichoptera"[Organism] OR Trichoptera[All Fields]) AND (COI[All Fields] OR CO1[All Fields] OR COX1[All Fields] OR COXI[All Fields]) AND ("1"[SLEN] : "1000"[SLEN])" | efetch -format fasta  > /home/edinson/Escritorio/Base/NCBI.fasta

```


los problemas que desarolle en este trabajo fueron basicamente de tiempo, no entendia como funcionaba la api lo que consumuio mucho tiempo del que tenia disponible, por ello no pude juntar las base de datos para terminar el 100% de lo planteado para la semana.





   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
