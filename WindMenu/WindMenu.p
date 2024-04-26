program WindMenu;
{Listing 9-1 Example of ultra-fancy window management via menus }
 uses
{$Load Insider:MPW:Pinterfaces:Allinterfaces}
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
  appleID = 128; {resource IDs/menu IDs for Apple, File and Edit menus}
  fileID = 129;
  editID = 130;
  windowID = 131;
  moveDialog = 1001; {DLOG ID for move & resize dialog}
  appleM = 1; {index for each menu in myMenus (array of menu handles)}
  fileM = 2;
  editM = 3;
  windowM = 4;
  menuCount = 4; {total number of menus}
  aboutItem = 1; {item in Apple menu}
  undoItem = 1; {Items in Edit menu}
  cutItem = 3;
  copyItem = 4;
  pasteItem = 5;
  clearitem = 6;

  newitem = 1; {items in File menu}
  closeitem = 3;
  quititem = 5;
  tileitem = 1; {items in Window menu}
  stackitem = 2;
  moveitem = 3;


  wName = 'Window '; {prefix for window names}
  windDX = 25; {distance to move for new windows}
  windDY = 25;
  leftEdge = 10; {initial dimensions of window}
  topEdge = 42;
  rightEdge = 210;
  botEdge = 175;
  firstWinitem = 4; {offset from first item in Window menu to first window}
 var
  myMenus: array[1..menuCount] of MenuHandle; {handles to the menus}
  dragRect: Rect;{rectangle used to mark boundaries for dragging window}
  txRect: Rect; {rectangle for text in application window}
  textH: TEHandle; {handle to Textedit record}
  theChar: char;{typed character}
  extended: boolean; {true if user is Shift-clicking}
  doneFlag: boolean; {true if user has chosen Quit Item}
  myEvent: EventRecord; {information about an event}
  wRecord: WindowRecord;{information about the application window}
  myWindow: WindowPtr; {pointer to wRecord}
  myWinPeek: WindowPeek;  {another pointer to wRecord}
  whichWindow: WindowPtr; {window in which mouse button was pressed}
  nextWRect: Rect; {portRect for next window to be opended}
  nextWTitle: Str255; {title of next window to be opened}
  nextWNum: Longint; {number of next window (for title)}
  savedPort: GrafPtr; {pointer to preserve GrafPort}
  menusOK: boolean; {for disabling menu items}
  windowCount: Integer; {number of open windows}
  itemString: Str255; {item selected from menu}

  switchWindow: WindowPtr; {new window to select)}
  windowName: Str255;  {new window's name}
  curWinName, flipname: Str255;{name of current app. window}
  curWinitem: Integer; {menu item number of current window}
  flipwin: WindowPtr;
  scrapErr: Longint;
  scrCopyErr: Integer;




 procedure SetUpMenus;
{ set up menus and menu bar }
  var
   i: Integer;
 begin
  myMenus[appleM] := GetMenu(appleID); {read Apple menu}
  AddResMenu(myMenus[appleM], 'DRVR'); {add desk accessory names}
  myMenus[fileM] := GetMenu(fileID);  {read file menu }
  myMenus[editM] := GetMenu(editID); {read Edit menu }
  myMenus[windowM] := GetMenu(windowID);

  for i := 1 to menuCount do
   InsertMenu(myMenus[i], 0);  { install menus in menu bar }
  DrawMenuBar; { and draw menu bar}
 end; {SetUpMenus}

 function ItemFromName (theName: str255): Integer;
  var
   itemString: str255;
   whichitem: integer;
 begin
  whichitem := firstWinitem; {start at item no. of dashed line}
  repeat
   whichitem := whichitem + 1;
   Getitem(myMenus[windowM], whichitem, itemString);
  until (itemString = theName) or (whichitem > (windowCount + firstWinitem));
  if whichitem > (windowCount + firstWinitem) then
   ItemFromName := 0
  else
   ItemFromName := whichitem;
 end;
 procedure AddWintoMenu (windowName: Str255);
 begin
  InsMenuitem(myMenus[windowM], windowName, firstWinitem);
 end;
 procedure RemoveWin (theWindow: WindowPtr);
  var
   winName: Str255;
 begin
  GetWTitle(theWindow, winName);
  DelMenuitem(myMenus[windowM], ItemFromName(winName));
 end;

 procedure OpenWindow; { Open a new window }
 begin
  NumToString(nextWNum, nextWTitle); {prepare number for title}
  nextWTitle := concat(wName, nextWTitle); {add to prefix}
  myWindow := NewWindow(nil, nextWRect, nextWTitle, True, noGrowDocProc, Pointer(-1), True, 0); {open the window}
  SetPort(myWindow); {make it the current port}
  txRect := thePort^.portRect;{prepare TERecord for new window}
  InsetRect(txRect, 4, 0);
  textH := TENew(txRect, txRect);
  myWinPeek := WindowPeek(myWindow);
  myWinPeek^.refcon := Longint(textH); {keep TEHandle in refcon}
  OffsetRect(nextWRect, windDX, windDY);{move window down and right}
  if nextWRect.right > dragRect.right then {move back if it's too far over}
   OffsetRect(nextWRect, -nextWRect.left + leftEdge, 0);
  if nextWRect.bottom > dragRect.bottom then
   OffsetRect(nextWRect, 0, -nextWRect.top + topEdge);
  nextWNum := nextWNum + 1;  {bump number for next window}

  menusOK := false;
  Enableitem(myMenus[editM], 0); {in case this is the only window}
  windowCount := windowCount + 1;
  AddWintoMenu(nextWTitle);
 end; {OpenWindow}

 procedure KillWindow (theWindow: WindowPtr); {Close a window and throw everything away}
  var
   winName: str255;
 begin
  RemoveWin(theWindow);
  TEDispose(TEHandle(WindowPeek(theWindow)^.refcon));
{throw away TERecord}
  DisposeWindow(theWindow); {throw away WindowRecord}
  textH := nil; {for TEidle in main event loop}
  if FrontWindow = nil then {if no more windows, disable Close}
   Disableitem(myMenus[fileM], closeitem)
  else
   begin
    theWindow := FrontWindow;
    while (WindowPeek(theWindow)^.windowKind < 0) do
     theWindow := WindowPtr(WindowPeek(theWindow)^.nextWindow);
    GetWTitle(theWindow, winName);
    curWinitem := ItemFromName(winName);
    curWinName := winName;
   end;

  if WindowPeek(FrontWindow)^.windowKind < 0 then
{if a desk ace is coming up, enable undo}
   Enableitem(myMenus[editM], undoitem)
  else
   Disableitem(myMenus[editM], undoitem);
  windowCount := windowCount - 1;
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
    HiliteControl(ControlHandle(theitem), 1);
    Delay(8, finalTicks);
    HiliteControl(ControlHandle(theItem), 0);
    itemHit := 1;
    MyFilter := True;
   end {if BitAnd... then begin}
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

 function NextNoDA (theWindow: windowPeek): windowPeek;
 begin
  if theWindow <> nil then
   while (theWindow^.windowKind < 0) do {weed out DAs}
    theWindow := theWindow^.nextWindow;
  NextNoDA := theWindow;
 end;
 function LastNoDA: windowPeek;
{Finds the rearmost window that's not a DA}
  var
   lastGoodUn: windowPeek;
 begin
  if FrontWindow <> nil then
   begin
    lastGoodUn := NextNoDA(WindowPeek(FrontWindow));
    while NextNoDA(lastGoodUn^.nextWindow) <> nil do
     lastGoodUn := NextNoDA(lastGoodUn^.nextWindow);
   end;
  LastNoDA := lastGoodUn;
 end;
 function numFromitem (theDialog: DialogPtr; itemNo: Integer): Integer;
{Given a dialog item number, return its value as an integer}
  var
   itemType: Integer;
   item: Handle;
   box: Rect;
   theText: Str255;
   theNum: Longint;
 begin
  GetDitem(theDialog, itemNo, itemType, item, box); {get item handle}
  GetIText(item, theText); {get its text}
  StringToNum(theText, theNum);
  numFromitem := theNum;
 end;
 procedure DoWinShuffle (theitem: Integer);
{Handle Stack, T ile, and Move & Resize commands}
  var
   theWindow: WindowPeek;
   mover: WindowPtr;
   nextPos: Point;
   dlogitem: Integer;
   newTop, newLeft, newBot, newRight: Integer;

   theDialog: DialogPtr;
 begin
  case theitem of
   tileitem: 
    ;
   stackitem: 
    begin
     nextPos.h := (((windowCount - 1) * windDX) + leftEdge) mod (screenBits.bounds.right - leftEdge);
     nextPos.v := (((windowCount - 1) * windDY) + topEdge) mod (screenBits.bounds.bottom - leftEdge);
     theWindow := NextNoDA(WindowPeek(FrontWindow));
     while theWindow <> nil do
      begin

       MoveWindow(windowPtr(theWindow), nextPos.h, nextPos.v, false);
       nextPos.h := nextPos.h - windDX;
       nextPos.v := nextPos.v - windDY;
       if nextPos.h < leftEdge then {move back if it's too far over}
       nextPos.h := rightEdge;
       if nextPos.v < topEdge then
       nextPos.v := botEdge;
       theWindow := NextNoDA(theWindow^.nextWindow);
      end;

    end; {case stackitem}
   moveitem: 
    begin
     mover := FrontWindow;
     theDialog := GetNewDialog(moveDialog, nil, pointer(-1));
     repeat
      ModalDialog(@myFilter, dlogitem);
     until (dlogitem = 1) or (dlogitem = 2);
     if dlogitem = 1 then
      begin
       newTop := numFromitem(theDialog, 8);
       newLeft := numFromitem(theDialog, 9);
       newBot := numFromitem(theDialog, 10);
       newRight := numFromitem(theDialog, 11);
       MoveWindow(mover, newLeft, newTop, true);
       SizeWindow(mover, newRight - newLeft, newBot - newTop, true);
      end;
     DisposDialog(theDialog);
    end;
  end {case theitem of}
 end; {procedure DoWinShuffle}


 procedure DoCommand (mResult: LONGINT);
{Execute Item specified by mResult, the result of MenuSelect}
  var
   theitem: Integer; {menu item number from mResult low-order word}
   theMenu: Integer; {menu number from mResult high-order word}
   name: Str255; {desk accessory name}
   temp: Integer;
 begin
  theitem := LoWord(mResult); {call Toolbox Utility routines to set theMenu := HiWord(mResult); {menu item number and menu number}
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
     end; {if theItem ... else begin}

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
      begin
       case theitem of {case on menu item number}
       cutitem: 
       TECut(textH); {call TextEdit to handle Item}
       copyitem: 
       TECopy(textH);
       pasteitem: 
       TEPaste(textH);
       clearItem: 
       TEDelete(textH);
       end; {case theitem}
       scrapErr := ZeroScrap;
       scrCopyErr := TEToScrap;
      end {if not SystemEdit ... begin}
    end; {editID begin}
   windowID: 
    begin
     Getitem(myMenus[windowM], theitem, itemString);
     if theitem < firstWinitem then
      DoWinShuffle(theitem)
     else
      begin
       switchWindow := FrontWindow;
       GetWTitle(switchWindow, windowName);
       while (windowName <> itemString) and (switchWindow <> nil) do
       begin
       switchWindow := WindowPtr(WindowPeek(switchWindow)^.nextWindow);
       GetWTitle(switchWindow, windowName);
       end;
       SelectWindow(switchWindow);
      end; {if theitem < ... else}
    end; {windowID}
  end; {case theMenu}
  HiliteMenu(0);
 end; {DoCommand}

 procedure FixCursor;
  var
   mouseLoc: point;
 begin
  GetMouse(mouseLoc);
  if PtinRect(mouseLoc, thePort^.portRect) then
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
 windowCount := 0;
 curWinitem := 0;
 nextWNum := 1; {initialize window number}
 SetRect(nextWRect, leftEdge, topEdge, rightEdge, botEdge); {initialize window rectangle}
 OpenWindow;  { start with one open window }
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
      else if FrontWindow <> nil then
       TEKey(theChar, textH);
     end;   {keyDown, autoKey begin}
    activateEvt: 
     begin
      if BitAnd(myEvent.modifiers, activeFlag) <> 0 then {application window is becoming active}
       begin
       SetPort(GrafPtr(myEvent.message));
       textH := TEHandle(WindowPeek(myEvent.message)^.refcon);
       TEActivate(textH);

       Enableitem(myMenus[fileM], closeitem);
       Disableitem(myMenus[editM], undoitem);
       scrCopyErr := TEFromScrap;
       if curWinitem <> 0 then


       begin
       Checkitem(myMenus[windowM], ItemFromName(curWinName), false);
       SetitemCmd(myMenus[windowM], ItemFromName(flipname), chr(0));
       end;
       GetWTitle(WindowPtr(myEvent.message), windowName);
       curWinitem := ItemFromName(windowName);
       curWinName := windowName;
       Checkitem(myMenus[windowM], curWinitem, true);
       if windowCount > 1 then
       begin
       flipWin := windowPtr(LastNoDA);
       GetWTitle(flipWin, flipname);
       SetitemCmd(myMenus[windowM], ItemFromName(flipname), 'F');
       end;
       end {if BitAnd .. . thenbegin}
      else {application window is becoming inactive}
       begin
       TEDeactivate(TEHandle(WindowPeek(myEvent.message)^.refcon));
       if WindowPeek(FrontWindow)^.windowKind < 0 then
       Enableitem(myMenus[editM], undoitem)
       else
       DisableItem(myMenus[editM], undoitem);
       end; {else begin}
     end; {activateEvt begin}
    updateEvt: 
     begin
      GetPort(savedPort);
      SetPort(GrafPtr(myEvent.message));
      BeginUpdate(WindowPtr(myEvent.message));
      EraseRect(WindowPtr(myEvent.message)^.portRect);
      TEUpdate(WindowPtr(myEvent.message)^.portRect, TEHandle(WindowPeek(myEvent.message)^.refcon));
      EndUpdate(WindowPtr(myEvent.message));
      SetPort(savedPort);
     end; {updateEvt.begin}
   end; {case myEvent.what}
 until doneFlag;
end.
