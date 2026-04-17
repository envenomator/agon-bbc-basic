20 DIM p(2,9)
30 p = 7
40 x = 1
50 y = 2
60 FOR I%=0 TO 9
70   x = x + 0.1
80   y = y + 0.2
90   p = p + 1
100  p(0,I%) = x : p(1,I%) = y - 5 : p(2,I%) = ABS(x - p) / 3
110 NEXT
120 PRINT "scalar p = "; p
130 FOR I%=0 TO 9
140   PRINT I%, p(0,I%), p(1,I%), p(2,I%)
150 NEXT
160 END
