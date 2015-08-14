library PyMinMod;

{

  Minimal Python module (library) that includes simple functions.

  Author: Phil (MacPgmr at fastermac.net).

  To compile this module:
    - With Delphi: Open this .dpr file and compile.
    - With Lazarus: Open .lpi file and compile.

  To deploy module:
    - With Delphi: Rename compiled .dll to .pyd.
    - With Lazarus on Windows: Rename compiled .so to .pyd.
    - With Lazarus on OS X and Linux: .so extension is okay.

}

uses
  Interfaces,
  Classes,
  SysUtils,
  PyAPI,
  Forms,
  Controls,
  StdCtrls,
  objectlistunit,
  callbacunit,
  lfmunit,
  TpyTedUnit,
  TpyTbuttonUnit,
  TpylabelUnit,
  TMemopyunit,
  TButtonpyunit,
  TCheckBoxpyunit,
  TComboBoxpyunit,
  TEditpyunit,
  TFormpyunit,
  TLabelpyunit,
  TListBoxpyunit,
  TMainMenupyunit,
  TMenuItempyunit,
  TPopupMenupyunit,
  TRadioButtonpyunit,
  TScrollBarpyunit,
  TToggleBoxpyunit,
  regallUnit,
  reginterfaceunit,
  ObjserUnit,
  Dialogs,Menus,pyutil;

  function SumTwoIntegers(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Arg1: integer;
    Arg2: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @Arg1, @Arg2);  //Get the two int arguments
    Result := PyInt_FromLong(Arg1 + Arg2);  //Add them together and return sum
    //  Result := PyLong_FromLong(Arg1 + Arg2);
    //  Result := PyLong_FromUnsignedLong(Arg1 + Arg2);
  end;


  function ConcatTwoStrings(Self: PyObject; Args: PyObject): PyObject; cdecl;
 {From Python documentation for "s" format: "You must not provide storage for
   the string itself; a pointer to an existing string is stored into the
   character pointer variable whose address you pass."
  From Python documentation for PyString_FromString: "Return a new string
   object with a copy of the string v as value on success".}
  var
    Arg1: PAnsiChar;
    Arg2: PAnsiChar;
  begin
    PyArg_ParseTuple(Args, 'ss', @Arg1, @Arg2);  //Get the two string arguments
    Result := PyString_FromString(PAnsiChar(ansistring(Arg1) + ansistring(Arg2)));
    //Concatenate and return string
  end;


var
  Methods: packed array [0..800] of PyMethodDef;
  laz4pyobj: Tlaz4py;
  numofcall: integer;

  function Create_Form(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Reference: Pointer;
    hashnum, prehash: integer;
  begin
    Application.Initialize;
    Application.CreateForm(TForm, Reference);
    //hashnum := laz4pyobj.add_obj(Reference);
    hashnum := integer(Pointer(Reference));
    Result := PyInt_FromLong(hashnum);
  end;

  function Create_FormLfm(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Reference: Pointer;
    hashnum, prehash: integer;
    Arg1,Arg2: PChar;
    rsredeader: Tlfmreader;
    f: TForm;
    pstr:String;
  begin
    Application.Initialize;
    PyArg_ParseTuple(Args, 'ss', @Arg1,@Arg2);
    rsredeader := Tlfmreader.Create(f,StrPas(Arg1));
    rsredeader.readlfm(f, StrPas(Arg1));
    pstr:=rsredeader.setcompnentpointer(f,StrPas(Arg2));
    f.Show;
    //Application.CreateForm(TForm, Reference);
    //hashnum := laz4pyobj.add_obj(Reference);
    StrPCopy(arg1,pstr);
    rsredeader.free;
    Result :=PyString_FromString(Arg1);
  end;

  function Application_Run(Self: PyObject; Args: PyObject): PyObject; cdecl;
  begin
    Application.Run;
    Result := PyInt_FromLong(0);
  end;

  function Create_Label(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var

    Reference: Pointer;
    hashnum: integer;
    formhashnum: integer;
    form: TForm;
    lab: TLabel;
    //cal: Tcallbac;
  begin
    PyArg_ParseTuple(Args, 'i', @formhashnum);
    form := TForm(formhashnum);
    lab := TLabel.Create(form);
    lab.Parent := form;
    //lab.Visible := True;
    //cal := Tcallbac.Create;
    // button.OnClick := cal.onclick;
    Result := PyInt_FromLong(integer(Pointer(lab)));
  end;

  function Create_Button(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var

    Reference: Pointer;
    hashnum: integer;
    formhashnum: integer;
    form: TForm;
    button: TButton;
    //cal: Tcallbac;
  begin
    PyArg_ParseTuple(Args, 'i', @formhashnum);
    form := TForm(formhashnum);
    button := TButton.Create(form);
    button.Parent := form;
    button.Visible := True;
    //cal := Tcallbac.Create;
    // button.OnClick := cal.onclick;
    Result := PyInt_FromLong(integer(Pointer(button)));
  end;

  function SetOnClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    temp, arg, pyresult: PyObject;
    call: Tcallbac;
    targetBut, iscall: integer;
    but: TButton;
  begin
    temp := nil;
    if (PyArg_ParseTuple(args, 'Oi', @temp, @targetBut) > 0) then
    begin
      PyCallable_Check(temp);
      call := Tcallbac.Create;
      Py_IncRef(temp);         // Add a reference to new callback */
      {Py_XDECREF(call.pyfun);  }// Dispose of previous callback */
      call.pyfun := temp;
      //targetBut:=1;
      but := TButton(targetBut);
      but.OnClick := call.click;
      // arg := Py_BuildValue('');
      //pyresult := PyObject_CallObject(temp, arg);
      //iscall:=PyCallable_Check(temp);
    end;
    Result := PyInt_FromLong(integer(pyresult));
  end;

  function Control_SetOnClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    temp: ^PyObject;
    call: Tcallbac;
  begin
    if (PyArg_ParseTuple(args, 'O:set_callback', @temp) > 0) then
    begin
      call := Tcallbac.Create;
      Py_XINCREF(temp);         // Add a reference to new callback */
      Py_XDECREF(call.pyfun);  // Dispose of previous callback */
      call.pyfun := temp;       // Remember new callback */
      // Boilerplate to return "None" */
      //Py_INCREF(Py_None);
    end;
    Result := Py_BuildValue('');
  end;

  function Set_Caption(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    Arg1: PAnsiChar;
    control_hash: integer;
    control: TControl;
  begin
    PyArg_ParseTuple(Args, 'is', @control_hash, @Arg1);  //Get the two string arguments
    control := TControl(control_hash);
    control.Caption := Arg1;
    Result := PyString_FromString(PAnsiChar(ansistring(Arg1)));
  end;

  function Set_Top(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control_hash, top: integer;
    control: TControl;
    F: TextFile;
  begin
   { AssignFile(F, 'G:\dev\laz4py\laz4py3\o.txt');
    Rewrite(F);
    numofcall := numofcall + 1;
    WriteLn(F, IntToStr(numofcall));
    CloseFile(F);    }
    PyArg_ParseTuple(Args, 'ii', @control_hash, @top);  //Get the two string arguments
    control := TControl(control_hash);
    control.Top := top;
    Result := PyInt_FromLong(top);
  end;
  //auto gen
  function Set_HelpContext(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    para, control_hash: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.HelpContext := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Tag(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Tag := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Cursor(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Cursor := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Left(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Left := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Height(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := laz4pyobj.get_obj(control_hash);
    control.Height := para;
    Result := PyInt_FromLong(para);
  end;

  function Set_Width(Self: PyObject; Args: PyObject): PyObject; cdecl;
  var
    control: TControl;
    control_hash, para: integer;
  begin
    PyArg_ParseTuple(Args, 'ii', @control_hash, @para);
    control := TControl(control_hash);
    control.Width := para;
    Result := PyInt_FromLong(para);
  end;

  procedure Teditinteface(var k: integer);
  var
    pyedit: Tpyedit;
    inter: Treginterface;
  begin
    regall(k, Methods);
    //pyedit:=Tpyedit.create(Nil);
    //pyedit.reg(k,Methods);
    //inter := TFormpy.Create(nil);
  end;

function TWinControlgetBoundsLockCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).BoundsLockCount);
end;
function TWinControlgetCachedClientHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).CachedClientHeight);
end;
function TWinControlgetCachedClientWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).CachedClientWidth);
end;
function TWinControlgetControlCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).ControlCount);
end;
function TWinControlgetControls(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TWinControl(Pointer(control_p)).Controls[Integer(para50)])));
end;
function TWinControlgetDockClientCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).DockClientCount);
end;
function TWinControlgetDockClients(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TWinControl(Pointer(control_p)).DockClients[Integer(para50)])));
end;
function TWinControlsetDockSite(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DockSite:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlgetDockSite(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).DockSite));
end;
function TWinControlsetDoubleBuffered(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DoubleBuffered:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlgetDoubleBuffered(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).DoubleBuffered));
end;
function TWinControlgetIsResizing(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).IsResizing));
end;
function TWinControlsetTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).TabStop:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlgetTabStop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).TabStop));
end;
function TWinControlgetShowing(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).Showing));
end;
function TWinControlsetDesignerDeleting(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DesignerDeleting:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TWinControlgetDesignerDeleting(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).DesignerDeleting));
end;
function TWinControlAutoSizeDelayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).AutoSizeDelayed));
end;
function TWinControlAutoSizeDelayedReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TWinControl(Pointer(control_p)).AutoSizeDelayedReport));
end;
function TWinControlAutoSizeDelayedHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).AutoSizeDelayedHandle));
end;
function TWinControlBeginUpdateBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).BeginUpdateBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlEndUpdateBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).EndUpdateBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlLockRealizeBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).LockRealizeBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlUnlockRealizeBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).UnlockRealizeBounds();
Result := PyInt_FromLong(0);
end;
function TWinControlContainsControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).ContainsControl(TControl(para50))));
end;
function TWinControlDoAdjustClientRectChange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).DoAdjustClientRectChange(Boolean(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlInvalidateClientRectCache(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).InvalidateClientRectCache(boolean(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlClientRectNeedsInterfaceUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).ClientRectNeedsInterfaceUpdate));
end;
function TWinControlSetBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TWinControl(Pointer(control_p)).SetBounds(integer(para47),integer(para48),integer(para49),integer(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlDisableAlign(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).DisableAlign();
Result := PyInt_FromLong(0);
end;
function TWinControlEnableAlign(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).EnableAlign();
Result := PyInt_FromLong(0);
end;
function TWinControlReAlign(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).ReAlign();
Result := PyInt_FromLong(0);
end;
function TWinControlScrollBy(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TWinControl(Pointer(control_p)).ScrollBy(Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlWriteLayoutDebugReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TWinControl(Pointer(control_p)).WriteLayoutDebugReport(StrPas(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlCanFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).CanFocus));
end;
function TWinControlGetControlIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).GetControlIndex(TControl(para50)));
end;
function TWinControlSetControlIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:TControl;
para50:integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TWinControl(Pointer(control_p)).SetControlIndex(TControl(para49),integer(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlFocused(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).Focused));
end;
function TWinControlPerformTab(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).PerformTab(boolean(para50))));
end;
function TWinControlFindChildControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TWinControl(Pointer(control_p)).FindChildControl(StrPas(para50)))));
end;
{function TWinControlBroadCast(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).BroadCast();
Result := PyInt_FromLong(0);
end;
function TWinControlDefaultHandler(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).DefaultHandler();
Result := PyInt_FromLong(0);
end;           }
function TWinControlGetTextLen(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TWinControl(Pointer(control_p)).GetTextLen);
end;
function TWinControlInvalidate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).Invalidate();
Result := PyInt_FromLong(0);
end;
function TWinControlAddControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).AddControl();
Result := PyInt_FromLong(0);
end;
function TWinControlInsertControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).InsertControl(TControl(para50));
Result := PyInt_FromLong(0);
end;
{
function TWinControlInsertControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:TControl;
para50:integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TWinControl(Pointer(control_p)).InsertControl(TControl(para49),integer(para50));
Result := PyInt_FromLong(0);
end;}
function TWinControlRepaint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).Repaint();
Result := PyInt_FromLong(0);
end;
function TWinControlUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).Update();
Result := PyInt_FromLong(0);
end;
function TWinControlSetFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).SetFocus();
Result := PyInt_FromLong(0);
end;
function TWinControlFlipChildren(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).FlipChildren(Boolean(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlScaleBy(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TWinControl(Pointer(control_p)).ScaleBy(Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlGetDockCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyString_FromString(PChar(TWinControl(Pointer(control_p)).GetDockCaption(TControl(para50))));
end;
function TWinControlUpdateDockCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TWinControl(Pointer(control_p)).UpdateDockCaption(TControl(para50));
Result := PyInt_FromLong(0);
end;
function TWinControlHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).HandleAllocated));
end;
function TWinControlParentHandlesAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).ParentHandlesAllocated));
end;
function TWinControlHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TWinControl(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TWinControlBrushCreated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TWinControl(Pointer(control_p)).BrushCreated));
end;
function TWinControlIntfGetDropFilesTarget(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TWinControl(Pointer(control_p)).IntfGetDropFilesTarget)));
end;
function TStringsAdd(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).Add(StrPas(para50)));
end;
function TStringsAddObject(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:PChar;
para50:TObject;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'isi',@control_p,@para49,@para50);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).AddObject(StrPas(para49),TObject(para50)));
end;
function TStringsAppend(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TStrings(Pointer(control_p)).Append(StrPas(para50));
Result := PyInt_FromLong(0);
end;
function TStringsAddStrings(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TStrings;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TStrings(Pointer(control_p)).AddStrings(TStrings(para50));
Result := PyInt_FromLong(0);
end;
function TStringsBeginUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TStrings(Pointer(control_p)).BeginUpdate();
Result := PyInt_FromLong(0);
end;
function TStringsClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TStrings(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TStringsDelete(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TStrings(Pointer(control_p)).Delete(Integer(para50));
Result := PyInt_FromLong(0);
end;
function TStringsEndUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TStrings(Pointer(control_p)).EndUpdate();
Result := PyInt_FromLong(0);
end;
function TStringsEquals(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TObject;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TStrings(Pointer(control_p)).Equals(TObject(para50))));
end;
{function TStringsEquals(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TStrings;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TStrings(Pointer(control_p)).Equals(TStrings(para50))));
end;}
function TStringsExchange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).Exchange(Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TStringsIndexOf(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).IndexOf(StrPas(para50)));
end;
function TStringsIndexOfName(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).IndexOfName(StrPas(para50)));
end;
function TStringsIndexOfObject(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TObject;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).IndexOfObject(TObject(para50)));
end;
function TStringsInsert(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iis',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).Insert(Integer(para49),StrPas(para50));
Result := PyInt_FromLong(0);
end;
function TStringsLoadFromFile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TStrings(Pointer(control_p)).LoadFromFile(StrPas(para50));
Result := PyInt_FromLong(0);
end;
function TStringsMove(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).Move(Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TStringsSaveToFile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TStrings(Pointer(control_p)).SaveToFile(StrPas(para50));
Result := PyInt_FromLong(0);
end;
{function TStringsGetNameValue(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para48:Integer;
para49:PChar;
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiss',@control_p,@para48,@para49,@para50);
TStrings(Pointer(control_p)).GetNameValue(Integer(para48),StrPas(para49),StrPas(para50));
Result := PyInt_FromLong(0);
end;        }
function TStringssetValueFromIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iis',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).ValueFromIndex[Integer(para49)]:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetValueFromIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyString_FromString(PChar(TStrings(Pointer(control_p)).ValueFromIndex[Integer(para50)]));
end;
function TStringssetCapacity(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TStrings(Pointer(control_p)).Capacity:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetCapacity(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).Capacity);
end;
function TStringssetCommaText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TStrings(Pointer(control_p)).CommaText:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetCommaText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TStrings(Pointer(control_p)).CommaText));
end;
function TStringsgetCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TStrings(Pointer(control_p)).Count);
end;
function TStringsgetNames(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyString_FromString(PChar(TStrings(Pointer(control_p)).Names[Integer(para50)]));
end;
function TStringssetObjects(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:TObject;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).Objects[Integer(para49)]:=TObject(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetObjects(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TStrings(Pointer(control_p)).Objects[Integer(para50)])));
end;
function TStringssetValues(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:PChar;
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iss',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).Values[StrPas(para49)]:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetValues(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyString_FromString(PChar(TStrings(Pointer(control_p)).Values[StrPas(para50)]));
end;
function TStringssetStrings(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iis',@control_p,@para49,@para50);
TStrings(Pointer(control_p)).Strings[Integer(para49)]:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetStrings(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyString_FromString(PChar(TStrings(Pointer(control_p)).Strings[Integer(para50)]));
end;
function TStringssetText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TStrings(Pointer(control_p)).Text:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TStringsgetText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TStrings;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TStrings(Pointer(control_p)).Text));
end;
function TScrollingWinControlUpdateScrollbars(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TScrollingWinControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TScrollingWinControl(Pointer(control_p)).UpdateScrollbars();
Result := PyInt_FromLong(0);
end;
function TPopupMenuPopUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TPopupMenu(Pointer(control_p)).PopUp();
Result := PyInt_FromLong(0);
end;
{function TPopupMenuPopUp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TPopupMenu(Pointer(control_p)).PopUp(Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;         }
function TPopupMenusetPopupComponent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TPopupMenu(Pointer(control_p)).PopupComponent:=TComponent(para50);
Result := PyInt_FromLong(0);
end;
function TPopupMenugetPopupComponent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TPopupMenu(Pointer(control_p)).PopupComponent)));
end;
function TPopupMenusetAutoPopup(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TPopupMenu(Pointer(control_p)).AutoPopup:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TPopupMenugetAutoPopup(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TPopupMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TPopupMenu(Pointer(control_p)).AutoPopup));
end;
{function TObjectCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TObject.Create(TComponent(para50)))));
end;
function TObjectClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TObject(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TObjectSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TObject(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TObjectClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TObject(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TObjectCopyToClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TObject(Pointer(control_p)).CopyToClipboard();
Result := PyInt_FromLong(0);
end;
function TObjectCutToClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TObject(Pointer(control_p)).CutToClipboard();
Result := PyInt_FromLong(0);
end;
function TObjectPasteFromClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TObject(Pointer(control_p)).PasteFromClipboard();
Result := PyInt_FromLong(0);
end;
function TObjectgetCanUndo(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TObject(Pointer(control_p)).CanUndo));
end;
function TObjectsetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).HideSelection:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TObject(Pointer(control_p)).HideSelection));
end;
function TObjectsetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).MaxLength:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TObject(Pointer(control_p)).MaxLength);
end;
function TObjectsetModified(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).Modified:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetModified(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TObject(Pointer(control_p)).Modified));
end;
function TObjectsetNumbersOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).NumbersOnly:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetNumbersOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TObject(Pointer(control_p)).NumbersOnly));
end;
function TObjectsetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).ReadOnly:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TObject(Pointer(control_p)).ReadOnly));
end;
function TObjectsetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).SelLength:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TObject(Pointer(control_p)).SelLength);
end;
function TObjectsetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TObject(Pointer(control_p)).SelStart:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TObject(Pointer(control_p)).SelStart);
end;
function TObjectsetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TObject(Pointer(control_p)).SelText:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TObjectgetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TObject;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TObject(Pointer(control_p)).SelText));
end;          }
function TMenuItemFind(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TMenuItem(Pointer(control_p)).Find(StrPas(para50)))));
end;
function TMenuItemGetParentComponent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TMenuItem(Pointer(control_p)).GetParentComponent)));
end;
function TMenuItemGetParentMenu(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TMenuItem(Pointer(control_p)).GetParentMenu)));
end;
function TMenuItemGetIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).GetIsRightToLeft));
end;
function TMenuItemHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HandleAllocated));
end;
function TMenuItemHasIcon(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HasIcon));
end;
function TMenuItemHasParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HasParent));
end;
function TMenuItemInitiateAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).InitiateAction();
Result := PyInt_FromLong(0);
end;
function TMenuItemIntfDoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).IntfDoSelect();
Result := PyInt_FromLong(0);
end;
function TMenuItemIndexOf(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TMenuItem;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).IndexOf(TMenuItem(para50)));
end;
function TMenuItemIndexOfCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).IndexOfCaption(StrPas(para50)));
end;
function TMenuItemVisibleIndexOf(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TMenuItem;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).VisibleIndexOf(TMenuItem(para50)));
end;
function TMenuItemAdd(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TMenuItem;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).Add(TMenuItem(para50));
Result := PyInt_FromLong(0);
end;
function TMenuItemAddSeparator(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).AddSeparator();
Result := PyInt_FromLong(0);
end;
function TMenuItemClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).Click();
Result := PyInt_FromLong(0);
end;
function TMenuItemDelete(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).Delete(Integer(para50));
Result := PyInt_FromLong(0);
end;
function TMenuItemHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TMenuItemInsert(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:TMenuItem;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TMenuItem(Pointer(control_p)).Insert(Integer(para49),TMenuItem(para50));
Result := PyInt_FromLong(0);
end;
function TMenuItemRecreateHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).RecreateHandle();
Result := PyInt_FromLong(0);
end;
function TMenuItemRemove(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TMenuItem;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).Remove(TMenuItem(para50));
Result := PyInt_FromLong(0);
end;
function TMenuItemIsCheckItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).IsCheckItem));
end;
function TMenuItemIsLine(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).IsLine));
end;
function TMenuItemIsInMenuBar(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).IsInMenuBar));
end;
function TMenuItemClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenuItem(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TMenuItemHasBitmap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).HasBitmap));
end;
function TMenuItemRemoveAllHandlersOfObject(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TObject;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).RemoveAllHandlersOfObject(TObject(para50));
Result := PyInt_FromLong(0);
end;
function TMenuItemgetCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).Count);
end;
function TMenuItemgetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TMenuItem(Pointer(control_p)).Items[Integer(para50)])));
end;
function TMenuItemsetMenuIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).MenuIndex:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TMenuItemgetMenuIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).MenuIndex);
end;
function TMenuItemgetMenu(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TMenuItem(Pointer(control_p)).Menu)));
end;
function TMenuItemgetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TMenuItem(Pointer(control_p)).Parent)));
end;
function TMenuItemMenuVisibleIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMenuItem(Pointer(control_p)).MenuVisibleIndex);
end;
function TMenuItemsetAutoCheck(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).AutoCheck:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TMenuItemgetAutoCheck(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).AutoCheck));
end;
function TMenuItemsetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).Default:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TMenuItemgetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).Default));
end;
function TMenuItemsetRadioItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).RadioItem:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TMenuItemgetRadioItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).RadioItem));
end;
function TMenuItemsetRightJustify(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenuItem(Pointer(control_p)).RightJustify:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TMenuItemgetRightJustify(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenuItem;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenuItem(Pointer(control_p)).RightJustify));
end;
function TMenuDestroyHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenu(Pointer(control_p)).DestroyHandle();
Result := PyInt_FromLong(0);
end;
function TMenuHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).HandleAllocated));
end;
function TMenuIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).IsRightToLeft));
end;
function TMenuUseRightToLeftAlignment(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).UseRightToLeftAlignment));
end;
function TMenuUseRightToLeftReading(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).UseRightToLeftReading));
end;
function TMenuHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TMenu(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TMenusetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenu(Pointer(control_p)).Parent:=TComponent(para50);
Result := PyInt_FromLong(0);
end;
function TMenugetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TMenu(Pointer(control_p)).Parent)));
end;
function TMenusetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TMenu(Pointer(control_p)).ParentBidiMode:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TMenugetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TMenu(Pointer(control_p)).ParentBidiMode));
end;
function TMenugetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TMenu(Pointer(control_p)).Items)));
end;
function TMainMenuCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TMainMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TMainMenu.Create(TComponent(para50)))));
end;
function TMainMenugetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TMainMenu;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TMainMenu(Pointer(control_p)).Height);
end;
{function TLCLComponentDestroyHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TLCLComponent(Pointer(control_p)).DestroyHandle();
Result := PyInt_FromLong(0);
end;
function TLCLComponentHandleAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).HandleAllocated));
end;
function TLCLComponentIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).IsRightToLeft));
end;
function TLCLComponentUseRightToLeftAlignment(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).UseRightToLeftAlignment));
end;
function TLCLComponentUseRightToLeftReading(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).UseRightToLeftReading));
end;
function TLCLComponentHandleNeeded(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TLCLComponent(Pointer(control_p)).HandleNeeded();
Result := PyInt_FromLong(0);
end;
function TLCLComponentsetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TLCLComponent(Pointer(control_p)).Parent:=TComponent(para50);
Result := PyInt_FromLong(0);
end;
function TLCLComponentgetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TLCLComponent(Pointer(control_p)).Parent)));
end;
function TLCLComponentsetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TLCLComponent(Pointer(control_p)).ParentBidiMode:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TLCLComponentgetParentBidiMode(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TLCLComponent(Pointer(control_p)).ParentBidiMode));
end;
function TLCLComponentgetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TLCLComponent;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TLCLComponent(Pointer(control_p)).Items)));
end;            }
function TFormCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TForm.Create(TComponent(para50)))));
end;
function TFormTile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TForm(Pointer(control_p)).Tile();
Result := PyInt_FromLong(0);
end;
function TFormsetLCLVersion(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TForm(Pointer(control_p)).LCLVersion:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TFormgetLCLVersion(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TForm(Pointer(control_p)).LCLVersion));
end;
function TCustomScrollBarCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TCustomScrollBar.Create(TComponent(para50)))));
end;
function TCustomScrollBarSetParams(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:Integer;
para48:Integer;
para49:Integer;
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TCustomScrollBar(Pointer(control_p)).SetParams(Integer(para47),Integer(para48),Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TCustomScrollBarsetMax(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).Max:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetMax(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).Max);
end;
function TCustomScrollBarsetMin(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).Min:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetMin(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).Min);
end;
function TCustomScrollBarsetPageSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).PageSize:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetPageSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).PageSize);
end;
function TCustomScrollBarsetPosition(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomScrollBar(Pointer(control_p)).Position:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomScrollBargetPosition(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomScrollBar;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomScrollBar(Pointer(control_p)).Position);
end;
function TCustomMemosetLines(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TStrings;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).Lines:=TStrings(para50);
Result := PyInt_FromLong(0);
end;
function TCustomMemogetLines(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomMemo(Pointer(control_p)).Lines)));
end;
function TCustomMemosetWantReturns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).WantReturns:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomMemogetWantReturns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomMemo(Pointer(control_p)).WantReturns));
end;
function TCustomMemosetWantTabs(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).WantTabs:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomMemogetWantTabs(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomMemo(Pointer(control_p)).WantTabs));
end;
function TCustomMemosetWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomMemo(Pointer(control_p)).WordWrap:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomMemogetWordWrap(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomMemo;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomMemo(Pointer(control_p)).WordWrap));
end;
function TCustomListBoxAddItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:PChar;
para50:TObject;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'isi',@control_p,@para49,@para50);
TCustomListBox(Pointer(control_p)).AddItem(StrPas(para49),TObject(para50));
Result := PyInt_FromLong(0);
end;
function TCustomListBoxClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).Click();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxGetIndexAtXY(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:integer;
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).GetIndexAtXY(integer(para49),integer(para50)));
end;
function TCustomListBoxGetIndexAtY(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).GetIndexAtY(integer(para50)));
end;
function TCustomListBoxGetSelectedText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TCustomListBox(Pointer(control_p)).GetSelectedText));
end;
function TCustomListBoxItemVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).ItemVisible(Integer(para50))));
end;
function TCustomListBoxItemFullyVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).ItemFullyVisible(Integer(para50))));
end;
function TCustomListBoxLockSelectionChange(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).LockSelectionChange();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxMakeCurrentVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).MakeCurrentVisible();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxMeasureItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Integer;
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TCustomListBox(Pointer(control_p)).MeasureItem(Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TCustomListBoxSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomListBox(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TCustomListBoxsetColumns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).Columns:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetColumns(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).Columns);
end;
function TCustomListBoxgetCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).Count);
end;
function TCustomListBoxsetExtendedSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ExtendedSelect:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetExtendedSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).ExtendedSelect));
end;
function TCustomListBoxsetIntegralHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).IntegralHeight:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetIntegralHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).IntegralHeight));
end;
function TCustomListBoxsetItemHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ItemHeight:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetItemHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).ItemHeight);
end;
function TCustomListBoxsetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ItemIndex:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).ItemIndex);
end;
function TCustomListBoxsetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TStrings;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).Items:=TStrings(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomListBox(Pointer(control_p)).Items)));
end;
function TCustomListBoxsetMultiSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).MultiSelect:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetMultiSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).MultiSelect));
end;
function TCustomListBoxsetScrollWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).ScrollWidth:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetScrollWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).ScrollWidth);
end;
function TCustomListBoxgetSelCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).SelCount);
end;
function TCustomListBoxsetSelected(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:integer;
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TCustomListBox(Pointer(control_p)).Selected[integer(para49)]:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetSelected(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).Selected[integer(para50)]));
end;
function TCustomListBoxsetSorted(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:boolean;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).Sorted:=boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetSorted(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomListBox(Pointer(control_p)).Sorted));
end;
function TCustomListBoxsetTopIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomListBox(Pointer(control_p)).TopIndex:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomListBoxgetTopIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomListBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomListBox(Pointer(control_p)).TopIndex);
end;
function TCustomLabelCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TCustomLabel.Create(TComponent(para50)))));
end;
function TCustomLabelColorIsStored(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomLabel(Pointer(control_p)).ColorIsStored));
end;
function TCustomLabelAdjustFontForOptimalFill(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomLabel(Pointer(control_p)).AdjustFontForOptimalFill));
end;
function TCustomLabelPaint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomLabel(Pointer(control_p)).Paint();
Result := PyInt_FromLong(0);
end;
function TCustomLabelSetBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TCustomLabel;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TCustomLabel(Pointer(control_p)).SetBounds(integer(para47),integer(para48),integer(para49),integer(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormAfterConstruction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).AfterConstruction();
Result := PyInt_FromLong(0);
end;
function TCustomFormBeforeDestruction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).BeforeDestruction();
Result := PyInt_FromLong(0);
end;
function TCustomFormClose(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Close();
Result := PyInt_FromLong(0);
end;
function TCustomFormCloseQuery(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).CloseQuery));
end;
function TCustomFormDefocusControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:TWinControl;
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TCustomForm(Pointer(control_p)).DefocusControl(TWinControl(para49),Boolean(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormDestroyWnd(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).DestroyWnd();
Result := PyInt_FromLong(0);
end;
function TCustomFormEnsureVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).EnsureVisible(Boolean(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormFocusControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TWinControl;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).FocusControl(TWinControl(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormFormIsUpdating(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).FormIsUpdating));
end;
function TCustomFormHide(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Hide();
Result := PyInt_FromLong(0);
end;
function TCustomFormIntfHelp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).IntfHelp(TComponent(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormAutoSizeDelayedHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).AutoSizeDelayedHandle));
end;
function TCustomFormRelease(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Release();
Result := PyInt_FromLong(0);
end;
function TCustomFormCanFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).CanFocus));
end;
function TCustomFormSetFocus(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).SetFocus();
Result := PyInt_FromLong(0);
end;
function TCustomFormSetFocusedControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TWinControl;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).SetFocusedControl(TWinControl(para50))));
end;
function TCustomFormSetRestoredBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TCustomForm(Pointer(control_p)).SetRestoredBounds(integer(para47),integer(para48),integer(para49),integer(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormShow(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).Show();
Result := PyInt_FromLong(0);
end;
function TCustomFormShowModal(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).ShowModal);
end;
function TCustomFormShowOnTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomForm(Pointer(control_p)).ShowOnTop();
Result := PyInt_FromLong(0);
end;
function TCustomFormRemoveAllHandlersOfObject(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TObject;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).RemoveAllHandlersOfObject(TObject(para50));
Result := PyInt_FromLong(0);
end;
function TCustomFormActiveMDIChild(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).ActiveMDIChild)));
end;
function TCustomFormGetMDIChildren(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).GetMDIChildren(Integer(para50)))));
end;
function TCustomFormMDIChildCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).MDIChildCount);
end;
function TCustomFormgetActive(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).Active));
end;
function TCustomFormsetActiveControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TWinControl;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).ActiveControl:=TWinControl(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetActiveControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).ActiveControl)));
end;
function TCustomFormsetActiveDefaultControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).ActiveDefaultControl:=TControl(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetActiveDefaultControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).ActiveDefaultControl)));
end;
function TCustomFormsetAllowDropFiles(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).AllowDropFiles:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetAllowDropFiles(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).AllowDropFiles));
end;
function TCustomFormsetAlphaBlend(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).AlphaBlend:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetAlphaBlend(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).AlphaBlend));
end;
function TCustomFormsetCancelControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).CancelControl:=TControl(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetCancelControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).CancelControl)));
end;
function TCustomFormsetDefaultControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).DefaultControl:=TControl(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetDefaultControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).DefaultControl)));
end;
function TCustomFormsetDesignTimeDPI(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).DesignTimeDPI:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetDesignTimeDPI(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).DesignTimeDPI);
end;
function TCustomFormsetHelpFile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TCustomForm(Pointer(control_p)).HelpFile:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetHelpFile(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TCustomForm(Pointer(control_p)).HelpFile));
end;
function TCustomFormsetKeyPreview(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).KeyPreview:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetKeyPreview(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomForm(Pointer(control_p)).KeyPreview));
end;
{function TCustomFormgetMDIChildren(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).MDIChildren[Integer(para50)])));
end;    }
function TCustomFormsetMenu(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TMainMenu;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).Menu:=TMainMenu(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetMenu(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).Menu)));
end;
function TCustomFormsetPopupParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TCustomForm;
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomForm(Pointer(control_p)).PopupParent:=TCustomForm(para50);
Result := PyInt_FromLong(0);
end;
function TCustomFormgetPopupParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomForm(Pointer(control_p)).PopupParent)));
end;
function TCustomFormgetRestoredLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredLeft);
end;
function TCustomFormgetRestoredTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredTop);
end;
function TCustomFormgetRestoredWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredWidth);
end;
function TCustomFormgetRestoredHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomForm;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomForm(Pointer(control_p)).RestoredHeight);
end;
function TCustomEditCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TCustomEdit.Create(TComponent(para50)))));
end;
function TCustomEditClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TCustomEditSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TCustomEditClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TCustomEditCopyToClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).CopyToClipboard();
Result := PyInt_FromLong(0);
end;
function TCustomEditCutToClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).CutToClipboard();
Result := PyInt_FromLong(0);
end;
function TCustomEditPasteFromClipboard(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomEdit(Pointer(control_p)).PasteFromClipboard();
Result := PyInt_FromLong(0);
end;
function TCustomEditgetCanUndo(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).CanUndo));
end;
function TCustomEditsetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).HideSelection:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetHideSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).HideSelection));
end;
function TCustomEditsetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).MaxLength:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetMaxLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomEdit(Pointer(control_p)).MaxLength);
end;
function TCustomEditsetModified(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).Modified:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetModified(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).Modified));
end;
function TCustomEditsetNumbersOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).NumbersOnly:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetNumbersOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).NumbersOnly));
end;
function TCustomEditsetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).ReadOnly:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomEdit(Pointer(control_p)).ReadOnly));
end;
function TCustomEditsetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).SelLength:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomEdit(Pointer(control_p)).SelLength);
end;
function TCustomEditsetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomEdit(Pointer(control_p)).SelStart:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomEdit(Pointer(control_p)).SelStart);
end;
function TCustomEditsetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TCustomEdit(Pointer(control_p)).SelText:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TCustomEditgetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomEdit;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TCustomEdit(Pointer(control_p)).SelText));
end;
function TCustomComboBoxIntfGetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).IntfGetItems();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxAddItem(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:PChar;
para50:TObject;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'isi',@control_p,@para49,@para50);
TCustomComboBox(Pointer(control_p)).AddItem(StrPas(para49),TObject(para50));
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxClear(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).Clear();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxClearSelection(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).ClearSelection();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxsetDroppedDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).DroppedDown:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetDroppedDown(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).DroppedDown));
end;
function TCustomComboBoxSelectAll(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomComboBox(Pointer(control_p)).SelectAll();
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxsetAutoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).AutoSelect:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetAutoSelect(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).AutoSelect));
end;
function TCustomComboBoxsetAutoSelected(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).AutoSelected:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetAutoSelected(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).AutoSelected));
end;
function TCustomComboBoxsetDropDownCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).DropDownCount:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetDropDownCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).DropDownCount);
end;
function TCustomComboBoxsetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TStrings;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).Items:=TStrings(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetItems(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TCustomComboBox(Pointer(control_p)).Items)));
end;
function TCustomComboBoxsetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).ItemIndex:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetItemIndex(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).ItemIndex);
end;
function TCustomComboBoxsetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).ReadOnly:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetReadOnly(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomComboBox(Pointer(control_p)).ReadOnly));
end;
function TCustomComboBoxsetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).SelLength:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetSelLength(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).SelLength);
end;
function TCustomComboBoxsetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).SelStart:=integer(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetSelStart(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TCustomComboBox(Pointer(control_p)).SelStart);
end;
function TCustomComboBoxsetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TCustomComboBox(Pointer(control_p)).SelText:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TCustomComboBoxgetSelText(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomComboBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TCustomComboBox(Pointer(control_p)).SelText));
end;
function TCustomCheckBoxsetAllowGrayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomCheckBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomCheckBox(Pointer(control_p)).AllowGrayed:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomCheckBoxgetAllowGrayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomCheckBox;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomCheckBox(Pointer(control_p)).AllowGrayed));
end;
function TCustomButtonCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TCustomButton.Create(TComponent(para50)))));
end;
function TCustomButtonClick(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).Click();
Result := PyInt_FromLong(0);
end;
function TCustomButtonExecuteDefaultAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).ExecuteDefaultAction();
Result := PyInt_FromLong(0);
end;
function TCustomButtonExecuteCancelAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).ExecuteCancelAction();
Result := PyInt_FromLong(0);
end;
function TCustomButtonActiveDefaultControlChanged(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomButton(Pointer(control_p)).ActiveDefaultControlChanged(TControl(para50));
Result := PyInt_FromLong(0);
end;
function TCustomButtonUpdateRolesForForm(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TCustomButton(Pointer(control_p)).UpdateRolesForForm();
Result := PyInt_FromLong(0);
end;
function TCustomButtongetActive(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomButton(Pointer(control_p)).Active));
end;
function TCustomButtonsetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomButton(Pointer(control_p)).Default:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomButtongetDefault(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomButton(Pointer(control_p)).Default));
end;
function TCustomButtonsetCancel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TCustomButton(Pointer(control_p)).Cancel:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TCustomButtongetCancel(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TCustomButton;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TCustomButton(Pointer(control_p)).Cancel));
end;
function TControlDragDrop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para48:TObject;
para49:Integer;
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiii',@control_p,@para48,@para49,@para50);
TControl(Pointer(control_p)).DragDrop(TObject(para48),Integer(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TControlAdjustSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).AdjustSize();
Result := PyInt_FromLong(0);
end;
function TControlAutoSizeDelayed(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).AutoSizeDelayed));
end;
function TControlAutoSizeDelayedReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TControl(Pointer(control_p)).AutoSizeDelayedReport));
end;
function TControlAutoSizeDelayedHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).AutoSizeDelayedHandle));
end;
function TControlAnchorHorizontalCenterTo(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).AnchorHorizontalCenterTo(TControl(para50));
Result := PyInt_FromLong(0);
end;
function TControlAnchorVerticalCenterTo(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).AnchorVerticalCenterTo(TControl(para50));
Result := PyInt_FromLong(0);
end;
function TControlAnchorClient(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).AnchorClient(Integer(para50));
Result := PyInt_FromLong(0);
end;
function TControlAnchoredControlCount(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).AnchoredControlCount);
end;
function TControlgetAnchoredControls(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TControl(Pointer(control_p)).AnchoredControls[integer(para50)])));
end;
function TControlSetBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TControl(Pointer(control_p)).SetBounds(integer(para47),integer(para48),integer(para49),integer(para50));
Result := PyInt_FromLong(0);
end;
function TControlSetInitialBounds(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para47:integer;
para48:integer;
para49:integer;
para50:integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iiiii',@control_p,@para47,@para48,@para49,@para50);
TControl(Pointer(control_p)).SetInitialBounds(integer(para47),integer(para48),integer(para49),integer(para50));
Result := PyInt_FromLong(0);
end;
function TControlGetDefaultWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).GetDefaultWidth);
end;
function TControlGetDefaultHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).GetDefaultHeight);
end;
function TControlCNPreferredSizeChanged(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).CNPreferredSizeChanged();
Result := PyInt_FromLong(0);
end;
function TControlInvalidatePreferredSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).InvalidatePreferredSize();
Result := PyInt_FromLong(0);
end;
function TControlWriteLayoutDebugReport(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).WriteLayoutDebugReport(StrPas(para50));
Result := PyInt_FromLong(0);
end;
function TControlShouldAutoAdjustLeftAndTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ShouldAutoAdjustLeftAndTop));
end;
function TControlBeforeDestruction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).BeforeDestruction();
Result := PyInt_FromLong(0);
end;
function TControlEditingDone(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).EditingDone();
Result := PyInt_FromLong(0);
end;
function TControlExecuteDefaultAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).ExecuteDefaultAction();
Result := PyInt_FromLong(0);
end;
function TControlExecuteCancelAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).ExecuteCancelAction();
Result := PyInt_FromLong(0);
end;
function TControlBeginDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para49:Boolean;
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'iii',@control_p,@para49,@para50);
TControl(Pointer(control_p)).BeginDrag(Boolean(para49),Integer(para50));
Result := PyInt_FromLong(0);
end;
function TControlEndDrag(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).EndDrag(Boolean(para50));
Result := PyInt_FromLong(0);
end;
function TControlBringToFront(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).BringToFront();
Result := PyInt_FromLong(0);
end;
function TControlHasParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).HasParent));
end;
function TControlGetParentComponent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TControl(Pointer(control_p)).GetParentComponent)));
end;
function TControlIsParentOf(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsParentOf(TControl(para50))));
end;
function TControlGetTopParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TControl(Pointer(control_p)).GetTopParent)));
end;
function TControlIsVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsVisible));
end;
function TControlIsControlVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsControlVisible));
end;
function TControlIsEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsEnabled));
end;
function TControlIsParentColor(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsParentColor));
end;
function TControlIsParentFont(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsParentFont));
end;
function TControlFormIsUpdating(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).FormIsUpdating));
end;
function TControlIsProcessingPaintMsg(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsProcessingPaintMsg));
end;
function TControlHide(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Hide();
Result := PyInt_FromLong(0);
end;
function TControlRefresh(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Refresh();
Result := PyInt_FromLong(0);
end;
function TControlRepaint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Repaint();
Result := PyInt_FromLong(0);
end;
function TControlInvalidate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Invalidate();
Result := PyInt_FromLong(0);
end;
function TControlCheckNewParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TWinControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).CheckNewParent(TWinControl(para50));
Result := PyInt_FromLong(0);
end;
function TControlSendToBack(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).SendToBack();
Result := PyInt_FromLong(0);
end;
function TControlUpdateRolesForForm(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).UpdateRolesForForm();
Result := PyInt_FromLong(0);
end;
function TControlActiveDefaultControlChanged(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ActiveDefaultControlChanged(TControl(para50));
Result := PyInt_FromLong(0);
end;
function TControlGetTextLen(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).GetTextLen);
end;
function TControlShow(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Show();
Result := PyInt_FromLong(0);
end;
function TControlUpdate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).Update();
Result := PyInt_FromLong(0);
end;
function TControlHandleObjectShouldBeVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).HandleObjectShouldBeVisible));
end;
function TControlParentDestroyingHandle(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ParentDestroyingHandle));
end;
function TControlParentHandlesAllocated(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ParentHandlesAllocated));
end;
function TControlInitiateAction(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).InitiateAction();
Result := PyInt_FromLong(0);
end;
function TControlShowHelp(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
TControl(Pointer(control_p)).ShowHelp();
Result := PyInt_FromLong(0);
end;
function TControlRemoveAllHandlersOfObject(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TObject;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).RemoveAllHandlersOfObject(TObject(para50));
Result := PyInt_FromLong(0);
end;
function TControlsetAccessibleDescription(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).AccessibleDescription:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetAccessibleDescription(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TControl(Pointer(control_p)).AccessibleDescription));
end;
function TControlsetAccessibleValue(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).AccessibleValue:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetAccessibleValue(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TControl(Pointer(control_p)).AccessibleValue));
end;
function TControlsetAutoSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).AutoSize:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetAutoSize(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).AutoSize));
end;
function TControlsetCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).Caption:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetCaption(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TControl(Pointer(control_p)).Caption));
end;
function TControlsetClientHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ClientHeight:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetClientHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).ClientHeight);
end;
function TControlsetClientWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ClientWidth:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetClientWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).ClientWidth);
end;
function TControlsetEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Enabled:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetEnabled(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).Enabled));
end;
function TControlsetIsControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).IsControl:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetIsControl(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsControl));
end;
function TControlgetMouseEntered(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).MouseEntered));
end;
function TControlsetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TWinControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Parent:=TWinControl(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetParent(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TControl(Pointer(control_p)).Parent)));
end;
function TControlsetPopupMenu(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TPopupmenu;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).PopupMenu:=TPopupmenu(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetPopupMenu(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TControl(Pointer(control_p)).PopupMenu)));
end;
function TControlsetShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).ShowHint:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetShowHint(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).ShowHint));
end;
function TControlsetVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Boolean;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Visible:=Boolean(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetVisible(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).Visible));
end;
function TControlgetFloating(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).Floating));
end;
function TControlsetHostDockSite(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TWinControl;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).HostDockSite:=TWinControl(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetHostDockSite(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(Integer(Pointer(TControl(Pointer(control_p)).HostDockSite)));
end;
function TControlsetLRDockWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).LRDockWidth:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetLRDockWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).LRDockWidth);
end;
function TControlsetTBDockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).TBDockHeight:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetTBDockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).TBDockHeight);
end;
function TControlsetUndockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).UndockHeight:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetUndockHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).UndockHeight);
end;
function TControlUseRightToLeftAlignment(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).UseRightToLeftAlignment));
end;
function TControlUseRightToLeftReading(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).UseRightToLeftReading));
end;
function TControlUseRightToLeftScrollBar(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).UseRightToLeftScrollBar));
end;
function TControlIsRightToLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(booltoint(TControl(Pointer(control_p)).IsRightToLeft));
end;
function TControlsetLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Left:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetLeft(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Left);
end;
function TControlsetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Height:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetHeight(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Height);
end;
function TControlsetTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Top:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetTop(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Top);
end;
function TControlsetWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:Integer;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
TControl(Pointer(control_p)).Width:=Integer(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetWidth(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyInt_FromLong(TControl(Pointer(control_p)).Width);
end;
function TControlsetHelpKeyword(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:PChar;
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'is',@control_p,@para50);
TControl(Pointer(control_p)).HelpKeyword:=StrPas(para50);
Result := PyInt_FromLong(0);
end;
function TControlgetHelpKeyword(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
control :TControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'i',@control_p);
Result := PyString_FromString(PChar(TControl(Pointer(control_p)).HelpKeyword));
end;
function TButtonControlCreate(Self: PyObject; Args: PyObject): PyObject; cdecl;
var
para50:TComponent;
control :TButtonControl;
control_p:integer;
begin
PyArg_ParseTuple(Args, 'ii',@control_p,@para50);
Result := PyInt_FromLong(Integer(Pointer(TButtonControl.Create(TComponent(para50)))));
end;

  procedure initPyMinMod; cdecl;
  var
    k: integer;
  begin
    Methods[0].Name := 'SumTwoIntegers';
    Methods[0].meth := @SumTwoIntegers;
    Methods[0].flags := METH_VARARGS;
    Methods[0].doc := 'Tests passing ints to and from module function';

    Methods[1].Name := 'ConcatTwoStrings';
    Methods[1].meth := @ConcatTwoStrings;
    Methods[1].flags := METH_VARARGS;
    Methods[1].doc := 'Tests passing strings to and from module function';

    Methods[2].Name := 'Create_Form';
    Methods[2].meth := @Create_Form;
    Methods[2].flags := METH_VARARGS;
    Methods[2].doc := 'creat form';

    Methods[3].Name := 'Create_Button';
    Methods[3].meth := @Create_Button;
    Methods[3].flags := METH_VARARGS;
    Methods[3].doc := 'creat form';

    Methods[4].Name := 'Application_Run';
    Methods[4].meth := @Application_Run;
    Methods[4].flags := METH_VARARGS;
    Methods[4].doc := 'application run';

    Methods[5].Name := 'Set_Caption';
    Methods[5].meth := @Set_Caption;
    Methods[5].flags := METH_VARARGS;
    Methods[5].doc := 'Set Caption';

    Methods[6].Name := 'SetOnClick';
    Methods[6].meth := @SetOnClick;
    Methods[6].flags := METH_VARARGS;
    Methods[6].doc := 'Control SetOnClick';

    Methods[7].Name := 'Set_Caption';
    Methods[7].meth := @Set_Caption;
    Methods[7].flags := METH_VARARGS;
    Methods[7].doc := 'SetCaption';

    Methods[7].Name := 'Set_Top';
    Methods[7].meth := @Set_Top;
    Methods[7].flags := METH_VARARGS;
    Methods[7].doc := 'SetCaption';
    k := 7;
    Inc(k);
    Methods[k].Name := 'setTNotifyEvent';
    Methods[k].meth := @SetOnClick;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Tag';
    Inc(k);
    Methods[k].Name := 'set_Cursor';
    Methods[k].meth := @set_Cursor;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Cursor';
    Inc(k);
    Methods[k].Name := 'set_Left';
    Methods[k].meth := @set_Left;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Left';
    Inc(k);
    Methods[k].Name := 'set_Height';
    Methods[k].meth := @set_Height;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Height';
    Inc(k);
    Methods[k].Name := 'set_Width';
    Methods[k].meth := @set_Width;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set Width';
    Inc(k);
    Methods[k].Name := 'set_HelpContext';
    Methods[k].meth := @set_HelpContext;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'set HelpContext';
    ///Teditinteface(k);









    //insert befor
inc(k);
Methods[k].Name := 'TWinControlgetBoundsLockCount';
Methods[k].meth := @TWinControlgetBoundsLockCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetBoundsLockCount';
inc(k);
Methods[k].Name := 'TWinControlgetCachedClientHeight';
Methods[k].meth := @TWinControlgetCachedClientHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetCachedClientHeight';
inc(k);
Methods[k].Name := 'TWinControlgetCachedClientWidth';
Methods[k].meth := @TWinControlgetCachedClientWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetCachedClientWidth';
inc(k);
Methods[k].Name := 'TWinControlgetControlCount';
Methods[k].meth := @TWinControlgetControlCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetControlCount';
inc(k);
Methods[k].Name := 'TWinControlgetControls';
Methods[k].meth := @TWinControlgetControls;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetControls';
inc(k);
Methods[k].Name := 'TWinControlgetDockClientCount';
Methods[k].meth := @TWinControlgetDockClientCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDockClientCount';
inc(k);
Methods[k].Name := 'TWinControlgetDockClients';
Methods[k].meth := @TWinControlgetDockClients;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDockClients';
inc(k);
Methods[k].Name := 'TWinControlsetDockSite';
Methods[k].meth := @TWinControlsetDockSite;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetDockSite';
inc(k);
Methods[k].Name := 'TWinControlgetDockSite';
Methods[k].meth := @TWinControlgetDockSite;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDockSite';
inc(k);
Methods[k].Name := 'TWinControlsetDoubleBuffered';
Methods[k].meth := @TWinControlsetDoubleBuffered;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetDoubleBuffered';
inc(k);
Methods[k].Name := 'TWinControlgetDoubleBuffered';
Methods[k].meth := @TWinControlgetDoubleBuffered;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDoubleBuffered';
inc(k);
Methods[k].Name := 'TWinControlgetIsResizing';
Methods[k].meth := @TWinControlgetIsResizing;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetIsResizing';
inc(k);
Methods[k].Name := 'TWinControlsetTabStop';
Methods[k].meth := @TWinControlsetTabStop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetTabStop';
inc(k);
Methods[k].Name := 'TWinControlgetTabStop';
Methods[k].meth := @TWinControlgetTabStop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetTabStop';
inc(k);
Methods[k].Name := 'TWinControlgetShowing';
Methods[k].meth := @TWinControlgetShowing;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetShowing';
inc(k);
Methods[k].Name := 'TWinControlsetDesignerDeleting';
Methods[k].meth := @TWinControlsetDesignerDeleting;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlsetDesignerDeleting';
inc(k);
Methods[k].Name := 'TWinControlgetDesignerDeleting';
Methods[k].meth := @TWinControlgetDesignerDeleting;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlgetDesignerDeleting';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayed';
Methods[k].meth := @TWinControlAutoSizeDelayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAutoSizeDelayed';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayedReport';
Methods[k].meth := @TWinControlAutoSizeDelayedReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAutoSizeDelayedReport';
inc(k);
Methods[k].Name := 'TWinControlAutoSizeDelayedHandle';
Methods[k].meth := @TWinControlAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TWinControlBeginUpdateBounds';
Methods[k].meth := @TWinControlBeginUpdateBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlBeginUpdateBounds';
inc(k);
Methods[k].Name := 'TWinControlEndUpdateBounds';
Methods[k].meth := @TWinControlEndUpdateBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlEndUpdateBounds';
inc(k);
Methods[k].Name := 'TWinControlLockRealizeBounds';
Methods[k].meth := @TWinControlLockRealizeBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlLockRealizeBounds';
inc(k);
Methods[k].Name := 'TWinControlUnlockRealizeBounds';
Methods[k].meth := @TWinControlUnlockRealizeBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlUnlockRealizeBounds';
inc(k);
Methods[k].Name := 'TWinControlContainsControl';
Methods[k].meth := @TWinControlContainsControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlContainsControl';
inc(k);
Methods[k].Name := 'TWinControlDoAdjustClientRectChange';
Methods[k].meth := @TWinControlDoAdjustClientRectChange;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlDoAdjustClientRectChange';
inc(k);
Methods[k].Name := 'TWinControlInvalidateClientRectCache';
Methods[k].meth := @TWinControlInvalidateClientRectCache;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlInvalidateClientRectCache';
inc(k);
Methods[k].Name := 'TWinControlClientRectNeedsInterfaceUpdate';
Methods[k].meth := @TWinControlClientRectNeedsInterfaceUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlClientRectNeedsInterfaceUpdate';
inc(k);
Methods[k].Name := 'TWinControlSetBounds';
Methods[k].meth := @TWinControlSetBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlSetBounds';
inc(k);
Methods[k].Name := 'TWinControlDisableAlign';
Methods[k].meth := @TWinControlDisableAlign;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlDisableAlign';
inc(k);
Methods[k].Name := 'TWinControlEnableAlign';
Methods[k].meth := @TWinControlEnableAlign;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlEnableAlign';
inc(k);
Methods[k].Name := 'TWinControlReAlign';
Methods[k].meth := @TWinControlReAlign;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlReAlign';
inc(k);
Methods[k].Name := 'TWinControlScrollBy';
Methods[k].meth := @TWinControlScrollBy;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlScrollBy';
inc(k);
Methods[k].Name := 'TWinControlWriteLayoutDebugReport';
Methods[k].meth := @TWinControlWriteLayoutDebugReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlWriteLayoutDebugReport';
inc(k);
Methods[k].Name := 'TWinControlCanFocus';
Methods[k].meth := @TWinControlCanFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlCanFocus';
inc(k);
Methods[k].Name := 'TWinControlGetControlIndex';
Methods[k].meth := @TWinControlGetControlIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlGetControlIndex';
inc(k);
Methods[k].Name := 'TWinControlSetControlIndex';
Methods[k].meth := @TWinControlSetControlIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlSetControlIndex';
inc(k);
Methods[k].Name := 'TWinControlFocused';
Methods[k].meth := @TWinControlFocused;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlFocused';
inc(k);
Methods[k].Name := 'TWinControlPerformTab';
Methods[k].meth := @TWinControlPerformTab;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlPerformTab';
inc(k);
Methods[k].Name := 'TWinControlFindChildControl';
Methods[k].meth := @TWinControlFindChildControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlFindChildControl'; {
inc(k);
Methods[k].Name := 'TWinControlBroadCast';
Methods[k].meth := @TWinControlBroadCast;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlBroadCast';
inc(k);
Methods[k].Name := 'TWinControlDefaultHandler';
Methods[k].meth := @TWinControlDefaultHandler;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlDefaultHandler';  }
inc(k);
Methods[k].Name := 'TWinControlGetTextLen';
Methods[k].meth := @TWinControlGetTextLen;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlGetTextLen';
inc(k);
Methods[k].Name := 'TWinControlInvalidate';
Methods[k].meth := @TWinControlInvalidate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlInvalidate';
inc(k);
Methods[k].Name := 'TWinControlAddControl';
Methods[k].meth := @TWinControlAddControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlAddControl';
inc(k);
Methods[k].Name := 'TWinControlInsertControl';
Methods[k].meth := @TWinControlInsertControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlInsertControl';
inc(k);
Methods[k].Name := 'TWinControlInsertControl';
Methods[k].meth := @TWinControlInsertControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlInsertControl';
inc(k);
Methods[k].Name := 'TWinControlRepaint';
Methods[k].meth := @TWinControlRepaint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlRepaint';
inc(k);
Methods[k].Name := 'TWinControlUpdate';
Methods[k].meth := @TWinControlUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlUpdate';
inc(k);
Methods[k].Name := 'TWinControlSetFocus';
Methods[k].meth := @TWinControlSetFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlSetFocus';
inc(k);
Methods[k].Name := 'TWinControlFlipChildren';
Methods[k].meth := @TWinControlFlipChildren;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlFlipChildren';
inc(k);
Methods[k].Name := 'TWinControlScaleBy';
Methods[k].meth := @TWinControlScaleBy;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlScaleBy';
inc(k);
Methods[k].Name := 'TWinControlGetDockCaption';
Methods[k].meth := @TWinControlGetDockCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlGetDockCaption';
inc(k);
Methods[k].Name := 'TWinControlUpdateDockCaption';
Methods[k].meth := @TWinControlUpdateDockCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlUpdateDockCaption';
inc(k);
Methods[k].Name := 'TWinControlHandleAllocated';
Methods[k].meth := @TWinControlHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlHandleAllocated';
inc(k);
Methods[k].Name := 'TWinControlParentHandlesAllocated';
Methods[k].meth := @TWinControlParentHandlesAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlParentHandlesAllocated';
inc(k);
Methods[k].Name := 'TWinControlHandleNeeded';
Methods[k].meth := @TWinControlHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlHandleNeeded';
inc(k);
Methods[k].Name := 'TWinControlBrushCreated';
Methods[k].meth := @TWinControlBrushCreated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlBrushCreated';
inc(k);
Methods[k].Name := 'TWinControlIntfGetDropFilesTarget';
Methods[k].meth := @TWinControlIntfGetDropFilesTarget;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TWinControlIntfGetDropFilesTarget';
inc(k);
Methods[k].Name := 'TStringsAdd';
Methods[k].meth := @TStringsAdd;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsAdd';
inc(k);
Methods[k].Name := 'TStringsAddObject';
Methods[k].meth := @TStringsAddObject;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsAddObject';
inc(k);
Methods[k].Name := 'TStringsAppend';
Methods[k].meth := @TStringsAppend;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsAppend';
inc(k);
Methods[k].Name := 'TStringsAddStrings';
Methods[k].meth := @TStringsAddStrings;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsAddStrings';
inc(k);
Methods[k].Name := 'TStringsBeginUpdate';
Methods[k].meth := @TStringsBeginUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsBeginUpdate';
inc(k);
Methods[k].Name := 'TStringsClear';
Methods[k].meth := @TStringsClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsClear';
inc(k);
Methods[k].Name := 'TStringsDelete';
Methods[k].meth := @TStringsDelete;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsDelete';
inc(k);
Methods[k].Name := 'TStringsEndUpdate';
Methods[k].meth := @TStringsEndUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsEndUpdate';
inc(k);
Methods[k].Name := 'TStringsEquals';
Methods[k].meth := @TStringsEquals;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsEquals';
inc(k);
Methods[k].Name := 'TStringsEquals';
Methods[k].meth := @TStringsEquals;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsEquals';
inc(k);
Methods[k].Name := 'TStringsExchange';
Methods[k].meth := @TStringsExchange;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsExchange';
inc(k);
Methods[k].Name := 'TStringsIndexOf';
Methods[k].meth := @TStringsIndexOf;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsIndexOf';
inc(k);
Methods[k].Name := 'TStringsIndexOfName';
Methods[k].meth := @TStringsIndexOfName;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsIndexOfName';
inc(k);
Methods[k].Name := 'TStringsIndexOfObject';
Methods[k].meth := @TStringsIndexOfObject;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsIndexOfObject';
inc(k);
Methods[k].Name := 'TStringsInsert';
Methods[k].meth := @TStringsInsert;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsInsert';
inc(k);
Methods[k].Name := 'TStringsLoadFromFile';
Methods[k].meth := @TStringsLoadFromFile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsLoadFromFile';
inc(k);
Methods[k].Name := 'TStringsMove';
Methods[k].meth := @TStringsMove;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsMove';
inc(k);
Methods[k].Name := 'TStringsSaveToFile';
Methods[k].meth := @TStringsSaveToFile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsSaveToFile';   {
inc(k);
Methods[k].Name := 'TStringsGetNameValue';
Methods[k].meth := @TStringsGetNameValue;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsGetNameValue';  }
inc(k);
Methods[k].Name := 'TStringssetValueFromIndex';
Methods[k].meth := @TStringssetValueFromIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetValueFromIndex';
inc(k);
Methods[k].Name := 'TStringsgetValueFromIndex';
Methods[k].meth := @TStringsgetValueFromIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetValueFromIndex';
inc(k);
Methods[k].Name := 'TStringssetCapacity';
Methods[k].meth := @TStringssetCapacity;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetCapacity';
inc(k);
Methods[k].Name := 'TStringsgetCapacity';
Methods[k].meth := @TStringsgetCapacity;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetCapacity';
inc(k);
Methods[k].Name := 'TStringssetCommaText';
Methods[k].meth := @TStringssetCommaText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetCommaText';
inc(k);
Methods[k].Name := 'TStringsgetCommaText';
Methods[k].meth := @TStringsgetCommaText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetCommaText';
inc(k);
Methods[k].Name := 'TStringsgetCount';
Methods[k].meth := @TStringsgetCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetCount';
inc(k);
Methods[k].Name := 'TStringsgetNames';
Methods[k].meth := @TStringsgetNames;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetNames';
inc(k);
Methods[k].Name := 'TStringssetObjects';
Methods[k].meth := @TStringssetObjects;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetObjects';
inc(k);
Methods[k].Name := 'TStringsgetObjects';
Methods[k].meth := @TStringsgetObjects;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetObjects';
inc(k);
Methods[k].Name := 'TStringssetValues';
Methods[k].meth := @TStringssetValues;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetValues';
inc(k);
Methods[k].Name := 'TStringsgetValues';
Methods[k].meth := @TStringsgetValues;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetValues';
inc(k);
Methods[k].Name := 'TStringssetStrings';
Methods[k].meth := @TStringssetStrings;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetStrings';
inc(k);
Methods[k].Name := 'TStringsgetStrings';
Methods[k].meth := @TStringsgetStrings;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetStrings';
inc(k);
Methods[k].Name := 'TStringssetText';
Methods[k].meth := @TStringssetText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringssetText';
inc(k);
Methods[k].Name := 'TStringsgetText';
Methods[k].meth := @TStringsgetText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TStringsgetText';
inc(k);
Methods[k].Name := 'TScrollingWinControlUpdateScrollbars';
Methods[k].meth := @TScrollingWinControlUpdateScrollbars;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TScrollingWinControlUpdateScrollbars';
inc(k);
Methods[k].Name := 'TPopupMenuPopUp';
Methods[k].meth := @TPopupMenuPopUp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenuPopUp';
inc(k);
Methods[k].Name := 'TPopupMenuPopUp';
Methods[k].meth := @TPopupMenuPopUp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenuPopUp';
inc(k);
Methods[k].Name := 'TPopupMenusetPopupComponent';
Methods[k].meth := @TPopupMenusetPopupComponent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenusetPopupComponent';
inc(k);
Methods[k].Name := 'TPopupMenugetPopupComponent';
Methods[k].meth := @TPopupMenugetPopupComponent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenugetPopupComponent';
inc(k);
Methods[k].Name := 'TPopupMenusetAutoPopup';
Methods[k].meth := @TPopupMenusetAutoPopup;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenusetAutoPopup';
inc(k);
Methods[k].Name := 'TPopupMenugetAutoPopup';
Methods[k].meth := @TPopupMenugetAutoPopup;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TPopupMenugetAutoPopup';  {
inc(k);
Methods[k].Name := 'TObjectCreate';
Methods[k].meth := @TObjectCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectCreate';
inc(k);
Methods[k].Name := 'TObjectClear';
Methods[k].meth := @TObjectClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectClear';
inc(k);
Methods[k].Name := 'TObjectSelectAll';
Methods[k].meth := @TObjectSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectSelectAll';
inc(k);
Methods[k].Name := 'TObjectClearSelection';
Methods[k].meth := @TObjectClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectClearSelection';
inc(k);
Methods[k].Name := 'TObjectCopyToClipboard';
Methods[k].meth := @TObjectCopyToClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectCopyToClipboard';
inc(k);
Methods[k].Name := 'TObjectCutToClipboard';
Methods[k].meth := @TObjectCutToClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectCutToClipboard';
inc(k);
Methods[k].Name := 'TObjectPasteFromClipboard';
Methods[k].meth := @TObjectPasteFromClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectPasteFromClipboard';
inc(k);
Methods[k].Name := 'TObjectgetCanUndo';
Methods[k].meth := @TObjectgetCanUndo;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetCanUndo';
inc(k);
Methods[k].Name := 'TObjectsetHideSelection';
Methods[k].meth := @TObjectsetHideSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetHideSelection';
inc(k);
Methods[k].Name := 'TObjectgetHideSelection';
Methods[k].meth := @TObjectgetHideSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetHideSelection';
inc(k);
Methods[k].Name := 'TObjectsetMaxLength';
Methods[k].meth := @TObjectsetMaxLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetMaxLength';
inc(k);
Methods[k].Name := 'TObjectgetMaxLength';
Methods[k].meth := @TObjectgetMaxLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetMaxLength';
inc(k);
Methods[k].Name := 'TObjectsetModified';
Methods[k].meth := @TObjectsetModified;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetModified';
inc(k);
Methods[k].Name := 'TObjectgetModified';
Methods[k].meth := @TObjectgetModified;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetModified';
inc(k);
Methods[k].Name := 'TObjectsetNumbersOnly';
Methods[k].meth := @TObjectsetNumbersOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetNumbersOnly';
inc(k);
Methods[k].Name := 'TObjectgetNumbersOnly';
Methods[k].meth := @TObjectgetNumbersOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetNumbersOnly';
inc(k);
Methods[k].Name := 'TObjectsetReadOnly';
Methods[k].meth := @TObjectsetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetReadOnly';
inc(k);
Methods[k].Name := 'TObjectgetReadOnly';
Methods[k].meth := @TObjectgetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetReadOnly';
inc(k);
Methods[k].Name := 'TObjectsetSelLength';
Methods[k].meth := @TObjectsetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetSelLength';
inc(k);
Methods[k].Name := 'TObjectgetSelLength';
Methods[k].meth := @TObjectgetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetSelLength';
inc(k);
Methods[k].Name := 'TObjectsetSelStart';
Methods[k].meth := @TObjectsetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetSelStart';
inc(k);
Methods[k].Name := 'TObjectgetSelStart';
Methods[k].meth := @TObjectgetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetSelStart';
inc(k);
Methods[k].Name := 'TObjectsetSelText';
Methods[k].meth := @TObjectsetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectsetSelText';
inc(k);
Methods[k].Name := 'TObjectgetSelText';
Methods[k].meth := @TObjectgetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TObjectgetSelText';   }
inc(k);
Methods[k].Name := 'TMenuItemFind';
Methods[k].meth := @TMenuItemFind;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemFind';
inc(k);
Methods[k].Name := 'TMenuItemGetParentComponent';
Methods[k].meth := @TMenuItemGetParentComponent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemGetParentComponent';
inc(k);
Methods[k].Name := 'TMenuItemGetParentMenu';
Methods[k].meth := @TMenuItemGetParentMenu;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemGetParentMenu';
inc(k);
Methods[k].Name := 'TMenuItemGetIsRightToLeft';
Methods[k].meth := @TMenuItemGetIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemGetIsRightToLeft';
inc(k);
Methods[k].Name := 'TMenuItemHandleAllocated';
Methods[k].meth := @TMenuItemHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHandleAllocated';
inc(k);
Methods[k].Name := 'TMenuItemHasIcon';
Methods[k].meth := @TMenuItemHasIcon;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHasIcon';
inc(k);
Methods[k].Name := 'TMenuItemHasParent';
Methods[k].meth := @TMenuItemHasParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHasParent';
inc(k);
Methods[k].Name := 'TMenuItemInitiateAction';
Methods[k].meth := @TMenuItemInitiateAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemInitiateAction';
inc(k);
Methods[k].Name := 'TMenuItemIntfDoSelect';
Methods[k].meth := @TMenuItemIntfDoSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIntfDoSelect';
inc(k);
Methods[k].Name := 'TMenuItemIndexOf';
Methods[k].meth := @TMenuItemIndexOf;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIndexOf';
inc(k);
Methods[k].Name := 'TMenuItemIndexOfCaption';
Methods[k].meth := @TMenuItemIndexOfCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIndexOfCaption';
inc(k);
Methods[k].Name := 'TMenuItemVisibleIndexOf';
Methods[k].meth := @TMenuItemVisibleIndexOf;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemVisibleIndexOf';
inc(k);
Methods[k].Name := 'TMenuItemAdd';
Methods[k].meth := @TMenuItemAdd;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemAdd';
inc(k);
Methods[k].Name := 'TMenuItemAddSeparator';
Methods[k].meth := @TMenuItemAddSeparator;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemAddSeparator';
inc(k);
Methods[k].Name := 'TMenuItemClick';
Methods[k].meth := @TMenuItemClick;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemClick';
inc(k);
Methods[k].Name := 'TMenuItemDelete';
Methods[k].meth := @TMenuItemDelete;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemDelete';
inc(k);
Methods[k].Name := 'TMenuItemHandleNeeded';
Methods[k].meth := @TMenuItemHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHandleNeeded';
inc(k);
Methods[k].Name := 'TMenuItemInsert';
Methods[k].meth := @TMenuItemInsert;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemInsert';
inc(k);
Methods[k].Name := 'TMenuItemRecreateHandle';
Methods[k].meth := @TMenuItemRecreateHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemRecreateHandle';
inc(k);
Methods[k].Name := 'TMenuItemRemove';
Methods[k].meth := @TMenuItemRemove;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemRemove';
inc(k);
Methods[k].Name := 'TMenuItemIsCheckItem';
Methods[k].meth := @TMenuItemIsCheckItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIsCheckItem';
inc(k);
Methods[k].Name := 'TMenuItemIsLine';
Methods[k].meth := @TMenuItemIsLine;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIsLine';
inc(k);
Methods[k].Name := 'TMenuItemIsInMenuBar';
Methods[k].meth := @TMenuItemIsInMenuBar;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemIsInMenuBar';
inc(k);
Methods[k].Name := 'TMenuItemClear';
Methods[k].meth := @TMenuItemClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemClear';
inc(k);
Methods[k].Name := 'TMenuItemHasBitmap';
Methods[k].meth := @TMenuItemHasBitmap;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemHasBitmap';
inc(k);
Methods[k].Name := 'TMenuItemRemoveAllHandlersOfObject';
Methods[k].meth := @TMenuItemRemoveAllHandlersOfObject;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemRemoveAllHandlersOfObject';
inc(k);
Methods[k].Name := 'TMenuItemgetCount';
Methods[k].meth := @TMenuItemgetCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetCount';
inc(k);
Methods[k].Name := 'TMenuItemgetItems';
Methods[k].meth := @TMenuItemgetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetItems';
inc(k);
Methods[k].Name := 'TMenuItemsetMenuIndex';
Methods[k].meth := @TMenuItemsetMenuIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetMenuIndex';
inc(k);
Methods[k].Name := 'TMenuItemgetMenuIndex';
Methods[k].meth := @TMenuItemgetMenuIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetMenuIndex';
inc(k);
Methods[k].Name := 'TMenuItemgetMenu';
Methods[k].meth := @TMenuItemgetMenu;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetMenu';
inc(k);
Methods[k].Name := 'TMenuItemgetParent';
Methods[k].meth := @TMenuItemgetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetParent';
inc(k);
Methods[k].Name := 'TMenuItemMenuVisibleIndex';
Methods[k].meth := @TMenuItemMenuVisibleIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemMenuVisibleIndex';
inc(k);
Methods[k].Name := 'TMenuItemsetAutoCheck';
Methods[k].meth := @TMenuItemsetAutoCheck;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetAutoCheck';
inc(k);
Methods[k].Name := 'TMenuItemgetAutoCheck';
Methods[k].meth := @TMenuItemgetAutoCheck;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetAutoCheck';
inc(k);
Methods[k].Name := 'TMenuItemsetDefault';
Methods[k].meth := @TMenuItemsetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetDefault';
inc(k);
Methods[k].Name := 'TMenuItemgetDefault';
Methods[k].meth := @TMenuItemgetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetDefault';
inc(k);
Methods[k].Name := 'TMenuItemsetRadioItem';
Methods[k].meth := @TMenuItemsetRadioItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetRadioItem';
inc(k);
Methods[k].Name := 'TMenuItemgetRadioItem';
Methods[k].meth := @TMenuItemgetRadioItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetRadioItem';
inc(k);
Methods[k].Name := 'TMenuItemsetRightJustify';
Methods[k].meth := @TMenuItemsetRightJustify;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemsetRightJustify';
inc(k);
Methods[k].Name := 'TMenuItemgetRightJustify';
Methods[k].meth := @TMenuItemgetRightJustify;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuItemgetRightJustify';
inc(k);
Methods[k].Name := 'TMenuDestroyHandle';
Methods[k].meth := @TMenuDestroyHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuDestroyHandle';
inc(k);
Methods[k].Name := 'TMenuHandleAllocated';
Methods[k].meth := @TMenuHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuHandleAllocated';
inc(k);
Methods[k].Name := 'TMenuIsRightToLeft';
Methods[k].meth := @TMenuIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuIsRightToLeft';
inc(k);
Methods[k].Name := 'TMenuUseRightToLeftAlignment';
Methods[k].meth := @TMenuUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TMenuUseRightToLeftReading';
Methods[k].meth := @TMenuUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TMenuHandleNeeded';
Methods[k].meth := @TMenuHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenuHandleNeeded';
inc(k);
Methods[k].Name := 'TMenusetParent';
Methods[k].meth := @TMenusetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenusetParent';
inc(k);
Methods[k].Name := 'TMenugetParent';
Methods[k].meth := @TMenugetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenugetParent';
inc(k);
Methods[k].Name := 'TMenusetParentBidiMode';
Methods[k].meth := @TMenusetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenusetParentBidiMode';
inc(k);
Methods[k].Name := 'TMenugetParentBidiMode';
Methods[k].meth := @TMenugetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenugetParentBidiMode';
inc(k);
Methods[k].Name := 'TMenugetItems';
Methods[k].meth := @TMenugetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMenugetItems';
inc(k);
Methods[k].Name := 'TMainMenuCreate';
Methods[k].meth := @TMainMenuCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMainMenuCreate';
inc(k);
Methods[k].Name := 'TMainMenugetHeight';
Methods[k].meth := @TMainMenugetHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TMainMenugetHeight'; {
inc(k);
Methods[k].Name := 'TLCLComponentDestroyHandle';
Methods[k].meth := @TLCLComponentDestroyHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentDestroyHandle';
inc(k);
Methods[k].Name := 'TLCLComponentHandleAllocated';
Methods[k].meth := @TLCLComponentHandleAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentHandleAllocated';
inc(k);
Methods[k].Name := 'TLCLComponentIsRightToLeft';
Methods[k].meth := @TLCLComponentIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentIsRightToLeft';
inc(k);
Methods[k].Name := 'TLCLComponentUseRightToLeftAlignment';
Methods[k].meth := @TLCLComponentUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TLCLComponentUseRightToLeftReading';
Methods[k].meth := @TLCLComponentUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TLCLComponentHandleNeeded';
Methods[k].meth := @TLCLComponentHandleNeeded;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentHandleNeeded';
inc(k);
Methods[k].Name := 'TLCLComponentsetParent';
Methods[k].meth := @TLCLComponentsetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentsetParent';
inc(k);
Methods[k].Name := 'TLCLComponentgetParent';
Methods[k].meth := @TLCLComponentgetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentgetParent';
inc(k);
Methods[k].Name := 'TLCLComponentsetParentBidiMode';
Methods[k].meth := @TLCLComponentsetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentsetParentBidiMode';
inc(k);
Methods[k].Name := 'TLCLComponentgetParentBidiMode';
Methods[k].meth := @TLCLComponentgetParentBidiMode;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentgetParentBidiMode';
inc(k);
Methods[k].Name := 'TLCLComponentgetItems';
Methods[k].meth := @TLCLComponentgetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TLCLComponentgetItems';  }
inc(k);
Methods[k].Name := 'TFormCreate';
Methods[k].meth := @TFormCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormCreate';
inc(k);
Methods[k].Name := 'TFormTile';
Methods[k].meth := @TFormTile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormTile';
inc(k);
Methods[k].Name := 'TFormsetLCLVersion';
Methods[k].meth := @TFormsetLCLVersion;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormsetLCLVersion';
inc(k);
Methods[k].Name := 'TFormgetLCLVersion';
Methods[k].meth := @TFormgetLCLVersion;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TFormgetLCLVersion';
inc(k);
Methods[k].Name := 'TCustomScrollBarCreate';
Methods[k].meth := @TCustomScrollBarCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarCreate';
inc(k);
Methods[k].Name := 'TCustomScrollBarSetParams';
Methods[k].meth := @TCustomScrollBarSetParams;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarSetParams';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetMax';
Methods[k].meth := @TCustomScrollBarsetMax;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetMax';
inc(k);
Methods[k].Name := 'TCustomScrollBargetMax';
Methods[k].meth := @TCustomScrollBargetMax;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetMax';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetMin';
Methods[k].meth := @TCustomScrollBarsetMin;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetMin';
inc(k);
Methods[k].Name := 'TCustomScrollBargetMin';
Methods[k].meth := @TCustomScrollBargetMin;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetMin';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetPageSize';
Methods[k].meth := @TCustomScrollBarsetPageSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetPageSize';
inc(k);
Methods[k].Name := 'TCustomScrollBargetPageSize';
Methods[k].meth := @TCustomScrollBargetPageSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetPageSize';
inc(k);
Methods[k].Name := 'TCustomScrollBarsetPosition';
Methods[k].meth := @TCustomScrollBarsetPosition;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBarsetPosition';
inc(k);
Methods[k].Name := 'TCustomScrollBargetPosition';
Methods[k].meth := @TCustomScrollBargetPosition;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomScrollBargetPosition';
inc(k);
Methods[k].Name := 'TCustomMemosetLines';
Methods[k].meth := @TCustomMemosetLines;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetLines';
inc(k);
Methods[k].Name := 'TCustomMemogetLines';
Methods[k].meth := @TCustomMemogetLines;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetLines';
inc(k);
Methods[k].Name := 'TCustomMemosetWantReturns';
Methods[k].meth := @TCustomMemosetWantReturns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetWantReturns';
inc(k);
Methods[k].Name := 'TCustomMemogetWantReturns';
Methods[k].meth := @TCustomMemogetWantReturns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetWantReturns';
inc(k);
Methods[k].Name := 'TCustomMemosetWantTabs';
Methods[k].meth := @TCustomMemosetWantTabs;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetWantTabs';
inc(k);
Methods[k].Name := 'TCustomMemogetWantTabs';
Methods[k].meth := @TCustomMemogetWantTabs;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetWantTabs';
inc(k);
Methods[k].Name := 'TCustomMemosetWordWrap';
Methods[k].meth := @TCustomMemosetWordWrap;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemosetWordWrap';
inc(k);
Methods[k].Name := 'TCustomMemogetWordWrap';
Methods[k].meth := @TCustomMemogetWordWrap;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomMemogetWordWrap';
inc(k);
Methods[k].Name := 'TCustomListBoxAddItem';
Methods[k].meth := @TCustomListBoxAddItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxAddItem';
inc(k);
Methods[k].Name := 'TCustomListBoxClick';
Methods[k].meth := @TCustomListBoxClick;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxClick';
inc(k);
Methods[k].Name := 'TCustomListBoxClear';
Methods[k].meth := @TCustomListBoxClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxClear';
inc(k);
Methods[k].Name := 'TCustomListBoxClearSelection';
Methods[k].meth := @TCustomListBoxClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxClearSelection';
inc(k);
Methods[k].Name := 'TCustomListBoxGetIndexAtXY';
Methods[k].meth := @TCustomListBoxGetIndexAtXY;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxGetIndexAtXY';
inc(k);
Methods[k].Name := 'TCustomListBoxGetIndexAtY';
Methods[k].meth := @TCustomListBoxGetIndexAtY;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxGetIndexAtY';
inc(k);
Methods[k].Name := 'TCustomListBoxGetSelectedText';
Methods[k].meth := @TCustomListBoxGetSelectedText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxGetSelectedText';
inc(k);
Methods[k].Name := 'TCustomListBoxItemVisible';
Methods[k].meth := @TCustomListBoxItemVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxItemVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxItemFullyVisible';
Methods[k].meth := @TCustomListBoxItemFullyVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxItemFullyVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxLockSelectionChange';
Methods[k].meth := @TCustomListBoxLockSelectionChange;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxLockSelectionChange';
inc(k);
Methods[k].Name := 'TCustomListBoxMakeCurrentVisible';
Methods[k].meth := @TCustomListBoxMakeCurrentVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxMakeCurrentVisible';
inc(k);
Methods[k].Name := 'TCustomListBoxMeasureItem';
Methods[k].meth := @TCustomListBoxMeasureItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxMeasureItem';
inc(k);
Methods[k].Name := 'TCustomListBoxSelectAll';
Methods[k].meth := @TCustomListBoxSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxSelectAll';
inc(k);
Methods[k].Name := 'TCustomListBoxsetColumns';
Methods[k].meth := @TCustomListBoxsetColumns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetColumns';
inc(k);
Methods[k].Name := 'TCustomListBoxgetColumns';
Methods[k].meth := @TCustomListBoxgetColumns;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetColumns';
inc(k);
Methods[k].Name := 'TCustomListBoxgetCount';
Methods[k].meth := @TCustomListBoxgetCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetCount';
inc(k);
Methods[k].Name := 'TCustomListBoxsetExtendedSelect';
Methods[k].meth := @TCustomListBoxsetExtendedSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetExtendedSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxgetExtendedSelect';
Methods[k].meth := @TCustomListBoxgetExtendedSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetExtendedSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxsetIntegralHeight';
Methods[k].meth := @TCustomListBoxsetIntegralHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetIntegralHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxgetIntegralHeight';
Methods[k].meth := @TCustomListBoxgetIntegralHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetIntegralHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItemHeight';
Methods[k].meth := @TCustomListBoxsetItemHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetItemHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItemHeight';
Methods[k].meth := @TCustomListBoxgetItemHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetItemHeight';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItemIndex';
Methods[k].meth := @TCustomListBoxsetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetItemIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItemIndex';
Methods[k].meth := @TCustomListBoxgetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetItemIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxsetItems';
Methods[k].meth := @TCustomListBoxsetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetItems';
inc(k);
Methods[k].Name := 'TCustomListBoxgetItems';
Methods[k].meth := @TCustomListBoxgetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetItems';
inc(k);
Methods[k].Name := 'TCustomListBoxsetMultiSelect';
Methods[k].meth := @TCustomListBoxsetMultiSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetMultiSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxgetMultiSelect';
Methods[k].meth := @TCustomListBoxgetMultiSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetMultiSelect';
inc(k);
Methods[k].Name := 'TCustomListBoxsetScrollWidth';
Methods[k].meth := @TCustomListBoxsetScrollWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetScrollWidth';
inc(k);
Methods[k].Name := 'TCustomListBoxgetScrollWidth';
Methods[k].meth := @TCustomListBoxgetScrollWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetScrollWidth';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSelCount';
Methods[k].meth := @TCustomListBoxgetSelCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetSelCount';
inc(k);
Methods[k].Name := 'TCustomListBoxsetSelected';
Methods[k].meth := @TCustomListBoxsetSelected;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetSelected';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSelected';
Methods[k].meth := @TCustomListBoxgetSelected;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetSelected';
inc(k);
Methods[k].Name := 'TCustomListBoxsetSorted';
Methods[k].meth := @TCustomListBoxsetSorted;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetSorted';
inc(k);
Methods[k].Name := 'TCustomListBoxgetSorted';
Methods[k].meth := @TCustomListBoxgetSorted;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetSorted';
inc(k);
Methods[k].Name := 'TCustomListBoxsetTopIndex';
Methods[k].meth := @TCustomListBoxsetTopIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxsetTopIndex';
inc(k);
Methods[k].Name := 'TCustomListBoxgetTopIndex';
Methods[k].meth := @TCustomListBoxgetTopIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomListBoxgetTopIndex';
inc(k);
Methods[k].Name := 'TCustomLabelCreate';
Methods[k].meth := @TCustomLabelCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelCreate';
inc(k);
Methods[k].Name := 'TCustomLabelColorIsStored';
Methods[k].meth := @TCustomLabelColorIsStored;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelColorIsStored';
inc(k);
Methods[k].Name := 'TCustomLabelAdjustFontForOptimalFill';
Methods[k].meth := @TCustomLabelAdjustFontForOptimalFill;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelAdjustFontForOptimalFill';
inc(k);
Methods[k].Name := 'TCustomLabelPaint';
Methods[k].meth := @TCustomLabelPaint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelPaint';
inc(k);
Methods[k].Name := 'TCustomLabelSetBounds';
Methods[k].meth := @TCustomLabelSetBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomLabelSetBounds';
inc(k);
Methods[k].Name := 'TCustomFormAfterConstruction';
Methods[k].meth := @TCustomFormAfterConstruction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormAfterConstruction';
inc(k);
Methods[k].Name := 'TCustomFormBeforeDestruction';
Methods[k].meth := @TCustomFormBeforeDestruction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormBeforeDestruction';
inc(k);
Methods[k].Name := 'TCustomFormClose';
Methods[k].meth := @TCustomFormClose;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormClose';
inc(k);
Methods[k].Name := 'TCustomFormCloseQuery';
Methods[k].meth := @TCustomFormCloseQuery;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormCloseQuery';
inc(k);
Methods[k].Name := 'TCustomFormDefocusControl';
Methods[k].meth := @TCustomFormDefocusControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormDefocusControl';
inc(k);
Methods[k].Name := 'TCustomFormDestroyWnd';
Methods[k].meth := @TCustomFormDestroyWnd;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormDestroyWnd';
inc(k);
Methods[k].Name := 'TCustomFormEnsureVisible';
Methods[k].meth := @TCustomFormEnsureVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormEnsureVisible';
inc(k);
Methods[k].Name := 'TCustomFormFocusControl';
Methods[k].meth := @TCustomFormFocusControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormFocusControl';
inc(k);
Methods[k].Name := 'TCustomFormFormIsUpdating';
Methods[k].meth := @TCustomFormFormIsUpdating;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormFormIsUpdating';
inc(k);
Methods[k].Name := 'TCustomFormHide';
Methods[k].meth := @TCustomFormHide;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormHide';
inc(k);
Methods[k].Name := 'TCustomFormIntfHelp';
Methods[k].meth := @TCustomFormIntfHelp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormIntfHelp';
inc(k);
Methods[k].Name := 'TCustomFormAutoSizeDelayedHandle';
Methods[k].meth := @TCustomFormAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TCustomFormRelease';
Methods[k].meth := @TCustomFormRelease;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormRelease';
inc(k);
Methods[k].Name := 'TCustomFormCanFocus';
Methods[k].meth := @TCustomFormCanFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormCanFocus';
inc(k);
Methods[k].Name := 'TCustomFormSetFocus';
Methods[k].meth := @TCustomFormSetFocus;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormSetFocus';
inc(k);
Methods[k].Name := 'TCustomFormSetFocusedControl';
Methods[k].meth := @TCustomFormSetFocusedControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormSetFocusedControl';
inc(k);
Methods[k].Name := 'TCustomFormSetRestoredBounds';
Methods[k].meth := @TCustomFormSetRestoredBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormSetRestoredBounds';
inc(k);
Methods[k].Name := 'TCustomFormShow';
Methods[k].meth := @TCustomFormShow;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormShow';
inc(k);
Methods[k].Name := 'TCustomFormShowModal';
Methods[k].meth := @TCustomFormShowModal;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormShowModal';
inc(k);
Methods[k].Name := 'TCustomFormShowOnTop';
Methods[k].meth := @TCustomFormShowOnTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormShowOnTop';
inc(k);
Methods[k].Name := 'TCustomFormRemoveAllHandlersOfObject';
Methods[k].meth := @TCustomFormRemoveAllHandlersOfObject;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormRemoveAllHandlersOfObject';
inc(k);
Methods[k].Name := 'TCustomFormActiveMDIChild';
Methods[k].meth := @TCustomFormActiveMDIChild;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormActiveMDIChild';
inc(k);
Methods[k].Name := 'TCustomFormGetMDIChildren';
Methods[k].meth := @TCustomFormGetMDIChildren;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormGetMDIChildren';
inc(k);
Methods[k].Name := 'TCustomFormMDIChildCount';
Methods[k].meth := @TCustomFormMDIChildCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormMDIChildCount';
inc(k);
Methods[k].Name := 'TCustomFormgetActive';
Methods[k].meth := @TCustomFormgetActive;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetActive';
inc(k);
Methods[k].Name := 'TCustomFormsetActiveControl';
Methods[k].meth := @TCustomFormsetActiveControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetActiveControl';
inc(k);
Methods[k].Name := 'TCustomFormgetActiveControl';
Methods[k].meth := @TCustomFormgetActiveControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetActiveControl';
inc(k);
Methods[k].Name := 'TCustomFormsetActiveDefaultControl';
Methods[k].meth := @TCustomFormsetActiveDefaultControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetActiveDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormgetActiveDefaultControl';
Methods[k].meth := @TCustomFormgetActiveDefaultControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetActiveDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormsetAllowDropFiles';
Methods[k].meth := @TCustomFormsetAllowDropFiles;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetAllowDropFiles';
inc(k);
Methods[k].Name := 'TCustomFormgetAllowDropFiles';
Methods[k].meth := @TCustomFormgetAllowDropFiles;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetAllowDropFiles';
inc(k);
Methods[k].Name := 'TCustomFormsetAlphaBlend';
Methods[k].meth := @TCustomFormsetAlphaBlend;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetAlphaBlend';
inc(k);
Methods[k].Name := 'TCustomFormgetAlphaBlend';
Methods[k].meth := @TCustomFormgetAlphaBlend;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetAlphaBlend';
inc(k);
Methods[k].Name := 'TCustomFormsetCancelControl';
Methods[k].meth := @TCustomFormsetCancelControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetCancelControl';
inc(k);
Methods[k].Name := 'TCustomFormgetCancelControl';
Methods[k].meth := @TCustomFormgetCancelControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetCancelControl';
inc(k);
Methods[k].Name := 'TCustomFormsetDefaultControl';
Methods[k].meth := @TCustomFormsetDefaultControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormgetDefaultControl';
Methods[k].meth := @TCustomFormgetDefaultControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetDefaultControl';
inc(k);
Methods[k].Name := 'TCustomFormsetDesignTimeDPI';
Methods[k].meth := @TCustomFormsetDesignTimeDPI;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetDesignTimeDPI';
inc(k);
Methods[k].Name := 'TCustomFormgetDesignTimeDPI';
Methods[k].meth := @TCustomFormgetDesignTimeDPI;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetDesignTimeDPI';
inc(k);
Methods[k].Name := 'TCustomFormsetHelpFile';
Methods[k].meth := @TCustomFormsetHelpFile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetHelpFile';
inc(k);
Methods[k].Name := 'TCustomFormgetHelpFile';
Methods[k].meth := @TCustomFormgetHelpFile;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetHelpFile';
inc(k);
Methods[k].Name := 'TCustomFormsetKeyPreview';
Methods[k].meth := @TCustomFormsetKeyPreview;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetKeyPreview';
inc(k);
Methods[k].Name := 'TCustomFormgetKeyPreview';
Methods[k].meth := @TCustomFormgetKeyPreview;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetKeyPreview';
inc(k);
Methods[k].Name := 'TCustomFormgetMDIChildren';
Methods[k].meth := @TCustomFormgetMDIChildren;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetMDIChildren';
inc(k);
Methods[k].Name := 'TCustomFormsetMenu';
Methods[k].meth := @TCustomFormsetMenu;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetMenu';
inc(k);
Methods[k].Name := 'TCustomFormgetMenu';
Methods[k].meth := @TCustomFormgetMenu;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetMenu';
inc(k);
Methods[k].Name := 'TCustomFormsetPopupParent';
Methods[k].meth := @TCustomFormsetPopupParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormsetPopupParent';
inc(k);
Methods[k].Name := 'TCustomFormgetPopupParent';
Methods[k].meth := @TCustomFormgetPopupParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetPopupParent';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredLeft';
Methods[k].meth := @TCustomFormgetRestoredLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredLeft';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredTop';
Methods[k].meth := @TCustomFormgetRestoredTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredTop';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredWidth';
Methods[k].meth := @TCustomFormgetRestoredWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredWidth';
inc(k);
Methods[k].Name := 'TCustomFormgetRestoredHeight';
Methods[k].meth := @TCustomFormgetRestoredHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomFormgetRestoredHeight';
inc(k);
Methods[k].Name := 'TCustomEditCreate';
Methods[k].meth := @TCustomEditCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditCreate';
inc(k);
Methods[k].Name := 'TCustomEditClear';
Methods[k].meth := @TCustomEditClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditClear';
inc(k);
Methods[k].Name := 'TCustomEditSelectAll';
Methods[k].meth := @TCustomEditSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditSelectAll';
inc(k);
Methods[k].Name := 'TCustomEditClearSelection';
Methods[k].meth := @TCustomEditClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditClearSelection';
inc(k);
Methods[k].Name := 'TCustomEditCopyToClipboard';
Methods[k].meth := @TCustomEditCopyToClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditCopyToClipboard';
inc(k);
Methods[k].Name := 'TCustomEditCutToClipboard';
Methods[k].meth := @TCustomEditCutToClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditCutToClipboard';
inc(k);
Methods[k].Name := 'TCustomEditPasteFromClipboard';
Methods[k].meth := @TCustomEditPasteFromClipboard;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditPasteFromClipboard';
inc(k);
Methods[k].Name := 'TCustomEditgetCanUndo';
Methods[k].meth := @TCustomEditgetCanUndo;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetCanUndo';
inc(k);
Methods[k].Name := 'TCustomEditsetHideSelection';
Methods[k].meth := @TCustomEditsetHideSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetHideSelection';
inc(k);
Methods[k].Name := 'TCustomEditgetHideSelection';
Methods[k].meth := @TCustomEditgetHideSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetHideSelection';
inc(k);
Methods[k].Name := 'TCustomEditsetMaxLength';
Methods[k].meth := @TCustomEditsetMaxLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetMaxLength';
inc(k);
Methods[k].Name := 'TCustomEditgetMaxLength';
Methods[k].meth := @TCustomEditgetMaxLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetMaxLength';
inc(k);
Methods[k].Name := 'TCustomEditsetModified';
Methods[k].meth := @TCustomEditsetModified;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetModified';
inc(k);
Methods[k].Name := 'TCustomEditgetModified';
Methods[k].meth := @TCustomEditgetModified;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetModified';
inc(k);
Methods[k].Name := 'TCustomEditsetNumbersOnly';
Methods[k].meth := @TCustomEditsetNumbersOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetNumbersOnly';
inc(k);
Methods[k].Name := 'TCustomEditgetNumbersOnly';
Methods[k].meth := @TCustomEditgetNumbersOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetNumbersOnly';
inc(k);
Methods[k].Name := 'TCustomEditsetReadOnly';
Methods[k].meth := @TCustomEditsetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetReadOnly';
inc(k);
Methods[k].Name := 'TCustomEditgetReadOnly';
Methods[k].meth := @TCustomEditgetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetReadOnly';
inc(k);
Methods[k].Name := 'TCustomEditsetSelLength';
Methods[k].meth := @TCustomEditsetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetSelLength';
inc(k);
Methods[k].Name := 'TCustomEditgetSelLength';
Methods[k].meth := @TCustomEditgetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetSelLength';
inc(k);
Methods[k].Name := 'TCustomEditsetSelStart';
Methods[k].meth := @TCustomEditsetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetSelStart';
inc(k);
Methods[k].Name := 'TCustomEditgetSelStart';
Methods[k].meth := @TCustomEditgetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetSelStart';
inc(k);
Methods[k].Name := 'TCustomEditsetSelText';
Methods[k].meth := @TCustomEditsetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditsetSelText';
inc(k);
Methods[k].Name := 'TCustomEditgetSelText';
Methods[k].meth := @TCustomEditgetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomEditgetSelText';
inc(k);
Methods[k].Name := 'TCustomComboBoxIntfGetItems';
Methods[k].meth := @TCustomComboBoxIntfGetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxIntfGetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxAddItem';
Methods[k].meth := @TCustomComboBoxAddItem;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxAddItem';
inc(k);
Methods[k].Name := 'TCustomComboBoxClear';
Methods[k].meth := @TCustomComboBoxClear;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxClear';
inc(k);
Methods[k].Name := 'TCustomComboBoxClearSelection';
Methods[k].meth := @TCustomComboBoxClearSelection;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxClearSelection';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetDroppedDown';
Methods[k].meth := @TCustomComboBoxsetDroppedDown;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetDroppedDown';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetDroppedDown';
Methods[k].meth := @TCustomComboBoxgetDroppedDown;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetDroppedDown';
inc(k);
Methods[k].Name := 'TCustomComboBoxSelectAll';
Methods[k].meth := @TCustomComboBoxSelectAll;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxSelectAll';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetAutoSelect';
Methods[k].meth := @TCustomComboBoxsetAutoSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetAutoSelect';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetAutoSelect';
Methods[k].meth := @TCustomComboBoxgetAutoSelect;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetAutoSelect';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetAutoSelected';
Methods[k].meth := @TCustomComboBoxsetAutoSelected;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetAutoSelected';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetAutoSelected';
Methods[k].meth := @TCustomComboBoxgetAutoSelected;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetAutoSelected';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetDropDownCount';
Methods[k].meth := @TCustomComboBoxsetDropDownCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetDropDownCount';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetDropDownCount';
Methods[k].meth := @TCustomComboBoxgetDropDownCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetDropDownCount';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetItems';
Methods[k].meth := @TCustomComboBoxsetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetItems';
Methods[k].meth := @TCustomComboBoxgetItems;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetItems';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetItemIndex';
Methods[k].meth := @TCustomComboBoxsetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetItemIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetItemIndex';
Methods[k].meth := @TCustomComboBoxgetItemIndex;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetItemIndex';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetReadOnly';
Methods[k].meth := @TCustomComboBoxsetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetReadOnly';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetReadOnly';
Methods[k].meth := @TCustomComboBoxgetReadOnly;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetReadOnly';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelLength';
Methods[k].meth := @TCustomComboBoxsetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetSelLength';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelLength';
Methods[k].meth := @TCustomComboBoxgetSelLength;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetSelLength';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelStart';
Methods[k].meth := @TCustomComboBoxsetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetSelStart';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelStart';
Methods[k].meth := @TCustomComboBoxgetSelStart;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetSelStart';
inc(k);
Methods[k].Name := 'TCustomComboBoxsetSelText';
Methods[k].meth := @TCustomComboBoxsetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxsetSelText';
inc(k);
Methods[k].Name := 'TCustomComboBoxgetSelText';
Methods[k].meth := @TCustomComboBoxgetSelText;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomComboBoxgetSelText';
inc(k);
Methods[k].Name := 'TCustomCheckBoxsetAllowGrayed';
Methods[k].meth := @TCustomCheckBoxsetAllowGrayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomCheckBoxsetAllowGrayed';
inc(k);
Methods[k].Name := 'TCustomCheckBoxgetAllowGrayed';
Methods[k].meth := @TCustomCheckBoxgetAllowGrayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomCheckBoxgetAllowGrayed';
inc(k);
Methods[k].Name := 'TCustomButtonCreate';
Methods[k].meth := @TCustomButtonCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonCreate';
inc(k);
Methods[k].Name := 'TCustomButtonClick';
Methods[k].meth := @TCustomButtonClick;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonClick';
inc(k);
Methods[k].Name := 'TCustomButtonExecuteDefaultAction';
Methods[k].meth := @TCustomButtonExecuteDefaultAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonExecuteDefaultAction';
inc(k);
Methods[k].Name := 'TCustomButtonExecuteCancelAction';
Methods[k].meth := @TCustomButtonExecuteCancelAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonExecuteCancelAction';
inc(k);
Methods[k].Name := 'TCustomButtonActiveDefaultControlChanged';
Methods[k].meth := @TCustomButtonActiveDefaultControlChanged;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonActiveDefaultControlChanged';
inc(k);
Methods[k].Name := 'TCustomButtonUpdateRolesForForm';
Methods[k].meth := @TCustomButtonUpdateRolesForForm;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonUpdateRolesForForm';
inc(k);
Methods[k].Name := 'TCustomButtongetActive';
Methods[k].meth := @TCustomButtongetActive;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtongetActive';
inc(k);
Methods[k].Name := 'TCustomButtonsetDefault';
Methods[k].meth := @TCustomButtonsetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonsetDefault';
inc(k);
Methods[k].Name := 'TCustomButtongetDefault';
Methods[k].meth := @TCustomButtongetDefault;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtongetDefault';
inc(k);
Methods[k].Name := 'TCustomButtonsetCancel';
Methods[k].meth := @TCustomButtonsetCancel;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtonsetCancel';
inc(k);
Methods[k].Name := 'TCustomButtongetCancel';
Methods[k].meth := @TCustomButtongetCancel;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TCustomButtongetCancel';
inc(k);
Methods[k].Name := 'TControlDragDrop';
Methods[k].meth := @TControlDragDrop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlDragDrop';
inc(k);
Methods[k].Name := 'TControlAdjustSize';
Methods[k].meth := @TControlAdjustSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAdjustSize';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayed';
Methods[k].meth := @TControlAutoSizeDelayed;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAutoSizeDelayed';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayedReport';
Methods[k].meth := @TControlAutoSizeDelayedReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAutoSizeDelayedReport';
inc(k);
Methods[k].Name := 'TControlAutoSizeDelayedHandle';
Methods[k].meth := @TControlAutoSizeDelayedHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAutoSizeDelayedHandle';
inc(k);
Methods[k].Name := 'TControlAnchorHorizontalCenterTo';
Methods[k].meth := @TControlAnchorHorizontalCenterTo;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAnchorHorizontalCenterTo';
inc(k);
Methods[k].Name := 'TControlAnchorVerticalCenterTo';
Methods[k].meth := @TControlAnchorVerticalCenterTo;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAnchorVerticalCenterTo';
inc(k);
Methods[k].Name := 'TControlAnchorClient';
Methods[k].meth := @TControlAnchorClient;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAnchorClient';
inc(k);
Methods[k].Name := 'TControlAnchoredControlCount';
Methods[k].meth := @TControlAnchoredControlCount;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlAnchoredControlCount';
inc(k);
Methods[k].Name := 'TControlgetAnchoredControls';
Methods[k].meth := @TControlgetAnchoredControls;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAnchoredControls';
inc(k);
Methods[k].Name := 'TControlSetBounds';
Methods[k].meth := @TControlSetBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlSetBounds';
inc(k);
Methods[k].Name := 'TControlSetInitialBounds';
Methods[k].meth := @TControlSetInitialBounds;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlSetInitialBounds';
inc(k);
Methods[k].Name := 'TControlGetDefaultWidth';
Methods[k].meth := @TControlGetDefaultWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetDefaultWidth';
inc(k);
Methods[k].Name := 'TControlGetDefaultHeight';
Methods[k].meth := @TControlGetDefaultHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetDefaultHeight';
inc(k);
Methods[k].Name := 'TControlCNPreferredSizeChanged';
Methods[k].meth := @TControlCNPreferredSizeChanged;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlCNPreferredSizeChanged';
inc(k);
Methods[k].Name := 'TControlInvalidatePreferredSize';
Methods[k].meth := @TControlInvalidatePreferredSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlInvalidatePreferredSize';
inc(k);
Methods[k].Name := 'TControlWriteLayoutDebugReport';
Methods[k].meth := @TControlWriteLayoutDebugReport;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlWriteLayoutDebugReport';
inc(k);
Methods[k].Name := 'TControlShouldAutoAdjustLeftAndTop';
Methods[k].meth := @TControlShouldAutoAdjustLeftAndTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlShouldAutoAdjustLeftAndTop';
inc(k);
Methods[k].Name := 'TControlBeforeDestruction';
Methods[k].meth := @TControlBeforeDestruction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlBeforeDestruction';
inc(k);
Methods[k].Name := 'TControlEditingDone';
Methods[k].meth := @TControlEditingDone;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlEditingDone';
inc(k);
Methods[k].Name := 'TControlExecuteDefaultAction';
Methods[k].meth := @TControlExecuteDefaultAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlExecuteDefaultAction';
inc(k);
Methods[k].Name := 'TControlExecuteCancelAction';
Methods[k].meth := @TControlExecuteCancelAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlExecuteCancelAction';
inc(k);
Methods[k].Name := 'TControlBeginDrag';
Methods[k].meth := @TControlBeginDrag;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlBeginDrag';
inc(k);
Methods[k].Name := 'TControlEndDrag';
Methods[k].meth := @TControlEndDrag;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlEndDrag';
inc(k);
Methods[k].Name := 'TControlBringToFront';
Methods[k].meth := @TControlBringToFront;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlBringToFront';
inc(k);
Methods[k].Name := 'TControlHasParent';
Methods[k].meth := @TControlHasParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlHasParent';
inc(k);
Methods[k].Name := 'TControlGetParentComponent';
Methods[k].meth := @TControlGetParentComponent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetParentComponent';
inc(k);
Methods[k].Name := 'TControlIsParentOf';
Methods[k].meth := @TControlIsParentOf;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsParentOf';
inc(k);
Methods[k].Name := 'TControlGetTopParent';
Methods[k].meth := @TControlGetTopParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetTopParent';
inc(k);
Methods[k].Name := 'TControlIsVisible';
Methods[k].meth := @TControlIsVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsVisible';
inc(k);
Methods[k].Name := 'TControlIsControlVisible';
Methods[k].meth := @TControlIsControlVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsControlVisible';
inc(k);
Methods[k].Name := 'TControlIsEnabled';
Methods[k].meth := @TControlIsEnabled;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsEnabled';
inc(k);
Methods[k].Name := 'TControlIsParentColor';
Methods[k].meth := @TControlIsParentColor;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsParentColor';
inc(k);
Methods[k].Name := 'TControlIsParentFont';
Methods[k].meth := @TControlIsParentFont;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsParentFont';
inc(k);
Methods[k].Name := 'TControlFormIsUpdating';
Methods[k].meth := @TControlFormIsUpdating;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlFormIsUpdating';
inc(k);
Methods[k].Name := 'TControlIsProcessingPaintMsg';
Methods[k].meth := @TControlIsProcessingPaintMsg;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsProcessingPaintMsg';
inc(k);
Methods[k].Name := 'TControlHide';
Methods[k].meth := @TControlHide;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlHide';
inc(k);
Methods[k].Name := 'TControlRefresh';
Methods[k].meth := @TControlRefresh;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlRefresh';
inc(k);
Methods[k].Name := 'TControlRepaint';
Methods[k].meth := @TControlRepaint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlRepaint';
inc(k);
Methods[k].Name := 'TControlInvalidate';
Methods[k].meth := @TControlInvalidate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlInvalidate';
inc(k);
Methods[k].Name := 'TControlCheckNewParent';
Methods[k].meth := @TControlCheckNewParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlCheckNewParent';
inc(k);
Methods[k].Name := 'TControlSendToBack';
Methods[k].meth := @TControlSendToBack;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlSendToBack';
inc(k);
Methods[k].Name := 'TControlUpdateRolesForForm';
Methods[k].meth := @TControlUpdateRolesForForm;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUpdateRolesForForm';
inc(k);
Methods[k].Name := 'TControlActiveDefaultControlChanged';
Methods[k].meth := @TControlActiveDefaultControlChanged;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlActiveDefaultControlChanged';
inc(k);
Methods[k].Name := 'TControlGetTextLen';
Methods[k].meth := @TControlGetTextLen;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlGetTextLen';
inc(k);
Methods[k].Name := 'TControlShow';
Methods[k].meth := @TControlShow;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlShow';
inc(k);
Methods[k].Name := 'TControlUpdate';
Methods[k].meth := @TControlUpdate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUpdate';
inc(k);
Methods[k].Name := 'TControlHandleObjectShouldBeVisible';
Methods[k].meth := @TControlHandleObjectShouldBeVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlHandleObjectShouldBeVisible';
inc(k);
Methods[k].Name := 'TControlParentDestroyingHandle';
Methods[k].meth := @TControlParentDestroyingHandle;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlParentDestroyingHandle';
inc(k);
Methods[k].Name := 'TControlParentHandlesAllocated';
Methods[k].meth := @TControlParentHandlesAllocated;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlParentHandlesAllocated';
inc(k);
Methods[k].Name := 'TControlInitiateAction';
Methods[k].meth := @TControlInitiateAction;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlInitiateAction';
inc(k);
Methods[k].Name := 'TControlShowHelp';
Methods[k].meth := @TControlShowHelp;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlShowHelp';
inc(k);
Methods[k].Name := 'TControlRemoveAllHandlersOfObject';
Methods[k].meth := @TControlRemoveAllHandlersOfObject;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlRemoveAllHandlersOfObject';
inc(k);
Methods[k].Name := 'TControlsetAccessibleDescription';
Methods[k].meth := @TControlsetAccessibleDescription;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetAccessibleDescription';
inc(k);
Methods[k].Name := 'TControlgetAccessibleDescription';
Methods[k].meth := @TControlgetAccessibleDescription;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAccessibleDescription';
inc(k);
Methods[k].Name := 'TControlsetAccessibleValue';
Methods[k].meth := @TControlsetAccessibleValue;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetAccessibleValue';
inc(k);
Methods[k].Name := 'TControlgetAccessibleValue';
Methods[k].meth := @TControlgetAccessibleValue;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAccessibleValue';
inc(k);
Methods[k].Name := 'TControlsetAutoSize';
Methods[k].meth := @TControlsetAutoSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetAutoSize';
inc(k);
Methods[k].Name := 'TControlgetAutoSize';
Methods[k].meth := @TControlgetAutoSize;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetAutoSize';
inc(k);
Methods[k].Name := 'TControlsetCaption';
Methods[k].meth := @TControlsetCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetCaption';
inc(k);
Methods[k].Name := 'TControlgetCaption';
Methods[k].meth := @TControlgetCaption;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetCaption';
inc(k);
Methods[k].Name := 'TControlsetClientHeight';
Methods[k].meth := @TControlsetClientHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetClientHeight';
inc(k);
Methods[k].Name := 'TControlgetClientHeight';
Methods[k].meth := @TControlgetClientHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetClientHeight';
inc(k);
Methods[k].Name := 'TControlsetClientWidth';
Methods[k].meth := @TControlsetClientWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetClientWidth';
inc(k);
Methods[k].Name := 'TControlgetClientWidth';
Methods[k].meth := @TControlgetClientWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetClientWidth';
inc(k);
Methods[k].Name := 'TControlsetEnabled';
Methods[k].meth := @TControlsetEnabled;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetEnabled';
inc(k);
Methods[k].Name := 'TControlgetEnabled';
Methods[k].meth := @TControlgetEnabled;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetEnabled';
inc(k);
Methods[k].Name := 'TControlsetIsControl';
Methods[k].meth := @TControlsetIsControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetIsControl';
inc(k);
Methods[k].Name := 'TControlgetIsControl';
Methods[k].meth := @TControlgetIsControl;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetIsControl';
inc(k);
Methods[k].Name := 'TControlgetMouseEntered';
Methods[k].meth := @TControlgetMouseEntered;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetMouseEntered';
inc(k);
Methods[k].Name := 'TControlsetParent';
Methods[k].meth := @TControlsetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetParent';
inc(k);
Methods[k].Name := 'TControlgetParent';
Methods[k].meth := @TControlgetParent;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetParent';
inc(k);
Methods[k].Name := 'TControlsetPopupMenu';
Methods[k].meth := @TControlsetPopupMenu;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetPopupMenu';
inc(k);
Methods[k].Name := 'TControlgetPopupMenu';
Methods[k].meth := @TControlgetPopupMenu;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetPopupMenu';
inc(k);
Methods[k].Name := 'TControlsetShowHint';
Methods[k].meth := @TControlsetShowHint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetShowHint';
inc(k);
Methods[k].Name := 'TControlgetShowHint';
Methods[k].meth := @TControlgetShowHint;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetShowHint';
inc(k);
Methods[k].Name := 'TControlsetVisible';
Methods[k].meth := @TControlsetVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetVisible';
inc(k);
Methods[k].Name := 'TControlgetVisible';
Methods[k].meth := @TControlgetVisible;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetVisible';
inc(k);
Methods[k].Name := 'TControlgetFloating';
Methods[k].meth := @TControlgetFloating;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetFloating';
inc(k);
Methods[k].Name := 'TControlsetHostDockSite';
Methods[k].meth := @TControlsetHostDockSite;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetHostDockSite';
inc(k);
Methods[k].Name := 'TControlgetHostDockSite';
Methods[k].meth := @TControlgetHostDockSite;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetHostDockSite';
inc(k);
Methods[k].Name := 'TControlsetLRDockWidth';
Methods[k].meth := @TControlsetLRDockWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetLRDockWidth';
inc(k);
Methods[k].Name := 'TControlgetLRDockWidth';
Methods[k].meth := @TControlgetLRDockWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetLRDockWidth';
inc(k);
Methods[k].Name := 'TControlsetTBDockHeight';
Methods[k].meth := @TControlsetTBDockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetTBDockHeight';
inc(k);
Methods[k].Name := 'TControlgetTBDockHeight';
Methods[k].meth := @TControlgetTBDockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetTBDockHeight';
inc(k);
Methods[k].Name := 'TControlsetUndockHeight';
Methods[k].meth := @TControlsetUndockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetUndockHeight';
inc(k);
Methods[k].Name := 'TControlgetUndockHeight';
Methods[k].meth := @TControlgetUndockHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetUndockHeight';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftAlignment';
Methods[k].meth := @TControlUseRightToLeftAlignment;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUseRightToLeftAlignment';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftReading';
Methods[k].meth := @TControlUseRightToLeftReading;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUseRightToLeftReading';
inc(k);
Methods[k].Name := 'TControlUseRightToLeftScrollBar';
Methods[k].meth := @TControlUseRightToLeftScrollBar;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlUseRightToLeftScrollBar';
inc(k);
Methods[k].Name := 'TControlIsRightToLeft';
Methods[k].meth := @TControlIsRightToLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlIsRightToLeft';
inc(k);
Methods[k].Name := 'TControlsetLeft';
Methods[k].meth := @TControlsetLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetLeft';
inc(k);
Methods[k].Name := 'TControlgetLeft';
Methods[k].meth := @TControlgetLeft;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetLeft';
inc(k);
Methods[k].Name := 'TControlsetHeight';
Methods[k].meth := @TControlsetHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetHeight';
inc(k);
Methods[k].Name := 'TControlgetHeight';
Methods[k].meth := @TControlgetHeight;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetHeight';
inc(k);
Methods[k].Name := 'TControlsetTop';
Methods[k].meth := @TControlsetTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetTop';
inc(k);
Methods[k].Name := 'TControlgetTop';
Methods[k].meth := @TControlgetTop;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetTop';
inc(k);
Methods[k].Name := 'TControlsetWidth';
Methods[k].meth := @TControlsetWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetWidth';
inc(k);
Methods[k].Name := 'TControlgetWidth';
Methods[k].meth := @TControlgetWidth;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetWidth';
inc(k);
Methods[k].Name := 'TControlsetHelpKeyword';
Methods[k].meth := @TControlsetHelpKeyword;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlsetHelpKeyword';
inc(k);
Methods[k].Name := 'TControlgetHelpKeyword';
Methods[k].meth := @TControlgetHelpKeyword;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TControlgetHelpKeyword';
inc(k);
Methods[k].Name := 'TButtonControlCreate';
Methods[k].meth := @TButtonControlCreate;
Methods[k].flags := METH_VARARGS;
Methods[k].doc := 'TButtonControlCreate';
    Inc(k);
    Methods[k].Name := 'Create_FormLfm';
    Methods[k].meth := @Create_FormLfm;
    Methods[k].flags := METH_VARARGS;
    Methods[k].doc := 'creat formlfm';
    Inc(k);
    Methods[k].Name := nil;
    Methods[k].meth := nil;
    Methods[k].flags := 0;
    Methods[k].doc := nil;

    numofcall := 0;
    laz4pyobj := Tlaz4py.Create();
    Py_InitModule('PyMinMod', Methods[0]);
  end;


exports
  initPyMinMod;

end.
