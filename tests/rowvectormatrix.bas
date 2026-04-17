   10 REM Row vector * Matrix test
   20 INPUT "Number of rows in matrix: ";m
   30 INPUT "Number of columns in matrix: ";n
   40 INPUT "Matrix cell value: "; cellvalue
   50 INPUT "Vector cell value: "; vectorvalue
   60 DIM MATRIX(m-1,n-1),V(m-1),CHECK(n-1),DOT(n-1)
   70 FOR i = 0 TO m-1
   80 FOR j = 0 TO n-1
   90 MATRIX(i,j) = cellvalue
  100 NEXT j
  110 NEXT i
  120 FOR i = 0 TO m-1
  130 V(i) = vectorvalue
  140 NEXT i
  150 FOR j = 0 TO n-1
  160 sum = 0
  170 FOR k = 0 TO m-1
  180 sum += V(k) * MATRIX(k,j)
  190 NEXT k
  200 CHECK(j) = sum
  210 NEXT j
  220 DOT() = V().MATRIX()
  230 PRINT "ROW Vector | should be"
  240 FOR j = 0 TO n-1
  250 PRINT DOT(j);" | ";CHECK(j)
  260 NEXT j
