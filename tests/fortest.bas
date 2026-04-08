   10   PRINT "Running FOR...NEXT tests..."
   20   
   30   REM Implicit nested loops:
   40   T% = 12
   50   FOR J% = 1 TO 10
   60     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
   70     FOR I% = -10 TO 10 STEP 2
   80       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
   90       IF I%+22*J%<>T% STOP
  100       T% += 2
  110     NEXT
  120   NEXT
  130   IF T% <> 232 STOP
  140   :
  150   REM Implicit nested loops (single NEXT):
  160   T% = 12
  170   FOR J% = 1 TO 10
  180     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  190     FOR I% = -10 TO 10 STEP 2
  200       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  210       IF I%+22*J%<>T% STOP
  220       T% += 2
  230     NEXT ,
  240   ENDIF : REM Fudge indentation
  250   IF T% <> 232 STOP
  260   :
  270   REM Explicit nested loops:
  280   T% = 12
  290   FOR J% = 1 TO 10
  300     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  310     FOR I% = -10 TO 10 STEP 2
  320       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  330       IF I%+22*J%<>T% STOP
  340       T% += 2
  350     NEXT I%
  360   NEXT J%
  370   IF T% <> 232 STOP
  380   :
  390   REM Explicit nested loops (single NEXT):
  400   T% = 12
  410   FOR J% = 1 TO 10
  420     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  430     FOR I% = -10 TO 10 STEP 2
  440       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  450       IF I%+22*J%<>T% STOP
  460       T% += 2
  470     NEXT I%,J%
  480   ENDIF : REM Fudge indentation
  490   IF T% <> 232 STOP
  500   :
  510   REM Pop inner loop:
  520   T% = -10
  530   FOR I% = -10 TO 10
  550     FOR J% = 1 TO 10
  560       IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  570       IF I%<>T% STOP
  580       T% += 1
  590     NEXT I%
  600   ENDIF : REM Fudge indentation
  610   IF T% <> 11 STOP
  620   :
  630   REM Negative step, implicit
  640   T% = -12
  650   FOR J% = 1 TO 10
  660     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  670     FOR I% = 10 TO -10 STEP -2 : REM reverse
  680       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  690       IF I%-J%*22<>T% STOP
  700       T% -= 2
  710     NEXT
  720   NEXT
  730   IF T% <> -232 STOP
  740   :
  750   REM Negative step, implicit, single NEXT
  760   T% = -12
  770   FOR J% = 1 TO 10
  780     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  790     FOR I% = 10 TO -10 STEP -2 : REM reverse
  800       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  810       IF I%-J%*22<>T% STOP
  820       T% -= 2
  830     NEXT ,
  840   ENDIF : REM Fudge indentation
  850   IF T% <> -232 STOP
  860   :
  870   REM Negative step, explicit
  880   T% = -12
  890   FOR J% = 1 TO 10
  900     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  910     FOR I% = 10 TO -10 STEP -2 : REM reverse
  920       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
  930       IF I%-J%*22<>T% STOP
  940       T% -= 2
  950     NEXT I%
  960   NEXT J%
  970   IF T% <> -232 STOP
  980   :
  990   REM Negative step, explicit, single NEXT
 1000   T% = -12
 1010   FOR J% = 1 TO 10
 1020     IF J% = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1030     FOR I% = 10 TO -10 STEP -2 : REM reverse
 1040       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1050       IF I%-J%*22<>T% STOP
 1060       T% -= 2
 1070     NEXT I%, J%
 1080   ENDIF : REM Fudge indentation
 1090   IF T% <> -232 STOP
 1100   :
 1110   REM Negative step, pop inner loop
 1120   T% = 9
 1130   FOR J% = 1 TO 10
 1150     FOR I% = 10 TO -10 STEP -1 : REM reverse
 1160       IF I% = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1170       IF I%-J%<>T% STOP
 1180       T% -= 1
 1190     NEXT J%
 1200   ENDIF : REM Fudge indentation
 1210   IF T% <> -1 STOP
 1220   :
 1230   REM Implied integer variables:
 1240   T = 12
 1250   FOR J = 1 TO 10
 1260     IF J = 5 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1270     FOR I = -10 TO 10 STEP 2
 1280       IF I = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1290       IF I+22*J<>T STOP
 1300       IF !(^I)<>I STOP : REM implied integer
 1310       T += 2
 1320     NEXT ,
 1330   ENDIF : REM Fudge indentation
 1340   IF T% <> -1 STOP
 1350   :
 1370   REM Promote to float, explicit
 1380   T = &7FFFAFFF
 1390   FOR I = &7FFFAFFF TO &7FFFAFFF+&A000 STEP &1000
 1400     IF I<>T STOP
 1410     IF (!^I = I) <> (I <= &7FFFFFFF) STOP
 1420     T += &1000
 1430     IF (!^T = T) <> (T <= &7FFFFFFF) STOP
 1440   NEXT I
 1450   IF T <> 2147508223 STOP
 1460   :
 1470   REM Promote to float, implicit
 1480   T = &7FFFAFFF
 1490   FOR I = &7FFFAFFF TO &7FFFAFFF+&A000 STEP &1000
 1500     IF I<>T STOP
 1510     T += &1000
 1520     IF (!^T = T) <> (T <= &7FFFFFFF) STOP
 1530   NEXT
 1540   IF T <> 2147508223 STOP
 1550   :
 1560   REM Promote to float, negative STEP, explicit
 1570   T = &80005000
 1580   FOR I = &80005000 TO &80005000-&A000 STEP -&1000
 1590     IF I<>T STOP
 1600     IF (!^I = I) <> (I >= &80000000) STOP
 1610     T -= &1000
 1620     IF (!^T = T) <> (T >= &80000000) STOP
 1630   NEXT I
 1640   IF T <> -2147508224 STOP
 1650   :
 1660   REM Promote to float, negative STEP, implicit
 1670   T = &80005000
 1680   FOR I = &80005000 TO &80005000-&A000 STEP -&1000
 1690     IF I<>T STOP
 1700     IF (!^I = I) <> (I >= &80000000) STOP
 1710     T -= &1000
 1720     IF (!^T = T) <> (T >= &80000000) STOP
 1730   NEXT
 1740   IF T <> -2147508224 STOP
 1750   :
 1760   REM Non-integer
 1770   T = -1.0
 1780   FOR I = -1.0 TO 1.0 STEP 0.1
 1790     IF I = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1800     IF I<>T STOP
 1810     T += .1
 1820   NEXT I
 1830   :
 1840   REM Non-integer, negative STEP
 1850   T = 1.0
 1860   FOR I = 1.0 TO -1.0 STEP -0.1
 1870     IF I = 0 LOCAL DATA : LOCAL ERROR : ON ERROR LOCAL STOP
 1880     IF I<>T STOP
 1890     T -= .1
 1900   NEXT I
 1910   :
 1920   DATA LOCAL
 1930   PRINT "FOR...NEXT tests completed."
 1940   
 1950   DATA REPORT WHEN CASE OF DATA LINE
