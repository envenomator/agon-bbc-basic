   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 5C
   30 REM FILE BOUNDARY / EOF / PTR TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   65 DIM vFailName$(50)
   66 vFailIdx%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 5C"
   80 PRINT "------------------------------------------"
   90 PROCsection("SMALL FILE BOUNDARIES")
  100 PROCtest_small_files
  110 PROCsection("PAGE / SECTOR-LIKE BOUNDARIES")
  120 PROCtest_page_files
  130 PROCsection("PTR# SEEK BOUNDARIES")
  140 PROCtest_ptr_boundaries
  150 PROCsection("EOF# BOUNDARIES")
  160 PROCtest_eof_boundaries
  170 PRINT
  180 PRINT "------------------------------------------"
  185 IF vFailIdx%>0 THEN PROCshow_failures
  190 PRINT "TOTAL TESTS : ";vTest%
  200 PRINT "PASSED      : ";vPass%
  210 PRINT "FAILED      : ";vFail%
  220 PRINT "------------------------------------------"
  230 END

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
  660 ENDPROC

  700 DEF PROCcheck_i(sName$,vGot%,vExp%)
  710 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  720 ENDPROC

  800 DEF PROCcheck_t(sName$,vFlag%)
  810 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
  820 ENDPROC

 1000 DEF PROCtest_small_files
 1010 REM PROCfile_size_test("L5C000.DAT",0)
 1020 PROCfile_size_test("L5C001.DAT",1)
 1030 PROCfile_size_test("L5C002.DAT",2)
 1040 PROCfile_size_test("L5C015.DAT",15)
 1050 PROCfile_size_test("L5C016.DAT",16)
 1060 PROCfile_size_test("L5C031.DAT",31)
 1070 PROCfile_size_test("L5C032.DAT",32)
 1080 ENDPROC

 2000 DEF PROCtest_page_files
 2010 PROCfile_size_test("L5C127.DAT",127)
 2020 PROCfile_size_test("L5C128.DAT",128)
 2030 PROCfile_size_test("L5C129.DAT",129)
 2040 PROCfile_size_test("L5C255.DAT",255)
 2050 PROCfile_size_test("L5C256.DAT",256)
 2060 PROCfile_size_test("L5C257.DAT",257)
 2070 PROCfile_size_test("L5C511.DAT",511)
 2080 PROCfile_size_test("L5C512.DAT",512)
 2090 PROCfile_size_test("L5C513.DAT",513)
 2100 ENDPROC

 3000 DEF PROCtest_ptr_boundaries
 3010 PROCmake_pattern_file("L5CPTR.DAT",512)
 3020 PROCptr_read_test("PTR start",0,0)
 3030 PROCptr_read_test("PTR one",1,1)
 3040 PROCptr_read_test("PTR 127",127,127)
 3050 PROCptr_read_test("PTR 128",128,128)
 3060 PROCptr_read_test("PTR 255",255,255)
 3070 PROCptr_read_test("PTR 256",256,0)
 3080 PROCptr_read_test("PTR 511",511,255)
 3090 ENDPROC

 4000 DEF PROCtest_eof_boundaries
 4010 LOCAL vCh%,vB%
 4020 PROCmake_pattern_file("L5CEOF.DAT",3)
 4030 vCh%=OPENIN("L5CEOF.DAT")
 4040 PROCcheck_t("EOF open non-empty false",NOT EOF#vCh%)
 4050 vB%=BGET#vCh%
 4060 PROCcheck_t("EOF after byte 1 false",NOT EOF#vCh%)
 4070 vB%=BGET#vCh%
 4080 PROCcheck_t("EOF after byte 2 false",NOT EOF#vCh%)
 4090 vB%=BGET#vCh%
 4100 PROCcheck_t("EOF after final byte true",EOF#vCh%)
 4110 CLOSE#vCh%
 4120 PROCmake_pattern_file("L5CEMP.DAT",0)
 4130 vCh%=OPENIN("L5CEMP.DAT")
 4140 REM PROCcheck_t("EOF empty file true",EOF#vCh%)
 4150 CLOSE#vCh%
 4160 ENDPROC

 5000 DEF PROCfile_size_test(sFile$,vSize%)
 5010 LOCAL vCh%,vI%,vB%,vSum%,vExp%
 5020 vCh%=OPENOUT(sFile$)
 5030 PROCcheck_t("OPENOUT "+sFile$,vCh%<>0)
 5040 FOR vI%=0 TO vSize%-1
 5050   BPUT#vCh%,vI% MOD 256
 5060 NEXT
 5070 CLOSE#vCh%
 5080 vCh%=OPENIN(sFile$)
 5090 PROCcheck_t("OPENIN "+sFile$,vCh%<>0)
 5100 PROCcheck_i("EXT# "+sFile$,EXT#vCh%,vSize%)
 5110 vSum%=0
 5120 FOR vI%=0 TO vSize%-1
 5130   vB%=BGET#vCh%
 5140   vSum%=vSum%+vB%
 5150 NEXT
 5160 vExp%=FNpattern_sum(vSize%)
 5170 PROCcheck_i("sum "+sFile$,vSum%,vExp%)
 5180 PROCcheck_t("EOF "+sFile$,EOF#vCh%)
 5190 CLOSE#vCh%
 5200 ENDPROC

 6000 DEF PROCmake_pattern_file(sFile$,vSize%)
 6010 LOCAL vCh%,vI%
 6020 vCh%=OPENOUT(sFile$)
 6030 FOR vI%=0 TO vSize%-1
 6040   BPUT#vCh%,vI% MOD 256
 6050 NEXT
 6060 CLOSE#vCh%
 6070 ENDPROC

 7000 DEF PROCptr_read_test(sName$,vPos%,vExp%)
 7010 LOCAL vCh%,vB%
 7020 vCh%=OPENIN("L5CPTR.DAT")
 7030 PROCcheck_t("OPENIN "+sName$,vCh%<>0)
 7040 PTR#vCh%=vPos%
 7050 PROCcheck_i(sName$+" PTR#",PTR#vCh%,vPos%)
 7060 vB%=BGET#vCh%
 7070 PROCcheck_i(sName$+" BGET#",vB%,vExp%)
 7080 CLOSE#vCh%
 7090 ENDPROC

 8000 DEF FNpattern_sum(vSize%)
 8010 LOCAL vFull%,vRem%,vSum%
 8020 vFull%=vSize% DIV 256
 8030 vRem%=vSize% MOD 256
 8040 vSum%=vFull%*32640
 8050 vSum%=vSum%+(vRem%*(vRem%-1)) DIV 2
 8060 =vSum%

 9000 DEF PROCshow_failures
 9010 LOCAL vI%
 9020 PRINT
 9030 PRINT "FAILED TEST NAMES:"
 9040 PRINT "-------------------"
 9050 FOR vI%=0 TO vFailIdx%-1
 9060   PRINT vFailName$(vI%)
 9070 NEXT
 9080 ENDPROC
