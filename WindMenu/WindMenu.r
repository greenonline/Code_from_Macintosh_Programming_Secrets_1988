#include "Types.r"; 
#include "SysTypes.r"


resource 'MENU' (128) {
128,
textMenuProc, 
0x7FFFFFFD, 
enabled, 
apple,
{ /* array: 2 elements */ 
/* [1] */
"About WindMenu ...", noIcon, noKey, noMark, plain; 
/* [2] */
"-", noIcon, noKey, noMark, plain
}
};


resource 'MENU' (129) {
129,
textMenuProc, 
0x7FFFFFF7, 
enabled, 
"File",
{    /* array: 5 elements */
/* [1] */
"New", noIcon, "N", noMark, plain; 
/* [2] */
"Open", noIcon, "0", noMark, plain; 
/* [3J */
"Close", noIcon, "W", noMark, plain; 
/* [4] */
"-", noIcon, noKey, noMark, plain; 
/* [5] */
"Quit", noIcon, "Q", noMark, plain
}
};

resource 'MENU' (130) {
130,
textMenuProc, 
0x7FFFFFFC, 
enabled, 
"Edit",
{    /* array: 6 elements */
/* [1] */
"Undo", noIcon, "Z", noMark, plain;
/* [2] */
"-", noIcon, noKey, noMark, plain;
/* [3] */
"Cut", noIcon, "X", noMark, plain;
/* [4] */
"Copy", noIcon, "C", noMark, plain;
/* [5] */
"Paste", noIcon, "V", noMark, plain; 
/* [6] */
"Clear", noIcon, noKey, noMark, plain
}
};

resource 'MENU' (131) {
 131,
textMenuProc,
0x7FFFFFF7,
enabled,
"Window",
{ "Tile Windows", noIcon, "T", noMark, plain;
"Stack Windows", noIcon, "S", noMark, plain; 
"Move and Resize", noIcon, "M", noMark, plain; 
"-", noIcon, noKey, noMark, plain
} };

resource 'BNDL' (128) { 'Scot',
0,
{  /* array TypeArray: 2 elements */ 
/* [1] */
'ICN#',
{ /* array IDArray: 2 elements */
/* [1] */ 
0, 128;
/* [2] */ 
1, 129
};
/* [2] */
'FREF',
{ /* array IDArray: 2 elements */
/* [1] */ 
0, 128;
/* [2] */ 
1, 129
}
}
};


resource 'DLOG' (1001, "Resize") {
{100, 120, 250, 430}, 
dBoxProc,
visible,
noGoAway, 
0x0,
1001, 
"Move me"
};



resource 'DITL' (1001) {
{ /* array DITLarray: 11 elements */ 
/* [1] */
{110,70,130,125},
Button {
enabled,
"OK"
};
/* [2] */ 
{110,200,130,255}, 
Button {
enabled,
"Cancel" 
};
/* [3] */
{9, 68, 29, 213}, 
StaticText {
disabled,
"New size for window"
},
/* [4] */
{44, 19, 64, 50}, 
StaticText {
disabled,
"top"
},
/* [5] */
{78, 19, 98, 50}, 
StaticText {
disabled,
"left" 
},
/* [6] */
{44, 146, 65, 199}, 
StaticText {
disabled,
"bottom" 
},
/* [7] */
{78, 146, 99, 185}, 
StaticText {
disabled,
"right" 
},
/* [8] */
{44, 59, 64, 119}, 
EditText {
enabled,
""
},
/* [9] */
{78, 59, 98, 119}, 
EditText {
enabled,
""
},
/* [10] */
{44, 204, 64, 264}, 
EditText {
enabled,
""
},
/* [11] */
{80, 204, 100, 264}, 
EditText {
enabled,
""
}
}
};






 resource 'DITL' (1000, "About box") {
{
/* array DITLarray: 2 elements */ /* [1] */
{61, 191, 81, 251},
Button {
enabled,
"OK" 
};
/* [2] */
{8, 24, 56, 272}, 
StaticText {
disabled,
"WindMenu example program\nby Scott Knaster" 
"\nversion 1.0 7/4/87"
}
}
};

resource 'FREF' (128) { 
'APPL',
0, 
""
};

resource 'FREF' (129) { 
'TEXT',
1, 
""
};

resource 'ICN#' (128) {
{  /* array: 2 elements */

/* [1] */
$"FFFF FFFF 8000 0005 F000 0005 9100 0005" 
$"9100 0005 91EF 0005 9129 0005 912F 0005" 
$"9128 0005 912F 0005 8000 0805 BF00 0805" 
$"8880 0805 8898 C905 BF25 2A05 BBA5 2C05" 
$"88A5 2A05 8F18 C905 8000 0005 8000 0005" 
$"9000 0005 9000 E485 9001 0505 9001 0605" 
$"9C90 C405 9290 2605 9290 2505 9CF1 C485" 
$"8010 0005 8010 0005 B0F0 0005 FFFF FFFF"; 
/* [2] */
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF" 
$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
}
};


resource 'ICN#' (129) {
{ /* array: 2 elements */
/* [1] */
$"0FFF FE00 0800 0300 0900 0280 0900 0240" 
$"0900 0220 0900 0210 0900 03FB 0900 0008" 
$"0900 0008 0900 0008 0900 0008 0900 0008" 
$"09F0 0008 0910 0008 0910 0008 0910 0008" 
$"0910 0008 0910 0008 0BED 0008 09F0 0008" 
$"09F0 0008 09F8 0008 09FB 0008 09EB 5FE8" 
$"09FB 0BEB 0800 3FEB 0BF0 FFEB 0870 3FEB" 
$"0819 FFEB 0800 0008 0800 0008 0FFF FFFB"; 
/* [2] */
$"0FFF FE00 0FFF FF00 0FFF FFB0 0FFF FFC0" 
$"0FFF FFE0 0FFF FFF0 0FFF FFFB 0FFF FFFB" 
$"0FFF FFFB 0FFF FFFB 0FFF FFFB 0FFF FFFB" 
$"0FFF FFFB 0FFF FFFB 0FFF FFFB 0FFF FFFB" 
$"0FFF FFFB 0FFF FFFB 0FFF FFFB 0FFF FFFB" 
$"0FFF FFFB 0FFF FFFB 0FFF FFFB 0FFF FFFB" 
$"0FFF FFFB 0FFF FFFB 0FFF FFFB 0FFF FFFB" 
$"0FFF FFFB 0FFF FFFB 0FFF FFFB 0FFF FFFB"
}
};



 data 'Scot' (0) {
$"1853 686F 776F 6666 2063 7265 6174 6564" /* .WindMenu created */
$"2031 322F 3235 2F38 35" /* 7/4/87 */
};
