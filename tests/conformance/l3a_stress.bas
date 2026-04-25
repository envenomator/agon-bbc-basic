   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 3A
   30 REM RUNTIME STRESS / STABILITY TESTS
   40 REM ==============================================================
   50 MODE 0
   65 DIM aI%(49),aT%(15)
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 vGosub%=0
   80 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 3A"
   90 PRINT "------------------------------------------"
  100 PROCsection("LOOP STRESS")
  110 PROCtest_loops
  120 PROCsection("PROC / FN / STACK STRESS")
  130 PROCtest_stack
  140 PROCsection("STRING STRESS")
  150 PROCtest_strings
  160 PROCsection("ARRAY STRESS")
  170 PROCtest_arrays
  180 PROCsection("MEMORY INDIRECTION STRESS")
  190 PROCtest_memory
  200 PROCsection("ERROR RECOVERY STRESS")
  210 PROCtest_errors
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
  630 PRINT "FAIL ";sName$;"  got=";vGot%;" expected=";vExp%
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

 2000 DEF PROCtest_loops
 2010 LOCAL vI%,vJ%,vK%,vSum%,vCnt%
 2020 vSum%=0
 2030 FOR vI%=1 TO 200
 2040   vSum%=vSum%+vI%
 2050 NEXT
 2060 PROCcheck_i("FOR sum 1..200",vSum%,20100)
 2070 vSum%=0
 2080 FOR vI%=1 TO 20
 2090   FOR vJ%=1 TO 10
 2100     vSum%=vSum%+vI%+vJ%
 2110   NEXT
 2120 NEXT
 2130 PROCcheck_i("nested FOR sum",vSum%,3200)
 2140 vCnt%=0
 2150 REPEAT
 2160   vCnt%=vCnt%+1
 2170 UNTIL vCnt%=250
 2180 PROCcheck_i("REPEAT 250 iterations",vCnt%,250)
 2190 vCnt%=0
 2200 WHILE vCnt%<300
 2210   vCnt%=vCnt%+1
 2220 ENDWHILE
 2230 PROCcheck_i("WHILE 300 iterations",vCnt%,300)
 2240 vGosub%=0
 2250 FOR vI%=1 TO 100
 2260   GOSUB 9000
 2270 NEXT
 2280 PROCcheck_i("100 GOSUB/RETURN cycles",vGosub%,100)
 2290 ENDPROC

 3000 DEF PROCtest_stack
 3010 LOCAL vI%,vOut%,vSum%
 3020 PROCcheck_i("recursive factorial 10",FNfact(10),3628800)
 3030 PROCcheck_i("recursive fibonacci 12",FNfib(12),144)
 3040 vSum%=0
 3050 FOR vI%=1 TO 100
 3060   PROCsmall(vI%,vOut%)
 3070   vSum%=vSum%+vOut%
 3080 NEXT
 3090 PROCcheck_i("100 PROC calls with return",vSum%,10100)
 3100 PROCnested_a(5,vOut%)
 3110 PROCcheck_i("nested PROC chain",vOut%,15)
 3120 ENDPROC

 4000 DEF PROCtest_strings
 4010 LOCAL sA$,sB$,vI%,vLen%
 4020 sA$=""
 4030 FOR vI%=1 TO 200
 4040   sA$=sA$+"A"
 4050 NEXT
 4060 PROCcheck_i("string build length 200",LEN(sA$),200)
 4070 PROCcheck_s("string build left",LEFT$(sA$,5),"AAAAA")
 4080 PROCcheck_s("string build right",RIGHT$(sA$,5),"AAAAA")
 4090 sB$=""
 4100 FOR vI%=1 TO 50
 4110   sB$=sB$+CHR$(64+(vI% MOD 26)+1)
 4120 NEXT
 4130 PROCcheck_i("mixed string length 50",LEN(sB$),50)
 4140 PROCcheck_s("mixed string prefix",LEFT$(sB$,6),"BCDEFG")
 4150 PROCcheck_s("mixed string middle",MID$(sB$,25,4),"ZABC")
 4160 FOR vI%=1 TO 20
 4170   MID$(sB$,vI%,1)="Z"
 4180 NEXT
 4190 PROCcheck_s("repeated MID$ assignment",LEFT$(sB$,20),STRING$(20,"Z"))
 4200 ENDPROC

 5000 DEF PROCtest_arrays
 5010 LOCAL vI%,vSum%,vOut%
 5020 FOR vI%=0 TO 49
 5030   aI%(vI%)=vI%
 5040 NEXT
 5050 vSum%=0
 5060 FOR vI%=0 TO 49
 5070   vSum%=vSum%+aI%(vI%)
 5080 NEXT
 5090 PROCcheck_i("array sum 0..49",vSum%,1225)
 5100 FOR vI%=0 TO 49
 5110   aI%(vI%)=aI%(vI%)*2
 5120 NEXT
 5130 PROCcheck_i("array doubled first",aI%(0),0)
 5140 PROCcheck_i("array doubled middle",aI%(25),50)
 5150 PROCcheck_i("array doubled last",aI%(49),98)
 5160 vSum%=0
 5170 FOR vI%=1 TO 20
 5180   PROCreuse_array(vI%,vOut%)
 5190   vSum%=vSum%+vOut%
 5200 NEXT
 5210 PROCcheck_i("20 reused array fills",vSum%,5760)
 5220 ENDPROC

 6000 DEF PROCtest_memory
 6010 LOCAL mBlk%,vBase%,vI%,vSum%,vP%
 6020 DIM mBlk% 255
 6030 vBase%=mBlk%
 6040 FOR vI%=0 TO 127
 6050   vBase%?vI%=vI%
 6060 NEXT
 6070 vSum%=0
 6080 FOR vI%=0 TO 127
 6090   vSum%=vSum%+(vBase%?vI%)
 6100 NEXT
 6110 PROCcheck_i("128 byte write/read sum",vSum%,8128)
 6120 vP%=vBase%+128
 6130 FOR vI%=0 TO 7
 6140   !(vP%+vI%*4)=&01020304+vI%
 6150 NEXT
 6160 PROCcheck_i("word stress first",!vP%,&01020304)
 6170 PROCcheck_i("word stress last",!(vP%+28),&0102030B)
 6180 ENDPROC

 7000 DEF PROCtest_errors
 7010 LOCAL vI%,vErr%,vGood%
 7020 vGood%=0
 7030 FOR vI%=1 TO 25
 7040   PROCcatch_div(vErr%)
 7050   IF vErr%=18 THEN vGood%=vGood%+1
 7060 NEXT
 7070 PROCcheck_i("25 trapped div zero errors",vGood%,25)
 7080 vGood%=0
 7090 FOR vI%=1 TO 25
 7100   PROCnormal_after_error(vErr%)
 7110   IF vErr%=0 THEN vGood%=vGood%+1
 7120 NEXT
 7130 PROCcheck_i("normal execution after errors",vGood%,25)
 7140 ENDPROC

 8000 DEF FNfact(vN%)
 8010 IF vN%<2 THEN =1
 8020 =vN%*FNfact(vN%-1)

 8100 DEF FNfib(vN%)
 8110 IF vN%<2 THEN =vN%
 8120 =FNfib(vN%-1)+FNfib(vN%-2)

 8200 DEF PROCsmall(vIn%,RETURN vOut%)
 8210 LOCAL vTmp%
 8220 vTmp%=vIn%*2
 8230 vOut%=vTmp%
 8240 ENDPROC

 8300 DEF PROCnested_a(vN%,RETURN vOut%)
 8310 LOCAL vTmp%
 8320 PROCnested_b(vN%,vTmp%)
 8330 vOut%=vTmp%+1
 8340 ENDPROC

 8400 DEF PROCnested_b(vN%,RETURN vOut%)
 8410 LOCAL vTmp%
 8420 PROCnested_c(vN%,vTmp%)
 8430 vOut%=vTmp%+2
 8440 ENDPROC

 8500 DEF PROCnested_c(vN%,RETURN vOut%)
 8510 vOut%=vN%+7
 8520 ENDPROC

 8600 DEF PROCreuse_array(vSeed%,RETURN vOut%)
 8610 LOCAL vI%,vSum%
 8620 vSum%=0
 8630 FOR vI%=0 TO 15
 8640   aT%(vI%)=vSeed%+vI%
 8650   vSum%=vSum%+aT%(vI%)
 8660 NEXT
 8670 vOut%=vSum%
 8680 ENDPROC

 8700 DEF PROCcatch_div(RETURN vErr%)
 8710 LOCAL vX%
 8720 ON ERROR LOCAL vErr%=ERR : ENDPROC
 8730 vX%=1/0
 8740 vErr%=0
 8750 ENDPROC

 8800 DEF PROCnormal_after_error(RETURN vErr%)
 8810 LOCAL vX%
 8820 vX%=10
 8830 vX%=vX%+5
 8840 IF vX%=15 THEN vErr%=0 ELSE vErr%=-1
 8850 ENDPROC

 9000 vGosub%=vGosub%+1 : RETURN
