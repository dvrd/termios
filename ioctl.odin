// +build darwin
package termios
import "core:c"
import "core:os"

TIOCGWINSZ :: 0x40087468

/*
 * Window/terminal size structure.  This information is stored by the kernel
 * in order to provide a consistent interface, but is not used by the kernel.
 */
winsize :: struct {
	ws_row:    c.ushort, /* rows, in characters */
	ws_col:    c.ushort, /* columns, in characters */
	ws_xpixel: c.ushort, /* horizontal size, pixels */
	ws_ypixel: c.ushort, /* vertical size, pixels */
}

ttysize :: struct {
	ts_lines: c.ushort,
	ts_cols: c.ushort,
	ts_xxx: c.ushort,
	ts_yyy: c.ushort,
};

TIOCGSIZE :: TIOCGWINSZ

foreign import libc "system:System.framework"
@(default_calling_convention = "c")
foreign libc {
	ioctl :: proc(fd: os.Handle, request: c.ulong, #c_vararg args: ..any) -> c.int ---
}

