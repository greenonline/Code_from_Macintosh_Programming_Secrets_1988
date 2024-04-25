#include "Types.r"; 
#include "SysTypes.r"

resource 'MENU' (128){
128,
textMenuProc, 
0x7FFFFFFD, 
enabled, 
apple,
{ /* array: 2 elements */ 
/* [1] */
"About Showoff...", noIcon,  "", "", plain, 
/* [2] */
"-", noIcon, "", "", plain
}
};

resource 'MENU' (129){
129,
textMenuProc, 
0x7FFFFFF7, 
enabled, 
"File",
{ /* array: 5 elements */
/* [1] */
"New", noIcon, "N",   noMark, plain; 
/* [2] */
"Open", noIcon, "0" ,  noMark, plain; 
/* [3] */
"Close", noIcon, "W",  noMark, plain; 
/* [4] */
"-", noIcon, noKey,  noMark, plain; 
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
{ /* array: 6 elements */ 
/* [1] */
"Undo" , noIcon, "Z", "", plain,
/* [2] */
"-", noIcon, "", "", plain,
/* [3] */
"Cut", noIcon, "X", "" , plain, 
/* [4] */
"Copy", noIcon, "C", "" , plain, 
/* [5] */
"Paste", noIcon, "V", "", plain, 
/* [6] */
"Clear", noIcon, "", "", plain
}
};

resource 'MENU' (131){
131,
textMenuProc, 
0x7FFFFFFF, 
enabled, 
"Text",
{  /* array: 3 elements */
/* [1] */
"Font", noIcon, "\0x1B", "\0x84", plain, 
/* [2] */
"Size", noIcon, "\0x1B", "\0x85", plain, 
/* [3] */
"Style", noIcon, "\0x1B", "\0x86", plain
}
};

resource 'MENU' (133) {
133,
textMenuProc, 
0x7FFFFFFF, 
enabled, 
"Size",
{ /* array: 9 elements */
/* [1] */
"9", noIcon, noKey, noMark, plain; 
/* [2] */
"10", noIcon, noKey, noMark, plain;
/* [3] */
"12" , noIcon, noKey, noMark, plain;
/* [4) */
"14" , noIcon, noKey, noMark, plain;
/* [5] */
"18", noIcon, noKey, noMark, plain;
/* [6) */
"24" , noIcon, noKey, noMark, plain;
/* [7] */
"36", noIcon, noKey, noMark, plain;
/* [8] */
"48" , noIcon, noKey, noMark, plain;
/* [9] */
"Other...", noIcon, noKey, noMark, plain
}
};

resource 'MENU' (134){
 134,
textMenuProc, 
0x7FFFFFFF, 
enabled, 
"Style",
{ /* array: 8 elements */ 
/* [1] */
"Plain", noIcon, noKey, noMark, plain; 
/* [21 */
"Bold", noIcon, noKey, noMark, bold; 
/* [3] */
"Italic", noIcon, noKey, noMark, italic;
/* [4] */
"Underline", noIcon, noKey, noMark, underline; 
/* [5] */
"Outline", noIcon, noKey, noMark, outline; 
/* [6J */
"Shadow", noIcon, noKey, noMark, shadow; 
/* [7] */
"Condense", noIcon, noKey, noMark, condense; 
/* [B] */
"Extend", noIcon, noKey, noMark, extend
}
};

resource 'BNDL' (128) { 
'Scot',
0,
{ /* array TypeArray: 2 elements */
/* [1] */
'ICN#',
{ /* array IDArray: 2 elements */
/* [1] */ 
0, 128, 
/* [2] */ 
1, 129
},
/* [2] */
'FREF',
{ /* array IDArray: 2 elements */
/* [1] */ 
0, 128,
/* [2] */ 
1, 129
}
}
};

 resource 'DITL' (1000, "About box") {
{ /* array DITLarray: 2 elements */
/* [1] */
{61, 191, 81, 251}, 
Button {
enabled,
"OK"
},
/* [2] */
{8, 24, 56, 272},
 StaticText {
disabled,
"NewHiyer example program\nby Scott Knaster" 
"\nversion 1. 0 10: 55: 43 PM 6/23/87"
}
}
};

resource 'DLOG' (1000, "About box") { 
{62, 100, 148, 412},
dBoxProc,
visible,
goAway,
0x0,
1000,
"New Dialog"
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
{ /* array: 2 elements */
/* [1] */
$"FFFF FFFF 8000 0005 FD00 0005 9100 0005" 
$"9100 0005 91EF 0005 9129 0005 912F 0005" 
$"9128 0005 912F 0005 8000 0805 8F00 0805" 
$"8880 0805 8898 C905 8F25 2A05 88A5 2C05" 
$"88A5 2A05 8F18 C905 8000 0005 8000 0005" 
$"9000 0005 9000 E485 9001 0505 9001 0605" 
$"9C90 C405 9290 2605 9290 2505 9CF1 C485" 
$"8010 0005 8010 0005 80F0 0005 FFFF FFFF", 
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
$"0900 0220 0900 0210 0900 03F8 0900 0008" 
$"0900 0008 0900 0008 0900 0008 0900 0008" 
$"09F0 0008 0910 0008 0910 0008 0910 0008" 
$"0910 0008 0910 0008 08E0 0008 09F0 0008" 
$"09F0 0008 09F8 0008 09F8 0008 09E8 5FE8" 
$"09F8 0BE8 0800 3FE8 08F0 FFE8 0870 3FE8" 
$"0819 FFE8 0800 0008 0800 0008 0FFF FFF8", 
/* [2] */
$"0FFF FE00 0FFF FF00 0FFF FF80 0FFF FFC0" 
$"0FFF FFE0 0FFF FFF0 0FFF FFF8 0FFF FFF8" 
$"0FFF FFF8 0FFF FFF8 0FFF FFF8 0FFF FFF8" 
$"0FFF FFF8 0FFF FFF8 0FFF FFF8 0FFF FFF8" 
$"0FFF FFF8 0FFF FFF8 0FFF FFF8 0FFF FFF8" 
$"0FFF FFF8 0FFF FFF8 0FFF FFF8 0FFF FFF8" 
$"0FFF FFF8 0FFF FFF8 0FFF FFF8 0FFF FFF8" 
$"0FFF FFF8 0FFF FFF8 0FFF FFF8 0FFF FFF8"
}
};


data 'Scot' (0) {
$"1853 686F 776F 6666 2063 7265 6174 6564"  /* .NewHiyer created */
$"2031 322F 3235 2F38 35"  /* 6/23/87 */
};
