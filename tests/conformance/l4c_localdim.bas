   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 4C
   30 REM LOCAL VARIABLES / LOCAL ARRAYS / DIM REGRESSION TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 ON ERROR PRINT "FATAL ERROR at line ";ERL;" : ";REPORT$ : END
   80 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 4C"
   90 PRINT "------------------------------------------"
  100 PROCsection("BASIC LOCAL ARRAY DIM")
  110 PROCtest_basic_localdim
  120 PROCsection("MULTIPLE LOCAL ARRAYS")
  130 PROCtest_many_localdim
  140 PROCsection("REPEATED LOCAL ARRAY ALLOCATION")
  150 PROCtest_repeat_localdim
  160 PROCsection("NESTED LOCAL ARRAYS")
  170 PROCtest_nested_localdim
  180 PROCsection("LOCAL ARRAYS INSIDE FUNCTIONS")
  190 PROCtest_fn_localdim
  200 PROCsection("GLOBAL DIM AFTER LOCAL ARRAYS")
  210 PROCtest_after_localdim
  220 PRINT
  230 PRINT "------------------------------------------"
  240 PRINT "TOTAL TESTS : ";vTest%
  250 PRINT "PASSED      : ";vPass%
  260 PRINT "FAILED      : ";vFail%
  270 PRINT "------------------------------------------"
  280 END

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
  630 PRINT "FAIL ";sName$;" got=";vGot%;" expected=";vExp%
  640 ENDPROC

  700 DEF PROCbad_r(sName$,vGot,vExp)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 PRINT "FAIL ";sName$;" got=";vGot;" expected=";vExp
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

 2000 DEF PROCtest_basic_localdim
 2010 LOCAL aR(),aI%()
 2020 DIM aR(9)
 2030 DIM aI%(9)
 2040 aR(0)=1.25 : aR(9)=9.75
 2050 aI%(0)=123 : aI%(9)=456
 2060 PROCcheck_r("local real array first",aR(0),1.25,1E-9)
 2070 PROCcheck_r("local real array last",aR(9),9.75,1E-9)
 2080 PROCcheck_i("local integer array first",aI%(0),123)
 2090 PROCcheck_i("local integer array last",aI%(9),456)
 2100 ENDPROC

 3000 DEF PROCtest_many_localdim
 3010 LOCAL aR(),bR(),cI%(),dI%()
 3020 DIM aR(3)
 3030 DIM bR(4)
 3040 DIM cI%(5)
 3050 DIM dI%(6)
 3060 aR(3)=33.25
 3070 bR(4)=44.5
 3080 cI%(5)=55
 3090 dI%(6)=66
 3100 PROCcheck_r("many locals real a",aR(3),33.25,1E-9)
 3110 PROCcheck_r("many locals real b",bR(4),44.5,1E-9)
 3120 PROCcheck_i("many locals integer c",cI%(5),55)
 3130 PROCcheck_i("many locals integer d",dI%(6),66)
 3140 ENDPROC

 4000 DEF PROCtest_repeat_localdim
 4010 LOCAL vI%,vGood%
 4020 vGood%=0
 4030 FOR vI%=1 TO 200
 4040   IF FNbasic_localdim_ok THEN vGood%=vGood%+1
 4050 NEXT
 4060 PROCcheck_i("200 repeated local DIM calls",vGood%,200)
 4070 ENDPROC

 5000 DEF PROCtest_nested_localdim
 5010 LOCAL vOut%
 5020 PROCnested_outer(20,vOut%)
 5030 PROCcheck_i("nested local arrays preserved",vOut%,1)
 5040 ENDPROC

 6000 DEF PROCtest_fn_localdim
 6010 PROCcheck_i("FN local integer array sum",FNlocal_int_sum(10),165)
 6020 PROCcheck_r("FN local real array value",FNlocal_real_value(12),12.5,1E-9)
 6030 PROCcheck_s("FN local string array value",FNlocal_string_value,"LOCAL-OK")
 6040 ENDPROC

 7000 DEF PROCtest_after_localdim
 7010 DIM gR(20)
 7020 DIM gI%(20)
 7030 gR(20)=123.5
 7040 gI%(20)=321
 7050 PROCcheck_r("global real DIM after locals",gR(20),123.5,1E-9)
 7060 PROCcheck_i("global integer DIM after locals",gI%(20),321)
 7070 ENDPROC

 8000 DEF FNbasic_localdim_ok
 8010 LOCAL aR(),aI%()
 8020 DIM aR(9)
 8030 DIM aI%(9)
 8040 aR(0)=1.25 : aR(9)=9.75
 8050 aI%(0)=123 : aI%(9)=456
 8060 IF aR(0)<>1.25 THEN =FALSE
 8070 IF aR(9)<>9.75 THEN =FALSE
 8080 IF aI%(0)<>123 THEN =FALSE
 8090 IF aI%(9)<>456 THEN =FALSE
 8100 =TRUE

 8200 DEF PROCnested_outer(vN%,RETURN vOut%)
 8210 LOCAL oR(),oI%()
 8220 DIM oR(vN%)
 8230 DIM oI%(vN%)
 8240 oR(vN%)=vN%+0.5
 8250 oI%(vN%)=vN%
 8260 PROCnested_inner(vN%)
 8270 IF oR(vN%)=vN%+0.5 AND oI%(vN%)=vN% THEN vOut%=1 ELSE vOut%=0
 8280 ENDPROC

 8300 DEF PROCnested_inner(vN%)
 8310 LOCAL iR(),iI%()
 8320 DIM iR(vN%)
 8330 DIM iI%(vN%)
 8340 iR(vN%)=vN%+1.5
 8350 iI%(vN%)=vN%+1
 8360 IF iR(vN%)<>vN%+1.5 THEN ERROR 105,"inner real array corrupt"
 8370 IF iI%(vN%)<>vN%+1 THEN ERROR 106,"inner integer array corrupt"
 8380 ENDPROC

 8400 DEF FNlocal_int_sum(vN%)
 8410 LOCAL aI%(),vI%,vSum%
 8420 DIM aI%(vN%)
 8430 vSum%=0
 8440 FOR vI%=0 TO vN%
 8450   aI%(vI%)=vI%*3
 8460   vSum%=vSum%+aI%(vI%)
 8470 NEXT
 8480 =vSum%

 8500 DEF FNlocal_real_value(vN%)
 8510 LOCAL aR()
 8520 DIM aR(vN%)
 8530 aR(vN%)=vN%+0.5
 8540 =aR(vN%)

 8600 DEF FNlocal_string_value
 8610 LOCAL aS$()
 8620 DIM aS$(2)
 8630 aS$(0)="LOCAL"
 8640 aS$(1)="-"
 8650 aS$(2)="OK"
 8660 =aS$(0)+aS$(1)+aS$(2)
