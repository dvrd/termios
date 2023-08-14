// +build darwin
package termios
import "core:c"
import "core:os"

VEOF     :: 0   /* ICANON */
VEOL     :: 1   /* ICANON */
VEOL2    :: 2   /* ICANON together with IEXTEN */
VERASE   :: 3   /* ICANON */
VWERASE  :: 4   /* ICANON together with IEXTEN */
VKILL    :: 5   /* ICANON */
VREPRINT :: 6   /* ICANON together with IEXTEN */
VINTR    :: 8   /* ISIG */
VQUIT    :: 9   /* ISIG */
VSUSP    :: 10  /* ISIG */
VDSUSP   :: 11  /* ISIG together with IEXTEN */
VSTART   :: 12  /* IXON, IXOFF */
VSTOP    :: 13  /* IXON, IXOFF */
VLNEXT   :: 14  /* IEXTEN */
VDISCARD :: 15  /* IEXTEN */
VMIN     :: 16  /* !ICANON */
VTIME    :: 17  /* !ICANON */
VSTATUS  :: 18  /* ICANON together with IEXTEN */
NCCS     :: 20

/* c_iflag bits */
IGNBRK  :: 0x00000001 /* ignore BREAK condition */
BRKINT  :: 0x00000002 /* map BREAK to SIGINTR */
IGNPAR  :: 0x00000004 /* ignore (discard) parity errors */
PARMRK  :: 0x00000008 /* mark parity and framing errors */
INPCK   :: 0x00000010 /* enable checking of parity errors */
ISTRIP  :: 0x00000020 /* strip 8th bit off chars */
INLCR   :: 0x00000040 /* map NL into CR */
IGNCR   :: 0x00000080 /* ignore CR */
ICRNL   :: 0x00000100 /* map CR to NL (ala CRMOD) */
IXON    :: 0x00000200 /* enable output flow control */
IXOFF   :: 0x00000400 /* enable input flow control */
IXANY   :: 0x00000800 /* any char will restart after stop */
IMAXBEL :: 0x00002000 /* ring bell on input queue full */
IUTF8   :: 0x00004000 /* maintain state for UTF-8 VERASE */

/* c_oflag bits */
OPOST		:: 0x00000001 /* enable following output processing */
ONLCR 	:: 0x00000002 /* map NL to CR-NL (ala CRMOD) */
OXTABS	:: 0x00000004 /* expand tabs to spaces */
ONOEOT	:: 0x00000008 /* discard EOT's (^D) on output) */
OCRNL 	:: 0x00000010 /* map CR to NL on output */
ONOCR 	:: 0x00000020 /* no CR output at column 0 */
ONLRET	:: 0x00000040 /* NL performs CR function */
OFILL 	:: 0x00000080 /* use fill characters for delay */
NLDLY 	:: 0x00000300 /* \n delay */
TABDLY	:: 0x00000c04 /* horizontal tab delay */
CRDLY 	:: 0x00003000 /* \r delay */
FFDLY 	:: 0x00004000 /* form feed delay */
BSDLY 	:: 0x00008000 /* \b delay */
VTDLY 	:: 0x00010000 /* vertical tab delay */
OFDEL 	:: 0x00020000 /* fill is DEL, else NUL */
NL0 		:: 0x00000000
NL1 		:: 0x00000100
NL2 		:: 0x00000200
NL3 		:: 0x00000300
TAB0		:: 0x00000000
TAB1		:: 0x00000400
TAB2		:: 0x00000800
TAB3		:: 0x00000004
CR0 		:: 0x00000000
CR1 		:: 0x00001000
CR2 		:: 0x00002000
CR3 		:: 0x00003000
FF0 		:: 0x00000000
FF1 		:: 0x00004000
BS0 		:: 0x00000000
BS1 		:: 0x00008000
VT0 		:: 0x00000000
VT1 		:: 0x00010000

/* c_cflag bit meaning */
CS5    			:: 0x00000000 /* 5 bits (pseudo) */
CS6    			:: 0x00000100 /* 6 bits */
CS7    			:: 0x00000200 /* 7 bits */
CS8    			:: 0x00000300 /* 8 bits */
CSTOPB 			:: 0x00000400 /* send 2 stop bits */
CREAD  			:: 0x00000800 /* enable receiver */
PARENB 			:: 0x00001000 /* parity enable */
PARODD 			:: 0x00002000 /* odd parity, else even */
HUPCL  			:: 0x00004000 /* hang up on last close */

