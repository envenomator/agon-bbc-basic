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
  141 PROCtest_flow2
  142 PROCsection("FOR / NEXT STEP")
  160 PROCtest_step
  155 PROCsection("CASE / OF / WHEN / OTHERWISE")
  156 PROCtest_case
  157 PROCsection("LET keyword")
  158 PROCtest_let
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

 9025 DEF PROCtest_case
 9026 LOCAL vA%,vB%,vC%,sA$,sB$
 9027 vA%=2
 9030 vB%=0
 9040 CASE vA% OF
 9050 WHEN 1
 9060   vB%=10
 9070 WHEN 2
 9080   vB%=20
 9090 WHEN 3
 9100   vB%=30
 9110 OTHERWISE
 9120   vB%=99
 9130 ENDCASE
 9140 PROCcheck_i("CASE numeric match",vB%,20)

 9150 vA%=5
 9160 vB%=0
 9170 CASE vA% OF
 9180 WHEN 1,3,5
 9190   vB%=135
 9200 WHEN 2,4,6
 9210   vB%=246
 9220 OTHERWISE
 9230   vB%=999
 9240 ENDCASE
 9250 PROCcheck_i("CASE multiple WHEN values",vB%,135)

 9260 vA%=8
 9270 vB%=0
 9280 CASE vA% OF
 9290 WHEN 1
 9300   vB%=1
 9310 WHEN 2
 9320   vB%=2
 9330 OTHERWISE
 9340   vB%=88
 9350 ENDCASE
 9360 PROCcheck_i("CASE OTHERWISE",vB%,88)

 9370 sA$="B"
 9380 sB$=""
 9390 CASE sA$ OF
 9400 WHEN "A"
 9410   sB$="ALPHA"
 9420 WHEN "B","b"
 9430   sB$="BRAVO"
 9440 WHEN "C"
 9450   sB$="CHARLIE"
 9460 OTHERWISE
 9470   sB$="OTHER"
 9480 ENDCASE
 9490 PROCcheck_s("CASE string match",sB$,"BRAVO")

 9500 vA%=10
 9510 vB%=0
 9520 CASE TRUE OF
 9530 WHEN vA%<5
 9540   vB%=1
 9550 WHEN vA%=10
 9560   vB%=2
 9570 WHEN vA%>0
 9580   vB%=3
 9590 OTHERWISE
 9600   vB%=4
 9610 ENDCASE
 9620 PROCcheck_i("CASE TRUE conditional match",vB%,2)

 9630 vA%=7
 9640 vB%=0
 9650 CASE vA% OF
 9660 WHEN 7
 9670   vB%=vB%+1
 9680   vB%=vB%+2
 9690 WHEN 8
 9700   vB%=99
 9710 OTHERWISE
 9720   vB%=-1
 9730 ENDCASE
 9740 PROCcheck_i("CASE multi-line WHEN block",vB%,3)

 9750 vA%=1
 9760 vB%=0
 9770 CASE vA% OF
 9780 WHEN 1
 9790   vB%=11
 9800 WHEN 1
 9810   vB%=22
 9820 OTHERWISE
 9830   vB%=33
 9840 ENDCASE
 9850 PROCcheck_i("CASE first match wins",vB%,11)

 9860 vA%=2
 9870 vB%=0
 9880 vC%=0
 9890 CASE vA% OF
 9900 WHEN 1
 9910   vB%=1
 9920 WHEN 2
 9930   vB%=2
 9940   CASE vB% OF
 9950   WHEN 2
 9960     vC%=20
 9970   OTHERWISE
 9980     vC%=99
 9990   ENDCASE
10000 OTHERWISE
10010   vB%=9
10020 ENDCASE
10030 PROCcheck_i("nested CASE outer",vB%,2)
10040 PROCcheck_i("nested CASE inner",vC%,20)
10050 vA%=3
10060 vB%=0
10070 CASE vA%+2 OF
10080 WHEN 4
10090   vB%=40
10100 WHEN 5
10110   vB%=50
10120 OTHERWISE
10130   vB%=99
10140 ENDCASE
10150 PROCcheck_i("CASE OF expression",vB%,50)

10160 vA%=2
10170 vB%=0
10180 CASE FNdbl(vA%) OF
10190 WHEN 2
10200   vB%=20
10210 WHEN 4
10220   vB%=40
10230 OTHERWISE
10240   vB%=99
10250 ENDCASE
10260 PROCcheck_i("CASE OF FN expression",vB%,40)

10270 sA$="B"
10280 sB$=""
10290 CASE FNcase_string$(sA$) OF
10300 WHEN "A"
10310   sB$="ALPHA"
10320 WHEN "B"
10330   sB$="BRAVO"
10340 OTHERWISE
10350   sB$="OTHER"
10360 ENDCASE
10370 PROCcheck_s("CASE OF string FN expression",sB$,"BRAVO")

10380 vA%=1
10390 vB%=0
10400 CASE vA%=1 OF
10410 WHEN TRUE
10420   vB%=123
10430 WHEN FALSE
10440   vB%=456
10450 ENDCASE
10460 PROCcheck_i("CASE OF boolean expression",vB%,123)
10500 vA%=0
10501 GOTO 10504
10502 vA%=99
10503 GOTO 10505
10504 vA%=11
10505 PROCcheck_i("GOTO forward",vA%,11)

