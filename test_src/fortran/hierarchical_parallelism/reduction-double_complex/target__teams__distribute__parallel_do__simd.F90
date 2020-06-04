FUNCTION almost_equal(x, gold, tol) RESULT(b)
    implicit none
    DOUBLE COMPLEX, intent(in) :: x
    INTEGER,  intent(in) :: gold
    REAL,     intent(in) :: tol
    LOGICAL              :: b
    b = ( gold * (1 - tol)  <= ABS(x) ).AND.( ABS(x) <= gold * (1+tol) )
END FUNCTION almost_equal
PROGRAM target__teams__distribute__parallel_do__simd
    LOGICAL :: almost_equal
    INTEGER :: N_i = 64
    INTEGER :: i
    INTEGER :: N_j = 64
    INTEGER :: j
    INTEGER :: N_k = 64
    INTEGER :: k
    DOUBLE COMPLEX :: counter = (0,0)
!$OMP TARGET MAP(TOFROM: counter) 
!$OMP TEAMS REDUCTION(+: counter)
!$OMP DISTRIBUTE
    DO i = 1 , N_i
!$OMP PARALLEL DO REDUCTION(+: counter)
    DO j = 1 , N_j
!$OMP SIMD REDUCTION(+: counter)
    DO k = 1 , N_k
counter = counter +  CMPLX(  1. , 0 ) 
    END DO
    END DO
    END DO
!$OMP END TEAMS
!$OMP END TARGET
IF ( .NOT.almost_equal(counter, N_i*N_j*N_k, 0.1) ) THEN
    WRITE(*,*)  'Expected', N_i*N_j*N_k,  'Got', counter
    CALL EXIT(112)
ENDIF
END PROGRAM target__teams__distribute__parallel_do__simd