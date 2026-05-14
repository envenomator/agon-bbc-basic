   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 LANGUAGE TEST HARNESS
   30 REM SAFE-NAME VERSION FOR PORT VALIDATION
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS"
   80 PRINT "--------------------------------"
   90 PROCsection("NUMERIC EXPRESSIONS")
  100 PROCtest_numeric
  101 PROCsection("CONVERSIONS")
  102 PROCsection("VAL")
  103 PROCtest_val
  110 PROCsection("STRINGS")
  120 PROCtest_strings
  130 PROCsection("FLOW CONTROL")
  140 PROCtest_flow
  150 PROCsection("PROCEDURES AND FUNCTIONS")
  160 PROCtest_procfn
  170 PROCsection("DATA / READ / RESTORE")
  180 PROCtest_data
  190 PROCsection("ARRAYS")
  200 PROCtest_arrays
  210 PROCsection("MEMORY / INDIRECTION")
  220 PROCtest_memory
  230 PROCsection("ERROR HANDLING")
  240 PROCtest_errors
  250 PRINT
  260 PRINT "--------------------------------"
  270 PRINT "TOTAL TESTS : ";vTest%
  280 PRINT "PASSED      : ";vPass%
  290 PRINT "FAILED      : ";vFail%
  300 PRINT "--------------------------------"
  310 END

  400 DEF PROCsection(sName$)
  410 PRINT
  420 PRINT sName$
  430 PRINT STRING$(LEN(sName$),"-")
  440 ENDPROC

  500 DEF PROCok(sName$)
  510 vTest%=vTest%+1
  520 vPass%=vPass%+1
  530 PRINT "PASS ";sName$
  540 ENDPROC

  600 DEF PROCbad_i(sName$,vGot%,vExp%)
  610 vTest%=vTest%+1
  620 vFail%=vFail%+1
  630 PRINT "FAIL ";sName$;"  got=";vGot%;" expected=";vExp%
  640 ENDPROC

  700 DEF PROCbad_r(sName$,vGot,vExp)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 PRINT "FAIL ";sName$;"  got=";vGot;" expected=";vExp
  740 ENDPROC

  800 DEF PROCbad_s(sName$,sGot$,sExp$)
  810 vTest%=vTest%+1
  820 vFail%=vFail%+1
  830 PRINT "FAIL ";sName$
  840 PRINT "     got=""";sGot$;""""
  850 PRINT "expected=""";sExp$;""""
  860 ENDPROC

  900 DEF PROCcheck_i(sName$,vGot%,vExp%)
  910 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  920 ENDPROC

 1000 DEF PROCcheck_r(sName$,vGot,vExp,vTol)
 1010 IF ABS(vGot-vExp)<=vTol THEN PROCok(sName$) ELSE PROCbad_r(sName$,vGot,vExp)
 1020 ENDPROC

 1100 DEF PROCcheck_s(sName$,sGot$,sExp$)
 1110 IF sGot$=sExp$ THEN PROCok(sName$) ELSE PROCbad_s(sName$,sGot$,sExp$)
 1120 ENDPROC

 1200 DEF PROCcheck_t(sName$,vFlag%)
 1210 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
 1220 ENDPROC

 2000 DEF PROCtest_numeric
 2010 LOCAL vN%
 2020 PROCcheck_i("precedence 7+5*3",7+5*3,22)
 2030 PROCcheck_i("brackets (7+5)*3",(7+5)*3,36)
 2040 PROCcheck_i("DIV",17 DIV 5,3)
 2050 PROCcheck_i("MOD",17 MOD 5,2)
 2060 vN%=123456
 2070 PROCcheck_i("integer assignment",vN%,123456)
 2080 PROCcheck_i("hex literal",&1234,4660)
 2090 PROCcheck_i("binary literal",%101101,45)
 2100 PROCcheck_i("TRUE",TRUE,-1)
 2110 PROCcheck_i("FALSE",FALSE,0)
 2120 PROCcheck_i("NOT FALSE",NOT FALSE,-1)
 2130 PROCcheck_i("AND",5 AND 3,1)
 2140 PROCcheck_i("OR",5 OR 2,7)
 2150 PROCcheck_i("EOR",5 EOR 3,6)
 2160 PROCcheck_i("shift left",1<<4,16)
 2170 PROCcheck_i("shift right",16>>2,4)
 2180 PROCcheck_r("ABS",ABS(-12.5),12.5,1E-9)
 2190 PROCcheck_i("INT positive",INT(99.8),99)
 2200 PROCcheck_i("INT negative",INT(-12.1),-13)
 2210 PROCcheck_i("SGN negative",SGN(-2),-1)
 2220 PROCcheck_i("SGN zero",SGN(0),0)
 2230 PROCcheck_i("SGN positive",SGN(3),1)
 2240 PROCcheck_r("SQR",SQR(81),9,1E-9)
 2250 PROCcheck_r("SIN(pi/2)",SIN(PI/2),1,1E-7)
 2260 PROCcheck_r("COS(0)",COS(0),1,1E-7)
 2270 PROCcheck_r("EXP(LN(5))",EXP(LN(5)),5,1E-7)
 2280 ENDPROC

 3000 DEF PROCtest_strings
 3010 LOCAL sA$,sB$,sC$
 3020 sA$="AGON"
 3030 sB$="BBC BASIC"
 3040 PROCcheck_i("LEN",LEN(sB$),9)
 3050 PROCcheck_s("LEFT$",LEFT$(sB$,3),"BBC")
 3060 PROCcheck_s("RIGHT$",RIGHT$(sB$,5),"BASIC")
 3070 PROCcheck_s("MID$ fixed",MID$(sB$,5,3),"BAS")
 3080 PROCcheck_s("MID$ to end",MID$(sB$,8),"IC")
 3090 PROCcheck_i("INSTR found",INSTR("HELLO WORLD","WORLD"),7)
 3100 PROCcheck_i("INSTR missing",INSTR("HELLO WORLD","ZZ"),0)
 3110 PROCcheck_i("ASC",ASC("A"),65)
 3120 PROCcheck_s("CHR$",CHR$(66),"B")
 3130 PROCcheck_i("VAL decimal",VAL("1234"),1234)
 3140 sC$="BBC BASIC"
 3150 LEFT$(sC$,3)="ZZ"
 3160 PROCcheck_s("LEFT$ assignment",sC$,"ZZC BASIC")
 3170 sC$="ABC"
 3180 sC$=sC$+"DEF"
 3190 PROCcheck_s("concatenation",sC$,"ABCDEF")
 3200 ENDPROC

 4000 DEF PROCtest_flow
 4010 LOCAL vI%,vSum%,vCnt%,vMark%,vDone%
 4020 vSum%=0
 4030 FOR vI%=1 TO 10
 4040   vSum%=vSum%+vI%
 4050 NEXT
 4060 PROCcheck_i("FOR/NEXT sum 1..10",vSum%,55)
 4070 vSum%=0
 4080 FOR vI%=5 TO 1 STEP -2
 4090   vSum%=vSum%+vI%
 4100 NEXT
 4110 PROCcheck_i("FOR STEP -2",vSum%,9)
 4120 vCnt%=0
 4130 REPEAT
 4140   vCnt%=vCnt%+1
 4150 UNTIL vCnt%=4
 4160 PROCcheck_i("REPEAT/UNTIL",vCnt%,4)
 4170 vCnt%=0
 4180 WHILE vCnt%<3
 4190   vCnt%=vCnt%+1
 4200 ENDWHILE
 4210 PROCcheck_i("WHILE/ENDWHILE",vCnt%,3)
 4220 vSum%=0
 4230 FOR vI%=1 TO 10
 4240   IF vI%=6 THEN EXIT FOR
 4250   vSum%=vSum%+vI%
 4260 NEXT
 4270 PROCcheck_i("EXIT FOR",vSum%,15)
 4280 vCnt%=0
 4290 REPEAT
 4300   vCnt%=vCnt%+1
 4310   IF vCnt%=3 THEN EXIT REPEAT
 4320 UNTIL FALSE
 4330 PROCcheck_i("EXIT REPEAT",vCnt%,3)
 4340 vCnt%=0
 4350 WHILE TRUE
 4360   vCnt%=vCnt%+1
 4370   IF vCnt%=2 THEN EXIT WHILE
 4380 ENDWHILE
 4390 PROCcheck_i("EXIT WHILE",vCnt%,2)
 4400 vMark%=0
 4410 ON 2 GOSUB 9000,9010,9020 ELSE 9030
 4420 PROCcheck_i("ON GOSUB",vMark%,22)
 4430 vDone%=0
 4440 IF 3<4 THEN vDone%=111 ELSE vDone%=222
 4450 PROCcheck_i("IF THEN ELSE single-line",vDone%,111)
 4460 vDone%=0
 4470 IF 2=2 THEN
 4480   vDone%=77
 4490 ELSE
 4500   vDone%=99
 4510 ENDIF
 4520 PROCcheck_i("IF THEN ENDIF multi-line",vDone%,77)
 4530 ENDPROC

 5000 DEF PROCtest_procfn
 5010 LOCAL vOut%,vTmp%
 5020 PROCdouble(7,vOut%)
 5030 PROCcheck_i("PROC parameter writeback",vOut%,14)
 5040 PROCcheck_i("FN square",FNsquare(9),81)
 5050 PROCcheck_i("recursive FN factorial",FNfact(6),720)
 5060 PROCcheck_s("FN reverse",FNreverse("AGON"),"NOGA")
 5070 ENDPROC

 6000 DEF PROCtest_data
 6010 LOCAL vA%,vB%,sA$,sB$
 6020 RESTORE 9500
 6030 READ vA%,vB%,sA$
 6040 PROCcheck_i("READ item 1",vA%,10)
 6050 PROCcheck_i("READ item 2",vB%,20)
 6060 PROCcheck_s("READ item 3",sA$,"THIRTY")
 6070 RESTORE 9510
 6080 READ sB$
 6090 PROCcheck_s("RESTORE to line",sB$,"ALPHA")
 6100 ENDPROC

 7000 DEF PROCtest_arrays
 7010 DIM aI%(2)
 7020 aI%()=1,2,3
 7030 PROCcheck_i("array element 0",aI%(0),1)
 7040 PROCcheck_i("array element 2",aI%(2),3)
 7050 PROCcheck_i("SUM integer array",SUM(aI%()),6)
 7060 DIM bI%(2)
 7070 bI%()=10
 7080 PROCcheck_i("single-value array init 0",bI%(0),10)
 7090 PROCcheck_i("single-value array init 2",bI%(2),10)
 7100 bI%()=bI%()+aI%()
 7110 PROCcheck_i("whole-array add 0",bI%(0),11)
 7120 PROCcheck_i("whole-array add 1",bI%(1),12)
 7130 PROCcheck_i("whole-array add 2",bI%(2),13)
 7140 DIM aR(2)
 7150 aR()=3,4,12
 7160 PROCcheck_r("array MOD function",MOD(aR()),13,1E-7)
 7170 DIM aS$(2)
 7180 aS$()="AG","ON","!"
 7190 PROCcheck_s("SUM string array",SUM(aS$()),"AGON!")
 7200 PROCcheck_i("SUMLEN string array",SUMLEN(aS$()),5)
 7210 ENDPROC

 8000 DEF PROCtest_memory
 8010 LOCAL vBase%,vP%,vR%,vS%
 8020 DIM mBlk% 31
 8030 vBase%=mBlk%
 8040 ?vBase%=&12
 8050 vBase%?1=&34
 8060 PROCcheck_i("? unary read",?vBase%,&12)
 8070 PROCcheck_i("? dyadic read",vBase%?1,&34)
 8080 vP%=vBase%+4
 8090 !vP%=&12345678
 8100 PROCcheck_i("! read back",!vP%,&12345678)
 8110 PROCcheck_i("! byte 0",vP%?0,&78)
 8120 PROCcheck_i("! byte 1",vP%?1,&56)
 8130 PROCcheck_i("! byte 2",vP%?2,&34)
 8140 PROCcheck_i("! byte 3",vP%?3,&12)
 8150 vR%=vBase%+12
 8160 |vR%=PI
 8170 PROCcheck_r("| read back",|vR%,PI,1E-7)
 8180 vS%=vBase%+20
 8190 $vS%="ABCDEF"
 8200 PROCcheck_s("$ read back",$vS%,"ABCDEF")
 8210 ENDPROC

 8300 DEF PROCtest_errors
 8310 LOCAL vErr%
 8320 PROCdivzero(vErr%)
 8330 PROCcheck_i("ON ERROR LOCAL catches div/0",vErr%,18)
 8340 ENDPROC

 9000 vMark%=11 : RETURN
 9010 vMark%=22 : RETURN
 9020 vMark%=33 : RETURN
 9030 vMark%=44 : RETURN

 9500 DATA 10,20,"THIRTY"
 9510 DATA "ALPHA","BETA","GAMMA"

 10000 DEF PROCdouble(vIn%,RETURN vOut%)
 10010 vOut%=vIn%*2
 10020 ENDPROC

 10100 DEF FNsquare(vN)=vN*vN

 10200 DEF FNfact(vN)
 10210 IF vN<2 THEN =1
 10220 =vN*FNfact(vN-1)

 10300 DEF FNreverse(sA$)
 10310 LOCAL sB$,vI%
 10320 FOR vI%=1 TO LEN(sA$)
 10330   sB$=MID$(sA$,vI%,1)+sB$
 10340 NEXT
 10350 =sB$

 10400 DEF PROCdivzero(RETURN vErr%)
 10410 LOCAL vX%
 10420 ON ERROR LOCAL vErr%=ERR : ENDPROC
 10430 vX%=1/0
 10440 vErr%=0
 10450 ENDPROC

 10800 DEF PROCtest_val
10801 LOCAL vR

10802 PROCcheck_i("VAL integer",VAL("123"),123)

10803 PROCcheck_i("VAL negative integer",VAL("-45"),-45)

10804 vR=VAL("12.5")
10805 PROCcheck_r("VAL real",vR,12.5,1E-6)

10806 vR=VAL("-3.75")
10807 PROCcheck_r("VAL negative real",vR,-3.75,1E-6)

10808 PROCcheck_i("VAL leading spaces",VAL("   42"),42)

10809 PROCcheck_i("VAL trailing spaces",VAL("99   "),99)

10810 PROCcheck_i("VAL STR$ roundtrip",VAL(STR$(456)),456)

10811 vR=VAL("1.25E2")
10812 PROCcheck_r("VAL exponent",vR,125,1E-5)

10813 PROCcheck_i("VAL zero",VAL("0"),0)

10814 ENDPROC
