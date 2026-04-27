   10 REM ==============================================================
   20 REM BBC BASIC V / Z80 COMBINED CONFORMANCE TEST HARNESS
   30 REM GENERATED FROM ALL SOURCE TEST PROGRAMS
   40 REM ==============================================================
   50 MODE 0
   60 ON ERROR PRINT "FATAL ERROR at line ";ERL;" : ";REPORT$ : END
   70 vPass%=0 : vFail%=0 : vTest%=0
   80 DIM vFailName$(200)
   90 vFailIdx%=0
   95 DIM c3%(49),d3%(15)
  100 PRINT "BBC BASIC V / Z80 COMBINED CONFORMANCE HARNESS"
  110 PRINT "-----------------------------------------------"
  120 PROCsection("L1_CORE - NUMERIC EXPRESSIONS")
  130 PROCPL1CORE_test_numeric
  140 PROCsection("L1_CORE - STRINGS")
  150 PROCPL1CORE_test_strings
  160 PROCsection("L1_CORE - FLOW CONTROL")
  170 PROCPL1CORE_test_flow
  180 PROCsection("L1_CORE - PROCEDURES AND FUNCTIONS")
  190 PROCPL1CORE_test_procfn
  200 PROCsection("L1_CORE - DATA / READ / RESTORE")
  210 PROCPL1CORE_test_data
  220 PROCsection("L1_CORE - ARRAYS")
  230 PROCPL1CORE_test_arrays
  240 PROCsection("L1_CORE - MEMORY / INDIRECTION")
  250 PROCPL1CORE_test_memory
  260 PROCsection("L1_CORE - ERROR HANDLING")
  270 PROCPL1CORE_test_errors
  280 PROCsection("L2_EDGE - NUMERIC EDGE CASES")
  290 PROCPL2EDGE_test_num2
  300 PROCsection("L2_EDGE - STRING EDGE CASES")
  310 PROCPL2EDGE_test_str2
  320 PROCsection("L2_EDGE - FLOW / TOKENISER EDGE CASES")
  330 PROCPL2EDGE_test_flow2
  340 PROCsection("L2_EDGE - ARRAY EDGE CASES")
  350 PROCPL2EDGE_test_arr2
  360 PROCsection("L2_EDGE - ERROR REPORTING EDGE CASES")
  370 PROCPL2EDGE_test_err2
  380 PROCsection("L3A_STRESS - LOOP STRESS")
  390 PROCPL3ASTRESS_test_loops
  400 PROCsection("L3A_STRESS - PROC / FN / STACK STRESS")
  410 PROCPL3ASTRESS_test_stack
  420 PROCsection("L3A_STRESS - STRING STRESS")
  430 PROCPL3ASTRESS_test_strings
  440 PROCsection("L3A_STRESS - ARRAY STRESS")
  450 PROCPL3ASTRESS_test_arrays
  460 PROCsection("L3A_STRESS - MEMORY INDIRECTION STRESS")
  470 PROCPL3ASTRESS_test_memory
  480 PROCsection("L3A_STRESS - ERROR RECOVERY STRESS")
  490 PROCPL3ASTRESS_test_errors
  500 PROCsection("L3B_FILEIO - BYTE FILE I/O")
  510 PROCPL3BFILEIO_test_bytefile
  520 PROCsection("L3B_FILEIO - PRINT# / INPUT# SEQUENTIAL I/O")
  530 PROCPL3BFILEIO_test_seqfile
  540 PROCsection("L3B_FILEIO - EOF# / EXT# / PTR#")
  550 PROCPL3BFILEIO_test_filepos
  560 PROCsection("L4A_EVAL - OPERATOR PRECEDENCE")
  570 PROCPL4AEVAL_test_prec
  580 PROCsection("L4A_EVAL - EVAL NUMERIC")
  590 PROCPL4AEVAL_test_eval_num
  600 PROCsection("L4A_EVAL - EVAL STRINGS")
  610 PROCPL4AEVAL_test_eval_str
  620 PROCsection("L4A_EVAL - GENERATED EXPRESSIONS")
  630 PROCPL4AEVAL_test_genexpr
  640 PROCsection("L4A_EVAL - NESTED FUNCTIONS")
  650 PROCPL4AEVAL_test_nestedfn
  660 PROCsection("L4B_FLOAT - BASIC REAL ARITHMETIC")
  670 PROCPL4BFLOAT_test_basicreal
  680 PROCsection("L4B_FLOAT - TRANSCENDENTAL FUNCTIONS")
  690 PROCPL4BFLOAT_test_trans
  700 PROCsection("L4B_FLOAT - ROUNDING / INT / SGN")
  710 PROCPL4BFLOAT_test_round
  720 PROCsection("L4B_FLOAT - PRECISION BOUNDARIES")
  730 PROCPL4BFLOAT_test_precision
  740 PROCsection("L4B_FLOAT - ACCUMULATION")
  750 PROCPL4BFLOAT_test_accum
  760 PROCsection("L4C_LOCALDIM - BASIC LOCAL ARRAY DIM")
  770 PROCPL4CLOCALDIM_test_basic_localdim
  780 PROCsection("L4C_LOCALDIM - MULTIPLE LOCAL ARRAYS")
  790 PROCPL4CLOCALDIM_test_many_localdim
  800 PROCsection("L4C_LOCALDIM - REPEATED LOCAL ARRAY ALLOCATION")
  810 PROCPL4CLOCALDIM_test_repeat_localdim
  820 PROCsection("L4C_LOCALDIM - NESTED LOCAL ARRAYS")
  830 PROCPL4CLOCALDIM_test_nested_localdim
  840 PROCsection("L4C_LOCALDIM - LOCAL ARRAYS INSIDE FUNCTIONS")
  850 PROCPL4CLOCALDIM_test_fn_localdim
  860 PROCsection("L4C_LOCALDIM - GLOBAL DIM AFTER LOCAL ARRAYS")
  870 PROCPL4CLOCALDIM_test_after_localdim
  880 PROCsection("L5A_LIMITS - STRING LENGTH LIMITS")
  890 PROCPL5ALIMITS_test_string_limits
  900 PROCsection("L5A_LIMITS - ARRAY BOUNDARY TESTS")
  910 PROCPL5ALIMITS_test_array_limits
  920 PROCsection("L5A_LIMITS - LOCAL ARRAY BOUNDARY TESTS")
  930 PROCPL5ALIMITS_test_local_array_limits
  940 PROCsection("L5A_LIMITS - RECURSION DEPTH SANITY")
  950 PROCPL5ALIMITS_test_recursion_sanity
  960 PROCsection("L5A_LIMITS - POST-LIMIT RUNTIME SANITY")
  970 PROCPL5ALIMITS_test_post_sanity
  980 PROCsection("L5B_RECOVERY - REPEATED ERROR RECOVERY")
  990 PROCPL5BRECOVERY_test_repeated
 1000 PROCsection("L5B_RECOVERY - ERRORS INSIDE LOOPS")
 1010 PROCPL5BRECOVERY_test_loop_errors
 1020 PROCsection("L5B_RECOVERY - ERRORS WITH LOCAL VARIABLES")
 1030 PROCPL5BRECOVERY_test_local_errors
 1040 PROCsection("L5B_RECOVERY - ERRORS WITH LOCAL ARRAYS")
 1050 PROCPL5BRECOVERY_test_local_array_errors
 1060 PROCsection("L5B_RECOVERY - ERRORS WITH FILES OPEN")
 1070 PROCPL5BRECOVERY_test_file_errors
 1080 PROCsection("L5B_RECOVERY - POST-ERROR RUNTIME SANITY")
 1090 PROCPL5BRECOVERY_test_post_sanity
 1100 PROCsection("L5C_FILEBOUND - SMALL FILE BOUNDARIES")
 1110 PROCPL5CFILEBOUND_test_small_files
 1120 PROCsection("L5C_FILEBOUND - PAGE / SECTOR-LIKE BOUNDARIES")
 1130 PROCPL5CFILEBOUND_test_page_files
 1140 PROCsection("L5C_FILEBOUND - PTR# SEEK BOUNDARIES")
 1150 PROCPL5CFILEBOUND_test_ptr_boundaries
 1160 PROCsection("L5C_FILEBOUND - EOF# BOUNDARIES")
 1170 PROCPL5CFILEBOUND_test_eof_boundaries
 1180 PROCsection("L5D_PARSERLIMIT - NESTED PARENTHESES")
 1190 PROCPL5DPARSERLIMIT_test_parens
 1200 PROCsection("L5D_PARSERLIMIT - LONG FLAT EXPRESSIONS")
 1210 PROCPL5DPARSERLIMIT_test_flat_expr
 1220 PROCsection("L5D_PARSERLIMIT - STRING PARSER EXPRESSIONS")
 1230 PROCPL5DPARSERLIMIT_test_string_expr
 1240 PROCsection("L5D_PARSERLIMIT - NESTED FUNCTION EXPRESSIONS")
 1250 PROCPL5DPARSERLIMIT_test_fn_expr
 1260 PROCsection("L5D_PARSERLIMIT - MANY STATEMENTS ON ONE LINE")
 1270 PROCPL5DPARSERLIMIT_test_many_statements
 1280 PROCsection("L5D_PARSERLIMIT - PARSER ERROR RECOVERY")
 1290 PROCPL5DPARSERLIMIT_test_parser_recovery
 1300 PROCsection("L5E_MEMCHURN - STRING CHURN")
 1310 PROCPL5EMEMCHURN_test_string_churn
 1320 PROCsection("L5E_MEMCHURN - LOCAL ARRAY CHURN")
 1330 PROCPL5EMEMCHURN_test_local_array_churn
 1340 PROCsection("L5E_MEMCHURN - MIXED ARRAY CHURN")
 1350 PROCPL5EMEMCHURN_test_mixed_array_churn
 1360 PROCsection("L5E_MEMCHURN - NESTED LOCAL CHURN")
 1370 PROCPL5EMEMCHURN_test_nested_churn
 1380 PROCsection("L5E_MEMCHURN - TEMPORARY EXPRESSION CHURN")
 1390 PROCPL5EMEMCHURN_test_temp_expr_churn
 1400 PROCsection("L5E_MEMCHURN - POST-CHURN SANITY")
 1410 PROCPL5EMEMCHURN_test_post_sanity
 1420 PROCsection("L5F_TIMING_RANDOM - RND REPEATABILITY")
 1430 PROCPL5FTIMINGRANDOM_test_rnd_repeat
 1440 PROCsection("L5F_TIMING_RANDOM - RND RANGE TESTS")
 1450 PROCPL5FTIMINGRANDOM_test_rnd_range
 1460 PROCsection("L5F_TIMING_RANDOM - RND BASIC DISTRIBUTION")
 1470 PROCPL5FTIMINGRANDOM_test_rnd_distribution
 1480 PROCsection("L5F_TIMING_RANDOM - TIME BASIC BEHAVIOUR")
 1490 PROCPL5FTIMINGRANDOM_test_time_basic
 1500 PROCsection("L5F_TIMING_RANDOM - TIME WITH WORKLOAD")
 1510 PROCPL5FTIMINGRANDOM_test_time_workload
 1520 PROCsection("L5F_TIMING_RANDOM - POST TIME/RND SANITY")
 1530 PROCPL5FTIMINGRANDOM_test_post_sanity
 1540 PROCsection("L5G_STATEEDGE - DATA POINTER STATE")
 1550 PROCPL5GSTATEEDGE_test_data_state
 1560 PROCsection("L5G_STATEEDGE - ERROR INSIDE FN/PROC STATE")
 1570 PROCPL5GSTATEEDGE_test_error_fn_proc
 1580 PROCsection("L5G_STATEEDGE - GOSUB / RETURN STATE")
 1590 PROCPL5GSTATEEDGE_test_gosub_state
 1600 PROCsection("L5G_STATEEDGE - DIM / REDIM EDGE STATE")
 1610 PROCPL5GSTATEEDGE_test_dim_state
 1620 PROCsection("L5G_STATEEDGE - CONTROL-FLOW ERROR TRAPS")
 1630 PROCPL5GSTATEEDGE_test_control_errors
 1640 PROCsection("L5G_STATEEDGE - POST-EDGE SANITY")
 1650 PROCPL5GSTATEEDGE_test_post_sanity
 1660 PRINT
 1670 PRINT "-----------------------------------------------"
 1680 IF vFailIdx%>0 THEN PROCshow_failures
 1690 PRINT "TOTAL TESTS : ";vTest%
 1700 PRINT "PASSED      : ";vPass%
 1710 PRINT "FAILED      : ";vFail%
 1720 PRINT "-----------------------------------------------"
 1730 END
 1740 DEF PROCsection(sName$)
 1750 PRINT
 1760 PRINT sName$
 1770 PRINT STRING$(LEN(sName$),"-")
 1780 ENDPROC
 1790 DEF PROCok(sName$)
 1800 vTest%=vTest%+1
 1810 vPass%=vPass%+1
 1820 PRINT "PASS ";sName$
 1830 ENDPROC
 1840 DEF PROCbad_i(sName$,vGot%,vExp%)
 1850 vTest%=vTest%+1
 1860 vFail%=vFail%+1
 1870 IF vFailIdx%<200 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
 1880 PRINT "FAIL ";sName$;"  got=";vGot%;" expected=";vExp%
 1890 ENDPROC
 1900 DEF PROCbad_r(sName$,vGot,vExp)
 1910 vTest%=vTest%+1
 1920 vFail%=vFail%+1
 1930 IF vFailIdx%<200 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
 1940 PRINT "FAIL ";sName$;"  got=";vGot;" expected=";vExp
 1950 ENDPROC
 1960 DEF PROCbad_s(sName$,sGot$,sExp$)
 1970 vTest%=vTest%+1
 1980 vFail%=vFail%+1
 1990 IF vFailIdx%<200 THEN vFailName$(vFailIdx%)=sName$ : vFailIdx%=vFailIdx%+1
 2000 PRINT "FAIL ";sName$
 2010 PRINT "     got=""";sGot$;""""
 2020 PRINT "expected=""";sExp$;""""
 2030 ENDPROC
 2040 DEF PROCcheck_i(sName$,vGot%,vExp%)
 2050 IF vGot%=vExp% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vGot%,vExp%)
 2060 ENDPROC
 2070 DEF PROCcheck_r(sName$,vGot,vExp,vTol)
 2080 IF ABS(vGot-vExp)<=vTol THEN PROCok(sName$) ELSE PROCbad_r(sName$,vGot,vExp)
 2090 ENDPROC
 2100 DEF PROCcheck_s(sName$,sGot$,sExp$)
 2110 IF sGot$=sExp$ THEN PROCok(sName$) ELSE PROCbad_s(sName$,sGot$,sExp$)
 2120 ENDPROC
 2130 DEF PROCcheck_t(sName$,vFlag%)
 2140 IF vFlag% THEN PROCok(sName$) ELSE PROCbad_i(sName$,vFlag%,-1)
 2150 ENDPROC
 2160 DEF PROCshow_failures
 2170 LOCAL vI%
 2180 PRINT
 2190 PRINT "FAILED TEST NAMES:"
 2200 PRINT "------------------"
 2210 FOR vI%=0 TO vFailIdx%-1
 2220   PRINT vFailName$(vI%)
 2230 NEXT
 2240 ENDPROC
 2250 DEF PROCPL1CORE_test_numeric
 2260 LOCAL vN%
 2270 PROCcheck_i("precedence 7+5*3",7+5*3,22)
 2280 PROCcheck_i("brackets (7+5)*3",(7+5)*3,36)
 2290 PROCcheck_i("DIV",17 DIV 5,3)
 2300 PROCcheck_i("MOD",17 MOD 5,2)
 2310 vN%=123456
 2320 PROCcheck_i("integer assignment",vN%,123456)
 2330 PROCcheck_i("hex literal",&1234,4660)
 2340 PROCcheck_i("binary literal",%101101,45)
 2350 PROCcheck_i("TRUE",TRUE,-1)
 2360 PROCcheck_i("FALSE",FALSE,0)
 2370 PROCcheck_i("NOT FALSE",NOT FALSE,-1)
 2380 PROCcheck_i("AND",5 AND 3,1)
 2390 PROCcheck_i("OR",5 OR 2,7)
 2400 PROCcheck_i("EOR",5 EOR 3,6)
 2410 PROCcheck_i("shift left",1<<4,16)
 2420 PROCcheck_i("shift right",16>>2,4)
 2430 PROCcheck_r("ABS",ABS(-12.5),12.5,1E-9)
 2440 PROCcheck_i("INT positive",INT(99.8),99)
 2450 PROCcheck_i("INT negative",INT(-12.1),-13)
 2460 PROCcheck_i("SGN negative",SGN(-2),-1)
 2470 PROCcheck_i("SGN zero",SGN(0),0)
 2480 PROCcheck_i("SGN positive",SGN(3),1)
 2490 PROCcheck_r("SQR",SQR(81),9,1E-9)
 2500 PROCcheck_r("SIN(pi/2)",SIN(PI/2),1,1E-7)
 2510 PROCcheck_r("COS(0)",COS(0),1,1E-7)
 2520 PROCcheck_r("EXP(LN(5))",EXP(LN(5)),5,1E-7)
 2530 ENDPROC
 2540 DEF PROCPL1CORE_test_strings
 2550 LOCAL sA$,sB$,sC$
 2560 sA$="AGON"
 2570 sB$="BBC BASIC"
 2580 PROCcheck_i("LEN",LEN(sB$),9)
 2590 PROCcheck_s("LEFT$",LEFT$(sB$,3),"BBC")
 2600 PROCcheck_s("RIGHT$",RIGHT$(sB$,5),"BASIC")
 2610 PROCcheck_s("MID$ fixed",MID$(sB$,5,3),"BAS")
 2620 PROCcheck_s("MID$ to end",MID$(sB$,8),"IC")
 2630 PROCcheck_i("INSTR found",INSTR("HELLO WORLD","WORLD"),7)
 2640 PROCcheck_i("INSTR missing",INSTR("HELLO WORLD","ZZ"),0)
 2650 PROCcheck_i("ASC",ASC("A"),65)
 2660 PROCcheck_s("CHR$",CHR$(66),"B")
 2670 PROCcheck_i("VAL decimal",VAL("1234"),1234)
 2680 sC$="BBC BASIC"
 2690 LEFT$(sC$,3)="ZZ"
 2700 PROCcheck_s("LEFT$ assignment",sC$,"ZZC BASIC")
 2710 sC$="ABC"
 2720 sC$=sC$+"DEF"
 2730 PROCcheck_s("concatenation",sC$,"ABCDEF")
 2740 ENDPROC
 2750 DEF PROCPL1CORE_test_flow
 2760 LOCAL vI%,vSum%,vCnt%,vMark%,vDone%
 2770 vSum%=0
 2780 FOR vI%=1 TO 10
 2790   vSum%=vSum%+vI%
 2800 NEXT
 2810 PROCcheck_i("FOR/NEXT sum 1..10",vSum%,55)
 2820 vSum%=0
 2830 FOR vI%=5 TO 1 STEP -2
 2840   vSum%=vSum%+vI%
 2850 NEXT
 2860 PROCcheck_i("FOR STEP -2",vSum%,9)
 2870 vCnt%=0
 2880 REPEAT
 2890   vCnt%=vCnt%+1
 2900 UNTIL vCnt%=4
 2910 PROCcheck_i("REPEAT/UNTIL",vCnt%,4)
 2920 vCnt%=0
 2930 WHILE vCnt%<3
 2940   vCnt%=vCnt%+1
 2950 ENDWHILE
 2960 PROCcheck_i("WHILE/ENDWHILE",vCnt%,3)
 2970 vSum%=0
 2980 FOR vI%=1 TO 10
 2990   IF vI%=6 THEN EXIT FOR
 3000   vSum%=vSum%+vI%
 3010 NEXT
 3020 PROCcheck_i("EXIT FOR",vSum%,15)
 3030 vCnt%=0
 3040 REPEAT
 3050   vCnt%=vCnt%+1
 3060   IF vCnt%=3 THEN EXIT REPEAT
 3070 UNTIL FALSE
 3080 PROCcheck_i("EXIT REPEAT",vCnt%,3)
 3090 vCnt%=0
 3100 WHILE TRUE
 3110   vCnt%=vCnt%+1
 3120   IF vCnt%=2 THEN EXIT WHILE
 3130 ENDWHILE
 3140 PROCcheck_i("EXIT WHILE",vCnt%,2)
 3150 vMark%=0
 3160 ON 2 GOSUB 3970,3980,3990 ELSE 4000
 3170 PROCcheck_i("ON GOSUB",vMark%,22)
 3180 vDone%=0
 3190 IF 3<4 THEN vDone%=111 ELSE vDone%=222
 3200 PROCcheck_i("IF THEN ELSE single-line",vDone%,111)
 3210 vDone%=0
 3220 IF 2=2 THEN
 3230   vDone%=77
 3240 ELSE
 3250   vDone%=99
 3260 ENDIF
 3270 PROCcheck_i("IF THEN ENDIF multi-line",vDone%,77)
 3280 ENDPROC
 3290 DEF PROCPL1CORE_test_procfn
 3300 LOCAL vOut%,vTmp%
 3310 PROCPL1CORE_double(7,vOut%)
 3320 PROCcheck_i("PROC parameter writeback",vOut%,14)
 3330 PROCcheck_i("FN square",FNPL1CORE_square(9),81)
 3340 PROCcheck_i("recursive FN factorial",FNPL1CORE_fact(6),720)
 3350 PROCcheck_s("FN reverse",FNPL1CORE_reverse("AGON"),"NOGA")
 3360 ENDPROC
 3370 DEF PROCPL1CORE_test_data
 3380 LOCAL vA%,vB%,sA$,sB$
 3390 RESTORE 4010
 3400 READ vA%,vB%,sA$
 3410 PROCcheck_i("READ item 1",vA%,10)
 3420 PROCcheck_i("READ item 2",vB%,20)
 3430 PROCcheck_s("READ item 3",sA$,"THIRTY")
 3440 RESTORE 4020
 3450 READ sB$
 3460 PROCcheck_s("RESTORE to line",sB$,"ALPHA")
 3470 ENDPROC
 3480 DEF PROCPL1CORE_test_arrays
 3490 DIM aI%(2)
 3500 aI%()=1,2,3
 3510 PROCcheck_i("array element 0",aI%(0),1)
 3520 PROCcheck_i("array element 2",aI%(2),3)
 3530 PROCcheck_i("SUM integer array",SUM(aI%()),6)
 3540 DIM bI%(2)
 3550 bI%()=10
 3560 PROCcheck_i("single-value array init 0",bI%(0),10)
 3570 PROCcheck_i("single-value array init 2",bI%(2),10)
 3580 bI%()=bI%()+aI%()
 3590 PROCcheck_i("whole-array add 0",bI%(0),11)
 3600 PROCcheck_i("whole-array add 1",bI%(1),12)
 3610 PROCcheck_i("whole-array add 2",bI%(2),13)
 3620 DIM aR(2)
 3630 aR()=3,4,12
 3640 PROCcheck_r("array MOD function",MOD(aR()),13,1E-7)
 3650 DIM aS$(2)
 3660 aS$()="AG","ON","!"
 3670 PROCcheck_s("SUM string array",SUM(aS$()),"AGON!")
 3680 PROCcheck_i("SUMLEN string array",SUMLEN(aS$()),5)
 3690 ENDPROC
 3700 DEF PROCPL1CORE_test_memory
 3710 LOCAL vBase%,vP%,vR%,vS%
 3720 DIM mBlk% 31
 3730 vBase%=mBlk%
 3740 ?vBase%=&12
 3750 vBase%?1=&34
 3760 PROCcheck_i("? unary read",?vBase%,&12)
 3770 PROCcheck_i("? dyadic read",vBase%?1,&34)
 3780 vP%=vBase%+4
 3790 !vP%=&12345678
 3800 PROCcheck_i("! read back",!vP%,&12345678)
 3810 PROCcheck_i("! byte 0",vP%?0,&78)
 3820 PROCcheck_i("! byte 1",vP%?1,&56)
 3830 PROCcheck_i("! byte 2",vP%?2,&34)
 3840 PROCcheck_i("! byte 3",vP%?3,&12)
 3850 vR%=vBase%+12
 3860 |vR%=PI
 3870 PROCcheck_r("| read back",|vR%,PI,1E-7)
 3880 vS%=vBase%+20
 3890 $vS%="ABCDEF"
 3900 PROCcheck_s("$ read back",$vS%,"ABCDEF")
 3910 ENDPROC
 3920 DEF PROCPL1CORE_test_errors
 3930 LOCAL vErr%
 3940 PROCPL1CORE_divzero(vErr%)
 3950 PROCcheck_i("ON ERROR LOCAL catches div/0",vErr%,18)
 3960 ENDPROC
 3970 vMark%=11 : RETURN
 3980 vMark%=22 : RETURN
 3990 vMark%=33 : RETURN
 4000 vMark%=44 : RETURN
 4010 DATA 10,20,"THIRTY"
 4020 DATA "ALPHA","BETA","GAMMA"
 4030 DEF PROCPL1CORE_double(vIn%,RETURN vOut%)
 4040 vOut%=vIn%*2
 4050 ENDPROC
 4060 DEF FNPL1CORE_square(vN)=vN*vN
 4070 DEF FNPL1CORE_fact(vN)
 4080 IF vN<2 THEN =1
 4090 =vN*FNPL1CORE_fact(vN-1)
 4100 DEF FNPL1CORE_reverse(sA$)
 4110 LOCAL sB$,vI%
 4120 FOR vI%=1 TO LEN(sA$)
 4130   sB$=MID$(sA$,vI%,1)+sB$
 4140 NEXT
 4150 =sB$
 4160 DEF PROCPL1CORE_divzero(RETURN vErr%)
 4170 LOCAL vX%
 4180 ON ERROR LOCAL vErr%=ERR : ENDPROC
 4190 vX%=1/0
 4200 vErr%=0
 4210 ENDPROC
 4220 DEF PROCPL2EDGE_test_num2
 4230 LOCAL vA,vB,vI%,vJ%,vK%
 4240 PROCcheck_r("0.1+0.2 approx",0.1+0.2,0.3,1E-6)
 4250 PROCcheck_r("1E-30 * 1E30",1E-30*1E30,1,1E-6)
 4260 PROCcheck_r("1E20 / 1E10",1E20/1E10,1E10,1E4)
 4270 PROCcheck_i("INT near integer low",INT(1.9999999),1)
 4280 PROCcheck_i("INT near integer neg",INT(-1.0000001),-2)
 4290 PROCcheck_i("round trip integer",VAL(STR$(12345)),12345)
 4300 vI%=5
 4310 vI%+=3
 4320 PROCcheck_i("compound += integer",vI%,8)
 4330 vI%*=2
 4340 PROCcheck_i("compound *= integer",vI%,16)
 4350 vI% DIV= 3
 4360 PROCcheck_i("compound DIV=",vI%,5)
 4370 vI% MOD= 3
 4380 PROCcheck_i("compound MOD=",vI%,2)
 4390 vI%=6
 4400 vI% AND= 3
 4410 PROCcheck_i("compound AND=",vI%,2)
 4420 vI%=6
 4430 vI% OR= 1
 4440 PROCcheck_i("compound OR=",vI%,7)
 4450 vI%=6
 4460 vI% EOR= 3
 4470 PROCcheck_i("compound EOR=",vI%,5)
 4480 PROCcheck_i("shift right positive",8>>1,4)
 4490 PROCcheck_t("comparison chaining",(3<4) AND (4<5))
 4500 ENDPROC
 4510 DEF PROCPL2EDGE_test_str2
 4520 LOCAL sA$,sB$,sC$
 4530 sA$=""
 4540 PROCcheck_i("LEN empty",LEN(sA$),0)
 4550 PROCcheck_s("concat empty left",sA$+"ABC","ABC")
 4560 PROCcheck_s("concat empty right","ABC"+sA$,"ABC")
 4570 PROCcheck_i("INSTR empty needle",INSTR("ABC",""),0):REM Russell variant
 4580 PROCcheck_i("INSTR empty haystack",INSTR("","A"),0)
 4590 sA$="ABCDE"
 4600 MID$(sA$,2,2)="XY"
 4610 PROCcheck_s("MID$ replace middle",sA$,"AXYDE")
 4620 sA$="ABCDE"
 4630 LEFT$(sA$,5)="XYZ"
 4640 PROCcheck_s("LEFT$ short assign",sA$,"XYZDE")
 4650 sA$="ABCDE"
 4660 MID$(sA$,3)="Z"
 4670 PROCcheck_s("MID$ tail assign",sA$,"ABZDE")
 4680 sB$=STRING$(20,"Q")
 4690 PROCcheck_i("STRING$ length",LEN(sB$),20)
 4700 PROCcheck_s("STRING$ content",LEFT$(sB$,4),"QQQQ")
 4710 sC$="A"+CHR$(0)+"B"
 4720 PROCcheck_i("ASC first byte",ASC(sC$),65)
 4730 ENDPROC
 4740 DEF PROCPL2EDGE_test_flow2
 4750 LOCAL vI%,vJ%,vSum%,vCnt%,vX%,vY%,vNox%,vIf1%
 4760 REM keyword adjacency tests
 4770 vNox%=123
 4780 PROCcheck_i("variable near keyword ON",vNox%,123)
 4790 vIf1%=77
 4800 PROCcheck_i("variable near keyword IF",vIf1%,77)
 4810 REM compact-spacing tests
 4820 vX%=0
 4830 IF 1=1 THENvX%=5
 4840 PROCcheck_i("IF THEN minimal spaces",vX%,5)
 4850 vSum%=0
 4860 FOR vI%=1TO5
 4870 vSum%=vSum%+vI%
 4880 NEXT
 4890 PROCcheck_i("FOR compact spacing",vSum%,15)
 4900 vCnt%=0
 4910 REPEAT
 4920 vCnt%=vCnt%+1
 4930 UNTIL vCnt%=3
 4940 PROCcheck_i("UNTIL compact spacing",vCnt%,3)
 4950 vY%=0
 4960 vMark%=0
 4970 ON 9 GOSUB 5400,5410 ELSE vMark%=44
 4980 PROCcheck_i("ON...ELSE out of range",vMark%,44)
 4990 vSum%=0
 5000 FOR vI%=1 TO 3
 5010   FOR vJ%=1 TO 3
 5020     IF vJ%=2 THEN EXIT FOR
 5030     vSum%=vSum%+10*vI%+vJ%
 5040   NEXT
 5050 NEXT
 5060 PROCcheck_i("nested EXIT FOR inner only",vSum%,63)
 5070 ENDPROC
 5080 DEF PROCPL2EDGE_test_arr2
 5090 DIM l2AI%(4)
 5100 DIM l2BI%(4)
 5110 DIM l2AR(2)
 5120 DIM l2AS$(3)
 5130 l2AI%()=1,2,3
 5140 PROCcheck_i("partial init keep old last",l2AI%(3),0)
 5150 PROCcheck_i("partial init keep old last2",l2AI%(4),0)
 5160 l2BI%()=9
 5170 PROCcheck_i("single init all 0",l2BI%(0),9)
 5180 PROCcheck_i("single init all 4",l2BI%(4),9)
 5190 l2BI%()+=1
 5200 PROCcheck_i("array += elem0",l2BI%(0),10)
 5210 PROCcheck_i("array += elem4",l2BI%(4),10)
 5220 l2AI%()=1,2,3,4,5
 5230 l2BI%()=5,4,3,2,1
 5240 l2AI%()=l2AI%()+l2BI%()
 5250 PROCcheck_i("array+array elem0",l2AI%(0),6)
 5260 PROCcheck_i("array+array elem4",l2AI%(4),6)
 5270 l2AR()=3,4,12
 5280 PROCcheck_r("MOD array rms vector",MOD(l2AR()),13,1E-6)
 5290 l2AS$()="A","BB","CCC","DDDD"
 5300 PROCcheck_s("SUM string array",SUM(l2AS$()),"ABBCCCDDDD")
 5310 PROCcheck_i("SUMLEN string array",SUMLEN(l2AS$()),10)
 5320 ENDPROC
 5330 DEF PROCPL2EDGE_test_err2
 5340 LOCAL vErr%,vErl%,sRep$
 5350 PROCPL2EDGE_err_div(vErr%,vErl%,sRep$)
 5360 PROCcheck_i("ERR div zero",vErr%,18)
 5370 PROCcheck_i("ERL div zero",vErl%,5460)
 5380 PROCcheck_t("REPORT$ non-empty",LEN(sRep$)<>0)
 5390 ENDPROC
 5400 vMark%=11 : RETURN
 5410 vMark%=22 : RETURN
 5420 vMark%=44 : RETURN
 5430 DEF PROCPL2EDGE_err_div(RETURN vErr%,RETURN vErl%,RETURN sRep$)
 5440 LOCAL vA%
 5450 ON ERROR LOCAL vErr%=ERR : vErl%=ERL : sRep$=REPORT$ : ENDPROC
 5460 vA%=1/0
 5470 vErr%=0 : vErl%=0 : sRep$=""
 5480 ENDPROC
 5490 DEF PROCPL3ASTRESS_test_loops
 5500 LOCAL vI%,vJ%,vK%,vSum%,vCnt%
 5510 vSum%=0
 5520 FOR vI%=1 TO 200
 5530   vSum%=vSum%+vI%
 5540 NEXT
 5550 PROCcheck_i("FOR sum 1..200",vSum%,20100)
 5560 vSum%=0
 5570 FOR vI%=1 TO 20
 5580   FOR vJ%=1 TO 10
 5590     vSum%=vSum%+vI%+vJ%
 5600   NEXT
 5610 NEXT
 5620 PROCcheck_i("nested FOR sum",vSum%,3200)
 5630 vCnt%=0
 5640 REPEAT
 5650   vCnt%=vCnt%+1
 5660 UNTIL vCnt%=250
 5670 PROCcheck_i("REPEAT 250 iterations",vCnt%,250)
 5680 vCnt%=0
 5690 WHILE vCnt%<300
 5700   vCnt%=vCnt%+1
 5710 ENDWHILE
 5720 PROCcheck_i("WHILE 300 iterations",vCnt%,300)
 5730 vGosub%=0
 5740 FOR vI%=1 TO 100
 5750   GOSUB 7150
 5760 NEXT
 5770 PROCcheck_i("100 GOSUB/RETURN cycles",vGosub%,100)
 5780 ENDPROC
 5790 DEF PROCPL3ASTRESS_test_stack
 5800 LOCAL vI%,vOut%,vSum%
 5810 PROCcheck_i("recursive factorial 10",FNPL3ASTRESS_fact(10),3628800)
 5820 PROCcheck_i("recursive fibonacci 12",FNPL3ASTRESS_fib(12),144)
 5830 vSum%=0
 5840 FOR vI%=1 TO 100
 5850   PROCPL3ASTRESS_small(vI%,vOut%)
 5860   vSum%=vSum%+vOut%
 5870 NEXT
 5880 PROCcheck_i("100 PROC calls with return",vSum%,10100)
 5890 PROCPL3ASTRESS_nested_a(5,vOut%)
 5900 PROCcheck_i("nested PROC chain",vOut%,15)
 5910 ENDPROC
 5920 DEF PROCPL3ASTRESS_test_strings
 5930 LOCAL sA$,sB$,vI%,vLen%
 5940 sA$=""
 5950 FOR vI%=1 TO 200
 5960   sA$=sA$+"A"
 5970 NEXT
 5980 PROCcheck_i("string build length 200",LEN(sA$),200)
 5990 PROCcheck_s("string build left",LEFT$(sA$,5),"AAAAA")
 6000 PROCcheck_s("string build right",RIGHT$(sA$,5),"AAAAA")
 6010 sB$=""
 6020 FOR vI%=1 TO 50
 6030   sB$=sB$+CHR$(64+(vI% MOD 26)+1)
 6040 NEXT
 6050 PROCcheck_i("mixed string length 50",LEN(sB$),50)
 6060 PROCcheck_s("mixed string prefix",LEFT$(sB$,6),"BCDEFG")
 6070 PROCcheck_s("mixed string middle",MID$(sB$,25,4),"ZABC")
 6080 FOR vI%=1 TO 20
 6090   MID$(sB$,vI%,1)="Z"
 6100 NEXT
 6110 PROCcheck_s("repeated MID$ assignment",LEFT$(sB$,20),STRING$(20,"Z"))
 6120 ENDPROC
 6130 DEF PROCPL3ASTRESS_test_arrays
 6140 LOCAL vI%,vSum%,vOut%
 6150 FOR vI%=0 TO 49
 6160   c3%(vI%)=vI%
 6170 NEXT
 6180 vSum%=0
 6190 FOR vI%=0 TO 49
 6200   vSum%=vSum%+c3%(vI%)
 6210 NEXT
 6220 PROCcheck_i("array sum 0..49",vSum%,1225)
 6230 FOR vI%=0 TO 49
 6240   c3%(vI%)=c3%(vI%)*2
 6250 NEXT
 6260 PROCcheck_i("array doubled first",c3%(0),0)
 6270 PROCcheck_i("array doubled middle",c3%(25),50)
 6280 PROCcheck_i("array doubled last",c3%(49),98)
 6290 vSum%=0
 6300 FOR vI%=1 TO 20
 6310   PROCPL3ASTRESS_reuse_array(vI%,vOut%)
 6320   vSum%=vSum%+vOut%
 6330 NEXT
 6340 PROCcheck_i("20 reused array fills",vSum%,5760)
 6350 ENDPROC
 6360 DEF PROCPL3ASTRESS_test_memory
 6370 LOCAL mBlk%,vBase%,vI%,vSum%,vP%
 6380 DIM mBlk% 255
 6390 vBase%=mBlk%
 6400 FOR vI%=0 TO 127
 6410   vBase%?vI%=vI%
 6420 NEXT
 6430 vSum%=0
 6440 FOR vI%=0 TO 127
 6450   vSum%=vSum%+(vBase%?vI%)
 6460 NEXT
 6470 PROCcheck_i("128 byte write/read sum",vSum%,8128)
 6480 vP%=vBase%+128
 6490 FOR vI%=0 TO 7
 6500   !(vP%+vI%*4)=&01020304+vI%
 6510 NEXT
 6520 PROCcheck_i("word stress first",!vP%,&01020304)
 6530 PROCcheck_i("word stress last",!(vP%+28),&0102030B)
 6540 ENDPROC
 6550 DEF PROCPL3ASTRESS_test_errors
 6560 LOCAL vI%,vErr%,vGood%
 6570 vGood%=0
 6580 FOR vI%=1 TO 25
 6590   PROCPL3ASTRESS_catch_div(vErr%)
 6600   IF vErr%=18 THEN vGood%=vGood%+1
 6610 NEXT
 6620 PROCcheck_i("25 trapped div zero errors",vGood%,25)
 6630 vGood%=0
 6640 FOR vI%=1 TO 25
 6650   PROCPL3ASTRESS_normal_after_error(vErr%)
 6660   IF vErr%=0 THEN vGood%=vGood%+1
 6670 NEXT
 6680 PROCcheck_i("normal execution after errors",vGood%,25)
 6690 ENDPROC
 6700 DEF FNPL3ASTRESS_fact(vN%)
 6710 IF vN%<2 THEN =1
 6720 =vN%*FNPL3ASTRESS_fact(vN%-1)
 6730 DEF FNPL3ASTRESS_fib(vN%)
 6740 IF vN%<2 THEN =vN%
 6750 =FNPL3ASTRESS_fib(vN%-1)+FNPL3ASTRESS_fib(vN%-2)
 6760 DEF PROCPL3ASTRESS_small(vIn%,RETURN vOut%)
 6770 LOCAL vTmp%
 6780 vTmp%=vIn%*2
 6790 vOut%=vTmp%
 6800 ENDPROC
 6810 DEF PROCPL3ASTRESS_nested_a(vN%,RETURN vOut%)
 6820 LOCAL vTmp%
 6830 PROCPL3ASTRESS_nested_b(vN%,vTmp%)
 6840 vOut%=vTmp%+1
 6850 ENDPROC
 6860 DEF PROCPL3ASTRESS_nested_b(vN%,RETURN vOut%)
 6870 LOCAL vTmp%
 6880 PROCPL3ASTRESS_nested_c(vN%,vTmp%)
 6890 vOut%=vTmp%+2
 6900 ENDPROC
 6910 DEF PROCPL3ASTRESS_nested_c(vN%,RETURN vOut%)
 6920 vOut%=vN%+7
 6930 ENDPROC
 6940 DEF PROCPL3ASTRESS_reuse_array(vSeed%,RETURN vOut%)
 6950 LOCAL vI%,vSum%
 6960 vSum%=0
 6970 FOR vI%=0 TO 15
 6980   d3%(vI%)=vSeed%+vI%
 6990   vSum%=vSum%+d3%(vI%)
 7000 NEXT
 7010 vOut%=vSum%
 7020 ENDPROC
 7030 DEF PROCPL3ASTRESS_catch_div(RETURN vErr%)
 7040 LOCAL vX%
 7050 ON ERROR LOCAL vErr%=ERR : ENDPROC
 7060 vX%=1/0
 7070 vErr%=0
 7080 ENDPROC
 7090 DEF PROCPL3ASTRESS_normal_after_error(RETURN vErr%)
 7100 LOCAL vX%
 7110 vX%=10
 7120 vX%=vX%+5
 7130 IF vX%=15 THEN vErr%=0 ELSE vErr%=-1
 7140 ENDPROC
 7150 vGosub%=vGosub%+1 : RETURN
 7160 DEF PROCPL3BFILEIO_test_bytefile
 7170 LOCAL vCh%,vI%,vB%,vSum%
 7180 vCh%=OPENOUT("B3BBIN.DAT")
 7190 PROCcheck_t("OPENOUT byte file",vCh%<>0)
 7200 FOR vI%=0 TO 15
 7210   BPUT#vCh%,vI%*3
 7220 NEXT
 7230 CLOSE#vCh%
 7240 vCh%=OPENIN("B3BBIN.DAT")
 7250 PROCcheck_i("EXT# after 16 BPUT",EXT#vCh%,16)
 7260 CLOSE#vCh%
 7270 vCh%=OPENIN("B3BBIN.DAT")
 7280 PROCcheck_t("OPENIN byte file",vCh%<>0)
 7290 vSum%=0
 7300 FOR vI%=0 TO 15
 7310   vB%=BGET#vCh%
 7320   vSum%=vSum%+vB%
 7330 NEXT
 7340 PROCcheck_i("byte file sum",vSum%,360)
 7350 PROCcheck_t("EOF# after byte reads",EOF#vCh%)
 7360 CLOSE#vCh%
 7370 ENDPROC
 7380 DEF PROCPL3BFILEIO_test_seqfile
 7390 LOCAL vCh%,vA%,vB%,vC%,sA$,sB$
 7400 vCh%=OPENOUT("B3BSEQ.DAT")
 7410 PROCcheck_t("OPENOUT seq file",vCh%<>0)
 7420 PRINT#vCh%,12345
 7430 PRINT#vCh%,-6789
 7440 PRINT#vCh%,"HELLO"
 7450 PRINT#vCh%,"BBC BASIC"
 7460 CLOSE#vCh%
 7470 vCh%=OPENIN("B3BSEQ.DAT")
 7480 PROCcheck_t("OPENIN seq file",vCh%<>0)
 7490 INPUT#vCh%,vA%
 7500 INPUT#vCh%,vB%
 7510 INPUT#vCh%,sA$
 7520 INPUT#vCh%,sB$
 7530 PROCcheck_i("INPUT# integer positive",vA%,12345)
 7540 PROCcheck_i("INPUT# integer negative",vB%,-6789)
 7550 PROCcheck_s("INPUT# string one",sA$,"HELLO")
 7560 PROCcheck_s("INPUT# string two",sB$,"BBC BASIC")
 7570 PROCcheck_t("EOF# after seq reads",EOF#vCh%)
 7580 CLOSE#vCh%
 7590 ENDPROC
 7600 DEF PROCPL3BFILEIO_test_filepos
 7610 LOCAL vCh%,vI%,vB%
 7620 vCh%=OPENOUT("B3BPOS.DAT")
 7630 PROCcheck_t("OPENOUT pos file",vCh%<>0)
 7640 FOR vI%=1 TO 10
 7650   BPUT#vCh%,vI%
 7660 NEXT
 7670 CLOSE#vCh%
 7680 vCh%=OPENIN("B3BPOS.DAT")
 7690 PROCcheck_i("EXT# pos file",EXT#vCh%,10)
 7700 CLOSE#vCh%
 7710 vCh%=OPENIN("B3BPOS.DAT")
 7720 PROCcheck_t("OPENIN pos file",vCh%<>0)
 7730 PROCcheck_i("PTR# initial",PTR#vCh%,0)
 7740 vB%=BGET#vCh%
 7750 PROCcheck_i("first BGET#",vB%,1)
 7760 PROCcheck_i("PTR# after one byte",PTR#vCh%,1)
 7770 PTR#vCh%=5
 7780 PROCcheck_i("PTR# seek to 5",PTR#vCh%,5)
 7790 vB%=BGET#vCh%
 7800 PROCcheck_i("BGET# after seek",vB%,6)
 7810 PTR#vCh%=9
 7820 vB%=BGET#vCh%
 7830 PROCcheck_i("BGET# final byte",vB%,10)
 7840 PROCcheck_t("EOF# final byte",EOF#vCh%)
 7850 CLOSE#vCh%
 7860 ENDPROC
 7870 DEF PROCPL4AEVAL_test_prec
 7880 PROCcheck_i("mul before add",2+3*4,14)
 7890 PROCcheck_i("brackets override",(2+3)*4,20)
 7900 PROCcheck_i("unary minus precedence",-2*3,-6)
 7910 PROCcheck_i("nested brackets",((2+3)*(4+5)),45)
 7920 PROCcheck_i("DIV before add",2+17 DIV 5,5)
 7930 PROCcheck_i("MOD before add",2+17 MOD 5,4)
 7940 PROCcheck_i("shift after add",(1+3)<<2,16)
 7950 PROCcheck_i("AND precedence",(7 AND 3)+10,13)
 7960 PROCcheck_i("OR precedence",8 OR 2+1,11)
 7970 PROCcheck_i("EOR precedence",15 EOR 5,10)
 7980 PROCcheck_i("relational TRUE",3*4=12,TRUE)
 7990 PROCcheck_i("relational FALSE",3*4=13,FALSE)
 8000 PROCcheck_i("boolean expression",(3<4) AND (5>2),TRUE)
 8010 PROCcheck_i("boolean expression false",(3<4) AND (5<2),FALSE)
 8020 ENDPROC
 8030 DEF PROCPL4AEVAL_test_eval_num
 8040 LOCAL vA%,vB%,vC%,vR
 8050 vA%=10 : vB%=5 : vC%=3
 8060 PROCcheck_i("EVAL simple",EVAL("2+3*4"),14)
 8070 PROCcheck_i("EVAL brackets",EVAL("(2+3)*4"),20)
 8080 PROCcheck_i("EVAL variables",EVAL("vA%+vB%*vC%"),25)
 8090 PROCcheck_i("EVAL DIV MOD",EVAL("17 DIV 5 + 17 MOD 5"),5)
 8100 PROCcheck_i("EVAL hex",EVAL("&10+&20"),48)
 8110 PROCcheck_i("EVAL binary",EVAL("%1010+%0101"),15)
 8120 PROCcheck_r("EVAL real",EVAL("SQR(81)+SIN(PI/2)"),10,1E-6)
 8130 vR=EVAL("EXP(LN(7))")
 8140 PROCcheck_r("EVAL EXP/LN",vR,7,1E-6)
 8150 PROCcheck_i("EVAL comparison true",EVAL("3<4"),TRUE)
 8160 PROCcheck_i("EVAL comparison false",EVAL("3>4"),FALSE)
 8170 ENDPROC
 8180 DEF PROCPL4AEVAL_test_eval_str
 8190 LOCAL sA$,sB$,sC$
 8200 sA$="HELLO"
 8210 sB$="WORLD"
 8220 PROCcheck_s("EVAL string literal",EVAL("""ABC"""),"ABC")
 8230 PROCcheck_s("EVAL string concat",EVAL("""AB""+""CD"""),"ABCD")
 8240 PROCcheck_s("EVAL string variables",EVAL("sA$+"" ""+sB$"),"HELLO WORLD")
 8250 PROCcheck_s("EVAL LEFT$",EVAL("LEFT$(sA$,2)"),"HE")
 8260 PROCcheck_s("EVAL MID$",EVAL("MID$(sB$,2,3)"),"ORL")
 8270 PROCcheck_i("EVAL LEN string",EVAL("LEN(sA$+sB$)"),10)
 8280 sC$="CHR$(65)+CHR$(66)+CHR$(67)"
 8290 PROCcheck_s("EVAL generated string expr",EVAL(sC$),"ABC")
 8300 ENDPROC
 8310 DEF PROCPL4AEVAL_test_genexpr
 8320 LOCAL sE$,vI%,vGot%,vExp%
 8330 sE$=""
 8340 FOR vI%=1 TO 10
 8350   IF vI%=1 THEN sE$=STR$(vI%) ELSE sE$=sE$+"+"+STR$(vI%)
 8360 NEXT
 8370 vGot%=EVAL(sE$)
 8380 PROCcheck_i("generated sum 1..10",vGot%,55)
 8390 sE$="1"
 8400 FOR vI%=1 TO 8
 8410   sE$="("+sE$+"*2)"
 8420 NEXT
 8430 PROCcheck_i("generated nested multiply",EVAL(sE$),256)
 8440 sE$="0"
 8450 FOR vI%=1 TO 16
 8460   sE$=sE$+"+1"
 8470 NEXT
 8480 PROCcheck_i("generated long flat expr",EVAL(sE$),16)
 8490 sE$="(3+4)*(5+6)-7"
 8500 PROCcheck_i("generated fixed complex",EVAL(sE$),70)
 8510 ENDPROC
 8520 DEF PROCPL4AEVAL_test_nestedfn
 8530 LOCAL vA%,vB%,vC%
 8540 PROCcheck_i("nested FN direct",FNPL4AEVAL_twice(FNPL4AEVAL_add3(4)),14)
 8550 PROCcheck_i("FN inside expression",FNPL4AEVAL_add3(4)*FNPL4AEVAL_twice(5),70)
 8560 vA%=3 : vB%=4
 8570 PROCcheck_i("EVAL FN call",EVAL("FNPL4AEVAL_add3(vA%)+FNPL4AEVAL_twice(vB%)"),14)
 8580 PROCcheck_i("recursive expression FN",FNPL4AEVAL_exprsum(10),55)
 8590 PROCcheck_i("nested recursive FN",FNPL4AEVAL_twice(FNPL4AEVAL_exprsum(5)),30)
 8600 ENDPROC
 8610 DEF FNPL4AEVAL_add3(vN%)
 8620 =vN%+3
 8630 DEF FNPL4AEVAL_twice(vN%)
 8640 =vN%*2
 8650 DEF FNPL4AEVAL_exprsum(vN%)
 8660 IF vN%<1 THEN =0
 8670 =vN%+FNPL4AEVAL_exprsum(vN%-1)
 8680 DEF PROCPL4BFLOAT_test_basicreal
 8690 PROCcheck_r("0.5 + 0.25",0.5+0.25,0.75,1E-9)
 8700 PROCcheck_r("0.1 + 0.2 approx",0.1+0.2,0.3,1E-6)
 8710 PROCcheck_r("10 / 4",10/4,2.5,1E-9)
 8720 PROCcheck_r("1 / 3 * 3",(1/3)*3,1,1E-6)
 8730 PROCcheck_r("SQR(2)^2",SQR(2)*SQR(2),2,1E-6)
 8740 PROCcheck_r("SQR(3)^2",SQR(3)*SQR(3),3,1E-6)
 8750 PROCcheck_r("large multiply/divide",(12345.678*1000)/1000,12345.678,1E-3)
 8760 PROCcheck_r("small multiply/divide",(0.000123456*1000000)/1000000,0.000123456,1E-10)
 8770 ENDPROC
 8780 DEF PROCPL4BFLOAT_test_trans
 8790 PROCcheck_r("SIN(0)",SIN(0),0,1E-7)
 8800 PROCcheck_r("COS(0)",COS(0),1,1E-7)
 8810 PROCcheck_r("SIN(PI/2)",SIN(PI/2),1,1E-6)
 8820 PROCcheck_r("COS(PI)",COS(PI),-1,1E-6)
 8830 PROCcheck_r("SIN(PI)",SIN(PI),0,1E-5)
 8840 PROCcheck_r("TAN(PI/4)",TAN(PI/4),1,1E-5)
 8850 PROCcheck_r("ATN(1)",ATN(1),PI/4,1E-6)
 8860 PROCcheck_r("EXP(0)",EXP(0),1,1E-9)
 8870 PROCcheck_r("LN(EXP(3))",LN(EXP(3)),3,1E-6)
 8880 PROCcheck_r("EXP(LN(12.5))",EXP(LN(12.5)),12.5,1E-5)
 8890 ENDPROC
 8900 DEF PROCPL4BFLOAT_test_round
 8910 PROCcheck_i("INT 1.999",INT(1.999),1)
 8920 PROCcheck_i("INT 2.000",INT(2.000),2)
 8930 PROCcheck_i("INT -1.001",INT(-1.001),-2)
 8940 PROCcheck_i("INT -1.000",INT(-1.000),-1)
 8950 PROCcheck_i("SGN tiny positive",SGN(1E-20),1)
 8960 PROCcheck_i("SGN tiny negative",SGN(-1E-20),-1)
 8970 PROCcheck_i("SGN zero",SGN(0),0)
 8980 PROCcheck_r("ABS tiny",ABS(-1E-20),1E-20,1E-25)
 8990 ENDPROC
 9000 DEF PROCPL4BFLOAT_test_precision
 9010 LOCAL vA,vB,vC
 9020 vA=1000000
 9030 vB=(vA+1)-vA
 9040 PROCcheck_r("(1E6+1)-1E6",vB,1,1E-5)
 9050 vA=10000000
 9060 vB=(vA+1)-vA
 9070 PROCcheck_r("(1E7+1)-1E7",vB,1,1E-4)
 9080 vA=1E-20
 9090 vB=vA*1E20
 9100 PROCcheck_r("1E-20 * 1E20",vB,1,1E-6)
 9110 vC=1E20/1E10
 9120 PROCcheck_r("1E20 / 1E10",vC,1E10,1E4)
 9130 PROCcheck_t("positive tiny nonzero",1E-30>0)
 9140 PROCcheck_t("negative tiny below zero",-1E-30<0)
 9150 ENDPROC
 9160 DEF PROCPL4BFLOAT_test_accum
 9170 LOCAL vI%,vS,vT
 9180 vS=0
 9190 FOR vI%=1 TO 100
 9200   vS=vS+0.1
 9210 NEXT
 9220 PROCcheck_r("sum 0.1 x100",vS,10,1E-4)
 9230 vS=1
 9240 FOR vI%=1 TO 50
 9250   vS=vS*1.01
 9260 NEXT
 9270 PROCcheck_r("compound growth 1.01^50",vS,1.64463,1E-4)
 9280 vT=1
 9290 FOR vI%=1 TO 50
 9300   vT=vT/1.01
 9310 NEXT
 9320 PROCcheck_r("growth then shrink",vS*vT,1,1E-4)
 9330 vS=0
 9340 FOR vI%=1 TO 1000
 9350   vS=vS+1
 9360 NEXT
 9370 PROCcheck_r("sum 1 x1000",vS,1000,1E-6)
 9380 ENDPROC
 9390 DEF PROCPL4CLOCALDIM_test_basic_localdim
 9400 LOCAL aR(),aI%()
 9410 DIM aR(9)
 9420 DIM aI%(9)
 9430 aR(0)=1.25 : aR(9)=9.75
 9440 aI%(0)=123 : aI%(9)=456
 9450 PROCcheck_r("local real array first",aR(0),1.25,1E-9)
 9460 PROCcheck_r("local real array last",aR(9),9.75,1E-9)
 9470 PROCcheck_i("local integer array first",aI%(0),123)
 9480 PROCcheck_i("local integer array last",aI%(9),456)
 9490 ENDPROC
 9500 DEF PROCPL4CLOCALDIM_test_many_localdim
 9510 LOCAL aR(),bR(),cI%(),dI%()
 9520 DIM aR(3)
 9530 DIM bR(4)
 9540 DIM cI%(5)
 9550 DIM dI%(6)
 9560 aR(3)=33.25
 9570 bR(4)=44.5
 9580 cI%(5)=55
 9590 dI%(6)=66
 9600 PROCcheck_r("many locals real a",aR(3),33.25,1E-9)
 9610 PROCcheck_r("many locals real b",bR(4),44.5,1E-9)
 9620 PROCcheck_i("many locals integer c",cI%(5),55)
 9630 PROCcheck_i("many locals integer d",dI%(6),66)
 9640 ENDPROC
 9650 DEF PROCPL4CLOCALDIM_test_repeat_localdim
 9660 LOCAL vI%,vGood%
 9670 vGood%=0
 9680 FOR vI%=1 TO 200
 9690   IF FNPL4CLOCALDIM_basic_localdim_ok THEN vGood%=vGood%+1
 9700 NEXT
 9710 PROCcheck_i("200 repeated local DIM calls",vGood%,200)
 9720 ENDPROC
 9730 DEF PROCPL4CLOCALDIM_test_nested_localdim
 9740 LOCAL vOut%
 9750 PROCPL4CLOCALDIM_nested_outer(20,vOut%)
 9760 PROCcheck_i("nested local arrays preserved",vOut%,1)
 9770 ENDPROC
 9780 DEF PROCPL4CLOCALDIM_test_fn_localdim
 9790 PROCcheck_i("FN local integer array sum",FNPL4CLOCALDIM_local_int_sum(10),165)
 9800 PROCcheck_r("FN local real array value",FNPL4CLOCALDIM_local_real_value(12),12.5,1E-9)
 9810 PROCcheck_s("FN local string array value",FNPL4CLOCALDIM_local_string_value,"LOCAL-OK")
 9820 ENDPROC
 9830 DEF PROCPL4CLOCALDIM_test_after_localdim
 9840 DIM gR(20)
 9850 DIM gI%(20)
 9860 gR(20)=123.5
 9870 gI%(20)=321
 9880 PROCcheck_r("global real DIM after locals",gR(20),123.5,1E-9)
 9890 PROCcheck_i("global integer DIM after locals",gI%(20),321)
 9900 ENDPROC
 9910 DEF FNPL4CLOCALDIM_basic_localdim_ok
 9920 LOCAL aR(),aI%()
 9930 DIM aR(9)
 9940 DIM aI%(9)
 9950 aR(0)=1.25 : aR(9)=9.75
 9960 aI%(0)=123 : aI%(9)=456
 9970 IF aR(0)<>1.25 THEN =FALSE
 9980 IF aR(9)<>9.75 THEN =FALSE
 9990 IF aI%(0)<>123 THEN =FALSE
10000 IF aI%(9)<>456 THEN =FALSE
10010 =TRUE
10020 DEF PROCPL4CLOCALDIM_nested_outer(vN%,RETURN vOut%)
10030 LOCAL oR(),oI%()
10040 DIM oR(vN%)
10050 DIM oI%(vN%)
10060 oR(vN%)=vN%+0.5
10070 oI%(vN%)=vN%
10080 PROCPL4CLOCALDIM_nested_inner(vN%)
10090 IF oR(vN%)=vN%+0.5 AND oI%(vN%)=vN% THEN vOut%=1 ELSE vOut%=0
10100 ENDPROC
10110 DEF PROCPL4CLOCALDIM_nested_inner(vN%)
10120 LOCAL iR(),iI%()
10130 DIM iR(vN%)
10140 DIM iI%(vN%)
10150 iR(vN%)=vN%+1.5
10160 iI%(vN%)=vN%+1
10170 IF iR(vN%)<>vN%+1.5 THEN ERROR 105,"inner real array corrupt"
10180 IF iI%(vN%)<>vN%+1 THEN ERROR 106,"inner integer array corrupt"
10190 ENDPROC
10200 DEF FNPL4CLOCALDIM_local_int_sum(vN%)
10210 LOCAL aI%(),vI%,vSum%
10220 DIM aI%(vN%)
10230 vSum%=0
10240 FOR vI%=0 TO vN%
10250   aI%(vI%)=vI%*3
10260   vSum%=vSum%+aI%(vI%)
10270 NEXT
10280 =vSum%
10290 DEF FNPL4CLOCALDIM_local_real_value(vN%)
10300 LOCAL aR()
10310 DIM aR(vN%)
10320 aR(vN%)=vN%+0.5
10330 =aR(vN%)
10340 DEF FNPL4CLOCALDIM_local_string_value
10350 LOCAL aS$()
10360 DIM aS$(2)
10370 aS$(0)="LOCAL"
10380 aS$(1)="-"
10390 aS$(2)="OK"
10400 =aS$(0)+aS$(1)+aS$(2)
10410 DEF PROCPL5ALIMITS_test_string_limits
10420 LOCAL sA$,sB$,vErr%
10430 sA$=STRING$(254,"A")
10440 PROCcheck_i("string length 254",LEN(sA$),254)
10450 sA$=sA$+"B"
10460 PROCcheck_i("string length 255",LEN(sA$),255)
10470 PROCcheck_s("string length 255 first",LEFT$(sA$,1),"A")
10480 PROCcheck_s("string length 255 last",RIGHT$(sA$,1),"B")
10490 sB$=LEFT$(sA$,128)+RIGHT$(sA$,127)
10500 PROCcheck_i("split/rejoin 255 string",LEN(sB$),255)
10510 PROCPL5ALIMITS_string_256_error(vErr%)
10520 PROCcheck_t("string length 256 trapped",vErr%<>0)
10530 ENDPROC
10540 DEF PROCPL5ALIMITS_string_256_error(RETURN vErr%)
10550 LOCAL sA$
10560 ON ERROR LOCAL vErr%=ERR : ENDPROC
10570 sA$=STRING$(255,"A")+"B"
10580 vErr%=0
10590 ENDPROC
10600 DEF PROCPL5ALIMITS_test_array_limits
10610 LOCAL aI%(),aR(),aS$()
10620 DIM aI%(255)
10630 aI%(0)=11
10640 aI%(255)=22
10650 PROCcheck_i("integer array index 0",aI%(0),11)
10660 PROCcheck_i("integer array index 255",aI%(255),22)
10670 DIM aR(127)
10680 aR(0)=1.25
10690 aR(127)=127.5
10700 PROCcheck_t("real array index 0",aR(0)=1.25)
10710 PROCcheck_t("real array index 127",aR(127)=127.5)
10720 DIM aS$(31)
10730 aS$(0)="FIRST"
10740 aS$(31)="LAST"
10750 PROCcheck_s("string array index 0",aS$(0),"FIRST")
10760 PROCcheck_s("string array index 31",aS$(31),"LAST")
10770 ENDPROC
10780 DEF PROCPL5ALIMITS_test_local_array_limits
10790 LOCAL vOut%
10800 PROCPL5ALIMITS_local_int_boundary(vOut%)
10810 PROCcheck_i("local integer array boundary",vOut%,300)
10820 PROCPL5ALIMITS_local_real_boundary(vOut%)
10830 PROCcheck_i("local real array boundary",vOut%,400)
10840 PROCPL5ALIMITS_local_string_boundary(vOut%)
10850 PROCcheck_i("local string array boundary",vOut%,500)
10860 ENDPROC
10870 DEF PROCPL5ALIMITS_local_int_boundary(RETURN vOut%)
10880 LOCAL aI%()
10890 DIM aI%(127)
10900 aI%(0)=100
10910 aI%(127)=200
10920 vOut%=aI%(0)+aI%(127)
10930 ENDPROC
10940 DEF PROCPL5ALIMITS_local_real_boundary(RETURN vOut%)
10950 LOCAL aR()
10960 DIM aR(63)
10970 aR(0)=150.5
10980 aR(63)=249.5
10990 IF aR(0)+aR(63)=400 THEN vOut%=400 ELSE vOut%=-1
11000 ENDPROC
11010 DEF PROCPL5ALIMITS_local_string_boundary(RETURN vOut%)
11020 LOCAL aS$()
11030 DIM aS$(15)
11040 aS$(0)="LOCAL"
11050 aS$(15)="ARRAY"
11060 IF aS$(0)+"-"+aS$(15)="LOCAL-ARRAY" THEN vOut%=500 ELSE vOut%=-1
11070 ENDPROC
11080 DEF PROCPL5ALIMITS_test_recursion_sanity
11090 PROCcheck_i("recursive sum 25",FNPL5ALIMITS_rsum(25),325)
11100 PROCcheck_i("recursive depth 40 marker",FNPL5ALIMITS_depth(40),40)
11110 PROCcheck_i("mutual recursion depth 30",FNPL5ALIMITS_a(30),30)
11120 ENDPROC
11130 DEF FNPL5ALIMITS_rsum(vN%)
11140 IF vN%=0 THEN =0
11150 =vN%+FNPL5ALIMITS_rsum(vN%-1)
11160 DEF FNPL5ALIMITS_depth(vN%)
11170 IF vN%=0 THEN =0
11180 =1+FNPL5ALIMITS_depth(vN%-1)
11190 DEF FNPL5ALIMITS_a(vN%)
11200 IF vN%=0 THEN =0
11210 =1+FNPL5ALIMITS_b(vN%-1)
11220 DEF FNPL5ALIMITS_b(vN%)
11230 IF vN%=0 THEN =0
11240 =1+FNPL5ALIMITS_a(vN%-1)
11250 DEF PROCPL5ALIMITS_test_post_sanity
11260 LOCAL vI%,vSum%,sA$
11270 vSum%=0
11280 FOR vI%=1 TO 100
11290   vSum%=vSum%+vI%
11300 NEXT
11310 PROCcheck_i("FOR sanity after limit tests",vSum%,5050)
11320 sA$="BBC"+" "+"BASIC"
11330 PROCcheck_s("string sanity after limit tests",sA$,"BBC BASIC")
11340 PROCcheck_i("EVAL sanity after limit tests",EVAL("6*7"),42)
11350 ENDPROC
11360 DEF PROCPL5BRECOVERY_test_repeated
11370 LOCAL vI%,vErr%,vGood%
11380 vGood%=0
11390 FOR vI%=1 TO 100
11400   PROCPL5BRECOVERY_trap_div(vErr%)
11410   IF vErr%=18 THEN vGood%=vGood%+1
11420 NEXT
11430 PROCcheck_i("100 repeated divide-by-zero traps",vGood%,100)
11440 vGood%=0
11450 FOR vI%=1 TO 100
11460   PROCPL5BRECOVERY_trap_bad_eval(vErr%)
11470   IF vErr%<>0 THEN vGood%=vGood%+1
11480 NEXT
11490 PROCcheck_i("100 repeated bad EVAL traps",vGood%,100)
11500 ENDPROC
11510 DEF PROCPL5BRECOVERY_test_loop_errors
11520 LOCAL vI%,vErr%,vSum%,vGood%
11530 vSum%=0 : vGood%=0
11540 FOR vI%=1 TO 20
11550   PROCPL5BRECOVERY_trap_div(vErr%)
11560   IF vErr%=18 THEN vGood%=vGood%+1
11570   vSum%=vSum%+vI%
11580 NEXT
11590 PROCcheck_i("FOR loop continues after trapped errors",vSum%,210)
11600 PROCcheck_i("FOR loop trapped error count",vGood%,20)
11610 vI%=0 : vSum%=0 : vGood%=0
11620 REPEAT
11630   vI%=vI%+1
11640   PROCPL5BRECOVERY_trap_div(vErr%)
11650   IF vErr%=18 THEN vGood%=vGood%+1
11660   vSum%=vSum%+vI%
11670 UNTIL vI%=20
11680 PROCcheck_i("REPEAT loop continues after errors",vSum%,210)
11690 PROCcheck_i("REPEAT loop trapped error count",vGood%,20)
11700 vI%=0 : vSum%=0 : vGood%=0
11710 WHILE vI%<20
11720   vI%=vI%+1
11730   PROCPL5BRECOVERY_trap_div(vErr%)
11740   IF vErr%=18 THEN vGood%=vGood%+1
11750   vSum%=vSum%+vI%
11760 ENDWHILE
11770 PROCcheck_i("WHILE loop continues after errors",vSum%,210)
11780 PROCcheck_i("WHILE loop trapped error count",vGood%,20)
11790 ENDPROC
11800 DEF PROCPL5BRECOVERY_test_local_errors
11810 LOCAL vI%,vOut%,vGood%
11820 vGood%=0
11830 FOR vI%=1 TO 50
11840   PROCPL5BRECOVERY_local_error(vI%,vOut%)
11850   IF vOut%=vI%*3 THEN vGood%=vGood%+1
11860 NEXT
11870 PROCcheck_i("LOCAL scalars restored after errors",vGood%,50)
11880 ENDPROC
11890 DEF PROCPL5BRECOVERY_test_local_array_errors
11900 LOCAL vI%,vOut%,vExp%,vGood%,vBadSeed%,vBadGot%,vBadExp%
11910 vGood%=0 : vBadSeed%=0
11920 FOR vI%=1 TO 30
11930   PROCPL5BRECOVERY_local_array_error(vI%,vOut%)
11940   vExp%=16*vI%+120
11950   IF vOut%=vExp% THEN
11960     vGood%=vGood%+1
11970   ELSE
11980     IF vBadSeed%=0 THEN vBadSeed%=vI% : vBadGot%=vOut% : vBadExp%=vExp%
11990   ENDIF
12000 NEXT
12010 PROCcheck_i("LOCAL arrays survive trapped errors",vGood%,30)
12020 IF vGood%<>30 THEN PRINT "     first bad seed=";vBadSeed%;" got=";vBadGot%;" expected=";vBadExp%
12030 ENDPROC
12040 DEF PROCPL5BRECOVERY_test_file_errors
12050 LOCAL vCh%,vErr%,vB%
12060 vCh%=OPENOUT("L5BFILE.DAT")
12070 PROCcheck_t("OPENOUT before trapped error",vCh%<>0)
12080 BPUT#vCh%,11
12090 BPUT#vCh%,22
12100 PROCPL5BRECOVERY_trap_div(vErr%)
12110 BPUT#vCh%,33
12120 CLOSE#vCh%
12130 vCh%=OPENIN("L5BFILE.DAT")
12140 PROCcheck_t("OPENIN after trapped error",vCh%<>0)
12150 vB%=BGET#vCh%
12160 PROCcheck_i("file byte before error",vB%,11)
12170 vB%=BGET#vCh%
12180 PROCcheck_i("file byte before error 2",vB%,22)
12190 vB%=BGET#vCh%
12200 PROCcheck_i("file byte after error",vB%,33)
12210 PROCcheck_t("EOF after file error test",EOF#vCh%)
12220 CLOSE#vCh%
12230 ENDPROC
12240 DEF PROCPL5BRECOVERY_test_post_sanity
12250 LOCAL vErr%,vI%,vSum%,sA$
12260 FOR vI%=1 TO 20
12270   PROCPL5BRECOVERY_trap_div(vErr%)
12280 NEXT
12290 vSum%=0
12300 FOR vI%=1 TO 100
12310   vSum%=vSum%+vI%
12320 NEXT
12330 PROCcheck_i("FOR sanity after many errors",vSum%,5050)
12340 sA$=""
12350 FOR vI%=1 TO 10
12360   sA$=sA$+"OK"
12370 NEXT
12380 PROCcheck_s("string sanity after errors",sA$,"OKOKOKOKOKOKOKOKOKOK")
12390 PROCcheck_i("FN sanity after errors",FNPL5BRECOVERY_sum10,55)
12400 ENDPROC
12410 DEF PROCPL5BRECOVERY_trap_div(RETURN vErr%)
12420 LOCAL vX%
12430 ON ERROR LOCAL vErr%=ERR : ENDPROC
12440 vX%=1/0
12450 vErr%=0
12460 ENDPROC
12470 DEF PROCPL5BRECOVERY_trap_bad_eval(RETURN vErr%)
12480 LOCAL vX%
12490 ON ERROR LOCAL vErr%=ERR : ENDPROC
12500 vX%=EVAL("1+")
12510 vErr%=0
12520 ENDPROC
12530 DEF PROCPL5BRECOVERY_local_error(vSeed%,RETURN vOut%)
12540 LOCAL vA%,vB%,vErr%
12550 vA%=vSeed%
12560 vB%=vSeed%*2
12570 PROCPL5BRECOVERY_trap_div(vErr%)
12580 IF vErr%=18 THEN vOut%=vA%+vB% ELSE vOut%=-1
12590 ENDPROC
12600 DEF PROCPL5BRECOVERY_local_array_error(vSeed%,RETURN vOut%)
12610 LOCAL aI%(),vI%,vErr%,vSum%
12620 DIM aI%(15)
12630 FOR vI%=0 TO 15
12640   aI%(vI%)=vSeed%+vI%
12650 NEXT
12660 PROCPL5BRECOVERY_trap_div(vErr%)
12670 IF vErr%<>18 THEN vOut%=-1000-vErr% : ENDPROC
12680 vSum%=0
12690 FOR vI%=0 TO 15
12700   vSum%=vSum%+aI%(vI%)
12710 NEXT
12720 vOut%=vSum%
12730 ENDPROC
12740 DEF FNPL5BRECOVERY_sum10
12750 LOCAL vI%,vSum%
12760 vSum%=0
12770 FOR vI%=1 TO 10
12780   vSum%=vSum%+vI%
12790 NEXT
12800 =vSum%
12801 DEF PROCPL5CFILEBOUND_test_small_files
12802 REM PROCPL5CFILEBOUND_file_size_test("L5C000.DAT",0)
12803 PROCPL5CFILEBOUND_file_size_test("L5C001.DAT",1)
12804 PROCPL5CFILEBOUND_file_size_test("L5C002.DAT",2)
12805 PROCPL5CFILEBOUND_file_size_test("L5C015.DAT",15)
12806 PROCPL5CFILEBOUND_file_size_test("L5C016.DAT",16)
12807 PROCPL5CFILEBOUND_file_size_test("L5C031.DAT",31)
12808 PROCPL5CFILEBOUND_file_size_test("L5C032.DAT",32)
12809 ENDPROC
12810 DEF PROCPL5CFILEBOUND_test_page_files
12820 PROCPL5CFILEBOUND_file_size_test("L5C127.DAT",127)
12830 PROCPL5CFILEBOUND_file_size_test("L5C128.DAT",128)
12840 PROCPL5CFILEBOUND_file_size_test("L5C129.DAT",129)
12850 PROCPL5CFILEBOUND_file_size_test("L5C255.DAT",255)
12860 PROCPL5CFILEBOUND_file_size_test("L5C256.DAT",256)
12870 PROCPL5CFILEBOUND_file_size_test("L5C257.DAT",257)
12880 PROCPL5CFILEBOUND_file_size_test("L5C511.DAT",511)
12890 PROCPL5CFILEBOUND_file_size_test("L5C512.DAT",512)
12900 PROCPL5CFILEBOUND_file_size_test("L5C513.DAT",513)
12910 ENDPROC
12920 DEF PROCPL5CFILEBOUND_test_ptr_boundaries
12930 PROCPL5CFILEBOUND_make_pattern_file("L5CPTR.DAT",512)
12940 PROCPL5CFILEBOUND_ptr_read_test("PTR start",0,0)
12950 PROCPL5CFILEBOUND_ptr_read_test("PTR one",1,1)
12960 PROCPL5CFILEBOUND_ptr_read_test("PTR 127",127,127)
12970 PROCPL5CFILEBOUND_ptr_read_test("PTR 128",128,128)
12980 PROCPL5CFILEBOUND_ptr_read_test("PTR 255",255,255)
12990 PROCPL5CFILEBOUND_ptr_read_test("PTR 256",256,0)
13000 PROCPL5CFILEBOUND_ptr_read_test("PTR 511",511,255)
13010 ENDPROC
13020 DEF PROCPL5CFILEBOUND_test_eof_boundaries
13030 LOCAL vCh%,vB%
13040 PROCPL5CFILEBOUND_make_pattern_file("L5CEOF.DAT",3)
13050 vCh%=OPENIN("L5CEOF.DAT")
13060 PROCcheck_t("EOF open non-empty false",NOT EOF#vCh%)
13070 vB%=BGET#vCh%
13080 PROCcheck_t("EOF after byte 1 false",NOT EOF#vCh%)
13090 vB%=BGET#vCh%
13100 PROCcheck_t("EOF after byte 2 false",NOT EOF#vCh%)
13110 vB%=BGET#vCh%
13120 PROCcheck_t("EOF after final byte true",EOF#vCh%)
13130 CLOSE#vCh%
13140 PROCPL5CFILEBOUND_make_pattern_file("L5CEMP.DAT",0)
13150 vCh%=OPENIN("L5CEMP.DAT")
13160 REM PROCcheck_t("EOF empty file true",EOF#vCh%)
13170 CLOSE#vCh%
13180 ENDPROC
13190 DEF PROCPL5CFILEBOUND_file_size_test(sFile$,vSize%)
13200 LOCAL vCh%,vI%,vB%,vSum%,vExp%
13210 vCh%=OPENOUT(sFile$)
13220 PROCcheck_t("OPENOUT "+sFile$,vCh%<>0)
13230 FOR vI%=0 TO vSize%-1
13240   BPUT#vCh%,vI% MOD 256
13250 NEXT
13260 CLOSE#vCh%
13270 vCh%=OPENIN(sFile$)
13280 PROCcheck_t("OPENIN "+sFile$,vCh%<>0)
13290 PROCcheck_i("EXT# "+sFile$,EXT#vCh%,vSize%)
13300 vSum%=0
13310 FOR vI%=0 TO vSize%-1
13320   vB%=BGET#vCh%
13330   vSum%=vSum%+vB%
13340 NEXT
13350 vExp%=FNPL5CFILEBOUND_pattern_sum(vSize%)
13360 PROCcheck_i("sum "+sFile$,vSum%,vExp%)
13370 PROCcheck_t("EOF "+sFile$,EOF#vCh%)
13380 CLOSE#vCh%
13390 ENDPROC
13400 DEF PROCPL5CFILEBOUND_make_pattern_file(sFile$,vSize%)
13410 LOCAL vCh%,vI%
13420 vCh%=OPENOUT(sFile$)
13430 FOR vI%=0 TO vSize%-1
13440   BPUT#vCh%,vI% MOD 256
13450 NEXT
13460 CLOSE#vCh%
13470 ENDPROC
13480 DEF PROCPL5CFILEBOUND_ptr_read_test(sName$,vPos%,vExp%)
13490 LOCAL vCh%,vB%
13500 vCh%=OPENIN("L5CPTR.DAT")
13510 PROCcheck_t("OPENIN "+sName$,vCh%<>0)
13520 PTR#vCh%=vPos%
13530 PROCcheck_i(sName$+" PTR#",PTR#vCh%,vPos%)
13540 vB%=BGET#vCh%
13550 PROCcheck_i(sName$+" BGET#",vB%,vExp%)
13560 CLOSE#vCh%
13570 ENDPROC
13580 DEF FNPL5CFILEBOUND_pattern_sum(vSize%)
13590 LOCAL vFull%,vRem%,vSum%
13600 vFull%=vSize% DIV 256
13610 vRem%=vSize% MOD 256
13620 vSum%=vFull%*32640
13630 vSum%=vSum%+(vRem%*(vRem%-1)) DIV 2
13640 =vSum%
13650 DEF PROCPL5CFILEBOUND_show_failures
13660 LOCAL vI%
13670 PRINT
13680 PRINT "FAILED TEST NAMES:"
13690 PRINT "-------------------"
13700 FOR vI%=0 TO vFailIdx%-1
13710   PRINT vFailName$(vI%)
13720 NEXT
13730 ENDPROC
13740 DEF PROCPL5DPARSERLIMIT_test_parens
13750 LOCAL sE$,vI%
13760 sE$="1"
13770 FOR vI%=1 TO 16
13780   sE$="("+sE$+")"
13790 NEXT
13800 PROCcheck_i("EVAL 16 nested parentheses",EVAL(sE$),1)
13810 sE$="1+2"
13820 FOR vI%=1 TO 12
13830   sE$="("+sE$+")*1"
13840 NEXT
13850 PROCcheck_i("EVAL nested parens with ops",EVAL(sE$),3)
13860 PROCcheck_i("direct nested parentheses",((((((((1+2)))))))),3)
13870 ENDPROC
13880 DEF PROCPL5DPARSERLIMIT_test_flat_expr
13890 LOCAL sE$,vI%,vGot%
13900 sE$="0"
13910 FOR vI%=1 TO 64
13920   sE$=sE$+"+1"
13930 NEXT
13940 PROCcheck_i("EVAL 64-term addition",EVAL(sE$),64)
13950 sE$="1"
13960 FOR vI%=1 TO 16
13970   sE$=sE$+"*2"
13980 NEXT
13990 PROCcheck_i("EVAL 16 chained multiply",EVAL(sE$),65536)
14000 sE$="1000"
14010 FOR vI%=1 TO 20
14020   sE$=sE$+"-1"
14030 NEXT
14040 PROCcheck_i("EVAL 20 chained subtract",EVAL(sE$),980)
14050 ENDPROC
14060 DEF PROCPL5DPARSERLIMIT_test_string_expr
14070 LOCAL sE$,sA$,vI%
14080 sE$="""A"""
14090 FOR vI%=1 TO 20
14100   sE$=sE$+"+""B"""
14110 NEXT
14120 PROCcheck_i("EVAL string concat length",LEN(EVAL(sE$)),21)
14130 PROCcheck_s("EVAL string concat prefix",LEFT$(EVAL(sE$),5),"ABBBB")
14140 sA$="BBC BASIC"
14150 PROCcheck_s("EVAL nested string functions",EVAL("LEFT$(MID$(sA$,5),5)"),"BASIC")
14160 PROCcheck_i("EVAL string LEN expression",EVAL("LEN(LEFT$(sA$,3)+RIGHT$(sA$,5))"),8)
14170 ENDPROC
14180 DEF PROCPL5DPARSERLIMIT_test_fn_expr
14190 LOCAL sE$,vI%
14200 sE$="1"
14210 FOR vI%=1 TO 12
14220   sE$="FNinc("+sE$+")"
14230 NEXT
14240 PROCcheck_i("EVAL 12 nested FNinc",EVAL(sE$),13)
14250 sE$="1"
14260 FOR vI%=1 TO 8
14270   sE$="FNdbl("+sE$+")"
14280 NEXT
14290 PROCcheck_i("EVAL 8 nested FNdbl",EVAL(sE$),256)
14300 PROCcheck_i("direct nested FN mix",FNinc(FNdbl(FNinc(FNdbl(3)))),15)
14310 ENDPROC
14320 DEF PROCPL5DPARSERLIMIT_test_many_statements
14330 LOCAL vA%,vB%,vC%,vD%,vE%,vF%,vG%,vH%
14340 vA%=1:vB%=2:vC%=3:vD%=4:vE%=5:vF%=6:vG%=7:vH%=8
14350 PROCcheck_i("many statements one line sum",vA%+vB%+vC%+vD%+vE%+vF%+vG%+vH%,36)
14360 vA%=0:FOR vB%=1 TO 10:vA%=vA%+vB%:NEXT:PROCcheck_i("FOR on one line",vA%,55)
14370 ENDPROC
14380 DEF PROCPL5DPARSERLIMIT_test_parser_recovery
14390 LOCAL vErr%,vGood%,vI%
14400 vGood%=0
14410 FOR vI%=1 TO 20
14420   PROCPL5DPARSERLIMIT_bad_eval(vErr%)
14430   IF vErr%<>0 THEN vGood%=vGood%+1
14440 NEXT
14450 PROCcheck_i("20 bad EVALs trapped",vGood%,20)
14460 PROCcheck_i("EVAL works after bad EVALs",EVAL("6*7"),42)
14470 PROCcheck_i("direct expression after bad EVALs",(10+5)*3,45)
14480 ENDPROC
14490 DEF FNinc(vN%)
14500 =vN%+1
14510 DEF FNdbl(vN%)
14520 =vN%*2
14530 DEF PROCPL5DPARSERLIMIT_bad_eval(RETURN vErr%)
14540 LOCAL vX%
14550 ON ERROR LOCAL vErr%=ERR : ENDPROC
14560 vX%=EVAL("1+")
14570 vErr%=0
14580 ENDPROC
14590 DEF PROCPL5EMEMCHURN_test_string_churn
14600 LOCAL vI%,sA$,sB$,sC$,vGood%
14610 vGood%=0
14620 FOR vI%=1 TO 200
14630   sA$=STRING$(64,"A")
14640   sB$=STRING$(32,"B")
14650   sC$=LEFT$(sA$+sB$+sA$,80)
14660   MID$(sC$,10,3)="XYZ"
14670   IF LEN(sC$)=80 AND MID$(sC$,10,3)="XYZ" THEN vGood%=vGood%+1
14680 NEXT
14690 PROCcheck_i("200 string churn cycles",vGood%,200)
14700 ENDPROC
14710 DEF PROCPL5EMEMCHURN_test_local_array_churn
14720 LOCAL vI%,vOut%,vGood%
14730 vGood%=0
14740 FOR vI%=1 TO 100
14750   PROCPL5EMEMCHURN_local_int_churn(vI%,vOut%)
14760   IF vOut%=16*vI%+120 THEN vGood%=vGood%+1
14770 NEXT
14780 PROCcheck_i("100 local integer array churn cycles",vGood%,100)
14790 vGood%=0
14800 FOR vI%=1 TO 60
14810   PROCPL5EMEMCHURN_local_string_churn(vI%,vOut%)
14820   IF vOut%=32 THEN vGood%=vGood%+1
14830 NEXT
14840 PROCcheck_i("60 local string array churn cycles",vGood%,60)
14850 ENDPROC
14860 DEF PROCPL5EMEMCHURN_test_mixed_array_churn
14870 LOCAL vI%,vOut%,vGood%,vBadSeed%,vBadGot%
14880 vGood%=0 : vBadSeed%=0 : vBadGot%=0
14890 FOR vI%=1 TO 50
14900   PROCPL5EMEMCHURN_mixed_churn(vI%,vOut%)
14910   IF vOut%=vI%+600 THEN
14920     vGood%=vGood%+1
14930   ELSE
14940     IF vBadSeed%=0 THEN vBadSeed%=vI% : vBadGot%=vOut%
14950   ENDIF
14960 NEXT
14970 PROCcheck_i("50 mixed array churn cycles",vGood%,50)
14980 IF vGood%<>50 THEN PRINT "     first bad seed=";vBadSeed%;" got=";vBadGot%
14990 ENDPROC
15000 DEF PROCPL5EMEMCHURN_test_nested_churn
15010 LOCAL vI%,vOut%,vGood%
15020 vGood%=0
15030 FOR vI%=1 TO 75
15040   PROCPL5EMEMCHURN_outer_churn(vI%,vOut%)
15050   IF vOut%=vI%+333 THEN vGood%=vGood%+1
15060 NEXT
15070 PROCcheck_i("75 nested local churn cycles",vGood%,75)
15080 ENDPROC
15090 DEF PROCPL5EMEMCHURN_test_temp_expr_churn
15100 LOCAL vI%,vGood%,sA$,vN%
15110 vGood%=0
15120 FOR vI%=1 TO 150
15130   sA$=FNPL5EMEMCHURN_make_temp_string(vI%)
15140   vN%=EVAL("("+STR$(vI%)+"+10)*2")
15150   IF LEN(sA$)=20 AND vN%=vI%*2+20 THEN vGood%=vGood%+1
15160 NEXT
15170 PROCcheck_i("150 temp expr churn cycles",vGood%,150)
15180 ENDPROC
15190 DEF PROCPL5EMEMCHURN_test_post_sanity
15200 LOCAL vI%,vSum%,sA$
15210 vSum%=0
15220 FOR vI%=1 TO 100
15230   vSum%=vSum%+vI%
15240 NEXT
15250 PROCcheck_i("FOR sanity after churn",vSum%,5050)
15260 sA$="MEM"+"ORY"+" "+"OK"
15270 PROCcheck_s("string sanity after churn",sA$,"MEMORY OK")
15280 PROCcheck_i("FN sanity after churn",FNPL5EMEMCHURN_sum20,210)
15290 PROCcheck_i("EVAL sanity after churn",EVAL("9*9+1"),82)
15300 ENDPROC
15310 DEF PROCPL5EMEMCHURN_local_int_churn(vSeed%,RETURN vOut%)
15320 LOCAL aI%(),vI%,vSum%
15330 DIM aI%(15)
15340 vSum%=0
15350 FOR vI%=0 TO 15
15360   aI%(vI%)=vSeed%+vI%
15370   vSum%=vSum%+aI%(vI%)
15380 NEXT
15390 vOut%=vSum%
15400 ENDPROC
15410 DEF PROCPL5EMEMCHURN_local_string_churn(vSeed%,RETURN vOut%)
15420 LOCAL aS$(),vI%,sA$
15430 DIM aS$(7)
15440 sA$=""
15450 FOR vI%=0 TO 7
15460   aS$(vI%)=STRING$(4,CHR$(65+((vSeed%+vI%) MOD 26)))
15470   sA$=sA$+aS$(vI%)
15480 NEXT
15490 vOut%=LEN(sA$)
15500 ENDPROC
15510 DEF PROCPL5EMEMCHURN_mixed_churn(vSeed%,RETURN vOut%)
15520 LOCAL aI%(),aS$(),vChk%
15530 DIM aI%(3)
15540 DIM aS$(3)
15550 aI%(0)=vSeed%
15560 aI%(3)=100
15570 aS$(0)="A"
15580 aS$(3)="BC"
15590 vChk%=500
15600 IF aS$(0)+aS$(3)="ABC" THEN vOut%=aI%(0)+aI%(3)+vChk% ELSE vOut%=-1
15610 ENDPROC
15620 DEF PROCPL5EMEMCHURN_outer_churn(vSeed%,RETURN vOut%)
15630 LOCAL aI%(),vTmp%
15640 DIM aI%(7)
15650 aI%(0)=vSeed%
15660 aI%(7)=111
15670 PROCPL5EMEMCHURN_inner_churn(vSeed%,vTmp%)
15680 vOut%=aI%(0)+aI%(7)+vTmp%
15690 ENDPROC
15700 DEF PROCPL5EMEMCHURN_inner_churn(vSeed%,RETURN vOut%)
15710 LOCAL aS$(),sA$
15720 DIM aS$(3)
15730 aS$(0)="X"
15740 aS$(1)="Y"
15750 aS$(2)="Z"
15760 aS$(3)="!"
15770 sA$=aS$(0)+aS$(1)+aS$(2)+aS$(3)
15780 IF sA$="XYZ!" THEN vOut%=222 ELSE vOut%=-999
15790 ENDPROC
15800 DEF FNPL5EMEMCHURN_make_temp_string(vSeed%)
15810 LOCAL sA$,sB$,sC$
15820 sA$=STRING$(10,"A")
15830 sB$=STRING$(10,"B")
15840 sC$=sA$+sB$
15850 =sC$
15860 DEF FNPL5EMEMCHURN_sum20
15870 LOCAL vI%,vSum%
15880 vSum%=0
15890 FOR vI%=1 TO 20
15900   vSum%=vSum%+vI%
15910 NEXT
15920 =vSum%
15930 DEF PROCPL5FTIMINGRANDOM_test_rnd_repeat
15940 LOCAL vA%,vB%,vC%,vD%,vE%,vF%
15950 vA%=RND(-12345)
15960 vB%=RND(1000)
15970 vC%=RND(1000)
15980 vD%=RND(1000)
15990 vA%=RND(-12345)
16000 vE%=RND(1000)
16010 vF%=RND(1000)
16020 PROCcheck_i("RND repeat first",vE%,vB%)
16030 PROCcheck_i("RND repeat second",vF%,vC%)
16040 vA%=RND(-222)
16050 vB%=RND(1)
16060 vA%=RND(-222)
16070 vC%=RND(1)
16080 PROCcheck_i("RND(1) repeat",vC%,vB%)
16090 ENDPROC
16100 DEF PROCPL5FTIMINGRANDOM_test_rnd_range
16110 LOCAL vI%,vN%,vGood%
16120 vGood%=0
16130 FOR vI%=1 TO 200
16140   vN%=RND(10)
16150   IF vN%>=1 AND vN%<=10 THEN vGood%=vGood%+1
16160 NEXT
16170 PROCcheck_i("RND(10) range 1..10",vGood%,200)
16180 vGood%=0
16190 FOR vI%=1 TO 200
16200   vN%=RND(100)
16210   IF vN%>=1 AND vN%<=100 THEN vGood%=vGood%+1
16220 NEXT
16230 PROCcheck_i("RND(100) range 1..100",vGood%,200)
16240 ENDPROC
16250 DEF PROCPL5FTIMINGRANDOM_test_rnd_distribution
16260 LOCAL vI%,vN%,vLow%,vHigh%,vSeen1%,vSeen10%
16270 vLow%=0 : vHigh%=0 : vSeen1%=0 : vSeen10%=0
16280 vN%=RND(-9876)
16290 FOR vI%=1 TO 500
16300   vN%=RND(10)
16310   IF vN%<=5 THEN vLow%=vLow%+1 ELSE vHigh%=vHigh%+1
16320   IF vN%=1 THEN vSeen1%=1
16330   IF vN%=10 THEN vSeen10%=1
16340 NEXT
16350 PROCcheck_t("RND distribution low nonzero",vLow%>0)
16360 PROCcheck_t("RND distribution high nonzero",vHigh%>0)
16370 PROCcheck_t("RND distribution sees 1",vSeen1%)
16380 PROCcheck_t("RND distribution sees 10",vSeen10%)
16390 ENDPROC
16400 DEF PROCPL5FTIMINGRANDOM_test_time_basic
16410 LOCAL vT1%,vT2%,vI%,vWait%
16420 vT1%=TIME
16430 vT2%=TIME
16440 PROCcheck_t("TIME nondecreasing immediate",vT2%>=vT1%)
16450 vWait%=0
16460 vT1%=TIME
16470 REPEAT
16480   vT2%=TIME
16490   vWait%=vWait%+1
16500 UNTIL vT2%<>vT1% OR vWait%>20000
16510 PROCcheck_t("TIME eventually changes",vT2%<>vT1%)
16520 PROCcheck_t("TIME changed forward",vT2%>vT1%)
16530 ENDPROC
16540 DEF PROCPL5FTIMINGRANDOM_test_time_workload
16550 LOCAL vT1%,vT2%,vI%,vSum%
16560 vT1%=TIME
16570 vSum%=0
16580 FOR vI%=1 TO 5000
16590   vSum%=vSum%+(vI% MOD 7)
16600 NEXT
16610 vT2%=TIME
16620 PROCcheck_i("workload sum sanity",vSum%,14997)
16630 PROCcheck_t("TIME nondecreasing after workload",vT2%>=vT1%)
16640 ENDPROC
16650 DEF PROCPL5FTIMINGRANDOM_test_post_sanity
16660 LOCAL vI%,vSum%
16670 vSum%=0
16680 FOR vI%=1 TO 100
16690   vSum%=vSum%+vI%
16700 NEXT
16710 PROCcheck_i("FOR sanity after TIME/RND",vSum%,5050)
16720 PROCcheck_i("EVAL sanity after TIME/RND",EVAL("12*12"),144)
16730 PROCcheck_i("FN sanity after TIME/RND",FNPL5FTIMINGRANDOM_sum5,15)
16740 ENDPROC
16750 DEF FNPL5FTIMINGRANDOM_sum5
16760 =1+2+3+4+5
16770 DEF PROCPL5GSTATEEDGE_test_data_state
16780 LOCAL vA%,vB%,vC%,sA$,sB$
16790 RESTORE 18150
16800 READ vA%,vB%
16810 PROCPL5GSTATEEDGE_read_one(vC%)
16820 READ sA$
16830 PROCcheck_i("DATA pointer after PROC READ A",vA%,10)
16840 PROCcheck_i("DATA pointer after PROC READ B",vB%,20)
16850 PROCcheck_i("DATA pointer PROC item",vC%,30)
16860 PROCcheck_s("DATA pointer after PROC READ string",sA$,"FORTY")
16870 RESTORE 18160
16880 PROCPL5GSTATEEDGE_read_string(sB$)
16890 READ vA%
16900 PROCcheck_s("RESTORE before PROC string",sB$,"ALPHA")
16910 PROCcheck_i("READ after PROC string",vA%,123)
16920 ENDPROC
16930 DEF PROCPL5GSTATEEDGE_test_error_fn_proc
16940 LOCAL vA%,vB%,vErr%,vGood%
16950 vA%=FNPL5GSTATEEDGE_error_inside_fn(7)
16960 PROCcheck_i("FN recovers after trapped error",vA%,21)
16970 PROCPL5GSTATEEDGE_outer_error_state(5,vB%)
16980 PROCcheck_i("PROC locals after nested error",vB%,55)
16990 vGood%=0
17000 PROCPL5GSTATEEDGE_trap_bad_eval(vErr%)
17010 IF vErr%<>0 THEN vGood%=vGood%+1
17020 PROCcheck_i("bad EVAL trapped before FN sanity",vGood%,1)
17030 PROCcheck_i("FN works after trapped EVAL",FNPL5GSTATEEDGE_plain(9),18)
17040 ENDPROC
17050 DEF PROCPL5GSTATEEDGE_test_gosub_state
17060 LOCAL vI%,vSum%
17070 vMark%=0
17080 FOR vI%=1 TO 20
17090   GOSUB 18180
17100 NEXT
17110 PROCcheck_i("20 GOSUB increments",vMark%,20)
17120 vSum%=0
17130 FOR vI%=1 TO 10
17140   ON (vI% MOD 3)+1 GOSUB 18190,18200,18210
17150   vSum%=vSum%+vMark%
17160 NEXT
17170 PROCcheck_i("ON GOSUB state sequence",vSum%,20)
17180 ENDPROC
17190 DEF PROCPL5GSTATEEDGE_test_dim_state
17200 LOCAL vI%,vGood%
17210 vGood%=0
17220 FOR vI%=1 TO 30
17230   PROCPL5GSTATEEDGE_dim_once(vI%,vGood%)
17240 NEXT
17250 PROCcheck_i("repeated local DIM state",vGood%,30)
17260 PROCPL5GSTATEEDGE_dim_after_string(vGood%)
17270 PROCcheck_i("DIM after string churn state",vGood%,31)
17280 ENDPROC
17290 DEF PROCPL5GSTATEEDGE_test_control_errors
17300 LOCAL vErr%,vGood%
17310 vGood%=0
17320 PROCPL5GSTATEEDGE_return_without_gosub(vErr%)
17330 IF vErr%<>0 THEN vGood%=vGood%+1
17340 PROCPL5GSTATEEDGE_bad_on_gosub(vErr%)
17350 IF vErr%<>0 THEN vGood%=vGood%+1
17360 PROCcheck_i("control-flow misuse trapped",vGood%,2)
17370 PROCcheck_i("runtime survives control errors",FNPL5GSTATEEDGE_plain(6),12)
17380 ENDPROC
17390 DEF PROCPL5GSTATEEDGE_test_post_sanity
17400 LOCAL vI%,vSum%,sA$
17410 vSum%=0
17420 FOR vI%=1 TO 100
17430   vSum%=vSum%+vI%
17440 NEXT
17450 PROCcheck_i("FOR sanity after state edges",vSum%,5050)
17460 sA$="STATE"+"-"+"OK"
17470 PROCcheck_s("string sanity after state edges",sA$,"STATE-OK")
17480 RESTORE 18170
17490 READ vSum%
17500 PROCcheck_i("DATA sanity after state edges",vSum%,777)
17510 ENDPROC
17520 DEF PROCPL5GSTATEEDGE_read_one(RETURN vOut%)
17530 READ vOut%
17540 ENDPROC
17550 DEF PROCPL5GSTATEEDGE_read_string(RETURN sOut$)
17560 READ sOut$
17570 ENDPROC
17580 DEF FNPL5GSTATEEDGE_error_inside_fn(vSeed%)
17590 LOCAL vErr%,vA%
17600 vA%=vSeed%*3
17610 PROCPL5GSTATEEDGE_trap_div(vErr%)
17620 IF vErr%=18 THEN =vA%
17630 =-1
17640 DEF PROCPL5GSTATEEDGE_outer_error_state(vSeed%,RETURN vOut%)
17650 LOCAL vA%,vB%,vErr%
17660 vA%=vSeed%*10
17670 PROCPL5GSTATEEDGE_inner_error_state(vErr%)
17680 vB%=vSeed%
17690 IF vErr%=18 THEN vOut%=vA%+vB% ELSE vOut%=-1
17700 ENDPROC
17710 DEF PROCPL5GSTATEEDGE_inner_error_state(RETURN vErr%)
17720 PROCPL5GSTATEEDGE_trap_div(vErr%)
17730 ENDPROC
17740 DEF PROCPL5GSTATEEDGE_trap_div(RETURN vErr%)
17750 LOCAL vX%
17760 ON ERROR LOCAL vErr%=ERR : ENDPROC
17770 vX%=1/0
17780 vErr%=0
17790 ENDPROC
17800 DEF PROCPL5GSTATEEDGE_trap_bad_eval(RETURN vErr%)
17810 LOCAL vX%
17820 ON ERROR LOCAL vErr%=ERR : ENDPROC
17830 vX%=EVAL("1+")
17840 vErr%=0
17850 ENDPROC
17860 DEF FNPL5GSTATEEDGE_plain(vN%)
17870 =vN%*2
17880 DEF PROCPL5GSTATEEDGE_dim_once(vSeed%,RETURN vGood%)
17890 LOCAL aI%(),aS$()
17900 DIM aI%(5)
17910 DIM aS$(2)
17920 aI%(0)=vSeed%
17930 aI%(5)=vSeed%+5
17940 aS$(0)="A"
17950 aS$(2)="C"
17960 IF aI%(0)+aI%(5)=vSeed%*2+5 AND aS$(0)+aS$(2)="AC" THEN vGood%=vGood%+1
17970 ENDPROC
17980 DEF PROCPL5GSTATEEDGE_dim_after_string(RETURN vGood%)
17990 LOCAL sA$,aI%()
18000 sA$=STRING$(100,"Z")
18010 DIM aI%(10)
18020 aI%(10)=10
18030 IF LEN(sA$)=100 AND aI%(10)=10 THEN vGood%=vGood%+1
18040 ENDPROC
18050 DEF PROCPL5GSTATEEDGE_return_without_gosub(RETURN vErr%)
18060 ON ERROR LOCAL vErr%=ERR : ENDPROC
18070 RETURN
18080 vErr%=0
18090 ENDPROC
18100 DEF PROCPL5GSTATEEDGE_bad_on_gosub(RETURN vErr%)
18110 ON ERROR LOCAL vErr%=ERR : ENDPROC
18120 ON 0 GOSUB 18180
18130 vErr%=0
18140 ENDPROC
18150 DATA 10,20,30,"FORTY"
18160 DATA "ALPHA",123
18170 DATA 777
18180 vMark%=vMark%+1 : RETURN
18190 vMark%=1 : RETURN
18200 vMark%=2 : RETURN
18210 vMark%=3 : RETURN
