# Trabajo semana 1
---
##### title: "Semana 1 Práctica"
##### author: "Edinson Brito"
##### date: "4/8/2020"
##### output: taxonomia de un .fasta
---



Para la semana 1, se estudio como "jugar" con los archivos.fasta y .fasq, guiandonos de el siguiente paper "https://link.springer.com/protocol/10.1007/978-1-4939-3774-5_16", que si bien segun yo estaba un poco desactualiazdo, fue muy util para ver las librerias y comandos basicos a usar en bash de linux.
Los programas que se utilizaron fueron los siguientes:

- FastQC, link de descarga: http://www.bioinformatics.babraham.ac.uk/projects/fastqc.
- Trimmomatic, link de descarga: http://www.usadellab.org/cms/?page=trimmomatic.
- FLASH, link de descarga: http://ccb.jhu.edu/software/FLASH.
- Cd-hit ,link de descarga: http://weizhong-lab.ucsd.edu/cd-hit/.

si bien, no se siguo al pie de la letra el procedimiento que se realizo en el paper ya mencionado, se realizaron pasos similares solo para ver el funcionamiento de cada uno de los programas

parti descargando archivos fastq utilizando la herramienta "SRA toolkit", link de su documentacion: https://www.ncbi.nlm.nih.gov/books/NBK158900/.

se descargo un archivo fastq y se examino con la siguiente linea de codigo:


```sh
$ fastqc "nombre_de_archivo.fasq"
```
esto me creaba un html visible por cualquier ordenador con la calidad de los datos descargados.


luego se descargo una base de datos .fasta desde la base de datos BOLD y fui trabajando con ella hasta obtener la id de cada especie que se encontraba en la base de datos y el reino al cual pertenecia, acontinuacion dejare los comandos que se utilizaron y una breve descripcion

1.- Eliminar secuencias de cebadores

```sh
$ java -jar trimmomatic-0.39.jar SE -phred33 -trimlog S1_R1_cut.logfile S1_R1_cut.fastq S1_R1_crop.fastq HEADCROP:25
```

2.- Combinar las lecturas hacia adelante y hacia atrás con un mínimo y longitud de superposición máxima requerida entre dos lecturas de 217 y 257 pb, respectivamente, eliminar las secuencias del cebador

```sh
$ flash S1_R1_crop.fastq.gz S1_R2_crop.fastq -M 257 -m 217 -o S1 -z
```
3.-Elimine secuencias idénticas del archivo de alineación y conserve uno como una secuencia representativa para reducir el tamaño de la base de datos:
```sh
$ cd-hit -i fasta.fas -o output.fasta -c 1
```
4.- Mantenga el encabezado con el identificador de secuencia precedido por ">":

```sh
$ cd-hit -i fasta.fas -o output.fasta -c 1
```

5.- Del archivo de taxonomía, mantenga solo las columnas y líneas necesarias

```sh
$ grep -v 'processid' BOLDtaxonomy.txt | cut -f1,10,12,14,16,20,22 | sed 's/\t/;/g' | cut -d ';' -f2- | sed 's/ /_/g' | sed 's/$/;/g'> BOLDtaxonomfinal.txt
```




esto me dio como resultado algo asi:

ACANT004-18	Acanthocephala;Palaeacanthocephala;Echinorhynchida;Pomphorhynchidae;Pomphorhynchus;Pomphorhynchus_bosniacus;
ACANT005-18	Acanthocephala;Palaeacanthocephala;Echinorhynchida;Pomphorhynchidae;Pomphorhynchus;Pomphorhynchus_bosniacus;
ACANT006-18	Acanthocephala;Palaeacanthocephala;Echinorhynchida;Pomphorhynchidae;Pomphorhynchus;Pomphorhynchus_bosniacus;
ACANT007-18	Acanthocephala;Palaeacanthocephala;Echinorhynchida;Pomphorhynchidae;Pomphorhynchus;Pomphorhynchus_bosniacus;
ACANT008-18	Acanthocephala;Palaeacanthocephala;Echinorhynchida;Pomphorhynchidae;Pomphorhynchus;Pomphorhynchus_bosniacus;
ACANT009-18	Acanthocephala;Palaeacanthocephala;Echinorhynchida;Pomphorhynchidae;Pomphorhynchus;Pomphorhynchus_bosniacus;

y hasta aca llego mi avanze, no se hizo el clasificador utilizando mothur debido a que no se contaba con  los datos a clasificar
problemas que  me ocurrieron en el desarollo:

- instalar linux mediante un virtualbox, fue algo bastante tedioso.
- instalar los packetes y programas necesarios, aca estuve artas horas intentando aprender como ejecutar y instalar los distintos packetes y programas ya que era mi primera vez en linux
-  la documentacion y sintaxis que se incluyo en el ppt guia estaba algo desactualizado y la sintaxis habia canbiado en algunos programas lo que me obligo a leer la documentacion de dichos programas.



   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
