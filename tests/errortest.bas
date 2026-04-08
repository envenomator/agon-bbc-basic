   10 PRINT "Running error tests..."
   20 DIM S% LOCAL -1
   40 ON ERROR GOTO FNerror : STOP
   50 R% = PAGE : R% += ?R% : R% += ?R% : R% += ?R% : R% += ?R%
   60 E% = 4  : A$ : REM Mistake
   70 E% = 4  : C!0=1 : REM Mistake
   80 E% = 5  : PRINT INSTR(A$ : REM Missing ,
   90 E% = 6  : A=0:A$="WOMBAT":B$=A : REM Type mismatch
  100 E% = 7  : =1  : REM Not in a function
  180 E% = 9  : A$="WOMBAT
  190 E% = 9  : ON 3 PROC1("), PROC2,PROC3
  200 E% = 9  : IF FALSE PROC3(")
  210 E% = 10 : DIM A$ : REM Bad DIM statement
  220 E% = 10 : DIM 100 : REM Bad DIM statement
  230 E% = 10 : DIM QQ(-1) : REM Bad DIM statement
  240 E% = 15 : DIM C(10),C(11) : REM Bad subscript
  250 E% = 15 : DIM A(10):DIM A(11) : REM Bad subscript
  260 REM E% = 11 : DIM E((HIMEM-PAGE)/5) : REM DIM space
  270 REM E% = 11 : DIM F((HIMEM-PAGE)/5) : REM DIM space
  280 E% = 11 : DIM A% (HIMEM-PAGE)/2,A% (HIMEM-PAGE)/2 : REM DIM space
  290 E% = 11 : DIM B% -1 : DIM A% HIMEM-B%-256 : REM DIM space
  300 E% = 11 : DIM E HIMEM-PAGE : REM DIM space
  310 E% = 12 : LOCAL : REM Not in a FN or PROC
  320 E% = 13 : ENDPROC : REM Not in a procedure
  330 E% = 14 : B(1)=3 : REM Bad use of array
  340 E% = 14 : DIM A$(10),B$(10) : IF A$()=B$() : REM Bad use of array
  350 E% = 15 : DIM Q(10):Q(11)=11 : REM Bad subscript
  360 E% = 16 : ERR : REM Syntax error
  370 E% = 16 : EOF : REM Syntax error
  380 E% = 16 : PRINT { : REM Syntax error
  390 E% = 16 : GOTO 390,390 : REM Syntax error
  400 E% = 16 : GOSUB 1290,1290 : REM Syntax error
  410 E% = 16 : PROCNOWT,PROCNOWT : REM Syntax error
  420 E% = 16 : PRINT SUM : REM Syntax error
  430 E% = 17 : ERROR 17, "Escape"
  440 E% = 18 : PRINT 1/0 : REM Division by zero
  450 E% = 18 : PROCdbz(1/0) : REM Division by zero
  460 E% = 18 : PRINT 0/0 : REM Division by zero
  470 E% = 19 : A$=STRING$(&7FFFFFFF, A$) : REM String too long
  480 E% = 20 : PRINT 1E1000*1E1000*1E1000*1E1000*1E1000 : REM Number too big
  490 E% = 20 : PRINT INT(2^17000) : REM Number too big
  500 E% = 20 : A%=2^31 : REM Number too big
  510 E% = 20 : A% = -2^31 - 1 : REM Number too big
  520 E% = 20 : A%=2^63 : REM Number too big
  530 E% = 20 : A% = -2^63 - 1025 : REM Number too big
  540 E% = 20 : A# = 1E309 : REM Number too big
  550 E% = 20 : A = -10^5000 : REM Number too big
  560 E% = 21 : PRINT SQR(-2) : REM Negative root
  570 E% = 22 : PRINT LN(-PI) : REM Logarithm range
  580 E% = 22 : PRINT LOG(0) : REM Logarithm range
  590 E% = 23 : A = SIN(1E37) : REM Accuracy lost
  600 E% = 24 : PRINT EXP(12000) : REM Exponent range
  620 E% = 26 : PRINT WOMBAT : REM No such variable
  630 E% = 26 : PRINT WOMBAT : REM No such variable
  640 E% = 26 : PROCJILL(WOMBAT,"") : REM No such variable
  650 E% = 27 : PRINT (22/7 : REM Missing )
  660 E% = 28 : QQ=& : REM Bad hex or binary
  670 E% = 28 : QQ=% : REM Bad hex or binary
  680 E% = 29 : PROCHELLO : REM No such FN/PROC
  690 E% = 30 : PROC    HELLO : REM Bad call
  700 E% = 31 : PROCJILL(A) : REM Incorrect arguments
  710 E% = 32 : NEXT : REM Not in a FOR loop
  720 E% = 33 : FOR I%=1 TO 10:NEXT J% : REM Can't match FOR
  730 E% = 34 : FOR : REM Bad FOR variable
  740   E% = 34 : FOR A$ = : NEXT : REM Bad FOR variable
  760   E% = 36 : FOR I=1 : NEXT : REM Missing TO
  770   E% = 37 : CASE I : REM Missing OF
  780   ENDCASE : E% = 38 : RETURN : REM Not in a subroutine
  790   E% = 39 : ON 1 RUN : REM ON syntax
  800   E% = 40 : ON 1000 GOTO 370 : REM ON range
  810   E% = 41 : GOTO 999 : REM No such line
  820   E% = 41 : GOSUB 999 : REM No such line
  830   E% = 41 : RESTORE 999 : REM No such line
  840   E% = 42 : RESTORE +1 : READ I,J : REM Out of DATA
  850   E% = 43 : UNTIL : REM Not in a WHILE loop
  860 E% = 16 : OTHERWISE : REM Syntax error
  870 E% = 16 : WHEN : REM Syntax error
  880 E% = 45 : BPUT : REM Missing #
  890 E% = 46 : ENDWHILE : REM Not in a WHILE loop
  900 E% = 47 : CASE I OF
  910   ENDIF : E% = 48 : CASE I OF ENDWHILE ENDWHILE : REM OF not last
  920   E% = 49 : IF FALSE THEN
  970     E% = 54 : RESTORE DATA : REM DATA not LOCAL
 1020     E% = 1  : DIM P% 1 : [OPT 2 : .L JR Z,0 : REM Jump out of range
 1040     E% = 3  : [OPT 0:.L : REM Multiple label
 1060     E% = 192 : REPEATF%=OPENIN ("ERRORTST"):UNTIL F% = 0 : REM Too many open files
 1070     E% = 196 : CLOSE#0:OSCLI("REN ""ARRAYTST""=""ARRAYTST""") : REM File exists
 1080     E% = 204 : F% = OPENOUT("??????")
 1100     E% = 214 : CHAIN "QWOMBAT" : REM File or path not found
 1110     E% = 222 : PRINT BGET#12 : REM Invalid channel
 1120     E% = 222 : BPUT#12,0     : REM Invalid channel
 1130     E% = 222 : PTR#12 = 0    : REM Invalid channel
 1140     E% = 222 : CLOSE#12      : REM Invalid channel
 1190     E% = 253 : *LOAD "  : REM Bad string
 1200     E% = 254 : *SAVE A 10000 : REM Bad command
 1220     ON ERROR OFF
 1230     DEF PROCNOWT:ENDPROC
 1240     DEF PROCJILL(A,A$):PRINT "OK":ENDPROC
 1250     DEF PROCdbz(A%) : ENDPROC
 1260     PRINT "Error tests completed."
 1270     END
 1290     
 1300     DEF FNerror
 1310     L% = ?(R%+1) + 256 * ?(R%+2)
 1315     REM L% = R%!1 AND &FFFF
 1330     IF ERL <> L% PRINT "An error should have occurred at line ";L% " but didn't" : STOP
 1340     IF ERR <> E% PRINT "Error number was "; ERR " but should have been "; E% " at line ";ERL : STOP
 1350     R% += ?R%
 1355     REM = R%!1 AND &FFFF
 1360     = ?(R%+1) + 256 * ?(R%+2)
