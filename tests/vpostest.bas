100 REM POS/VPOS keyword tests
120 PROCtest("Initial POS after newline", FNtest_pos_initial)
130 PROCtest("PRINT updates POS", FNtest_pos_print)
140 PROCtest("PRINT newline resets POS", FNtest_pos_newline)
150 PROCtest("TAB updates POS", FNtest_pos_tab)
160 PROCtest("Initial VPOS", FNtest_vpos_initial)
170 PROCtest("PRINT newline updates VPOS", FNtest_vpos_newline)
180 PROCtest("TAB x,y updates POS and VPOS", FNtest_tab_xy)
190 PROCtest("Reading POS/VPOS does not modify them", FNtest_readonly)
200 PRINT
210 PRINT "Tests complete"
220 END

1000 DEF PROCtest(N$,R%)
1010 IF R% THEN
1020   PRINT N$;" : PASS"
1030 ELSE
1040   PRINT N$;" : FAIL"
1050 ENDIF
1060 ENDPROC

2000 DEF FNtest_pos_initial
2010 PRINT
2020 =(POS=0)

2100 DEF FNtest_pos_print
2110 PRINT
2120 PRINT "ABC";
2130 =(POS=3)

2200 DEF FNtest_pos_newline
2210 PRINT
2220 PRINT "ABC";
2230 IF POS<>3 THEN =FALSE
2240 PRINT
2250 =(POS=0)

2300 DEF FNtest_pos_tab
2310 PRINT
2320 PRINT TAB(10);
2330 =(POS=10)

2400 DEF FNtest_vpos_initial
2410 CLS
2420 =(VPOS=0)

2500 DEF FNtest_vpos_newline
2510 CLS
2520 A%=VPOS
2530 PRINT
2540 B%=VPOS
2550 =(A%=0 AND B%=1)

2600 DEF FNtest_tab_xy
2610 CLS
2620 PRINT TAB(12,5);
2630 =(POS=12 AND VPOS=5)

2700 DEF FNtest_readonly
2710 CLS
2720 PRINT TAB(4,3);
2730 A%=POS
2740 B%=VPOS
2750 C%=POS
2760 D%=VPOS
2770 =(A%=4 AND B%=3 AND C%=4 AND D%=3)
