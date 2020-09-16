#!/bin/bash
# -*- ENCODING: UTF-8 -*-
cd /home/claudio/Escritorio/entrez_qiime-master
source /home/claudio/anaconda3/etc/profile.d/conda.sh
conda init -d bash
conda activate Practico

python2 entrez_qiime.py -i /home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/Perlidae/Perlidae_GB.fasta -o /home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/Perlidae/Perlidae_NCBI_taxon.txt -g /home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/Perlidae/perlidaelogncbi -n /home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/Perlidae -a /home/claudio/Escritorio/BaseFinal/PrimerMiner-master/Sample_Data/Perlidae/nucl_gb.accession2taxid -r phylum,class,order,family,genus,species

exit
