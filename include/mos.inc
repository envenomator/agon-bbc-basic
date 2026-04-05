;
; Title:	AGON MOS - API for user projects
; Author:	Dean Belfield
; Created:	03/08/2022
; Last Updated:	12/03/2026
; Adjusted for fasmg assembler (Paul Cawte, 16/06/2023)
; Adjusted for MOS 3.0 API (Jeroen Venema, 18/04/2025)
;
; Modinfo:
; 05/08/2022:	Added mos_feof
; 09/08/2022:	Added system variables: cursorX, cursorY
; 18/08/2022:	Added system variables: scrchar, scrpixel, audioChannel, audioSuccess, vdp_pflags
; 05/09/2022:	Added mos_ren, vdp_pflag_mode
; 24/09/2022:	Added mos_getError, mos_mkdir
; 13/10/2022:	Added mos_oscli
; 23/02/2023:	Added more sysvars, fixed typo in sysvar_audioSuccess, offsets for sysvar_scrCols, sysvar_scrRows
; 04/03/2023:	Added sysvar_scrpixelIndex
; 08/03/2023:	Renamed sysvar_keycode to sysvar_keyascii, added sysvar_vkeycode
; 15/03/2023:	Added mos_copy, mos_getrtc, mos_setrtc, rtc, vdp_pflag_rtc
; 21/03/2023:	Added mos_setintvector, sysvars for keyboard status, vdu codes for vdp
; 22/03/2023:	The VDP commands are now indexed from 0x80
; 29/03/2023:	Added mos_uopen, mos_uclose, mos_ugetc, mos_uputc
; 13/04/2023:	Added FatFS file structures (FFOBJID, FIL, DIR, FILINFO)
; 15/04/2023:	Added mos_getfil, mos_fread, mos_fwrite and mos_flseek
; 18/11/2023:	Added _mos_setkbvector, _mos_getkbmap, _mos_i2c_open, _mos_i2c_close, _mos_i2c_write, _mos_i2c_read
; 18/04/2025: Added remaining ffs_* API values in MOS 2.20 / 3.0
; 11/11/2025: Added 0x27+ sysvar offsets
; 12/03/2026: Added FILINFO.attrib attribute bits

; VDP control (VDU 23, 0, n)
;
vdp_gp                  := 0x080
vdp_keycode             := 0x081
vdp_cursor              := 0x082
vdp_scrchar             := 0x083
vdp_scrpixel            := 0x084
vdp_audio               := 0x085
vdp_mode                := 0x086
vdp_rtc                 := 0x087
vdp_keystate            := 0x088
vdp_logicalcoords       := 0x0C0
vdp_terminalmode        := 0x0FF

; MOS high level functions
;
mos_getkey              := 0x000
mos_load                := 0x001
mos_save                := 0x002
mos_cd                  := 0x003
mos_dir                 := 0x004
mos_del                 := 0x005
mos_ren                 := 0x006
mos_mkdir               := 0x007
mos_sysvars             := 0x008
mos_editline            := 0x009
mos_fopen               := 0x00A
mos_fclose              := 0x00B
mos_fgetc               := 0x00C
mos_fputc               := 0x00D
mos_feof                := 0x00E
mos_getError            := 0x00F
mos_oscli               := 0x010
mos_copy                := 0x011
mos_getrtc              := 0x012
mos_setrtc              := 0x013
mos_setintvector        := 0x014
mos_uopen               := 0x015
mos_uclose              := 0x016
mos_ugetc               := 0x017
mos_uputc               := 0x018
mos_getfil              := 0x019
mos_fread               := 0x01A
mos_fwrite              := 0x01B
mos_flseek              := 0x01C
mos_setkbvector         := 0x01D
mos_getkbmap            := 0x01E
mos_i2c_open            := 0x01F
mos_i2c_close           := 0x020
mos_i2c_write           := 0x021
mos_i2c_read            := 0x022
mos_unpackrtc           := 0x023
mos_flseek_p            := 0x024
mos_pmatch              := 0x028
mos_getargument         := 0x029
mos_extractstring       := 0x02A
mos_extractnumber       := 0x02B
mos_escapestring        := 0x02C
mos_setvarval           := 0x030
mos_readvarval          := 0x031
mos_gsinit              := 0x032
mos_gsread              := 0x033
mos_gstrans             := 0x034
mos_substituteargs      := 0x035
mos_evaluateexpression  := 0x036
mos_resolvepath         := 0x038
mos_getdirforpath       := 0x039
mos_getleafname         := 0x03A
mos_isdirectory         := 0x03B
mos_getabsolutepath     := 0x03C
mos_clearvdpflags       := 0x040
mos_waitforvdpflags     := 0x041
mos_getfunction         := 0x050
sd_getunlockcode        := 0x070
sd_init                 := 0x071
sd_readblocks           := 0x072
sd_writeblocks          := 0x073

