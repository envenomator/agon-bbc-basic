   10   PRINT "Running string slicing tests..."
   20   aTest$ = "Antidisestablishmentarianism"
   30   
   40   IF LEFT$(aTest$) <> "Antidisestablishmentarianis" THEN STOP
   50   IF LEFT$(LEFT$(aTest$)) <> "Antidisestablishmentariani" THEN STOP
   60   
   70   IF LEFT$(aTest$,FNn(0)) <> "" THEN STOP
   80   IF LEFT$(aTest$,FNn(1)) <> "A" THEN STOP
   90   IF LEFT$(aTest$,FNn(2)) <> "An" THEN STOP
  100   IF LEFT$(aTest$,FNn(3)) <> "Ant" THEN STOP
  110   IF LEFT$(aTest$,FNn(4)) <> "Anti" THEN STOP
  120   
  130   IF LEFT$(aTest$, FNn(28)) <> aTest$ THEN STOP
  140   IF LEFT$(aTest$, FNn(29)) <> "Antidisestablishmentarianism" THEN STOP
  150   IF LEFT$(aTest$, 65535) <> "Antidisestablishmentarianism" THEN STOP
  160   IF LEFT$(aTest$, -1) <> "Antidisestablishmentarianism" THEN STOP
  170   
  180   IF LEFT$(LEFT$(aTest$,FNn(27)),FNn(5)) <> "Antid" THEN STOP
  190   IF LEFT$(LEFT$(aTest$,FNn(6)),FNn(26)) <> "Antidi" THEN STOP
  200   
  210   IF RIGHT$(aTest$) <> "m" THEN STOP
  220   IF RIGHT$(RIGHT$(aTest$)) <> "m" THEN STOP
  230   IF LEFT$(RIGHT$(aTest$)) <> "" THEN STOP
  240   IF RIGHT$(LEFT$(aTest$)) <> "s" THEN STOP
  250   
  260   IF RIGHT$(aTest$,FNn(0)) <> "" THEN STOP
  270   IF RIGHT$(aTest$,FNn(1)) <> "m" THEN STOP
  280   IF RIGHT$(aTest$,FNn(2)) <> "sm" THEN STOP
  290   IF RIGHT$(aTest$,FNn(3)) <> "ism" THEN STOP
  300   IF RIGHT$(aTest$,FNn(FNn(4))) <> "nism" THEN STOP
  310   
  320   IF RIGHT$(aTest$, FNn(28)) <> aTest$ THEN STOP
  330   IF RIGHT$(aTest$, FNn(29)) <> "Antidisestablishmentarianism" THEN STOP
  340   IF RIGHT$(aTest$, 65535) <> "Antidisestablishmentarianism" THEN STOP
  350   IF RIGHT$(aTest$, -1) <> "Antidisestablishmentarianism" THEN STOP
  360   
  370   IF RIGHT$(RIGHT$(aTest$,FNn(27)),FNn(5)) <> "anism" THEN STOP
  380   IF RIGHT$(RIGHT$(aTest$,FNn(6)),FNn(26)) <> "ianism" THEN STOP
  390   
  400   IF LEFT$(RIGHT$(aTest$,FNn(27)),FNn(5)) <> "ntidi" THEN STOP
  410   IF RIGHT$(LEFT$(aTest$,FNn(6)),FNn(26)) <> "Antidi" THEN STOP
  420   
  430   IF MID$(aTest$,FNn(0)) <> aTest$ THEN STOP
  440   IF MID$(aTest$,FNn(1)) <> aTest$ THEN STOP
  450   IF MID$(aTest$,FNn(0)) <> "Antidisestablishmentarianism" THEN STOP
  460   IF MID$(aTest$,FNn(1)) <> "Antidisestablishmentarianism" THEN STOP
  470   
  480   IF MID$(aTest$,FNn(2)) <> "ntidisestablishmentarianism" THEN STOP
  490   IF MID$(aTest$,FNn(3)) <> "tidisestablishmentarianism" THEN STOP
  500   IF MID$(aTest$,FNn(4)) <> "idisestablishmentarianism" THEN STOP
  510   IF MID$(aTest$,FNn(5)) <> "disestablishmentarianism" THEN STOP
  520   
  530   IF MID$(aTest$,FNn(6),FNn(0)) <> "" THEN STOP
  540   IF MID$(aTest$,FNn(7),FNn(1)) <> "s" THEN STOP
  550   IF MID$(aTest$,FNn(8),FNn(2)) <> "es" THEN STOP
  560   IF MID$(aTest$,FNn(9),FNn(3)) <> "sta" THEN STOP
  570   IF MID$(aTest$,FNn(10),FNn(4)) <> "tabl" THEN STOP
  580   
  590   IF MID$(aTest$,FNn(11),FNn(18)) <> "ablishmentarianism" THEN STOP
  600   IF MID$(aTest$,FNn(12),FNn(19)) <> "blishmentarianism" THEN STOP
  610   IF MID$(aTest$,FNn(13),65535) <> "lishmentarianism" THEN STOP
  620   IF MID$(aTest$,FNn(14),-1) <> "ishmentarianism" THEN STOP
  630   
  640   IF LEFT$(MID$(aTest$,FNn(2))) <> "ntidisestablishmentarianis" THEN STOP
  650   IF RIGHT$(MID$(aTest$,FNn(3))) <> "m" THEN STOP
  660   IF MID$(LEFT$(aTest$),FNn(4)) <> "idisestablishmentarianis" THEN STOP
  670   IF MID$(RIGHT$(aTest$),FNn(5)) <> "" THEN STOP
  680   
  690   LEFT$(aTest$) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  700   LEFT$(aTest$,FNn(0)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  710   LEFT$(aTest$,FNn(5)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  720   LEFT$(aTest$,FNn(50)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  730   
  740   RIGHT$(aTest$) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  750   RIGHT$(aTest$,FNn(0)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  760   RIGHT$(aTest$,FNn(5)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  770   RIGHT$(aTest$,FNn(50)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  780   
  790   MID$(aTest$,FNn(0)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  800   MID$(aTest$,FNn(5)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  810   MID$(aTest$,FNn(50)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  820   MID$(aTest$,FNn(8),FNn(2)) = "" : IF aTest$ <> "Antidisestablishmentarianism" STOP
  830   
  840   short$ = "Replace"
  850   LEFT$(aTest$,FNn(0)) = short$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
  860   LEFT$(aTest$,FNn(3)) = short$ : IF aTest$ <> "Repidisestablishmentarianism" STOP
  870   aTest$ = "Antidisestablishmentarianism"
  880   LEFT$(aTest$,FNn(6)) = short$ : IF aTest$ <> "Replacsestablishmentarianism" STOP
  890   aTest$ = "Antidisestablishmentarianism"
  900   LEFT$(aTest$,FNn(7)) = short$ : IF aTest$ <> "Replaceestablishmentarianism" STOP
  910   aTest$ = "Antidisestablishmentarianism"
  920   LEFT$(aTest$,FNn(8)) = short$ : IF aTest$ <> "Replaceestablishmentarianism" STOP
  930   aTest$ = "Antidisestablishmentarianism"
  940   LEFT$(aTest$,FNn(50)) = short$ : IF aTest$ <> "Replaceestablishmentarianism" STOP
  950   aTest$ = "Antidisestablishmentarianism"
  960   LEFT$(aTest$) = short$ : IF aTest$ <> "Replaceestablishmentarianism" STOP
  970   
  980   aTest$ = "Antidisestablishmentarianism"
  990   RIGHT$(aTest$,FNn(0)) = short$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1000   RIGHT$(aTest$,FNn(3)) = short$ : IF aTest$ <> "AntidisestablishmentarianRep" STOP
 1010   aTest$ = "Antidisestablishmentarianism"
 1020   RIGHT$(aTest$,FNn(6)) = short$ : IF aTest$ <> "AntidisestablishmentarReplac" STOP
 1030   aTest$ = "Antidisestablishmentarianism"
 1040   RIGHT$(aTest$,FNn(7)) = short$ : IF aTest$ <> "AntidisestablishmentaReplace" STOP
 1050   aTest$ = "Antidisestablishmentarianism"
 1060   RIGHT$(aTest$,FNn(8)) = short$ : IF aTest$ <> "AntidisestablishmentaReplace" STOP
 1070   aTest$ = "Antidisestablishmentarianism"
 1080   RIGHT$(aTest$,FNn(50)) = short$ : IF aTest$ <> "AntidisestablishmentaReplace" STOP
 1090   aTest$ = "Antidisestablishmentarianism"
 1100   RIGHT$(aTest$) = short$ : IF aTest$ <> "AntidisestablishmentarianisR" STOP
 1110   
 1120   aTest$ = "Antidisestablishmentarianism"
 1130   MID$(aTest$,FNn(0)) = short$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1140   MID$(aTest$,FNn(3)) = short$ : IF aTest$ <> "AnReplacetablishmentarianism" STOP
 1150   aTest$ = "Antidisestablishmentarianism"
 1160   MID$(aTest$,FNn(6)) = short$ : IF aTest$ <> "AntidReplacelishmentarianism" STOP
 1170   aTest$ = "Antidisestablishmentarianism"
 1180   MID$(aTest$,FNn(7)) = short$ : IF aTest$ <> "AntidiReplaceishmentarianism" STOP
 1190   aTest$ = "Antidisestablishmentarianism"
 1200   MID$(aTest$,FNn(8)) = short$ : IF aTest$ <> "AntidisReplaceshmentarianism" STOP
 1210   aTest$ = "Antidisestablishmentarianism"
 1220   MID$(aTest$,FNn(50)) = short$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1230   
 1240   aTest$ = "Antidisestablishmentarianism"
 1250   MID$(aTest$,FNn(6),FNn(0)) = short$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1260   aTest$ = "Antidisestablishmentarianism"
 1270   MID$(aTest$,FNn(7),FNn(1)) = short$ : IF aTest$ <> "AntidiRestablishmentarianism" STOP
 1280   aTest$ = "Antidisestablishmentarianism"
 1290   MID$(aTest$,FNn(8),FNn(2)) = short$ : IF aTest$ <> "AntidisRetablishmentarianism" STOP
 1300   aTest$ = "Antidisestablishmentarianism"
 1310   MID$(aTest$,FNn(9),FNn(3)) = short$ : IF aTest$ <> "AntidiseRepblishmentarianism" STOP
 1320   aTest$ = "Antidisestablishmentarianism"
 1330   MID$(aTest$,FNn(10),FNn(4)) = short$ : IF aTest$ <> "AntidisesReplishmentarianism" STOP
 1340   aTest$ = "Antidisestablishmentarianism"
 1350   MID$(aTest$,FNn(11),FNn(18)) = short$ : IF aTest$ <> "AntidisestReplaceentarianism" STOP
 1360   aTest$ = "Antidisestablishmentarianism"
 1370   MID$(aTest$,FNn(12),FNn(19)) = short$ : IF aTest$ <> "AntidisestaReplacentarianism" STOP
 1380   aTest$ = "Antidisestablishmentarianism"
 1390   MID$(aTest$,FNn(23),65535) = short$ : IF aTest$ <> "AntidisestablishmentarReplac" STOP
 1400   aTest$ = "Antidisestablishmentarianism"
 1410   MID$(aTest$,FNn(24),-1) = short$ : IF aTest$ <> "AntidisestablishmentariRepla" STOP
 1420   aTest$ = "Antidisestablishmentarianism"
 1430   
 1440   long$ = "0123456789012345678901234567890123456789012345678901234567890123456789"
 1450   LEFT$(aTest$,FNn(0)) = long$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1460   LEFT$(aTest$,FNn(3)) = long$ : IF aTest$ <> "012idisestablishmentarianism" STOP
 1470   aTest$ = "Antidisestablishmentarianism"
 1480   LEFT$(aTest$,FNn(6)) = long$ : IF aTest$ <> "012345sestablishmentarianism" STOP
 1490   aTest$ = "Antidisestablishmentarianism"
 1500   LEFT$(aTest$,FNn(7)) = long$ : IF aTest$ <> "0123456establishmentarianism" STOP
 1510   aTest$ = "Antidisestablishmentarianism"
 1520   LEFT$(aTest$,FNn(8)) = long$ : IF aTest$ <> "01234567stablishmentarianism" STOP
 1530   aTest$ = "Antidisestablishmentarianism"
 1540   LEFT$(aTest$,FNn(50)) = long$ : IF aTest$ <> "0123456789012345678901234567" STOP
 1550   aTest$ = "Antidisestablishmentarianism"
 1560   LEFT$(aTest$) = long$ : IF aTest$ <> "012345678901234567890123456m" STOP
 1570   
 1580   aTest$ = "Antidisestablishmentarianism"
 1590   RIGHT$(aTest$,FNn(0)) = long$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1600   RIGHT$(aTest$,FNn(3)) = long$ : IF aTest$ <> "Antidisestablishmentarian012" STOP
 1610   aTest$ = "Antidisestablishmentarianism"
 1620   RIGHT$(aTest$,FNn(6)) = long$ : IF aTest$ <> "Antidisestablishmentar012345" STOP
 1630   aTest$ = "Antidisestablishmentarianism"
 1640   RIGHT$(aTest$,FNn(7)) = long$ : IF aTest$ <> "Antidisestablishmenta0123456" STOP
 1650   aTest$ = "Antidisestablishmentarianism"
 1660   RIGHT$(aTest$,FNn(8)) = long$ : IF aTest$ <> "Antidisestablishment01234567" STOP
 1670   aTest$ = "Antidisestablishmentarianism"
 1680   RIGHT$(aTest$,FNn(50)) = long$ : IF aTest$ <> "0123456789012345678901234567" STOP
 1690   aTest$ = "Antidisestablishmentarianism"
 1700   RIGHT$(aTest$) = long$ : IF aTest$ <> "Antidisestablishmentarianis0" STOP
 1710   
 1720   aTest$ = "Antidisestablishmentarianism"
 1730   MID$(aTest$,FNn(0)) = long$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1740   MID$(aTest$,FNn(3)) = long$ : IF aTest$ <> "An01234567890123456789012345" STOP
 1750   aTest$ = "Antidisestablishmentarianism"
 1760   MID$(aTest$,FNn(6)) = long$ : IF aTest$ <> "Antid01234567890123456789012" STOP
 1770   aTest$ = "Antidisestablishmentarianism"
 1780   MID$(aTest$,FNn(7)) = long$ : IF aTest$ <> "Antidi0123456789012345678901" STOP
 1790   aTest$ = "Antidisestablishmentarianism"
 1800   MID$(aTest$,FNn(8)) = long$ : IF aTest$ <> "Antidis012345678901234567890" STOP
 1810   aTest$ = "Antidisestablishmentarianism"
 1820   MID$(aTest$,FNn(50)) = long$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1830   
 1840   aTest$ = "Antidisestablishmentarianism"
 1850   MID$(aTest$,FNn(6),FNn(0)) = long$ : IF aTest$ <> "Antidisestablishmentarianism" STOP
 1870   MID$(aTest$,FNn(7),FNn(1)) = long$ : IF aTest$ <> "Antidi0establishmentarianism" STOP
 1880   aTest$ = "Antidisestablishmentarianism"
 1890   MID$(aTest$,FNn(8),FNn(2)) = long$ : IF aTest$ <> "Antidis01tablishmentarianism" STOP
 1900   aTest$ = "Antidisestablishmentarianism"
 1910   MID$(aTest$,FNn(9),FNn(3)) = long$ : IF aTest$ <> "Antidise012blishmentarianism" STOP
 1920   aTest$ = "Antidisestablishmentarianism"
 1930   MID$(aTest$,FNn(10),FNn(4)) = long$ : IF aTest$ <> "Antidises0123ishmentarianism" STOP
 1940   aTest$ = "Antidisestablishmentarianism"
 1950   MID$(aTest$,FNn(11),FNn(18)) = long$ : IF aTest$ <> "Antidisest012345678901234567" STOP
 1960   aTest$ = "Antidisestablishmentarianism"
 1970   MID$(aTest$,FNn(12),FNn(19)) = long$ : IF aTest$ <> "Antidisesta01234567890123456" STOP
 1980   aTest$ = "Antidisestablishmentarianism"
 1990   MID$(aTest$,FNn(23),65535) = long$ : IF aTest$ <> "Antidisestablishmentar012345" STOP
 2000   aTest$ = "Antidisestablishmentarianism"
 2010   MID$(aTest$,FNn(24),-1) = long$ : IF aTest$ <> "Antidisestablishmentari01234" STOP
 2020   
 2030   DEF FNn(N%) = LEN(MID$(STRING$(2*N%,"X"),N%DIV2,N%))
 2040   
 2050   PRINT "String slicing tests completed."
