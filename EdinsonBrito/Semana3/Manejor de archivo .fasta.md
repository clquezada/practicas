
#### Edinson Brito
#### 28/08/20


# Manejor de archivo .fasta desde BOLD



#### datos utilizados:
una base de datos .fasta descargada desde la pagina https://www.boldsystems.org/ 
en al apartado de public data, descargar el archivo speciment en formato .tsv y el archivo sequences en formato.fas para el grupo taxonomico "Brachiopoda"

este conjunto de comandos permite obtener las IDS y luego la clasificacion y subclasificacion taxonomica y luego juntarlos en 1 solo archivo en el que se tendra las IDS y sus categorias.
```sh
$ grep -v 'processid' bold_data.txt | cut -f1,9,11,13,15,19,21 | sed 's/\t/;/g' | cut -d ';' -f1 > BOLDtaxonomy1.txt
$ grep -v 'processid' bold_data.txt | cut -f1,9,11,13,15,19,21 | sed 's/\t/;/g' | cut -d ';' -f2- | sed 's/ /_/g' | sed 's/$/;/g'> BOLDtaxonomy2.txt
$ paste BOLDtaxonomy1.txt BOLDtaxonomy2.txt> BOLDtax.txt
```