; FatFS file access functions
;
ffs_fopen               := 0x080
ffs_fclose              := 0x081
ffs_fread               := 0x082
ffs_fwrite              := 0x083
ffs_flseek              := 0x084
ffs_ftruncate           := 0x085
ffs_fsync               := 0x086
ffs_fforward            := 0x087
ffs_fexpand             := 0x088
ffs_fgets               := 0x089
ffs_fputc               := 0x08A
ffs_fputs               := 0x08B
ffs_fprintf             := 0x08C
ffs_ftell               := 0x08D
ffs_feof                := 0x08E
ffs_fsize               := 0x08F
ffs_ferror              := 0x090

; FatFS directory access functions
;
ffs_dopen               := 0x091
ffs_dclose              := 0x092
ffs_dread               := 0x093
ffs_dfindfirst          := 0x094
ffs_dfindnext           := 0x095

; FatFS file and directory management functions
;
ffs_stat                := 0x096
ffs_unlink              := 0x097
ffs_rename              := 0x098
ffs_chmod               := 0x099
ffs_utime               := 0x09A
ffs_mkdir               := 0x09B
ffs_chdir               := 0x09C
ffs_chdrive             := 0x09D
ffs_getcwd              := 0x09E

; FatFS volume management and system configuration functions
;
ffs_mount               := 0x09F
ffs_mkfs                := 0x0A0
ffs_fdisk               := 0x0A1
ffs_getfree             := 0x0A2
ffs_getlabel            := 0x0A3
ffs_setlabel            := 0x0A4
ffs_setcp               := 0x0A5
ffs_flseek_p            := 0x0A6

; File access modes
;
fa_read	                := 0x001
fa_write                := 0x002
fa_open_existing        := 0x000
fa_create_new           := 0x004
fa_create_always        := 0x008
fa_open_always          := 0x010
fa_open_append          := 0x030

; File attribute bits for directory entry (FILINFO.fattrib) 
;
am_rdo := 0x01	 ; Read only 
am_hid := 0x02	 ; Hidden 
am_sys := 0x04	 ; System 
am_dir := 0x10	 ; Directory 
am_arc := 0x20	 ; Archive 

; System variable indexes for api_sysvars
; Index into _sysvars in globals.asm
;
sysvar_time             := 0x000	 ; 4: Clock timer in centiseconds (incremented by 2 every VBLANK)
sysvar_vdp_pflags       := 0x004	 ; 1: Flags to indicate completion of VDP commands
sysvar_keyascii         := 0x005	 ; 1: ASCII keycode, or 0 .if no key is pressed
sysvar_keymods          := 0x006	 ; 1: Keycode modifiers
sysvar_cursorX          := 0x007	 ; 1: Cursor X position
sysvar_cursorY          := 0x008	 ; 1: Cursor Y position
sysvar_scrchar          := 0x009	 ; 1: Character read from screen
sysvar_scrpixel         := 0x00A	 ; 3: Pixel data read from screen (R,B,G)
sysvar_audioChannel     := 0x00D	 ; 1: Audio channel 
sysvar_audioSuccess     := 0x00E	 ; 1: Audio channel note queued (0 = no, 1 = yes)
sysvar_scrWidth         := 0x00F	 ; 2: Screen width in pixels
sysvar_scrHeight        := 0x011	 ; 2: Screen height in pixels
sysvar_scrCols          := 0x013	 ; 1: Screen columns in characters
sysvar_scrRows          := 0x014	 ; 1: Screen rows in characters
sysvar_scrColours       := 0x015	 ; 1: Number of colours displayed
sysvar_scrpixelIndex	:= 0x016	 ; 1: Index of pixel data read from screen
sysvar_vkeycode         := 0x017	 ; 1: Virtual key code from FabGL
sysvar_vkeydown         := 0x018	 ; 1: Virtual key state from FabGL (0=up, 1=down)
sysvar_vkeycount        := 0x019	 ; 1: Incremented every time a key packet is received
sysvar_rtc              := 0x01A	 ; 8: Real time clock data
sysvar_keydelay         := 0x022	 ; 2: Keyboard repeat delay
sysvar_keyrate          := 0x024	 ; 2: Keyboard repeat reat
sysvar_keyled           := 0x026	 ; 1: Keyboard LED status
sysvar_scrMode			:= 0x027	 ; 1: Screen mode
sysvar_rtcEnable		:= 0x028	 ; 1: RTC enable flag (0: disabled, 1: use ESP32 RTC)
sysvar_mouseX           := 0x029  ; 2: Mouse X position
sysvar_mouseY           := 0x02B  ; 2: Mouse Y position
sysvar_mouseButtons     := 0x02D  ; 1: Mouse left+right+middle buttons (bits 0-2, 0=up, 1=down)
sysvar_mouseWheel       := 0x02E  ; 1: Mouse wheel delta
sysvar_mouseXDelta      := 0x02F  ; 2: Mouse X delta
sysvar_mouseYDelta      := 0x031  ; 2: Mouse Y delta
	
