   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 LANGUAGE TEST HARNESS - LEVEL 2
   30 REM EDGE CASES / CORNER CASES / STRESS SEMANTICS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 vMark%=0
   80 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 2"
   90 PRINT "----------------------------------------"
  100 PROCsection("NUMERIC EDGE CASES")
  110 PROCtest_num2
  120 PROCsection("STRING EDGE CASES")
  130 PROCtest_str2
  140 PROCsection("FLOW / TOKENISER EDGE CASES")
  150 PROCtest_flow2
  160 PROCsection("ARRAY EDGE CASES")
  170 PROCtest_arr2
  180 PROCsection("ERROR REPORTING EDGE CASES")
  190 PROCtest_err2
  200 PRINT
  210 PRINT "----------------------------------------"
  220 PRINT "TOTAL TESTS : ";vTest%
  230 PRINT "PASSED      : ";vPass%
  240 PRINT "FAILED      : ";vFail%
  250 PRINT "----------------------------------------"
  260 END

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

 2000 DEF PROCtest_num2
 2010 LOCAL vA,vB,vI%,vJ%,vK%
 2020 PROCcheck_r("0.1+0.2 approx",0.1+0.2,0.3,1E-6)
 2030 PROCcheck_r("1E-30 * 1E30",1E-30*1E30,1,1E-6)
 2040 PROCcheck_r("1E20 / 1E10",1E20/1E10,1E10,1E4)
 2050 PROCcheck_i("INT near integer low",INT(1.9999999),1)
 2060 PROCcheck_i("INT near integer neg",INT(-1.0000001),-2)
 2070 PROCcheck_i("round trip integer",VAL(STR$(12345)),12345)
 2080 vI%=5
 2090 vI%+=3
 2100 PROCcheck_i("compound += integer",vI%,8)
 2110 vI%*=2
 2120 PROCcheck_i("compound *= integer",vI%,16)
 2130 vI% DIV= 3
 2140 PROCcheck_i("compound DIV=",vI%,5)
 2150 vI% MOD= 3
 2160 PROCcheck_i("compound MOD=",vI%,2)
 2170 vI%=6
 2180 vI% AND= 3
 2190 PROCcheck_i("compound AND=",vI%,2)
 2200 vI%=6
 2210 vI% OR= 1
 2220 PROCcheck_i("compound OR=",vI%,7)
 2230 vI%=6
 2240 vI% EOR= 3
 2250 PROCcheck_i("compound EOR=",vI%,5)
 2260 PROCcheck_i("shift right positive",8>>1,4)
 2270 PROCcheck_t("comparison chaining",(3<4) AND (4<5))
 2280 ENDPROC

 3000 DEF PROCtest_str2
 3010 LOCAL sA$,sB$,sC$
 3020 sA$=""
 3030 PROCcheck_i("LEN empty",LEN(sA$),0)
 3040 PROCcheck_s("concat empty left",sA$+"ABC","ABC")
 3050 PROCcheck_s("concat empty right","ABC"+sA$,"ABC")
 3060 PROCcheck_i("INSTR empty needle",INSTR("ABC",""),0):REM Russell variant
 3070 PROCcheck_i("INSTR empty haystack",INSTR("","A"),0)
 3080 sA$="ABCDE"
 3090 MID$(sA$,2,2)="XY"
 3100 PROCcheck_s("MID$ replace middle",sA$,"AXYDE")
 3110 sA$="ABCDE"
 3120 LEFT$(sA$,5)="XYZ"
 3130 PROCcheck_s("LEFT$ short assign",sA$,"XYZDE")
 3140 sA$="ABCDE"
 3150 MID$(sA$,3)="Z"
 3160 PROCcheck_s("MID$ tail assign",sA$,"ABZDE")
 3170 sB$=STRING$(20,"Q")
 3180 PROCcheck_i("STRING$ length",LEN(sB$),20)
 3190 PROCcheck_s("STRING$ content",LEFT$(sB$,4),"QQQQ")
 3200 sC$="A"+CHR$(0)+"B"
 3210 PROCcheck_i("ASC first byte",ASC(sC$),65)
 3220 ENDPROC


 4000 DEF PROCtest_flow2
 4010 LOCAL vI%,vJ%,vSum%,vCnt%,vX%,vY%,vNox%,vIf1%
 4020 REM keyword adjacency tests
 4030 vNox%=123
 4040 PROCcheck_i("variable near keyword ON",vNox%,123)
 4050 vIf1%=77
 4060 PROCcheck_i("variable near keyword IF",vIf1%,77)
 4070 REM compact-spacing tests
 4080 vX%=0
 4090 IF 1=1 THENvX%=5
 4100 PROCcheck_i("IF THEN minimal spaces",vX%,5)
 4110 vSum%=0
 4120 FOR vI%=1TO5
 4130 vSum%=vSum%+vI%
 4140 NEXT
 4150 PROCcheck_i("FOR compact spacing",vSum%,15)
 4160 vCnt%=0
 4170 REPEAT
 4180 vCnt%=vCnt%+1
 4190 UNTIL vCnt%=3
 4200 PROCcheck_i("UNTIL compact spacing",vCnt%,3)
 4210 vY%=0
 4220 vMark%=0
 4230 ON 9 GOSUB 9000,9010 ELSE vMark%=44
 4240 PROCcheck_i("ON...ELSE out of range",vMark%,44)
 4240 vSum%=0
 4250 FOR vI%=1 TO 3
 4260   FOR vJ%=1 TO 3
 4270     IF vJ%=2 THEN EXIT FOR
 4280     vSum%=vSum%+10*vI%+vJ%
 4290   NEXT
 4300 NEXT
 4310 PROCcheck_i("nested EXIT FOR inner only",vSum%,63)
 4320 ENDPROC

 5000 DEF PROCtest_arr2
 5010 DIM aI%(4)
 5020 DIM bI%(4)
 5030 DIM aR(2)
 5040 DIM aS$(3)
 5050 aI%()=1,2,3
 5060 PROCcheck_i("partial init keep old last",aI%(3),0)
 5070 PROCcheck_i("partial init keep old last2",aI%(4),0)
 5080 bI%()=9
 5090 PROCcheck_i("single init all 0",bI%(0),9)
 5100 PROCcheck_i("single init all 4",bI%(4),9)
 5110 bI%()+=1
 5120 PROCcheck_i("array += elem0",bI%(0),10)
 5130 PROCcheck_i("array += elem4",bI%(4),10)
 5140 aI%()=1,2,3,4,5
 5150 bI%()=5,4,3,2,1
 5160 aI%()=aI%()+bI%()
 5170 PROCcheck_i("array+array elem0",aI%(0),6)
 5180 PROCcheck_i("array+array elem4",aI%(4),6)
 5190 aR()=3,4,12
 5200 PROCcheck_r("MOD array rms vector",MOD(aR()),13,1E-6)
 5210 aS$()="A","BB","CCC","DDDD"
 5220 PROCcheck_s("SUM string array",SUM(aS$()),"ABBCCCDDDD")
 5230 PROCcheck_i("SUMLEN string array",SUMLEN(aS$()),10)
 5240 ENDPROC

 6000 DEF PROCtest_err2
 6010 LOCAL vErr%,vErl%,sRep$
 6020 PROCerr_div(vErr%,vErl%,sRep$)
 6030 PROCcheck_i("ERR div zero",vErr%,18)
 6040 PROCcheck_i("ERL div zero",vErl%,10630)
 6050 PROCcheck_t("REPORT$ non-empty",LEN(sRep$)<>0)
 6060 ENDPROC

 9000 vMark%=11 : RETURN
 9010 vMark%=22 : RETURN
 9020 vMark%=44 : RETURN

 10600 DEF PROCerr_div(RETURN vErr%,RETURN vErl%,RETURN sRep$)
 10610 LOCAL vA%
 10620 ON ERROR LOCAL vErr%=ERR : vErl%=ERL : sRep$=REPORT$ : ENDPROC
 10630 vA%=1/0
 10640 vErr%=0 : vErl%=0 : sRep$=""
 10650 ENDPROC

