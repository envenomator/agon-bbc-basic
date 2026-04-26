   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5A
   30 REM DOCUMENTED LIMITS / SAFE BOUNDARY TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5A"
   80 PRINT "------------------------------------------"
   90 PROCsection("STRING LENGTH LIMITS")
  100 PROCtest_string_limits
  110 PROCsection("ARRAY BOUNDARY TESTS")
  120 PROCtest_array_limits
  130 PROCsection("LOCAL ARRAY BOUNDARY TESTS")
  140 PROCtest_local_array_limits
  150 PROCsection("RECURSION DEPTH SANITY")
  160 PROCtest_recursion_sanity
  170 PROCsection("POST-LIMIT RUNTIME SANITY")
  180 PROCtest_post_sanity
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

 2000 DEF PROCtest_string_limits
 2010 LOCAL sA$,sB$,vErr%
 2020 sA$=STRING$(254,"A")
 2030 PROCcheck_i("string length 254",LEN(sA$),254)
 2040 sA$=sA$+"B"
 2050 PROCcheck_i("string length 255",LEN(sA$),255)
 2060 PROCcheck_s("string length 255 first",LEFT$(sA$,1),"A")
 2070 PROCcheck_s("string length 255 last",RIGHT$(sA$,1),"B")
 2080 sB$=LEFT$(sA$,128)+RIGHT$(sA$,127)
 2090 PROCcheck_i("split/rejoin 255 string",LEN(sB$),255)
 2100 PROCstring_256_error(vErr%)
 2110 PROCcheck_t("string length 256 trapped",vErr%<>0)
 2120 ENDPROC

 2200 DEF PROCstring_256_error(RETURN vErr%)
 2210 LOCAL sA$
 2220 ON ERROR LOCAL vErr%=ERR : ENDPROC
 2230 sA$=STRING$(255,"A")+"B"
 2240 vErr%=0
 2250 ENDPROC

 3000 DEF PROCtest_array_limits
 3010 LOCAL aI%(),aR(),aS$()
 3020 DIM aI%(255)
 3030 aI%(0)=11
 3040 aI%(255)=22
 3050 PROCcheck_i("integer array index 0",aI%(0),11)
 3060 PROCcheck_i("integer array index 255",aI%(255),22)
 3070 DIM aR(127)
 3080 aR(0)=1.25
 3090 aR(127)=127.5
 3100 PROCcheck_t("real array index 0",aR(0)=1.25)
 3110 PROCcheck_t("real array index 127",aR(127)=127.5)
 3120 DIM aS$(31)
 3130 aS$(0)="FIRST"
 3140 aS$(31)="LAST"
 3150 PROCcheck_s("string array index 0",aS$(0),"FIRST")
 3160 PROCcheck_s("string array index 31",aS$(31),"LAST")
 3170 ENDPROC

 4000 DEF PROCtest_local_array_limits
 4010 LOCAL vOut%
 4020 PROClocal_int_boundary(vOut%)
 4030 PROCcheck_i("local integer array boundary",vOut%,300)
 4040 PROClocal_real_boundary(vOut%)
 4050 PROCcheck_i("local real array boundary",vOut%,400)
 4060 PROClocal_string_boundary(vOut%)
 4070 PROCcheck_i("local string array boundary",vOut%,500)
 4080 ENDPROC

 4200 DEF PROClocal_int_boundary(RETURN vOut%)
 4210 LOCAL aI%()
 4220 DIM aI%(127)
 4230 aI%(0)=100
 4240 aI%(127)=200
 4250 vOut%=aI%(0)+aI%(127)
 4260 ENDPROC

 4300 DEF PROClocal_real_boundary(RETURN vOut%)
 4310 LOCAL aR()
 4320 DIM aR(63)
 4330 aR(0)=150.5
 4340 aR(63)=249.5
 4350 IF aR(0)+aR(63)=400 THEN vOut%=400 ELSE vOut%=-1
 4360 ENDPROC

 4400 DEF PROClocal_string_boundary(RETURN vOut%)
 4410 LOCAL aS$()
 4420 DIM aS$(15)
 4430 aS$(0)="LOCAL"
 4440 aS$(15)="ARRAY"
 4450 IF aS$(0)+"-"+aS$(15)="LOCAL-ARRAY" THEN vOut%=500 ELSE vOut%=-1
 4460 ENDPROC

 5000 DEF PROCtest_recursion_sanity
 5010 PROCcheck_i("recursive sum 25",FNrsum(25),325)
 5020 PROCcheck_i("recursive depth 40 marker",FNdepth(40),40)
 5030 PROCcheck_i("mutual recursion depth 30",FNa(30),30)
 5040 ENDPROC

 5100 DEF FNrsum(vN%)
 5110 IF vN%=0 THEN =0
 5120 =vN%+FNrsum(vN%-1)

 5200 DEF FNdepth(vN%)
 5210 IF vN%=0 THEN =0
 5220 =1+FNdepth(vN%-1)

 5300 DEF FNa(vN%)
 5310 IF vN%=0 THEN =0
 5320 =1+FNb(vN%-1)

 5400 DEF FNb(vN%)
 5410 IF vN%=0 THEN =0
 5420 =1+FNa(vN%-1)

 6000 DEF PROCtest_post_sanity
 6010 LOCAL vI%,vSum%,sA$
 6020 vSum%=0
 6030 FOR vI%=1 TO 100
 6040   vSum%=vSum%+vI%
 6050 NEXT
 6060 PROCcheck_i("FOR sanity after limit tests",vSum%,5050)
 6070 sA$="BBC"+" "+"BASIC"
 6080 PROCcheck_s("string sanity after limit tests",sA$,"BBC BASIC")
 6090 PROCcheck_i("EVAL sanity after limit tests",EVAL("6*7"),42)
 6100 ENDPROC
