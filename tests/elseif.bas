10 FOR r=0 TO 1 STEP 0.2
20   IF r>0.93 THEN
30     k=1
40   ELSE
50     IF r>0.86 THEN
60       k=2
70     ELSE
80       IF r>0.10 THEN
90         k=3
100      ELSE
110        k=4
120      ENDIF
130    ENDIF
140  ENDIF
150  PRINT r,k
160 NEXT
