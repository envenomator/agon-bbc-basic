   10 REM ============================================================
   20 REM 32x32 -> 64 multiply test harness for BBC BASIC
   30 REM
   40 REM Replace PROCasmmul at lines 9000-9070 with your MULX call.
   50 REM
   60 REM Operands are unsigned 32-bit, passed as:
   70 REM   AH%:AL% and BH%:BL%
   80 REM where each half is a 16-bit unsigned word 0..65535.
   90 REM
  100 REM Returned / compared result is 64-bit as four 16-bit words:
  110 REM   R3%:R2%:R1%:R0%
  120 REM ============================================================

  130 MODE 7
  140 ON ERROR PRINT REPORT$;" at line ";ERL : END

  150 DIM EDGE%(63)
  160 DIM OPH%(1023), OPL%(1023)
  170 DIM AB%(3), BB%(3), S%(7)

  180 PROCinitedges
  190 PROCbuildops

  200 PRINT "Operand cases built: ";OPN%
  210 PRINT "Running pairwise boundary tests..."
  220 PRINT

  230 FAIL%=0
  240 TESTS%=0

  250 FOR I%=0 TO OPN%-1
  260   FOR J%=0 TO OPN%-1
  270     PROCtestpair(OPH%(I%), OPL%(I%), OPH%(J%), OPL%(J%))
  280   NEXT
  290 NEXT

  300 PRINT
  310 PRINT "Running random tests..."
  320 FOR I%=1 TO 5000
  330   AH%=RND(65536)-1
  340   AL%=RND(65536)-1
  350   BH%=RND(65536)-1
  360   BL%=RND(65536)-1
  370   PROCtestpair(AH%, AL%, BH%, BL%)
  380 NEXT

  390 PRINT
  400 PRINT "Tests run : ";TESTS%
  410 PRINT "Failures  : ";FAIL%
  420 IF FAIL%=0 PRINT "All tests passed."
  430 END

 1000 DEF PROCinitedges
 1010 LOCAL I%,V%
 1020 RESTORE 8000
 1030 I%=0
 1040 REPEAT
 1050   READ V%
 1060   IF V%<>-1 EDGE%(I%)=V% : I%=I%+1
 1070 UNTIL V%=-1
 1080 EDGECOUNT%=I%
 1090 ENDPROC

 1100 DEF PROCbuildops
 1110 LOCAL I%,V%
 1120 OPN%=0
 1130 REM Core edge-driven patterns
 1140 FOR I%=0 TO EDGECOUNT%-1
 1150   V%=EDGE%(I%)
 1160   PROCaddop(0, V%)
 1170   PROCaddop(V%, 0)
 1180   PROCaddop(V%, V%)
 1190   PROCaddop(65535, V%)
 1200   PROCaddop(V%, 65535)
 1210   PROCaddop(65535-V%, V%)
 1220   PROCaddop(V%, 65535-V%)
 1230 NEXT
 1240 REM Fixed byte/word patterns
 1250 PROCaddop(&0000, &0000)
 1260 PROCaddop(&0000, &0001)
 1270 PROCaddop(&0000, &00FF)
 1280 PROCaddop(&0000, &0100)
 1290 PROCaddop(&0000, &7FFF)
 1300 PROCaddop(&0000, &8000)
 1310 PROCaddop(&0000, &FFFF)
 1320 PROCaddop(&0001, &0000)
 1330 PROCaddop(&0001, &0001)
 1340 PROCaddop(&0001, &FFFF)
 1350 PROCaddop(&00FF, &00FF)
 1360 PROCaddop(&00FF, &FF00)
 1370 PROCaddop(&0100, &0100)
 1380 PROCaddop(&7FFF, &7FFF)
 1390 PROCaddop(&8000, &8000)
 1400 PROCaddop(&FFFF, &0001)
 1410 PROCaddop(&FFFF, &FFFF)
 1420 PROCaddop(&00FF, &FFFF)
 1430 PROCaddop(&FFFF, &00FF)
 1440 PROCaddop(&FF00, &00FF)
 1450 PROCaddop(&00FF, &FF00)
 1460 PROCaddop(&1234, &5678)
 1470 PROCaddop(&89AB, &CDEF)
 1480 PROCaddop(&1357, &9BDF)
 1490 PROCaddop(&AAAA, &5555)
 1500 PROCaddop(&5555, &AAAA)
 1510 PROCdedup
 1520 ENDPROC

 1600 DEF PROCaddop(HI%, LO%)
 1610 IF HI%<0 HI%=HI%+65536
 1620 IF LO%<0 LO%=LO%+65536
 1630 OPH%(OPN%)=HI%
 1640 OPL%(OPN%)=LO%
 1650 OPN%=OPN%+1
 1660 ENDPROC

 1700 DEF PROCdedup
 1710 LOCAL I%,J%,K%
 1720 FOR I%=0 TO OPN%-1
 1730   J%=I%+1
 1740   REPEAT
 1750     IF J%>=OPN% THEN EXIT REPEAT
 1760     IF OPH%(I%)=OPH%(J%) AND OPL%(I%)=OPL%(J%) THEN
 1770       FOR K%=J% TO OPN%-2
 1780         OPH%(K%)=OPH%(K%+1)
 1790         OPL%(K%)=OPL%(K%+1)
 1800       NEXT
 1810       OPN%=OPN%-1
 1820     ELSE
 1830       J%=J%+1
 1840     ENDIF
 1850   UNTIL FALSE
 1860 NEXT
 1870 ENDPROC

 2000 DEF PROCtestpair(AH%, AL%, BH%, BL%)
 2010 TESTS%=TESTS%+1
 2020 PROCrefmul(AH%, AL%, BH%, BL%)
 2030 PROCasmmul(AH%, AL%, BH%, BL%)

 2040 IF R0%<>T0% OR R1%<>T1% OR R2%<>T2% OR R3%<>T3% THEN
 2050   FAIL%=FAIL%+1
 2060   PRINT "FAIL ";FAIL%
 2070   PRINT "  A=&";FNHEX8(AH%,AL%)
 2080   PRINT "  B=&";FNHEX8(BH%,BL%)
 2090   PRINT "  expected =&";FNHEX16(R3%,R2%,R1%,R0%)
 2100   PRINT "       got =&";FNHEX16(T3%,T2%,T1%,T0%)
 2110   PRINT
 2120   IF FAIL%>=50 THEN PRINT "Stopping after 50 failures." : END
 2130 ENDIF
 2140 ENDPROC

 3000 DEF PROCrefmul(AH%, AL%, BH%, BL%)
 3010 LOCAL I%,J%,K%,C%
 3020 AB%(0)=AL% MOD 256
 3030 AB%(1)=AL% DIV 256
 3040 AB%(2)=AH% MOD 256
 3050 AB%(3)=AH% DIV 256
 3060 BB%(0)=BL% MOD 256
 3070 BB%(1)=BL% DIV 256
 3080 BB%(2)=BH% MOD 256
 3090 BB%(3)=BH% DIV 256

 3100 FOR I%=0 TO 7
 3110   S%(I%)=0
 3120 NEXT

 3130 FOR I%=0 TO 3
 3140   FOR J%=0 TO 3
 3150     S%(I%+J%)=S%(I%+J%)+AB%(I%)*BB%(J%)
 3160   NEXT
 3170 NEXT

 3180 FOR K%=0 TO 6
 3190   C%=S%(K%) DIV 256
 3200   S%(K%)=S%(K%) MOD 256
 3210   S%(K%+1)=S%(K%+1)+C%
 3220 NEXT
 3230 S%(7)=S%(7) MOD 256

 3240 R0%=S%(0)+256*S%(1)
 3250 R1%=S%(2)+256*S%(3)
 3260 R2%=S%(4)+256*S%(5)
 3270 R3%=S%(6)+256*S%(7)
 3280 ENDPROC

 4000 DEF FNHEX4(W%)
 4010 LOCAL D%,S$
 4020 W%=W% MOD 65536
 4030 S$=""
 4040 FOR D%=3 TO 0 STEP -1
 4050   S$=S$+MID$("0123456789ABCDEF", (W% DIV (16^D%)) MOD 16 + 1, 1)
 4060 NEXT
 4070 =S$

 4100 DEF FNHEX8(HI%,LO%)
 4110 =FNHEX4(HI%)+FNHEX4(LO%)

 4200 DEF FNHEX16(W3%,W2%,W1%,W0%)
 4210 =FNHEX4(W3%)+FNHEX4(W2%)+FNHEX4(W1%)+FNHEX4(W0%)

 9000 DEF PROCasmmul(AH%, AL%, BH%, BL%)
 9010 REM ============================================================
 9020 REM Replace this stub with your actual MULX call.
 9030 REM It must set:
 9040 REM   T0% = low  16 bits
 9050 REM   T1% = next 16 bits
 9060 REM   T2% = next 16 bits
 9070 REM   T3% = high 16 bits
 9080 REM
 9090 REM Temporary default: use reference result so the harness runs.
 9100 REM ============================================================
 9110 PROCrefmul(AH%, AL%, BH%, BL%)
 9120 T0%=R0%
 9130 T1%=R1%
 9140 T2%=R2%
 9150 T3%=R3%
 9160 ENDPROC

 8000 DATA 0
 8010 DATA 1,2,3,4,7,8,15,16,31,32,63,64,127,128
 8020 DATA 255,256,257,511,512,513
 8030 DATA 1023,1024,1025,2047,2048,2049
 8040 DATA 4095,4096,4097,8191,8192,8193
 8050 DATA 16383,16384,16385,32767,32768,32769
 8060 DATA 49151,49152,49153,65279,65280,65281
 8070 DATA 65533,65534,65535
 8080 DATA -1
