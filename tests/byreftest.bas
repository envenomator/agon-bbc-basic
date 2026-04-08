   10 PRINT "Running Byref tests..."
   20 
   30 DIM D% 0, E% 3, G% 255, H% 9, I% 255
   40 DIM dd% 0, ee% 3, gg% 255, hh% 9, ii% 255
   50 
   60 Exp2 = EXP(2)
   70 Ln2 = LN(2)
   80 Log2 = LOG(2)
   90 PiSq = PI^2
  110 
  120 REM Initialise dummies
  130 
  140 A = PI
  150 B% = 12345678
  170 ?D% = &55
  180 !E% = &12345678
  190 F$ = "WOMBAT"
  200 $G% = "Antelope"
  210 |H% = PI^3
  230 J% = 2^31-1
  240 K& = 132
  250 
  260 REM. Initialise by-reference parameters
  270 
  280 aa = EXP(1)
  290 bb% = 98765432
  310 ?dd% = &AA
  320 !ee% = &98765432
  330 ff$ = "Frog"
  340 $gg% = "Wolverine"
  350 |hh% = EXP(3)
  370 jj% = &80000000
  380 k& = 231
  390 
  400 PROC1(A, aa, bb%, ?dd%, !ee%, ff$, $gg%, |hh%, jj%, k&)
  410 
  420 REM. Check that by-reference parameters were returned correctly from PROC
  430 
  440 IF aa <> LN(1)  STOP
  450 IF bb% <> 55555555  STOP
  470 IF ?dd% <> &5A  STOP
  480 IF !ee% <> &A5A5A5A5  STOP
  490 IF ff$ <> "Marsupial"  STOP
  500 IF $gg% <> "Spiny Anteater"  STOP
  510 IF |hh% <> LN(3)  STOP
  530 IF jj% <> 1111111111  STOP
  540 IF k& <> 111  STOP
  550 
  560 IF "Test string" <> FN1(A, aa, bb%, ?dd%, !ee%, ff$, $gg%, |hh%, jj%, k&) STOP
  570 
  580 REM. Check that by-reference parameters were returned correctly from FN
  590 
  600 IF aa <> LOG(1)  STOP
  610 IF bb% <> 66666666  STOP
  630 IF ?dd% <> &A5  STOP
  640 IF !ee% <> &5A5A5A5A  STOP
  650 IF ff$ <> "Toad"  STOP
  660 IF $gg% <> "Kangaroo"  STOP
  670 IF |hh% <> LOG(3)  STOP
  690 IF jj% <> -555555555  STOP
  700 IF k& <> 55  STOP
  710 
  720 REM. Check that dummies were correctly restored
  730 
  740 IF A <> PI  STOP
  750 IF B% <> 12345678  STOP
  770 IF ?D% <> &55  STOP
  780 IF !E% <> &12345678  STOP
  790 IF F$ <> "WOMBAT"  STOP
  800 IF $G% <> "Antelope"  STOP
  810 IF |H% <> PI^3  STOP
  830 IF J% <> 2^31-1  STOP
  840 IF K& <> 132
  850 
  860 PRINT "Byref tests completed."
  870 ON ERROR END
  880 RETURN
  890 ;
  900 DEF PROC1(RETURN aa, RETURN A, RETURN B%, RETURN ?D%, RETURN !E%, RETURN F$, RETURN $G%, RETURN |H%, RETURN J%, RETURN K&)
  910 
  920 REM. Check that dummies were correctly loaded
  930 
  940 IF A <> EXP(1)  STOP
  950 IF B% <> 98765432  STOP
  970 IF ?D% <> &AA  STOP
  980 IF !E% <> &98765432  STOP
  990 IF F$ <> "Frog"  STOP
 1000 IF $G% <> "Wolverine"  STOP
 1010 IF |H% <> EXP(3)  STOP
 1030 IF jj% <> &80000000  STOP
 1040 IF k& <> 231  STOP
 1050 
 1060 REM. Modify dummies, for transfer to by-reference parameters
 1070 
 1080 A = LN(1)
 1090 B% = 55555555
 1110 ?D% = &5A
 1120 !E% = &A5A5A5A5
 1130 F$ = "Marsupial"
 1140 $G% = "Spiny Anteater"
 1150 |H% = LN(3)
 1170 J% = 1111111111
 1180 K& = 111
 1190 
 1200 ENDPROC
 1210 ;
 1220 DEF FN1(RETURN aa, RETURN A, RETURN B%, RETURN ?D%, RETURN !E%, RETURN F$, RETURN $G%, RETURN |H%, RETURN J%, RETURN K&)
 1230 
 1240 REM. Check that dummies were correctly loaded
 1250 
 1260 IF A <> LN(1)  STOP
 1270 IF B% <> 55555555  STOP
 1290 IF ?D% <> &5A  STOP
 1300 IF !E% <> &A5A5A5A5  STOP
 1310 IF F$ <> "Marsupial"  STOP
 1320 IF $G% <> "Spiny Anteater"  STOP
 1330 IF |H% <> LN(3)  STOP
 1350 IF J% <> 1111111111  STOP
 1360 IF K& <> 111  STOP
 1370 
 1380 REM. Modify dummies, for transfer to by-reference parameters
 1390 
 1400 A = LOG(1)
 1410 B% = 66666666
 1430 ?D% = &A5
 1440 !E% = &5A5A5A5A
 1450 F$ = "Toad"
 1460 $G% = "Kangaroo"
 1470 |H% = LOG(3)
 1490 J% = -555555555
 1500 K& = 55
 1510 
 1520 = "Test string"
