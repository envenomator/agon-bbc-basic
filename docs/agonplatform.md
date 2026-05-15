# Agon specific implementation details

## LOAD/SAVE
The following file extensions are supported:

- .BBC: LOAD and SAVE in BBC BASIC for Z80 tokenised format
- .BAS: LOAD and SAVE in plain text format (also .TXT and .ASC)

## Line editing
Lines can be edited by using:
1) ````*EDIT <linenumber>````
2) ````*<linenumber>```` - starting at the given linenumber, the user is allowed to scroll through the listing using arrow-keys and/or j/k keys to select a line to edit. Press RETURN, left arrow or BACKSPACE to confirm selection of the line to edit. Escape to quit.

## AGON MOS integration
For the most part, the MOS is transparent to BASIC; most of the operations via the MOS and VDP are accessed via normal BBC BASIC statements, with the following exceptions:

### Accessing the MOS SysVars
MOS has a small area of memory for system state variables (sysvars) which lives in an area of RAM outside of the area in which BBC BASIC runs. To access these, you will need to do an OSBYTE call

Example: Print the least significant byte of the internal clock counter
````
10 L%=&00 : REM The sysvar to fetch
20 A%=&A0 : REM The OSBYTE number
30 PRINT USR(&FFF4)
````
Documentation for the full list of sysvars can be found in the [MOS API documentation](https://agonplatform.github.io/agon-docs/mos/API/#sysvars)

### Running star commands with variables
The star command parser does not use the same evaluator as BBC BASIC, so whilst commands can be run in BASIC, variable names are treated as literals.

Example: This will NOT work

````
10 INPUT "Filename";f$
20 INPUT "Load Address";addr%
30 *LOAD f$ addr%
````
To do this correctly, you must call the star command indirectly using the OSCLI command
Example: This will work

````
30 OSCLI("LOAD " + f$ + " " + STR$(addr%))
````

## Inline assembler
The inline ez80 assembler defaults to ADL=1 mode, as this best fits the default ADL mode of the BBC Basic port.

## ADVAL channels

ADVAL(0) returns the fire buttons as per the BBC Micro User guide in a 16-bit number, plus some extras:
Bits:
- 0 - joystick1 fire button pressed
- 1 - joystick2 fire button pressed
- 2 - joystick1 2nd fire button pressed
- 3 - joystick2 2nd fire button pressed
- 8 - always 1, to indicate virtual BBC Micro ADC channel '1' has completed the ADC conversion.

Examples:
- X=0 no button pressed
- X=1 joystick1 fire button pressed
- X=2 joystick2 fire button pressed
- X=3 both fire buttons pressed

- ADVAL(1) - Returns joystick1 X channel as virtual ADC value (0 = left, 32768 center, 65520 right)
- ADVAL(2) - Returns joystick1 Y channel as virtual ADC value (0 = down, 32768 center, 65520 up)
- ADVAL(3) - Returns joystick2 X channel as virtual ADC value
- ADVAL(4) - Returns joystick2 Y channel as virtual ADC value

ADVAL(5) - Returns all digital joystick pins as a single 16bit number (1 = on, 0 = off)
- 15 - joystick1 2nd fire button
- 14 - joystick2 2nd fire button
- 13 - joystick1 fire button
- 12 - joystick2 fire button
- 11 - not used
- 10 - not used
- 09 - not used
- 08 - not used
- 07 - joystick1 right
- 06 - joystick2 right
- 05 - joystick1 left
- 04 - joystick2 left
- 03 - joystick1 down
- 02 - joystick2 down
- 01 - joystick1 up
- 00 - joystick2 up

Other ADVAL channel values are ignored and return 0

## ENVELOPE
The BBC Basic ENVELOPE keyword will not be implemented on the Agon platform. Agon's VDP has a rich audio API with different envelope options per channel, that can be easily accessed/set through the VDU keyword. Please see the [AgonPlatform VDP Enhanced audio API](https://agonplatform.github.io/agon-docs/vdp/Enhanced-Audio-API/?h=audio+api)

## INKEY behavior
INKEY behaves as documented, except when given a negative value as 'wait' time. The negative value represents the keyvalue to immediately check for. TRUE is returned when the given key is pressed, or 0 if not pressed.

## TINT behavior
TINT can be used to get the current 32bit colorvalue of a single pixel in BGR format. Each B/G/R color is 8bit. The upper 8bit of the 32bit colorvalue is set to 0 always. Setting a colorvalue isn't implemented.

## MODE
The modes differ from those on the BBC series of microcomputers. The full list can be found [here](https://agonplatform.github.io/agon-docs/vdp/Screen-Modes/) in the VDP documentation.

## COLOUR
Syntax: ````COLOUR c````
Change the the current text output colour

- If c is between 0 and 63, the foreground text colour will be set
- If c is between 128 and 191, the background text colour will be set

Syntax: ````COLOUR l,p````

Set the logical colour l to the physical colour p

Syntax: ````COLOUR l,r,g,b````

## GCOL
Syntax: GCOL mode,c
Set the graphics colour c, and the "mode" of graphics paint operations.

Colour values are interpreted as per the COLOUR command, i.e. values below 128 will set the foreground colour, and values above 128 set the background colour.

Versions of the VDP earlier than 1.04 only supported mode 0, with all painting operations just setting on-screen pixels.

VDP 1.04 introduced partial support for mode 4, which inverts the pixel. Mode 4 would only apply to straight line drawing operations. The mode would affect all applicable plot operations.

As of Console8 VDP 2.6.0, all 8 of the basic modes are supported for all currently supported plot operations. Separate plot modes are now tracked for foreground and background colours, and the mode is applied to the graphics operation.
[GCOL paint modes](https://agonplatform.github.io/agon-docs/vdp/PLOT-Commands/#interaction-with-gcol-paint-modes)

## POINT
Syntax: ````POINT(x,y)````
This returns the physical colour index of the colour at pixel position (x, y)

## PLOT
Syntax: ````PLOT mode,x,y````
For information on the various PLOT modes, please see the [VDP PLOT command documentation](https://agonplatform.github.io/agon-docs/vdp/PLOT-Commands/)

## GET$
Syntax: ````GET$(x,y)````
Returns the ASCII character at position x,y

## GET
Syntax: ````GET(x,y)````
As GET$, but returns the ASCII code of the character at position x, y

Syntax: ````GET(p)````
Read and return the value of Z80 port p

## SOUND
Syntax: ````SOUND channel,volume,pitch,duration````
Play a sound through the Agon Light buzzer and audio output jack

- Channel: 0 to 2
- Volume: 0 (off) to -15 or 15 (full volume)
- Pitch: 0 to 255
- Duration: -1 to 254 (duration in 20ths of a second, -1 = play forever)

## TIME$
Access the ESP32 RTC data

Example:
````
  10 REM CLOCK
  20 :
  30 CLS
  40 PRINT TAB(2,2); TIME$
  50 GOTO 40
````
NB: This is a virtual string variable; at the moment only getting the time works. Setting is not implemented.

## VDU
The VDU commands on the Agon Light will be familiar to those who have coded on Acorn machines. Please read the [VDP documentation](https://agonplatform.github.io/agon-docs/vdp/VDU-Commands/) for details on what VDU commands are supported.

