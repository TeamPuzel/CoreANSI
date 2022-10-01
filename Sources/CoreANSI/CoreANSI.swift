//
//  This is the main file of CoreANSI,
//  a library for Swiftier terminal formatting,
//  and the foundation for SwiftTerminalUI
//
//  Created by TeamPuzel on 25/09/2022.
//

#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#elseif os(Windows)
#error("Windows not supported")
#endif

public extension String {
    @inlinable func foregroundColor(_ color: CAColor) -> String {
        switch color {
            case .black:
                return "\u{001B}[30m" + self
            case .red:
                return "\u{001B}[31m" + self
            case .green:
                return "\u{001B}[32m" + self
            case .yellow:
                return "\u{001B}[33m" + self
            case .blue:
                return "\u{001B}[34m" + self
            case .magenta:
                return "\u{001B}[35m" + self
            case .cyan:
                return "\u{001B}[36m" + self
            case .white:
                return "\u{001B}[37m" + self
            case .`default`:
                return "\u{001B}[39m" + self
            case .reset:
                return "\u{001B}[0m" + self
        }
    }
    @inlinable func backgroundColor(_ color: CAColor) -> String {
        switch color {
            case .black:
                return "\u{001B}[40m" + self
            case .red:
                return "\u{001B}[41m" + self
            case .green:
                return "\u{001B}[42m" + self
            case .yellow:
                return "\u{001B}[43m" + self
            case .blue:
                return "\u{001B}[44m" + self
            case .magenta:
                return "\u{001B}[45m" + self
            case .cyan:
                return "\u{001B}[46m" + self
            case .white:
                return "\u{001B}[47m" + self
            case .`default`:
                return "\u{001B}[49m" + self
            case .reset:
                return "\u{001B}[0m" + self
        }
    }
    @inlinable func formatting(_ formatting: CAGraphicsMode...) -> String {
        var buffer = "" ; buffer.reserveCapacity(self.count + (formatting.count * 11) + 11)
        for argument in formatting {
            switch argument {
                case .bold:
                    buffer.append("\u{001B}[1m")
                case .italic:
                    buffer.append("\u{001B}[3m")
                case .underline:
                    buffer.append("\u{001B}[4m")
                case .strikethrough:
                    buffer.append("\u{001B}[9m")
                case .faint:
                    buffer.append("\u{001B}[2m")
                case .blinking:
                    buffer.append("\u{001B}[5m")
                case .inverse:
                    buffer.append("\u{001B}[7m")
                case .invisible:
                    buffer.append("\u{001B}[8m")
            }
        }
        buffer.append(self)
        buffer.append("\u{001B}[0m")
        return buffer
    }
}

//  ESC Code Sequence    Description
//  ESC[38;2;{r};{g};{b}m    Set foreground color as RGB.
//  ESC[48;2;{r};{g};{b}m    Set background color as RGB.

//  Note that ;38 and ;48 corresponds to the 16 color sequence and is interpreted by the terminal to set the foreground and background color respectively. Where as ;2 and ;5 sets the color format.

//  public typealias CArgb = (UInt8, UInt8, UInt8)

// on macOS both seem to set the background.

public extension String {
    /// Caution, this is not documented and likely unsupported.
    ///
    /// Creates a color based on rgb values
    /// - Parameters:
    ///   - r: Red.
    ///   - g: Green.
    ///   - b: Blue.
    @inlinable func unsafeForegroundRGB(_ r: UInt8, _ g: UInt8, _ b: UInt8) -> String {
        return "\u{001B}[38;2;\(r);\(g);\(b)m" + self
    }
    /// Caution, this is not documented and likely unsupported.
    ///
    /// Creates a color based on rgb values
    /// - Parameters:
    ///   - r: Red.
    ///   - g: Green.
    ///   - b: Blue.
    @inlinable func unsafeBackgroundRGB(_ r: UInt8, _ g: UInt8, _ b: UInt8) -> String {
        return "\u{001B}[48;2;\(r);\(g);\(b)m" + self
    }
}

