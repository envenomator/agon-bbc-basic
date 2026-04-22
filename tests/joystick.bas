   10                                                                                                                                                                 CLS
   20                                                                                                                                                                 J=ADVAL(5)
   30                                                                                                                                                                 IF J AND 1 THEN PRINT "2UP";
   40                                                                                                                                                                 IF J AND 2 THEN PRINT "1UP";
   50                                                                                                                                                                 IF J AND 4 THEN PRINT "2DOWN";
   60                                                                                                                                                                 IF J AND 8 THEN PRINT "1DOWN";
   70                                                                                                                                                                 IF J AND 16 THEN PRINT "2LEFT";
   80                                                                                                                                                                 IF J AND 32 THEN PRINT "1LEFT";
   90                                                                                                                                                                 IF J AND 64 THEN PRINT "2RIGHT";
  100                                                                                                                                                                 IF J AND 128 THEN PRINT "1RIGHT";
  110                                                                                                                                                                 IF J AND 4096 THEN PRINT "2B1";
  120                                                                                                                                                                 IF J AND 8192 THEN PRINT "1B1";
  130                                                                                                                                                                 IF J AND 16384 THEN PRINT "2B2"
  140                                                                                                                                                                 IF J AND 32768 THEN PRINT "1B2";
  150                                                                                                                                                                 WAIT 10
  160                                                                                                                                                                 GOTO 10
