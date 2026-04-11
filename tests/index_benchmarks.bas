   10 REM BBC BASIC V benchmark - compact and compatible
   20 MODE 0
   30 PRINT "BBC BASIC V ARRAY / MATRIX BENCHMARK"
   40 PRINT STRING$(40,"-")
   50 PROCbench1D
   60 PROCbench2D
   70 PROCbenchMatAdd
   80 PROCbenchMatMul
   90 PRINT STRING$(40,"-")
  100 PRINT "Done."
  110 END
  120 :
  130 DEF FNshowProgress(P%,LASTP%)
  140 IF P%=LASTP% =LASTP%
  150 PRINT TAB(0,VPOS);"Progress: ";P%;"%   ";
  160 =P%
  170 :
  180 DEF PROCbench1D
  190 LOCAL I%,J%,N%,LOOPS%,T0,S,P%,LP%
  200 N%=199
  210 LOOPS%=20
  220 DIM VEC(N%)
  230 FOR I%=0 TO N%
  240   VEC(I%)=I%*0.5+1
  250 NEXT
  260 S=0
  270 PRINT "1D array indexing"
  280 LP%=-1
  290 T0=TIME
  300 FOR J%=1 TO LOOPS%
  310   P%=J%*100/LOOPS%
  320   LP%=FNshowProgress(P%,LP%)
  330   FOR I%=0 TO N%
  340     VEC(I%)=VEC(I%)+1
  350     S=S+VEC(I%)
  360   NEXT
  370 NEXT
  380 T0=TIME-T0
  390 PRINT
  400 PRINT "  elements = ";N%+1
  410 PRINT "  loops    = ";LOOPS%
  420 PRINT "  checksum = ";S
  430 PRINT "  time cs  = ";T0
  440 PRINT
  450 ENDPROC
  460 :
  470 DEF PROCbench2D
  480 LOCAL X%,Y%,PASSES%,W%,H%,SIZE%,MAX%,IDX%,T0,S,P%,LP%,X2%
  490 W%=9
  500 H%=9
  510 PASSES%=20
  520 SIZE%=(W%+1)*(H%+1)
  530 MAX%=SIZE%-1
  540 DIM MAT(MAX%)
  550 FOR Y%=0 TO H%
  560   FOR X%=0 TO W%
  570     IDX%=Y%*(W%+1)+X%
  580     MAT(IDX%)=X%+Y%
  590   NEXT
  600 NEXT
  610 S=0
  620 PRINT "2D array indexing"
  630 LP%=-1
  640 T0=TIME
  650 FOR X%=1 TO PASSES%
  660   P%=X%*100/PASSES%
  670   LP%=FNshowProgress(P%,LP%)
  680   FOR Y%=0 TO H%
  690     FOR X2%=0 TO W%
  700       IDX%=Y%*(W%+1)+X2%
  710       MAT(IDX%)=MAT(IDX%)+1
  720       S=S+MAT(IDX%)
  730     NEXT
  740   NEXT
  750 NEXT
  760 T0=TIME-T0
  770 PRINT
  780 PRINT "  size     = ";W%+1;" x ";H%+1
  790 PRINT "  passes   = ";PASSES%
  800 PRINT "  checksum = ";S
  810 PRINT "  time cs  = ";T0
  820 PRINT
  830 ENDPROC
  840 :
  850 DEF PROCbenchMatAdd
  860 LOCAL X%,Y%,X2%,REPS%,N%,SIDE%,SIZE%,MAX%,IDX%,T0,S,P%,LP%
  870 N%=9
  880 SIDE%=N%+1
  890 SIZE%=SIDE%*SIDE%
  900 MAX%=SIZE%-1
  910 REPS%=50
  920 DIM MA(MAX%)
  930 DIM MB(MAX%)
  940 DIM MC(MAX%)
  950 FOR Y%=0 TO N%
  960   FOR X%=0 TO N%
  970     IDX%=Y%*SIDE%+X%
  980     MA(IDX%)=X%+Y%
  990     MB(IDX%)=X%-Y%
 1000   NEXT
 1010 NEXT
 1020 S=0
 1030 PRINT "Matrix add benchmark"
 1040 LP%=-1
 1050 T0=TIME
 1060 FOR X%=1 TO REPS%
 1070   P%=X%*100/REPS%
 1080   LP%=FNshowProgress(P%,LP%)
 1090   FOR Y%=0 TO N%
 1100     FOR X2%=0 TO N%
 1110       IDX%=Y%*SIDE%+X2%
 1120       MC(IDX%)=MA(IDX%)+MB(IDX%)
 1130       S=S+MC(IDX%)
 1140     NEXT
 1150   NEXT
 1160 NEXT
 1170 T0=TIME-T0
 1180 PRINT
 1190 PRINT "  size     = ";SIDE%;" x ";SIDE%
 1200 PRINT "  reps     = ";REPS%
 1210 PRINT "  checksum = ";S
 1220 PRINT "  time cs  = ";T0
 1230 PRINT
 1240 ENDPROC
 1250 :
 1260 DEF PROCbenchMatMul
 1270 LOCAL I%,J%,K%,K2%,REPS%,N%,SIDE%,SIZE%,MAX%,IA%,IB%,IC%,T0,S,P%,LP%
 1280 N%=3
 1290 SIDE%=N%+1
 1300 SIZE%=SIDE%*SIDE%
 1310 MAX%=SIZE%-1
 1320 REPS%=10
 1330 DIM MX(MAX%)
 1340 DIM MY(MAX%)
 1350 DIM MZ(MAX%)
 1360 FOR I%=0 TO N%
 1370   FOR J%=0 TO N%
 1380     IA%=I%*SIDE%+J%
 1390     MX(IA%)=(I%+1)*(J%+1)/10
 1400     MY(IA%)=(I%-J%+2)/10
 1410   NEXT
 1420 NEXT
 1430 S=0
 1440 PRINT "Matrix multiply benchmark"
 1450 LP%=-1
 1460 T0=TIME
 1470 FOR K%=1 TO REPS%
 1480   P%=K%*100/REPS%
 1490   LP%=FNshowProgress(P%,LP%)
 1500   FOR I%=0 TO N%
 1510     FOR J%=0 TO N%
 1520       IC%=I%*SIDE%+J%
 1530       MZ(IC%)=0
 1540       FOR K2%=0 TO N%
 1550         IA%=I%*SIDE%+K2%
 1560         IB%=K2%*SIDE%+J%
 1570         MZ(IC%)=MZ(IC%)+MX(IA%)*MY(IB%)
 1580       NEXT
 1590       S=S+MZ(IC%)
 1600     NEXT
 1610   NEXT
 1620 NEXT
 1630 T0=TIME-T0
 1640 PRINT
 1650 PRINT "  size     = ";SIDE%;" x ";SIDE%
 1660 PRINT "  reps     = ";REPS%
 1670 PRINT "  checksum = ";S
 1680 PRINT "  time cs  = ";T0
 1690 PRINT
 1700 ENDPROC