; Flags for the VDP protocol
;
vdp_pflag_cursor        := 0b00000001
vdp_pflag_scrchar       := 0b00000010
vdp_pflag_point         := 0b00000100
vdp_pflag_audio         := 0b00001000
vdp_pflag_mode          := 0b00010000
vdp_pflag_rtc           := 0b00100000

;
; FatFS structures
; These mirror the structures contained in src_fatfs/ff.h in the MOS project
;
; Object ID and allocation information (FFOBJID)
;
;FFOBJID	.STRUCT
;	fs:		DS	3	; Pointer to the hosting volume of this object
;	id:		DS	2	; Hosting volume mount ID
;	attr:		DS	1	; Object attribute
;	stat:		DS	1	; Object chain status (b1-0: =0:not contiguous, =2:contiguous, 
;					;  =3:fragmented in this session, b2:sub-directory stretched)
;	sclust:		DS	4	; Object data start cluster (0:no cluster or root directory)
;	objsize:	DS	4	; Object size (valid when sclust != 0)
;FFOBJID_SIZE .ENDSTRUCT FFOBJID
;
; File object structure (FIL)
;
;FIL .STRUCT
FIL.obj.objsize: .equ 0x0B
;	obj:		.TAG	FFOBJID	; Object identifier
;	flag:		DS	1	; File status flags
;	err:		DS	1	; Abort flag (error code)
FIL.fptr  .equ 11
;	fptr:		DS	4	; File read/write pointer (Zeroed on file open)
;	clust:		DS	4	; Current cluster of fpter (invalid when fptr is 0)
;	sect:		DS	4	; Sector number appearing in buf[] (0:invalid)
;	dir_sect:	DS	4	; Sector number containing the directory entry
;	dir_ptr:	DS	3	; Pointer to the directory entry in the win[]
;FIL_SIZE .ENDSTRUCT FIL
;
; Directory object structure (DIR)
; 
;DIR .STRUCT
;	obj:		.TAG	FFOBJID	; Object identifier
;	dptr:		DS	4	; Current read/write offset
;	clust:		DS	4	; Current cluster
;	sect:		DS	4	; Current sector (0:Read operation has terminated)
;	dir:		DS	3	; Pointer to the directory item in the win[]
;	fn:		DS	12	; SFN (in/out) {body[8],ext[3],status[1]}
;	blk_ofs:	DS	4	; Offset of current entry block being processed (0xFFFFFFFF:Invalid)
;DIR_SIZE .ENDSTRUCT DIR
;
; File information structure (FILINFO)
;
;FILINFO .STRUCT
;	fsize:		DS 	4	; File size
;	fdate:		DS	2	; Modified date
;	ftime:		DS	2	; Modified time
;	fattrib:	DS	1	; File attribute
;	altname:	DS	13	; Alternative file name
;	fname:		DS	256	; Primary file name
;FILINFO_SIZE .ENDSTRUCT FILINFO
;
;
