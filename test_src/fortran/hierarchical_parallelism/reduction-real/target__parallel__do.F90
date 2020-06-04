FUNCTION almost_equal(x, gold, tol) RESULT(b)
    implicit none
    REAL, intent(in) :: x
    INTEGER,  intent(in) :: gold
    REAL,     intent(in) :: tol
    LOGICAL              :: b
    b = ( gold * (1 - tol)  <= x ).AND.( x <= gold * (1+tol) )
END FUNCTION almost_equal
PROGRAM target__parallel__do
    LOGICAL :: almost_equal
    INTEGER :: N_i = 64
    INTEGER :: i
    REAL :: counter = 0
!$OMP TARGET MAP(TOFROM: counter) 
!$OMP PARALLEL REDUCTION(+: counter)
!$OMP DO
    DO i = 1 , N_i
counter = counter +  1.
    END DO
!$OMP END PARALLEL
!$OMP END TARGET
IF ( .NOT.almost_equal(counter, N_i, 0.1) ) THEN
    WRITE(*,*)  'Expected', N_i,  'Got', counter
    CALL EXIT(112)
ENDIF
END PROGRAM target__parallel__do