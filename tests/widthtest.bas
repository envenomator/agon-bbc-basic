100 REM WIDTH keyword tests
120 PROCtest("WIDTH accepts normal value", FNtest_width_normal)
130 PROCtest("WIDTH 0 disables wrapping", FNtest_width_zero)
140 PROCtest("WIDTH affects PRINT wrapping", FNtest_width_wrap)
150 PROCtest("WIDTH can be changed repeatedly", FNtest_width_change)
160 PRINT
170 PRINT "Tests complete"
180 END

1000 DEF PROCtest(N$,R%)
1010 IF R% THEN
1020   PRINT N$;" : PASS"
1030 ELSE
1040   PRINT N$;" : FAIL"
1050 ENDIF
1060 ENDPROC

2000 DEF FNtest_width_normal
2010 WIDTH 20
2020 PRINT
2030 PRINT "ABC";
2040 =(POS=3)

2100 DEF FNtest_width_zero
2110 WIDTH 0
2120 PRINT
2130 PRINT "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
2140 =(POS=26)

2200 DEF FNtest_width_wrap
2210 WIDTH 10
2220 PRINT
2230 PRINT "ABCDEFGHIJ";
2240 =(POS=0)

2300 DEF FNtest_width_change
2310 WIDTH 5
2320 PRINT
2330 PRINT "ABCDE";
2340 IF POS<>0 THEN =FALSE
2350 WIDTH 20
2360 PRINT "ABC";
2370 =(POS=3)
