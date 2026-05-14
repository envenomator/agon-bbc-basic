   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 CLEAR KEYWORD TEST
   30 REM ==============================================================
   40 MODE 0
   50 PRINT "BBC BASIC V CLEAR KEYWORD TEST"
   60 PRINT "------------------------------"
   70 vA%=123
   80 vB=45.5
   90 sA$="HELLO"
  100 DIM aI%(3)
  110 aI%(0)=10
  120 CLEAR
  130 vPass%=0 : vFail%=0 : vTest%=0
  140 PROCtest_clear
  150 PRINT
  160 PRINT "TOTAL TESTS : ";vTest%
  170 PRINT "PASSED      : ";vPass%
  180 PRINT "FAILED      : ";vFail%
  190 END

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

  600 DEF PROCcheck_i(sName$,vGot%,vExp%)
  610 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  620 ENDPROC

 1000 DEF PROCtest_clear
 1010 LOCAL vErr%
 1020 PROCprobe_int(vErr%)
 1030 IF vErr%<>0 THEN PROCok("CLEAR removes integer scalar") ELSE PROCbad_i("CLEAR removes integer scalar",vErr%,-1)
 1040 PROCprobe_real(vErr%)
 1050 IF vErr%<>0 THEN PROCok("CLEAR removes real scalar") ELSE PROCbad_i("CLEAR removes real scalar",vErr%,-1)
 1060 PROCprobe_string(vErr%)
 1070 IF vErr%<>0 THEN PROCok("CLEAR removes string scalar") ELSE PROCbad_i("CLEAR removes string scalar",vErr%,-1)
 1080 PROCprobe_array(vErr%)
 1090 IF vErr%<>0 THEN PROCok("CLEAR removes arrays") ELSE PROCbad_i("CLEAR removes arrays",vErr%,-1)
 1100 vA%=77
 1110 sA$="OK"
 1120 DIM aI%(2)
 1130 aI%(2)=99
 1140 PROCcheck_i("post-CLEAR integer assignment",vA%,77)
 1150 IF sA$="OK" THEN PROCok("post-CLEAR string assignment") ELSE PROCbad_i("post-CLEAR string assignment",0,-1)
 1160 PROCcheck_i("post-CLEAR array recreate",aI%(2),99)
 1170 ENDPROC

 2000 DEF PROCprobe_int(RETURN vErr%)
 2010 LOCAL vX%
 2020 ON ERROR LOCAL vErr%=ERR : ENDPROC
 2030 vX%=vA%
 2040 vErr%=0
 2050 ENDPROC

 2100 DEF PROCprobe_real(RETURN vErr%)
 2110 LOCAL vX
 2120 ON ERROR LOCAL vErr%=ERR : ENDPROC
 2130 vX=vB
 2140 vErr%=0
 2150 ENDPROC

 2200 DEF PROCprobe_string(RETURN vErr%)
 2210 LOCAL sX$
 2220 ON ERROR LOCAL vErr%=ERR : ENDPROC
 2230 sX$=sA$
 2240 vErr%=0
 2250 ENDPROC

 2300 DEF PROCprobe_array(RETURN vErr%)
 2310 LOCAL vX%
 2320 ON ERROR LOCAL vErr%=ERR : ENDPROC
 2330 vX%=aI%(0)
 2340 vErr%=0
 2350 ENDPROC
