# A port of BBC Basic V to the Agon Platform in eZ80/ADL mode

A port of BBC Basic for Z80 by R.T.Russell.  Modified to run in eZ80/ADL mode on the Agon Platform.
This port is targetting to be functionally compatible with BBC Basic V5 for the Z80 as per upstream repo https://github.com/rtrussell/BBCZ80

### Status: beta
See the issue list for any functionality that isn't supported yet.

### Installation
Copy the 'basic.bin' file to the /bin folder of your SD card.

### Requirements
Starting release v0.6, BBC Basic V requires at least MOS version 1.04RC2. While the user is encouraged to update to a much more modern version of [AgonPlatform MOS](https://github.com/AgonPlatform/agon-mos/releases), the ancient 1.04RC2+ MOS version is now the minimum supported configuration.

### [Agon specific implementation details](docs/agonplatform.md)

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
