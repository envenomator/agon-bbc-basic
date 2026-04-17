10 MODE 7
20 PRINT "DEG  SIN      COS      TAN"
30 PRINT "--------------------------"
40 FOR A%=0 TO 90 STEP 10
50 R=A%*PI/180
60 S=SIN(R) : C=COS(R)
70 PRINT RIGHT$("   "+STR$(A%),3);" ";
80 PRINT LEFT$(STR$(S)+"        ",8);" ";
90 PRINT LEFT$(STR$(C)+"        ",8);" ";
100 IF A%=90 THEN PRINT "INF" ELSE PRINT LEFT$(STR$(TAN(R))+"        ",8)
110 NEXT A%
120 END
