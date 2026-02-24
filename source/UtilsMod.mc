using Toybox.Lang;

// Useful functions which are not provided by the default garmin modules

module UtilsMod{

    // returns the (decimal) ascii code of the given character
    function toAsciiCode(char as Lang.String) as Lang.Number{
        var AsciiTable = [
        "0", "0", "0", "0", "0", "0", "0", "0", 
        "0", "0", "0", "0", "0", "0", "0", "0", 
        "0", "0", "0", "0", "0", "0", "0", "0", 
        "0", "0", "0", "0", "0", "0", "0", "0",
        " ", "!", "\"", "#", "$", "%", "&", "'", 
        "(", ")", "*", "+", ",", "-", ".", "/",
        "0", "1", "2", "3", "4", "5", "6", "7", 
        "8", "9", ":", ";", "<", "=", ">", "?",
        "@", "A", "B", "C", "D", "E", "F", "G", 
        "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", 
        "X", "Y", "Z", "[", "\\", "]", "^", "_",
        "`", "a", "b", "c", "d", "e", "f", "g", 
        "h", "i", "j", "k", "l", "m", "n", "o",
        "p", "q", "r", "s", "t", "u", "v", "w", 
        "x", "y", "z", "{", "|", "}", "~", "0"
        ];
        
        char.substring(0, 0);

        return AsciiTable.indexOf(char) as Lang.Number;
    }

    // returns the character with the given ascii code (decimal)
    function toAsciiString(code as Lang.Number) as Lang.String{
        var AsciiTable = [
        "0", "0", "0", "0", "0", "0", "0", "0", 
        "0", "0", "0", "0", "0", "0", "0", "0", 
        "0", "0", "0", "0", "0", "0", "0", "0", 
        "0", "0", "0", "0", "0", "0", "0", "0",
        " ", "!", "\"", "#", "$", "%", "&", "'", 
        "(", ")", "*", "+", ",", "-", ".", "/",
        "0", "1", "2", "3", "4", "5", "6", "7", 
        "8", "9", ":", ";", "<", "=", ">", "?",
        "@", "A", "B", "C", "D", "E", "F", "G", 
        "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", 
        "X", "Y", "Z", "[", "\\", "]", "^", "_",
        "`", "a", "b", "c", "d", "e", "f", "g", 
        "h", "i", "j", "k", "l", "m", "n", "o",
        "p", "q", "r", "s", "t", "u", "v", "w", 
        "x", "y", "z", "{", "|", "}", "~", "0"
        ];
        return AsciiTable[code] as Lang.String;
    }

}