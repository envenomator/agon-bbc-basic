   10 MODE 0
   20 PRINT "Scalar/array name collision test"
   30 PRINT

   40 N%=4
   50 DIM p(2,N%-1), q(2,N%-1), r(2,2)

   60 REM Scalars with same names as arrays:
   70 p=123.456
   80 q=789.012
   90 r=0.5

  100 REM Fill p() with distinct values
  110 p(0,0)=10 : p(1,0)=20 : p(2,0)=30
  120 p(0,1)=11 : p(1,1)=21 : p(2,1)=31
  130 p(0,2)=12 : p(1,2)=22 : p(2,2)=32
  140 p(0,3)=13 : p(1,3)=23 : p(2,3)=33

  150 REM Fill r() as identity
  160 r(0,0)=1 : r(0,1)=0 : r(0,2)=0
  170 r(1,0)=0 : r(1,1)=1 : r(1,2)=0
  180 r(2,0)=0 : r(2,1)=0 : r(2,2)=1

  190 PRINT "Before multiply:"
  200 PRINT "scalar p = "; p
  210 PRINT "scalar q = "; q
  220 PRINT "scalar r = "; r
  230 PRINT

  240 FOR I%=0 TO 2
  250   PRINT "p(";I%;",0..3) = ";
  260   FOR J%=0 TO 3
  270     PRINT p(I%,J%);" ";
  280   NEXT
  290   PRINT
  300 NEXT
  310 PRINT

  320 q() = r() . p()

  330 PRINT "After q() = r() . p()"
  340 FOR I%=0 TO 2
  350   PRINT "q(";I%;",0..3) = ";
  360   FOR J%=0 TO 3
  370     PRINT q(I%,J%);" ";
  380   NEXT
  390   PRINT
  400 NEXT
  410 PRINT
  420 PRINT "Expected q() to equal p() exactly"
  430 END
