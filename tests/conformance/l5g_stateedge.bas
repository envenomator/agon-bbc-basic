   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5G
   30 REM INTERPRETER STATE / EDGE SEMANTICS TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 DIM vFailName$(50)
   80 vFailIdx%=0
   90 vMark%=0
  100 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5G"
  110 PRINT "------------------------------------------"
  120 PROCsection("DATA POINTER STATE")
  130 PROCtest_data_state
  140 PROCsection("ERROR INSIDE FN/PROC STATE")
  150 PROCtest_error_fn_proc
  160 PROCsection("GOSUB / RETURN STATE")
  170 PROCtest_gosub_state
  180 PROCsection("DIM / REDIM EDGE STATE")
  190 PROCtest_dim_state
  200 PROCsection("CONTROL-FLOW ERROR TRAPS")
  210 PROCtest_control_errors
  220 PROCsection("POST-EDGE SANITY")
  230 PROCtest_post_sanity
  240 IF vFailIdx%>0 THEN PROCshow_failures
  250 PRINT
  260 PRINT "------------------------------------------"
  270 PRINT "TOTAL TESTS : ";vTest%
  280 PRINT "PASSED      : ";vPass%
  290 PRINT "FAILED      : ";vFail%
  300 PRINT "------------------------------------------"
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

 2000 DEF PROCtest_data_state
 2010 LOCAL vA%,vB%,vC%,sA$,sB$
 2020 RESTORE 12000
 2030 READ vA%,vB%
 2040 PROCread_one(vC%)
 2050 READ sA$
 2060 PROCcheck_i("DATA pointer after PROC READ A",vA%,10)
 2070 PROCcheck_i("DATA pointer after PROC READ B",vB%,20)
 2080 PROCcheck_i("DATA pointer PROC item",vC%,30)
 2090 PROCcheck_s("DATA pointer after PROC READ string",sA$,"FORTY")
 2100 RESTORE 12100
 2110 PROCread_string(sB$)
 2120 READ vA%
 2130 PROCcheck_s("RESTORE before PROC string",sB$,"ALPHA")
 2140 PROCcheck_i("READ after PROC string",vA%,123)
 2150 ENDPROC

 3000 DEF PROCtest_error_fn_proc
 3010 LOCAL vA%,vB%,vErr%,vGood%
 3020 vA%=FNerror_inside_fn(7)
 3030 PROCcheck_i("FN recovers after trapped error",vA%,21)
 3040 PROCouter_error_state(5,vB%)
 3050 PROCcheck_i("PROC locals after nested error",vB%,55)
 3060 vGood%=0
 3070 PROCtrap_bad_eval(vErr%)
 3080 IF vErr%<>0 THEN vGood%=vGood%+1
 3090 PROCcheck_i("bad EVAL trapped before FN sanity",vGood%,1)
 3100 PROCcheck_i("FN works after trapped EVAL",FNplain(9),18)
 3110 ENDPROC

 4000 DEF PROCtest_gosub_state
 4010 LOCAL vI%,vSum%
 4020 vMark%=0
 4030 FOR vI%=1 TO 20
 4040   GOSUB 13000
 4050 NEXT
 4060 PROCcheck_i("20 GOSUB increments",vMark%,20)
 4070 vSum%=0
 4080 FOR vI%=1 TO 10
 4090   ON (vI% MOD 3)+1 GOSUB 13100,13200,13300
 4100   vSum%=vSum%+vMark%
 4110 NEXT
 4120 PROCcheck_i("ON GOSUB state sequence",vSum%,20)
 4130 ENDPROC

 5000 DEF PROCtest_dim_state
 5010 LOCAL vI%,vGood%
 5020 vGood%=0
 5030 FOR vI%=1 TO 30
 5040   PROCdim_once(vI%,vGood%)
 5050 NEXT
 5060 PROCcheck_i("repeated local DIM state",vGood%,30)
 5070 PROCdim_after_string(vGood%)
 5080 PROCcheck_i("DIM after string churn state",vGood%,31)
 5090 ENDPROC

 6000 DEF PROCtest_control_errors
 6010 LOCAL vErr%,vGood%
 6020 vGood%=0
 6030 PROCreturn_without_gosub(vErr%)
 6040 IF vErr%<>0 THEN vGood%=vGood%+1
 6050 PROCbad_on_gosub(vErr%)
 6060 IF vErr%<>0 THEN vGood%=vGood%+1
 6070 PROCcheck_i("control-flow misuse trapped",vGood%,2)
 6080 PROCcheck_i("runtime survives control errors",FNplain(6),12)
 6090 ENDPROC

 7000 DEF PROCtest_post_sanity
 7010 LOCAL vI%,vSum%,sA$
 7020 vSum%=0
 7030 FOR vI%=1 TO 100
 7040   vSum%=vSum%+vI%
 7050 NEXT
 7060 PROCcheck_i("FOR sanity after state edges",vSum%,5050)
 7070 sA$="STATE"+"-"+"OK"
 7080 PROCcheck_s("string sanity after state edges",sA$,"STATE-OK")
 7090 RESTORE 12200
 7100 READ vSum%
 7110 PROCcheck_i("DATA sanity after state edges",vSum%,777)
 7120 ENDPROC

 8000 DEF PROCread_one(RETURN vOut%)
 8010 READ vOut%
 8020 ENDPROC

 8100 DEF PROCread_string(RETURN sOut$)
 8110 READ sOut$
 8120 ENDPROC

 8200 DEF FNerror_inside_fn(vSeed%)
 8210 LOCAL vErr%,vA%
 8220 vA%=vSeed%*3
 8230 PROCtrap_div(vErr%)
 8240 IF vErr%=18 THEN =vA%
 8250 =-1

 8300 DEF PROCouter_error_state(vSeed%,RETURN vOut%)
 8310 LOCAL vA%,vB%,vErr%
 8320 vA%=vSeed%*10
 8330 PROCinner_error_state(vErr%)
 8340 vB%=vSeed%
 8350 IF vErr%=18 THEN vOut%=vA%+vB% ELSE vOut%=-1
 8360 ENDPROC

 8400 DEF PROCinner_error_state(RETURN vErr%)
 8410 PROCtrap_div(vErr%)
 8420 ENDPROC

 8500 DEF PROCtrap_div(RETURN vErr%)
 8510 LOCAL vX%
 8520 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8530 vX%=1/0
 8540 vErr%=0
 8550 ENDPROC

 8600 DEF PROCtrap_bad_eval(RETURN vErr%)
 8610 LOCAL vX%
 8620 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8630 vX%=EVAL("1+")
 8640 vErr%=0
 8650 ENDPROC

 8700 DEF FNplain(vN%)
 8710 =vN%*2

 8800 DEF PROCdim_once(vSeed%,RETURN vGood%)
 8810 LOCAL aI%(),aS$()
 8820 DIM aI%(5)
 8830 DIM aS$(2)
 8840 aI%(0)=vSeed%
 8850 aI%(5)=vSeed%+5
 8860 aS$(0)="A"
 8870 aS$(2)="C"
 8880 IF aI%(0)+aI%(5)=vSeed%*2+5 AND aS$(0)+aS$(2)="AC" THEN vGood%=vGood%+1
 8890 ENDPROC

 8900 DEF PROCdim_after_string(RETURN vGood%)
 8910 LOCAL sA$,aI%()
 8920 sA$=STRING$(100,"Z")
 8930 DIM aI%(10)
 8940 aI%(10)=10
 8950 IF LEN(sA$)=100 AND aI%(10)=10 THEN vGood%=vGood%+1
 8960 ENDPROC

 9000 DEF PROCreturn_without_gosub(RETURN vErr%)
 9010 ON ERROR LOCAL vErr%=ERR : ENDPROC
 9020 RETURN
 9030 vErr%=0
 9040 ENDPROC

 9100 DEF PROCbad_on_gosub(RETURN vErr%)
 9110 ON ERROR LOCAL vErr%=ERR : ENDPROC
 9120 ON 0 GOSUB 13000
 9130 vErr%=0
 9140 ENDPROC

12000 DATA 10,20,30,"FORTY"
12100 DATA "ALPHA",123
12200 DATA 777

13000 vMark%=vMark%+1 : RETURN
13100 vMark%=1 : RETURN
13200 vMark%=2 : RETURN
13300 vMark%=3 : RETURN