// TODO: 256 colors

//public extension String {
//    @inlinable func foreground256(_ color: ANSIColor256) -> String {
//
//    }
//    @inlinable func background256(_ color: ANSIColor256) -> String {
//
//    }
//}
//
//public enum ANSIColor256 {
//
//}

public enum CAGraphicsMode {
    case bold
    case italic
    case underline
    case strikethrough
    case faint
    case blinking
    case inverse
    case invisible
}

public enum CAColor {
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default`
    case reset
}

@inlinable public func erase(_ operation: CAErase) {
    switch operation {
        case .screen:
            print("\u{001B}[2J")
        case .inDisplay:
            print("\u{001B}[J")
        case .savedLines:
            print("\u{001B}[3J")
        case .eraseLine:
            print("\u{001B}[2K")
        case .fromCursorToLineEnd:
            print("\u{001B}[0K")
        case .fromCursorToLineStart:
            print("\u{001B}[1K")
        case .fromCursorToScreenEnd:
            print("\u{001B}[0J")
        case .fromCursorToScreenStart:
            print("\u{001B}[1J")
    }
}

public enum CAErase {
    case screen
    case inDisplay
    case savedLines
    case eraseLine
    case fromCursorToLineEnd
    case fromCursorToLineStart
    case fromCursorToScreenEnd
    case fromCursorToScreenStart
}

/// Moves the cursor relative to it's current position.
/// - Parameters:
///   - direction: Direction in which the cursor will move.
///   - distance: Move by how many tiles. Defaults to 1 if not specified.
@inlinable public func moveCursor(_ direction: CADirection, _ distance: Int?) {
    switch direction {
        case .left:
            print("\u{001B}[\(distance ?? 1)D")
        case .right:
            print("\u{001B}[\(distance ?? 1)C")
        case .up:
            print("\u{001B}[\(distance ?? 1)A")
        case .down:
            print("\u{001B}[\(distance ?? 1)B")
    }
}

/// Direction shorthand.
public enum CADirection {
    case left
    case right
    case up
    case down
}

/// Allows storing the cursor position and restoring it.
/// - Parameters:
///   - operation: Can be either `.save` or `.load`.
///   - mode: While some terminal emulators support both `SCO` and `DEC` sequences,
///   they are likely to have different functionality. It is recommended to use `DEC` sequences.
///   Defaults to `DEC` if not specified.
@inlinable public func cursorMemory(
    _ operation: _CursorMemory.CursorMemoryOperation,
    mode: _CursorMemory.CursorMemoryOperationMode?) {
        if mode == .DEC || mode == nil {
            switch operation {
                case .save:
                    print("\u{001B}7") // space 7?
                case .load:
                    print("\u{001B}8") // space 8?
            }
        } else if mode == .SCO {
            switch operation {
                case .save:
                    print("\u{001B}[s")
                case .load:
                    print("\u{001B}[u")
            }
        }
}

public struct _CursorMemory {
    public enum CursorMemoryOperation {
        case save
        case load
    }
    public enum CursorMemoryOperationMode {
        case DEC
        case SCO
    }
}

/// Resets the cursor to `(0,0)`.
@inlinable public func resetCursor() {
    print("\u{001B}[H")
}

/// Moves the cursor to the specified position.
/// - Parameters:
///   - line: y axis.
///   - column: x axis.
@inlinable public func moveCursorTo(line: Int, column: Int) {
    print("\u{001B}[\(line);\(column)H")
}

/// Moves the cursor down and to the beginning of the next line.
/// - Parameter by: Defaults to 1, specifies the amount of lines to move by.
@inlinable public func moveCursorToNextLine(by: Int?) {
    print("\u{001B}[\(by ?? 1)E")
}

/// Moves the cursor down and to the beginning of the previous line.
/// - Parameter by: Defaults to 1, specifies the amount of lines to move by.
@inlinable public func moveCursorToPreviousLine(by: Int?) {
    print("\u{001B}[\(by ?? 1)F")
}

@inlinable public func moveCursorToColumn(_ value: Int) {
    print("\u{001B}[\(value)G")
}

// request cursor position (reports as ESC[#;#R) - uses [6n
// TODO: function to retrieve position

private enum _Sequences {
    /// Sequence starting with `ESC (\x1B)`
    case ESC
    /// Control Sequence Introducer: sequence starting with `ESC [` or `CSI (\x9B)`
    case CSI
    /// Device Control String: sequence starting with `ESC P` or `DCS (\x90)`
    case DCS
    /// Operating System Command: sequence starting with `ESC ]` or `OSC (\x9D)`
    case OSC
}

// Note: Some control escape sequences, like \e for ESC, are not guaranteed to work in all languages and compilers. It is recommended to use the decimal, octal or hex representation as escape code.
                                                    
// Note: The Ctrl-Key representation is simply associating the non-printable characters from ASCII code 1 with the printable (letter) characters from ASCII code 65 ("A"). ASCII code 1 would be ^A (Ctrl-A), while ASCII code 7 (BEL) would be ^G (Ctrl-G). This is a common representation (and input method) and historically comes from one of the VT series of terminals.

struct ASCIICodes {
    struct Code {
        let name: String
        let cEscape: String
        let ctrlKey: String
        let desciption: String
    }
    static let ASCIICODETABLE: [ASCIICodes.Code] = [
        Code(name: "BEL", cEscape: #"\a"#    , ctrlKey: "^G"    , desciption: "Term bell"),
        Code(name: "BS" , cEscape: #"\b"#    , ctrlKey: "^H"    , desciption: "Backspace"),
        Code(name: "HT" , cEscape: #"\t"#    , ctrlKey: "^I"    , desciption: "Horizontal TAB"),
        Code(name: "LF" , cEscape: #"\n"#    , ctrlKey: "^J"    , desciption: "Newline"),
        Code(name: "VT" , cEscape: #"\v"#    , ctrlKey: "^K"    , desciption: "Vertical TAB"),
        Code(name: "FF" , cEscape: #"\f"#    , ctrlKey: "^L"    , desciption: "Formfeed"),
        Code(name: "CR" , cEscape: #"\r"#    , ctrlKey: "^M"    , desciption: "Carriage return"),
        Code(name: "ESC", cEscape: #"\e"#    , ctrlKey: "^["    , desciption: "Escape char"),
        Code(name: "DEL", cEscape: #"<none>"#, ctrlKey: "<none>", desciption: "Delete char")
    ]
}

//  Name    decimal    octal    hex    C-escape    Ctrl-Key    Description
//  BEL     7          007      0x07   \a          ^G          Terminal bell
//  BS      8          010      0x08   \b          ^H          Backspace
//  HT      9          011      0x09   \t          ^I          Horizontal TAB
//  LF      10         012      0x0A   \n          ^J          Linefeed (newline)
//  VT      11         013      0x0B   \v          ^K          Vertical TAB
//  FF      12         014      0x0C   \f          ^L          Formfeed (also: New page NP)
//  CR      13         015      0x0D   \r          ^M          Carriage return
//  ESC     27         033      0x1B   \e*         ^[          Escape character
//  DEL     127        177      0x7F   <none>      <none>      Delete character

@inlinable public func privateMode(_ option: PrivateModes) {
    switch option {
        case .invisibleCursor:
            print("\u{001B}[?25l")
        case .visibleCursor:
            print("\u{001B}[?25h")
        case .saveScreen:
            print("\u{001B}[?47h")
        case .loadScreen:
            print("\u{001B}[?47l")
        case .enableAlternativeBuffer:
            print("\u{001B}[?1049h")
        case .disableAlternativeBuffer:
            print("\u{001B}[?1049l")
    }
}

public enum PrivateModes {
    case invisibleCursor
    case visibleCursor
    case saveScreen
    case loadScreen
    case enableAlternativeBuffer
    case disableAlternativeBuffer
}

public typealias CACoordinates = (x: Int, y: Int)

@inlinable public func getWindowSize() -> CACoordinates {
    var window: winsize = winsize(
        ws_row: 0,
        ws_col: 0,
        ws_xpixel: 0,
        ws_ypixel: 0)
    withUnsafeMutablePointer(to: &window) { pointer in
        #if os(macOS)
        _ = ioctl(0, TIOCGWINSZ, pointer)
        #elseif os(Linux)
        // Idk why I had to do this but ok
        _ = ioctl(0, UInt(TIOCGWINSZ), pointer)
        #endif
    }
    let size: CACoordinates = (Int(window.ws_col), Int(window.ws_row))
    return size
}

//@inlinable public func getCursorPosition()/* -> CACoordinates */{
//    let t = getTermios()
//    setTermios(t, mode: .cBreak)
//    print("\u{001B}[6n")
//    let line = readLine()
//    setTermios(t, mode: .setC
//    print(line!.formatting(.blinking))
//}

//@inlinable func setTermios(_ t: termios, mode: TermiosCommand) {
//    var buffer = t
//    switch mode {
//        case .setCanonical:
//            buffer.c_lflag = buffer.c_lflag | 0x8000
//        case .cBreak:
//            buffer.c_lflag = buffer.c_lflag ^ 0x8000
//    }
//    withUnsafeMutablePointer(to: &buffer) { pointer in
//        _ = tcsetattr(0x0, 0x0, pointer)
//    }
//}
//
//@usableFromInline enum TermiosCommand {
//    case setCanonical
//    case cBreak
//}
//
//@inlinable func getTermios() -> termios {
//    var mtermios: termios = termios(
//        c_iflag: 0,
//        c_oflag: 0,
//        c_cflag: 0,
//        c_lflag: 0,
//        c_cc: (0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0),
//        c_ispeed: 0x0,
//        c_ospeed: 0x0)
//    withUnsafeMutablePointer(to: &mtermios) { pointer in
//        _ = tcgetattr(0, pointer)
//    }
//    return mtermios
//}

//@inlinable public func getWindowSize() -> CACoordinates {
//
//}

@inlinable public func setScreenMode(_ mode: CAScreenMode) {
    switch mode {
        case .mono40x20_text:
            print("\u{001B}[=0h")
        case .color40x20_text:
            print("\u{001B}[=1h")
        case .mono80x25_text:
            print("\u{001B}[=2h")
        case .color80x25_text:
            print("\u{001B}[=3h")
        case .fourcolor320x200_graphics:
            print("\u{001B}[=4h")
        case .mono320x200_graphics:
            print("\u{001B}[=5h")
        case .mono640x200_graphics:
            print("\u{001B}[=6h")
        case .color320x200_graphics:
            print("\u{001B}[=13h")
        case .sixteencolor640x200_graphics:
            print("\u{001B}[=14h")
        case .mono640x350_dualcolor_graphics:
            print("\u{001B}[=15h")
        case .sixteencolor640x350_graphics:
            print("\u{001B}[=16h")
        case .mono640x480_dualcolor_graphics:
            print("\u{001B}[=17h")
        case .sixteencolor640x480_graphics:
            print("\u{001B}[=18h")
        case .color320x200_graphics256:
            print("\u{001B}[=19h")
            
        // TODO: MOVE SOMEWHERE ELSE
        case .enableLineWrapping:
            print("\u{001B}[=7h")
    }
}

// TODO: implement reset

public enum CAScreenMode {
    case mono40x20_text
    case color40x20_text
    case mono80x25_text
    case color80x25_text
    case fourcolor320x200_graphics
    case mono320x200_graphics
    case mono640x200_graphics
    case color320x200_graphics
    case sixteencolor640x200_graphics
    case mono640x350_dualcolor_graphics
    case sixteencolor640x350_graphics
    case mono640x480_dualcolor_graphics
    case sixteencolor640x480_graphics
    case color320x200_graphics256
    // TODO: This should be implemented elsewhere
    case enableLineWrapping
}


//  Keyboard Strings
//
//  ESC[{code};{string};{...}p
//  Redefines a keyboard key to a specified string.
//
//  The parameters for this escape sequence are defined as follows:
//
//  code is one or more of the values listed in the following table. These values represent keyboard keys and key combinations. When using these values in a command, you must type the semicolons shown in this table in addition to the semicolons required by the escape sequence. The codes in parentheses are not available on some keyboards. ANSI.SYS will not interpret the codes in parentheses for those keyboards unless you specify the /X switch in the DEVICE command for ANSI.SYS.
//
//  string is either the ASCII code for a single character or a string contained in quotation marks. For example, both 65 and "A" can be used to represent an uppercase A.
//
//  IMPORTANT: Some of the values in the following table are not valid for all computers. Check your computer's documentation for values that are different.

public struct KeyboardMapping {
    struct MappableKey {
        let name: String
        let code: String
        let shift: String
        let control: String
        let option: String
    }
    static let KeyboardTable: [MappableKey] = [
        MappableKey(name: "F1"             , code: "0;59"  , shift: "0;84"  , control: "0;94"   , option: "0;104"),
        MappableKey(name: "F2"             , code: "0;60"  , shift: "0;85"  , control: "0;95"   , option: "0;105"),
        MappableKey(name: "F3"             , code: "0;61"  , shift: "0;86"  , control: "0;96"   , option: "0;106"),
        MappableKey(name: "F4"             , code: "0;62"  , shift: "0;87"  , control: "0;97"   , option: "0;107"),
        MappableKey(name: "F5"             , code: "0;63"  , shift: "0;88"  , control: "0;98"   , option: "0;108"),
        MappableKey(name: "F6"             , code: "0;64"  , shift: "0;89"  , control: "0;99"   , option: "0;109"),
        MappableKey(name: "F7"             , code: "0;65"  , shift: "0;90"  , control: "0;100"  , option: "0;110"),
        MappableKey(name: "F8"             , code: "0;66"  , shift: "0;91"  , control: "0;101"  , option: "0;111"),
        MappableKey(name: "F9"             , code: "0;67"  , shift: "0;92"  , control: "0;102"  , option: "0;112"),
        MappableKey(name: "F10"            , code: "0;68"  , shift: "0;93"  , control: "0;103"  , option: "0;113"),
        MappableKey(name: "F11"            , code: "0;133" , shift: "0;135" , control: "0;137"  , option: "0;139"),
        MappableKey(name: "F12"            , code: "0;134" , shift: "0;136" , control: "0;138"  , option: "0;140"),
        MappableKey(name: "HOME_NUM"       , code: "0;71"  , shift: "55"    , control: "0;119"  , option: ""),
        MappableKey(name: "UP_ARROW_NUM"   , code: "0;72"  , shift: "56"    , control: "0;141"  , option: ""),
        MappableKey(name: "PAGE_UP_NUM"    , code: "0;73"  , shift: "57"    , control: "0;132"  , option: ""),
        MappableKey(name: "LEFT_ARROW_NUM" , code: "0;75"  , shift: "52"    , control: "0;115"  , option: ""),
        MappableKey(name: "RIGHT_ARROW_NUM", code: "0;77"  , shift: "54"    , control: "0;116"  , option: ""),
        MappableKey(name: "END_NUM"        , code: "0;79"  , shift: "49"    , control: "0;117"  , option: ""),
        MappableKey(name: "DOWN_ARROW_NUM" , code: "0;80"  , shift: "50"    , control: "0;145"  , option: ""),
        MappableKey(name: "PAGE_DOWN_NUM"  , code: "0;81"  , shift: "51"    , control: "0;118"  , option: ""),
        MappableKey(name: "INSERT_NUM"     , code: "0;82"  , shift: "48"    , control: "0;146"  , option: ""),
        MappableKey(name: "DELETE_NUM"     , code: "0;83"  , shift: "46"    , control: "0;147"  , option: ""),
        MappableKey(name: "HOME"           , code: "224;71", shift: "224;71", control: "224;119", option: "224;151"),
        MappableKey(name: "UP_ARROW"       , code: "224;72", shift: "224;72", control: "224;141", option: "224;152"),
        MappableKey(name: "PAGE_UP"        , code: "224;73", shift: "224;73", control: "224;132", option: "224;153"),
        MappableKey(name: "LEFT_ARROW"     , code: "224;75", shift: "224;75", control: "224;115", option: "224;155"),
        MappableKey(name: "RIGHT_ARROW"    , code: "224;77", shift: "224;77", control: "224;116", option: "224;157"),
        MappableKey(name: "END"            , code: "224;79", shift: "224;79", control: "224;117", option: "224;159"),
        MappableKey(name: "DOWN_ARROW"     , code: "224;80", shift: "224;80", control: "224;145", option: "224;154"),
        MappableKey(name: "PAGE_DOWN"      , code: "224;81", shift: "224;81", control: "224;118", option: "224;161"),
        MappableKey(name: "INSERT"         , code: "224;82", shift: "224;82", control: "224;146", option: "224;162"),
        MappableKey(name: "DELETE"         , code: "224;83", shift: "224;83", control: "224;147", option: "224;163"),
        MappableKey(name: "PRINT_SCREEN"   , code: ""      , shift: ""      , control: "0;114"  , option: ""),
        MappableKey(name: "PAUSE_BREAK"    , code: ""      , shift: ""      , control: "0;0"    , option: ""),
        MappableKey(name: "BACKSPACE"      , code: "8"     , shift: "8"     , control: "127"    , option: "0"),
        MappableKey(name: "ENTER"          , code: "13"    , shift: ""      , control: "10"     , option: "0"),
        MappableKey(name: "TAB"            , code: "9"     , shift: "0;15"  , control: "0;148"  , option: "0;165"),
        MappableKey(name: "NULL"           , code: "0;3"   , shift: ""      , control: ""       , option: ""),
        MappableKey(name: "A"              , code: "97"    , shift: "65"    , control: "1"      , option: "0;30"),
        MappableKey(name: "B"              , code: "98"    , shift: "66"    , control: "2"      , option: "0;48"),
        MappableKey(name: "C"              , code: "99"    , shift: "67"    , control: "3"      , option: "0;46"),
        MappableKey(name: "D"              , code: "100"   , shift: "68"    , control: "4"      , option: "0;32"),
        MappableKey(name: "E"              , code: "101"   , shift: "69"    , control: "5"      , option: "0;18"),
        MappableKey(name: "F"              , code: "102"   , shift: "70"    , control: "6"      , option: "0;33"),
        MappableKey(name: "G"              , code: "103"   , shift: "71"    , control: "7"      , option: "0;34"),
        MappableKey(name: "H"              , code: "104"   , shift: "72"    , control: "8"      , option: "0;35"),
        MappableKey(name: "I"              , code: "105"   , shift: "73"    , control: "9"      , option: "0;23"),
        MappableKey(name: "J"              , code: "106"   , shift: "74"    , control: "10"     , option: "0;36"),
        MappableKey(name: "K"              , code: "107"   , shift: "75"    , control: "11"     , option: "0;37"),
        MappableKey(name: "L"              , code: "108"   , shift: "76"    , control: "12"     , option: "0;38"),
        MappableKey(name: "M"              , code: "109"   , shift: "77"    , control: "13"     , option: "0;50"),
        MappableKey(name: "N"              , code: "110"   , shift: "78"    , control: "14"     , option: "0;49"),
        MappableKey(name: "O"              , code: "111"   , shift: "79"    , control: "15"     , option: "0;24"),
        MappableKey(name: "P"              , code: "112"   , shift: "80"    , control: "16"     , option: "0;25"),
        MappableKey(name: "Q"              , code: "113"   , shift: "81"    , control: "17"     , option: "0;16"),
        MappableKey(name: "R"              , code: "114"   , shift: "82"    , control: "18"     , option: "0;19"),
        MappableKey(name: "S"              , code: "115"   , shift: "83"    , control: "19"     , option: "0;31"),
        MappableKey(name: "T"              , code: "116"   , shift: "84"    , control: "20"     , option: "0;20"),
        MappableKey(name: "U"              , code: "117"   , shift: "85"    , control: "21"     , option: "0;22"),
        MappableKey(name: "V"              , code: "118"   , shift: "86"    , control: "22"     , option: "0;47"),
        MappableKey(name: "W"              , code: "119"   , shift: "87"    , control: "23"     , option: "0;17"),
        MappableKey(name: "X"              , code: "120"   , shift: "88"    , control: "24"     , option: "0;45"),
        MappableKey(name: "Y"              , code: "121"   , shift: "89"    , control: "25"     , option: "0;21"),
        MappableKey(name: "Z"              , code: "122"   , shift: "90"    , control: "26"     , option: "0;44"),
        MappableKey(name: "1"              , code: "49"    , shift: "33"    , control: ""       , option: "0;120"),
        MappableKey(name: "2"              , code: "50"    , shift: "64"    , control: "0"      , option: "0;121"),
        MappableKey(name: "3"              , code: "51"    , shift: "35"    , control: ""       , option: "0;122"),
        MappableKey(name: "4"              , code: "52"    , shift: "36"    , control: ""       , option: "0;123"),
        MappableKey(name: "5"              , code: "53"    , shift: "37"    , control: ""       , option: "0;124"),
        MappableKey(name: "6"              , code: "54"    , shift: "94"    , control: "30"     , option: "0;125"),
        MappableKey(name: "7"              , code: "55"    , shift: "38"    , control: ""       , option: "0;126"),
        MappableKey(name: "8"              , code: "56"    , shift: "42"    , control: ""       , option: "0;126"),
        MappableKey(name: "9"              , code: "57"    , shift: "40"    , control: ""       , option: "0;127"),
        MappableKey(name: "0"              , code: "48"    , shift: "41"    , control: ""       , option: "0;129"),
        MappableKey(name: "DASH"           , code: "45"    , shift: "95"    , control: "31"     , option: "0;130"),
        MappableKey(name: "EQUAL"          , code: "61"    , shift: "43"    , control: ""       , option: "0;131"),
        MappableKey(name: "SQUAREBRACKET_L", code: "91"    , shift: "123"   , control: "27"     , option: "0;126"),
        MappableKey(name: "SQUAREBRACKER_R", code: "93"    , shift: "125"   , control: "29"     , option: "0;27"),
        MappableKey(name: "EMPTY"          , code: "92"    , shift: "124"   , control: "28"     , option: "0;43"),
        MappableKey(name: "SEMICOLON"      , code: "59"    , shift: "58"    , control: ""       , option: "0;39"),
        MappableKey(name: "APOSTROPHE"     , code: "39"    , shift: "34"    , control: ""       , option: "0;40"),
        MappableKey(name: "COMMA"          , code: "44"    , shift: "60"    , control: ""       , option: "0;51"),
        MappableKey(name: "PERIOD"         , code: "46"    , shift: "62"    , control: ""       , option: "0;52"),
        MappableKey(name: "FORWARD_SLASH"  , code: "47"    , shift: "63"    , control: ""       , option: "0;53"),
        MappableKey(name: "BACKTICK"       , code: "96"    , shift: "126"   , control: ""       , option: "0;41"),
    ]
}
