program Colorit;

{Listing 3-1 Example of old-model color drawing that works with all Macintoshes}

 uses
{$U HD:MPW:Interfaces.p:MemTypes.p}
  MemTypes, 
 {$U HD:MPW:Interfaces.p:QuickDraw.p}
  QuickDraw, 
 {$U HD:MPW:Interfaces.p:OSintf.p }
  OSintf, 
 {$U HD:MPW:Interfaces.p:Toolintf.p }
  Toolintf, 
 {$U HD:MPW:Interfaces.p:Packintf.p }
  Packintf;
 const
  appleID = 128; {resource IDs/menu IDs for Apple, File and Edit menus}
  fileID = 129;
  editID = 130;
  colorID = 131;
  appleM = l; {index for each menu in myMenus (array of menu handles)}
  fileM = 2;
  editM = 3;
  colorM = 4;
  menuCount = 4; {total number of menus}

  aboutitem = l; {item in Apple menu}

  undoItem = l;    {Items in Edit menu}

  cutItem = 3;
  copyItem = 4;
  pasteitem = 5;
  clearitem = 6;


  newitem = 1;
  closeitem = 3;
  quititem = 5;
  blackitem = 1;
  whiteitem = 2;
  reditem = 3;
  greenitem = 4;
  blueitem = 5;
  cyanitem = 6;
  magentaitem = 7;
  yellowitem = 8;
{ items in File menu }
  wName = 'Window ';
{ prefix for window names }
  windDX = 25;
{ distance to move for new windows }
  windDY = 25;
  leftEdge = 10;
{ initial dimensions of window }
  topEdge = 42;
  rightEdge = 210;
  botEdge = 175;

 var
  myMenus: array[1..menuCount] of MenuHandle; {headless to the menus}
  dragRect: Rect; {rectangle used to mark boundaries for dragging window}
  txRect: Rect; {rectangle for text in application window}
  textH: TEHandle; {handle to TextEdit record}
  theChar: char; {typed character}
  extended: boolean; {true if User is shift-clicking}
  doneFlag: boolean; {true if User has chosen Quit item}
  myEvent: EventRecord; {information about an event}
  wRecord: WindowRecord;
{ information about the application window }
  myWindow: WindowPtr;
{ pointer to wRecord }
  myWinPeek: WindowPeek;
{ another pointer to wRecord }
  whichWindow: WindowPtr;
{ window in which mouse button was pressed }
  nextWRect: Rect;
{ portRect for next window to be opended }
  nextWTitle: Str255;
{ title of next window to be opened }
  nextWNum: Longint;
{ number of next window ( for title ) }
  savedPort: GrafPtr;
{ pointer to preserve GrafPort }
  menusOK: boolean;
{ for disabling menu items }
  scrapErr: Longint;
  scrCopyErr: Integer;

 procedure SetUpMenus;
{ set up menus and menu bar }
  var
   i: Integer;

 begin
  myMenus[appleM] := GetMenu(appleID); {read Apple menu}
  AddResMenu(myMenus[appleM], 'DRVR'); {add desk accessory names}
  myMenus[fileM] := GetMenu(fileID);{read file menu }
  myMenus[editM] := GetMenu(editID);{read Edit menu }
  myMenus[colorM] := GetMenu(colorID);


  for i := l to menuCount do
   InsertMenu(myMenus[i], 0); {install menus in menu bar}
  DrawMenuBar; { and draw menu bar}
 end; {SetUpMenus}
 procedure OpenWindow; { Open a new window }
 begin
  NumToString(nextWNum, nextWTitle); {prepare number for title}
  nextWTitle := concat(wName, nextWTitle); {add to prefix}
  myWindow := NewWindow(nil, nextWRect, nextWTitle, True, noGrowDocProc, Pointer(-1), True, 0); {open the window}
  SetPort(myWindow); {make it the current port}
  txRect := thePortA.portRect;{prepare TERecord for new window}
  InsetRect(txRect, 4, 0);
  textH := TENew(txRect, txRect);
  myWinPeek := WindowPeek(myWindow);
  myWinPeekA.refcon := Longint(textH); {keep TEHandle in refcon!}
  OffsetRect(nextWRect, windDX, windDY);{move window down and right}
  if nextWRect.right > dragRect.right then {move back if it's too far over}
   OffsetRect(nextWRect, -hextWRect.left + leftEdge, 0);
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
  if WindowPeek(FrontWindow)^.windowKind < O then
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
 {enter}
   begin
    GetDitem(theDialog, 1, theType, theitem, theBox);
    HiliteControl(ControlHandle(theitem), l);
    Delay(8, finalTicks);
    HiliteControl(ControlHandle(theitem), 0);
    itemHit := l;
    MyFilter := True;
   end {if BitAnd...then begin}
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
  until itemHit = l;
  DisposDialog(myWindow);
 end; {procedure DoAboutBox}
 procedure ColorMe (color: Integer);
 begin
  myWindow := FrontWindow;
  SetPort(myWindow);
  BackColor(color);
  InvalRect(thePortA.portBits.bounds);
 end;
 procedure DoCommand (mResult: LONGINT);
  var
   itemString: STR255;
{ Execute Item specified by mResult , the result of MenuSelect }

  var
   theitem: Integer; {menu item number from mResult low-order word}
   theMenu: Integer; {menu number from mResult high-order word}
   name: Str255; {desk accessory name}
   temp: Integer;
 begin
  theitem := LoWord(mResult); {call Toolbox Utility routines to set}
  theMenu := HiWord(mResult); {menu item number and menu number}
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
     end; {if theitem ... else begin}
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
       TEPaste(textH);
       clearitem: 
       TEDelete(textH);
      end; {case theitem}
    end; {editID begin}
   colorID: 
    begin
     Getitem(myMenus[colorM], theitem, itemString);
     myWindow := FrontWindow;
     SetWTitle(myWindow, itemString);
     case theitem of
      blackitem: 
       ColorMe(blackColor);
      whiteitem: 
       ColorMe(whiteColor);
      reditem: 
       ColorMe(redColor);
      greenitem: 
       ColorMe(greenColor);
      blueitem: 
       ColorMe(blueColor);
      cyanitem: 
       ColorMe(cyanColor);
      magentaitem: 
       ColorMe(magentaColor);
      yellowitem: 
       ColorMe(yellowColor);
     end;
{case theitem }
    end; {colorID begin}
  end; {case theMenu}
  HiliteMenu(O);
  e n d; {DoComrnand}
 procedure FixCursor;
  var
   rnouseLoc: point;
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
 nextWNum := l; {initialize window number}
 SetRect(nextWRect, leftEdge, topEdge, rightEdge, botEdge);
{initialize window rectangle}
 OpenWindow; {start with one open window}

{Main event loop}
 repeat
  SystemTask;
  if FrontWindow <> nil then
   if WindowPeek(FrontWindow)^.windowKind >= O then
    FixCursor;
  if not menusOK and (FrontWindow = nil) then
   begin
    Disableitem(myMenus[fileM], closeitem);
    Disableitem(myMenus[editM], 0);
    menusOK := true;
   end; {if FrontWindow... then begin}
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
      if BitAnd(myEvent.modifiers, activeFlag) <> 0 then
{application window is becoming active}
       begin
       SetPort(GrafPtr(myEvent.message));
       textH := TEHandle(WindowPeek(myEvent.message)^.refcon);
       TEActivate(textH);
       Enableitem(myMenus[fileM], closeitem);
       Disableitem(myMenus[editM], undoitem);
       if WindowPeek(FrontWindow)^.nextWindow^.windowKind < 0 then

       scrCopyErr := TEFromScrap;
       end{if BitAnd...then begin}

      else {application window is becoming inactive}
       begin
       TEDeactivate(TEHandle(WindowPeek(myEvent.message)^.refcon));
       if WindowPeek(FrontWindow)^.windowKind < 0 then
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
     end;
    GetPort(savedPort);
    SetPort(GrafPtr(myEvent.message));
    BeginUpdate(WindowPtr(myEvent.message));
    EraseRect(WindowPtr(myEvent.message)^.portRect);
    TEUpdate(WindowPtr(myEvent.message)^.portRect, TEHandle(WindowPeek(myEvent.message)^.refcon));
    EndUpdate(WindowPtr(myEvent.message));
    SetPort(savedPort);
   end; {updateEvt begin}
 {case myEvent.what}
 until doneFlag;
end.



