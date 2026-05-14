100 REM SPC keyword tests
120 PROCtest("SPC(0) prints nothing", FNtest_spc_zero)
130 PROCtest("SPC(n) advances POS", FNtest_spc_pos)
140 PROCtest("SPC(n) advances COUNT", FNtest_spc_count)
150 PROCtest("SPC can be chained in PRINT", FNtest_spc_chain)
160 PROCtest("SPC after text updates correctly", FNtest_spc_after_text)
170 PRINT
180 PRINT "Tests complete"
190 END

1000 DEF PROCtest(N$,R%)
1010 IF R% THEN
1020   PRINT N$;" : PASS"
1030 ELSE
1040   PRINT N$;" : FAIL"
1050 ENDIF
1060 ENDPROC

2000 DEF FNtest_spc_zero
2010 PRINT
2020 PRINT SPC(0);
2030 =(POS=0 AND COUNT=0)

2100 DEF FNtest_spc_pos
2110 PRINT
2120 PRINT SPC(5);
2130 =(POS=5)

2200 DEF FNtest_spc_count
2210 PRINT
2220 PRINT SPC(8);
2230 =(COUNT=8)

2300 DEF FNtest_spc_chain
2310 PRINT
2320 PRINT "A";SPC(3);"B";
2330 =(POS=5 AND COUNT=5)

2400 DEF FNtest_spc_after_text
2410 PRINT
2420 PRINT "HELLO";
2430 IF POS<>5 THEN =FALSE
2440 PRINT SPC(4);
2450 =(POS=9 AND COUNT=9)
