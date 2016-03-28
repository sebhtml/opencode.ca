while true
do

	rm -rf opencode-ray

mpiexec \
--prefix /software/MPI/openmpi/1.6.4_gcc \
-n 64 \
-hostfile Nodes.txt \
-x PATH -x LD_LIBRARY_PATH -x PWD \
./Ray -detect-sequence-files BigData \
-o opencode-ray


done
