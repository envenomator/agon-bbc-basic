   10 REM =============================================================
   20 REM BBC BASIC V / Z80 ALL TESTS COMBINED CONFORMANCE SUITE
   30 REM Quiet summary build: only final pass/fail overview is printed
   40 REM =============================================================
   50 MODE 0
   55 ON ERROR PRINT "FATAL ";REPORT$;" AT LINE ";ERL : END
   60 vCh%=OPENOUT("ALLSUM.DAT")
   70 PRINT#vCh%,"INIT",0,0,0
   80 CLOSE#vCh%
   90 PRINT "BBC BASIC V ALL TESTS"
  100 PRINT "Running tests; final summary will be shown at the end."
  105 PRINT "Running L1"
  110 PROCrun_L1
  120 PROCsave_summary("L1")
  130 CLEAR
  135 PRINT "Running L2"
  140 PROCrun_L2
  150 PROCsave_summary("L2")
  160 CLEAR
  165 PRINT "Running L3A"
  170 PROCrun_L3A
  180 PROCsave_summary("L3A")
  190 CLEAR
  195 PRINT "Running L3B"
  200 PROCrun_L3B
  210 PROCsave_summary("L3B")
  220 CLEAR
  225 PRINT "Running L4A"
  230 PROCrun_L4A
  240 PROCsave_summary("L4A")
  250 CLEAR
  255 PRINT "Running L4B"
  260 PROCrun_L4B
  270 PROCsave_summary("L4B")
  280 CLEAR
  285 PRINT "Running L4C"
  290 PROCrun_L4C
  300 PROCsave_summary("L4C")
  310 CLEAR
  315 PRINT "Running L5A"
  320 PROCrun_L5A
  330 PROCsave_summary("L5A")
  340 CLEAR
  345 PRINT "Running L5B"
  350 PROCrun_L5B
  360 PROCsave_summary("L5B")
  370 CLEAR
  375 PRINT "Running L5C"
  380 PROCrun_L5C
  390 PROCsave_summary("L5C")
  400 CLEAR
  405 PRINT "Running L5D"
  410 PROCrun_L5D
  420 PROCsave_summary("L5D")
  430 CLEAR
  435 PRINT "Running L5E"
  440 PROCrun_L5E
  450 PROCsave_summary("L5E")
  460 CLEAR
  465 PRINT "Running L5F"
  470 PROCrun_L5F
  480 PROCsave_summary("L5F")
  490 CLEAR
  495 PRINT "Running L5G"
  500 PROCrun_L5G
  510 PROCsave_summary("L5G")
  520 PROCshow_all_summary
  530 END
  540 DEF PROCsection(sName$)
  550 ENDPROC
  560 DEF PROCok(sName$)
  570 vTest%=vTest%+1
  580 vPass%=vPass%+1
  590 ENDPROC
  600 DEF PROCbad_i(sName$,vGot%,vExp%)
  610 vTest%=vTest%+1
  620 vFail%=vFail%+1
  630 IF vFailIdx%<100 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
  640 ENDPROC
  650 DEF PROCbad_r(sName$,vGot,vExp)
  660 vTest%=vTest%+1
  670 vFail%=vFail%+1
  680 IF vFailIdx%<100 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
  690 ENDPROC
  700 DEF PROCbad_s(sName$,sGot$,sExp$)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 IF vFailIdx%<100 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
  740 ENDPROC
  750 DEF PROCcheck_i(sName$,vGot%,vExp%)
  760 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  770 ENDPROC
  780 DEF PROCcheck_r(sName$,vGot,vExp,vTol)
  790 IF ABS(vGot-vExp)<=vTol THEN PROCok(sName$) ELSE PROCbad_r(sName$,vGot,vExp)
  800 ENDPROC
  810 DEF PROCcheck_s(sName$,sGot$,sExp$)
  820 IF sGot$=sExp$ THEN PROCok(sName$) ELSE PROCbad_s(sName$,sGot$,sExp$)
  830 ENDPROC
  840 DEF PROCcheck_t(sName$,vFlag%)
  850 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
  860 ENDPROC
  870 DEF PROCshow_failures
  880 ENDPROC
 1100 DEF PROCrun_L1
 1110 vPass%=0 : vFail%=0 : vTest%=0
 1120 DIM vFailName$(100) : vFailIdx%=0
 1130 REM ==============================================================
 1140 REM BBC BASIC V / Z80 LANGUAGE TEST HARNESS
 1150 REM SAFE-NAME VERSION FOR PORT VALIDATION
 1160 REM ==============================================================
 1170 REM quiet output suppressed
 1180 REM quiet output suppressed
 1190 PROCsection("NUMERIC EXPRESSIONS")
 1200 PROCL1_test_numeric
 1210 PROCsection("CONVERSIONS")
 1220 PROCsection("VAL")
 1230 PROCL1_test_val
 1240 PROCsection("STRINGS")
 1250 PROCL1_test_strings
 1260 PROCsection("FLOW CONTROL")
 1270 PROCL1_test_flow
 1280 PROCsection("PROCEDURES AND FUNCTIONS")
 1290 PROCL1_test_procfn
 1300 PROCsection("DATA / READ / RESTORE")
 1310 PROCL1_test_data
 1320 PROCsection("ARRAYS")
 1330 PROCL1_test_arrays
 1340 PROCsection("MEMORY / INDIRECTION")
 1350 PROCL1_test_memory
 1360 PROCsection("ERROR HANDLING")
 1370 PROCL1_test_errors
 1380 REM quiet output suppressed
 1390 REM quiet output suppressed
 1400 REM quiet output suppressed
 1410 REM quiet output suppressed
 1420 REM quiet output suppressed
 1430 REM quiet output suppressed
 1440 ENDPROC
 1450 DEF PROCL1_test_numeric
 1460 LOCAL vN%
 1470 PROCcheck_i("precedence 7+5*3",7+5*3,22)
 1480 PROCcheck_i("brackets (7+5)*3",(7+5)*3,36)
 1490 PROCcheck_i("DIV",17 DIV 5,3)
 1500 PROCcheck_i("MOD",17 MOD 5,2)
 1510 vN%=123456
 1520 PROCcheck_i("integer assignment",vN%,123456)
 1530 PROCcheck_i("hex literal",&1234,4660)
 1540 PROCcheck_i("binary literal",%101101,45)
 1550 PROCcheck_i("TRUE",TRUE,-1)
 1560 PROCcheck_i("FALSE",FALSE,0)
 1570 PROCcheck_i("NOT FALSE",NOT FALSE,-1)
 1580 PROCcheck_i("AND",5 AND 3,1)
 1590 PROCcheck_i("OR",5 OR 2,7)
 1600 PROCcheck_i("EOR",5 EOR 3,6)
 1610 PROCcheck_i("shift left",1<<4,16)
 1620 PROCcheck_i("shift right",16>>2,4)
 1630 PROCcheck_r("ABS",ABS(-12.5),12.5,1E-9)
 1640 PROCcheck_i("INT positive",INT(99.8),99)
 1650 PROCcheck_i("INT negative",INT(-12.1),-13)
 1660 PROCcheck_i("SGN negative",SGN(-2),-1)
 1670 PROCcheck_i("SGN zero",SGN(0),0)
 1680 PROCcheck_i("SGN positive",SGN(3),1)
 1690 PROCcheck_r("SQR",SQR(81),9,1E-9)
 1700 PROCcheck_r("SIN(pi/2)",SIN(PI/2),1,1E-7)
 1710 PROCcheck_r("COS(0)",COS(0),1,1E-7)
 1720 PROCcheck_r("EXP(LN(5))",EXP(LN(5)),5,1E-7)
 1730 ENDPROC
 1740 DEF PROCL1_test_strings
 1750 LOCAL sA$,sB$,sC$
 1760 sA$="AGON"
 1770 sB$="BBC BASIC"
 1780 PROCcheck_i("LEN",LEN(sB$),9)
 1790 PROCcheck_s("LEFT$",LEFT$(sB$,3),"BBC")
 1800 PROCcheck_s("RIGHT$",RIGHT$(sB$,5),"BASIC")
 1810 PROCcheck_s("MID$ fixed",MID$(sB$,5,3),"BAS")
 1820 PROCcheck_s("MID$ to end",MID$(sB$,8),"IC")
 1830 PROCcheck_i("INSTR found",INSTR("HELLO WORLD","WORLD"),7)
 1840 PROCcheck_i("INSTR missing",INSTR("HELLO WORLD","ZZ"),0)
 1850 PROCcheck_i("ASC",ASC("A"),65)
 1860 PROCcheck_s("CHR$",CHR$(66),"B")
 1870 PROCcheck_i("VAL decimal",VAL("1234"),1234)
 1880 sC$="BBC BASIC"
 1890 LEFT$(sC$,3)="ZZ"
 1900 PROCcheck_s("LEFT$ assignment",sC$,"ZZC BASIC")
 1910 sC$="ABC"
 1920 sC$=sC$+"DEF"
 1930 PROCcheck_s("concatenation",sC$,"ABCDEF")
 1940 ENDPROC
 1950 DEF PROCL1_test_flow
 1960 LOCAL vI%,vSum%,vCnt%,vMark%,vDone%
 1970 vSum%=0
 1980 FOR vI%=1 TO 10
 1990   vSum%=vSum%+vI%
 2000 NEXT
 2010 PROCcheck_i("FOR/NEXT sum 1..10",vSum%,55)
 2020 vSum%=0
 2030 FOR vI%=5 TO 1 STEP -2
 2040   vSum%=vSum%+vI%
 2050 NEXT
 2060 PROCcheck_i("FOR STEP -2",vSum%,9)
 2070 vCnt%=0
 2080 REPEAT
 2090   vCnt%=vCnt%+1
 2100 UNTIL vCnt%=4
 2110 PROCcheck_i("REPEAT/UNTIL",vCnt%,4)
 2120 vCnt%=0
 2130 WHILE vCnt%<3
 2140   vCnt%=vCnt%+1
 2150 ENDWHILE
 2160 PROCcheck_i("WHILE/ENDWHILE",vCnt%,3)
 2170 vSum%=0
 2180 FOR vI%=1 TO 10
 2190   IF vI%=6 THEN EXIT FOR
 2200   vSum%=vSum%+vI%
 2210 NEXT
 2220 PROCcheck_i("EXIT FOR",vSum%,15)
 2230 vCnt%=0
 2240 REPEAT
 2250   vCnt%=vCnt%+1
 2260   IF vCnt%=3 THEN EXIT REPEAT
 2270 UNTIL FALSE
 2280 PROCcheck_i("EXIT REPEAT",vCnt%,3)
 2290 vCnt%=0
 2300 WHILE TRUE
 2310   vCnt%=vCnt%+1
 2320   IF vCnt%=2 THEN EXIT WHILE
 2330 ENDWHILE
 2340 PROCcheck_i("EXIT WHILE",vCnt%,2)
 2350 vMark%=0
 2360 ON 2 GOSUB 3170,3180,3190 ELSE 9030
 2370 PROCcheck_i("ON GOSUB",vMark%,22)
 2380 vDone%=0
 2390 IF 3<4 THEN vDone%=111 ELSE vDone%=222
 2400 PROCcheck_i("IF THEN ELSE single-line",vDone%,111)
 2410 vDone%=0
 2420 IF 2=2 THEN
 2430   vDone%=77
 2440 ELSE
 2450   vDone%=99
 2460 ENDIF
 2470 PROCcheck_i("IF THEN ENDIF multi-line",vDone%,77)
 2480 ENDPROC
 2490 DEF PROCL1_test_procfn
 2500 LOCAL vOut%,vTmp%
 2510 PROCL1_double(7,vOut%)
 2520 PROCcheck_i("PROC parameter writeback",vOut%,14)
 2530 PROCcheck_i("FN square",FNL1_square(9),81)
 2540 PROCcheck_i("recursive FN factorial",FNL1_fact(6),720)
 2550 PROCcheck_s("FN reverse",FNL1_reverse("AGON"),"NOGA")
 2560 ENDPROC
 2570 DEF PROCL1_test_data
 2580 LOCAL vA%,vB%,sA$,sB$
 2590 RESTORE 3210
 2600 READ vA%,vB%,sA$
 2610 PROCcheck_i("READ item 1",vA%,10)
 2620 PROCcheck_i("READ item 2",vB%,20)
 2630 PROCcheck_s("READ item 3",sA$,"THIRTY")
 2640 RESTORE 3220
 2650 READ sB$
 2660 PROCcheck_s("RESTORE to line",sB$,"ALPHA")
 2670 ENDPROC
 2680 DEF PROCL1_test_arrays
 2690 DIM aI%(2)
 2700 aI%()=1,2,3
 2710 PROCcheck_i("array element 0",aI%(0),1)
 2720 PROCcheck_i("array element 2",aI%(2),3)
 2730 PROCcheck_i("SUM integer array",SUM(aI%()),6)
 2740 DIM bI%(2)
 2750 bI%()=10
 2760 PROCcheck_i("single-value array init 0",bI%(0),10)
 2770 PROCcheck_i("single-value array init 2",bI%(2),10)
 2780 bI%()=bI%()+aI%()
 2790 PROCcheck_i("whole-array add 0",bI%(0),11)
 2800 PROCcheck_i("whole-array add 1",bI%(1),12)
 2810 PROCcheck_i("whole-array add 2",bI%(2),13)
 2820 DIM aR(2)
 2830 aR()=3,4,12
 2840 PROCcheck_r("array MOD function",MOD(aR()),13,1E-7)
 2850 DIM aS$(2)
 2860 aS$()="AG","ON","!"
 2870 PROCcheck_s("SUM string array",SUM(aS$()),"AGON!")
 2880 PROCcheck_i("SUMLEN string array",SUMLEN(aS$()),5)
 2890 ENDPROC
 2900 DEF PROCL1_test_memory
 2910 LOCAL vBase%,vP%,vR%,vS%
 2920 DIM mBlk% 31
 2930 vBase%=mBlk%
 2940 ?vBase%=&12
 2950 vBase%?1=&34
 2960 PROCcheck_i("? unary read",?vBase%,&12)
 2970 PROCcheck_i("? dyadic read",vBase%?1,&34)
 2980 vP%=vBase%+4
 2990 !vP%=&12345678
 3000 PROCcheck_i("! read back",!vP%,&12345678)
 3010 PROCcheck_i("! byte 0",vP%?0,&78)
 3020 PROCcheck_i("! byte 1",vP%?1,&56)
 3030 PROCcheck_i("! byte 2",vP%?2,&34)
 3040 PROCcheck_i("! byte 3",vP%?3,&12)
 3050 vR%=vBase%+12
 3060 |vR%=PI
 3070 PROCcheck_r("| read back",|vR%,PI,1E-7)
 3080 vS%=vBase%+20
 3090 $vS%="ABCDEF"
 3100 PROCcheck_s("$ read back",$vS%,"ABCDEF")
 3110 ENDPROC
 3120 DEF PROCL1_test_errors
 3130 LOCAL vErr%
 3140 PROCL1_divzero(vErr%)
 3150 PROCcheck_i("ON ERROR LOCAL catches div/0",vErr%,18)
 3160 ENDPROC
 3170 vMark%=11 : RETURN
 3180 vMark%=22 : RETURN
 3190 vMark%=33 : RETURN
 3200 vMark%=44 : RETURN
 3210 DATA 10,20,"THIRTY"
 3220 DATA "ALPHA","BETA","GAMMA"
 3230 DEF PROCL1_double(vIn%,RETURN vOut%)
 3240 vOut%=vIn%*2
 3250 ENDPROC
 3260 DEF FNL1_square(vN)=vN*vN
 3270 DEF FNL1_fact(vN)
 3280 IF vN<2 THEN =1
 3290 =vN*FNL1_fact(vN-1)
 3300 DEF FNL1_reverse(sA$)
 3310 LOCAL sB$,vI%
 3320 FOR vI%=1 TO LEN(sA$)
 3330   sB$=MID$(sA$,vI%,1)+sB$
 3340 NEXT
 3350 =sB$
 3360 DEF PROCL1_divzero(RETURN vErr%)
 3370 LOCAL vX%
 3380 ON ERROR LOCAL vErr%=ERR : ENDPROC
 3390 vX%=1/0
 3400 vErr%=0
 3410 ENDPROC
 3420 DEF PROCL1_test_val
 3430 LOCAL vR
 3440 PROCcheck_i("VAL integer",VAL("123"),123)
 3450 PROCcheck_i("VAL negative integer",VAL("-45"),-45)
 3460 vR=VAL("12.5")
 3470 PROCcheck_r("VAL real",vR,12.5,1E-6)
 3480 vR=VAL("-3.75")
 3490 PROCcheck_r("VAL negative real",vR,-3.75,1E-6)
 3500 PROCcheck_i("VAL leading spaces",VAL("   42"),42)
 3510 PROCcheck_i("VAL trailing spaces",VAL("99   "),99)
 3520 PROCcheck_i("VAL STR$ roundtrip",VAL(STR$(456)),456)
 3530 vR=VAL("1.25E2")
 3540 PROCcheck_r("VAL exponent",vR,125,1E-5)
 3550 PROCcheck_i("VAL zero",VAL("0"),0)
 3560 ENDPROC
 3600 DEF PROCrun_L2
 3610 vPass%=0 : vFail%=0 : vTest%=0
 3620 DIM vFailName$(100) : vFailIdx%=0
 3630 REM ==============================================================
 3640 REM BBC BASIC V / Z80 LANGUAGE TEST HARNESS - LEVEL 2
 3650 REM EDGE CASES / CORNER CASES / STRESS SEMANTICS
 3660 REM ==============================================================
 3670 vMark%=0
 3680 REM quiet output suppressed
 3690 REM quiet output suppressed
 3700 PROCsection("NUMERIC EDGE CASES")
 3710 PROCL2_test_num2
 3720 PROCsection("STRING EDGE CASES")
 3730 PROCL2_test_str2
 3740 PROCsection("FLOW / TOKENISER EDGE CASES")
 3750 PROCL2_test_flow2
 3760 PROCsection("CASE / OF / WHEN / OTHERWISE")
 3770 PROCL2_test_case
 3780 PROCsection("ARRAY EDGE CASES")
 3790 PROCL2_test_arr2
 3800 PROCsection("ERROR REPORTING EDGE CASES")
 3810 PROCL2_test_err2
 3820 REM quiet output suppressed
 3830 REM quiet output suppressed
 3840 REM quiet output suppressed
 3850 REM quiet output suppressed
 3860 REM quiet output suppressed
 3870 REM quiet output suppressed
 3880 ENDPROC
 3890 DEF PROCL2_test_num2
 3900 LOCAL vA,vB,vI%,vJ%,vK%
 3910 PROCcheck_r("0.1+0.2 approx",0.1+0.2,0.3,1E-6)
 3920 PROCcheck_r("1E-30 * 1E30",1E-30*1E30,1,1E-6)
 3930 PROCcheck_r("1E20 / 1E10",1E20/1E10,1E10,1E4)
 3940 PROCcheck_i("INT near integer low",INT(1.9999999),1)
 3950 PROCcheck_i("INT near integer neg",INT(-1.0000001),-2)
 3960 PROCcheck_i("round trip integer",VAL(STR$(12345)),12345)
 3970 vI%=5
 3980 vI%+=3
 3990 PROCcheck_i("compound += integer",vI%,8)
 4000 vI%*=2
 4010 PROCcheck_i("compound *= integer",vI%,16)
 4020 vI% DIV= 3
 4030 PROCcheck_i("compound DIV=",vI%,5)
 4040 vI% MOD= 3
 4050 PROCcheck_i("compound MOD=",vI%,2)
 4060 vI%=6
 4070 vI% AND= 3
 4080 PROCcheck_i("compound AND=",vI%,2)
 4090 vI%=6
 4100 vI% OR= 1
 4110 PROCcheck_i("compound OR=",vI%,7)
 4120 vI%=6
 4130 vI% EOR= 3
 4140 PROCcheck_i("compound EOR=",vI%,5)
 4150 PROCcheck_i("shift right positive",8>>1,4)
 4160 PROCcheck_t("comparison chaining",(3<4) AND (4<5))
 4170 ENDPROC
 4180 DEF PROCL2_test_str2
 4190 LOCAL sA$,sB$,sC$
 4200 sA$=""
 4210 PROCcheck_i("LEN empty",LEN(sA$),0)
 4220 PROCcheck_s("concat empty left",sA$+"ABC","ABC")
 4230 PROCcheck_s("concat empty right","ABC"+sA$,"ABC")
 4240 PROCcheck_i("INSTR empty needle",INSTR("ABC",""),0):REM Russell variant
 4250 PROCcheck_i("INSTR empty haystack",INSTR("","A"),0)
 4260 sA$="ABCDE"
 4270 MID$(sA$,2,2)="XY"
 4280 PROCcheck_s("MID$ replace middle",sA$,"AXYDE")
 4290 sA$="ABCDE"
 4300 LEFT$(sA$,5)="XYZ"
 4310 PROCcheck_s("LEFT$ short assign",sA$,"XYZDE")
 4320 sA$="ABCDE"
 4330 MID$(sA$,3)="Z"
 4340 PROCcheck_s("MID$ tail assign",sA$,"ABZDE")
 4350 sB$=STRING$(20,"Q")
 4360 PROCcheck_i("STRING$ length",LEN(sB$),20)
 4370 PROCcheck_s("STRING$ content",LEFT$(sB$,4),"QQQQ")
 4380 sC$="A"+CHR$(0)+"B"
 4390 PROCcheck_i("ASC first byte",ASC(sC$),65)
 4400 ENDPROC
 4410 DEF PROCL2_test_flow2
 4420 LOCAL vI%,vJ%,vSum%,vCnt%,vX%,vY%,vNox%,vIf1%
 4430 REM keyword adjacency tests
 4440 vNox%=123
 4450 PROCcheck_i("variable near keyword ON",vNox%,123)
 4460 vIf1%=77
 4470 PROCcheck_i("variable near keyword IF",vIf1%,77)
 4480 REM compact-spacing tests
 4490 vX%=0
 4500 IF 1=1 THENvX%=5
 4510 PROCcheck_i("IF THEN minimal spaces",vX%,5)
 4520 vSum%=0
 4530 FOR vI%=1TO5
 4540 vSum%=vSum%+vI%
 4550 NEXT
 4560 PROCcheck_i("FOR compact spacing",vSum%,15)
 4570 vCnt%=0
 4580 REPEAT
 4590 vCnt%=vCnt%+1
 4600 UNTIL vCnt%=3
 4610 PROCcheck_i("UNTIL compact spacing",vCnt%,3)
 4620 vY%=0
 4630 vMark%=0
 4640 ON 9 GOSUB 5070,5080 ELSE vMark%=44
 4650 PROCcheck_i("ON...ELSE out of range",vMark%,44)
 4660 vSum%=0
 4670 FOR vI%=1 TO 3
 4680   FOR vJ%=1 TO 3
 4690     IF vJ%=2 THEN EXIT FOR
 4700     vSum%=vSum%+10*vI%+vJ%
 4710   NEXT
 4720 NEXT
 4730 PROCcheck_i("nested EXIT FOR inner only",vSum%,63)
 4740 ENDPROC
 4750 DEF PROCL2_test_arr2
 4760 DIM aI%(4)
 4770 DIM bI%(4)
 4780 DIM aR(2)
 4790 DIM aS$(3)
 4800 aI%()=1,2,3
 4810 PROCcheck_i("partial init keep old last",aI%(3),0)
 4820 PROCcheck_i("partial init keep old last2",aI%(4),0)
 4830 bI%()=9
 4840 PROCcheck_i("single init all 0",bI%(0),9)
 4850 PROCcheck_i("single init all 4",bI%(4),9)
 4860 bI%()+=1
 4870 PROCcheck_i("array += elem0",bI%(0),10)
 4880 PROCcheck_i("array += elem4",bI%(4),10)
 4890 aI%()=1,2,3,4,5
 4900 bI%()=5,4,3,2,1
 4910 aI%()=aI%()+bI%()
 4920 PROCcheck_i("array+array elem0",aI%(0),6)
 4930 PROCcheck_i("array+array elem4",aI%(4),6)
 4940 aR()=3,4,12
 4950 PROCcheck_r("MOD array rms vector",MOD(aR()),13,1E-6)
 4960 aS$()="A","BB","CCC","DDDD"
 4970 PROCcheck_s("SUM string array",SUM(aS$()),"ABBCCCDDDD")
 4980 PROCcheck_i("SUMLEN string array",SUMLEN(aS$()),10)
 4990 ENDPROC
 5000 DEF PROCL2_test_err2
 5010 LOCAL vErr%,vErl%,sRep$
 5020 PROCL2_err_div(vErr%,vErl%,sRep$)
 5030 PROCcheck_i("ERR div zero",vErr%,18)
 5040 PROCcheck_i("ERL div zero",vErl%,7030)
 5050 PROCcheck_t("REPORT$ non-empty",LEN(sRep$)<>0)
 5060 ENDPROC
 5070 vMark%=11 : RETURN
 5080 vMark%=22 : RETURN
 5090 vMark%=44 : RETURN
 5100 DEF PROCL2_test_case
 5110 LOCAL vA%,vB%,vC%,sA$,sB$
 5120 vA%=2
 5130 vB%=0
 5140 CASE vA% OF
 5150 WHEN 1
 5160   vB%=10
 5170 WHEN 2
 5180   vB%=20
 5190 WHEN 3
 5200   vB%=30
 5210 OTHERWISE
 5220   vB%=99
 5230 ENDCASE
 5240 PROCcheck_i("CASE numeric match",vB%,20)
 5250 vA%=5
 5260 vB%=0
 5270 CASE vA% OF
 5280 WHEN 1,3,5
 5290   vB%=135
 5300 WHEN 2,4,6
 5310   vB%=246
 5320 OTHERWISE
 5330   vB%=999
 5340 ENDCASE
 5350 PROCcheck_i("CASE multiple WHEN values",vB%,135)
 5360 vA%=8
 5370 vB%=0
 5380 CASE vA% OF
 5390 WHEN 1
 5400   vB%=1
 5410 WHEN 2
 5420   vB%=2
 5430 OTHERWISE
 5440   vB%=88
 5450 ENDCASE
 5460 PROCcheck_i("CASE OTHERWISE",vB%,88)
 5470 sA$="B"
 5480 sB$=""
 5490 CASE sA$ OF
 5500 WHEN "A"
 5510   sB$="ALPHA"
 5520 WHEN "B","b"
 5530   sB$="BRAVO"
 5540 WHEN "C"
 5550   sB$="CHARLIE"
 5560 OTHERWISE
 5570   sB$="OTHER"
 5580 ENDCASE
 5590 PROCcheck_s("CASE string match",sB$,"BRAVO")
 5600 vA%=10
 5610 vB%=0
 5620 CASE TRUE OF
 5630 WHEN vA%<5
 5640   vB%=1
 5650 WHEN vA%=10
 5660   vB%=2
 5670 WHEN vA%>0
 5680   vB%=3
 5690 OTHERWISE
 5700   vB%=4
 5710 ENDCASE
 5720 PROCcheck_i("CASE TRUE conditional match",vB%,2)
 5730 vA%=7
 5740 vB%=0
 5750 CASE vA% OF
 5760 WHEN 7
 5770   vB%=vB%+1
 5780   vB%=vB%+2
 5790 WHEN 8
 5800   vB%=99
 5810 OTHERWISE
 5820   vB%=-1
 5830 ENDCASE
 5840 PROCcheck_i("CASE multi-line WHEN block",vB%,3)
 5850 vA%=1
 5860 vB%=0
 5870 CASE vA% OF
 5880 WHEN 1
 5890   vB%=11
 5900 WHEN 1
 5910   vB%=22
 5920 OTHERWISE
 5930   vB%=33
 5940 ENDCASE
 5950 PROCcheck_i("CASE first match wins",vB%,11)
 5960 vA%=2
 5970 vB%=0
 5980 vC%=0
 5990 CASE vA% OF
 6000 WHEN 1
 6010   vB%=1
 6020 WHEN 2
 6030   vB%=2
 6040   CASE vB% OF
 6050   WHEN 2
 6060     vC%=20
 6070   OTHERWISE
 6080     vC%=99
 6090   ENDCASE
 6100 OTHERWISE
 6110   vB%=9
 6120 ENDCASE
 6130 PROCcheck_i("nested CASE outer",vB%,2)
 6140 PROCcheck_i("nested CASE inner",vC%,20)
 6150 vA%=3
 6160 vB%=0
 6170 CASE vA%+2 OF
 6180 WHEN 4
 6190   vB%=40
 6200 WHEN 5
 6210   vB%=50
 6220 OTHERWISE
 6230   vB%=99
 6240 ENDCASE
 6250 PROCcheck_i("CASE OF expression",vB%,50)
 6260 vA%=2
 6270 vB%=0
 6280 CASE FNL2_dbl(vA%) OF
 6290 WHEN 2
 6300   vB%=20
 6310 WHEN 4
 6320   vB%=40
 6330 OTHERWISE
 6340   vB%=99
 6350 ENDCASE
 6360 PROCcheck_i("CASE OF FN expression",vB%,40)
 6370 sA$="B"
 6380 sB$=""
 6390 CASE FNL2_case_string$(sA$) OF
 6400 WHEN "A"
 6410   sB$="ALPHA"
 6420 WHEN "B"
 6430   sB$="BRAVO"
 6440 OTHERWISE
 6450   sB$="OTHER"
 6460 ENDCASE
 6470 PROCcheck_s("CASE OF string FN expression",sB$,"BRAVO")
 6480 vA%=1
 6490 vB%=0
 6500 CASE vA%=1 OF
 6510 WHEN TRUE
 6520   vB%=123
 6530 WHEN FALSE
 6540   vB%=456
 6550 ENDCASE
 6560 PROCcheck_i("CASE OF boolean expression",vB%,123)
 6570 vA%=0
 6580 GOTO 6610
 6590 vA%=99
 6600 GOTO 6620
 6610 vA%=11
 6620 PROCcheck_i("GOTO forward",vA%,11)
 6630 vA%=0
 6640 vB%=0
 6650 vA%=vA%+1
 6660 IF vA%<5 THEN GOTO 6650
 6670 PROCcheck_i("GOTO backward loop",vA%,5)
 6680 vA%=0
 6690 IF TRUE THEN GOTO 6720
 6700 vA%=99
 6710 GOTO 6730
 6720 vA%=22
 6730 PROCcheck_i("IF THEN GOTO",vA%,22)
 6740 vA%=0
 6750 vB%=2
 6760 ON vB% GOTO 6780,6800,6820
 6770 vA%=99 : GOTO 6830
 6780 vA%=1 : GOTO 6830
 6790 REM unused
 6800 vA%=2 : GOTO 6830
 6810 REM unused
 6820 vA%=3
 6830 PROCcheck_i("ON GOTO",vA%,2)
 6840 vA%=0
 6850 vB%=9
 6860 ON vB% GOTO 6880,6900 ELSE vA%=44
 6870 GOTO 6910
 6880 vA%=1 : GOTO 6910
 6890 REM unused
 6900 vA%=2
 6910 PROCcheck_i("ON GOTO ELSE",vA%,44)
 6920 vA%=0
 6930 vI%=1
 6940 IF vI%=3 THEN GOTO 6980
 6950 vA%=vA%+vI%
 6960 vI%=vI%+1
 6970 GOTO 6940
 6980 PROCcheck_i("manual GOTO loop exit",vA%,3)
 6990 ENDPROC
 7000 DEF PROCL2_err_div(RETURN vErr%,RETURN vErl%,RETURN sRep$)
 7010 LOCAL vA%
 7020 ON ERROR LOCAL vErr%=ERR : vErl%=ERL : sRep$=REPORT$ : ENDPROC
 7030 vA%=1/0
 7040 vErr%=0 : vErl%=0 : sRep$=""
 7050 ENDPROC
 7060 DEF FNL2_dbl(vN%)
 7070 =vN%*2
 7080 DEF FNL2_case_string$(sX$)
 7090 =sX$
 7100 DEF PROCrun_L3A
 7110 vPass%=0 : vFail%=0 : vTest%=0
 7120 DIM vFailName$(100) : vFailIdx%=0
 7130 REM ==============================================================
 7140 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 3A
 7150 REM RUNTIME STRESS / STABILITY TESTS
 7160 REM ==============================================================
 7170 DIM aI%(49),aT%(15)
 7180 vGosub%=0
 7190 REM quiet output suppressed
 7200 REM quiet output suppressed
 7210 PROCsection("LOOP STRESS")
 7220 PROCL3A_test_loops
 7230 PROCsection("PROC / FN / STACK STRESS")
 7240 PROCL3A_test_stack
 7250 PROCsection("STRING STRESS")
 7260 PROCL3A_test_strings
 7270 PROCsection("ARRAY STRESS")
 7280 PROCL3A_test_arrays
 7290 PROCsection("MEMORY INDIRECTION STRESS")
 7300 PROCL3A_test_memory
 7310 PROCsection("ERROR RECOVERY STRESS")
 7320 PROCL3A_test_errors
 7330 REM quiet output suppressed
 7340 REM quiet output suppressed
 7350 REM quiet output suppressed
 7360 REM quiet output suppressed
 7370 REM quiet output suppressed
 7380 REM quiet output suppressed
 7390 ENDPROC
 7400 DEF PROCL3A_test_loops
 7410 LOCAL vI%,vJ%,vK%,vSum%,vCnt%
 7420 vSum%=0
 7430 FOR vI%=1 TO 200
 7440   vSum%=vSum%+vI%
 7450 NEXT
 7460 PROCcheck_i("FOR sum 1..200",vSum%,20100)
 7470 vSum%=0
 7480 FOR vI%=1 TO 20
 7490   FOR vJ%=1 TO 10
 7500     vSum%=vSum%+vI%+vJ%
 7510   NEXT
 7520 NEXT
 7530 PROCcheck_i("nested FOR sum",vSum%,3200)
 7540 vCnt%=0
 7550 REPEAT
 7560   vCnt%=vCnt%+1
 7570 UNTIL vCnt%=250
 7580 PROCcheck_i("REPEAT 250 iterations",vCnt%,250)
 7590 vCnt%=0
 7600 WHILE vCnt%<300
 7610   vCnt%=vCnt%+1
 7620 ENDWHILE
 7630 PROCcheck_i("WHILE 300 iterations",vCnt%,300)
 7640 vGosub%=0
 7650 FOR vI%=1 TO 100
 7660   GOSUB 9060
 7670 NEXT
 7680 PROCcheck_i("100 GOSUB/RETURN cycles",vGosub%,100)
 7690 ENDPROC
 7700 DEF PROCL3A_test_stack
 7710 LOCAL vI%,vOut%,vSum%
 7720 PROCcheck_i("recursive factorial 10",FNL3A_fact(10),3628800)
 7730 PROCcheck_i("recursive fibonacci 12",FNL3A_fib(12),144)
 7740 vSum%=0
 7750 FOR vI%=1 TO 100
 7760   PROCL3A_small(vI%,vOut%)
 7770   vSum%=vSum%+vOut%
 7780 NEXT
 7790 PROCcheck_i("100 PROC calls with return",vSum%,10100)
 7800 PROCL3A_nested_a(5,vOut%)
 7810 PROCcheck_i("nested PROC chain",vOut%,15)
 7820 ENDPROC
 7830 DEF PROCL3A_test_strings
 7840 LOCAL sA$,sB$,vI%,vLen%
 7850 sA$=""
 7860 FOR vI%=1 TO 200
 7870   sA$=sA$+"A"
 7880 NEXT
 7890 PROCcheck_i("string build length 200",LEN(sA$),200)
 7900 PROCcheck_s("string build left",LEFT$(sA$,5),"AAAAA")
 7910 PROCcheck_s("string build right",RIGHT$(sA$,5),"AAAAA")
 7920 sB$=""
 7930 FOR vI%=1 TO 50
 7940   sB$=sB$+CHR$(64+(vI% MOD 26)+1)
 7950 NEXT
 7960 PROCcheck_i("mixed string length 50",LEN(sB$),50)
 7970 PROCcheck_s("mixed string prefix",LEFT$(sB$,6),"BCDEFG")
 7980 PROCcheck_s("mixed string middle",MID$(sB$,25,4),"ZABC")
 7990 FOR vI%=1 TO 20
 8000   MID$(sB$,vI%,1)="Z"
 8010 NEXT
 8020 PROCcheck_s("repeated MID$ assignment",LEFT$(sB$,20),STRING$(20,"Z"))
 8030 ENDPROC
 8040 DEF PROCL3A_test_arrays
 8050 LOCAL vI%,vSum%,vOut%
 8060 FOR vI%=0 TO 49
 8070   aI%(vI%)=vI%
 8080 NEXT
 8090 vSum%=0
 8100 FOR vI%=0 TO 49
 8110   vSum%=vSum%+aI%(vI%)
 8120 NEXT
 8130 PROCcheck_i("array sum 0..49",vSum%,1225)
 8140 FOR vI%=0 TO 49
 8150   aI%(vI%)=aI%(vI%)*2
 8160 NEXT
 8170 PROCcheck_i("array doubled first",aI%(0),0)
 8180 PROCcheck_i("array doubled middle",aI%(25),50)
 8190 PROCcheck_i("array doubled last",aI%(49),98)
 8200 vSum%=0
 8210 FOR vI%=1 TO 20
 8220   PROCL3A_reuse_array(vI%,vOut%)
 8230   vSum%=vSum%+vOut%
 8240 NEXT
 8250 PROCcheck_i("20 reused array fills",vSum%,5760)
 8260 ENDPROC
 8270 DEF PROCL3A_test_memory
 8280 LOCAL mBlk%,vBase%,vI%,vSum%,vP%
 8290 DIM mBlk% 255
 8300 vBase%=mBlk%
 8310 FOR vI%=0 TO 127
 8320   vBase%?vI%=vI%
 8330 NEXT
 8340 vSum%=0
 8350 FOR vI%=0 TO 127
 8360   vSum%=vSum%+(vBase%?vI%)
 8370 NEXT
 8380 PROCcheck_i("128 byte write/read sum",vSum%,8128)
 8390 vP%=vBase%+128
 8400 FOR vI%=0 TO 7
 8410   !(vP%+vI%*4)=&01020304+vI%
 8420 NEXT
 8430 PROCcheck_i("word stress first",!vP%,&01020304)
 8440 PROCcheck_i("word stress last",!(vP%+28),&0102030B)
 8450 ENDPROC
 8460 DEF PROCL3A_test_errors
 8470 LOCAL vI%,vErr%,vGood%
 8480 vGood%=0
 8490 FOR vI%=1 TO 25
 8500   PROCL3A_catch_div(vErr%)
 8510   IF vErr%=18 THEN vGood%=vGood%+1
 8520 NEXT
 8530 PROCcheck_i("25 trapped div zero errors",vGood%,25)
 8540 vGood%=0
 8550 FOR vI%=1 TO 25
 8560   PROCL3A_normal_after_error(vErr%)
 8570   IF vErr%=0 THEN vGood%=vGood%+1
 8580 NEXT
 8590 PROCcheck_i("normal execution after errors",vGood%,25)
 8600 ENDPROC
 8610 DEF FNL3A_fact(vN%)
 8620 IF vN%<2 THEN =1
 8630 =vN%*FNL3A_fact(vN%-1)
 8640 DEF FNL3A_fib(vN%)
 8650 IF vN%<2 THEN =vN%
 8660 =FNL3A_fib(vN%-1)+FNL3A_fib(vN%-2)
 8670 DEF PROCL3A_small(vIn%,RETURN vOut%)
 8680 LOCAL vTmp%
 8690 vTmp%=vIn%*2
 8700 vOut%=vTmp%
 8710 ENDPROC
 8720 DEF PROCL3A_nested_a(vN%,RETURN vOut%)
 8730 LOCAL vTmp%
 8740 PROCL3A_nested_b(vN%,vTmp%)
 8750 vOut%=vTmp%+1
 8760 ENDPROC
 8770 DEF PROCL3A_nested_b(vN%,RETURN vOut%)
 8780 LOCAL vTmp%
 8790 PROCL3A_nested_c(vN%,vTmp%)
 8800 vOut%=vTmp%+2
 8810 ENDPROC
 8820 DEF PROCL3A_nested_c(vN%,RETURN vOut%)
 8830 vOut%=vN%+7
 8840 ENDPROC
 8850 DEF PROCL3A_reuse_array(vSeed%,RETURN vOut%)
 8860 LOCAL vI%,vSum%
 8870 vSum%=0
 8880 FOR vI%=0 TO 15
 8890   aT%(vI%)=vSeed%+vI%
 8900   vSum%=vSum%+aT%(vI%)
 8910 NEXT
 8920 vOut%=vSum%
 8930 ENDPROC
 8940 DEF PROCL3A_catch_div(RETURN vErr%)
 8950 LOCAL vX%
 8960 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8970 vX%=1/0
 8980 vErr%=0
 8990 ENDPROC
 9000 DEF PROCL3A_normal_after_error(RETURN vErr%)
 9010 LOCAL vX%
 9020 vX%=10
 9030 vX%=vX%+5
 9040 IF vX%=15 THEN vErr%=0 ELSE vErr%=-1
 9050 ENDPROC
 9060 vGosub%=vGosub%+1 : RETURN
 9100 DEF PROCrun_L3B
 9110 vPass%=0 : vFail%=0 : vTest%=0
 9120 DIM vFailName$(100) : vFailIdx%=0
 9130 REM ==============================================================
 9140 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 3B
 9150 REM FILE I/O TESTS
 9160 REM ==============================================================
 9170 REM quiet output suppressed
 9180 REM quiet output suppressed
 9190 PROCsection("BYTE FILE I/O")
 9200 PROCL3B_test_bytefile
 9210 PROCsection("PRINT# / INPUT# SEQUENTIAL I/O")
 9220 PROCL3B_test_seqfile
 9230 PROCsection("EOF# / EXT# / PTR#")
 9240 PROCL3B_test_filepos
 9250 PROCsection("OPENUP")
 9260 PROCL3B_test_openup
 9270 REM quiet output suppressed
 9280 REM quiet output suppressed
 9290 REM quiet output suppressed
 9300 REM quiet output suppressed
 9310 REM quiet output suppressed
 9320 REM quiet output suppressed
 9330 ENDPROC
 9340 DEF PROCL3B_test_bytefile
 9350 LOCAL vCh%,vI%,vB%,vSum%
 9360 vCh%=OPENOUT("B3BBIN.DAT")
 9370 PROCcheck_t("OPENOUT byte file",vCh%<>0)
 9380 FOR vI%=0 TO 15
 9390   BPUT#vCh%,vI%*3
 9400 NEXT
 9410 CLOSE#vCh%
 9420 vCh%=OPENIN("B3BBIN.DAT")
 9430 PROCcheck_i("EXT# after 16 BPUT",EXT#vCh%,16)
 9440 CLOSE#vCh%
 9450 vCh%=OPENIN("B3BBIN.DAT")
 9460 PROCcheck_t("OPENIN byte file",vCh%<>0)
 9470 vSum%=0
 9480 FOR vI%=0 TO 15
 9490   vB%=BGET#vCh%
 9500   vSum%=vSum%+vB%
 9510 NEXT
 9520 PROCcheck_i("byte file sum",vSum%,360)
 9530 PROCcheck_t("EOF# after byte reads",EOF#vCh%)
 9540 CLOSE#vCh%
 9550 ENDPROC
 9560 DEF PROCL3B_test_seqfile
 9570 LOCAL vCh%,vA%,vB%,vC%,sA$,sB$
 9580 vCh%=OPENOUT("B3BSEQ.DAT")
 9590 PROCcheck_t("OPENOUT seq file",vCh%<>0)
 9600 PRINT#vCh%,12345
 9610 PRINT#vCh%,-6789
 9620 PRINT#vCh%,"HELLO"
 9630 PRINT#vCh%,"BBC BASIC"
 9640 CLOSE#vCh%
 9650 vCh%=OPENIN("B3BSEQ.DAT")
 9660 PROCcheck_t("OPENIN seq file",vCh%<>0)
 9670 INPUT#vCh%,vA%
 9680 INPUT#vCh%,vB%
 9690 INPUT#vCh%,sA$
 9700 INPUT#vCh%,sB$
 9710 PROCcheck_i("INPUT# integer positive",vA%,12345)
 9720 PROCcheck_i("INPUT# integer negative",vB%,-6789)
 9730 PROCcheck_s("INPUT# string one",sA$,"HELLO")
 9740 PROCcheck_s("INPUT# string two",sB$,"BBC BASIC")
 9750 PROCcheck_t("EOF# after seq reads",EOF#vCh%)
 9760 CLOSE#vCh%
 9770 ENDPROC
 9780 DEF PROCL3B_test_filepos
 9790 LOCAL vCh%,vI%,vB%
 9800 vCh%=OPENOUT("B3BPOS.DAT")
 9810 PROCcheck_t("OPENOUT pos file",vCh%<>0)
 9820 FOR vI%=1 TO 10
 9830   BPUT#vCh%,vI%
 9840 NEXT
 9850 CLOSE#vCh%
 9860 vCh%=OPENIN("B3BPOS.DAT")
 9870 PROCcheck_i("EXT# pos file",EXT#vCh%,10)
 9880 CLOSE#vCh%
 9890 vCh%=OPENIN("B3BPOS.DAT")
 9900 PROCcheck_t("OPENIN pos file",vCh%<>0)
 9910 PROCcheck_i("PTR# initial",PTR#vCh%,0)
 9920 vB%=BGET#vCh%
 9930 PROCcheck_i("first BGET#",vB%,1)
 9940 PROCcheck_i("PTR# after one byte",PTR#vCh%,1)
 9950 PTR#vCh%=5
 9960 PROCcheck_i("PTR# seek to 5",PTR#vCh%,5)
 9970 vB%=BGET#vCh%
 9980 PROCcheck_i("BGET# after seek",vB%,6)
 9990 PTR#vCh%=9
10000 vB%=BGET#vCh%
10010 PROCcheck_i("BGET# final byte",vB%,10)
10020 PROCcheck_t("EOF# final byte",EOF#vCh%)
10030 CLOSE#vCh%
10040 ENDPROC
10050 DEF PROCL3B_test_openup
10060 LOCAL vCh%,vA%,vB%,vC%
10070 vCh%=OPENOUT("L3BUP.DAT")
10080 BPUT#vCh%,10
10090 BPUT#vCh%,20
10100 BPUT#vCh%,30
10110 CLOSE#vCh%
10120 vCh%=OPENUP("L3BUP.DAT")
10130 PROCcheck_t("OPENUP returns valid handle",vCh%<>0)
10140 PROCcheck_i("OPENUP initial PTR#",PTR#vCh%,0)
10150 PROCcheck_i("OPENUP initial EXT#",EXT#vCh%,3)
10160 PTR#vCh%=1
10170 BPUT#vCh%,99
10180 CLOSE#vCh%
10190 vCh%=OPENIN("L3BUP.DAT")
10200 vA%=BGET#vCh%
10210 vB%=BGET#vCh%
10220 vC%=BGET#vCh%
10230 CLOSE#vCh%
10240 PROCcheck_i("OPENUP byte 1 unchanged",vA%,10)
10250 PROCcheck_i("OPENUP byte overwritten",vB%,99)
10260 PROCcheck_i("OPENUP byte 3 unchanged",vC%,30)
10270 vCh%=OPENUP("L3BUP.DAT")
10280 PTR#vCh%=EXT#vCh%
10290 BPUT#vCh%,55
10300 CLOSE#vCh%
10310 vCh%=OPENIN("L3BUP.DAT")
10320 PROCcheck_i("OPENUP extend EXT#",EXT#vCh%,4)
10330 PTR#vCh%=3
10340 vA%=BGET#vCh%
10350 CLOSE#vCh%
10360 PROCcheck_i("OPENUP appended byte",vA%,55)
10370 ENDPROC
10400 DEF PROCrun_L4A
10410 vPass%=0 : vFail%=0 : vTest%=0
10420 DIM vFailName$(100) : vFailIdx%=0
10430 REM ==============================================================
10440 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 4A
10450 REM PARSER / EVAL / EXPRESSION STRESS TESTS
10460 REM ==============================================================
10470 REM quiet output suppressed
10480 REM quiet output suppressed
10490 PROCsection("OPERATOR PRECEDENCE")
10500 PROCL4A_test_prec
10510 PROCsection("EVAL NUMERIC")
10520 PROCL4A_test_eval_num
10530 PROCsection("EVAL STRINGS")
10540 PROCL4A_test_eval_str
10550 PROCsection("GENERATED EXPRESSIONS")
10560 PROCL4A_test_genexpr
10570 PROCsection("NESTED FUNCTIONS")
10580 PROCL4A_test_nestedfn
10590 REM quiet output suppressed
10600 REM quiet output suppressed
10610 REM quiet output suppressed
10620 REM quiet output suppressed
10630 REM quiet output suppressed
10640 REM quiet output suppressed
10650 ENDPROC
10660 DEF PROCL4A_test_prec
10670 PROCcheck_i("mul before add",2+3*4,14)
10680 PROCcheck_i("brackets override",(2+3)*4,20)
10690 PROCcheck_i("unary minus precedence",-2*3,-6)
10700 PROCcheck_i("nested brackets",((2+3)*(4+5)),45)
10710 PROCcheck_i("DIV before add",2+17 DIV 5,5)
10720 PROCcheck_i("MOD before add",2+17 MOD 5,4)
10730 PROCcheck_i("shift after add",(1+3)<<2,16)
10740 PROCcheck_i("AND precedence",(7 AND 3)+10,13)
10750 PROCcheck_i("OR precedence",8 OR 2+1,11)
10760 PROCcheck_i("EOR precedence",15 EOR 5,10)
10770 PROCcheck_i("relational TRUE",3*4=12,TRUE)
10780 PROCcheck_i("relational FALSE",3*4=13,FALSE)
10790 PROCcheck_i("boolean expression",(3<4) AND (5>2),TRUE)
10800 PROCcheck_i("boolean expression false",(3<4) AND (5<2),FALSE)
10810 ENDPROC
10820 DEF PROCL4A_test_eval_num
10830 LOCAL vA%,vB%,vC%,vR
10840 vA%=10 : vB%=5 : vC%=3
10850 PROCcheck_i("EVAL simple",EVAL("2+3*4"),14)
10860 PROCcheck_i("EVAL brackets",EVAL("(2+3)*4"),20)
10870 PROCcheck_i("EVAL variables",EVAL("vA%+vB%*vC%"),25)
10880 PROCcheck_i("EVAL DIV MOD",EVAL("17 DIV 5 + 17 MOD 5"),5)
10890 PROCcheck_i("EVAL hex",EVAL("&10+&20"),48)
10900 PROCcheck_i("EVAL binary",EVAL("%1010+%0101"),15)
10910 PROCcheck_r("EVAL real",EVAL("SQR(81)+SIN(PI/2)"),10,1E-6)
10920 vR=EVAL("EXP(LN(7))")
10930 PROCcheck_r("EVAL EXP/LN",vR,7,1E-6)
10940 PROCcheck_i("EVAL comparison true",EVAL("3<4"),TRUE)
10950 PROCcheck_i("EVAL comparison false",EVAL("3>4"),FALSE)
10960 ENDPROC
10970 DEF PROCL4A_test_eval_str
10980 LOCAL sA$,sB$,sC$
10990 sA$="HELLO"
11000 sB$="WORLD"
11010 PROCcheck_s("EVAL string literal",EVAL("""ABC"""),"ABC")
11020 PROCcheck_s("EVAL string concat",EVAL("""AB""+""CD"""),"ABCD")
11030 PROCcheck_s("EVAL string variables",EVAL("sA$+"" ""+sB$"),"HELLO WORLD")
11040 PROCcheck_s("EVAL LEFT$",EVAL("LEFT$(sA$,2)"),"HE")
11050 PROCcheck_s("EVAL MID$",EVAL("MID$(sB$,2,3)"),"ORL")
11060 PROCcheck_i("EVAL LEN string",EVAL("LEN(sA$+sB$)"),10)
11070 sC$="CHR$(65)+CHR$(66)+CHR$(67)"
11080 PROCcheck_s("EVAL generated string expr",EVAL(sC$),"ABC")
11090 ENDPROC
11100 DEF PROCL4A_test_genexpr
11110 LOCAL sE$,vI%,vGot%,vExp%
11120 sE$=""
11130 FOR vI%=1 TO 10
11140   IF vI%=1 THEN sE$=STR$(vI%) ELSE sE$=sE$+"+"+STR$(vI%)
11150 NEXT
11160 vGot%=EVAL(sE$)
11170 PROCcheck_i("generated sum 1..10",vGot%,55)
11180 sE$="1"
11190 FOR vI%=1 TO 8
11200   sE$="("+sE$+"*2)"
11210 NEXT
11220 PROCcheck_i("generated nested multiply",EVAL(sE$),256)
11230 sE$="0"
11240 FOR vI%=1 TO 16
11250   sE$=sE$+"+1"
11260 NEXT
11270 PROCcheck_i("generated long flat expr",EVAL(sE$),16)
11280 sE$="(3+4)*(5+6)-7"
11290 PROCcheck_i("generated fixed complex",EVAL(sE$),70)
11300 ENDPROC
11310 DEF PROCL4A_test_nestedfn
11320 LOCAL vA%,vB%,vC%
11330 PROCcheck_i("nested FN direct",FNL4A_twice(FNL4A_add3(4)),14)
11340 PROCcheck_i("FN inside expression",FNL4A_add3(4)*FNL4A_twice(5),70)
11350 vA%=3 : vB%=4
11360 PROCcheck_i("EVAL FN call",EVAL("FNL4A_add3(vA%)+FNL4A_twice(vB%)"),14)
11370 PROCcheck_i("recursive expression FN",FNL4A_exprsum(10),55)
11380 PROCcheck_i("nested recursive FN",FNL4A_twice(FNL4A_exprsum(5)),30)
11390 ENDPROC
11400 DEF FNL4A_add3(vN%)
11410 =vN%+3
11420 DEF FNL4A_twice(vN%)
11430 =vN%*2
11440 DEF FNL4A_exprsum(vN%)
11450 IF vN%<1 THEN =0
11460 =vN%+FNL4A_exprsum(vN%-1)
11500 DEF PROCrun_L4B
11510 vPass%=0 : vFail%=0 : vTest%=0
11520 DIM vFailName$(100) : vFailIdx%=0
11530 REM ==============================================================
11540 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 4B
11550 REM FLOATING POINT / NUMERIC STABILITY TESTS
11560 REM ==============================================================
11570 REM quiet output suppressed
11580 REM quiet output suppressed
11590 PROCsection("BASIC REAL ARITHMETIC")
11600 PROCL4B_test_basicreal
11610 PROCsection("TRANSCENDENTAL FUNCTIONS")
11620 PROCL4B_test_trans
11630 PROCsection("INVERSE TRIG / ANGLE CONVERSION")
11640 PROCL4B_test_angles
11650 PROCsection("ROUNDING / INT / SGN")
11660 PROCL4B_test_round
11670 PROCsection("PRECISION BOUNDARIES")
11680 PROCL4B_test_precision
11690 PROCsection("ACCUMULATION")
11700 PROCL4B_test_accum
11710 REM quiet output suppressed
11720 REM quiet output suppressed
11730 REM quiet output suppressed
11740 REM quiet output suppressed
11750 REM quiet output suppressed
11760 REM quiet output suppressed
11770 ENDPROC
11780 DEF PROCL4B_test_basicreal
11790 PROCcheck_r("0.5 + 0.25",0.5+0.25,0.75,1E-9)
11800 PROCcheck_r("0.1 + 0.2 approx",0.1+0.2,0.3,1E-6)
11810 PROCcheck_r("10 / 4",10/4,2.5,1E-9)
11820 PROCcheck_r("1 / 3 * 3",(1/3)*3,1,1E-6)
11830 PROCcheck_r("SQR(2)^2",SQR(2)*SQR(2),2,1E-6)
11840 PROCcheck_r("SQR(3)^2",SQR(3)*SQR(3),3,1E-6)
11850 PROCcheck_r("large multiply/divide",(12345.678*1000)/1000,12345.678,1E-3)
11860 PROCcheck_r("small multiply/divide",(0.000123456*1000000)/1000000,0.000123456,1E-10)
11870 ENDPROC
11880 DEF PROCL4B_test_trans
11890 PROCcheck_r("SIN(0)",SIN(0),0,1E-7)
11900 PROCcheck_r("COS(0)",COS(0),1,1E-7)
11910 PROCcheck_r("SIN(PI/2)",SIN(PI/2),1,1E-6)
11920 PROCcheck_r("COS(PI)",COS(PI),-1,1E-6)
11930 PROCcheck_r("SIN(PI)",SIN(PI),0,1E-5)
11940 PROCcheck_r("TAN(PI/4)",TAN(PI/4),1,1E-5)
11950 PROCcheck_r("ATN(1)",ATN(1),PI/4,1E-6)
11960 PROCcheck_r("EXP(0)",EXP(0),1,1E-9)
11970 PROCcheck_r("LN(EXP(3))",LN(EXP(3)),3,1E-6)
11980 PROCcheck_r("EXP(LN(12.5))",EXP(LN(12.5)),12.5,1E-5)
11990 PROCcheck_r("LOG(100)",LOG(100),2,1E-7)
12000 PROCcheck_r("LOG(10)",LOG(10),1,1E-7)
12010 PROCcheck_r("LOG(1)",LOG(1),0,1E-7)
12020 PROCcheck_r("10^LOG(12.5)",10^LOG(12.5),12.5,1E-5)
12030 ENDPROC
12040 DEF PROCL4B_test_angles
12050 PROCcheck_r("ACS(1)",ACS(1),0,1E-7)
12060 PROCcheck_r("ACS(0)",ACS(0),PI/2,1E-6)
12070 PROCcheck_r("ACS(-1)",ACS(-1),PI,1E-6)
12080 PROCcheck_r("ASN(0)",ASN(0),0,1E-7)
12090 PROCcheck_r("ASN(1)",ASN(1),PI/2,1E-6)
12100 PROCcheck_r("ASN(-1)",ASN(-1),-PI/2,1E-6)
12110 PROCcheck_r("DEG(PI)",DEG(PI),180,1E-5)
12120 PROCcheck_r("DEG(PI/2)",DEG(PI/2),90,1E-5)
12130 PROCcheck_r("RAD(180)",RAD(180),PI,1E-6)
12140 PROCcheck_r("RAD(90)",RAD(90),PI/2,1E-6)
12150 PROCcheck_r("RAD(DEG(1))",RAD(DEG(1)),1,1E-6)
12160 PROCcheck_r("DEG(RAD(45))",DEG(RAD(45)),45,1E-5)
12170 ENDPROC
12180 DEF PROCL4B_test_round
12190 PROCcheck_i("INT 1.999",INT(1.999),1)
12200 PROCcheck_i("INT 2.000",INT(2.000),2)
12210 PROCcheck_i("INT -1.001",INT(-1.001),-2)
12220 PROCcheck_i("INT -1.000",INT(-1.000),-1)
12230 PROCcheck_i("SGN tiny positive",SGN(1E-20),1)
12240 PROCcheck_i("SGN tiny negative",SGN(-1E-20),-1)
12250 PROCcheck_i("SGN zero",SGN(0),0)
12260 PROCcheck_r("ABS tiny",ABS(-1E-20),1E-20,1E-25)
12270 ENDPROC
12280 DEF PROCL4B_test_precision
12290 LOCAL vA,vB,vC
12300 vA=1000000
12310 vB=(vA+1)-vA
12320 PROCcheck_r("(1E6+1)-1E6",vB,1,1E-5)
12330 vA=10000000
12340 vB=(vA+1)-vA
12350 PROCcheck_r("(1E7+1)-1E7",vB,1,1E-4)
12360 vA=1E-20
12370 vB=vA*1E20
12380 PROCcheck_r("1E-20 * 1E20",vB,1,1E-6)
12390 vC=1E20/1E10
12400 PROCcheck_r("1E20 / 1E10",vC,1E10,1E4)
12410 PROCcheck_t("positive tiny nonzero",1E-30>0)
12420 PROCcheck_t("negative tiny below zero",-1E-30<0)
12430 ENDPROC
12440 DEF PROCL4B_test_accum
12450 LOCAL vI%,vS,vT
12460 vS=0
12470 FOR vI%=1 TO 100
12480   vS=vS+0.1
12490 NEXT
12500 PROCcheck_r("sum 0.1 x100",vS,10,1E-4)
12510 vS=1
12520 FOR vI%=1 TO 50
12530   vS=vS*1.01
12540 NEXT
12550 PROCcheck_r("compound growth 1.01^50",vS,1.64463,1E-4)
12560 vT=1
12570 FOR vI%=1 TO 50
12580   vT=vT/1.01
12590 NEXT
12600 PROCcheck_r("growth then shrink",vS*vT,1,1E-4)
12610 vS=0
12620 FOR vI%=1 TO 1000
12630   vS=vS+1
12640 NEXT
12650 PROCcheck_r("sum 1 x1000",vS,1000,1E-6)
12660 ENDPROC
12700 DEF PROCrun_L4C
12710 vPass%=0 : vFail%=0 : vTest%=0
12720 DIM vFailName$(100) : vFailIdx%=0
12730 REM ==============================================================
12740 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 4C
12750 REM LOCAL VARIABLES / LOCAL ARRAYS / DIM REGRESSION TESTS
12760 REM ==============================================================
12770 REM quiet output suppressed
12780 REM quiet output suppressed
12790 PROCsection("BASIC LOCAL ARRAY DIM")
12800 PROCL4C_test_basic_localdim
12810 PROCsection("MULTIPLE LOCAL ARRAYS")
12820 PROCL4C_test_many_localdim
12830 PROCsection("REPEATED LOCAL ARRAY ALLOCATION")
12840 PROCL4C_test_repeat_localdim
12850 PROCsection("NESTED LOCAL ARRAYS")
12860 PROCL4C_test_nested_localdim
12870 PROCsection("LOCAL ARRAYS INSIDE FUNCTIONS")
12880 PROCL4C_test_fn_localdim
12890 PROCsection("GLOBAL DIM AFTER LOCAL ARRAYS")
12900 PROCL4C_test_after_localdim
12910 REM quiet output suppressed
12920 REM quiet output suppressed
12930 REM quiet output suppressed
12940 REM quiet output suppressed
12950 REM quiet output suppressed
12960 REM quiet output suppressed
12970 ENDPROC
12980 DEF PROCL4C_test_basic_localdim
12990 LOCAL aR(),aI%()
13000 DIM aR(9)
13010 DIM aI%(9)
13020 aR(0)=1.25 : aR(9)=9.75
13030 aI%(0)=123 : aI%(9)=456
13040 PROCcheck_r("local real array first",aR(0),1.25,1E-9)
13050 PROCcheck_r("local real array last",aR(9),9.75,1E-9)
13060 PROCcheck_i("local integer array first",aI%(0),123)
13070 PROCcheck_i("local integer array last",aI%(9),456)
13080 ENDPROC
13090 DEF PROCL4C_test_many_localdim
13100 LOCAL aR(),bR(),cI%(),dI%()
13110 DIM aR(3)
13120 DIM bR(4)
13130 DIM cI%(5)
13140 DIM dI%(6)
13150 aR(3)=33.25
13160 bR(4)=44.5
13170 cI%(5)=55
13180 dI%(6)=66
13190 PROCcheck_r("many locals real a",aR(3),33.25,1E-9)
13200 PROCcheck_r("many locals real b",bR(4),44.5,1E-9)
13210 PROCcheck_i("many locals integer c",cI%(5),55)
13220 PROCcheck_i("many locals integer d",dI%(6),66)
13230 ENDPROC
13240 DEF PROCL4C_test_repeat_localdim
13250 LOCAL vI%,vGood%
13260 vGood%=0
13270 FOR vI%=1 TO 200
13280   IF FNL4C_basic_localdim_ok THEN vGood%=vGood%+1
13290 NEXT
13300 PROCcheck_i("200 repeated local DIM calls",vGood%,200)
13310 ENDPROC
13320 DEF PROCL4C_test_nested_localdim
13330 LOCAL vOut%
13340 PROCL4C_nested_outer(20,vOut%)
13350 PROCcheck_i("nested local arrays preserved",vOut%,1)
13360 ENDPROC
13370 DEF PROCL4C_test_fn_localdim
13380 PROCcheck_i("FN local integer array sum",FNL4C_local_int_sum(10),165)
13390 PROCcheck_r("FN local real array value",FNL4C_local_real_value(12),12.5,1E-9)
13400 PROCcheck_s("FN local string array value",FNL4C_local_string_value,"LOCAL-OK")
13410 ENDPROC
13420 DEF PROCL4C_test_after_localdim
13430 DIM gR(20)
13440 DIM gI%(20)
13450 gR(20)=123.5
13460 gI%(20)=321
13470 PROCcheck_r("global real DIM after locals",gR(20),123.5,1E-9)
13480 PROCcheck_i("global integer DIM after locals",gI%(20),321)
13490 ENDPROC
13500 DEF FNL4C_basic_localdim_ok
13510 LOCAL aR(),aI%()
13520 DIM aR(9)
13530 DIM aI%(9)
13540 aR(0)=1.25 : aR(9)=9.75
13550 aI%(0)=123 : aI%(9)=456
13560 IF aR(0)<>1.25 THEN =FALSE
13570 IF aR(9)<>9.75 THEN =FALSE
13580 IF aI%(0)<>123 THEN =FALSE
13590 IF aI%(9)<>456 THEN =FALSE
13600 =TRUE
13610 DEF PROCL4C_nested_outer(vN%,RETURN vOut%)
13620 LOCAL oR(),oI%()
13630 DIM oR(vN%)
13640 DIM oI%(vN%)
13650 oR(vN%)=vN%+0.5
13660 oI%(vN%)=vN%
13670 PROCL4C_nested_inner(vN%)
13680 IF oR(vN%)=vN%+0.5 AND oI%(vN%)=vN% THEN vOut%=1 ELSE vOut%=0
13690 ENDPROC
13700 DEF PROCL4C_nested_inner(vN%)
13710 LOCAL iR(),iI%()
13720 DIM iR(vN%)
13730 DIM iI%(vN%)
13740 iR(vN%)=vN%+1.5
13750 iI%(vN%)=vN%+1
13760 IF iR(vN%)<>vN%+1.5 THEN ERROR 105,"inner real array corrupt"
13770 IF iI%(vN%)<>vN%+1 THEN ERROR 106,"inner integer array corrupt"
13780 ENDPROC
13790 DEF FNL4C_local_int_sum(vN%)
13800 LOCAL aI%(),vI%,vSum%
13810 DIM aI%(vN%)
13820 vSum%=0
13830 FOR vI%=0 TO vN%
13840   aI%(vI%)=vI%*3
13850   vSum%=vSum%+aI%(vI%)
13860 NEXT
13870 =vSum%
13880 DEF FNL4C_local_real_value(vN%)
13890 LOCAL aR()
13900 DIM aR(vN%)
13910 aR(vN%)=vN%+0.5
13920 =aR(vN%)
13930 DEF FNL4C_local_string_value
13940 LOCAL aS$()
13950 DIM aS$(2)
13960 aS$(0)="LOCAL"
13970 aS$(1)="-"
13980 aS$(2)="OK"
13990 =aS$(0)+aS$(1)+aS$(2)
14000 DEF PROCrun_L5A
14010 vPass%=0 : vFail%=0 : vTest%=0
14020 DIM vFailName$(100) : vFailIdx%=0
14030 REM ==============================================================
14040 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5A
14050 REM DOCUMENTED LIMITS / SAFE BOUNDARY TESTS
14060 REM ==============================================================
14070 REM quiet output suppressed
14080 REM quiet output suppressed
14090 PROCsection("STRING LENGTH LIMITS")
14100 PROCL5A_test_string_limits
14110 PROCsection("ARRAY BOUNDARY TESTS")
14120 PROCL5A_test_array_limits
14130 PROCsection("LOCAL ARRAY BOUNDARY TESTS")
14140 PROCL5A_test_local_array_limits
14150 PROCsection("RECURSION DEPTH SANITY")
14160 PROCL5A_test_recursion_sanity
14170 PROCsection("POST-LIMIT RUNTIME SANITY")
14180 PROCL5A_test_post_sanity
14190 REM quiet output suppressed
14200 REM quiet output suppressed
14210 REM quiet output suppressed
14220 REM quiet output suppressed
14230 REM quiet output suppressed
14240 REM quiet output suppressed
14250 ENDPROC
14260 DEF PROCL5A_test_string_limits
14270 LOCAL sA$,sB$,vErr%
14280 sA$=STRING$(254,"A")
14290 PROCcheck_i("string length 254",LEN(sA$),254)
14300 sA$=sA$+"B"
14310 PROCcheck_i("string length 255",LEN(sA$),255)
14320 PROCcheck_s("string length 255 first",LEFT$(sA$,1),"A")
14330 PROCcheck_s("string length 255 last",RIGHT$(sA$,1),"B")
14340 sB$=LEFT$(sA$,128)+RIGHT$(sA$,127)
14350 PROCcheck_i("split/rejoin 255 string",LEN(sB$),255)
14360 PROCL5A_string_256_error(vErr%)
14370 PROCcheck_t("string length 256 trapped",vErr%<>0)
14380 ENDPROC
14390 DEF PROCL5A_string_256_error(RETURN vErr%)
14400 LOCAL sA$
14410 ON ERROR LOCAL vErr%=ERR : ENDPROC
14420 sA$=STRING$(255,"A")+"B"
14430 vErr%=0
14440 ENDPROC
14450 DEF PROCL5A_test_array_limits
14460 LOCAL aI%(),aR(),aS$()
14470 DIM aI%(255)
14480 aI%(0)=11
14490 aI%(255)=22
14500 PROCcheck_i("integer array index 0",aI%(0),11)
14510 PROCcheck_i("integer array index 255",aI%(255),22)
14520 DIM aR(127)
14530 aR(0)=1.25
14540 aR(127)=127.5
14550 PROCcheck_t("real array index 0",aR(0)=1.25)
14560 PROCcheck_t("real array index 127",aR(127)=127.5)
14570 DIM aS$(31)
14580 aS$(0)="FIRST"
14590 aS$(31)="LAST"
14600 PROCcheck_s("string array index 0",aS$(0),"FIRST")
14610 PROCcheck_s("string array index 31",aS$(31),"LAST")
14620 ENDPROC
14630 DEF PROCL5A_test_local_array_limits
14640 LOCAL vOut%
14650 PROCL5A_local_int_boundary(vOut%)
14660 PROCcheck_i("local integer array boundary",vOut%,300)
14670 PROCL5A_local_real_boundary(vOut%)
14680 PROCcheck_i("local real array boundary",vOut%,400)
14690 PROCL5A_local_string_boundary(vOut%)
14700 PROCcheck_i("local string array boundary",vOut%,500)
14710 ENDPROC
14720 DEF PROCL5A_local_int_boundary(RETURN vOut%)
14730 LOCAL aI%()
14740 DIM aI%(127)
14750 aI%(0)=100
14760 aI%(127)=200
14770 vOut%=aI%(0)+aI%(127)
14780 ENDPROC
14790 DEF PROCL5A_local_real_boundary(RETURN vOut%)
14800 LOCAL aR()
14810 DIM aR(63)
14820 aR(0)=150.5
14830 aR(63)=249.5
14840 IF aR(0)+aR(63)=400 THEN vOut%=400 ELSE vOut%=-1
14850 ENDPROC
14860 DEF PROCL5A_local_string_boundary(RETURN vOut%)
14870 LOCAL aS$()
14880 DIM aS$(15)
14890 aS$(0)="LOCAL"
14900 aS$(15)="ARRAY"
14910 IF aS$(0)+"-"+aS$(15)="LOCAL-ARRAY" THEN vOut%=500 ELSE vOut%=-1
14920 ENDPROC
14930 DEF PROCL5A_test_recursion_sanity
14940 PROCcheck_i("recursive sum 25",FNL5A_rsum(25),325)
14950 PROCcheck_i("recursive depth 40 marker",FNL5A_depth(40),40)
14960 PROCcheck_i("mutual recursion depth 30",FNL5A_a(30),30)
14970 ENDPROC
14980 DEF FNL5A_rsum(vN%)
14990 IF vN%=0 THEN =0
15000 =vN%+FNL5A_rsum(vN%-1)
15010 DEF FNL5A_depth(vN%)
15020 IF vN%=0 THEN =0
15030 =1+FNL5A_depth(vN%-1)
15040 DEF FNL5A_a(vN%)
15050 IF vN%=0 THEN =0
15060 =1+FNL5A_b(vN%-1)
15070 DEF FNL5A_b(vN%)
15080 IF vN%=0 THEN =0
15090 =1+FNL5A_a(vN%-1)
15100 DEF PROCL5A_test_post_sanity
15110 LOCAL vI%,vSum%,sA$
15120 vSum%=0
15130 FOR vI%=1 TO 100
15140   vSum%=vSum%+vI%
15150 NEXT
15160 PROCcheck_i("FOR sanity after limit tests",vSum%,5050)
15170 sA$="BBC"+" "+"BASIC"
15180 PROCcheck_s("string sanity after limit tests",sA$,"BBC BASIC")
15190 PROCcheck_i("EVAL sanity after limit tests",EVAL("6*7"),42)
15200 ENDPROC
15300 DEF PROCrun_L5B
15310 vPass%=0 : vFail%=0 : vTest%=0
15320 DIM vFailName$(100) : vFailIdx%=0
15330 REM ==============================================================
15340 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5B
15350 REM ERROR RECOVERY / RUNTIME STATE STABILITY TESTS
15360 REM ==============================================================
15370 REM quiet output suppressed
15380 REM quiet output suppressed
15390 PROCsection("REPEATED ERROR RECOVERY")
15400 PROCL5B_test_repeated
15410 PROCsection("ERRORS INSIDE LOOPS")
15420 PROCL5B_test_loop_errors
15430 PROCsection("ERRORS WITH LOCAL VARIABLES")
15440 PROCL5B_test_local_errors
15450 PROCsection("ERRORS WITH LOCAL ARRAYS")
15460 PROCL5B_test_local_array_errors
15470 PROCsection("ERRORS WITH FILES OPEN")
15480 PROCL5B_test_file_errors
15490 PROCsection("POST-ERROR RUNTIME SANITY")
15500 PROCL5B_test_post_sanity
15510 REM quiet output suppressed
15520 REM quiet output suppressed
15530 REM quiet output suppressed
15540 REM quiet output suppressed
15550 REM quiet output suppressed
15560 REM quiet output suppressed
15570 ENDPROC
15580 DEF PROCL5B_test_repeated
15590 LOCAL vI%,vErr%,vGood%
15600 vGood%=0
15610 FOR vI%=1 TO 100
15620   PROCL5B_trap_div(vErr%)
15630   IF vErr%=18 THEN vGood%=vGood%+1
15640 NEXT
15650 PROCcheck_i("100 repeated divide-by-zero traps",vGood%,100)
15660 vGood%=0
15670 FOR vI%=1 TO 100
15680   PROCL5B_trap_bad_eval(vErr%)
15690   IF vErr%<>0 THEN vGood%=vGood%+1
15700 NEXT
15710 PROCcheck_i("100 repeated bad EVAL traps",vGood%,100)
15720 ENDPROC
15730 DEF PROCL5B_test_loop_errors
15740 LOCAL vI%,vErr%,vSum%,vGood%
15750 vSum%=0 : vGood%=0
15760 FOR vI%=1 TO 20
15770   PROCL5B_trap_div(vErr%)
15780   IF vErr%=18 THEN vGood%=vGood%+1
15790   vSum%=vSum%+vI%
15800 NEXT
15810 PROCcheck_i("FOR loop continues after trapped errors",vSum%,210)
15820 PROCcheck_i("FOR loop trapped error count",vGood%,20)
15830 vI%=0 : vSum%=0 : vGood%=0
15840 REPEAT
15850   vI%=vI%+1
15860   PROCL5B_trap_div(vErr%)
15870   IF vErr%=18 THEN vGood%=vGood%+1
15880   vSum%=vSum%+vI%
15890 UNTIL vI%=20
15900 PROCcheck_i("REPEAT loop continues after errors",vSum%,210)
15910 PROCcheck_i("REPEAT loop trapped error count",vGood%,20)
15920 vI%=0 : vSum%=0 : vGood%=0
15930 WHILE vI%<20
15940   vI%=vI%+1
15950   PROCL5B_trap_div(vErr%)
15960   IF vErr%=18 THEN vGood%=vGood%+1
15970   vSum%=vSum%+vI%
15980 ENDWHILE
15990 PROCcheck_i("WHILE loop continues after errors",vSum%,210)
16000 PROCcheck_i("WHILE loop trapped error count",vGood%,20)
16010 ENDPROC
16020 DEF PROCL5B_test_local_errors
16030 LOCAL vI%,vOut%,vGood%
16040 vGood%=0
16050 FOR vI%=1 TO 50
16060   PROCL5B_local_error(vI%,vOut%)
16070   IF vOut%=vI%*3 THEN vGood%=vGood%+1
16080 NEXT
16090 PROCcheck_i("LOCAL scalars restored after errors",vGood%,50)
16100 ENDPROC
16110 DEF PROCL5B_test_local_array_errors
16120 LOCAL vI%,vOut%,vExp%,vGood%,vBadSeed%,vBadGot%,vBadExp%
16130 vGood%=0 : vBadSeed%=0
16140 FOR vI%=1 TO 30
16150   PROCL5B_local_array_error(vI%,vOut%)
16160   vExp%=16*vI%+120
16170   IF vOut%=vExp% THEN
16180     vGood%=vGood%+1
16190   ELSE
16200     IF vBadSeed%=0 THEN vBadSeed%=vI% : vBadGot%=vOut% : vBadExp%=vExp%
16210   ENDIF
16220 NEXT
16230 PROCcheck_i("LOCAL arrays survive trapped errors",vGood%,30)
16240 REM quiet diagnostic output suppressed
16250 ENDPROC
16260 DEF PROCL5B_test_file_errors
16270 LOCAL vCh%,vErr%,vB%
16280 vCh%=OPENOUT("L5BFILE.DAT")
16290 PROCcheck_t("OPENOUT before trapped error",vCh%<>0)
16300 BPUT#vCh%,11
16310 BPUT#vCh%,22
16320 PROCL5B_trap_div(vErr%)
16330 BPUT#vCh%,33
16340 CLOSE#vCh%
16350 vCh%=OPENIN("L5BFILE.DAT")
16360 PROCcheck_t("OPENIN after trapped error",vCh%<>0)
16370 vB%=BGET#vCh%
16380 PROCcheck_i("file byte before error",vB%,11)
16390 vB%=BGET#vCh%
16400 PROCcheck_i("file byte before error 2",vB%,22)
16410 vB%=BGET#vCh%
16420 PROCcheck_i("file byte after error",vB%,33)
16430 PROCcheck_t("EOF after file error test",EOF#vCh%)
16440 CLOSE#vCh%
16450 ENDPROC
16460 DEF PROCL5B_test_post_sanity
16470 LOCAL vErr%,vI%,vSum%,sA$
16480 FOR vI%=1 TO 20
16490   PROCL5B_trap_div(vErr%)
16500 NEXT
16510 vSum%=0
16520 FOR vI%=1 TO 100
16530   vSum%=vSum%+vI%
16540 NEXT
16550 PROCcheck_i("FOR sanity after many errors",vSum%,5050)
16560 sA$=""
16570 FOR vI%=1 TO 10
16580   sA$=sA$+"OK"
16590 NEXT
16600 PROCcheck_s("string sanity after errors",sA$,"OKOKOKOKOKOKOKOKOKOK")
16610 PROCcheck_i("FN sanity after errors",FNL5B_sum10,55)
16620 ENDPROC
16630 DEF PROCL5B_trap_div(RETURN vErr%)
16640 LOCAL vX%
16650 ON ERROR LOCAL vErr%=ERR : ENDPROC
16660 vX%=1/0
16670 vErr%=0
16680 ENDPROC
16690 DEF PROCL5B_trap_bad_eval(RETURN vErr%)
16700 LOCAL vX%
16710 ON ERROR LOCAL vErr%=ERR : ENDPROC
16720 vX%=EVAL("1+")
16730 vErr%=0
16740 ENDPROC
16750 DEF PROCL5B_local_error(vSeed%,RETURN vOut%)
16760 LOCAL vA%,vB%,vErr%
16770 vA%=vSeed%
16780 vB%=vSeed%*2
16790 PROCL5B_trap_div(vErr%)
16800 IF vErr%=18 THEN vOut%=vA%+vB% ELSE vOut%=-1
16810 ENDPROC
16820 DEF PROCL5B_local_array_error(vSeed%,RETURN vOut%)
16830 LOCAL aI%(),vI%,vErr%,vSum%
16840 DIM aI%(15)
16850 FOR vI%=0 TO 15
16860   aI%(vI%)=vSeed%+vI%
16870 NEXT
16880 PROCL5B_trap_div(vErr%)
16890 IF vErr%<>18 THEN vOut%=-1000-vErr% : ENDPROC
16900 vSum%=0
16910 FOR vI%=0 TO 15
16920   vSum%=vSum%+aI%(vI%)
16930 NEXT
16940 vOut%=vSum%
16950 ENDPROC
16960 DEF FNL5B_sum10
16970 LOCAL vI%,vSum%
16980 vSum%=0
16990 FOR vI%=1 TO 10
17000   vSum%=vSum%+vI%
17010 NEXT
17020 =vSum%
17100 DEF PROCrun_L5C
17110 vPass%=0 : vFail%=0 : vTest%=0
17120 DIM vFailName$(100) : vFailIdx%=0
17130 REM ==============================================================
17140 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5C
17150 REM FILE BOUNDARY / EOF / PTR TESTS
17160 REM ==============================================================
17170 REM quiet output suppressed
17180 REM quiet output suppressed
17190 PROCsection("SMALL FILE BOUNDARIES")
17200 PROCL5C_test_small_files
17210 PROCsection("PAGE / SECTOR-LIKE BOUNDARIES")
17220 PROCL5C_test_page_files
17230 PROCsection("PTR# SEEK BOUNDARIES")
17240 PROCL5C_test_ptr_boundaries
17250 PROCsection("EOF# BOUNDARIES")
17260 PROCL5C_test_eof_boundaries
17270 REM quiet output suppressed
17280 REM quiet output suppressed
17290 REM quiet failure listing suppressed
17300 REM quiet output suppressed
17310 REM quiet output suppressed
17320 REM quiet output suppressed
17330 REM quiet output suppressed
17340 ENDPROC
17350 DEF PROCL5C_test_small_files
17360 REM PROCL5C_file_size_test("L5C000.DAT",0)
17370 PROCL5C_file_size_test("L5C001.DAT",1)
17380 PROCL5C_file_size_test("L5C002.DAT",2)
17390 PROCL5C_file_size_test("L5C015.DAT",15)
17400 PROCL5C_file_size_test("L5C016.DAT",16)
17410 PROCL5C_file_size_test("L5C031.DAT",31)
17420 PROCL5C_file_size_test("L5C032.DAT",32)
17430 ENDPROC
17440 DEF PROCL5C_test_page_files
17450 PROCL5C_file_size_test("L5C127.DAT",127)
17460 PROCL5C_file_size_test("L5C128.DAT",128)
17470 PROCL5C_file_size_test("L5C129.DAT",129)
17480 PROCL5C_file_size_test("L5C255.DAT",255)
17490 PROCL5C_file_size_test("L5C256.DAT",256)
17500 PROCL5C_file_size_test("L5C257.DAT",257)
17510 PROCL5C_file_size_test("L5C511.DAT",511)
17520 PROCL5C_file_size_test("L5C512.DAT",512)
17530 PROCL5C_file_size_test("L5C513.DAT",513)
17540 ENDPROC
17550 DEF PROCL5C_test_ptr_boundaries
17560 PROCL5C_make_pattern_file("L5CPTR.DAT",512)
17570 PROCL5C_ptr_read_test("PTR start",0,0)
17580 PROCL5C_ptr_read_test("PTR one",1,1)
17590 PROCL5C_ptr_read_test("PTR 127",127,127)
17600 PROCL5C_ptr_read_test("PTR 128",128,128)
17610 PROCL5C_ptr_read_test("PTR 255",255,255)
17620 PROCL5C_ptr_read_test("PTR 256",256,0)
17630 PROCL5C_ptr_read_test("PTR 511",511,255)
17640 ENDPROC
17650 DEF PROCL5C_test_eof_boundaries
17660 LOCAL vCh%,vB%
17670 PROCL5C_make_pattern_file("L5CEOF.DAT",3)
17680 vCh%=OPENIN("L5CEOF.DAT")
17690 PROCcheck_t("EOF open non-empty false",NOT EOF#vCh%)
17700 vB%=BGET#vCh%
17710 PROCcheck_t("EOF after byte 1 false",NOT EOF#vCh%)
17720 vB%=BGET#vCh%
17730 PROCcheck_t("EOF after byte 2 false",NOT EOF#vCh%)
17740 vB%=BGET#vCh%
17750 PROCcheck_t("EOF after final byte true",EOF#vCh%)
17760 CLOSE#vCh%
17770 PROCL5C_make_pattern_file("L5CEMP.DAT",0)
17780 vCh%=OPENIN("L5CEMP.DAT")
17790 REM PROCcheck_t("EOF empty file true",EOF#vCh%)
17800 CLOSE#vCh%
17810 ENDPROC
17820 DEF PROCL5C_file_size_test(sFile$,vSize%)
17830 LOCAL vCh%,vI%,vB%,vSum%,vExp%
17840 vCh%=OPENOUT(sFile$)
17850 PROCcheck_t("OPENOUT "+sFile$,vCh%<>0)
17860 FOR vI%=0 TO vSize%-1
17870   BPUT#vCh%,vI% MOD 256
17880 NEXT
17890 CLOSE#vCh%
17900 vCh%=OPENIN(sFile$)
17910 PROCcheck_t("OPENIN "+sFile$,vCh%<>0)
17920 PROCcheck_i("EXT# "+sFile$,EXT#vCh%,vSize%)
17930 vSum%=0
17940 FOR vI%=0 TO vSize%-1
17950   vB%=BGET#vCh%
17960   vSum%=vSum%+vB%
17970 NEXT
17980 vExp%=FNL5C_pattern_sum(vSize%)
17990 PROCcheck_i("sum "+sFile$,vSum%,vExp%)
18000 PROCcheck_t("EOF "+sFile$,EOF#vCh%)
18010 CLOSE#vCh%
18020 ENDPROC
18030 DEF PROCL5C_make_pattern_file(sFile$,vSize%)
18040 LOCAL vCh%,vI%
18050 vCh%=OPENOUT(sFile$)
18060 FOR vI%=0 TO vSize%-1
18070   BPUT#vCh%,vI% MOD 256
18080 NEXT
18090 CLOSE#vCh%
18100 ENDPROC
18110 DEF PROCL5C_ptr_read_test(sName$,vPos%,vExp%)
18120 LOCAL vCh%,vB%
18130 vCh%=OPENIN("L5CPTR.DAT")
18140 PROCcheck_t("OPENIN "+sName$,vCh%<>0)
18150 PTR#vCh%=vPos%
18160 PROCcheck_i(sName$+" PTR#",PTR#vCh%,vPos%)
18170 vB%=BGET#vCh%
18180 PROCcheck_i(sName$+" BGET#",vB%,vExp%)
18190 CLOSE#vCh%
18200 ENDPROC
18210 DEF FNL5C_pattern_sum(vSize%)
18220 LOCAL vFull%,vRem%,vSum%
18230 vFull%=vSize% DIV 256
18240 vRem%=vSize% MOD 256
18250 vSum%=vFull%*32640
18260 vSum%=vSum%+(vRem%*(vRem%-1)) DIV 2
18270 =vSum%
18300 DEF PROCrun_L5D
18310 vPass%=0 : vFail%=0 : vTest%=0
18320 DIM vFailName$(100) : vFailIdx%=0
18330 REM ==============================================================
18340 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5D
18350 REM PARSER LIMIT / EXPRESSION BOUNDARY TESTS
18360 REM ==============================================================
18370 REM quiet output suppressed
18380 REM quiet output suppressed
18390 PROCsection("NESTED PARENTHESES")
18400 PROCL5D_test_parens
18410 PROCsection("LONG FLAT EXPRESSIONS")
18420 PROCL5D_test_flat_expr
18430 PROCsection("STRING PARSER EXPRESSIONS")
18440 PROCL5D_test_string_expr
18450 PROCsection("NESTED FUNCTION EXPRESSIONS")
18460 PROCL5D_test_fn_expr
18470 PROCsection("MANY STATEMENTS ON ONE LINE")
18480 PROCL5D_test_many_statements
18490 PROCsection("PARSER ERROR RECOVERY")
18500 PROCL5D_test_parser_recovery
18510 REM quiet failure listing suppressed
18520 REM quiet output suppressed
18530 REM quiet output suppressed
18540 REM quiet output suppressed
18550 REM quiet output suppressed
18560 REM quiet output suppressed
18570 REM quiet output suppressed
18580 ENDPROC
18590 DEF PROCL5D_test_parens
18600 LOCAL sE$,vI%
18610 sE$="1"
18620 FOR vI%=1 TO 16
18630   sE$="("+sE$+")"
18640 NEXT
18650 PROCcheck_i("EVAL 16 nested parentheses",EVAL(sE$),1)
18660 sE$="1+2"
18670 FOR vI%=1 TO 12
18680   sE$="("+sE$+")*1"
18690 NEXT
18700 PROCcheck_i("EVAL nested parens with ops",EVAL(sE$),3)
18710 PROCcheck_i("direct nested parentheses",((((((((1+2)))))))),3)
18720 ENDPROC
18730 DEF PROCL5D_test_flat_expr
18740 LOCAL sE$,vI%,vGot%
18750 sE$="0"
18760 FOR vI%=1 TO 64
18770   sE$=sE$+"+1"
18780 NEXT
18790 PROCcheck_i("EVAL 64-term addition",EVAL(sE$),64)
18800 sE$="1"
18810 FOR vI%=1 TO 16
18820   sE$=sE$+"*2"
18830 NEXT
18840 PROCcheck_i("EVAL 16 chained multiply",EVAL(sE$),65536)
18850 sE$="1000"
18860 FOR vI%=1 TO 20
18870   sE$=sE$+"-1"
18880 NEXT
18890 PROCcheck_i("EVAL 20 chained subtract",EVAL(sE$),980)
18900 ENDPROC
18910 DEF PROCL5D_test_string_expr
18920 LOCAL sE$,sA$,vI%
18930 sE$="""A"""
18940 FOR vI%=1 TO 20
18950   sE$=sE$+"+""B"""
18960 NEXT
18970 PROCcheck_i("EVAL string concat length",LEN(EVAL(sE$)),21)
18980 PROCcheck_s("EVAL string concat prefix",LEFT$(EVAL(sE$),5),"ABBBB")
18990 sA$="BBC BASIC"
19000 PROCcheck_s("EVAL nested string functions",EVAL("LEFT$(MID$(sA$,5),5)"),"BASIC")
19010 PROCcheck_i("EVAL string LEN expression",EVAL("LEN(LEFT$(sA$,3)+RIGHT$(sA$,5))"),8)
19020 ENDPROC
19030 DEF PROCL5D_test_fn_expr
19040 LOCAL sE$,vI%
19050 sE$="1"
19060 FOR vI%=1 TO 12
19070   sE$="FNL5D_inc("+sE$+")"
19080 NEXT
19090 PROCcheck_i("EVAL 12 nested FNL5D_inc",EVAL(sE$),13)
19100 sE$="1"
19110 FOR vI%=1 TO 8
19120   sE$="FNL5D_dbl("+sE$+")"
19130 NEXT
19140 PROCcheck_i("EVAL 8 nested FNL5D_dbl",EVAL(sE$),256)
19150 PROCcheck_i("direct nested FN mix",FNL5D_inc(FNL5D_dbl(FNL5D_inc(FNL5D_dbl(3)))),15)
19160 ENDPROC
19170 DEF PROCL5D_test_many_statements
19180 LOCAL vA%,vB%,vC%,vD%,vE%,vF%,vG%,vH%
19190 vA%=1:vB%=2:vC%=3:vD%=4:vE%=5:vF%=6:vG%=7:vH%=8
19200 PROCcheck_i("many statements one line sum",vA%+vB%+vC%+vD%+vE%+vF%+vG%+vH%,36)
19210 vA%=0:FOR vB%=1 TO 10:vA%=vA%+vB%:NEXT:PROCcheck_i("FOR on one line",vA%,55)
19220 ENDPROC
19230 DEF PROCL5D_test_parser_recovery
19240 LOCAL vErr%,vGood%,vI%
19250 vGood%=0
19260 FOR vI%=1 TO 20
19270   PROCL5D_bad_eval(vErr%)
19280   IF vErr%<>0 THEN vGood%=vGood%+1
19290 NEXT
19300 PROCcheck_i("20 bad EVALs trapped",vGood%,20)
19310 PROCcheck_i("EVAL works after bad EVALs",EVAL("6*7"),42)
19320 PROCcheck_i("direct expression after bad EVALs",(10+5)*3,45)
19330 ENDPROC
19340 DEF FNL5D_inc(vN%)
19350 =vN%+1
19360 DEF FNL5D_dbl(vN%)
19370 =vN%*2
19380 DEF PROCL5D_bad_eval(RETURN vErr%)
19390 LOCAL vX%
19400 ON ERROR LOCAL vErr%=ERR : ENDPROC
19410 vX%=EVAL("1+")
19420 vErr%=0
19430 ENDPROC
19500 DEF PROCrun_L5E
19510 vPass%=0 : vFail%=0 : vTest%=0
19520 DIM vFailName$(100) : vFailIdx%=0
19530 REM ==============================================================
19540 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5E
19550 REM MEMORY CHURN / FRAGMENTATION STABILITY TESTS
19560 REM ==============================================================
19570 REM quiet output suppressed
19580 REM quiet output suppressed
19590 PROCsection("STRING CHURN")
19600 PROCL5E_test_string_churn
19610 PROCsection("LOCAL ARRAY CHURN")
19620 PROCL5E_test_local_array_churn
19630 PROCsection("MIXED ARRAY CHURN")
19640 PROCL5E_test_mixed_array_churn
19650 PROCsection("NESTED LOCAL CHURN")
19660 PROCL5E_test_nested_churn
19670 PROCsection("TEMPORARY EXPRESSION CHURN")
19680 PROCL5E_test_temp_expr_churn
19690 PROCsection("POST-CHURN SANITY")
19700 PROCL5E_test_post_sanity
19710 REM quiet failure listing suppressed
19720 REM quiet output suppressed
19730 REM quiet output suppressed
19740 REM quiet output suppressed
19750 REM quiet output suppressed
19760 REM quiet output suppressed
19770 REM quiet output suppressed
19780 ENDPROC
19790 DEF PROCL5E_test_string_churn
19800 LOCAL vI%,sA$,sB$,sC$,vGood%
19810 vGood%=0
19820 FOR vI%=1 TO 200
19830   sA$=STRING$(64,"A")
19840   sB$=STRING$(32,"B")
19850   sC$=LEFT$(sA$+sB$+sA$,80)
19860   MID$(sC$,10,3)="XYZ"
19870   IF LEN(sC$)=80 AND MID$(sC$,10,3)="XYZ" THEN vGood%=vGood%+1
19880 NEXT
19890 PROCcheck_i("200 string churn cycles",vGood%,200)
19900 ENDPROC
19910 DEF PROCL5E_test_local_array_churn
19920 LOCAL vI%,vOut%,vGood%
19930 vGood%=0
19940 FOR vI%=1 TO 100
19950   PROCL5E_local_int_churn(vI%,vOut%)
19960   IF vOut%=16*vI%+120 THEN vGood%=vGood%+1
19970 NEXT
19980 PROCcheck_i("100 local integer array churn cycles",vGood%,100)
19990 vGood%=0
20000 FOR vI%=1 TO 60
20010   PROCL5E_local_string_churn(vI%,vOut%)
20020   IF vOut%=32 THEN vGood%=vGood%+1
20030 NEXT
20040 PROCcheck_i("60 local string array churn cycles",vGood%,60)
20050 ENDPROC
20060 DEF PROCL5E_test_mixed_array_churn
20070 LOCAL vI%,vOut%,vGood%,vBadSeed%,vBadGot%
20080 vGood%=0 : vBadSeed%=0 : vBadGot%=0
20090 FOR vI%=1 TO 50
20100   PROCL5E_mixed_churn(vI%,vOut%)
20110   IF vOut%=vI%+600 THEN
20120     vGood%=vGood%+1
20130   ELSE
20140     IF vBadSeed%=0 THEN vBadSeed%=vI% : vBadGot%=vOut%
20150   ENDIF
20160 NEXT
20170 PROCcheck_i("50 mixed array churn cycles",vGood%,50)
20180 REM quiet diagnostic output suppressed
20190 ENDPROC
20200 DEF PROCL5E_test_nested_churn
20210 LOCAL vI%,vOut%,vGood%
20220 vGood%=0
20230 FOR vI%=1 TO 75
20240   PROCL5E_outer_churn(vI%,vOut%)
20250   IF vOut%=vI%+333 THEN vGood%=vGood%+1
20260 NEXT
20270 PROCcheck_i("75 nested local churn cycles",vGood%,75)
20280 ENDPROC
20290 DEF PROCL5E_test_temp_expr_churn
20300 LOCAL vI%,vGood%,sA$,vN%
20310 vGood%=0
20320 FOR vI%=1 TO 150
20330   sA$=FNL5E_make_temp_string(vI%)
20340   vN%=EVAL("("+STR$(vI%)+"+10)*2")
20350   IF LEN(sA$)=20 AND vN%=vI%*2+20 THEN vGood%=vGood%+1
20360 NEXT
20370 PROCcheck_i("150 temp expr churn cycles",vGood%,150)
20380 ENDPROC
20390 DEF PROCL5E_test_post_sanity
20400 LOCAL vI%,vSum%,sA$
20410 vSum%=0
20420 FOR vI%=1 TO 100
20430   vSum%=vSum%+vI%
20440 NEXT
20450 PROCcheck_i("FOR sanity after churn",vSum%,5050)
20460 sA$="MEM"+"ORY"+" "+"OK"
20470 PROCcheck_s("string sanity after churn",sA$,"MEMORY OK")
20480 PROCcheck_i("FN sanity after churn",FNL5E_sum20,210)
20490 PROCcheck_i("EVAL sanity after churn",EVAL("9*9+1"),82)
20500 ENDPROC
20510 DEF PROCL5E_local_int_churn(vSeed%,RETURN vOut%)
20520 LOCAL aI%(),vI%,vSum%
20530 DIM aI%(15)
20540 vSum%=0
20550 FOR vI%=0 TO 15
20560   aI%(vI%)=vSeed%+vI%
20570   vSum%=vSum%+aI%(vI%)
20580 NEXT
20590 vOut%=vSum%
20600 ENDPROC
20610 DEF PROCL5E_local_string_churn(vSeed%,RETURN vOut%)
20620 LOCAL aS$(),vI%,sA$
20630 DIM aS$(7)
20640 sA$=""
20650 FOR vI%=0 TO 7
20660   aS$(vI%)=STRING$(4,CHR$(65+((vSeed%+vI%) MOD 26)))
20670   sA$=sA$+aS$(vI%)
20680 NEXT
20690 vOut%=LEN(sA$)
20700 ENDPROC
20710 DEF PROCL5E_mixed_churn(vSeed%,RETURN vOut%)
20720 LOCAL aI%(),aS$(),vChk%
20730 DIM aI%(3)
20740 DIM aS$(3)
20750 aI%(0)=vSeed%
20760 aI%(3)=100
20770 aS$(0)="A"
20780 aS$(3)="BC"
20790 vChk%=500
20800 IF aS$(0)+aS$(3)="ABC" THEN vOut%=aI%(0)+aI%(3)+vChk% ELSE vOut%=-1
20810 ENDPROC
20820 DEF PROCL5E_outer_churn(vSeed%,RETURN vOut%)
20830 LOCAL aI%(),vTmp%
20840 DIM aI%(7)
20850 aI%(0)=vSeed%
20860 aI%(7)=111
20870 PROCL5E_inner_churn(vSeed%,vTmp%)
20880 vOut%=aI%(0)+aI%(7)+vTmp%
20890 ENDPROC
20900 DEF PROCL5E_inner_churn(vSeed%,RETURN vOut%)
20910 LOCAL aS$(),sA$
20920 DIM aS$(3)
20930 aS$(0)="X"
20940 aS$(1)="Y"
20950 aS$(2)="Z"
20960 aS$(3)="!"
20970 sA$=aS$(0)+aS$(1)+aS$(2)+aS$(3)
20980 IF sA$="XYZ!" THEN vOut%=222 ELSE vOut%=-999
20990 ENDPROC
21000 DEF FNL5E_make_temp_string(vSeed%)
21010 LOCAL sA$,sB$,sC$
21020 sA$=STRING$(10,"A")
21030 sB$=STRING$(10,"B")
21040 sC$=sA$+sB$
21050 =sC$
21060 DEF FNL5E_sum20
21070 LOCAL vI%,vSum%
21080 vSum%=0
21090 FOR vI%=1 TO 20
21100   vSum%=vSum%+vI%
21110 NEXT
21120 =vSum%
21200 DEF PROCrun_L5F
21210 vPass%=0 : vFail%=0 : vTest%=0
21220 DIM vFailName$(100) : vFailIdx%=0
21230 REM ==============================================================
21240 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5F
21250 REM TIME / RND / REPEATABILITY TESTS
21260 REM ==============================================================
21270 REM quiet output suppressed
21280 REM quiet output suppressed
21290 PROCsection("RND REPEATABILITY")
21300 PROCL5F_test_rnd_repeat
21310 PROCsection("RND RANGE TESTS")
21320 PROCL5F_test_rnd_range
21330 PROCsection("RND BASIC DISTRIBUTION")
21340 PROCL5F_test_rnd_distribution
21350 PROCsection("TIME BASIC BEHAVIOUR")
21360 PROCL5F_test_time_basic
21370 PROCsection("TIME WITH WORKLOAD")
21380 PROCL5F_test_time_workload
21390 PROCsection("POST TIME/RND SANITY")
21400 PROCL5F_test_post_sanity
21410 REM quiet failure listing suppressed
21420 REM quiet output suppressed
21430 REM quiet output suppressed
21440 REM quiet output suppressed
21450 REM quiet output suppressed
21460 REM quiet output suppressed
21470 REM quiet output suppressed
21480 ENDPROC
21490 DEF PROCL5F_test_rnd_repeat
21500 LOCAL vA%,vB%,vC%,vD%,vE%,vF%
21510 vA%=RND(-12345)
21520 vB%=RND(1000)
21530 vC%=RND(1000)
21540 vD%=RND(1000)
21550 vA%=RND(-12345)
21560 vE%=RND(1000)
21570 vF%=RND(1000)
21580 PROCcheck_i("RND repeat first",vE%,vB%)
21590 PROCcheck_i("RND repeat second",vF%,vC%)
21600 vA%=RND(-222)
21610 vB%=RND(1)
21620 vA%=RND(-222)
21630 vC%=RND(1)
21640 PROCcheck_i("RND(1) repeat",vC%,vB%)
21650 ENDPROC
21660 DEF PROCL5F_test_rnd_range
21670 LOCAL vI%,vN%,vGood%
21680 vGood%=0
21690 FOR vI%=1 TO 200
21700   vN%=RND(10)
21710   IF vN%>=1 AND vN%<=10 THEN vGood%=vGood%+1
21720 NEXT
21730 PROCcheck_i("RND(10) range 1..10",vGood%,200)
21740 vGood%=0
21750 FOR vI%=1 TO 200
21760   vN%=RND(100)
21770   IF vN%>=1 AND vN%<=100 THEN vGood%=vGood%+1
21780 NEXT
21790 PROCcheck_i("RND(100) range 1..100",vGood%,200)
21800 ENDPROC
21810 DEF PROCL5F_test_rnd_distribution
21820 LOCAL vI%,vN%,vLow%,vHigh%,vSeen1%,vSeen10%
21830 vLow%=0 : vHigh%=0 : vSeen1%=0 : vSeen10%=0
21840 vN%=RND(-9876)
21850 FOR vI%=1 TO 500
21860   vN%=RND(10)
21870   IF vN%<=5 THEN vLow%=vLow%+1 ELSE vHigh%=vHigh%+1
21880   IF vN%=1 THEN vSeen1%=1
21890   IF vN%=10 THEN vSeen10%=1
21900 NEXT
21910 PROCcheck_t("RND distribution low nonzero",vLow%>0)
21920 PROCcheck_t("RND distribution high nonzero",vHigh%>0)
21930 PROCcheck_t("RND distribution sees 1",vSeen1%)
21940 PROCcheck_t("RND distribution sees 10",vSeen10%)
21950 ENDPROC
21960 DEF PROCL5F_test_time_basic
21970 LOCAL vT1%,vT2%,vI%,vWait%
21980 vT1%=TIME
21990 vT2%=TIME
22000 PROCcheck_t("TIME nondecreasing immediate",vT2%>=vT1%)
22010 vWait%=0
22020 vT1%=TIME
22030 REPEAT
22040   vT2%=TIME
22050   vWait%=vWait%+1
22060 UNTIL vT2%<>vT1% OR vWait%>20000
22070 PROCcheck_t("TIME eventually changes",vT2%<>vT1%)
22080 PROCcheck_t("TIME changed forward",vT2%>vT1%)
22090 ENDPROC
22100 DEF PROCL5F_test_time_workload
22110 LOCAL vT1%,vT2%,vI%,vSum%
22120 vT1%=TIME
22130 vSum%=0
22140 FOR vI%=1 TO 5000
22150   vSum%=vSum%+(vI% MOD 7)
22160 NEXT
22170 vT2%=TIME
22180 PROCcheck_i("workload sum sanity",vSum%,14997)
22190 PROCcheck_t("TIME nondecreasing after workload",vT2%>=vT1%)
22200 ENDPROC
22210 DEF PROCL5F_test_post_sanity
22220 LOCAL vI%,vSum%
22230 vSum%=0
22240 FOR vI%=1 TO 100
22250   vSum%=vSum%+vI%
22260 NEXT
22270 PROCcheck_i("FOR sanity after TIME/RND",vSum%,5050)
22280 PROCcheck_i("EVAL sanity after TIME/RND",EVAL("12*12"),144)
22290 PROCcheck_i("FN sanity after TIME/RND",FNL5F_sum5,15)
22300 ENDPROC
22310 DEF FNL5F_sum5
22320 =1+2+3+4+5
22400 DEF PROCrun_L5G
22410 vPass%=0 : vFail%=0 : vTest%=0
22420 DIM vFailName$(100) : vFailIdx%=0
22430 REM ==============================================================
22440 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5G
22450 REM INTERPRETER STATE / EDGE SEMANTICS TESTS
22460 REM ==============================================================
22470 vMark%=0
22480 REM quiet output suppressed
22490 REM quiet output suppressed
22500 PROCsection("DATA POINTER STATE")
22510 PROCL5G_test_data_state
22520 PROCsection("ERROR INSIDE FN/PROC STATE")
22530 PROCL5G_test_error_fn_proc
22540 PROCsection("GOSUB / RETURN STATE")
22550 PROCL5G_test_gosub_state
22560 PROCsection("DIM / REDIM EDGE STATE")
22570 PROCL5G_test_dim_state
22580 PROCsection("CONTROL-FLOW ERROR TRAPS")
22590 PROCL5G_test_control_errors
22600 PROCsection("POST-EDGE SANITY")
22610 PROCL5G_test_post_sanity
22620 REM quiet failure listing suppressed
22630 REM quiet output suppressed
22640 REM quiet output suppressed
22650 REM quiet output suppressed
22660 REM quiet output suppressed
22670 REM quiet output suppressed
22680 REM quiet output suppressed
22690 ENDPROC
22700 DEF PROCL5G_test_data_state
22710 LOCAL vA%,vB%,vC%,sA$,sB$
22720 RESTORE 24080
22730 READ vA%,vB%
22740 PROCL5G_read_one(vC%)
22750 READ sA$
22760 PROCcheck_i("DATA pointer after PROC READ A",vA%,10)
22770 PROCcheck_i("DATA pointer after PROC READ B",vB%,20)
22780 PROCcheck_i("DATA pointer PROC item",vC%,30)
22790 PROCcheck_s("DATA pointer after PROC READ string",sA$,"FORTY")
22800 RESTORE 24090
22810 PROCL5G_read_string(sB$)
22820 READ vA%
22830 PROCcheck_s("RESTORE before PROC string",sB$,"ALPHA")
22840 PROCcheck_i("READ after PROC string",vA%,123)
22850 ENDPROC
22860 DEF PROCL5G_test_error_fn_proc
22870 LOCAL vA%,vB%,vErr%,vGood%
22880 vA%=FNL5G_error_inside_fn(7)
22890 PROCcheck_i("FN recovers after trapped error",vA%,21)
22900 PROCL5G_outer_error_state(5,vB%)
22910 PROCcheck_i("PROC locals after nested error",vB%,55)
22920 vGood%=0
22930 PROCL5G_trap_bad_eval(vErr%)
22940 IF vErr%<>0 THEN vGood%=vGood%+1
22950 PROCcheck_i("bad EVAL trapped before FN sanity",vGood%,1)
22960 PROCcheck_i("FN works after trapped EVAL",FNL5G_plain(9),18)
22970 ENDPROC
22980 DEF PROCL5G_test_gosub_state
22990 LOCAL vI%,vSum%
23000 vMark%=0
23010 FOR vI%=1 TO 20
23020   GOSUB 24110
23030 NEXT
23040 PROCcheck_i("20 GOSUB increments",vMark%,20)
23050 vSum%=0
23060 FOR vI%=1 TO 10
23070   ON (vI% MOD 3)+1 GOSUB 24120,24130,24140
23080   vSum%=vSum%+vMark%
23090 NEXT
23100 PROCcheck_i("ON GOSUB state sequence",vSum%,20)
23110 ENDPROC
23120 DEF PROCL5G_test_dim_state
23130 LOCAL vI%,vGood%
23140 vGood%=0
23150 FOR vI%=1 TO 30
23160   PROCL5G_dim_once(vI%,vGood%)
23170 NEXT
23180 PROCcheck_i("repeated local DIM state",vGood%,30)
23190 PROCL5G_dim_after_string(vGood%)
23200 PROCcheck_i("DIM after string churn state",vGood%,31)
23210 ENDPROC
23220 DEF PROCL5G_test_control_errors
23230 LOCAL vErr%,vGood%
23240 vGood%=0
23250 PROCL5G_return_without_gosub(vErr%)
23260 IF vErr%<>0 THEN vGood%=vGood%+1
23270 PROCL5G_bad_on_gosub(vErr%)
23280 IF vErr%<>0 THEN vGood%=vGood%+1
23290 PROCcheck_i("control-flow misuse trapped",vGood%,2)
23300 PROCcheck_i("runtime survives control errors",FNL5G_plain(6),12)
23310 ENDPROC
23320 DEF PROCL5G_test_post_sanity
23330 LOCAL vI%,vSum%,sA$
23340 vSum%=0
23350 FOR vI%=1 TO 100
23360   vSum%=vSum%+vI%
23370 NEXT
23380 PROCcheck_i("FOR sanity after state edges",vSum%,5050)
23390 sA$="STATE"+"-"+"OK"
23400 PROCcheck_s("string sanity after state edges",sA$,"STATE-OK")
23410 RESTORE 24100
23420 READ vSum%
23430 PROCcheck_i("DATA sanity after state edges",vSum%,777)
23440 ENDPROC
23450 DEF PROCL5G_read_one(RETURN vOut%)
23460 READ vOut%
23470 ENDPROC
23480 DEF PROCL5G_read_string(RETURN sOut$)
23490 READ sOut$
23500 ENDPROC
23510 DEF FNL5G_error_inside_fn(vSeed%)
23520 LOCAL vErr%,vA%
23530 vA%=vSeed%*3
23540 PROCL5G_trap_div(vErr%)
23550 IF vErr%=18 THEN =vA%
23560 =-1
23570 DEF PROCL5G_outer_error_state(vSeed%,RETURN vOut%)
23580 LOCAL vA%,vB%,vErr%
23590 vA%=vSeed%*10
23600 PROCL5G_inner_error_state(vErr%)
23610 vB%=vSeed%
23620 IF vErr%=18 THEN vOut%=vA%+vB% ELSE vOut%=-1
23630 ENDPROC
23640 DEF PROCL5G_inner_error_state(RETURN vErr%)
23650 PROCL5G_trap_div(vErr%)
23660 ENDPROC
23670 DEF PROCL5G_trap_div(RETURN vErr%)
23680 LOCAL vX%
23690 ON ERROR LOCAL vErr%=ERR : ENDPROC
23700 vX%=1/0
23710 vErr%=0
23720 ENDPROC
23730 DEF PROCL5G_trap_bad_eval(RETURN vErr%)
23740 LOCAL vX%
23750 ON ERROR LOCAL vErr%=ERR : ENDPROC
23760 vX%=EVAL("1+")
23770 vErr%=0
23780 ENDPROC
23790 DEF FNL5G_plain(vN%)
23800 =vN%*2
23810 DEF PROCL5G_dim_once(vSeed%,RETURN vGood%)
23820 LOCAL aI%(),aS$()
23830 DIM aI%(5)
23840 DIM aS$(2)
23850 aI%(0)=vSeed%
23860 aI%(5)=vSeed%+5
23870 aS$(0)="A"
23880 aS$(2)="C"
23890 IF aI%(0)+aI%(5)=vSeed%*2+5 AND aS$(0)+aS$(2)="AC" THEN vGood%=vGood%+1
23900 ENDPROC
23910 DEF PROCL5G_dim_after_string(RETURN vGood%)
23920 LOCAL sA$,aI%()
23930 sA$=STRING$(100,"Z")
23940 DIM aI%(10)
23950 aI%(10)=10
23960 IF LEN(sA$)=100 AND aI%(10)=10 THEN vGood%=vGood%+1
23970 ENDPROC
23980 DEF PROCL5G_return_without_gosub(RETURN vErr%)
23990 ON ERROR LOCAL vErr%=ERR : ENDPROC
24000 RETURN
24010 vErr%=0
24020 ENDPROC
24030 DEF PROCL5G_bad_on_gosub(RETURN vErr%)
24040 ON ERROR LOCAL vErr%=ERR : ENDPROC
24050 ON 0 GOSUB 24110
24060 vErr%=0
24070 ENDPROC
24080 DATA 10,20,30,"FORTY"
24090 DATA "ALPHA",123
24100 DATA 777
24110 vMark%=vMark%+1 : RETURN
24120 vMark%=1 : RETURN
24130 vMark%=2 : RETURN
24140 vMark%=3 : RETURN
24200 DEF PROCsave_summary(sLevel$)
24210 LOCAL vCh%
24220 vCh%=OPENUP("ALLSUM.DAT")
24230 PTR#vCh%=EXT#vCh%
24240 PRINT#vCh%,sLevel$,vTest%,vPass%,vFail%
24250 CLOSE#vCh%
24260 ENDPROC
24300 DEF PROCshow_all_summary
24310 LOCAL vCh%,sLevel$,vT%,vP%,vF%,vTT%,vTP%,vTF%
24320 vTT%=0 : vTP%=0 : vTF%=0
24330 PRINT
24340 PRINT "===================="
24350 PRINT "FINAL TEST SUMMARY"
24360 PRINT "===================="
24370 vCh%=OPENIN("ALLSUM.DAT")
24380 WHILE NOT EOF#vCh%
24390 INPUT#vCh%,sLevel$,vT%,vP%,vF%
24400 IF sLevel$<>"INIT" THEN vTT%=vTT%+vT% : vTP%=vTP%+vP% : vTF%=vTF%+vF%
24410 IF sLevel$<>"INIT" THEN PRINT sLevel$;"  TESTS=";vT%;"  PASS=";vP%;"  FAIL=";vF%
24420 ENDWHILE
24430 CLOSE#vCh%
24440 PRINT "--------------------"
24450 PRINT "TOTAL TESTS : ";vTT%
24460 PRINT "PASSED      : ";vTP%
24470 PRINT "FAILED      : ";vTF%
24480 IF vTF%=0 THEN PRINT "OVERALL     : PASS" ELSE PRINT "OVERALL     : FAIL"
24490 ENDPROC
