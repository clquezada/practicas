# Combinar base de datos BOLD y NCBI
#### Edinson Brito
#### 30/08/20



Aca explicaremos como automatizar la descarga de base de datos utilizando las api o link de descarga directa de BOLD y NCBI guiandonos del siguiente paper:
https://mbmg.pensoft.net/article/22262/instance/3909914/


Primero  creamos un scrip para descargar los archivos .fasta desde NCBI y BOLD en este caso utilizaremos los datos de taxon = Trichoptera
```sh
wget -c http://www.boldsystems.org/index.php/API_Public/sequence?taxon=Trichoptera -P /home/edinson/Escritorio/Base



esearch -db nucleotide -query "("Trichoptera"[Organism] OR Trichoptera[All Fields]) AND (COI[All Fields] OR CO1[All Fields] OR COX1[All Fields] OR COXI[All Fields]) AND ("1"[SLEN] : "1000"[SLEN])" | efetch -format fasta  > /home/edinson/Escritorio/Base/NCBI.fasta
```

Luego, una vez descargada las base de datos debemos renombrar las base de datos y guardar cada base de datos en su carpeta.
ej : al descargar el archivo fasta desde BOLD se descarga por default como "fasta.fas", debemos renombrarlo como "Trichoptera_BOLD.fasta" y guardarlo en la ruta "files: /Users/jnm/Desktop/BOLD_NCBI_Merger/2_input/BOLD".
en el caso de NCBI renombrar el archivo descargado a "Trichoptera_NCBI.fasta" y moverlo a la ruta "files: /Users/jnm/Desktop/BOLD_NCBI_Merger/2_input/NCBI"

despues, continuando con el proceso, nos dirigimos a la ruta files: /Users/jnm/Desktop/BOLD_NCBI_Merger y abrimos el archivo option.txt y seteamos los parametros, en este caso el taxon es Trichoptera y el query es eDNA_RuMoGi_subset.fasta, guardamos y cerramos el archivo

a esta altura ya estamos listo para ejecutar el scrip que se encuentra en el root de la carpeta :

```sh
$ ./run.sh
```

despues de ejecutar ese comando se guardara la base de datos ya combinada  en la carpeta 4_database


ademas, de forma adicional podemos crear un proceso para mantener la base de datos mas reciente, creando un "scrip cron" el cual descarge la base de datos de forma mensual, para esto utilizamos:
```sh
$ crontab -e
```
esto nos permitira añadir una instruccion tipo cron, en la cual diremos que el script de descarga que se menciono al pricipio de este documento se ejecute una vez al mes, esto nos sobreescribira la base de datos de forma mensual con el objetivo de mantener la base de datos actualizada.
 