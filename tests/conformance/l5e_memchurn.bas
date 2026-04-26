   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5E
   30 REM MEMORY CHURN / FRAGMENTATION STABILITY TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 DIM vFailName$(50)
   80 vFailIdx%=0
   90 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5E"
  100 PRINT "------------------------------------------"
  110 PROCsection("STRING CHURN")
  120 PROCtest_string_churn
  130 PROCsection("LOCAL ARRAY CHURN")
  140 PROCtest_local_array_churn
  150 PROCsection("MIXED ARRAY CHURN")
  160 PROCtest_mixed_array_churn
  170 PROCsection("NESTED LOCAL CHURN")
  180 PROCtest_nested_churn
  190 PROCsection("TEMPORARY EXPRESSION CHURN")
  200 PROCtest_temp_expr_churn
  210 PROCsection("POST-CHURN SANITY")
  220 PROCtest_post_sanity
  230 IF vFailIdx%>0 THEN PROCshow_failures
  240 PRINT
  250 PRINT "------------------------------------------"
  260 PRINT "TOTAL TESTS : ";vTest%
  270 PRINT "PASSED      : ";vPass%
  280 PRINT "FAILED      : ";vFail%
  290 PRINT "------------------------------------------"
  300 END

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
  630 IF vFailIdx%<50 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
  640 PRINT "FAIL ";sName$;" got=";vGot%;" expected=";vExp%
  650 ENDPROC

  700 DEF PROCbad_s(sName$,sGot$,sExp$)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 IF vFailIdx%<50 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
  740 PRINT "FAIL ";sName$
  750 PRINT "     got=""";sGot$;""""
  760 PRINT "expected=""";sExp$;""""
  770 ENDPROC

  800 DEF PROCcheck_i(sName$,vGot%,vExp%)
  810 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  820 ENDPROC

  900 DEF PROCcheck_s(sName$,sGot$,sExp$)
  910 IF sGot$=sExp$ THEN PROCok(sName$) ELSE PROCbad_s(sName$,sGot$,sExp$)
  920 ENDPROC

 1000 DEF PROCcheck_t(sName$,vFlag%)
 1010 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
 1020 ENDPROC

 1100 DEF PROCshow_failures
 1110 LOCAL vI%
 1120 PRINT
 1130 PRINT "FAILED TEST NAMES:"
 1140 PRINT "------------------"
 1150 FOR vI%=0 TO vFailIdx%-1
 1160   PRINT vFailName$(vI%)
 1170 NEXT
 1180 ENDPROC

 2000 DEF PROCtest_string_churn
 2010 LOCAL vI%,sA$,sB$,sC$,vGood%
 2020 vGood%=0
 2030 FOR vI%=1 TO 200
 2040   sA$=STRING$(64,"A")
 2050   sB$=STRING$(32,"B")
 2060   sC$=LEFT$(sA$+sB$+sA$,80)
 2070   MID$(sC$,10,3)="XYZ"
 2080   IF LEN(sC$)=80 AND MID$(sC$,10,3)="XYZ" THEN vGood%=vGood%+1
 2090 NEXT
 2100 PROCcheck_i("200 string churn cycles",vGood%,200)
 2110 ENDPROC

 3000 DEF PROCtest_local_array_churn
 3010 LOCAL vI%,vOut%,vGood%
 3020 vGood%=0
 3030 FOR vI%=1 TO 100
 3040   PROClocal_int_churn(vI%,vOut%)
 3050   IF vOut%=16*vI%+120 THEN vGood%=vGood%+1
 3060 NEXT
 3070 PROCcheck_i("100 local integer array churn cycles",vGood%,100)
 3080 vGood%=0
 3090 FOR vI%=1 TO 60
 3100   PROClocal_string_churn(vI%,vOut%)
 3110   IF vOut%=32 THEN vGood%=vGood%+1
 3120 NEXT
 3130 PROCcheck_i("60 local string array churn cycles",vGood%,60)
 3140 ENDPROC

 4000 DEF PROCtest_mixed_array_churn
 4010 LOCAL vI%,vOut%,vGood%,vBadSeed%,vBadGot%
 4020 vGood%=0 : vBadSeed%=0 : vBadGot%=0
 4030 FOR vI%=1 TO 50
 4040   PROCmixed_churn(vI%,vOut%)
 4050   IF vOut%=vI%+600 THEN
 4060     vGood%=vGood%+1
 4070   ELSE
 4080     IF vBadSeed%=0 THEN vBadSeed%=vI% : vBadGot%=vOut%
 4090   ENDIF
 4100 NEXT
 4110 PROCcheck_i("50 mixed array churn cycles",vGood%,50)
 4120 IF vGood%<>50 THEN PRINT "     first bad seed=";vBadSeed%;" got=";vBadGot%
 4130 ENDPROC


 5000 DEF PROCtest_nested_churn
 5010 LOCAL vI%,vOut%,vGood%
 5020 vGood%=0
 5030 FOR vI%=1 TO 75
 5040   PROCouter_churn(vI%,vOut%)
 5050   IF vOut%=vI%+333 THEN vGood%=vGood%+1
 5060 NEXT
 5070 PROCcheck_i("75 nested local churn cycles",vGood%,75)
 5080 ENDPROC

 6000 DEF PROCtest_temp_expr_churn
 6010 LOCAL vI%,vGood%,sA$,vN%
 6020 vGood%=0
 6030 FOR vI%=1 TO 150
 6040   sA$=FNmake_temp_string(vI%)
 6050   vN%=EVAL("("+STR$(vI%)+"+10)*2")
 6060   IF LEN(sA$)=20 AND vN%=vI%*2+20 THEN vGood%=vGood%+1
 6070 NEXT
 6080 PROCcheck_i("150 temp expr churn cycles",vGood%,150)
 6090 ENDPROC

 7000 DEF PROCtest_post_sanity
 7010 LOCAL vI%,vSum%,sA$
 7020 vSum%=0
 7030 FOR vI%=1 TO 100
 7040   vSum%=vSum%+vI%
 7050 NEXT
 7060 PROCcheck_i("FOR sanity after churn",vSum%,5050)
 7070 sA$="MEM"+"ORY"+" "+"OK"
 7080 PROCcheck_s("string sanity after churn",sA$,"MEMORY OK")
 7090 PROCcheck_i("FN sanity after churn",FNsum20,210)
 7100 PROCcheck_i("EVAL sanity after churn",EVAL("9*9+1"),82)
 7110 ENDPROC

 8000 DEF PROClocal_int_churn(vSeed%,RETURN vOut%)
 8010 LOCAL aI%(),vI%,vSum%
 8020 DIM aI%(15)
 8030 vSum%=0
 8040 FOR vI%=0 TO 15
 8050   aI%(vI%)=vSeed%+vI%
 8060   vSum%=vSum%+aI%(vI%)
 8070 NEXT
 8080 vOut%=vSum%
 8090 ENDPROC

 8100 DEF PROClocal_string_churn(vSeed%,RETURN vOut%)
 8110 LOCAL aS$(),vI%,sA$
 8120 DIM aS$(7)
 8130 sA$=""
 8140 FOR vI%=0 TO 7
 8150   aS$(vI%)=STRING$(4,CHR$(65+((vSeed%+vI%) MOD 26)))
 8160   sA$=sA$+aS$(vI%)
 8170 NEXT
 8180 vOut%=LEN(sA$)
 8190 ENDPROC

 8200 DEF PROCmixed_churn(vSeed%,RETURN vOut%)
 8210 LOCAL aI%(),aS$(),vChk%
 8220 DIM aI%(3)
 8230 DIM aS$(3)
 8240 aI%(0)=vSeed%
 8250 aI%(3)=100
 8260 aS$(0)="A"
 8270 aS$(3)="BC"
 8280 vChk%=500
 8290 IF aS$(0)+aS$(3)="ABC" THEN vOut%=aI%(0)+aI%(3)+vChk% ELSE vOut%=-1
 8300 ENDPROC

 8400 DEF PROCouter_churn(vSeed%,RETURN vOut%)
 8410 LOCAL aI%(),vTmp%
 8420 DIM aI%(7)
 8430 aI%(0)=vSeed%
 8440 aI%(7)=111
 8450 PROCinner_churn(vSeed%,vTmp%)
 8460 vOut%=aI%(0)+aI%(7)+vTmp%
 8470 ENDPROC

 8500 DEF PROCinner_churn(vSeed%,RETURN vOut%)
 8510 LOCAL aS$(),sA$
 8520 DIM aS$(3)
 8530 aS$(0)="X"
 8540 aS$(1)="Y"
 8550 aS$(2)="Z"
 8560 aS$(3)="!"
 8570 sA$=aS$(0)+aS$(1)+aS$(2)+aS$(3)
 8580 IF sA$="XYZ!" THEN vOut%=222 ELSE vOut%=-999
 8590 ENDPROC

 9000 DEF FNmake_temp_string(vSeed%)
 9010 LOCAL sA$,sB$,sC$
 9020 sA$=STRING$(10,"A")
 9030 sB$=STRING$(10,"B")
 9040 sC$=sA$+sB$
 9050 =sC$

 9100 DEF FNsum20
 9110 LOCAL vI%,vSum%
 9120 vSum%=0
 9130 FOR vI%=1 TO 20
 9140   vSum%=vSum%+vI%
 9150 NEXT
 9160 =vSum%
