10 REM ==========================================
20 REM Integer multiply benchmark buckets
30 REM 8x8, 8x16/16x8, and full 32x32
40 REM ==========================================

50 REPS%=5000
60 PRINT "Multiply benchmark"
70 PRINT "Iterations per bucket = "; REPS%
80 PRINT

100 REM ---------- 8 x 8 ----------
110 TIME=0
120 FOR I%=1 TO REPS%
130 R%=13*17
140 R%=29*251
150 R%=255*255
160 R%=127*63
170 R%=1*255
180 R%=255*1
190 R%=200*37
200 R%=0*255
210 NEXT
220 T8%=TIME
230 PRINT "8x8        : "; T8%; " cs"

300 REM ---------- 8 x 16 / 16 x 8 ----------
310 TIME=0
320 FOR I%=1 TO REPS%
330 R%=17*50000
340 R%=50000*17
350 R%=255*65535
360 R%=65535*255
370 R%=1*32768
380 R%=32768*1
390 R%=200*40000
400 R%=40000*200
410 NEXT
420 T816%=TIME
430 PRINT "8x16/16x8  : "; T816%; " cs"

500 REM ---------- full 32 x 32 ----------
510 REM These intentionally exceed 16-bit on both sides
520 REM Results will generally overflow signed 32-bit
530 TIME=0
540 FOR I%=1 TO REPS%
550 R=65537*65539
560 R=70000*70000
570 R=100000*90000
580 R=123456*654321
590 R=214741*100001
600 R=99999*88888
610 R=262147*131071
620 R=70001*65537
630 NEXT
640 T32%=TIME
650 PRINT "32x32      : "; T32%; " cs"

700 PRINT
710 PRINT "Done"
