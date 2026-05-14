100 REM TAB keyword tests
120 PROCtest("TAB(x) sets POS", FNtest_tab_x)
130 PROCtest("TAB(x,y) sets POS and VPOS", FNtest_tab_xy)
140 PROCtest("TAB after text moves forward", FNtest_tab_after_text)
150 PROCtest("TAB(0) moves to column zero", FNtest_tab_zero)
160 PROCtest("TAB can be chained in PRINT", FNtest_tab_chain)
170 PROCtest("Reading after TAB is stable", FNtest_tab_readonly)
180 PRINT
190 PRINT "Tests complete"
200 END

1000 DEF PROCtest(N$,R%)
1010 IF R% THEN
1020   PRINT N$;" : PASS"
1030 ELSE
1040   PRINT N$;" : FAIL"
1050 ENDIF
1060 ENDPROC

2000 DEF FNtest_tab_x
2010 CLS
2020 PRINT TAB(10);
2030 =(POS=10)

2100 DEF FNtest_tab_xy
2110 CLS
2120 PRINT TAB(12,5);
2130 =(POS=12 AND VPOS=5)

2200 DEF FNtest_tab_after_text
2210 CLS
2220 PRINT "ABC";TAB(8);
2230 =(POS=8)

2300 DEF FNtest_tab_zero
2310 CLS
2320 PRINT TAB(10);
2330 IF POS<>10 THEN =FALSE
2340 PRINT TAB(0);
2350 =(POS=0)

2400 DEF FNtest_tab_chain
2410 CLS
2420 PRINT TAB(2);"A";TAB(6);"B";
2430 =(POS=7)

2500 DEF FNtest_tab_readonly
2510 CLS
2520 PRINT TAB(4,3);
2530 A%=POS
2540 B%=VPOS
2550 C%=POS
2560 D%=VPOS
2570 =(A%=4 AND B%=3 AND C%=4 AND D%=3)
