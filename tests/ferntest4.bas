   10 REM Flying Fractal Fern by Richard Russell
   20
   30 MODE 0: OFF
   40 ORIGIN 640,512
   50
   60 N% = 900
   70 DIM p(2,N%-1), q(2,N%-1), a(2,2), b(2,2), c(2,2), r(2,2)
   80
   90 REM Create the 3D fractal fern leaf:
  100 x=0
  110 y=0
  120 p=0
  130 q=0
  140 FOR I% = 0 TO N%-1
  150   r = RND(1)
  160   CASE TRUE OF
  170     WHEN r>0.93: A=-.15: B=.28 : C=.26 : D=.24 : E=0: F=.44
  180     WHEN r>0.86: A=.2  : B=-.26: C=.23 : D=.22 : E=0: F=1.6
  190     WHEN r>0.10: A=.85 : B=.04 : C=-.04: D=.85 : E=0: F=1.6
  200     OTHERWISE:   A=0   : B=0   : C=0   : D=0.16: E=0: F=0
  210   ENDCASE
  220   t = A*x+B*y+E : y = C*x+D*y+F : x = t
  230   IF r <= 0.86 t = A*p+B*q+E : q = C*p+D*q+F : p = t
  240   p(0,I%) = x : p(1,I%) = y - 5 : p(2,I%) = ABS(x - p) / 3
  250 NEXT
  260
  270 REM Now animate it:
  280 a = 0
  290 b = 0
  300 c = 0
  310 REM *REFRESH OFF
  320 GCOL 2
  330 REPEAT
  340   REM Create the rotation matrix:
  350   REM a() = 1, 0, 0, 0, COS(a), -SIN(a), 0, SIN(a), COS(a)
  360   REM b() = COS(b), 0, SIN(b), 0, 1, 0, -SIN(b), 0, COS(b)
  370   REM c() = COS(c), -SIN(c), 0, SIN(c), COS(c), 0, 0, 0, 1
  350   a(0,0)=1 : a(0,1)=0      : a(0,2)=0
  351   a(1,0)=0 : a(1,1)=COS(a) : a(1,2)=-SIN(a)
  352   a(2,0)=0 : a(2,1)=SIN(a) : a(2,2)=COS(a)

  360   b(0,0)=COS(b) : b(0,1)=0 : b(0,2)=SIN(b)
  361   b(1,0)=0      : b(1,1)=1 : b(1,2)=0
  362   b(2,0)=-SIN(b): b(2,1)=0 : b(2,2)=COS(b)

  370   c(0,0)=COS(c) : c(0,1)=-SIN(c) : c(0,2)=0
  371   c(1,0)=SIN(c) : c(1,1)=COS(c)  : c(1,2)=0
  372   c(2,0)=0      : c(2,1)=0       : c(2,2)=1
  380   r() = b() . a() : r() = c() . r()
  390
  400   REM Rotate the leaf:
  410   REM q() = r() . p()
  400   REM Rotate the leaf manually:
  401   FOR I% = 0 TO N%-1
  402     q(0,I%) = r(0,0)*p(0,I%) + r(0,1)*p(1,I%) + r(0,2)*p(2,I%)
  403     q(1,I%) = r(1,0)*p(0,I%) + r(1,1)*p(1,I%) + r(1,2)*p(2,I%)
  404     q(2,I%) = r(2,0)*p(0,I%) + r(2,1)*p(1,I%) + r(2,2)*p(2,I%)
  405   NEXT
  420
  430   REM Plot the leaf:
  440   CLS
  450   FOR I% = 0 TO N%-1
  460     z = 1000 / (12 + q(2,I%))
  470     PLOT q(0,I%)*z, q(1,I%)*z
  480   NEXT
  490
  500   REM Update the angles:
  510   a += 0.030 : IF a > 2*PI THEN a -= 2*PI
  520   b += 0.025 : IF b > 2*PI THEN b -= 2*PI
  530   c += 0.020 : IF c > 2*PI THEN c -= 2*PI
  540
  550 REM   *REFRESH
  560 UNTIL FALSE
  570 END