/* c_lflag bits */
ECHOKE    	:: 0x00000001 /* visual erase for line kill */
ECHOE     	:: 0x00000002 /* visually erase chars */
ECHOK     	:: 0x00000004 /* echo NL after line kill */
ECHO      	:: 0x00000008 /* enable echoing */
ECHONL    	:: 0x00000010 /* echo NL even if ECHO is off */
ECHOPRT   	:: 0x00000020 /* visual erase mode for hardcopy */
ECHOCTL   	:: 0x00000040 /* echo control chars as ^(Char) */
ISIG      	:: 0x00000080 /* enable signals INTR, QUIT, [D]SUSP */
ICANON    	:: 0x00000100 /* canonicalize input lines */
ALTWERASE 	:: 0x00000200 /* use alternate WERASE algorithm */
IEXTEN    	:: 0x00000400 /* enable DISCARD and LNEXT */
EXTPROC   	:: 0x00000800 /* external processing */
TOSTOP    	:: 0x00400000 /* stop background jobs from output */
FLUSHO    	:: 0x00800000 /* output being flushed (state) */
NOKERNINFO	:: 0x02000000 /* no kernel output from VSTATUS */
PENDIN    	:: 0x20000000 /* XXX retype pending input (state) */
NOFLSH    	:: 0x80000000 /* don't flush after interrupt */

tcflag_t :: c.ulong
cc_t :: c.uchar
speed_t :: c.ulong

termios :: struct {
	c_iflag:  tcflag_t,
	c_oflag:  tcflag_t,
	c_cflag:  tcflag_t,
	c_lflag:  tcflag_t,
	c_cc:     [NCCS]cc_t,
	c_ispeed: speed_t,
	c_ospeed: speed_t,
}

TCSetAttr_Optional_Actions :: enum c.int {
	NOW   = 0,		/* make change immediate */
	DRAIN = 1,		/* drain output, then change */
	FLUSH = 2,		/* drain output, flush input */
	SOFT  = 0x10, /* flag - don't alter h.w. state */
}

/*
 * Standard speeds
 */
B0     		:: 0
B50    		:: 50
B75    		:: 75
B110   		:: 110
B134   		:: 134
B150   		:: 150
B200   		:: 200
B300   		:: 300
B600   		:: 600
B1200  		:: 1200
B1800  		:: 1800
B2400  		:: 2400
B4800  		:: 4800
B9600  		:: 9600
B19200 		:: 19200
B38400 		:: 38400
B7200  		:: 7200
B14400 		:: 14400
B28800 		:: 28800
B57600 		:: 57600
B76800 		:: 76800
B115200		:: 115200
B230400		:: 230400
EXTA   		:: 19200
EXTB   		:: 38400

TCIFLUSH  :: 1
TCOFLUSH  :: 2
TCIOFLUSH :: 3
TCOOFF    :: 1
TCOON     :: 2
TCIOFF    :: 3
TCION     :: 4


foreign import libc "system:System.framework"
@(default_calling_convention = "c")
foreign libc {
	cfgetispeed :: proc(termios_p: ^termios) -> speed_t ---
	cfgetospeed :: proc(termios_p: ^termios) -> speed_t ---
	cfsetispeed :: proc(termips_p: ^termios, speed: speed_t) -> c.int ---
	cfsetospeed :: proc(termips_p: ^termios, speed: speed_t) -> c.int ---
	tcgetattr :: proc(fd: os.Handle, termios_p: ^termios) -> c.int ---
	tcsetattr :: proc(fd: os.Handle, optional_actions: TCSetAttr_Optional_Actions, termios_p: ^termios) -> c.int ---
	tcdrain :: proc(int) -> c.int ---
	tcflow :: proc(int, int) -> c.int ---
	tcflush :: proc(int, int) -> c.int ---
	tcsendbreak :: proc(int, int) -> c.int ---
	cfmakeraw :: proc(termips_p: ^termios) ---
	cfsetspeed :: proc(termips_p: ^termios, speed: speed_t) -> c.int ---
}

