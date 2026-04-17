20 x=0:y=0:p=0:q=0
30 FOR I%=0 TO 19
40   r = RND(1)
50   CASE TRUE OF
60     WHEN r>0.93: A=-.15: B=.28 : C=.26 : D=.24 : E=0: F=.44 : k%=1
70     WHEN r>0.86: A=.2  : B=-.26: C=.23 : D=.22 : E=0: F=1.6  : k%=2
80     WHEN r>0.10: A=.85 : B=.04 : C=-.04: D=.85 : E=0: F=1.6  : k%=3
90     OTHERWISE:   A=0   : B=0   : C=0   : D=0.16: E=0: F=0    : k%=4
100   ENDCASE
110   t = A*x+B*y+E : y = C*x+D*y+F : x = t
120   IF r <= 0.86 t = A*p+B*q+E : q = C*p+D*q+F : p = t
130   PRINT I%;" r=";r;" k=";k%;" x=";x;" y=";y;" p=";p;" q=";q
140 NEXT
150 END
