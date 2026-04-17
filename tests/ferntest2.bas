   10 MODE 0
   20 DIM A(2,2), B(2,2), C(2,2), R(2,2), P(2,3), Q(2,3)

   30 REM Fill A, B, C with simple values
   40 FOR I%=0 TO 2
   50   FOR J%=0 TO 2
   60     A(I%,J%) = I%+J%+1
   70     B(I%,J%) = I%*2+J%+1
   80     C(I%,J%) = I%*3+J%+1
   90   NEXT
  100 NEXT

  110 REM Fill P (3x4)
  120 FOR I%=0 TO 2
  130   FOR J%=0 TO 3
  140     P(I%,J%) = I%*10 + J%
  150   NEXT
  160 NEXT

  170 PRINT "Step 1: R = B . A"
  180 R() = B() . A()

  190 PRINT "Step 2: R = C . R"
  200 R() = C() . R()

  210 PRINT "Step 3: Q = R . P"
  220 Q() = R() . P()

  230 PRINT "Q():"
  240 FOR I%=0 TO 2
  250   FOR J%=0 TO 3
  260     PRINT Q(I%,J%);" ";
  270   NEXT
  280   PRINT
  290 NEXT
