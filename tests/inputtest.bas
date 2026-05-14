   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 INPUT KEYWORD TEST
   30 REM Tests GET / GET$ / INPUT / INPUT LINE
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V INPUT KEYWORD TEST"
   80 PRINT "------------------------------"
   90 PRINT
  100 PRINT "Follow the prompts exactly."
  110 PRINT

  120 PROCtest_get
  130 PROCtest_gets
  140 PROCtest_input
  150 PROCtest_inputline

  160 PRINT
  170 PRINT "------------------------------"
  180 PRINT "TOTAL TESTS : ";vTest%
  190 PRINT "PASSED      : ";vPass%
  200 PRINT "FAILED      : ";vFail%
  210 PRINT "------------------------------"
  220 END

  400 DEF PROCok(sName$)
  410 vTest%=vTest%+1
  420 vPass%=vPass%+1
  430 PRINT "PASS ";sName$
  440 ENDPROC

  500 DEF PROCbad_i(sName$,vGot%,vExp%)
  510 vTest%=vTest%+1
  520 vFail%=vFail%+1
  530 PRINT "FAIL ";sName$;" got=";vGot%;" expected=";vExp%
  540 ENDPROC

  600 DEF PROCbad_s(sName$,sGot$,sExp$)
  610 vTest%=vTest%+1
  620 vFail%=vFail%+1
  630 PRINT "FAIL ";sName$
  640 PRINT "     got=""";sGot$;""""
  650 PRINT "expected=""";sExp$;""""
  660 ENDPROC

  700 DEF PROCcheck_i(sName$,vGot%,vExp%)
  710 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  720 ENDPROC

  800 DEF PROCcheck_s(sName$,sGot$,sExp$)
  810 IF sGot$=sExp$ THEN PROCok(sName$) ELSE PROCbad_s(sName$,sGot$,sExp$)
  820 ENDPROC

 1000 DEF PROCtest_get
 1010 LOCAL vA%
 1020 PRINT
 1030 PRINT "GET test"
 1040 PRINT "Press uppercase A"
 1050 vA%=GET
 1060 PROCcheck_i("GET returns ASCII A",vA%,65)
 1070 ENDPROC

 2000 DEF PROCtest_gets
 2010 LOCAL sA$
 2020 PRINT
 2030 PRINT "GET$ test"
 2040 PRINT "Press uppercase B"
 2050 sA$=GET$
 2060 PROCcheck_s("GET$ returns B",sA$,"B")
 2070 ENDPROC

 3000 DEF PROCtest_input
 3010 LOCAL vA%,vB%,sA$
 3020 PRINT
 3030 PRINT "INPUT numeric test"
 3040 PRINT "When prompted, type: 123"
 3050 INPUT "Number ? " vA%
 3060 PROCcheck_i("INPUT integer",vA%,123)

 3070 PRINT
 3080 PRINT "INPUT string test"
 3090 PRINT "When prompted, type: HELLO"
 3100 INPUT "String ? " sA$
 3110 PROCcheck_s("INPUT string",sA$,"HELLO")

 3120 PRINT
 3130 PRINT "INPUT multiple values test"
 3140 PRINT "When prompted, type: 10,20"
 3150 INPUT "Two numbers ? " vA%,vB%
 3160 PROCcheck_i("INPUT first number",vA%,10)
 3170 PROCcheck_i("INPUT second number",vB%,20)
 3180 ENDPROC

 4000 DEF PROCtest_inputline
 4010 LOCAL sA$,sB$
 4020 PRINT
 4030 PRINT "INPUT LINE test"
 4040 PRINT "When prompted, type exactly: HELLO WORLD"
 4050 INPUT LINE "Line ? " sA$
 4060 PROCcheck_s("INPUT LINE preserves spaces",sA$,"HELLO WORLD")

 4070 PRINT
 4080 PRINT "When prompted, press RETURN on an empty line"
 4090 INPUT LINE "Empty line ? " sB$
 4100 PROCcheck_s("INPUT LINE empty line",sB$,"")
 4110 ENDPROC
