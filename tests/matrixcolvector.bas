   10 REM Matrix * Column vector test
   20 INPUT "Number of rows in matrix: ";m
   30 INPUT "Number of columns in matrix: ";n
   40 INPUT "Matrix cell value: "; cellvalue
   50 INPUT "Vector cell value: "; vectorvalue
   60 DIM MATRIX(m-1,n-1),V(n-1),CHECK(m-1),DOT(m-1)
   70 FOR i = 0 TO m-1
   80 FOR j = 0 TO n-1
   90 MATRIX(i,j) = cellvalue
  100 NEXT j
  110 NEXT i
  120 FOR j = 0 TO n-1
  130 V(j) = vectorvalue
  140 NEXT j
  150 FOR i = 0 TO m-1
  160 sum = 0
  170 FOR k = 0 TO n-1
  180 sum += MATRIX(i,k) * V(k)
  190 NEXT k
  200 CHECK(i) = sum
  210 NEXT i
  220 DOT() = MATRIX().V()
  230 PRINT "COL Vector | should be"
  240 FOR i = 0 TO m-1
  250 PRINT DOT(i);" | ";CHECK(i)
  260 NEXT i
