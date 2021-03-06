PROGRAM target__teams__distribute__parallel__do
  implicit none
  INTEGER :: N0 = 512
  INTEGER :: i0
  INTEGER :: N1 = 512
  INTEGER :: i1
  INTEGER :: idx, S
  INTEGER :: errno = 0
  REAL, ALLOCATABLE :: src(:)
  REAL, ALLOCATABLE :: dst(:)
  S = N0*N1
  ALLOCATE(dst(S), src(S) )
  CALL RANDOM_NUMBER(src)
  !$OMP target map(to: src) map(from: dst)
  !$OMP teams
  !$OMP distribute
  DO i0 = 1, N0
    !$OMP parallel
    !$OMP do
    DO i1 = 1, N1
      idx = i1-1+N1*(i0-1)+1
      dst(idx) = src(idx)
    END DO
    !$OMP END parallel
  END DO
  !$OMP END teams
  !$OMP END target
  IF (ANY(ABS(dst - src) > EPSILON(src))) THEN
    WRITE(*,*)  'Wrong value', MAXVAL(ABS(DST-SRC)), 'max difference'
    errno = 112
  ENDIF
  DEALLOCATE(src, dst)
  IF (errno .EQ. 112) STOP 112
END PROGRAM target__teams__distribute__parallel__do
