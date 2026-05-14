   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 TEST HARNESS - LEVEL 4B
   30 REM FLOATING POINT / NUMERIC STABILITY TESTS
   40 REM ==============================================================
   50 MODE 0
   60 vPass%=0 : vFail%=0 : vTest%=0
   70 PRINT "BBC BASIC V / Z80 TEST HARNESS - LEVEL 4B"
   80 PRINT "------------------------------------------"
   90 PROCsection("BASIC REAL ARITHMETIC")
  100 PROCtest_basicreal
  110 PROCsection("TRANSCENDENTAL FUNCTIONS")
  120 PROCtest_trans
  130 PROCsection("INVERSE TRIG / ANGLE CONVERSION")
  140 PROCtest_angles
  145 PROCsection("ROUNDING / INT / SGN")
  146 PROCtest_round
  150 PROCsection("PRECISION BOUNDARIES")
  160 PROCtest_precision
  170 PROCsection("ACCUMULATION")
  180 PROCtest_accum
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

  600 DEF PROCbad_r(sName$,vGot,vExp)
  610 vTest%=vTest%+1
  620 vFail%=vFail%+1
  630 PRINT "FAIL ";sName$;" got=";vGot;" expected=";vExp
  640 ENDPROC

  700 DEF PROCbad_i(sName$,vGot%,vExp%)
  710 vTest%=vTest%+1
  720 vFail%=vFail%+1
  730 PRINT "FAIL ";sName$;" got=";vGot%;" expected=";vExp%
  740 ENDPROC

  800 DEF PROCcheck_r(sName$,vGot,vExp,vTol)
  810 IF ABS(vGot-vExp)<=vTol THEN PROCok(sName$) ELSE PROCbad_r(sName$,vGot,vExp)
  820 ENDPROC

  900 DEF PROCcheck_i(sName$,vGot%,vExp%)
  910 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
  920 ENDPROC

 1000 DEF PROCcheck_t(sName$,vFlag%)
 1010 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
 1020 ENDPROC

 2000 DEF PROCtest_basicreal
 2010 PROCcheck_r("0.5 + 0.25",0.5+0.25,0.75,1E-9)
 2020 PROCcheck_r("0.1 + 0.2 approx",0.1+0.2,0.3,1E-6)
 2030 PROCcheck_r("10 / 4",10/4,2.5,1E-9)
 2040 PROCcheck_r("1 / 3 * 3",(1/3)*3,1,1E-6)
 2050 PROCcheck_r("SQR(2)^2",SQR(2)*SQR(2),2,1E-6)
 2060 PROCcheck_r("SQR(3)^2",SQR(3)*SQR(3),3,1E-6)
 2070 PROCcheck_r("large multiply/divide",(12345.678*1000)/1000,12345.678,1E-3)
 2080 PROCcheck_r("small multiply/divide",(0.000123456*1000000)/1000000,0.000123456,1E-10)
 2090 ENDPROC

 3000 DEF PROCtest_trans
 3010 PROCcheck_r("SIN(0)",SIN(0),0,1E-7)
 3020 PROCcheck_r("COS(0)",COS(0),1,1E-7)
 3030 PROCcheck_r("SIN(PI/2)",SIN(PI/2),1,1E-6)
 3040 PROCcheck_r("COS(PI)",COS(PI),-1,1E-6)
 3050 PROCcheck_r("SIN(PI)",SIN(PI),0,1E-5)
 3060 PROCcheck_r("TAN(PI/4)",TAN(PI/4),1,1E-5)
 3070 PROCcheck_r("ATN(1)",ATN(1),PI/4,1E-6)
 3080 PROCcheck_r("EXP(0)",EXP(0),1,1E-9)
 3090 PROCcheck_r("LN(EXP(3))",LN(EXP(3)),3,1E-6)
 3100 PROCcheck_r("EXP(LN(12.5))",EXP(LN(12.5)),12.5,1E-5)
 3115 PROCcheck_r("LOG(100)",LOG(100),2,1E-7)
 3116 PROCcheck_r("LOG(10)",LOG(10),1,1E-7)
 3117 PROCcheck_r("LOG(1)",LOG(1),0,1E-7)
 3118 PROCcheck_r("10^LOG(12.5)",10^LOG(12.5),12.5,1E-5)
 3110 ENDPROC

 3500 DEF PROCtest_angles
 3510 PROCcheck_r("ACS(1)",ACS(1),0,1E-7)
 3520 PROCcheck_r("ACS(0)",ACS(0),PI/2,1E-6)
 3530 PROCcheck_r("ACS(-1)",ACS(-1),PI,1E-6)
 3540 PROCcheck_r("ASN(0)",ASN(0),0,1E-7)
 3550 PROCcheck_r("ASN(1)",ASN(1),PI/2,1E-6)
 3560 PROCcheck_r("ASN(-1)",ASN(-1),-PI/2,1E-6)
 3570 PROCcheck_r("DEG(PI)",DEG(PI),180,1E-5)
 3580 PROCcheck_r("DEG(PI/2)",DEG(PI/2),90,1E-5)
 3590 PROCcheck_r("RAD(180)",RAD(180),PI,1E-6)
 3600 PROCcheck_r("RAD(90)",RAD(90),PI/2,1E-6)
 3610 PROCcheck_r("RAD(DEG(1))",RAD(DEG(1)),1,1E-6)
 3620 PROCcheck_r("DEG(RAD(45))",DEG(RAD(45)),45,1E-5)
 3630 ENDPROC

 4000 DEF PROCtest_round
 4010 PROCcheck_i("INT 1.999",INT(1.999),1)
 4020 PROCcheck_i("INT 2.000",INT(2.000),2)
 4030 PROCcheck_i("INT -1.001",INT(-1.001),-2)
 4040 PROCcheck_i("INT -1.000",INT(-1.000),-1)
 4050 PROCcheck_i("SGN tiny positive",SGN(1E-20),1)
 4060 PROCcheck_i("SGN tiny negative",SGN(-1E-20),-1)
 4070 PROCcheck_i("SGN zero",SGN(0),0)
 4080 PROCcheck_r("ABS tiny",ABS(-1E-20),1E-20,1E-25)
 4090 ENDPROC

 5000 DEF PROCtest_precision
 5010 LOCAL vA,vB,vC
 5020 vA=1000000
 5030 vB=(vA+1)-vA
 5040 PROCcheck_r("(1E6+1)-1E6",vB,1,1E-5)
 5050 vA=10000000
 5060 vB=(vA+1)-vA
 5070 PROCcheck_r("(1E7+1)-1E7",vB,1,1E-4)
 5080 vA=1E-20
 5090 vB=vA*1E20
 5100 PROCcheck_r("1E-20 * 1E20",vB,1,1E-6)
 5110 vC=1E20/1E10
 5120 PROCcheck_r("1E20 / 1E10",vC,1E10,1E4)
 5130 PROCcheck_t("positive tiny nonzero",1E-30>0)
 5140 PROCcheck_t("negative tiny below zero",-1E-30<0)
 5150 ENDPROC

 6000 DEF PROCtest_accum
 6010 LOCAL vI%,vS,vT
 6020 vS=0
 6030 FOR vI%=1 TO 100
 6040   vS=vS+0.1
 6050 NEXT
 6060 PROCcheck_r("sum 0.1 x100",vS,10,1E-4)
 6070 vS=1
 6080 FOR vI%=1 TO 50
 6090   vS=vS*1.01
 6100 NEXT
 6110 PROCcheck_r("compound growth 1.01^50",vS,1.64463,1E-4)
 6120 vT=1
 6130 FOR vI%=1 TO 50
 6140   vT=vT/1.01
 6150 NEXT
 6160 PROCcheck_r("growth then shrink",vS*vT,1,1E-4)
 6170 vS=0
 6180 FOR vI%=1 TO 1000
 6190   vS=vS+1
 6200 NEXT
 6210 PROCcheck_r("sum 1 x1000",vS,1000,1E-6)
 6220 ENDPROC
