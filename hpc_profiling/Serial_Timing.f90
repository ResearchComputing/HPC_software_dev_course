Module Serial_Timing
    Type, Public :: Timer
	    Real*8 :: delta, elapsed
        Integer :: t1,t2
        Integer :: count_rate, count_max

	    Contains
	    Procedure :: Init  => Initialize_Timer
	    Procedure :: startclock
	    Procedure :: stopclock
	    Procedure :: increment
    End Type Timer


Contains



    Subroutine Initialize_Timer(self)
	    Implicit None
	    Class(Timer) :: self
	    self%elapsed = 0.0d0
	    self%t1 = 0.0d0
	    self%delta = 0.0d0
    End Subroutine Initialize_Timer

    Subroutine Startclock(self)
	    Implicit None
	    Class(Timer) :: self
	    !self%t1 = MPI_WTIME()
        CALL SYSTEM_CLOCK(self%t1, self%count_rate, self%count_max)
    End Subroutine Startclock

    Subroutine Stopclock(self)
	    Implicit None

	    Class(Timer) :: self
	    !t2 = MPI_WTIME()
        CALL SYSTEM_CLOCK(self%t2, self%count_rate, self%count_max)
	    self%delta = real(self%t2-self%t1)/real(self%count_rate)
    End Subroutine Stopclock

    Subroutine Increment(self)
	    Implicit None
	    Class(Timer) :: self
	    Call self%stopclock()
	    self%elapsed = self%elapsed+self%delta
    End Subroutine Increment
End Module Serial_Timing
