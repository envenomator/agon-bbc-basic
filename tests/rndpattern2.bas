10 x=0:y=0:p=0:q=0
20 FOR I%=0 TO 19
30   r=RND(1)
40   IF r>0.93
50     A=-.15: B=.28 : C=.26 : D=.24 : E=0: F=.44 : k%=1
60   ELSEIF r>0.86
70     A=.2  : B=-.26: C=.23 : D=.22 : E=0: F=1.6  : k%=2
80   ELSEIF r>0.10
90     A=.85 : B=.04 : C=-.04: D=.85 : E=0: F=1.6  : k%=3
100  ELSE
110    A=0   : B=0   : C=0   : D=0.16: E=0: F=0    : k%=4
120  ENDIF
130  t=A*x+B*y+E : y=C*x+D*y+F : x=t
140  IF r<=0.86 THEN t=A*p+B*q+E : q=C*p+D*q+F : p=t
150  PRINT I%;" r=";r;" k=";k%;" x=";x;" y=";y;" p=";p;" q=";q
160 NEXT
