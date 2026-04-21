10000 REM :::::::::::::::::::::::::::::::::::::::::::::
10010 REM :: SNAC-SNAKE FOR AgonLight (BBC BASIC v3) ::
10020 REM :::::::::::::::::::::::::::::::::::::::::::::
10030 REM :: 20231103: V1.3 - Use new VDP MODEs and  ::
10040 REM :: miscellaneous little improvements       ::
10050 REM :::::::::::::::::::::::::::::::::::::::::::::
10060 REM :: The game was originally created for the ::
10070 REM :: Olimex Weekend Programming Challenge    ::
10080 REM :: Issue #3                                ::
10090 REM :::::::::::::::::::::::::::::::::::::::::::::
10100 REM :: It is best experienced on a 40+ column, ::
10110 REM :: 16+ color display                       ::
10120 REM :::::::::::::::::::::::::::::::::::::::::::::
10130 CLEAR
10140 REPEAT CLS:SY$=FN_TO_UPPER(FN_PROMPT(0,0,"TARGET (A)gon or (B)BC B-SDL:","A")):UNTIL SY$ = "A" OR SY$ = "B"
10150 IF SY$ = "B" THEN LEFT = 136:RIGHT = 137:DOWN = 138:UP = 139:DL% = 10:MO% = 9:ELSE LEFT = 8:RIGHT = 21:DOWN = 10:UP = 11:DL% = 14:MO% = 13
10160 IF SY$ = "A" THEN REPEAT CLS:MO$=FN_PROMPT_FOR_NUMBERS(0,0,"MODE (0,3,4,8,9,12,13,...):",STR$(MO%),3):UNTIL VAL(MO$) >= 0:MO% = VAL(MO$)
10170 MODE MO%
10180 PROC_SETUP
10190 ON ERROR PROC_HANDLE_ERROR:REM Handle ESC key
10200 PROC_WELCOME
10210 GoodBye% = FALSE:REPEAT
10220   PROC_NEW_GAME
10230   PROC_MAIN_LOOP:REM Invoke main loop
10240   PROC_DEATH_ANIMATION(X(P), Y(P))
10250   PROC_GAME_OVER
10260   Resp$ = FN_PLAY_AGAIN:GoodBye% = (Resp$ = "N")
10270 UNTIL GoodBye%
10280 PROC_GOODBYE(GameName$)
10290 END
10300 :
10310 REM ::::::::::::::::::::
10320 REM ::   Setup Game   ::
10330 REM ::::::::::::::::::::
10340 DEF PROC_SETUP
10350 GameName$ = "Snac-Snake"
10360 BLACK = 0:RED = 1:GREEN = 2:YELLOW = 3:BLUE = 4:MAGENTA = 5:CYAN = 6:WHITE = 7:C_ORANGE = 8 + (SY$ = "A" AND FN_COLORCOUNT = &40) *-50
10370 BLANK = 32:DOT = 38:BLANK_X = 64:SKULL = 42
10380 MON_WHITE = 134:MON_BLUE = 135:MON_RED = 136:MON_PINK = 137:MON_CYAN = 138:MON_GREEN = 139:MON_RESET = ASC("M")
10390 E_HEART = 129:E_DIAMOND = 130:E_FRUIT = 131:E_CIRC = 132:E_DISC = 133:E_TOADSTOOL = 147
10400 B_VERT = 140:B_HORZ = 141:B_UR = 142:B_UL = 143:B_DL = 144:B_DR = 145
10410 SN_W = 128:SN_L = 123:SN_R = 124:SN_D = 125:SN_U = 126
10420 SN_D1 = 150:SN_D2 = 151:SN_D3 = 152:SN_D4 = 153:SN_D5 = 154:SN_D6 = 155
10430 MAXINT% = &3B9AC9FF
10440 IF SY$ = "A" THEN CW% = FN_getByteVDP(&13):CH% = FN_getByteVDP(&14)-2:ELSE CW% = 40:CH% = 23
10450 UX% = 0:UY% = 1:LX% = CW% - UX% - 1:LY% = CH% - UY%:REM Playing Field Boundaries
10460 UB% = (LX% - UX% + 1) + (LY% - UY% + 2) * LX%
10470 HighScore% = 1500:REM Set minimum high score
10480 MAX_SIZE% = (CW% + CH% - 2) DIV 2:REM Maximum Size of Snake
10490 MAX_MONSTER_SETS% = CW% DIV 40:REM Maximum number of 4-monster sets
10500 MAX_MONSTERS% = MAX_MONSTER_SETS% * 4:REM Maximum number of monsters that can appear at one time
10510 TK = TIME:PROC_SLEEP(100):TK = TIME - TK:REM CALIBRATE TIME TICKS
10520 SP% = DL% * TK / 100:REM Speed Throttler (smaller value speeds up the game)
10530 DIM PV$(1),PH$(1)
10540 PH$(0)=CHR$(B_DL)+CHR$(BLANK_X)+CHR$(B_UL):PH$(1)=CHR$(B_DR)+CHR$(BLANK_X)+CHR$(B_UR)
10550 PV$(0)=CHR$(B_DL)+CHR$(BLANK_X)+CHR$(B_DR):PV$(1)=CHR$(B_UL)+CHR$(BLANK_X)+CHR$(B_UR)
10560 MO$=STRING$(MAX_MONSTER_SETS%,CHR$(MON_RED)+CHR$(MON_PINK)+CHR$(MON_CYAN)+CHR$(MON_GREEN))
10570 BX$=CHR$(B_UR) + CHR$(B_HORZ) + CHR$(B_UL) + CHR$(B_VERT) + CHR$(B_DL) + CHR$(B_HORZ) + CHR$(B_DR) + CHR$(B_VERT)
10580 DIM X(MAX_SIZE%-1),Y(MAX_SIZE%-1),MP%(MAX_MONSTERS% - 1),screen CW% * CH%
10590 PROC_REDEFINE_COLORS
10600 PROC_REDEFINE_CHARS
10610 PROC_HISCORE_READ(GameName$)
10620 ENDPROC
10630 :
10640 REM ::::::::::::::::::::::
10650 REM ::     New Game     ::
10660 REM ::::::::::::::::::::::
10670 DEF PROC_NEW_GAME
10680 LOCAL i%
10690 TI = 0:TIME = 0:Dead% = FALSE:Score% = 0:Size% = 2
10700 P = Size% - 1:REM Index Of Initial Position Of Snake's Head
10710 AF = 0:REM Initial Animation Frame For Snake's Head
10720 X(1) = CW% DIV 2:Y(1) = CH% DIV 2:X(0) = X(1):Y(0) = Y(1) - 1:REM Snake Starting Position
10730 D% = 3:REM Direction For Snake (initial = down)
10740 M_Position% = 0:REM Monster Position Index
10750 Portal_State% = 0:REM Portal State
10760 M_Count% = 0:REM Number Of Active Monsters
10770 MonGoWhite% = FALSE:MonReset% = FALSE:REM Monster color timer values
10780 Rvs_Dir% = FALSE:REM Reverse Direction Flag
10790 FOR i% = 0 TO MAX_MONSTERS% - 1:MP%(i%) = -1:NEXT i%
10800 CLS
10810 PROC_HIDE_CURSOR:PROC_CLEAR_SCREEN
10820 PROC_DRAW_PLAYING_FIELD(UX%, UY%, CW% - 2*UX%, CH% - UY%)
10830 VDU 17,YELLOW:PROC_FULL_CENTER_TEXT("GET READY!"):REM Display GET READY Message
10840 FOR i% = 1 TO 7:PROC_SOUND(i% + 10, 1.05 * i%):NEXT i%:REM Play some tones
10850 PROC_SLEEP(200):PROC_FULL_CENTER_TEXT(STRING$(10, " ")):REM Erase GET READY Message after 2 Seconds
10860 PROC_DRAW(X(0),Y(0),SN_W, TRUE):PROC_DRAW(X(1),Y(1),SN_W, TRUE):REM Draw Snake at Initial Position
10870 PROC_DISPLAY_SCORES
10880 ENDPROC
10890 :
10900 REM :::::::::::::::::::::::
10910 REM :: Play Another Game ::
10920 REM :::::::::::::::::::::::
10930 DEF FN_PLAY_AGAIN
10940 LOCAL message$,r$
10950 message$ = "Play Again? (Y/N)":PROC_EMPTY_KEYBOARD_BUFFER
10960 REPEAT r$ = FN_PROMPT((CW% - LEN(message$)) DIV 2, CH% DIV 2 + 2, message$, "") UNTIL INSTR("YN", r$) <> 0
10970 = r$
10980 :
10990 REM :::::::::::::::::
11000 REM :: Say Goodbye ::
11010 REM :::::::::::::::::
11020 DEF PROC_GOODBYE(game$)
11030 PROC_HIDE_CURSOR
11040 CLS:PROC_FULL_CENTER_TEXT("So long and thank you for playing...")
11050 FOR i% = 0 TO FN_CENTER(game$) - 1:PRINTTAB(0, CH% DIV 2 + 2)STRING$(i%, " ")CHR$(17)CHR$(i% MOD 7 + 1)game$:PROC_SLEEP(20):NEXT i%
11060 PROC_DEFAULT_COLORS
11070 PROC_SHOW_CURSOR
11080 ENDPROC
11090 :
11100 REM ::::::::::::::::::::::
11110 REM ::     Main Loop    ::
11120 REM ::::::::::::::::::::::
11130 DEF PROC_MAIN_LOOP
11140 LOCAL dd%,prevsec%,sec%, tt%
11150 sec% = -1
11160 REPEAT
11170   TI = FN_INT_TIME
11180   prevsec% = sec%:sec% = FN_INT_TIME DIV TK
11190   PROC_MONSTER_COLOR_CHECK
11200   IF FN_IS_TIME(sec%, prevsec%, 30) THEN PROC_UPDATE_PORTAL_STATE
11210   IF SY$ <> "A" THEN dd% = INKEY(INT(TK / 100 * DL%)):PROC_EMPTY_KEYBOARD_BUFFER:ELSE dd% = FN_ASCII_KEYCODE
11220   dd% = FN_MAP_INPUT(dd%):IF dd% > 0 THEN Rvs_Dir% = FN_CHECK_FOR_REVERSE_DIRECTION(D%, dd%):D% = dd%
11230   PROC_GROW_SNAKE(D%)
11240   IF FN_IS_TIME(sec%, prevsec%, 2.5) THEN PROC_RANDOM_EVENT
11250   PROC_DISPLAY_SCORES:REM Update score display
11260   tt% = FN_INT_TIME - TI:IF SY$ = "A" THEN PROC_SLEEP((tt% < SP%) * -(SP% - tt%)):REM Throttle if necessary
11270 UNTIL Dead%
11280 ENDPROC
11290 :
11300 REM ::::::::::::::::::::::::::::
11310 REM :: Miscellaneous Routines ::
11320 REM ::::::::::::::::::::::::::::
11330 DEF PROC_COUT(text$, row%):VDU 31,0,CH%+row%,17,WHITE:PRINT text$:ENDPROC
11340 DEF PROC_ERASE(x%, y%):PROC_PLOT(x%, y%, BLANK, BLACK):ENDPROC
11350 DEF PROC_MON_GO_WHITE:MonGoWhite% = FN_INT_TIME + (TK+DL%)*3:MonReset% = (MonGoWhite% + (TK+DL%)*2) MOD MAXINT%:ENDPROC
11360 DEF FN_X_DELTA(d%):=(d% = 1) + (d% = 2)*-1 + (d% = 3)*0 + (d% = 4)*0
11370 DEF FN_Y_DELTA(d%):=(d% = 1)*0 + (d% = 2)*0 + (d% = 3)*-1 + (d% = 4)
11380 DEF FN_INT_TIME:=TIME MOD MAXINT%
11390 DEF FN_MAP_INPUT(n%):=(n% = LEFT)*-1 + (n% = RIGHT)*-2 + (n% = DOWN)*-3 + (n% = UP)*-4
11400 DEF FN_NEXT_POS(i%):=(i% + 1) MOD MAX_SIZE%
11410 DEF FN_PAUSED(n):=NOT((TIME - TI) > n):REM Attempt To Determine If Game Should Throttle Down
11420 DEF FN_HASH(x%, y%):=x% + y% * CW%:REM (x% - UX%) + (y% - UY%) * (LX% - UX%)
11430 DEF FN_RND_EDIBLE:LOCAL r%:r% = FN_RND_INT(1, 4):= (r% < 4)*-(E_HEART + r% - 1) + (r% = 4)*-E_TOADSTOOL
11440 DEF FN_RND_X:=FN_RND_INT(UX%, LX%):REM 1 - 38
11450 DEF FN_RND_Y:=FN_RND_INT(UY%, LY%):REM 1 - 23
11460 DEF FN_XYINDEX(x%, y%):= y% * CW% + x%
11470 :
11480 REM :::::::::::::::::::::::::::::::::
11490 REM :: Random Integer Within Range ::
11500 REM :::::::::::::::::::::::::::::::::
11510 DEF FN_RND_INT(lo%, hi%):= (RND(1) * (hi% - lo% + 1)) + lo%
11520 :
11530 REM ::::::::::::::::::::::::::::::::
11540 REM :: Return TRUE when random    ::
11550 REM :: value is below given value ::
11560 REM ::::::::::::::::::::::::::::::::
11570 DEF FN_RND_PCT(n%):=RND(1) <= (n% / 100):REM Returns TRUE or FALSE
11580 :
11590 REM ::::::::::::::::::
11600 REM ::  Frame Wait  ::
11610 REM ::::::::::::::::::
11620 DEF PROC_WAIT(frames%)
11630 LOCAL i%
11640 FOR i% = 1 TO frames%
11650   *FX 19
11660 NEXT i%
11670 ENDPROC
11680 :
11690 REM ::::::::::::::::::::::
11700 REM ::   To Uppercase   ::
11710 REM ::::::::::::::::::::::
11720 DEF FN_TO_UPPER(ch$):LOCAL ch%:ch% = ASC(ch$):ch$ = CHR$(ch% + 32 * (ch% >= 97 AND ch% <= 122)):=ch$
11730 :
11740 REM :::::::::::::::::::::::::
11750 REM :: Prompt For Response ::
11760 REM :::::::::::::::::::::::::
11770 DEF FN_PROMPT(x%, y%, text$, default$)
11780 LOCAL r$
11790 PRINT TAB(x%, y%)text$;" ";default$:PRINT TAB(x% + LEN(text$) + 1, y%);
11800 r$ = GET$:r$ = FN_TO_UPPER(r$):IF r$ = CHR$(13) THEN r$ = default$
11810 := r$
11820 :
11830 REM :::::::::::::::::::::::::::::::::
11840 REM :: Enter numbers from keyboard ::
11850 REM :::::::::::::::::::::::::::::::::
11860 DEF FN_PROMPT_FOR_NUMBERS(x%, y%, text$, default$, length%)
11870 LOCAL c$, r$
11880 r$ = "":PROC_EMPTY_KEYBOARD_BUFFER:PROC_SHOW_CURSOR
11890 PRINT TAB(x%, y%)text$;" ";default$:PRINT TAB(x% + LEN(text$) + 1, y%);
11900 REPEAT
11910   c$ = GET$
11920   IF ((c$ = CHR$(127) OR c$ = CHR$(8)) AND LEN(r$) > 0) THEN r$ = LEFT$(r$, LEN(r$) - 1):PRINT CHR$(127);
11930   IF ((c$ >= "0" AND c$ <= "9") AND LEN(r$) < length%) THEN r$ = r$ + c$:PRINT c$;
11940   IF c$ = CHR$(13) AND LEN(r$) = 0 THEN r$ = default$
11950 UNTIL (c$ = CHR$(13) AND LEN(r$) <= length%)
11960 PROC_HIDE_CURSOR
11970 := r$
11980 :
11990 REM :::::::::::::::::::::
12000 REM ::   Center text   ::
12010 REM :::::::::::::::::::::
12020 DEF FN_CENTER(text$):= (CW% - LEN(text$)) DIV 2
12030 :
12040 REM ::::::::::::::::::::::
12050 REM :: Maximum of x & y ::
12060 REM ::::::::::::::::::::::
12070 DEF FN_MAX(x, y):= y + (x > y) * (y - x)
12080 :
12090 REM ::::::::::::::::::::::
12100 REM :: Minimum of x & y ::
12110 REM ::::::::::::::::::::::
12120 DEF FN_MIN(x, y):= y + (x < y) * (y - x)
12130 :
12140 REM :::::::::::::::::::::::::::
12150 REM ::   Bounded time ticks  ::
12160 REM :::::::::::::::::::::::::::
12170 DEF FN_INT_TIME:=TIME MOD MAXINT%
12180 :
12190 REM :::::::::::::::::::::::
12200 REM :: Has time reached  ::
12210 REM :: target seconds?   ::
12220 REM :::::::::::::::::::::::
12230 DEF FN_IS_TIME(sec%, prevSec%, targetSec%):= (sec% MOD targetSec% = 0 AND sec% <> prevSec%)
12240 :
12250 REM ::::::::::::::::::::::
12260 REM :: Retrieve a byte  ::
12270 REM :: register value   ::
12280 REM :: from VDP         ::
12290 REM ::::::::::::::::::::::
12300 DEF FN_getByteVDP(var%):A% = &A0:L% = var%:= USR(&FFF4)
12310 :
12320 REM ::::::::::::::::::::::
12330 REM :: Retrieve a word  ::
12340 REM :: register value   ::
12350 REM :: from VDP         ::
12360 REM ::::::::::::::::::::::
12370 DEF FN_getWordVDP(var%):= FN_getByteVDP(var%) + 256 * FN_getByteVDP(var% + 1)
12380 :
12390 REM ::::::::::::::::::::::
12400 REM :: Retrieve the     ::
12410 REM :: number of colors ::
12420 REM :: reported by VDP  ::
12430 REM ::::::::::::::::::::::
12440 DEF FN_COLORCOUNT:= FN_getByteVDP(&15)
12450 :
12460 REM ::::::::::::::::::::::
12470 REM :: Retrieve the     ::
12480 REM :: ASCII key code   ::
12490 REM :: reported by VDP  ::
12500 REM ::::::::::::::::::::::
12510 DEF FN_ASCII_KEYCODE:= FN_getByteVDP(&05)
12520 :
12530 REM ::::::::::::::::::::::
12540 REM :: Retrieve the     ::
12550 REM :: Virtual key code ::
12560 REM :: reported by VDP  ::
12570 REM ::::::::::::::::::::::
12580 DEF FN_VIRTUAL_KEYCODE:= FN_getByteVDP(&17)
12590 :
12600 REM :::::::::::::::::::::::::::::
12610 REM :: Retrieve the number of  ::
12620 REM :: keys as reported by VDP ::
12630 REM :::::::::::::::::::::::::::::
12640 DEF FN_ASCII_KEYCOUNT:= FN_getByteVDP(&19)
12650 :
12660 REM :::::::::::::::::::::::::::::::::
12670 REM :: Retrieve a keypress within  ::
12680 REM :: the given timeout value     ::
12690 REM :::::::::::::::::::::::::::::::::
12700 DEF FN_GET_KEY(timeout%)
12710 LOCAL i%, keycount%, r%, sync%
12720 r% = -1
12730 keycount% = FN_ASCII_KEYCOUNT
12740 i% = 0
12750 REPEAT
12760   IF keycount% <> FN_ASCII_KEYCOUNT THEN r% = FN_ASCII_KEYCODE:IF r% = 0 THEN r% = FN_VIRTUAL_KEYCODE ELSE *FX 19
12770   i% = i% + 1
12780 UNTIL i% = timeout% OR r% > 0
12790 := r%
12800 :
12810 REM :::::::::::::::::::::::::::
12820 REM :: Empty Keyboard Buffer ::
12830 REM :::::::::::::::::::::::::::
12840 DEF PROC_EMPTY_KEYBOARD_BUFFER
12850 REPEAT UNTIL INKEY(0) = -1
12860 ENDPROC
12870 :
12880 REM ::::::::::::::::::::::::::::
12890 REM :: Disable display of the ::
12900 REM :: cursor on the screen   ::
12910 REM ::::::::::::::::::::::::::::
12920 DEF PROC_HIDE_CURSOR:VDU 23,1,0;0;0;0;:ENDPROC
12930 :
12940 REM ::::::::::::::::::::::::::::
12950 REM :: Enable display of the  ::
12960 REM :: cursor on the screen   ::
12970 REM ::::::::::::::::::::::::::::
12980 DEF PROC_SHOW_CURSOR:VDU 23,1,1;0;0;0;:ENDPROC
12990 :
13000 REM :::::::::::::::::::::::::::::::::
13010 REM :: Center text both vertically ::
13020 REM :: and horizontally            ::
13030 REM :::::::::::::::::::::::::::::::::
13040 DEF PROC_FULL_CENTER_TEXT(text$):VDU 31,FN_CENTER(text$), CH% DIV 2:PRINT text$;:ENDPROC
13050 :
13060 REM :::::::::::::::::::::::::::::::::::::::
13070 REM :: Pause execution of the program    ::
13080 REM :: for a number of ticks (1/100) sec ::
13090 REM :::::::::::::::::::::::::::::::::::::::
13100 DEF PROC_SLEEP(hundredth_seconds%):LOCAL t:hundredth_seconds% = hundredth_seconds% + (hundredth_seconds% < 0) * -hundredth_seconds%:t = TIME:REPEAT UNTIL ((TIME - t) > hundredth_seconds%):ENDPROC
13110 :
13120 REM :::::::::::::::::::::::::::::
13130 REM ::  Display Centered Text  ::
13140 REM :::::::::::::::::::::::::::::
13150 DEF PROC_CENTER(text$)
13160 LOCAL i%, n%, l%
13170 l% = 0
13180 FOR i% = 1 TO LEN(text$)
13190   IF ASC(MID$(text$, i%, 1)) >= BLANK THEN l% = l% + 1
13200 NEXT i%
13210 n% = FN_CENTER(STRING$(l%, CHR$(BLANK)))
13220 i% = VPOS:VDU 31, n%, i%
13230 FOR i% = 1 TO LEN(text$)
13240   VDU ASC(MID$(text$, i%, 1))
13250 NEXT i%
13260 ENDPROC
13270 :
13280 REM ::::::::::::::::::::::::::::
13290 REM :: Restore Default Colors ::
13300 REM ::::::::::::::::::::::::::::
13310 DEF PROC_DEFAULT_COLORS
13320 COLOUR 128+BLACK:COLOUR WHITE
13330 ENDPROC
13340 :
13350 REM ::::::::::::::::::::::::
13360 REM ::   Display Scores   ::
13370 REM ::::::::::::::::::::::::
13380 DEF PROC_DISPLAY_SCORES
13390 LOCAL hs$, sc$
13400 PROC_UPDATE_HIGH_SCORE
13410 hs$ = CHR$(17)+CHR$(YELLOW)+"HIGH SCORE "+CHR$(17)+CHR$(WHITE)+STR$(HighScore%)
13420 sc$ = CHR$(17)+CHR$(RED)+"1UP "+CHR$(17)+CHR$(WHITE)+STR$(Score%)
13430 PRINT TAB(0,0)sc$:PRINT TAB(CW%-LEN(hs$)+4,0)hs$
13440 ENDPROC
13450 :
13460 REM :::::::::::::::::::::::::
13470 REM ::  Update High Score  ::
13480 REM :::::::::::::::::::::::::
13490 DEF PROC_UPDATE_HIGH_SCORE
13500 IF (HighScore% < Score%) THEN HighScore% = Score%:REM Check if new highscore has been achieved and update if needed
13510 ENDPROC
13520 :
13530 REM :::::::::::::::::::::::::
13540 REM ::   High Score Read   ::
13550 REM :::::::::::::::::::::::::
13560 DEF PROC_HISCORE_READ(game$)
13570 LOCAL f0%, error%, val%
13580 error% = FALSE
13590 f0% = OPENIN(game$ + ".HI")
13600 IF f0% <> 0 THEN INPUT#f0%, val%:ELSE error% = TRUE
13610 CLOSE#f0%
13620 IF NOT error% THEN HighScore% = val%
13630 ENDPROC
13640 :
13650 REM :::::::::::::::::::::::::
13660 REM ::   High Score Write  ::
13670 REM :::::::::::::::::::::::::
13680 DEF PROC_HISCORE_WRITE(game$)
13690 LOCAL f0%
13700 f0% = OPENOUT(game$ + ".HI")
13710 IF f0% <> 0 THEN PRINT#f0%, HighScore%
13720 CLOSE#f0%
13730 ENDPROC
13740 :
13750 REM :::::::::::::::::::::::::::
13760 REM :: Empty Keyboard Buffer ::
13770 REM :::::::::::::::::::::::::::
13780 DEF PROC_EMPTY_KEYBOARD_BUFFER
13790 REPEAT UNTIL INKEY(0) = -1
13800 ENDPROC
13810 :
13820 REM ::::::::::::::::::::::::::::::::::::::
13830 REM :: Custom "Screen Memory" Functions ::
13840 REM ::::::::::::::::::::::::::::::::::::::
13850 DEF FN_READ(x%, y%)
13860 LOCAL n%
13870 n% = FN_XYINDEX(x%, y%)
13880 := screen?n%
13890 :
13900 DEF PROC_WRITE(x%, y%, ch%)
13910 LOCAL n%
13920 n% = FN_XYINDEX(x%, y%)
13930 screen?n% = ch%
13940 ENDPROC
13950 :
13960 DEF PROC_CLEAR_SCREEN
13970 LOCAL n%, ub%
13980 ub% = CW% * CH% - 1
13990 FOR n% = 0 TO ub%
14000   screen?n% = BLANK
14010 NEXT n%
14020 ENDPROC
14030 :
14040 DEF PROC_PLOT(x%, y%, ch%, co%)
14050 PROC_WRITE(x%, y%, ch%)
14060 VDU 31, x%, y%
14070 IF co% < 0 THEN co% = FN_COLOR_MAP(ch%)
14080 VDU 17, co%, ch%
14090 ENDPROC
14100 :
14110 DEF PROC_DRAW(x%, y%, ch%, overwrite%)
14120 LOCAL f%
14130 f% = FN_READ(x%, y%):REM Is Position Currently Unoccupied?
14140 IF (f% = BLANK OR overwrite%) THEN PROC_PLOT(x%, y%, ch%, -1)
14150 ENDPROC
14160 :
14170 REM :::::::::::::::::::::::::
14180 REM ::  Map Char To Color  ::
14190 REM :::::::::::::::::::::::::
14200 DEF FN_COLOR_MAP(c%)
14210 LOCAL r%
14220 r% = (c% = E_HEART OR c% = MON_RED)*-RED + (c% = E_FRUIT OR c% = MON_GREEN)*-GREEN + ((c% >= SN_L AND c% <= SN_U) OR c% = SN_W OR c% = E_TOADSTOOL)*-YELLOW
14230 r% = r% + (c% = MON_BLUE OR c% = B_VERT OR c% = B_HORZ OR (c% >= B_UR AND c% <= B_DR))*-BLUE
14240 r% = r% + (c% = MON_PINK)*-MAGENTA + (c% = E_DIAMOND OR c% = MON_CYAN)*-CYAN + (c% = DOT OR c% = MON_WHITE OR c% = E_CIRC OR c% = E_DISC)*-WHITE
14250 := r%
14260 :
14270 REM ::::::::::::::::::::
14280 REM ::  Random Event  ::
14290 REM ::::::::::::::::::::
14300 DEF PROC_RANDOM_EVENT
14310 LOCAL c%, f, free%, i%, r, rx%, ry%
14320 REM IF FN_RND_PCT(10) THEN GOTO ENDPROC:REM No new obstacle
14330 rx% = FN_RND_X:ry% = FN_RND_Y:REM Determine random position
14340 free% = (FN_READ(rx%, ry%) = BLANK):IF NOT free% THEN 14420:REM Ensure the position is free
14350 r = RND(1)
14360 IF (r < .85) THEN 14390
14370 i% = FN_NEXT_MONSTER_SLOT
14380 IF (-1 < i%) THEN c% = ASC(MID$(MO$, i% + 1, 1)):PROC_MANAGE_MONSTER(rx%, ry%, c%, TRUE):f = 9.5:GOTO 14410:ELSE c% = E_DISC:GOTO 14400
14390 c% = (r >= 0 AND r < .5)*-DOT + (r >= .5 AND r < .7)*-E_CIRC + (r >= .7 AND r < .85)*-FN_RND_EDIBLE
14400 PROC_DRAW(rx%, ry%, c%, FALSE):f = 4.5
14410 PROC_SOUND(f, 2)
14420 ENDPROC
14430 :
14440 REM :::::::::::::::::
14450 REM ::   REM Eat   ::
14460 REM :::::::::::::::::
14470 DEF FN_EAT(x%, y%)
14480 LOCAL c%, n%, s%
14490 c% = FN_READ(x%, y%):REM PROC_COUT(STR$(x%)+" "+STR$(y%)+" "+STR$(c%)+"      ",0)
14500 n% = (c% = BLANK OR c% = BLANK_X)*0 + ((c% = SN_W AND NOT Rvs_Dir%) OR (c% >= MON_RED AND c% <= MON_GREEN) OR (c% = E_TOADSTOOL))*-1 + (c% = E_CIRC)*-2 + (c% = E_DISC)*-3
14510 n% = n% + (c% = DOT OR (c% >= E_HEART AND c% <= E_FRUIT))*-4 + (c% = MON_WHITE OR c% = MON_BLUE)*-5
14520 n% = n% + (c% = B_VERT OR c% = B_HORZ OR c% = B_UR OR c% = B_UL OR c% = B_DL OR c% = B_DR)*-6
14530 ON n% GOTO 14540,14550,14560,14580,14610,14630:ELSE 14640
14540 Dead% = TRUE:r% = FALSE:GOTO 14650:REM Collided with self, toadstool or deadly monster
14550 PROC_SHRINK_SNAKE(1):GOTO 14590:REM The open circle shrinks the snake
14560 PROC_UPDATE_MONSTER_STATE(TRUE, MON_BLUE):PROC_CHARGE:REM The filled circle makes existing monsters vulnerable
14570 GOTO 14590
14580 s% = 2 + (c% = DOT) + (c% = E_DISC)*2:PROC_INC_SIZE(s%):REM Edible increases size of snake
14590 Score% = Score% + (c% = DOT)*-(Size% * 5) + (c% = E_HEART)*-100 + (c% = E_DIAMOND)*-200 + (c% = E_FRUIT)*-500 + (c% = E_CIRC OR c% = E_DISC)*-25
14600 GOTO 14640
14610 Score% = Score% + (c% = MON_BLUE)*-500 + (c% = MON_WHITE)*-1000:PROC_MANAGE_MONSTER(x%, y%, c%, FALSE):PROC_SHRINK_SNAKE(1):REM Eating cowardly monster shrinks the snake
14620 GOTO 14640
14630 Dead% = TRUE:REM Collided with boundary
14640 IF (Dead% <> TRUE AND c% <> BLANK AND c% <> BLANK_X AND c% <> SN_W) THEN PROC_SOUND(16, 2)
14650 := (Dead%) + (NOT Dead%) * -c%
14660 :
14670 REM :::::::::::::::::::::::::::
14680 REM ::    Recoil The Snake   ::
14690 REM :::::::::::::::::::::::::::
14700 DEF FN_RECOIL_SNAKE
14710 LOCAL i%
14720 i% = P - Size%:REM Locate tail end of snake
14730 IF i% < 0 THEN i% = i% + MAX_SIZE%:REM Wrap around to the end
14740 PROC_ERASE(X(i%), Y(i%))
14750 := i%
14760 :
14770 REM ::::::::::::::::::::::::::
14780 REM ::   Shrink The Snake   ::
14790 REM ::::::::::::::::::::::::::
14800 DEF PROC_SHRINK_SNAKE(d%)
14810 LOCAL n%
14820 PROC_INC_SIZE(-d%)
14830 n% = FN_RECOIL_SNAKE
14840 ENDPROC
14850 :
14860 REM ::::::::::::::::::::::::::
14870 REM ::  Grow Out The Snake  ::
14880 REM ::::::::::::::::::::::::::
14890 DEF PROC_GROW_SNAKE(d%)
14900 LOCAL i%, ch%, dx%, dy%, nx%, ny%
14910 dx% = FN_X_DELTA(d%):dy% = FN_Y_DELTA(d%)
14920 nx% = X(P) + dx%:ny% = Y(P) + dy%
14930 ch% = FN_EAT(nx%, ny%)
14940 IF ch% < 0 THEN 15070
14950 IF nx% <= UX% THEN nx% = LX% - 1:REM Snake entered Left Portal; Exit Out Right Portal
14960 IF nx% >= LX% THEN nx% = UX% + 1:REM Snake entered Right Portal; Exit Out Left Portal
14970 IF ny% <= UY% THEN ny% = LY% - 1:REM Snake entered Top Portal; Exit Out Bottom Portal
14980 IF ny% >= LY% THEN ny% = UY% + 1:REM Snake entered Bottom Portal; Exit Out Top Portal
14990 P = FN_NEXT_POS(P)
15000 i% = FN_RECOIL_SNAKE
15010 X(P) = nx%:Y(P) = ny%
15020 i% = FN_NEXT_POS(i%):IF i% = P THEN 15040
15030 REPEAT:PROC_DRAW(X(i%), Y(i%), SN_W, TRUE):i% = FN_NEXT_POS(i%):UNTIL i% = P
15040 ch% = (AF <> 0) * -SN_W + (AF = 0) * -(d% + SN_L - 1):REM Which Animation Frame To Display For Snake's Head
15050 PROC_DRAW(X(P), Y(P), ch%, TRUE)
15060 AF = (AF + 1) MOD 2
15070 ENDPROC
15080 :
15090 REM ::::::::::::::::::::::::::::::::
15100 REM :: Increase The Size Of Snake ::
15110 REM ::::::::::::::::::::::::::::::::
15120 DEF PROC_INC_SIZE(n%)
15130 Size% = FN_MAX(FN_MIN(Size% + n%, MAX_SIZE%), 2)
15140 ENDPROC
15150 :
15160 REM :::::::::::::::::::::::::::::::::::::
15170 REM :: Check For Reversal Of Direction ::
15180 REM :::::::::::::::::::::::::::::::::::::
15190 DEF FN_CHECK_FOR_REVERSE_DIRECTION(old%, new%)
15200 REM 4 = UP; 3= DOWN; 1 = LEFT; 2 = RIGHT
15210 REM := (old% = 4 AND new% = 3) OR (old% = 3 AND new% = 4) OR (old% = 1 AND new% = 2) OR (old% = 2 AND new% = 1)
15220 := (old% OR new%) = 7 OR (old% OR new%) = 3
15230 :
15240 REM :::::::::::::::::::::::::::::::::
15250 REM :: Monster Management Routines ::
15260 REM :::::::::::::::::::::::::::::::::
15270 DEF PROC_MANAGE_MONSTER(x%, y%, c%, state%)
15280 LOCAL pos%:REM PROC_COUT(STR$(x%)+","+STR$(y%)+" "+STR$(c%)+"  ", 2)
15290 IF state% = FALSE THEN PROC_CLEAR_MONSTER(x%, y%)
15300 IF state% = TRUE THEN PROC_NEW_MONSTER(x%, y%, c%):PROC_DRAW(x%, y%, c%, TRUE)
15310 IF state% = MON_BLUE OR state% = MON_WHITE THEN PROC_DRAW(x%, y%, state%, TRUE):IF state% = MON_BLUE THEN PROC_MON_GO_WHITE
15320 IF state% = MON_RESET THEN PROC_DRAW(x%, y%, c%, TRUE)
15330 ENDPROC
15340 :
15350 DEF PROC_MANAGE_MONSTER_BY_POS(pos%, c%, state%)
15360 LOCAL x%, y%
15370 IF -1 <> pos% THEN y% = pos% DIV CW%:x% = pos% MOD CW%:PROC_MANAGE_MONSTER(x%, y%, c%, state%)
15380 ENDPROC
15390 :
15400 DEF PROC_NEW_MONSTER(x%, y%, c%)
15410 LOCAL i%
15420 IF M_Count% >= MAX_MONSTERS% THEN 15450
15430 i% = FN_NEXT_MONSTER_SLOT
15440 IF -1 <> i% THEN MP%(i%) = FN_HASH(x%, y%):M_Position% = i%:M_Count% = M_Count% + 1
15450 ENDPROC
15460 :
15470 DEF FN_NEXT_MONSTER_SLOT
15480 LOCAL found%, i%, r%
15490 found% = FALSE:i% = 0
15500 REPEAT
15510   IF -1 = MP%(i%) THEN found% = TRUE:ELSE i% = i% + 1
15520 UNTIL found% OR i% = MAX_MONSTERS%
15530 IF found% THEN r% = i%:ELSE r% = -1
15540 := r%
15550 :
15560 DEF FN_FIND_MONSTER(x%, y%)
15570 LOCAL found%, i%, r%
15580 found% = FALSE:i% = 0
15590 REPEAT
15600   IF (FN_HASH(x%, y%) = MP%(i%)) THEN found% = TRUE:ELSE i% = i% + 1
15610 UNTIL found% OR i% = MAX_MONSTERS%
15620 IF found% THEN r% = i%:ELSE r% = -1
15630 := r%
15640 :
15650 DEF FN_MONSTER_AT_POS(pos%)
15660 LOCAL r%, x%, y%
15670 r% = -1:IF -1 <> pos% THEN y% = pos% DIV CW%:x% = pos% MOD CW%:r% = FN_READ(x%, y%)
15680 := r%
15690 :
15700 DEF PROC_CLEAR_MONSTER(x%, y%)
15710 LOCAL i%
15720 i% = FN_FIND_MONSTER(x%, y%)
15730 IF -1 <> i% THEN MP%(i%) = -1:M_Count% = M_Count% - 1
15740 ENDPROC
15750 :
15760 DEF PROC_UPDATE_MONSTER_STATE(oldState%, newState%)
15770 LOCAL c%, i%
15780 FOR i% = 0 TO MAX_MONSTERS% - 1
15790   c% = (newState% = MON_RESET) * -ASC(MID$(MO$, i%+1, 1)) + (newState% = MON_WHITE AND oldState% = MON_BLUE) * -FN_MONSTER_AT_POS(MP%(i%))
15800   IF -1 <> MP%(i%) AND (oldState% = c% OR oldState% = TRUE) THEN PROC_MANAGE_MONSTER_BY_POS(MP%(i%), c%, newState%)
15810 NEXT i%
15820 ENDPROC
15830 :
15840 DEF PROC_MONSTER_COLOR_CHECK
15850 IF MonGoWhite% <> FALSE AND FN_INT_TIME >= MonGoWhite% THEN MonGoWhite% = FALSE:PROC_UPDATE_MONSTER_STATE(MON_BLUE, MON_WHITE)
15860 IF MonReset% <> FALSE AND FN_INT_TIME >= MonReset% THEN MonReset% = FALSE:PROC_UPDATE_MONSTER_STATE(TRUE, MON_RESET)
15870 ENDPROC
15880 :
15890 REM :::::::::::::::::::::::::::::::::::::::::::
15900 REM ::  Calculate type index of a clockwise  ::
15910 REM ::  position on a box's perimeter        ::
15920 REM :::::::::::::::::::::::::::::::::::::::::::
15930 DEF FN_CLOCKWISE_BOX_SIDE_INDEX(pos%, width%, height%)
15940 REM 0 = UPPER_LEFT_CORNER, 1 = UPPER_MIDDLE, 2 = UPPER_RIGHT_CORNER, 3 = MIDDLE_RIGHT, 4 = LOWER_RIGHT_CORNER, 5 = LOWER_MIDDLE, 6 = LOWER_LEFT_CORNER, 7 = MIDDLE_LEFT
15950 LOCAL r%
15960 r% = (pos% > 0 AND pos% < width% - 1) * -1 + (pos% = width% - 1) * -2 + (pos% >= width% AND pos% < width% + height% - 2) * -3 + (pos% = width% + height% - 2) * -4
15970 r% = r% + (pos% > width% + height% - 2 AND pos% < 2 * width% + height% - 3) * -5 + (pos% = 2 * width% + height% - 3) * -6 + (pos% > 2 * width% + height% - 3) * -7
15980 :=r%
15990 :
16000 REM ::::::::::::::::::::::::::
16010 REM ::  Draw Box Clockwise  ::
16020 REM ::::::::::::::::::::::::::
16030 DEF PROC_CLOCKWISE_BOX(ux%, uy%, width%, height%, color%)
16040 LOCAL aq%, bq%, ch%, i%, p%, x%, y%
16050 aq% = width% + height% - 2:bq% = aq% + width%:p% = bq% + height% - 2
16060 FOR i% = 0 TO p% - 1
16070   x% = (i% < width%) * -i% + (i% > (width%-1) AND i% < aq%) * -(width%-1) + (i% >= aq% AND i% < bq%) * (i% - (bq% - 1)) + (i% >= bq%) * 0
16080   y% = (i% < width%) * 0 + (i% > (width%-1) AND i% < aq%) * -(i% - (width%-1)) + (i% >= aq% AND i% < bq%) * -(height%-1) + (i% >= bq%) * -((height%-2) - (i% - bq%))
16090   ch% = ASC(MID$(BX$, FN_CLOCKWISE_BOX_SIDE_INDEX(i%, width%, height%) + 1, 1))
16100   PROC_PLOT(ux% + x%, uy% + y%, ch%, color%)
16110 NEXT i%
16120 ENDPROC
16130 :
16140 REM ::::::::::::::::::::::::
16150 REM :: Draw Playing Field ::
16160 REM ::::::::::::::::::::::::
16170 DEF PROC_DRAW_PLAYING_FIELD(ux%, uy%, width%, height%)
16180 PROC_CLOCKWISE_BOX(ux%, uy%, width%, height%, BLUE)
16190 ENDPROC
16200 :
16210 REM :::::::::::::::::::
16220 REM :: Draw Portals  ::
16230 REM :::::::::::::::::::
16240 DEF PROC_DRAW_PORTALS(horizontal%, vertical%, ux%, uy%, width%, height%)
16250 LOCAL ch%, h%, i%, j%, lx%, ly%, pColor%, v%, wColor%
16260 pColor% = CYAN:wColor% = BLUE:h% = ux% + width% DIV 2 - 2:v% = uy% + height% DIV 2 - 2:lx% = ux% + width% - 1:ly% = uy% + height% - 1
16270 FOR i% = 0 TO 1:REM Vertical portal
16280   FOR j% = 0 TO 2
16290     ch% = (vertical%) * -(ASC(MID$(PV$(i%), j% + 1, 1))) + (NOT vertical%) * -B_HORZ
16300     PROC_PLOT(h% + j%, (i% = 0) * -uy% + (i% = 1) * -ly%, ch%, (ch% = BLANK_X) * -BLACK + (ch% = B_HORZ) * -wColor% + ((ch% <> BLANK_X) AND (ch% <> B_HORZ)) * -pColor%)
16310   NEXT j%
16320 NEXT i%
16330 FOR i% = 0 TO 1:REM Horizontal portal
16340   FOR j% = 0 TO 2
16350     ch% = (horizontal%) * -(ASC(MID$(PH$(i%), j% + 1, 1))) + (NOT horizontal%) * -B_VERT
16360     PROC_PLOT((i% = 0) * -ux% + (i% = 1) * -lx%, v% + j%, ch%, (ch% = BLANK_X) * -BLACK + (ch% = B_VERT) * -wColor% + ((ch% <> BLANK_X) AND (ch% <> B_VERT)) * -pColor%)
16370   NEXT j%
16380 NEXT i%
16390 ENDPROC
16400 :
16410 REM :::::::::::::::::::::::::::
16420 REM ::  Update Portal State  ::
16430 REM :::::::::::::::::::::::::::
16440 DEF PROC_UPDATE_PORTAL_STATE
16450 LOCAL horizontal%, vertical%
16460 Portal_State% = (Portal_State% + 1) MOD 4
16470 IF Portal_State% = 0 THEN horizontal% = FALSE: vertical% = FALSE
16480 IF Portal_State% = 1 THEN horizontal% = TRUE: vertical% = FALSE
16490 IF Portal_State% = 2 THEN horizontal% = TRUE: vertical% = TRUE
16500 IF Portal_State% = 3 THEN horizontal% = FALSE: vertical% = TRUE
16510 PROC_DRAW_PORTALS(horizontal%, vertical%, UX%, UY%, CW% - 2*UX%, CH% - UY%)
16520 FOR i% = 1 TO 2:PROC_SOUND(i% * 24, 1.5 * i%):NEXT i%
16530 ENDPROC
16540 :
16550 REM ::::::::::::::::::::::::::::::::
16560 REM ::       Clockwise Plot       ::
16570 REM ::::::::::::::::::::::::::::::::
16580 DEF PROC_CLOCKWISE_PLOT(pos%, color%, char%, ux%, uy%, width%, height%)
16590 LOCAL cx%, cy%, a%, b%, c%
16600 a% = width% + height% - 2:b% = a% + width%:c% = b% + height% - 2
16610 cx% = (pos% < width%) * -pos% + (pos% > (width% - 1) AND pos% < a%) * -(width% - 1)
16620 cx% = cx% + (pos% >= a% AND pos% < b%) * (pos% - (b% - 1)) + (pos% >= b%) * 0
16630 cy% = (pos% < width%) * 0 + (pos% > (width% - 1) AND pos% < a%) * -(pos% - (width% - 1))
16640 cy% = cy% + (pos% >= a% AND pos% < b%) * -(height% - 1) + (pos% >= b%) * -((height% - 2) - (pos% - b%))
16650 VDU 31,ux% + cx%,uy% + cy%,17,color%,char%:REM Plot a character on the path
16660 ENDPROC
16670 :
16680 REM :::::::::::::::::::::::
16690 REM ::  Death Animation  ::
16700 REM :::::::::::::::::::::::
16710 DEF PROC_DEATH_ANIMATION(x%, y%)
16720 LOCAL ch%, fr$, i%, n%
16730 REPEAT:Size% = Size% - 1:n% = FN_RECOIL_SNAKE:PROC_SOUND(2 * Size%, 2):PROC_SOUND(0, 0):PROC_SLEEP(10):UNTIL Size% < 2
16740 fr$ = RIGHT$("0"+STR$(SN_W), 3)+STR$(SN_U)+STR$(SN_D1)+STR$(SN_D2)+STR$(SN_D3)+STR$(SN_D4)+STR$(SN_D5)+STR$(SN_D6)+"0"+STR$(BLANK)
16750 FOR i% = 1 TO LEN(fr$) DIV 3 STEP 2
16760   ch% = VAL(MID$(fr$, 3 * (i% - 1) + 1, 3))
16770   VDU 31, x%, y%, 17, YELLOW, ch%:PROC_SOUND(i% + 8, 2):PROC_SLEEP(20)
16780 NEXT i%:PROC_SOUND(4, 3)
16790 ENDPROC
16800 :
16810 REM :::::::::::::::::::
16820 REM ::    Welcome    ::
16830 REM :::::::::::::::::::
16840 DEF PROC_WELCOME
16850 LOCAL boxh%, boxw%, c%, cc%, ch$, ex%, perimeter%, t%, t$, ux%, uy%
16860 boxh% = 18:boxw% = FN_MIN(CW%, 40):cc% = 0:ex% = FALSE:perimeter% = 2 * (boxw% + boxh% - 2):t% = 2:ux% = (CW% - boxw%) DIV 2:uy% = 0
16870 PROC_HIDE_CURSOR
16880 CLS:PROC_DEFAULT_COLORS
16890 PRINT TAB(0, uy% + 1);
16900 PROC_CENTER("Welcome to " + CHR$(17)+CHR$(YELLOW) + GameName$ + CHR$(17)+CHR$(WHITE)+ "..."):PRINT:PRINT
16910 PROC_CENTER("A nostalgic variant of the classic"):PRINT
16920 PROC_CENTER("SNAKE game."):PRINT:PRINT
16930 PROC_CENTER("Use the four arrow keys to maneuver"):PRINT
16940 PROC_CENTER("the starving little snake to snack"):PRINT
16950 PROC_CENTER("on pellets and other tasty morsels."):PRINT
16960 PROC_CENTER("Avoid the walls and spooky little"):PRINT
16970 PROC_CENTER("monsters while trying to avoid"):PRINT
16980 PROC_CENTER("chomping on yourself like an"):PRINT
16990 COLOUR YELLOW:PROC_CENTER("Ouroboros."):PRINT:PRINT
17000 COLOUR WHITE:PROC_CENTER("Good luck and have fun!"):PRINT:PRINT
17010 COLOUR CYAN:PROC_CENTER("Hit a key to continue")
17020 REPEAT
17030   PROC_CLOCKWISE_PLOT(cc%, BLACK, BLANK, ux%, uy%, boxw%, boxh%)
17040   cc% = (cc% + 1) MOD perimeter%
17050   PROC_CLOCKWISE_PLOT(cc%, cc% MOD 6 + 1, MON_RED, ux%, uy%, boxw%, boxh%)
17060   IF SY$ = "A" THEN c% = INKEY(DL%):PROC_EMPTY_KEYBOARD_BUFFER:ELSE c% = INKEY(TK/DL%)
17070   ex% = (c% > 0)
17080 UNTIL ex%
17090 boxh% = 18:boxw% = FN_MIN(CW%, 40):cc% = 0:ex% = FALSE:perimeter% = 2 * (boxw% + boxh% - 2):ux% = (CW% - boxw%) DIV 2:uy% = 0
17100 CLS:PROC_DEFAULT_COLORS
17110 PRINT TAB(0, uy% + 2);
17120 COLOUR YELLOW:PROC_CENTER(STRING$(t%, " ")+"....  Score"+STRING$(2, " ")+"Resize"):PRINT:PRINT
17130 t$ = STRING$(t%, " ")+CHR$(17)+CHR$(RED)+CHR$(MON_RED)+CHR$(17)+CHR$(MAGENTA)+CHR$(MON_RED)+CHR$(17)+CHR$(CYAN)+CHR$(MON_RED)+CHR$(17)+CHR$(GREEN)+CHR$(MON_RED)
17140 t$ = t$ + STRING$(2, " ")+CHR$(17)+CHR$(WHITE)+"Death"+STRING$(2, " ")+CHR$(SKULL)+STRING$(6, " "):PROC_CENTER(t$):PRINT
17150 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(BLUE)+CHR$(MON_RED)+STRING$(5, " ")+CHR$(17)+CHR$(WHITE)+"  500"+STRING$(2, " ")+"-"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+STRING$(4, " ")):PRINT
17160 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(WHITE)+CHR$(MON_RED)+STRING$(5, " ")+" 1000"+STRING$(2, " ")+"-"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+STRING$(4, " ")):PRINT
17170 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(WHITE)+CHR$(DOT)+STRING$(5, " ")+"  5x"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+STRING$(2, " ")+CHR$(17)+CHR$(WHITE)+"+"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+STRING$(4, " ")):PRINT
17180 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(WHITE)+CHR$(E_CIRC)+STRING$(5, " ")+"   25"+STRING$(2, " ")+"-"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+STRING$(4, " ")):PRINT
17190 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(WHITE)+CHR$(E_DISC)+STRING$(5, " ")+"   25"+STRING$(2, " ")+STRING$(6, " ")):PRINT
17200 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(RED)+CHR$(E_HEART)+STRING$(5, " ")+CHR$(17)+CHR$(WHITE)+"  100"+STRING$(2, " ")+"+"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+CHR$(SN_W)+STRING$(3, " ")):PRINT
17210 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(CYAN)+CHR$(E_DIAMOND)+STRING$(5, " ")+CHR$(17)+CHR$(WHITE)+"  200"+STRING$(2, " ")+"+"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+CHR$(SN_W)+STRING$(3, " ")):PRINT
17220 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(GREEN)+CHR$(E_FRUIT)+STRING$(5, " ")+CHR$(17)+CHR$(WHITE)+"  500"+STRING$(2, " ")+"+"+CHR$(17)+CHR$(YELLOW)+CHR$(SN_W)+CHR$(SN_W)+STRING$(3, " ")):PRINT
17230 PROC_CENTER(STRING$(t%, " ")+CHR$(17)+CHR$(YELLOW)+CHR$(E_TOADSTOOL)+STRING$(5, " ")+CHR$(17)+CHR$(WHITE)+"Death"+STRING$(2, " ")+CHR$(SKULL)+STRING$(6, " ")):PRINT:PRINT
17240 COLOUR GREEN:PROC_CENTER("Hit a key to begin playing")
17250 PROC_CLOCKWISE_BOX(ux% + 1, uy% + 1, boxw% - 2, boxh% - 2, CYAN)
17260 ch$=CHR$(SN_R)+CHR$(SN_R)+CHR$(SN_D)+CHR$(SN_D)+CHR$(SN_L)+CHR$(SN_L)+CHR$(SN_U)+CHR$(SN_U)
17270 REPEAT
17280   PROC_CLOCKWISE_PLOT(cc% - 1, BLACK, BLANK, ux%, uy%, boxw%, boxh%):PROC_CLOCKWISE_PLOT(cc%, BLACK, BLANK, ux%, uy%, boxw%, boxh%)
17290   cc% = (cc% + 1) MOD perimeter%
17300   c% = (cc% MOD 2 <> 0) * -SN_W + (cc% MOD 2 = 0) * -ASC(MID$(ch$, FN_CLOCKWISE_BOX_SIDE_INDEX(cc%, boxw%, boxh%) + 1, 1))
17310   PROC_CLOCKWISE_PLOT(cc%, YELLOW, SN_W, ux%, uy%, boxw%, boxh%):PROC_CLOCKWISE_PLOT(cc% + 1, YELLOW, c%, ux%, uy%, boxw%, boxh%)
17320   IF SY$ = "A" THEN c% = INKEY(DL%):PROC_EMPTY_KEYBOARD_BUFFER:ELSE c% = INKEY(TK/DL%)
17330   ex% = (c% > 0)
17340 UNTIL ex%
17350 PROC_DEFAULT_COLORS
17360 ENDPROC
17370 :
17380 REM :::::::::::::::::
17390 REM ::  Game Over  ::
17400 REM :::::::::::::::::
17410 DEF PROC_GAME_OVER
17420 VDU 17,RED:PROC_FULL_CENTER_TEXT("GAME OVER")
17430 PROC_SLEEP(200):VDU 17,YELLOW
17440 PROC_HISCORE_WRITE(GameName$)
17450 ENDPROC
17460 :
17470 REM :::::::::::::::::::::::
17480 REM :: Play Simple Sound ::
17490 REM :::::::::::::::::::::::
17500 DEF PROC_SOUND(index%, duration%)
17510 LOCAL constant%:constant% = 12.2
17520 SOUND 1, -10, index% * constant%, duration%
17530 ENDPROC
17540 :
17550 REM :::::::::::::::::::::::::
17560 REM :: Play Musical Phrase ::
17570 REM :::::::::::::::::::::::::
17580 DEF PROC_PLAY(notes$)
17590 LOCAL d%, j%, l%, p%
17600 l% = LEN(notes$) DIV 3
17610 FOR j% = 1 TO l% STEP 2
17620   p% = VAL(MID$(notes$, 3 * (j% - 1) + 1, 3)):d% = VAL(MID$(notes$, 3 * (j% - 1) + 4, 3))
17630   SOUND 1, -10, p%, d%
17640   SOUND 1, 0, p%, 1:REM Stacatto the currently playing sound
17650 NEXT j%
17660 ENDPROC
17670 :
17680 REM :::::::::::::::::::
17690 REM ::  CHARGE!!!!!  ::
17700 REM :::::::::::::::::::
17710 DEF PROC_CHARGE
17720 PROC_PLAY("129001149001165001177004165002177008"):REM COUNT,PITCH,DURATION
17730 ENDPROC
17740 :
17750 REM ::::::::::::::::::::::::::
17760 REM :: Define Custom Colors ::
17770 REM ::::::::::::::::::::::::::
17780 DEF PROC_REDEFINE_COLORS
17790 IF SY$="A" AND FN_COLORCOUNT < &40 THEN VDU 19,C_ORANGE,&FF,&FF,&80,&00:ELSE COLOUR C_ORANGE,&FF,&80,&00
17800 ENDPROC
17810 :
17820 REM ::::::::::::::::::::::::::::::
17830 REM :: Define Custom Characters ::
17840 REM ::::::::::::::::::::::::::::::
17850 DEF PROC_REDEFINE_CHARS
17860 VDU 23,BLANK_X,0,0,0,0,0,0,0,0:REM BLANK
17870 VDU 23,DOT,0,0,0,24,24,0,0,0:REM DOT
17880 VDU 23,SN_L,0,60,30,14,14,30,60,0:REM LEFT(3)
17890 VDU 23,SN_R,0,60,120,112,112,120,60,0:REM RIGHT(3)
17900 VDU 23,SN_D,0,60,126,126,102,66,0,0:REM DOWN(3)
17910 VDU 23,SN_U,0,0,66,102,126,126,60,0:REM UP(3)
17920 VDU 23,SN_W,0,60,126,126,126,126,60,0:REM WHOLE(3)
17930 VDU 23,E_HEART,54,127,127,127,62,28,8,0:REM HEART(1)
17940 VDU 23,E_DIAMOND,8,28,62,127,62,28,8,0:REM DIAMOND(6)
17950 VDU 23,E_FRUIT,0,12,24,60,60,60,24,0:REM FRUIT(2)
17960 VDU 23,E_TOADSTOOL,0,0,24,60,60,8,24,0:REM TOADSTOOL(3)
17970 VDU 23,E_CIRC,0,60,126,102,102,126,60,0:REM CIRCLE(7)
17980 VDU 23,E_DISC,0,60,126,126,126,126,60,0:REM FILLED CIRCLE(7)
17990 VDU 23,MON_WHITE,0,60,126,90,126,126,90,0:REM WHITE(7)
18000 VDU 23,MON_BLUE,0,60,126,90,126,126,90,0:REM BLUE(4)
18010 VDU 23,MON_RED,0,60,126,90,126,126,90,0:REM RED(1)
18020 VDU 23,MON_PINK,0,60,126,90,126,126,90,0:REM MAGENTA(5)
18030 VDU 23,MON_CYAN,0,60,126,90,126,126,90,0:REM CYAN(6)
18040 VDU 23,MON_GREEN,0,60,126,90,126,126,90,0:REM GREEN(2)
18050 VDU 23,B_VERT,24,24,24,24,24,24,24,24:REM VERTICAL(4)
18060 VDU 23,B_HORZ,0,0,0,255,255,0,0,0:REM HORIZONTAL(4)
18070 VDU 23,B_UR,0,0,0,7,15,28,24,24:REM UPRIGHT C(4)
18080 VDU 23,B_UL,0,0,0,224,240,56,24,24:REM UPLEFT C(4)
18090 VDU 23,B_DL,24,24,56,240,224,0,0,0:REM DOWNLEFT C(4)
18100 VDU 23,B_DR,24,24,28,15,7,0,0,0:REM DOWN RIGHT C(4)
18110 VDU 23,SN_D1,0,0,0,102,126,126,60,0:REM DYING 1
18120 VDU 23,SN_D2,0,0,0,0,126,126,60,0:REM DYING 2
18130 VDU 23,SN_D3,0,0,0,0,126,126,60,0:REM DYING 3
18140 VDU 23,SN_D4,0,0,0,0,24,60,60,0:REM DYING 4
18150 VDU 23,SN_D5,0,0,0,0,24,24,60,0:REM DYING 5
18160 VDU 23,SN_D6,0,0,0,0,8,24,16,0:REM DYING 6
18170 VDU 23,SKULL,0,189,126,90,126,165,24,0:REM SKULL(7)
18180 ENDPROC
18190 :
18200 REM ::::::::::::::::::::::::::::::
18210 REM ::  Error Handling Routine  ::
18220 REM ::::::::::::::::::::::::::::::
18230 DEF PROC_HANDLE_ERROR
18240 IF ERR <> 17 THEN PROC_DEFAULT_COLORS:PROC_SHOW_CURSOR:PRINT:REPORT:PRINT" @line #";ERL:STOP
18250 ENDPROC
