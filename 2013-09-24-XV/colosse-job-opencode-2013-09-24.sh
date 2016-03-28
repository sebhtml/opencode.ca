
# Ce fichier demande 8 machines avec
# chacun 8 coeurs pour une durée de 12 heures.
# La quantité de coeur-heures
# sera facturée à l'allocation nne-790-ac
# chez Calcul Québec.

#PBS -S /bin/bash
#PBS -N opencode-2013-09-24
#PBS -o opencode-2013-09-24.stdout
#PBS -e opencode-2013-09-24.stderr
#PBS -A nne-790-ac
#PBS -l walltime=00:12:00:00
#PBS -l nodes=8:ppn=8
#PBS -M sebastien.boisvert.3@ulaval.ca
#PBS -m bea

cd $PBS_O_WORKDIR

sleep 9999999999
