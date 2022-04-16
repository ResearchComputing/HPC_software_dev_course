MPFC=mpif90
FC=ifort
FFLAGS=-O3 -g -debug inline-debug-info -I . 
OMPFLAGS = $(FFLAGS) -qopenmp -parallel-source-info=2
SCALE = prog.mpi
SERIAL = prog.serial
OMP = prog.omp
STIMING = Serial_Timing.o

.PHONY: clean all

all: $(SERIAL) $(SCALE) $(OMP)

$(STIMING): Serial_Timing.f90
	$(FC) $(FFLAGS) -c $<  -o $@

$(OMP): serial.f90 $(STIMING)
	$(FC) $(OMPFLAGS) $^  -o $@
$(SERIAL): serial.f90 $(STIMING)
	$(FC) $(FFLAGS) $^  -o $@
$(SCALE): scale.f90
	$(MPFC) $(FFLAGS) $< -o $@
clean:
	rm -rf $(SERIAL) $(SCALE) $(OMP)
	rm -rf *.o *.mod
