program NewHiyer;
{Listing A-1 Example of hierarchical menus and stylish TextEdit}
 uses
{$LOAD Insider:MPW:Pinterfaces:Allinterfaces}
{$U Insider:MPW:Pinterfaces:MemTypes.p }
  MemTypes, 
 {$U Insider:MPW:Pinterfaces:QuickDraw.p}
  QuickDraw, 
 {$U Insider:MPW:Pinterfaces:OSintf.p }
  OSintf, 
 {$U Insider:MPW:Pinterfaces:Toolintf.p }
  Toolintf, 
 {$U Insider:MPW:Pinterfaces:Packintf.p }
  Packintf;


 const
  appleID = 128;  {resource IDs/menu IDs for menus}
  fileID = 129;
  editID = 130;
  textID = 131;

  fontID = 132;
  sizeID = 133;
  styleID = 134;
  appleM = 1;  {index for each menu in myMenus (array of menu handles)}
  fileM = 2;
  editM = 3;
  textM = 4;
  fontM = 5;
  sizeM = 6;
  styleM = 7;
  menuCount = 7; {total number of menus (incl. hierarchical)}
  aboutItem = 1; {item in Apple menu}

  undoItem = 1; {Items in Edit menu}
  cutItem = 3;
  copyItem = 4;
  pasteitem = 5;
  clearitem = 6;

  newitem = 1; {items in File menu}
  closeitem = 3;
  quititem = 5;

  fontitem = 1; {items in Text menu}
  sizeitem = 2;
  styleitm = 3;

  wName = 'Window '; {prefix for window names}
  windDX = 25;
  windDY = 25;
  leftEdge = 10;
  topEdge = 42;
  rightEdge = 210;
  botEdge = 175;
{distance to move for new windows}
{initial dimensions of window}
 var
  myMenus: array[1..menuCount] of MenuHandle; {handles to the menu}
  dragRect: Rect;{rectangle used to mark boundaries for dragging window}
  txRect: Rect;{rectangle for text in application window}
  textH: TEHandle;{handle to T extedit record}
  theChar: char;{typed character}
  extended: boolean;{true if user is Shift-clicking}
  doneFlag: boolean;{true if user has chosen Quit Item}
  myEvent: EventRecord; {information about an event}
  wRecord: WindowRecord; {information about the application window}


  myWindow: WindowPtr; {pointer to wRecord}
  myWinPeek: WindowPeek;{another pointer to wRecord}
  whichWindow: WindowPtr;{window in which mouse button was pressed}
  nextWRect: Rect; {portRect for next window to be opended}
  nextWTitle: Str255; {title of next window to be opened}
  nextWNum: Longint; {number of next window (for title)}
  savedPort: GrafPtr; {pointer to preserve GrafPort}
  menusOK: boolean; {for disabling menu items}
  scrapErr: LongInt;
  scrCopyErr: Integer;
  theStyle: TextStyle; {for setting TE style}
  itemString: Str255; {font name selected}
  familyID: Integer; {for setting font ID}
  fontSize: Longint; {for setting font size}



 procedure SetUpMenus;
{ set up menus and menu bar }
  var
   i: Integer;
 begin
  myMenus[appleM] := GetMenu(appleID);{read Apple menu}
  AddResMenu(myMenus[appleM], 'DRVR'); {add desk accessory names}
  myMenus[fileM] := GetMenu(fileID); {read file menu}
  myMenus[editM] := GetMenu(editID); {read Edit menu}
  myMenus[textM] := GetMenu(textID);
  myMenus[fontM] := NewMenu(fontID, 'Font');
  AddResMenu(myMenus[5], 'FONT');
  myMenus[sizeM] := GetMenu(sizeID);
  myMenus[styleM] := GetMenu(styleID);

  for i := 1 to 4 do
   InsertMenu(myMenus[i], 0); {install menus in menu bar}

  InsertMenu(myMenus[fontM], -1);  {install hierarchical menus}
  InsertMenu(myMenus[sizeM], -1);
  InsertMenu(myMenus[styleM], -1);
  DrawMenuBar; { and draw menu bar}
 end; {SetUpMenus}
 procedure OpenWindow; { Open a new window }
 begin
  NumToString(nextWNum, nextWTitle); {prepare number for title}
  nextWTitle := concat(wName, nextWTitle); {add to prefix}
  myWindow := NewWindow(nil, nextWRect, nextWTitle, True, noGrowDocProc, Pointer(-1), True, 0); {open the window}
  SetPort(myWindow);
{make it the current port}
  txRect := thePortA.portRect;{prepare TERecord for new window}

  InsetRect(txRect, 4, 0);
  textH := TEStylNew(txRect, txRect);
  theStyle.tsSize := 12;
  TESetSelect(0, 32767, textH);
  TESetStyle(doSize, theStyle, true, textH);
  myWinPeek := WindowPeek(myWindow);
  myWinPeekA.refcon := Longint(textH);
{ keep TEHandle in refcon !}
  OffsetRect(nextWRect, windDX, windDY);{move window down and right}
  if nextWRect.right > dragRect.right then {move back if it's too far over}
   OffsetRect(nextWRect, -nextWRect.left + leftEdge, 0);
  if nextWRect.bottom > dragRect.bottom then
   OffsetRect(nextWRect, 0, -nextWRect.top + topEdge);
  nextWNum := nextWNum + l; {bump number for next window}
  menusOK := false;
  Enableitem(myMenus[editM], 0); {in case this is the only window}
 end; {OpenWindow}
 procedure KillWindow (theWindow: WindowPtr); {Close a window and throw everything away}
 begin
  TEDispose(TEHandle(WindowPeek(theWindow)^.refcon));
{throw away TERecord}
  DisposeWindow(theWindow); {throw away WindowRecord}
  textH := nil; {for TEidle in main event loop}
  if FrontWindow = nil then {if no more windows, disable Close}
   Disableitem(myMenus[fileM], closeitem);
  if WindowPeek(FrontWindow)^.windowKind < 0 then
{if a desk ace is coming up, enable undo}
   Enableitem(myMenus[editM], undoitem)
  else
   Disableitem(myMenus[editM], undoitem);
 end; {KillWindow}
 function MyFilter (theDialog: DialogPtr; var theEvent: EventRecord; var itemHit: Integer): Boolean;
  var
   theType: Integer;
   theitem: Handle;
   theBox: Rect;
   finalTicks: Longint;
 begin
  if (BitAnd(theEvent.message, charCodeMask) = 13) or (BitAnd(theEvent.message, charCodeMask) = 3) then {carriage return}
{ enter }
   begin
    GetDitem(theDialog, 1, theType, theitem, theBox);
    HiliteControl(ControlHandle(theitem), 1);
    Delay(8, finalTicks);
    HiliteControl(ControlHandle(theitem), 0);
    itemHit := 1;
    MyFilter := True;
   end { if BitAnd .. . then     begin}
  else
   MyFilter := False;
 end; {function MyFilter}
 procedure DoAboutBox;
  var
   itemHit: Integer;
 begin
  myWindow := GetNewDialog(1000, nil, pointer(-1));
  repeat
   ModalDialog(@MyFilter, itemHit)
  until itemHit = 1;
  DisposDialog(myWindow);
 end; {procedure DoAboutBox}

 procedure MakeStyle (theitem: integer; var theStyle: TextStyle);
 begin
  with theStyle do
   case theitem of
    1: 
     tsFace := [];
    2: 
     tsFace := [bold];
    3: 
     tsFace := [italic];
    4: 
     tsFace := [underline];
    5: 
     tsFace := [outline];
    6: 
     tsFace := [shadow];
    7: 
     tsFace := [condense];
    8: 
     tsFace := [extend];
   end; {case theitem}
 end; {procedure MakeStyle}

 procedure DoCommand (mResult: LONGINT);
{Execute Item specified by mResult, the result of MenuSelect}
  var
   theitem: Integer; {menu item number from mResult low-order word}
   theMenu: Integer; {menu number from mResult high-order word}
   name: Str255; {desk accessory name}
   temp: Integer;

 begin
  theitem := LoWord(mResult); {call Toolbox Utility routines to set theMenu ·= HiWord(mResult); {menu item number and menu number}
  case theMenu of {case on menu ID}
   appleID: 
    if theitem = aboutitem then
     DoAboutBox
    else

     begin
      Getitem(myMenus[appleM], theitem, name); {GetPort (savedPort);}
      scrapErr := ZeroScrap;
      scrCopyErr := TEToScrap;
      temp := OpenDeskAcc(name);
      Enableitem(myMenus[editM], 0); {SetPort (savedPort);}
      if FrontWindow <> nil then
       begin
       Enableitem(myMenus[fileM], closeitem);
       Enableitem(myMenus[editM], undoitem);
       end; {if FrontWindow then begin}
      menusOK := false;
     end; {if theitem...else begin}
   fileID: 
    case theitem of
     newitem: 
      OpenWindow;
     closeitem: 
      if WindowPeek(FrontWindow)^.windowKind < 0 then
       CloseDeskAcc(windowPeek(FrontWindow)^.windowKind) {if desk ace window, close it}
      else
       KillWindow(FrontWindow);
{if it's one of mine, blow it away}
     quitItem: 
      doneFlag := TRUE; {quit}
    end; {case theitem}
   editID: 
    begin
     if not SystemEdit(theitem - 1) then
      case theitem of {case on menu item number}
       cutitem: 
       TECut(textH); {call TextEdit to handle Item}

       copyitem: 
       TECopy(textH);
       pasteitem: 
       TEStylPaste(textH);
       clearitem: 
       TEDelete(textH);
      end; {case theitem}
    end; {editID begin}
   fontID: 
    begin
     Getitem(myMenus[fontM], theitem, itemString);
     GetFNum(itemString, familyID);
     theStyle.tsFont := familyID;
{theStyle.tsSize := 12; {fix to set right size}
     TESetStyle(doFont + doSize, theStyle, true, textH);
    end; {fontID: begin}
   sizeID: 
    begin
     Getitem(myMenus[sizeM], theitem, itemString);
     StringToNum(itemString, fontSize);
     theStyle.tsSize := fontSize;
     TESetStyle(doSize, theStyle, true, textH);
    end; {sizeID: begin}
   styleID: 
    begin
     MakeStyle(theitem, theStyle);
     TESetStyle(doFace + doSize, theStyle, true, textH);
    end; {sizeID: begin}
  end; {case theMenu}
  HiliteMenu(0);
 end; {DoConunand}
 procedure FixCursor;
  var
   mouseLoc: point;
 begin
  GetMouse(mouseLoc);
  if PtinRect(mouseLoc, thePortA.portRect) then
   SetCursor(GetCursor(iBeamCursor)^^)
  else
   SetCursor(arrow);
 end; {procedure FixCursor}

begin {main program}
 InitGraf(@thePort);
 InitFonts;
 FlushEvents(everyEvent, 0);
 InitWindows;
 InitMenus;
 TEinit;
 InitDialogs(nil);
 InitCursor;
 SetUpMenus;
 with screenBits.bounds do
  SetRect(dragRect, 4, 24, right - 4, bottom - 4);
 doneFlag := false;
 menusOK := false;
 nextWNum := 1;
{initialize window number}
 SetRect(nextWRect, leftEdge, topEdge, rightEdge, botEdge);
{initialize window rectangle}
 OpenWindow; {start with one open window}
{Main event loop}
 repeat
  SystemTask;
  if FrontWindow <> nil then
   if WindowPeek(FrontWindow)^.windowKind >= 0 then
    FixCursor;
  if not menusOK and (FrontWindow = nil) then
   begin
    Disableitem(myMenus[fileM], closeitem);
    Disableitem(myMenus[editM], 0);
    menusOK := true;
   end; {if FrontWindow...then begin}
  if textH <> nil then
   TEidle(textH);
  if GetNextEvent(everyEvent, myEvent) then
   case myEvent.what of
    mouseDown: 
     case FindWindow(myEvent.where, whichWindow) of
      inSysWindow: 
       SystemClick(myEvent, whichWindow);
      inMenuBar: 
       DoCommand(MenuSelect(myEvent.where));
      inDrag: 
       DragWindow(whichWindow, myEvent.where, dragRect);

      inContent: 
       begin
       if whichWindow <> FrontWindow then
       SelectWindow(whichWindow)
       else
       begin
       GlobalToLocal(myEvent.where);
       extended := BitAnd(myEvent.modifiers, shiftKey) <> 0;
       TEClick(myEvent.where, extended, textH);
       end; {else}
       end; {inContent}
      inGoAway: 
       if TrackGoAway(whichWindow, myEvent.where) then
       KillWindow(whichWindow);
     end; {case FindWindow}

    keyDown, autoKey: 
     begin
      theChar := CHR(BitAnd(myEvent.message, charCodeMask));
      if BitAnd(myEvent.modifiers, cmdKey) <> 0 then
       DoCommand(MenuKey(theChar))
      else
       TEKey(theChar, textH);
     end; {keyDown, autoKey begin}
    activateEvt: 
     begin
      if BitAnd(myEvent.modifiers, activeFlag) <> 0 then {application window is becoming active}
       begin
       SetPort(GrafPtr(myEvent.message));
       textH := TEHandle(WindowPeek(myEvent.message)^.refcon);
       TEActivate(textH);
       Enableitem(myMenus[fileM], closeitem);
       Disableitem(myMenus[editM], undoitem);
       if WindowPeek(FrontWindow)^.nextWindowA.windowKind < O then
       scrCopyErr := TEFromScrap;
       end {if BitAnd... then begin}
      else {application window is becoming inactive}
       begin
       TEDeactivate(TEHandle(WindowPeek(myEvent.message)^.refcon));
       if WindowPeek(FrontWindow)^.windowKind < O then
       begin
       Enableitem(myMenus[editM], undoitem);
       scrapErr := ZeroScrap;
       scrCopyErr := TEToScrap;
       end {if WindowPeek ... then begin}
       else
       Disableitem(myMenus[editM], undoitem);
       end; {else begin}
     end; {activateEvt begin}

    updateEvt: 
     begin
      GetPort(savedPort);
      SetPort(GrafPtr(rnyEvent.rnessage));
      BeginUpdate(WindowPtr(rnyEvent.rnessage));
      EraseRect(WindowPtr(rnyEvent.rnessage)^.portRect);
      TEUpdate(WindowPtr(rnyEvent.rnessage)^.portRect, TEHandle(WindowPeek(rnyEvent.rnessage)^.refcon));
      EndUpdate(WindowPtr(rnyEvent.rnessage));
      SetPort(savedPort);
     end; {updateEvt begin}
   end; {case rnyEvent.what}
 until doneFlag;
end.
