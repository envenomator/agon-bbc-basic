10 REM MUL16-related self-test
20 REM Tests array dimensioning and multidimensional indexing
30 REM Only prints failures, or final success message
40 fail%=0
50 GOSUB 1000
60 GOSUB 2000
70 GOSUB 3000
80 GOSUB 4000
90 GOSUB 5000
100 IF fail%=0 THEN PRINT "All MUL16-related tests passed"
110 END

500 REM Report failure
510 PRINT msg$
520 fail%=fail%+1
530 RETURN

1000 REM SECTION 1 - BASIC 2D indexing
1010 DIM A%(3,4)
1020 FOR i%=0 TO 3
1030 FOR j%=0 TO 4
1040 A%(i%,j%)=i%*100+j%
1050 NEXT
1060 NEXT
1070 FOR i%=0 TO 3
1080 FOR j%=0 TO 4
1090 expected%=i%*100+j%
1100 IF A%(i%,j%)<>expected% THEN msg$="FAIL BASIC 2D: A%("+STR$(i%)+","+STR$(j%)+") expected "+STR$(expected%)+" got "+STR$(A%(i%,j%)):GOSUB 500
1110 NEXT
1120 NEXT
1130 RETURN

2000 REM SECTION 2 - 4D indexing, same order readback
2010 DIM B%(2,3,4,5)
2020 FOR a%=0 TO 2
2030 FOR b%=0 TO 3
2040 FOR c%=0 TO 4
2050 FOR d%=0 TO 5
2060 B%(a%,b%,c%,d%)=a%*1000+b%*100+c%*10+d%
2070 NEXT
2080 NEXT
2090 NEXT
2100 NEXT
2110 FOR a%=0 TO 2
2120 FOR b%=0 TO 3
2130 FOR c%=0 TO 4
2140 FOR d%=0 TO 5
2150 expected%=a%*1000+b%*100+c%*10+d%
2160 IF B%(a%,b%,c%,d%)<>expected% THEN msg$="FAIL 4D: B%("+STR$(a%)+","+STR$(b%)+","+STR$(c%)+","+STR$(d%)+") expected "+STR$(expected%)+" got "+STR$(B%(a%,b%,c%,d%)):GOSUB 500
2170 NEXT
2180 NEXT
2190 NEXT
2200 NEXT
2210 RETURN

3000 REM SECTION 3 - reversed access pattern
3010 DIM C%(3,3,3,3)
3020 FOR a%=0 TO 3
3030 FOR b%=0 TO 3
3040 FOR c%=0 TO 3
3050 FOR d%=0 TO 3
3060 C%(a%,b%,c%,d%)=a%*1000+b%*100+c%*10+d%
3070 NEXT
3080 NEXT
3090 NEXT
3100 NEXT
3110 FOR a%=0 TO 3
3120 FOR b%=0 TO 3
3130 FOR c%=0 TO 3
3140 FOR d%=0 TO 3
3150 expected%=d%*1000+c%*100+b%*10+a%
3160 IF C%(d%,c%,b%,a%)<>expected% THEN msg$="FAIL REVERSED: C%("+STR$(d%)+","+STR$(c%)+","+STR$(b%)+","+STR$(a%)+") expected "+STR$(expected%)+" got "+STR$(C%(d%,c%,b%,a%)):GOSUB 500
3170 NEXT
3180 NEXT
3190 NEXT
3200 NEXT
3210 RETURN

4000 REM SECTION 4 - overwrite and accumulate through same indexing paths
4010 DIM D%(2,2,2,2,2)
4020 FOR a%=0 TO 2
4030 FOR b%=0 TO 2
4040 FOR c%=0 TO 2
4050 FOR d%=0 TO 2
4060 FOR e%=0 TO 2
4070 D%(a%,b%,c%,d%,e%)=0
4080 NEXT
4090 NEXT
4100 NEXT
4110 NEXT
4120 NEXT
4130 FOR p%=1 TO 5
4140 FOR a%=0 TO 2
4150 FOR b%=0 TO 2
4160 FOR c%=0 TO 2
4170 FOR d%=0 TO 2
4180 FOR e%=0 TO 2
4190 D%(a%,b%,c%,d%,e%)=D%(a%,b%,c%,d%,e%)+p%+a%+b%+c%+d%+e%
4200 NEXT
4210 NEXT
4220 NEXT
4230 NEXT
4240 NEXT
4250 NEXT
4260 FOR a%=0 TO 2
4270 FOR b%=0 TO 2
4280 FOR c%=0 TO 2
4290 FOR d%=0 TO 2
4300 FOR e%=0 TO 2
4310 expected%=15+5*(a%+b%+c%+d%+e%)
4320 IF D%(a%,b%,c%,d%,e%)<>expected% THEN msg$="FAIL ACCUM: D%("+STR$(a%)+","+STR$(b%)+","+STR$(c%)+","+STR$(d%)+","+STR$(e%)+") expected "+STR$(expected%)+" got "+STR$(D%(a%,b%,c%,d%,e%)):GOSUB 500
4330 NEXT
4340 NEXT
4350 NEXT
4360 NEXT
4370 NEXT
4380 RETURN

5000 REM SECTION 5 - checksum on larger dimensions
5010 DIM E%(7,7,7)
5020 sum=0
5030 FOR a%=0 TO 7
5040 FOR b%=0 TO 7
5050 FOR c%=0 TO 7
5060 E%(a%,b%,c%)=a%*64+b%*8+c%
5070 sum=sum+E%(a%,b%,c%)
5080 NEXT
5090 NEXT
5100 NEXT
5110 expected=130816
5120 IF sum<>expected THEN msg$="FAIL CHECKSUM WRITE: expected "+STR$(expected)+" got "+STR$(sum):GOSUB 500
5130 sum=0
5140 FOR a%=0 TO 7
5150 FOR b%=0 TO 7
5160 FOR c%=0 TO 7
5170 sum=sum+E%(a%,b%,c%)
5180 NEXT
5190 NEXT
5200 NEXT
5210 IF sum<>expected THEN msg$="FAIL CHECKSUM READ: expected "+STR$(expected)+" got "+STR$(sum):GOSUB 500
5220 RETURN
