   10 REM Matrix dot-product regression test for ARRDOT
   20 MODE 0
   30 PRINT "3x3 . 3x4 matrix multiplication test"
   40 PRINT

   50 DIM R(2,2),P(2,3),Q(2,3)

   60 REM Left matrix R = 3x3
   70 R(0,0)=1 : R(0,1)=2 : R(0,2)=3
   80 R(1,0)=4 : R(1,1)=5 : R(1,2)=6
   90 R(2,0)=7 : R(2,1)=8 : R(2,2)=9

  100 REM Right matrix P = 3x4
  110 P(0,0)=10 : P(0,1)=11 : P(0,2)=12 : P(0,3)=13
  120 P(1,0)=20 : P(1,1)=21 : P(1,2)=22 : P(1,3)=23
  130 P(2,0)=30 : P(2,1)=31 : P(2,2)=32 : P(2,3)=33

  140 PRINT "Matrix R() ="
  150 GOSUB 1000
  160 PRINT
  170 PRINT "Matrix P() ="
  180 GOSUB 2000
  190 PRINT

  200 PRINT "Computing Q() = R() . P()"
  210 Q() = R() . P()
  220 PRINT
  230 PRINT "Matrix Q() ="
  240 GOSUB 3000
  250 PRINT

  260 PRINT "Expected rows of Q() should be:"
  270 PRINT "Row 0: 140 146 152 158"
  280 PRINT "Row 1: 320 335 350 365"
  290 PRINT "Row 2: 500 524 548 572"
  300 PRINT

  310 PRINT "Row comparison check:"
  320 PRINT "If all printed Q rows are identical, the bug is reproduced."
  330 END

 1000 FOR I%=0 TO 2
 1010   PRINT "R(";I%;",0..2) = ";
 1020   FOR J%=0 TO 2
 1030     PRINT R(I%,J%);" ";
 1040   NEXT
 1050   PRINT
 1060 NEXT
 1070 RETURN

 2000 FOR I%=0 TO 2
 2010   PRINT "P(";I%;",0..3) = ";
 2020   FOR J%=0 TO 3
 2030     PRINT P(I%,J%);" ";
 2040   NEXT
 2050   PRINT
 2060 NEXT
 2070 RETURN

 3000 FOR I%=0 TO 2
 3010   PRINT "Q(";I%;",0..3) = ";
 3020   FOR J%=0 TO 3
 3030     PRINT Q(I%,J%);" ";
 3040   NEXT
 3050   PRINT
 3060 NEXT
 3070 RETURN
