   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 3B
   30 REM FILE I/O TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 3B"
   80 PRINT "------------------------------------------"
   90 PROCsection("BYTE FILE I/O")
  100 PROCtest_bytefile
  110 PROCsection("PRINT# / INPUT# SEQUENTIAL I/O")
  120 PROCtest_seqfile
  130 PROCsection("EOF# / EXT# / PTR#")
  140 PROCtest_filepos
  150 PRINT
  160 PRINT "------------------------------------------"
  170 PRINT "TOTAL TESTS : ";vTest%
  180 PRINT "PASSED      : ";vPass%
  190 PRINT "FAILED      : ";vFail%
  200 PRINT "------------------------------------------"
  210 END

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

 2000 DEF PROCtest_bytefile
 2010 LOCAL vCh%,vI%,vB%,vSum%
 2020 vCh%=OPENOUT("B3BBIN.DAT")
 2030 PROCcheck_t("OPENOUT byte file",vCh%<>0)
 2040 FOR vI%=0 TO 15
 2050   BPUT#vCh%,vI%*3
 2060 NEXT
 2065 CLOSE#vCh%
 2066 vCh%=OPENIN("B3BBIN.DAT")
 2070 PROCcheck_i("EXT# after 16 BPUT",EXT#vCh%,16)
 2080 CLOSE#vCh%
 2090 vCh%=OPENIN("B3BBIN.DAT")
 2100 PROCcheck_t("OPENIN byte file",vCh%<>0)
 2110 vSum%=0
 2120 FOR vI%=0 TO 15
 2130   vB%=BGET#vCh%
 2140   vSum%=vSum%+vB%
 2150 NEXT
 2160 PROCcheck_i("byte file sum",vSum%,360)
 2170 PROCcheck_t("EOF# after byte reads",EOF#vCh%)
 2180 CLOSE#vCh%
 2190 ENDPROC

 3000 DEF PROCtest_seqfile
 3010 LOCAL vCh%,vA%,vB%,vC%,sA$,sB$
 3020 vCh%=OPENOUT("B3BSEQ.DAT")
 3030 PROCcheck_t("OPENOUT seq file",vCh%<>0)
 3040 PRINT#vCh%,12345
 3050 PRINT#vCh%,-6789
 3060 PRINT#vCh%,"HELLO"
 3070 PRINT#vCh%,"BBC BASIC"
 3080 CLOSE#vCh%
 3090 vCh%=OPENIN("B3BSEQ.DAT")
 3100 PROCcheck_t("OPENIN seq file",vCh%<>0)
 3110 INPUT#vCh%,vA%
 3120 INPUT#vCh%,vB%
 3130 INPUT#vCh%,sA$
 3140 INPUT#vCh%,sB$
 3150 PROCcheck_i("INPUT# integer positive",vA%,12345)
 3160 PROCcheck_i("INPUT# integer negative",vB%,-6789)
 3170 PROCcheck_s("INPUT# string one",sA$,"HELLO")
 3180 PROCcheck_s("INPUT# string two",sB$,"BBC BASIC")
 3190 PROCcheck_t("EOF# after seq reads",EOF#vCh%)
 3200 CLOSE#vCh%
 3210 ENDPROC

 4000 DEF PROCtest_filepos
 4010 LOCAL vCh%,vI%,vB%
 4020 vCh%=OPENOUT("B3BPOS.DAT")
 4030 PROCcheck_t("OPENOUT pos file",vCh%<>0)
 4040 FOR vI%=1 TO 10
 4050   BPUT#vCh%,vI%
 4060 NEXT
 4065 CLOSE#vCh%
 4066 vCh%=OPENIN("B3BPOS.DAT")
 4070 PROCcheck_i("EXT# pos file",EXT#vCh%,10)
 4080 CLOSE#vCh%
 4090 vCh%=OPENIN("B3BPOS.DAT")
 4100 PROCcheck_t("OPENIN pos file",vCh%<>0)
 4110 PROCcheck_i("PTR# initial",PTR#vCh%,0)
 4120 vB%=BGET#vCh%
 4130 PROCcheck_i("first BGET#",vB%,1)
 4140 PROCcheck_i("PTR# after one byte",PTR#vCh%,1)
 4150 PTR#vCh%=5
 4160 PROCcheck_i("PTR# seek to 5",PTR#vCh%,5)
 4170 vB%=BGET#vCh%
 4180 PROCcheck_i("BGET# after seek",vB%,6)
 4190 PTR#vCh%=9
 4200 vB%=BGET#vCh%
 4210 PROCcheck_i("BGET# final byte",vB%,10)
 4220 PROCcheck_t("EOF# final byte",EOF#vCh%)
 4230 CLOSE#vCh%
 4240 ENDPROC
