   10 DIM code% 100
   20 FOR opt=1 TO 3 STEP 2
   30   P%=code% : O%=code%
   40   [OPT opt
   50   LD HL,0
   60   LD HL,&123456
   70   JP &123456
   80   CALL &123456
   90   .loop
  100   LD HL,loop
  110   JR fwd
  120   DEFB 0
  130   .fwd
  140   ]
  150 NEXT
