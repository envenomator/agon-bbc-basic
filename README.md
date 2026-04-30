# A port of BBC Basic V to the Agon Platform in eZ80/ADL mode

A port of BBC Basic for Z80 by R.T.Russell.  Modified to run in eZ80/ADL mode on the Agon Platform.
This port is targetting to be functionally compatible with BBC Basic V5 for the Z80 as per upstream repo https://github.com/rtrussell/BBCZ80

### Status: beta

See the issue list for any functionality that isn't supported yet.

### Installation
Copy the 'basic.bin' file to the /bin folder of your SD card.

### Agon specific

#### ADVAL channels

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

### Building

Building from source requires the installation of the [AgonDev Toolchain](https://github.com/AgonPlatform/agondev)
Clone the repository, run 'make' and the resulting binary can be found in the project ./bin folder.

### history/changes

* The project is originally forked from https://github.com/rtrussell/BBCZ80.
* With changes by Dean Netherton to port to ADL mode running on the eZ80 CPU module for RC2014/RCBus kits.
* It has utilised some of changes done by Dean Belfield (https://github.com/breakintoprogram/agon-bbc-basic-adl) in his original ADL port for the Agon platform.
* With changes to the original code to optimize for performance using the ez80 MLT instruction where possible
* With changes to the original code to allow automatic loading/chaining of a file on the Agon CLI

All original copyrights/licenses etc as per individual contributors.
