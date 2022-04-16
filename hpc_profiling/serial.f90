!///////////////////////////////////////////////////////////////////////////////////////////
!   This program is intended for use illustrating the concepts of strong
!   and weak scaling.  There is no useful work done by the program at the moment
!   
!   The user can switch between modes of operation involving nearest-neighbor and global communication
!   Usage:
!           mpiexec -np N ./program -nx X -ny Y -nt T -comm C
!           N:   number of MPI ranks
!           X:   number of gridpoints in x-direction (default = 1024)
!           Y:   number of gridpoints in y-direction (default = 4096)
!           T:   number of iterations to run for (default = 100)
!           C:   Integer value 1 or 2; 1 => nearest neighbor; 2 => global communication
!
!   Description:
!           The program will run for T timesteps and execute a smoothing operation on an array of size
!           X x Y at each timestep.   The Y gridpoints are distributed across the N MPI ranks.
!           The X-direction remains in processor always (1-D domain decomposition)
!

Program Main
    USE ISO_FORTRAN_ENV, ONLY : output_unit
    USE Serial_Timing
    !USE MPI 
    IMPLICIT NONE


    Real*8 :: loop_time, loop_start, ticklen

    Real*8, Allocatable :: f(:,:), df(:,:), ftemp(:,:)
    INTEGER :: count1, count2, count_rate, count_max
    Type(timer) :: loop_timer, smooth_timer, update_timer
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    !   Problem Control Parameters
    Integer :: niter = 100
    Integer :: comm_type =1   ! 1 for nearest-neighbor; 2 for all-to-all
    Integer :: nyglobal = 4096
    Integer :: nxglobal = 4096 
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    Call loop_timer%init()
    Call smooth_timer%init()
    Call update_timer%init()

    Call grab_args(nxglobal, nyglobal, niter, comm_type)
    Call Initialization()



    Call Loop_Timer%startclock()

    Call Main_Loop()

    Call Loop_Timer%increment()

    loop_time = loop_timer%elapsed

    ! Print out some information regarding the time and problem size

    !Write(output_unit, '(e12.3,i6,i6,i6)') &
    !& loop_time, nxglobal, nyglobal, niter

    Write(output_unit,'(a,f8.4)')'Elapsed time (s): ', loop_timer%elapsed
    Write(output_unit,'(a,f8.4,a,f8.4,a)')'Smooth time  (s): ', &
                                      smooth_timer%elapsed, &
                                      ' (', 100*smooth_timer%elapsed/loop_timer%elapsed, ' %)'
    Write(output_unit,'(a,f8.4,a,f8.4,a)')'Update time  (s): ', &
                                      update_timer%elapsed, &
                                      ' (', 100*update_timer%elapsed/loop_timer%elapsed, ' %)'
    Call Finalize()



Contains

    SUBROUTINE grab_args(numx, numy, numiter, ctype)
            IMPLICIT NONE

            INTEGER, INTENT(INOUT)   :: numx
            INTEGER, INTENT(INOUT)   :: numy
            INTEGER, INTENT(INOUT)   :: ctype
            INTEGER, INTENT(INOUT)   :: numiter


            INTEGER :: n                    ! Number of command-line arguments
            INTEGER :: i                    
            CHARACTER(len=1024) :: argname  ! Argument key
            CHARACTER(len=1024) :: val      ! Argument value

            n = command_argument_count()
            DO i=1,n,2
                    CALL get_command_argument(i, argname)
                    CALL get_command_argument(i+1, val)
                    SELECT CASE(argname)
                            CASE('-nx')
                                    read(val, '(I8)') numx
                            CASE('-ny')
                                    read(val, '(I8)') numy
                            CASE('-nt')
                                    read(val, '(I8)') numiter
                            CASE('-comm')
                                    read(val, '(I8)') ctype
                            CASE DEFAULT
                                    WRITE(output_unit,'(a)') ' '
                                    WRITE(output_unit,'(a)') &
                                    ' Unrecognized option: '// trim(argname)
                    END SELECT
            ENDDO



    END SUBROUTINE grab_args

    Subroutine Initialization()
        Implicit None
        Integer :: modcheck, min_proc
        Real*8 :: amps(2), phases(2)

        Allocate(    f( 1:nxglobal , 1:nyglobal+2 ))
        Allocate(   df( 1:nxglobal , 1:nyglobal+2 ))
        Allocate(ftemp( 1:nxglobal , 1:nyglobal+2 ))

        f = 0
        df = 0
        ftemp =0
        

    End Subroutine Initialization

    Subroutine Main_Loop()
        Implicit None
        Integer :: i
        Do i = 1, niter
            Call Smooth()
            Call Update()
        Enddo
    End Subroutine Main_Loop


    Subroutine Smooth()
        Integer :: i, j, k
        ! Smooth the field
        Call smooth_timer%startclock()
        !$OMP PARALLEL DO PRIVATE(i,j) schedule(dynamic)
        Do j = 2, nyglobal-1
            Do i = 2, nxglobal -1
                df(i,j) = 0.25 * ( f(i+1,j) + f(i-1,j) + f(i,j+1) + f(i,j-1) )
            Enddo
        Enddo
        !$OMP END PARALLEL DO
        Call smooth_timer%increment()
    End Subroutine Smooth

    Subroutine Update()
        Integer :: i, j, k
        ! Update the field
        Call update_timer%startclock()
        !$OMP PARALLEL DO PRIVATE(i,j) schedule(dynamic)
        Do j = 2, nyglobal-1
            Do i = 2, nxglobal-1
                f(i,j) = f(i,j)+df(i,j)
            Enddo
        Enddo
        !$OMP END PARALLEL DO
        Call update_timer%increment()
    End Subroutine Update


    Subroutine Finalize()
        Implicit None
        Integer :: ierr
        If (Allocated(    f)) DeAllocate(    f) 
        If (Allocated(   df)) DeAllocate(   df) 
        If (Allocated(ftemp)) DeAllocate(ftemp) 
    End Subroutine Finalize



End Program Main
