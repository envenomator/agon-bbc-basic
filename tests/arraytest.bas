   10 PRINT "Running array tests..."
   20 
   30 REM. Create global one-dimensional arrays:
   40 DIM OneD(99), OneD%(99), OneD&(99), OneD$(99)
   50 
   60 REM. Check reported number of dimensions and sizes:
   70 IF DIM(OneD()) <> 1   OR DIM(OneD(),1) <> 99   STOP
   80 IF DIM(OneD%()) <> 1  OR DIM(OneD%(),1) <> 99  STOP
   90 IF DIM(OneD&()) <> 1  OR DIM(OneD&(),1) <> 99  STOP
  100 IF DIM(OneD$()) <> 1  OR DIM(OneD$(),1) <> 99  STOP
  110 
  120 REM. Check size of array:
  130 IF ^OneD(99) - ^OneD(0)     <> 99*5 STOP
  140 IF ^OneD%(99) - ^OneD%(0)   <> 99*4 STOP
  150 IF ^OneD&(99) - ^OneD&(0)   <> 99*1 STOP
  160 IF ^OneD$(99) - ^OneD$(0)   <> 99*5 STOP
  170 
  180 REM. Check arrays are initially empty:
  190 FOR I% = 0 TO 99
  200   IF OneD(I%)   <> 0.0 STOP
  210   IF OneD%(I%)  <> 0   STOP
  220   IF OneD&(I%)  <> 0   STOP
  230   IF OneD$(I%)  <> ""  STOP
  240 NEXT
  250 
  260 REM. Load arrays in a loop:
  270 FOR I% = 0 TO 99
  280   OneD(I%)  = I% * 1.0001
  290   OneD%(I%) = I% * &01020201
  300   OneD&(I%) = I%
  310   OneD$(I%) = "13 characters" + STR$(I%)
  320 NEXT
  330 
  340 REM. Check LOCAL arrays:
  350 PROC6(9)
  360 
  370 REM. Check and fill arrays:
  380 PROC1(OneD(), OneD%(), OneD&(), OneD$())
  390 
  400 REM. Check LOCAL arrays:
  410 PROC6(10)
  420 
  430 REM. Check filled arrays:
  440 FOR I% = 0 TO 99
  450   IF OneD(I%)  <> 1 + 241/1024   STOP
  460   IF OneD%(I%) <> &12345678      STOP
  470   IF OneD&(I%) <> &AA            STOP
  480   IF OneD$(I%) <> "Hello world!" STOP
  490 NEXT
  500 
  510 REM. Initialise and check arrays:
  520 PROC2(OneD(), OneD%(), OneD&(), OneD$())
  530 
  540 REM. Check rest of arrays is unchanged:
  550 FOR I% = 5 TO 99
  560   IF OneD(I%)  <> 1 + 241/1024   STOP
  570   IF OneD%(I%) <> &12345678      STOP
  580   IF OneD&(I%) <> &AA            STOP
  590   IF OneD$(I%) <> "Hello world!" STOP
  600 NEXT
  610 
  620 REM. Check SUM function:
  630 IF SUM( OneD() ) <> 15 * 1.015625 + 95 + 95*241/1024 STOP
  640 IF SUM( OneD%()) <> 15 * &11111111 + 95 * &12345678 STOP
  650 IF SUM(OneD&() ) <> 15 * &11 + 95 * &AA STOP
  660 IF SUMLEN(OneD$() ) <> 19 + 95 * 12 STOP
  670 
  680 REM. Check MOD and SUMLEN functions:
  690 FOR I% = 0 TO 99
  700   Mod1 += OneD(I%) ^ 2
  710   Mod2 += OneD%(I%) ^ 2
  720   Mod4 += OneD&(I%) ^ 2
  730 NEXT
  740 IF MOD(OneD())   <> SQR(Mod1) STOP
  750 IF MOD(OneD%())  <> SQR(Mod2) STOP
  760 IF MOD(OneD&())  <> SQR(Mod4) STOP
  770 IF SUMLEN(OneD$()) <> 19 + 95 * 12 STOP
  780 
  790 REM. Check that LOCAL arrays free their heap usage:
  800 PROC6(10)
  810 heap% = END
  820 PROC6(10)
  830 IF END > heap% STOP
  840 
  850 REM. Check whole-array assignment operators:
  860 OneD() += 1.0 : OneD%() += 1 : OneD&() += 1 : OneD$() += "!"
  870 IF SUM(OneD()) <> 100 + 15 * 1.015625 + 95 + 95*241/1024 STOP
  880 IF ABS(SUM(OneD%()) - 100 - 15 * &11111111 - 95 * &12345678) > 2048 STOP
  890 IF SUM(OneD&()) <> 100 + 15 * &11 + 95 * &AA STOP
  900 IF SUMLEN(OneD$()) <> LEN("One!two!three!four!five!") + 95 * LEN("Hello world!!") STOP
  910 
  920 OneD() -= 1.0 : OneD%() -= 1 : OneD&() -= 1
  930 IF SUM(OneD()) <> 15 * 1.015625 + 95 + 95*241/1024 STOP
  940 IF SUM(OneD%()) <> 15 * &11111111 + 95 * &12345678 STOP
  950 IF SUM(OneD&()) <> 15 * &11 + 95 * &AA STOP
  960 
  970 OneD() *= 0.5 : OneD%() DIV= 2 : OneD&() DIV= 2
  980 IF SUM(OneD()) <> (15 * 1.015625 + 95 + 95*241/1024) / 2 STOP
  990 IF SUM(OneD%()) <> &7FFFFFFE + 95 * &91A2B3C STOP
 1000 IF SUM(OneD&()) <> &08 + &11 + &19 + &22 + &2A + 95 * &55 STOP
 1010 
 1020 OneD() += OneD() : OneD%() += OneD%() : OneD&() += OneD&()
 1030 IF SUM(OneD()) <> 15 * 1.015625 + 95 + 95*241/1024 STOP
 1040 IF SUM(OneD%()) <> 2 * &7FFFFFFE + 95 * &12345678 STOP
 1050 IF SUM(OneD&()) <> &10 + &22 + &32 + &44 + &54 + 95 * &AA STOP
 1060 
 1070 REM. Check array arithmetic (strict left-to-right):
 1080 OneD() = -OneD() : OneD%() = -OneD%() : OneD&() = -OneD&()
 1090 IF SUM(OneD()) <> -15 * 1.015625 - 95 - 95*241/1024 STOP
 1100 IF SUM(OneD%()) <> -2 * &7FFFFFFE - 95 * &12345678 STOP
 1110 IF SUM(OneD&()) <> &F0 + &DE + &CE + &BC + &AC + 95 * &56 STOP
 1120 
 1130 OneD()  =  OneD() * 0.5 + (1.5 * 2.0) - OneD()
 1140 OneD%() = OneD%() DIV 2 - OneD%() + 3 AND &FFFFFFFF OR 1
 1150 OneD&() = OneD&() DIV 2 - OneD&() + 3 AND &FE EOR 1
 1160 IF SUM(OneD()) <> 300 + (15 * 1.015625 + 95 + 95*241/1024) / 2 STOP
 1170 IF ABS(SUM(OneD%()) - 300 - &7FFFFFA1 - 95 * &91A2B3D) > 2048 STOP
 1180 IF SUM(OneD&()) <> 300 + &88 + &92 + &9A + &A2 + &AA + 95 * &D6 STOP
 1190 
 1200 CLEAR
 1210 REM. Create global multi-dimensional arrays:
 1220 PROC3(MulD(), MulD%(), MulD&(), MulD$())
 1230 
 1240 PROC7(FALSE)
 1250 
 1260 REM. Check reported number of dimensions and sizes:
 1270 IF DIM(MulD()) <> 5   OR DIM(MulD(),1) <> 0   OR DIM(MulD(),5) <> 4   STOP
 1280 IF DIM(MulD%()) <> 4  OR DIM(MulD%(),2) <> 2  OR DIM(MulD%(),3) <> 3  STOP
 1290 IF DIM(MulD&()) <> 3  OR DIM(MulD&(),1) <> 2  OR DIM(MulD&(),3) <> 4  STOP
 1300 IF DIM(MulD$()) <> 2  OR DIM(MulD$(),1) <> 3  OR DIM(MulD$(),2) <> 4  STOP
 1310 
 1320 REM. Check size of array:
 1330 IF ^MulD(0,1,2,3,4) - ^MulD(0,0,0,0,0) <> 119*5 STOP
 1340 IF ^MulD%(1,2,3,4) - ^MulD%(0,0,0,0) <> 119*4 STOP
 1350 IF ^MulD&(2,3,4) - ^MulD&(0,0,0) <> 59*1 STOP
 1360 IF ^MulD$(3,4) - ^MulD$(0,0) <> 19*5 STOP
 1370 
 1380 REM. Check arrays are initially empty:
 1390 IF SUM(MulD())   <> 0.0 STOP
 1400 IF SUM(MulD%())  <> 0   STOP
 1410 IF SUM(MulD&())  <> 0   STOP
 1420 IF SUM(MulD$())  <> ""  STOP
 1430 
 1440 REM. Load arrays in a loop:
 1450 I% = 0
 1460 FOR A% = 0 TO 4
 1470   FOR B% = 0 TO 3
 1480     MulD$(B%,A%) = STR$(I%)
 1490     FOR C% = 0 TO 2
 1500       MulD&(C%,B%,A%) = I%
 1510       FOR D% = 0 TO 1
 1530         MulD%(D%,C%,B%,A%) = I% * &00020201
 1550         MulD(0,D%,C%,B%,A%) = I% * 1.0001
 1560         I% += 1
 1590       NEXT
 1600     NEXT
 1610   NEXT
 1620 NEXT
 1630 
 1640 PROC7(TRUE)
 1650 heap% = END
 1660 PROC7(TRUE)
 1670 IF heap% <> END STOP
 1680 
 1690 REM. Check and fill arrays:
 1700 PROC4(MulD(), MulD%(), MulD&(), MulD$())
 1710 
 1720 REM. Check filled arrays:
 1730 IF SUM(MulD())  <> 120*(1 + 241/1024)         STOP
 1740 IF ABS(SUM(MulD%()) - 120*&12345678) > 100    STOP
 1750 IF SUM(MulD&()) <> 60*&AA                     STOP
 1760 IF SUM(MulD$()) <> STRING$(20,"Hello world!") STOP
 1770 
 1780 REM. Initialise arrays:
 1790 PROC5(MulD(), MulD%(), MulD&(), MulD$())
 1800 
 1810 REM. Check initialised arrays:
 1820 IF SUM( MulD() ) <> 15 * 1.015625 + 115 + 115*241/1024 STOP
 1830 IF ABS(SUM( MulD%()) - 15 * &11111111 - 115 * &12345678) > 2048 STOP
 1840 IF SUM(MulD&() ) <> 15 * &11 + 55 * &AA STOP
 1850 IF SUM(MulD$() ) <> "Onetwothreefourfive" + STRING$(15, "Hello world!") STOP
 1860 
 1870 REM. Check MOD and SUMLEN functions:
 1880 Mod1 = 0 : Mod2 = 0 : Mod3 = 0
 1890 FOR A% = 0 TO 4
 1900   FOR B% = 0 TO 3
 1910     FOR C% = 0 TO 2
 1920       Mod1 += MulD&(C%,B%,A%)^2
 1930       FOR D% = 0 TO 1
 1940         Mod2 += MulD%(D%,C%,B%,A%)^2
 1960         Mod3 += MulD(0,D%,C%,B%,A%)^2
 2000       NEXT
 2010     NEXT
 2020   NEXT
 2030 NEXT
 2040 IF MOD(MulD&())  <> SQR(Mod1) STOP
 2050 IF ABS(MOD(MulD%()) - SQR(Mod2)) > 2 STOP
 2060 IF MOD(MulD())   <> SQR(Mod3) STOP
 2070 IF SUM(MulD$()) <> "Onetwothreefourfive" + STRING$(15,"Hello world!") STOP
 2080 
 2090 CLEAR
 2100 REM. Check array multiplication (dot-product):
 2110 DIM A(2,1),B(1,3),C(2,3) : A()=1,2,3,4,5,6 : B()=8,7,6,5,4,3,2,1 : C() = A().B()
 2120 DIM A%(2,1),B%(1,3),C%(2,3) : A%()=1,2,3,4,5,6 : B%()=8,7,6,5,4,3,2,1 : C%() = A%() . B%()
 2130 DIM A&(2,1),B&(1,3),C&(2,3) : A&()=1,2,3,4,5,6 : B&()=8,7,6,5,4,3,2,1 : C&() = A&() . B&()
 2140 C()   -= 16,13,10,7,40,33,26,19,64,53,42,31 : IF SUM(C()) <> 0   OR MOD(C()) <> 0   STOP
 2150 C%()  -= 16,13,10,7,40,33,26,19,64,53,42,31 : IF SUM(C%()) <> 0  OR MOD(C%()) <> 0  STOP
 2160 C&()  -= 16,13,10,7,40,33,26,19,64,53,42,31 : IF SUM(C&()) <> 0  OR MOD(C&()) <> 0  STOP
 2170 
 2180 CLEAR
 2190 REM. Check vector multiplication (dot-product):
 2200 DIM A(5),B(5),C(0):A()=1.0,2.0,3.0,4.0,5.0,6.0:B()=8,7,6,5,4,3:  C() = A() . B() : IF C(0) <> 98  STOP
 2210 DIM A%(5), B%(5), C%(0) : A%()=1,2,3,4,5,6 : B%()=8,7,6,5,4,3 : C%() = A%().B%() : IF C%(0) <> 98 STOP
 2220 DIM A&(5), B&(5), C&(0) : A&()=1,2,3,4,5,6 : B&()=8,7,6,5,4,3 : C&() = A&().B&() : IF C&(0) <> 98 STOP
 2230 
 2240 PRINT "Array tests completed."
 2250 ON ERROR END
 2260 RETURN
 2270 
 2280 DEF PROC1(wond(), wond%(), wond&(), wond$())
 2290 LOCAL I%
 2300 REM. Check array contents:
 2310 FOR I% = 0 TO DIM(wond(),1)
 2320   IF wond(I%)  <> I% * 1.0001                STOP
 2330   IF wond%(I%) <> I% * &01020201             STOP
 2340   IF wond&(I%) <> I%                         STOP
 2350   IF wond$(I%) <> "13 characters" + STR$(I%) STOP
 2360 NEXT
 2370 
 2380 REM. Fill arrays:
 2390 wond()   = 1 + 241/1024
 2400 wond%()  = &12345678
 2410 wond&()  = &AA
 2420 wond$()  = "Hello world!"
 2430 ENDPROC
 2440 
 2450 DEF PROC2(RETURN wond(), RETURN wond%(), RETURN wond&(), RETURN wond$())
 2460 LOCAL I%, a$ : LOCAL DATA : RESTORE +1
 2470 REM. Initialise arrays:
 2480 wond()  = 1.015625, 2.03125, 3.046875, 4.0625, 5.078125
 2490 wond%() = &11111111, &22222222, &33333333, &44444444, &55555555
 2500 wond&() = &11, &22, &33, &44, &55
 2510 wond$() = "One", "two", "three", "four", "five"
 2520 
 2530 REM. Check initialised arrays:
 2540 FOR I% = 1 TO 5
 2550   READ a$
 2560   IF wond(I%-1)   <> I% * 1.015625  STOP
 2570   IF wond%(I%-1)  <> I% * &11111111 STOP
 2580   IF wond&(I%-1)  <> I% * &11       STOP
 2590   IF wond$(I%-1)  <> a$             STOP
 2600 NEXT
 2610 DATA One, two, three, four, five
 2620 ENDPROC
 2630 
 2640 DEF PROC3(RETURN a(), RETURN b%(), RETURN d&(), RETURN f$())
 2650 DIM a(0,1,2,3,4), b%(1,2,3,4), d&(2,3,4), f$(3,4)
 2660 ENDPROC
 2670 
 2680 DEF PROC4(muld(), muld%(), muld&(), muld$())
 2690 LOCAL A%,B%,C%,D%,I%
 2700 REM. Check array contents:
 2710 I% = 0
 2720 FOR A% = 0 TO DIM(muld(),5)
 2730   FOR B% = 0 TO DIM(muld(),4)
 2740     IF VAL(muld$(B%,A%)) <> I% STOP
 2750     FOR C% = 0 TO DIM(muld(),3)
 2760       IF muld&(C%,B%,A%) <> I% MOD 256 STOP
 2770       FOR D% = 0 TO DIM(muld(),2)
 2780         IF muld%(D%,C%,B%,A%) <> I% * &00020201 STOP
 2790         IF muld(0,D%,C%,B%,A%) <> I% * 1.0001 STOP
 2800         I% += 1
 2810       NEXT
 2820     NEXT
 2830   NEXT
 2840 NEXT
 2850 
 2860 REM. Fill arrays:
 2870 muld()   = 1 + 241/1024
 2880 muld%()  = &12345678
 2890 muld&()  = &AA
 2900 muld$()  = "Hello world!"
 2910 ENDPROC
 2920 
 2930 DEF PROC5(muld(), muld%(), muld&(), muld$())
 2940 REM. Initialise arrays:
 2950 muld()  = 1.015625, 2.03125, 3.046875, 4.0625, 5.078125
 2960 muld%() = &11111111, &22222222, &33333333, &44444444, &55555555
 2970 muld&() = &11, &22, &33, &44, &55
 2980 muld$() = "One", "two", "three", "four", "five"
 2990 ENDPROC
 3000 
 3010 DEF PROC6(N%)
 3020 LOCAL I%, heap%, OneD(), OneD%(), OneD&(), OneD$()
 3030 heap% = END
 3040 DIM OneD(N%), OneD%(N%), OneD&(N%), OneD$(N%)
 3050 IF heap% <> END STOP
 3060 
 3070 REM. Check reported number of dimensions and sizes:
 3080 IF DIM(OneD()) <> 1   OR DIM(OneD(),1) <> N%  STOP
 3090 IF DIM(OneD%()) <> 1  OR DIM(OneD%(),1) <> N% STOP
 3100 IF DIM(OneD&()) <> 1  OR DIM(OneD&(),1) <> N% STOP
 3110 IF DIM(OneD$()) <> 1  OR DIM(OneD$(),1) <> N% STOP
 3120 
 3130 REM. Check size of array:
 3140 IF ^OneD(N%) - ^OneD(0)     <> N%*5 STOP
 3150 IF ^OneD%(N%) - ^OneD%(0)   <> N%*4 STOP
 3160 IF ^OneD&(N%) - ^OneD&(0)   <> N%*1 STOP
 3170 IF ^OneD$(N%) - ^OneD$(0)   <> N%*5 STOP
 3180 
 3190 REM. Check arrays are initially empty:
 3200 FOR I% = 0 TO N%
 3210   IF OneD(I%)   <> 0.0 STOP
 3220   IF OneD%(I%)  <> 0   STOP
 3230   IF OneD&(I%)  <> 0   STOP
 3240   IF OneD$(I%)  <> ""  STOP
 3250 NEXT
 3260 
 3270 REM. Load arrays in a loop:
 3280 FOR I% = 0 TO N%
 3290   OneD(I%)  = I% * 1.0001
 3300   OneD%(I%) = I% * &01020201
 3310   OneD&(I%) = I%
 3320   OneD$(I%) = "13 characters" + STR$(I%)
 3330 NEXT
 3340 
 3350 REM. Check and fill arrays:
 3360 PROC1(OneD(), OneD%(), OneD&(), OneD$())
 3370 
 3380 REM. Check filled arrays:
 3390 FOR I% = 0 TO N%
 3400   IF OneD(I%)  <> 1 + 241/1024   STOP
 3410   IF OneD%(I%) <> &12345678      STOP
 3420   IF OneD&(I%) <> &AA            STOP
 3430   IF OneD$(I%) <> "Hello world!" STOP
 3440 NEXT
 3450 
 3460 REM. Initialise and check arrays:
 3470 PROC2(OneD(), OneD%(), OneD&(), OneD$())
 3480 
 3490 REM. Check SUM function:
 3500 IF SUM(OneD()) <> 15 * 1.015625 + (N%-4) * (1 + 241/1024) STOP
 3510 IF SUM(OneD%()) <> 15 * &11111111 + (N%-4) * &12345678 STOP
 3520 IF SUM(OneD&()) <> 15 * &11 + (N%-4) * &AA STOP
 3530 IF SUM(OneD$()) <> "Onetwothreefourfive" + STRING$(N%-4, "Hello world!") STOP
 3540 
 3550 REM. Check MOD and SUMLEN functions:
 3560 LOCAL m1, m2, m4
 3570 FOR I% = 0 TO N%
 3580   m1 += OneD(I%) ^ 2
 3590   m2 += OneD%(I%) ^ 2
 3600   m4 += OneD&(I%) ^ 2
 3610 NEXT
 3620 IF MOD(OneD())   <> SQR(m1) STOP
 3630 IF MOD(OneD%())  <> SQR(m2) STOP
 3640 IF MOD(OneD&())  <> SQR(m4) STOP
 3650 IF SUMLEN(OneD$()) <> 19 + (N%-4) * 12 STOP
 3660 ENDPROC
 3670 
 3680 DEF PROC7(F%)
 3690 LOCAL A%, B%, C%, D%, I%
 3700 LOCAL MulD(), MulD%(), MulD&(), MulD$()
 3710 DIM MulD$(4,3), MulD&(1,4,3), MulD%(2,1,4,3), MulD(0,2,1,4,3)
 3720 
 3730 REM. Check reported number of dimensions and sizes:
 3740 IF DIM(MulD$()) <> 2 OR DIM(MulD$(),1) <> 4 OR DIM(MulD$(),2) <> 3 STOP
 3750 IF DIM(MulD&()) <> 3 OR DIM(MulD&(),2) <> 4 OR DIM(MulD&(),3) <> 3 STOP
 3760 IF DIM(MulD%()) <> 4 OR DIM(MulD%(),3) <> 4 OR DIM(MulD%(),4) <> 3 STOP
 3770 IF DIM(MulD())  <> 5 OR DIM(MulD(),4)  <> 4 OR DIM(MulD(),5)  <> 3 STOP
 3780 
 3790 REM. Check size of array:
 3800 IF ^MulD$(4,3)      - ^MulD$(0,0)      <> 19*5  STOP
 3810 IF ^MulD&(1,4,3)    - ^MulD&(0,0,0)    <> 39*1  STOP
 3820 IF ^MulD%(2,1,4,3)  - ^MulD%(0,0,0,0)  <> 119*4 STOP
 3830 IF ^MulD(0,2,1,4,3) - ^MulD(0,0,0,0,0) <> 119*5 STOP
 3840 
 3850 REM. Check arrays are initially empty:
 3860 IF SUM(MulD())   <> 0.0 STOP
 3870 IF SUM(MulD%())  <> 0   STOP
 3880 IF SUM(MulD&())  <> 0   STOP
 3890 IF SUM(MulD$())  <> ""  STOP
 3900 
 3910 REM. Load arrays in a loop:
 3920 I% = 0
 3930 FOR A% = 0 TO 3
 3940   FOR B% = 0 TO 4
 3950     MulD$(B%,A%) = RIGHT$("            " + STR$(I%), 12)
 3960     FOR C% = 0 TO 1
 3970       MulD&(C%,B%,A%) = I%
 3980       FOR F% = 0 TO 2
 3990         MulD%(F%,C%,B%,A%) = I% * &00020201
 4000         MulD(0,F%,C%,B%,A%) = I% * 1.0001
 4010         I% += 1
 4020       NEXT
 4030     NEXT
 4040   NEXT
 4050 NEXT
 4060 
 4070 REM. Check and fill arrays:
 4080 PROC4(MulD(), MulD%(), MulD&(), MulD$())
 4090 
 4100 REM. Check filled arrays:
 4110 IF SUM(MulD())  <> 120*(1 + 241/1024)          STOP
 4120 IF ABS(SUM(MulD%()) <> 120*&12345678) > 2048   STOP
 4130 IF SUM(MulD&()) <> 40*&AA                      STOP
 4140 IF SUM(MulD$()) <> STRING$(20, "Hello world!") STOP
 4150 
 4160 REM. Initialise arrays:
 4170 PROC5(MulD(), MulD%(), MulD&(), MulD$())
 4180 
 4190 REM. Check initialised arrays:
 4200 IF SUM(MulD()) <> 15 * 1.015625 + 115 + 115*241/1024 STOP
 4210 IF ABS(SUM(MulD%()) - 15 * &11111111 - 115 * &12345678) > 2048 STOP
 4220 IF SUM(MulD&()) <> 15 * &11 + 35 * &AA STOP
 4230 IF SUM(MulD$()) <> "Onetwothreefourfive" + STRING$(15,"Hello world!") STOP
 4240 
 4250 REM. Check MOD and SUMLEN functions:
 4260 Mod1 = 0 : Mod2 = 0 : Mod3 = 0
 4270 FOR A% = 0 TO 3
 4280   FOR B% = 0 TO 4
 4300     FOR C% = 0 TO 1
 4310       Mod1 += MulD&(C%,B%,A%)^2
 4320       FOR D% = 0 TO 2
 4325         Mod2 += MulD%(D%,C%,B%,A%)^2
 4330         Mod3 += MulD(0,D%,C%,B%,A%)^2
 4340       NEXT
 4350     NEXT
 4360   NEXT
 4370 NEXT
 4380 IF MOD(MulD&())   <> SQR(Mod1) STOP
 4390 IF ABS(MOD(MulD%()) - SQR(Mod2)) > 2 STOP
 4400 IF MOD(MulD())  <> SQR(Mod3) STOP
 4410 IF SUM(MulD$()) <> "Onetwothreefourfive" + STRING$(15, "Hello world!") STOP
 4420 ENDPROC
