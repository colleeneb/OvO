FUNCTION almost_equal(x, gold, tol) RESULT(b)
    implicit none
    DOUBLE COMPLEX, intent(in) :: x
    INTEGER,  intent(in) :: gold
    REAL,     intent(in) :: tol
    LOGICAL              :: b
    b = ( gold * (1 - tol)  <= ABS(x) ).AND.( ABS(x) <= gold * (1+tol) )
END FUNCTION almost_equal
PROGRAM target_teams__distribute
    LOGICAL :: almost_equal
    INTEGER :: N_i = 64
    INTEGER :: i
    DOUBLE COMPLEX :: counter = (0,0)
!$OMP TARGET TEAMS REDUCTION(+: counter) MAP(TOFROM: counter) 
!$OMP DISTRIBUTE
    DO i = 1 , N_i
counter = counter +  CMPLX(  1. , 0 ) 
    END DO
!$OMP END TARGET TEAMS
IF ( .NOT.almost_equal(counter, N_i, 0.1) ) THEN
    WRITE(*,*)  'Expected', N_i,  'Got', counter
    CALL EXIT(112)
ENDIF
END PROGRAM target_teams__distribute