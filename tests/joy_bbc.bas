   10 CLS
   20 adc=ADVAL(1)
   30 PRINT "X1: ";,adc
   40 adc=ADVAL(2)
   50 PRINT "Y1: ";,adc
   60 adc=ADVAL(3)
   70 PRINT "X2: ";,adc
   80 adc=ADVAL(4)
   90 PRINT "Y2: ";,adc
  100 fire=ADVAL(0)
  105 PRINT "B1: ";
  110 IF fire AND 1 PRINT "JOY1-B1":ELSE PRINT "-"
  115 PRINT "B2: ";
  120 IF fire AND 2 PRINT "JOY2-B1":ELSE PRINT "-"
  125 PRINT "B3: ";
  130 IF fire AND 4 PRINT "JOY1-B2":ELSE PRINT "-"
  135 PRINT "B4: ";
  140 IF fire AND 8 PRINT "JOY2-B2":ELSE PRINT "-"
  150 WAIT 20
  160 GOTO 10
