   10 MODE 27
   20 GCOL 0,15
   30 DIM XX(4), XY(4), YX(4), YY(4), YT(4)
   40 XX(2)=0.98 : XY(2)=-0.97 : YX(2)=0.9 : YY(2)=0.96 : YT(2)=1.7
   50 XX(4)=-0.15 : XY(4)=.28 : YX(4)=.26 : YY(4)=.24 : YT(4)=.44
   60 X=0: Y=0
   70 FOR I = 1 TO 20000
   80   R = INT(RND(1)*100)
   90   IF R<86 THEN F=2 ELSE F=4
  100   X=XX(F)*X + XY(F)*Y
  110   Y=YX(F)*X + YY(F)*Y + YT(F)
  120   SX=1000 + X*200
  130   SY=552 - Y*200
  140   GCOL 0,RND(64)+1
  150   PLOT 69,SX,SY
  160 NEXT
  170 A=GET
