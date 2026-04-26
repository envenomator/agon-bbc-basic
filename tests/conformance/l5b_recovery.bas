   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5B
   30 REM ERROR RECOVERY / RUNTIME STATE STABILITY TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5B"
   80 PRINT "------------------------------------------"
   90 PROCsection("REPEATED ERROR RECOVERY")
  100 PROCtest_repeated
  110 PROCsection("ERRORS INSIDE LOOPS")
  120 PROCtest_loop_errors
  130 PROCsection("ERRORS WITH LOCAL VARIABLES")
  140 PROCtest_local_errors
  150 PROCsection("ERRORS WITH LOCAL ARRAYS")
  160 PROCtest_local_array_errors
  170 PROCsection("ERRORS WITH FILES OPEN")
  180 PROCtest_file_errors
  190 PROCsection("POST-ERROR RUNTIME SANITY")
  200 PROCtest_post_sanity
  210 PRINT
  220 PRINT "------------------------------------------"
  230 PRINT "TOTAL TESTS : ";vTest%
  240 PRINT "PASSED      : ";vPass%
  250 PRINT "FAILED      : ";vFail%
  260 PRINT "------------------------------------------"
  270 END

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

  700 DEF PROCbad_s(sName$,sGot$,sExp$)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 PRINT "FAIL ";sName$
  740 PRINT "     got=""";sGot$;""""
  750 PRINT "expected=""";sExp$;""""
  760 ENDPROC

  800 DEF PROCcheck_i(sName$,vGot%,vExp%)
  810 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  820 ENDPROC

  900 DEF PROCcheck_s(sName$,sGot$,sExp$)
  910 IF sGot$=sExp$ THEN PROCok(sName$) ELSE PROCbad_s(sName$,sGot$,sExp$)
  920 ENDPROC

 1000 DEF PROCcheck_t(sName$,vFlag%)
 1010 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
 1020 ENDPROC

 2000 DEF PROCtest_repeated
 2010 LOCAL vI%,vErr%,vGood%
 2020 vGood%=0
 2030 FOR vI%=1 TO 100
 2040   PROCtrap_div(vErr%)
 2050   IF vErr%=18 THEN vGood%=vGood%+1
 2060 NEXT
 2070 PROCcheck_i("100 repeated divide-by-zero traps",vGood%,100)
 2080 vGood%=0
 2090 FOR vI%=1 TO 100
 2100   PROCtrap_bad_eval(vErr%)
 2110   IF vErr%<>0 THEN vGood%=vGood%+1
 2120 NEXT
 2130 PROCcheck_i("100 repeated bad EVAL traps",vGood%,100)
 2140 ENDPROC

 3000 DEF PROCtest_loop_errors
 3010 LOCAL vI%,vErr%,vSum%,vGood%
 3020 vSum%=0 : vGood%=0
 3030 FOR vI%=1 TO 20
 3040   PROCtrap_div(vErr%)
 3050   IF vErr%=18 THEN vGood%=vGood%+1
 3060   vSum%=vSum%+vI%
 3070 NEXT
 3080 PROCcheck_i("FOR loop continues after trapped errors",vSum%,210)
 3090 PROCcheck_i("FOR loop trapped error count",vGood%,20)
 3100 vI%=0 : vSum%=0 : vGood%=0
 3110 REPEAT
 3120   vI%=vI%+1
 3130   PROCtrap_div(vErr%)
 3140   IF vErr%=18 THEN vGood%=vGood%+1
 3150   vSum%=vSum%+vI%
 3160 UNTIL vI%=20
 3170 PROCcheck_i("REPEAT loop continues after errors",vSum%,210)
 3180 PROCcheck_i("REPEAT loop trapped error count",vGood%,20)
 3190 vI%=0 : vSum%=0 : vGood%=0
 3200 WHILE vI%<20
 3210   vI%=vI%+1
 3220   PROCtrap_div(vErr%)
 3230   IF vErr%=18 THEN vGood%=vGood%+1
 3240   vSum%=vSum%+vI%
 3250 ENDWHILE
 3260 PROCcheck_i("WHILE loop continues after errors",vSum%,210)
 3270 PROCcheck_i("WHILE loop trapped error count",vGood%,20)
 3280 ENDPROC

 4000 DEF PROCtest_local_errors
 4010 LOCAL vI%,vOut%,vGood%
 4020 vGood%=0
 4030 FOR vI%=1 TO 50
 4040   PROClocal_error(vI%,vOut%)
 4050   IF vOut%=vI%*3 THEN vGood%=vGood%+1
 4060 NEXT
 4070 PROCcheck_i("LOCAL scalars restored after errors",vGood%,50)
 4080 ENDPROC

 5000 DEF PROCtest_local_array_errors
 5010 LOCAL vI%,vOut%,vExp%,vGood%,vBadSeed%,vBadGot%,vBadExp%
 5020 vGood%=0 : vBadSeed%=0
 5030 FOR vI%=1 TO 30
 5040   PROClocal_array_error(vI%,vOut%)
 5050   vExp%=16*vI%+120
 5060   IF vOut%=vExp% THEN
 5070     vGood%=vGood%+1
 5080   ELSE
 5090     IF vBadSeed%=0 THEN vBadSeed%=vI% : vBadGot%=vOut% : vBadExp%=vExp%
 5100   ENDIF
 5110 NEXT
 5120 PROCcheck_i("LOCAL arrays survive trapped errors",vGood%,30)
 5130 IF vGood%<>30 THEN PRINT "     first bad seed=";vBadSeed%;" got=";vBadGot%;" expected=";vBadExp%
 5140 ENDPROC

 6000 DEF PROCtest_file_errors
 6010 LOCAL vCh%,vErr%,vB%
 6020 vCh%=OPENOUT("L5BFILE.DAT")
 6030 PROCcheck_t("OPENOUT before trapped error",vCh%<>0)
 6040 BPUT#vCh%,11
 6050 BPUT#vCh%,22
 6060 PROCtrap_div(vErr%)
 6070 BPUT#vCh%,33
 6080 CLOSE#vCh%
 6090 vCh%=OPENIN("L5BFILE.DAT")
 6100 PROCcheck_t("OPENIN after trapped error",vCh%<>0)
 6110 vB%=BGET#vCh%
 6120 PROCcheck_i("file byte before error",vB%,11)
 6130 vB%=BGET#vCh%
 6140 PROCcheck_i("file byte before error 2",vB%,22)
 6150 vB%=BGET#vCh%
 6160 PROCcheck_i("file byte after error",vB%,33)
 6170 PROCcheck_t("EOF after file error test",EOF#vCh%)
 6180 CLOSE#vCh%
 6190 ENDPROC

 7000 DEF PROCtest_post_sanity
 7010 LOCAL vErr%,vI%,vSum%,sA$
 7020 FOR vI%=1 TO 20
 7030   PROCtrap_div(vErr%)
 7040 NEXT
 7050 vSum%=0
 7060 FOR vI%=1 TO 100
 7070   vSum%=vSum%+vI%
 7080 NEXT
 7090 PROCcheck_i("FOR sanity after many errors",vSum%,5050)
 7100 sA$=""
 7110 FOR vI%=1 TO 10
 7120   sA$=sA$+"OK"
 7130 NEXT
 7140 PROCcheck_s("string sanity after errors",sA$,"OKOKOKOKOKOKOKOKOKOK")
 7150 PROCcheck_i("FN sanity after errors",FNsum10,55)
 7160 ENDPROC

 8000 DEF PROCtrap_div(RETURN vErr%)
 8010 LOCAL vX%
 8020 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8030 vX%=1/0
 8040 vErr%=0
 8050 ENDPROC

 8100 DEF PROCtrap_bad_eval(RETURN vErr%)
 8110 LOCAL vX%
 8120 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8130 vX%=EVAL("1+")
 8140 vErr%=0
 8150 ENDPROC

 8200 DEF PROClocal_error(vSeed%,RETURN vOut%)
 8210 LOCAL vA%,vB%,vErr%
 8220 vA%=vSeed%
 8230 vB%=vSeed%*2
 8240 PROCtrap_div(vErr%)
 8250 IF vErr%=18 THEN vOut%=vA%+vB% ELSE vOut%=-1
 8260 ENDPROC

 8300 DEF PROClocal_array_error(vSeed%,RETURN vOut%)
 8310 LOCAL aI%(),vI%,vErr%,vSum%
 8320 DIM aI%(15)
 8330 FOR vI%=0 TO 15
 8340   aI%(vI%)=vSeed%+vI%
 8350 NEXT
 8360 PROCtrap_div(vErr%)
 8370 IF vErr%<>18 THEN vOut%=-1000-vErr% : ENDPROC
 8380 vSum%=0
 8390 FOR vI%=0 TO 15
 8400   vSum%=vSum%+aI%(vI%)
 8410 NEXT
 8420 vOut%=vSum%
 8430 ENDPROC

 8500 DEF FNsum10
 8510 LOCAL vI%,vSum%
 8520 vSum%=0
 8530 FOR vI%=1 TO 10
 8540   vSum%=vSum%+vI%
 8550 NEXT
 8560 =vSum%
