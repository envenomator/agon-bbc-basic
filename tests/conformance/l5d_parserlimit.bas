   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5D
   30 REM PARSER LIMIT / EXPRESSION BOUNDARY TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 DIM vFailName$(50)
   80 vFailIdx%=0
   90 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5D"
  100 PRINT "------------------------------------------"
  110 PROCsection("NESTED PARENTHESES")
  120 PROCtest_parens
  130 PROCsection("LONG FLAT EXPRESSIONS")
  140 PROCtest_flat_expr
  150 PROCsection("STRING PARSER EXPRESSIONS")
  160 PROCtest_string_expr
  170 PROCsection("NESTED FUNCTION EXPRESSIONS")
  180 PROCtest_fn_expr
  190 PROCsection("MANY STATEMENTS ON ONE LINE")
  200 PROCtest_many_statements
  210 PROCsection("PARSER ERROR RECOVERY")
  220 PROCtest_parser_recovery
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

 2000 DEF PROCtest_parens
 2010 LOCAL sE$,vI%
 2020 sE$="1"
 2030 FOR vI%=1 TO 16
 2040   sE$="("+sE$+")"
 2050 NEXT
 2060 PROCcheck_i("EVAL 16 nested parentheses",EVAL(sE$),1)
 2070 sE$="1+2"
 2080 FOR vI%=1 TO 12
 2090   sE$="("+sE$+")*1"
 2100 NEXT
 2110 PROCcheck_i("EVAL nested parens with ops",EVAL(sE$),3)
 2120 PROCcheck_i("direct nested parentheses",((((((((1+2)))))))),3)
 2130 ENDPROC

 3000 DEF PROCtest_flat_expr
 3010 LOCAL sE$,vI%,vGot%
 3020 sE$="0"
 3030 FOR vI%=1 TO 64
 3040   sE$=sE$+"+1"
 3050 NEXT
 3060 PROCcheck_i("EVAL 64-term addition",EVAL(sE$),64)
 3070 sE$="1"
 3080 FOR vI%=1 TO 16
 3090   sE$=sE$+"*2"
 3100 NEXT
 3110 PROCcheck_i("EVAL 16 chained multiply",EVAL(sE$),65536)
 3120 sE$="1000"
 3130 FOR vI%=1 TO 20
 3140   sE$=sE$+"-1"
 3150 NEXT
 3160 PROCcheck_i("EVAL 20 chained subtract",EVAL(sE$),980)
 3170 ENDPROC

 4000 DEF PROCtest_string_expr
 4010 LOCAL sE$,sA$,vI%
 4020 sE$="""A"""
 4030 FOR vI%=1 TO 20
 4040   sE$=sE$+"+""B"""
 4050 NEXT
 4060 PROCcheck_i("EVAL string concat length",LEN(EVAL(sE$)),21)
 4070 PROCcheck_s("EVAL string concat prefix",LEFT$(EVAL(sE$),5),"ABBBB")
 4080 sA$="BBC BASIC"
 4090 PROCcheck_s("EVAL nested string functions",EVAL("LEFT$(MID$(sA$,5),5)"),"BASIC")
 4100 PROCcheck_i("EVAL string LEN expression",EVAL("LEN(LEFT$(sA$,3)+RIGHT$(sA$,5))"),8)
 4110 ENDPROC

 5000 DEF PROCtest_fn_expr
 5010 LOCAL sE$,vI%
 5020 sE$="1"
 5030 FOR vI%=1 TO 12
 5040   sE$="FNinc("+sE$+")"
 5050 NEXT
 5060 PROCcheck_i("EVAL 12 nested FNinc",EVAL(sE$),13)
 5070 sE$="1"
 5080 FOR vI%=1 TO 8
 5090   sE$="FNdbl("+sE$+")"
 5100 NEXT
 5110 PROCcheck_i("EVAL 8 nested FNdbl",EVAL(sE$),256)
 5120 PROCcheck_i("direct nested FN mix",FNinc(FNdbl(FNinc(FNdbl(3)))),15)
 5130 ENDPROC

 6000 DEF PROCtest_many_statements
 6010 LOCAL vA%,vB%,vC%,vD%,vE%,vF%,vG%,vH%
 6020 vA%=1:vB%=2:vC%=3:vD%=4:vE%=5:vF%=6:vG%=7:vH%=8
 6030 PROCcheck_i("many statements one line sum",vA%+vB%+vC%+vD%+vE%+vF%+vG%+vH%,36)
 6040 vA%=0:FOR vB%=1 TO 10:vA%=vA%+vB%:NEXT:PROCcheck_i("FOR on one line",vA%,55)
 6050 ENDPROC

 7000 DEF PROCtest_parser_recovery
 7010 LOCAL vErr%,vGood%,vI%
 7020 vGood%=0
 7030 FOR vI%=1 TO 20
 7040   PROCbad_eval(vErr%)
 7050   IF vErr%<>0 THEN vGood%=vGood%+1
 7060 NEXT
 7070 PROCcheck_i("20 bad EVALs trapped",vGood%,20)
 7080 PROCcheck_i("EVAL works after bad EVALs",EVAL("6*7"),42)
 7090 PROCcheck_i("direct expression after bad EVALs",(10+5)*3,45)
 7100 ENDPROC

 8000 DEF FNinc(vN%)
 8010 =vN%+1

 8100 DEF FNdbl(vN%)
 8110 =vN%*2

 8200 DEF PROCbad_eval(RETURN vErr%)
 8210 LOCAL vX%
 8220 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8230 vX%=EVAL("1+")
 8240 vErr%=0
 8250 ENDPROC