10506 vA%=0
10507 vB%=0
10508 vA%=vA%+1
10509 IF vA%<5 THEN GOTO 10508
10510 PROCcheck_i("GOTO backward loop",vA%,5)

10511 vA%=0
10512 IF TRUE THEN GOTO 10515
10513 vA%=99
10514 GOTO 10516
10515 vA%=22
10516 PROCcheck_i("IF THEN GOTO",vA%,22)

10517 vA%=0
10518 vB%=2
10519 ON vB% GOTO 10521,10523,10525
10520 vA%=99 : GOTO 10526
10521 vA%=1 : GOTO 10526
10522 REM unused
10523 vA%=2 : GOTO 10526
10524 REM unused
10525 vA%=3
10526 PROCcheck_i("ON GOTO",vA%,2)

10527 vA%=0
10528 vB%=9
10529 ON vB% GOTO 10531,10533 ELSE vA%=44
10530 GOTO 10534
10531 vA%=1 : GOTO 10534
10532 REM unused
10533 vA%=2
10534 PROCcheck_i("ON GOTO ELSE",vA%,44)

10535 vA%=0
10536 vI%=1
10537 IF vI%=3 THEN GOTO 10541
10538 vA%=vA%+vI%
10539 vI%=vI%+1
10540 GOTO 10537
10541 PROCcheck_i("manual GOTO loop exit",vA%,3)
10550 ENDPROC

 10600 DEF PROCerr_div(RETURN vErr%,RETURN vErl%,RETURN sRep$)
 10610 LOCAL vA%
 10620 ON ERROR LOCAL vErr%=ERR : vErl%=ERL : sRep$=REPORT$ : ENDPROC
 10630 vA%=1/0
 10640 vErr%=0 : vErl%=0 : sRep$=""
 10650 ENDPROC

10700 DEF PROCtest_let
10701 LOCAL vA%,vB%,sA$,aI%()

10702 LET vA%=10
10703 PROCcheck_i("LET integer assignment",vA%,10)

10704 LET vA%=vA%+5
10705 PROCcheck_i("LET integer expression",vA%,15)

10706 vB%=20
10707 LET vA%=vB%*2
10708 PROCcheck_i("LET variable expression",vA%,40)

10709 LET sA$="HELLO"
10710 PROCcheck_s("LET string assignment",sA$,"HELLO")

10711 LET sA$=sA$+" WORLD"
10712 PROCcheck_s("LET string concat",sA$,"HELLO WORLD")

10713 DIM aI%(5)
10714 LET aI%(3)=123
10715 PROCcheck_i("LET array assignment",aI%(3),123)

10716 LET aI%(3)=aI%(3)+7
10717 PROCcheck_i("LET array expression",aI%(3),130)

10718 LET vA%=FNdouble(9)
10719 PROCcheck_i("LET FN expression",vA%,18)

10720 ENDPROC

10900 DEF PROCtest_step
10901 LOCAL vI%,vSum%,vCnt%

10902 vSum%=0
10903 FOR vI%=1 TO 10 STEP 2
10904   vSum%=vSum%+vI%
10905 NEXT
10906 PROCcheck_i("STEP positive 2 sum",vSum%,25)

10907 vSum%=0
10908 FOR vI%=10 TO 1 STEP -2
10909   vSum%=vSum%+vI%
10910 NEXT
10911 PROCcheck_i("STEP negative 2 sum",vSum%,30)

10912 vCnt%=0
10913 FOR vI%=1 TO 1 STEP 5
10914   vCnt%=vCnt%+1
10915 NEXT
10916 PROCcheck_i("STEP single iteration",vCnt%,1)

10917 vCnt%=0
10918 FOR vI%=1 TO 10 STEP 20
10919   vCnt%=vCnt%+1
10920 NEXT
10921 PROCcheck_i("STEP overshoot positive",vCnt%,1)

10922 vCnt%=0
10923 FOR vI%=10 TO 1 STEP -20
10924   vCnt%=vCnt%+1
10925 NEXT
10926 PROCcheck_i("STEP overshoot negative",vCnt%,1)

10927 vCnt%=0
10928 FOR vI%=1 TO 10 STEP -1
10929   vCnt%=vCnt%+1
10930 NEXT
10931 PROCcheck_i("STEP wrong direction positive range",vCnt%,0)

10932 vCnt%=0
10933 FOR vI%=10 TO 1 STEP 1
10934   vCnt%=vCnt%+1
10935 NEXT
10936 PROCcheck_i("STEP wrong direction negative range",vCnt%,0)

10937 vSum%=0
10938 FOR vI%=2 TO 16 STEP 4
10939   vSum%=vSum%+vI%
10940 NEXT
10941 PROCcheck_i("STEP positive 4 sum",vSum%,40)

10942 vSum%=0
10943 FOR vI%=-5 TO 5 STEP 5
10944   vSum%=vSum%+vI%
10945 NEXT
10946 PROCcheck_i("STEP across zero",vSum%,0)

10947 ENDPROC

11000 DEF FNdbl(vN%)
11010 =vN%*2

11020 DEF FNcase_string$(sX$)
11030 =sX$

11040 DEF FNdouble(vN%)
11050 =vN%*2
