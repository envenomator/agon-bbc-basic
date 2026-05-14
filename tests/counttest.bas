100 REM COUNT keyword tests
120 PROCtest("Initial COUNT after newline", FNtest_initial)
130 PROCtest("PRINT semicolon increments COUNT", FNtest_printsemi)
140 PROCtest("PRINT newline resets COUNT", FNtest_newline)
150 PROCtest("SPC increments COUNT", FNtest_spc)
160 PROCtest("TAB sets COUNT position", FNtest_tab)
170 PROCtest("VDU output increments COUNT", FNtest_vdu)
180 PROCtest("Reading COUNT does not modify it", FNtest_readonly)
190 PRINT
200 PRINT "Tests complete"
210 END

1000 DEF PROCtest(N$,R%)
1010 IF R% THEN
1020   PRINT N$;" : PASS"
1030 ELSE
1040   PRINT N$;" : FAIL"
1050 ENDIF
1060 ENDPROC

2000 DEF FNtest_initial
2010 PRINT
2020 =(COUNT=0)

2100 DEF FNtest_printsemi
2110 PRINT
2120 PRINT "ABC";
2130 =(COUNT=3)

2200 DEF FNtest_newline
2210 PRINT
2220 PRINT "ABC";
2230 IF COUNT<>3 THEN =FALSE
2240 PRINT
2250 =(COUNT=0)

2300 DEF FNtest_spc
2310 PRINT
2320 PRINT SPC(5);
2330 =(COUNT=5)

2400 DEF FNtest_tab
2410 PRINT
2420 PRINT TAB(10);
2430 REM COUNT should now reflect cursor position
2440 =(COUNT=10)

2500 DEF FNtest_vdu
2510 PRINT
2520 VDU 65
2530 =(COUNT=1)

2600 DEF FNtest_readonly
2610 PRINT
2620 PRINT "HELLO";
2630 A%=COUNT
2640 B%=COUNT
2650 =(A%=5 AND B%=5)
