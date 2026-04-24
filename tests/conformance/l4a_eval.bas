   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 4A
   30 REM PARSER / EVAL / EXPRESSION STRESS TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 4A"
   80 PRINT "------------------------------------------"
   90 PROCsection("OPERATOR PRECEDENCE")
  100 PROCtest_prec
  110 PROCsection("EVAL NUMERIC")
  120 PROCtest_eval_num
  130 PROCsection("EVAL STRINGS")
  140 PROCtest_eval_str
  150 PROCsection("GENERATED EXPRESSIONS")
  160 PROCtest_genexpr
  170 PROCsection("NESTED FUNCTIONS")
  180 PROCtest_nestedfn
  190 PRINT
  200 PRINT "------------------------------------------"
  210 PRINT "TOTAL TESTS : ";vTest%
  220 PRINT "PASSED      : ";vPass%
  230 PRINT "FAILED      : ";vFail%
  240 PRINT "------------------------------------------"
  250 END

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

 2000 DEF PROCtest_prec
 2010 PROCcheck_i("mul before add",2+3*4,14)
 2020 PROCcheck_i("brackets override",(2+3)*4,20)
 2030 PROCcheck_i("unary minus precedence",-2*3,-6)
 2040 PROCcheck_i("nested brackets",((2+3)*(4+5)),45)
 2050 PROCcheck_i("DIV before add",2+17 DIV 5,5)
 2060 PROCcheck_i("MOD before add",2+17 MOD 5,4)
 2070 PROCcheck_i("shift after add",(1+3)<<2,16)
 2080 PROCcheck_i("AND precedence",(7 AND 3)+10,13)
 2090 PROCcheck_i("OR precedence",8 OR 2+1,11)
 2100 PROCcheck_i("EOR precedence",15 EOR 5,10)
 2110 PROCcheck_i("relational TRUE",3*4=12,TRUE)
 2120 PROCcheck_i("relational FALSE",3*4=13,FALSE)
 2130 PROCcheck_i("boolean expression",(3<4) AND (5>2),TRUE)
 2140 PROCcheck_i("boolean expression false",(3<4) AND (5<2),FALSE)
 2150 ENDPROC

 3000 DEF PROCtest_eval_num
 3010 LOCAL vA%,vB%,vC%,vR
 3020 vA%=10 : vB%=5 : vC%=3
 3030 PROCcheck_i("EVAL simple",EVAL("2+3*4"),14)
 3040 PROCcheck_i("EVAL brackets",EVAL("(2+3)*4"),20)
 3050 PROCcheck_i("EVAL variables",EVAL("vA%+vB%*vC%"),25)
 3060 PROCcheck_i("EVAL DIV MOD",EVAL("17 DIV 5 + 17 MOD 5"),5)
 3070 PROCcheck_i("EVAL hex",EVAL("&10+&20"),48)
 3080 PROCcheck_i("EVAL binary",EVAL("%1010+%0101"),15)
 3090 PROCcheck_r("EVAL real",EVAL("SQR(81)+SIN(PI/2)"),10,1E-6)
 3100 vR=EVAL("EXP(LN(7))")
 3110 PROCcheck_r("EVAL EXP/LN",vR,7,1E-6)
 3120 PROCcheck_i("EVAL comparison true",EVAL("3<4"),TRUE)
 3130 PROCcheck_i("EVAL comparison false",EVAL("3>4"),FALSE)
 3140 ENDPROC

 4000 DEF PROCtest_eval_str
 4010 LOCAL sA$,sB$,sC$
 4020 sA$="HELLO"
 4030 sB$="WORLD"
 4040 PROCcheck_s("EVAL string literal",EVAL("""ABC"""),"ABC")
 4050 PROCcheck_s("EVAL string concat",EVAL("""AB""+""CD"""),"ABCD")
 4060 PROCcheck_s("EVAL string variables",EVAL("sA$+"" ""+sB$"),"HELLO WORLD")
 4070 PROCcheck_s("EVAL LEFT$",EVAL("LEFT$(sA$,2)"),"HE")
 4080 PROCcheck_s("EVAL MID$",EVAL("MID$(sB$,2,3)"),"ORL")
 4090 PROCcheck_i("EVAL LEN string",EVAL("LEN(sA$+sB$)"),10)
 4100 sC$="CHR$(65)+CHR$(66)+CHR$(67)"
 4110 PROCcheck_s("EVAL generated string expr",EVAL(sC$),"ABC")
 4120 ENDPROC

 5000 DEF PROCtest_genexpr
 5010 LOCAL sE$,vI%,vGot%,vExp%
 5020 sE$=""
 5030 FOR vI%=1 TO 10
 5040   IF vI%=1 THEN sE$=STR$(vI%) ELSE sE$=sE$+"+"+STR$(vI%)
 5050 NEXT
 5060 vGot%=EVAL(sE$)
 5070 PROCcheck_i("generated sum 1..10",vGot%,55)
 5080 sE$="1"
 5090 FOR vI%=1 TO 8
 5100   sE$="("+sE$+"*2)"
 5110 NEXT
 5120 PROCcheck_i("generated nested multiply",EVAL(sE$),256)
 5130 sE$="0"
 5140 FOR vI%=1 TO 16
 5150   sE$=sE$+"+1"
 5160 NEXT
 5170 PROCcheck_i("generated long flat expr",EVAL(sE$),16)
 5180 sE$="(3+4)*(5+6)-7"
 5190 PROCcheck_i("generated fixed complex",EVAL(sE$),70)
 5200 ENDPROC

 6000 DEF PROCtest_nestedfn
 6010 LOCAL vA%,vB%,vC%
 6020 PROCcheck_i("nested FN direct",FNtwice(FNadd3(4)),14)
 6030 PROCcheck_i("FN inside expression",FNadd3(4)*FNtwice(5),70)
 6040 vA%=3 : vB%=4
 6050 PROCcheck_i("EVAL FN call",EVAL("FNadd3(vA%)+FNtwice(vB%)"),14)
 6060 PROCcheck_i("recursive expression FN",FNexprsum(10),55)
 6070 PROCcheck_i("nested recursive FN",FNtwice(FNexprsum(5)),30)
 6080 ENDPROC

 7000 DEF FNadd3(vN%)
 7010 =vN%+3

 7100 DEF FNtwice(vN%)
 7110 =vN%*2

 7200 DEF FNexprsum(vN%)
 7210 IF vN%<1 THEN =0
 7220 =vN%+FNexprsum(vN%-1)
