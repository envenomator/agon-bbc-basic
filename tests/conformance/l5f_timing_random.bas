   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5F
   30 REM TIME / RND / REPEATABILITY TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 DIM vFailName$(50)
   80 vFailIdx%=0
   90 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5F"
  100 PRINT "------------------------------------------"
  110 PROCsection("RND REPEATABILITY")
  120 PROCtest_rnd_repeat
  130 PROCsection("RND RANGE TESTS")
  140 PROCtest_rnd_range
  150 PROCsection("RND BASIC DISTRIBUTION")
  160 PROCtest_rnd_distribution
  170 PROCsection("TIME BASIC BEHAVIOUR")
  180 PROCtest_time_basic
  190 PROCsection("TIME WITH WORKLOAD")
  200 PROCtest_time_workload
  210 PROCsection("POST TIME/RND SANITY")
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

  700 DEF PROCbad_r(sName$,vGot,vExp)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 IF vFailIdx%<50 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
  740 PRINT "FAIL ";sName$;" got=";vGot;" expected=";vExp
  750 ENDPROC

  800 DEF PROCcheck_i(sName$,vGot%,vExp%)
  810 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  820 ENDPROC

  900 DEF PROCcheck_t(sName$,vFlag%)
  910 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
  920 ENDPROC

 1000 DEF PROCcheck_r(sName$,vGot,vExp,vTol)
 1010 IF ABS(vGot-vExp)<=vTol THEN PROCok(sName$) ELSE PROCbad_r(sName$,vGot,vExp)
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

 2000 DEF PROCtest_rnd_repeat
 2010 LOCAL vA%,vB%,vC%,vD%,vE%,vF%
 2020 vA%=RND(-12345)
 2030 vB%=RND(1000)
 2040 vC%=RND(1000)
 2050 vD%=RND(1000)
 2060 vA%=RND(-12345)
 2070 vE%=RND(1000)
 2080 vF%=RND(1000)
 2090 PROCcheck_i("RND repeat first",vE%,vB%)
 2100 PROCcheck_i("RND repeat second",vF%,vC%)
 2110 vA%=RND(-222)
 2120 vB%=RND(1)
 2130 vA%=RND(-222)
 2140 vC%=RND(1)
 2150 PROCcheck_i("RND(1) repeat",vC%,vB%)
 2160 ENDPROC

 3000 DEF PROCtest_rnd_range
 3010 LOCAL vI%,vN%,vGood%
 3020 vGood%=0
 3030 FOR vI%=1 TO 200
 3040   vN%=RND(10)
 3050   IF vN%>=1 AND vN%<=10 THEN vGood%=vGood%+1
 3060 NEXT
 3070 PROCcheck_i("RND(10) range 1..10",vGood%,200)
 3080 vGood%=0
 3090 FOR vI%=1 TO 200
 3100   vN%=RND(100)
 3110   IF vN%>=1 AND vN%<=100 THEN vGood%=vGood%+1
 3120 NEXT
 3130 PROCcheck_i("RND(100) range 1..100",vGood%,200)
 3140 ENDPROC

 4000 DEF PROCtest_rnd_distribution
 4010 LOCAL vI%,vN%,vLow%,vHigh%,vSeen1%,vSeen10%
 4020 vLow%=0 : vHigh%=0 : vSeen1%=0 : vSeen10%=0
 4030 vN%=RND(-9876)
 4040 FOR vI%=1 TO 500
 4050   vN%=RND(10)
 4060   IF vN%<=5 THEN vLow%=vLow%+1 ELSE vHigh%=vHigh%+1
 4070   IF vN%=1 THEN vSeen1%=1
 4080   IF vN%=10 THEN vSeen10%=1
 4090 NEXT
 4100 PROCcheck_t("RND distribution low nonzero",vLow%>0)
 4110 PROCcheck_t("RND distribution high nonzero",vHigh%>0)
 4120 PROCcheck_t("RND distribution sees 1",vSeen1%)
 4130 PROCcheck_t("RND distribution sees 10",vSeen10%)
 4140 ENDPROC

 5000 DEF PROCtest_time_basic
 5010 LOCAL vT1%,vT2%,vI%,vWait%
 5020 vT1%=TIME
 5030 vT2%=TIME
 5040 PROCcheck_t("TIME nondecreasing immediate",vT2%>=vT1%)
 5050 vWait%=0
 5060 vT1%=TIME
 5070 REPEAT
 5080   vT2%=TIME
 5090   vWait%=vWait%+1
 5100 UNTIL vT2%<>vT1% OR vWait%>20000
 5110 PROCcheck_t("TIME eventually changes",vT2%<>vT1%)
 5120 PROCcheck_t("TIME changed forward",vT2%>vT1%)
 5130 ENDPROC

 6000 DEF PROCtest_time_workload
 6010 LOCAL vT1%,vT2%,vI%,vSum%
 6020 vT1%=TIME
 6030 vSum%=0
 6040 FOR vI%=1 TO 5000
 6050   vSum%=vSum%+(vI% MOD 7)
 6060 NEXT
 6070 vT2%=TIME
 6080 PROCcheck_i("workload sum sanity",vSum%,14997)
 6090 PROCcheck_t("TIME nondecreasing after workload",vT2%>=vT1%)
 6100 ENDPROC

 7000 DEF PROCtest_post_sanity
 7010 LOCAL vI%,vSum%
 7020 vSum%=0
 7030 FOR vI%=1 TO 100
 7040   vSum%=vSum%+vI%
 7050 NEXT
 7060 PROCcheck_i("FOR sanity after TIME/RND",vSum%,5050)
 7070 PROCcheck_i("EVAL sanity after TIME/RND",EVAL("12*12"),144)
 7080 PROCcheck_i("FN sanity after TIME/RND",FNsum5,15)
 7090 ENDPROC

 8000 DEF FNsum5
 8010 =1+2+3+4+5
