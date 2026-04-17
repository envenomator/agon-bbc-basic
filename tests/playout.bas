   10 MODE 0
   20 N%=10
   30 DIM P(2,N%-1)

   40 FOR I%=0 TO N%-1
   50   P(0,I%) = I%
   60   P(1,I%) = I% + 100
   70   P(2,I%) = I% + 200
   80 NEXT

   90 PRINT "Reading row-wise:"
  100 FOR R%=0 TO 2
  110   PRINT "Row ";R%;": ";
  120   FOR C%=0 TO N%-1
  130     PRINT P(R%,C%);" ";
  140   NEXT
  150   PRINT
  160 NEXT
