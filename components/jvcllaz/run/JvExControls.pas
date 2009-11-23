{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExControls.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -
               dejoy.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvExControls.pas 11400 2007-06-28 21:24:06Z ahuser $
// Initial port to Lazarus by Sergio Samayoa - september 2007.
// Conversion is done in incremental way: as types / classes / routines
// are needed they are converted.
// TODO: Make this unit generated by template as JVCL's.

{$mode objfpc}{$H+}

unit JvExControls;
{MACROINCLUDE JvExControls.macros}

{*****************************************************************************
 * WARNING: Do not edit this file.
 * This file is autogenerated from the source in devtools/JvExVCL/src.
 * If you do it despite this warning your changes will be discarded by the next
 * update of this file. Do your changes in the template files.
 ****************************************************************************}
{$D-} // do not step into this unit

interface

uses
  Classes, Controls, Graphics, LCLIntf, LCLType, LMessages, Forms;

type
  TDlgCode =
   (dcWantAllKeys, dcWantArrows, dcWantChars, dcButton, dcHasSetSel, dcWantTab,
    dcNative); // if dcNative is in the set the native allowed keys are used and GetDlgCode is ignored
  TDlgCodes = set of TDlgCode;

(******************** NOT CONVERTED
const
  dcWantMessage = dcWantAllKeys;

const
  CM_DENYSUBCLASSING = JvThemes.CM_DENYSUBCLASSING;
  CM_PERFORM = CM_BASE + $500 + 0; // LParam: "Msg: ^TMessage"
  CM_SETAUTOSIZE = CM_BASE + $500 + 1; // WParam: "Value: Boolean"

type
  TJvHotTrackOptions = class;

  { IJvExControl is used for the identification of an JvExXxx control. }
  IJvExControl = interface
    ['{8E6579C3-D683-4562-AFAB-D23C8526E386}']
  end;

  { Add IJvDenySubClassing to the base class list if the control should not
    be themed by the ThemeManager (http://www.soft-gems.net Mike Lischke).
    This only works with JvExVCL derived classes. }
  IJvDenySubClassing = interface
    ['{76942BC0-2A6E-4DC4-BFC9-8E110DB7F601}']
  end;


  { IJvHotTrack is Specifies whether Control are highlighted when the mouse passes over them}
  IJvHotTrack = interface
    ['{8F1B40FB-D8E3-46FE-A7A3-21CE4B199A8F}']

    function GetHotTrack:Boolean;
    function GetHotTrackFont:TFont;
    function GetHotTrackFontOptions:TJvTrackFontOptions;
    function GetHotTrackOptions:TJvHotTrackOptions;

    procedure SetHotTrack(Value: Boolean);
    procedure SetHotTrackFont(Value: TFont);
    procedure SetHotTrackFontOptions(Value: TJvTrackFontOptions);
    procedure SetHotTrackOptions(Value: TJvHotTrackOptions);

    property HotTrack: Boolean read GetHotTrack write SetHotTrack;
    property HotTrackFont: TFont read GetHotTrackFont write SetHotTrackFont;
    property HotTrackFontOptions: TJvTrackFontOptions read GetHotTrackFontOptions write SetHotTrackFontOptions;
    property HotTrackOptions: TJvHotTrackOptions read GetHotTrackOptions write SetHotTrackOptions;
  end;

  TJvHotTrackOptions = class(TJvPersistentProperty)
  private
    FEnabled: Boolean;
    FFrameVisible: Boolean;
    FColor: TColor;
    FFrameColor: TColor;
    procedure SetColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameVisible(Value: Boolean);
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Color: TColor read FColor write SetColor default $00D2BDB6;
    property FrameVisible: Boolean read FFrameVisible write SetFrameVisible default False;
    property FrameColor: TColor read FFrameColor write SetFrameColor default $006A240A;
  end;
******************** NOT CONVERTED *)

type
  TStructPtrMessage = class(TObject)
  private
  public
    Msg: TLMessage;
    constructor Create(AMsg: Integer; WParam: Integer; var LParam);
  end;

//******************** NOT CONVERTED
//procedure SetDotNetFrameColors(FocusedColor, UnfocusedColor: TColor);

procedure DrawDotNetControl(Control: TWinControl; AColor: TColor; InControl: Boolean);
procedure HandleDotNetHighlighting(Control: TWinControl; const Msg: TLMessage;
  MouseOver: Boolean; Color: TColor);
function CreateWMMessage(Msg: Integer; WParam: PtrInt; LParam: PtrInt): TLMessage; overload; {$IFDEF SUPPORTS_INLINE} inline {$ENDIF}
function CreateWMMessage(Msg: Integer; WParam: PtrInt; LParam: TControl): TLMessage; overload; {$IFDEF SUPPORTS_INLINE} inline {$ENDIF}
function SmallPointToLong(const Pt: TSmallPoint): Longint; {$IFDEF SUPPORTS_INLINE} inline {$ENDIF}
function ShiftStateToKeyData(Shift: TShiftState): Longint;

//******************** NOT CONVERTED
//function GetFocusedControl(AControl: TControl): TWinControl;

function DlgcToDlgCodes(Value: Longint): TDlgCodes;
function DlgCodesToDlgc(Value: TDlgCodes): Longint;
procedure GetHintColor(var HintInfo: THintInfo; AControl: TControl; HintColor: TColor);
function DispatchIsDesignMsg(Control: TControl; var Msg: TLMessage): Boolean;

type
  //******************** NOT CONVERTED
  //CONTROL_DECL_DEFAULT(Control)

  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(WinControl)

  TJvExCustomControl = class(TCustomControl)
  private
    // TODO:
    // FAboutJVCL: TJVCLAboutInfo;
    FHintColor: TColor;
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    function BaseWndProc(Msg: Integer; WParam: PtrInt = 0; LParam: Longint = 0): Integer; overload;
    function BaseWndProc(Msg: Integer; WParam: Ptrint; LParam: TControl): Integer; overload;
    function BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
  protected
    procedure WndProc(var Msg: TLMessage); override;
    procedure FocusChanged(AControl: TWinControl); dynamic;
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean; reintroduce; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure MouseEnter(AControl: TControl); reintroduce; dynamic;
    procedure MouseLeave(AControl: TControl); reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    function GetCaption: TCaption; virtual;
    procedure SetCaption(Value: TCaption); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Caption: TCaption read GetCaption write SetCaption;
    property HintWindowClass: THintWindowClass read FHintWindowClass write FHintWindowClass;
  published
    // TODO:
    // property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  private
    FDotNetHighlighting: Boolean;
  protected
    procedure BoundsChanged; reintroduce; virtual;
    procedure CursorChanged; reintroduce; dynamic;
    procedure ShowingChanged; reintroduce; dynamic;
    procedure ShowHintChanged; reintroduce; dynamic;
    procedure ControlsListChanging(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure ControlsListChanged(Control: TControl; Inserting: Boolean); reintroduce; dynamic;
    procedure GetDlgCode(var Code: TDlgCodes); virtual;
    procedure FocusSet(PrevWnd: THandle); virtual;
    procedure FocusKilled(NextWnd: THandle); virtual;
    function DoEraseBackground(ACanvas: TCanvas; Param: Integer): Boolean; virtual;
  published
    property DotNetHighlighting: Boolean read FDotNetHighlighting write FDotNetHighlighting default False;
  end;

  TJvExGraphicControl = class(TGraphicControl)
  private
    // TODO:
    // FAboutJVCL: TJVCLAboutInfo;
    FHintColor: TColor;
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    function BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer; overload;
    function BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer; overload;
    function BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
  protected
    procedure WndProc(var Msg: TLMessage); override;
    procedure FocusChanged(AControl: TWinControl); dynamic;
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean; reintroduce; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure MouseEnter(AControl: TControl); reintroduce; dynamic;
    procedure MouseLeave(AControl: TControl); reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    function GetCaption: TCaption; virtual;
    procedure SetCaption(Value: TCaption); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Caption: TCaption read GetCaption write SetCaption;
    property HintWindowClass: THintWindowClass read FHintWindowClass write FHintWindowClass;
  published
    // TODO:
    // property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  end;
  
  //******************** NOT CONVERTED
  //WINCONTROL_DECL_DEFAULT(HintWindow)

(******************** NOT CONVERTED
  TJvExPubGraphicControl = class(TJvExGraphicControl)
  COMMON_PUBLISHED
  end;
******************** NOT CONVERTED *)

implementation

(******************** NOT CONVERTED
uses
  TypInfo;

var
  InternalFocusedColor: TColor = TColor($00733800);
  InternalUnfocusedColor: TColor = clGray;

procedure SetDotNetFrameColors(FocusedColor, UnfocusedColor: TColor);
begin
  InternalFocusedColor := FocusedColor;
  InternalUnfocusedColor := UnfocusedColor;
end;
******************** NOT CONVERTED *)

procedure DrawDotNetControl(Control: TWinControl; AColor: TColor; InControl: Boolean);
(******************** NOT CONVERTED
var
  DC: HDC;
  R: TRect;
  Canvas: TCanvas;
begin
  DC := GetWindowDC(Control.Handle);
  try
    GetWindowRect(Control.Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    Canvas := TCanvas.Create;
    with Canvas do
    try
      Handle := DC;
      Brush.Color := InternalUnfocusedColor;
      if Control.Focused or InControl then
        Brush.Color := InternalFocusedColor;
      FrameRect(R);
      InflateRect(R, -1, -1);
      if not (Control.Focused or InControl) then
        Brush.Color := AColor;
      FrameRect(R);
    finally
      Free;
    end;
  finally
    ReleaseDC(Control.Handle, DC);
  end;
end;
******************** NOT CONVERTED *)
begin
end;

procedure HandleDotNetHighlighting(Control: TWinControl; const Msg: TLMessage;
  MouseOver: Boolean; Color: TColor);
(******************** NOT CONVERTED
var
  Rgn, SubRgn: HRGN;
begin
  if not (csDesigning in Control.ComponentState) then
    case Msg.Msg of
      CM_MOUSEENTER, CM_MOUSELEAVE, WM_KILLFOCUS, WM_SETFOCUS, WM_NCPAINT:
        begin
          DrawDotNetControl(Control, Color, MouseOver);
          if Msg.Msg = CM_MOUSELEAVE then
          begin
            Rgn := CreateRectRgn(0, 0, Control.Width - 1, Control.Height - 1);
            SubRgn := CreateRectRgn(2, 2, Control.Width - 3, Control.Height - 3);
            try
              CombineRgn(Rgn, Rgn, SubRgn, RGN_DIFF);
              InvalidateRgn(Control.Handle, Rgn, False); // redraw 3D border
            finally
              DeleteObject(SubRgn);
              DeleteObject(Rgn);
            end;
          end;
        end;
    end;
end;
******************** NOT CONVERTED *)
begin
end;

function CreateWMMessage(Msg: Integer; WParam: PtrInt; LParam: PtrInt): TLMessage;
begin
  Result.Msg := Msg;
  Result.WParam := WParam;
  Result.LParam := LParam;
  Result.Result := 0;
end;

function CreateWMMessage(Msg: Integer; WParam: PtrInt; LParam: TControl): TLMessage;
begin
  Result := CreateWMMessage(Msg, WParam, Ptrint(LParam));
end;

{ TStructPtrMessage }
constructor TStructPtrMessage.Create(AMsg: Integer; WParam: Integer; var LParam);
begin
  inherited Create;
  Self.Msg.Msg := AMsg;
  Self.Msg.WParam := WParam;
  Self.Msg.LParam := PtrInt(@LParam);
  Self.Msg.Result := 0;
end;

function SmallPointToLong(const Pt: TSmallPoint): Longint;
begin
  Result := Longint(Pt);
end;

function ShiftStateToKeyData(Shift: TShiftState): Longint;
const
  AltMask = $20000000;
  CtrlMask = $10000000;
  ShiftMask = $08000000;
begin
  Result := 0;
  if ssAlt in Shift then
    Result := Result or AltMask;
  if ssCtrl in Shift then
    Result := Result or CtrlMask;
  if ssShift in Shift then
    Result := Result or ShiftMask;
end;

(******************** NOT CONVERTED
function GetFocusedControl(AControl: TControl): TWinControl;
var
  Form: TCustomForm;
begin
  Result := nil;
  Form := GetParentForm(AControl);
  if Assigned(Form) then
    Result := Form.ActiveControl;
end;
******************** NOT CONVERTED *)

function DlgcToDlgCodes(Value: Longint): TDlgCodes;
begin
  Result := [];
(******************** NOT CONVERTED
  if (Value and DLGC_WANTARROWS) <> 0 then
    Include(Result, dcWantArrows);
  if (Value and DLGC_WANTTAB) <> 0 then
    Include(Result, dcWantTab);
  if (Value and DLGC_WANTALLKEYS) <> 0 then
    Include(Result, dcWantAllKeys);
  if (Value and DLGC_WANTCHARS) <> 0 then
    Include(Result, dcWantChars);
  if (Value and DLGC_BUTTON) <> 0 then
    Include(Result, dcButton);
  if (Value and DLGC_HASSETSEL) <> 0 then
    Include(Result, dcHasSetSel);
******************** NOT CONVERTED *)
end;

function DlgCodesToDlgc(Value: TDlgCodes): Longint;
begin
  Result := 0;
(******************** NOT CONVERTED
  if dcWantAllKeys in Value then
    Result := Result or DLGC_WANTALLKEYS;
  if dcWantArrows in Value then
    Result := Result or DLGC_WANTARROWS;
  if dcWantTab in Value then
    Result := Result or DLGC_WANTTAB;
  if dcWantChars in Value then
    Result := Result or DLGC_WANTCHARS;
  if dcButton in Value then
    Result := Result or DLGC_BUTTON;
  if dcHasSetSel in Value then
    Result := Result or DLGC_HASSETSEL;
******************** NOT CONVERTED *)
end;

procedure GetHintColor(var HintInfo: THintInfo; AControl: TControl; HintColor: TColor);
var
  AHintInfo: THintInfo;
begin
  case HintColor of
    clNone:
      HintInfo.HintColor := Application.HintColor;
    clDefault:
      begin
        if Assigned(AControl) and Assigned(AControl.Parent) then
        begin
          AHintInfo := HintInfo;
          AControl.Parent.Perform(CM_HINTSHOW, 0, PtrInt(@AHintInfo));
          HintInfo.HintColor := AHintInfo.HintColor;
        end;
      end;
  else
    HintInfo.HintColor := HintColor;
  end;
end;

function DispatchIsDesignMsg(Control: TControl; var Msg: TLMessage): Boolean;
var
  Form: TCustomForm;
begin
  Result := False;
  case Msg.Msg of
    LM_SETFOCUS, LM_KILLFOCUS, LM_NCHITTEST,
    LM_MOUSEFIRST..LM_MOUSELAST,
    LM_KEYFIRST..LM_KEYLAST,
    LM_CANCELMODE:
      Exit; // These messages are handled in TWinControl.WndProc before IsDesignMsg() is called
  end;
  if (Control <> nil) and (csDesigning in Control.ComponentState) then
  begin
    Form := GetParentForm(Control);
    if (Form <> nil) and (Form.Designer <> nil) and
       Form.Designer.IsDesignMsg(Control, Msg) then
      Result := True;
  end;
end;

(******************** NOT CONVERTED
//=== { TJvHotTrackOptions } ======================================

constructor TJvHotTrackOptions.Create;
begin
  inherited Create;
  FEnabled := False;
  FFrameVisible := False;
  FColor := $00D2BDB6;
  FFrameColor := $006A240A;
end;

procedure TJvHotTrackOptions.Assign(Source: TPersistent);
begin
  if Source is TJvHotTrackOptions then
  begin
    BeginUpdate;
    try
      Enabled := TJvHotTrackOptions(Source).Enabled;
      Color := TJvHotTrackOptions(Source).Color;
      FrameVisible := TJvHotTrackOptions(Source).FrameVisible;
      FrameColor := TJvHotTrackOptions(Source).FrameColor;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TJvHotTrackOptions.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    Changing;
    ChangingProperty('Color');
    FColor := Value;
    ChangedProperty('Color');
    Changed;
  end;
end;

procedure TJvHotTrackOptions.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    Changing;
    ChangingProperty('Enabled');
    FEnabled := Value;
    ChangedProperty('Enabled');
    Changed;
  end;
end;

procedure TJvHotTrackOptions.SetFrameVisible(Value: Boolean);
begin
  if FFrameVisible <> Value then
  begin
    Changing;
    ChangingProperty('FrameVisible');
    FFrameVisible := Value;
    ChangedProperty('FrameVisible');
    Changed;
  end;
end;

procedure TJvHotTrackOptions.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    Changing;
    ChangingProperty('FrameColor');
    FFrameColor := Value;
    ChangedProperty('FrameColor');
    Changed;
  end;
end;
******************** NOT CONVERTED *)

//============================================================================

//******************** NOT CONVERTED
//CONTROL_IMPL_DEFAULT(Control)

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(WinControl)

constructor TJvExGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := clDefault;
end;

function TJvExGraphicControl.BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer;
var
  Mesg: TLMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExGraphicControl.BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer;
var
  Mesg: TLMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExGraphicControl.BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
var
  Mesg: TStructPtrMessage;
begin
  Mesg := TStructPtrMessage.Create(Msg, WParam, LParam);
  try
    inherited WndProc(Mesg.Msg);
  finally
    Result := Mesg.Msg.Result;
    Mesg.Free;
  end;
end;

procedure TJvExGraphicControl.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TJvExGraphicControl.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TJvExGraphicControl.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TJvExGraphicControl.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TJvExGraphicControl.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TJvExGraphicControl.ParentFontChanged;
begin
  // LCL doesn't send this message but left it in case
  //BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TJvExGraphicControl.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TJvExGraphicControl.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

function TJvExGraphicControl.WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExGraphicControl.HitTest(X, Y: Integer): Boolean;
begin
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

function TJvExGraphicControl.HintShow(var HintInfo: THintInfo): Boolean;
begin
  GetHintColor(HintInfo, Self, FHintColor);
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

procedure TJvExGraphicControl.MouseEnter(AControl: TControl);
begin
  FMouseOver := True;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  BaseWndProc(CM_MOUSEENTER, 0, AControl);
end;

procedure TJvExGraphicControl.MouseLeave(AControl: TControl);
begin
  FMouseOver := False;
  BaseWndProc(CM_MOUSELEAVE, 0, AControl);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvExGraphicControl.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

function TJvExGraphicControl.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

// 25.09.2007 - SESS:
// I have done this because TextChanged wasn't fired as expected.
// I still don't shure if this problem is only for this reintroduced
// method because the way LCL treats Caption or will have the same
// problem with other reintroduced methods. So far, I tested some
// other events and seems not.
procedure TJvExGraphicControl.SetCaption(Value: TCaption);
begin
  inherited Caption := Value;
  TextChanged;
end;

procedure TJvExGraphicControl.WndProc(var Msg: TLMessage);
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  case Msg.Msg of
    {
    // TODO: do we need this? I think not...
    CM_DENYSUBCLASSING:
      Msg.Result := Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil);
    }
    CM_DIALOGCHAR:
      with TCMDialogChar(Msg) do
        Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := Integer(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := Integer(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    // LCL doesn't send this message but left it in case
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    // LCL doesn't send this message but left it in case
    //CM_PARENTFONTCHANGED:
    //  ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
  else
    inherited WndProc(Msg);
  end;
end;

//============================================================================

constructor TJvExCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := clDefault;
end;

function TJvExCustomControl.BaseWndProc(Msg: Integer; WParam: PtrInt = 0; LParam: Longint = 0): Integer;
var
  Mesg: TLMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExCustomControl.BaseWndProc(Msg: Integer; WParam: PtrInt; LParam: TControl): Integer;
var
  Mesg: TLMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TJvExCustomControl.BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
var
  Mesg: TStructPtrMessage;
begin
  Mesg := TStructPtrMessage.Create(Msg, WParam, LParam);
  try
    inherited WndProc(Mesg.Msg);
  finally
    Result := Mesg.Msg.Result;
    Mesg.Free;
  end;
end;

procedure TJvExCustomControl.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TJvExCustomControl.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TJvExCustomControl.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TJvExCustomControl.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TJvExCustomControl.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TJvExCustomControl.ParentFontChanged;
begin
  // LCL doesn't send this message but left it in case
  //BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TJvExCustomControl.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TJvExCustomControl.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

function TJvExCustomControl.WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExCustomControl.HitTest(X, Y: Integer): Boolean;
begin
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

function TJvExCustomControl.HintShow(var HintInfo: THintInfo): Boolean;
begin
  GetHintColor(HintInfo, Self, FHintColor);
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

procedure TJvExCustomControl.MouseEnter(AControl: TControl);
begin
  FMouseOver := True;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  BaseWndProc(CM_MOUSEENTER, 0, AControl);
end;

procedure TJvExCustomControl.MouseLeave(AControl: TControl);
begin
  FMouseOver := False;
  BaseWndProc(CM_MOUSELEAVE, 0, AControl);
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TJvExCustomControl.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

function TJvExCustomControl.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

// 25.09.2007 - SESS:
// I have done this because TextChanged wasn't fired as expected.
// I still don't shure if this problem is only for this reintroduced
// method because the way LCL treats Caption or will have the same
// problem with other reintroduced methods. So far, I tested some
// other events and seems not.
procedure TJvExCustomControl.SetCaption(Value: TCaption);
begin
  inherited Caption := Value;
  TextChanged;
end;

procedure TJvExCustomControl.BoundsChanged;
begin
end;

procedure TJvExCustomControl.CursorChanged;
begin
  BaseWndProc(CM_CURSORCHANGED);
end;

procedure TJvExCustomControl.ShowingChanged;
begin
  BaseWndProc(CM_SHOWINGCHANGED);
end;

procedure TJvExCustomControl.ShowHintChanged;
begin
  BaseWndProc(CM_SHOWHINTCHANGED);
end;

{ VCL sends CM_CONTROLLISTCHANGE and CM_CONTROLCHANGE in a different order than
  the CLX methods are used. So we must correct it by evaluating "Inserting". }
procedure TJvExCustomControl.ControlsListChanging(Control: TControl; Inserting: Boolean);
begin
  if Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, PtrInt(Control), Integer(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, PtrInt(Control), Integer(Inserting));
end;

procedure TJvExCustomControl.ControlsListChanged(Control: TControl; Inserting: Boolean);
begin
  if not Inserting then
    BaseWndProc(CM_CONTROLLISTCHANGE, PtrInt(Control), Integer(Inserting))
  else
    BaseWndProc(CM_CONTROLCHANGE, PtrInt(Control), Integer(Inserting));
end;

procedure TJvExCustomControl.GetDlgCode(var Code: TDlgCodes);
begin
end;

procedure TJvExCustomControl.FocusSet(PrevWnd: THandle);
begin
  BaseWndProc(LM_SETFOCUS, Integer(PrevWnd), 0);
end;

procedure TJvExCustomControl.FocusKilled(NextWnd: THandle);
begin
  BaseWndProc(LM_KILLFOCUS, Integer(NextWnd), 0);
end;

function TJvExCustomControl.DoEraseBackground(ACanvas: TCanvas; Param: Integer): Boolean;
begin
  Result := BaseWndProc(LM_ERASEBKGND, ACanvas.Handle, Param) <> 0;
end;

procedure TJvExCustomControl.WndProc(var Msg: TLMessage);
var
  IdSaveDC: Integer;
  DlgCodes: TDlgCodes;
  WCanvas: TCanvas;
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  begin
    case Msg.Msg of
      {
    // TODO: do we need this? I think not...
    CM_DENYSUBCLASSING:
      Msg.Result := Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil);
    }
    CM_DIALOGCHAR:
      with TCMDialogChar(Msg) do
        Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := Integer(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := Integer(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    // LCL doesn't send this message but left it in case
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    // LCL doesn't send this message but left it in case
    //CM_PARENTFONTCHANGED:
    //  ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
    CM_CURSORCHANGED:
      CursorChanged;
    CM_SHOWINGCHANGED:
      ShowingChanged;
    CM_SHOWHINTCHANGED:
      ShowHintChanged;
    CM_CONTROLLISTCHANGE:
      if Msg.LParam <> 0 then
        ControlsListChanging(TControl(Msg.WParam), True)
      else
        ControlsListChanged(TControl(Msg.WParam), False);
    CM_CONTROLCHANGE:
      if Msg.LParam = 0 then
        ControlsListChanging(TControl(Msg.WParam), False)
      else
        ControlsListChanged(TControl(Msg.WParam), True);
    LM_SETFOCUS:
      FocusSet(THandle(Msg.WParam));
    LM_KILLFOCUS:
      FocusKilled(THandle(Msg.WParam));
    LM_SIZE:
      begin
        inherited WndProc(Msg);
        BoundsChanged;
      end;
    LM_ERASEBKGND:
      if Msg.WParam <> 0 then
      begin
        IdSaveDC := SaveDC(HDC(Msg.WParam)); // protect DC against Stock-Objects from Canvas
        WCanvas := TCanvas.Create;
        try
          WCanvas.Handle := HDC(Msg.WParam);
          Msg.Result := Ord(DoEraseBackground(WCanvas, Msg.LParam));
        finally
          WCanvas.Handle := 0;
          WCanvas.Free;
          RestoreDC(HDC(Msg.WParam), IdSaveDC);
        end;
      end
      else
        inherited WndProc(Msg);
    LM_GETDLGCODE:
      begin
        inherited WndProc(Msg);
        DlgCodes := [dcNative] + DlgcToDlgCodes(Msg.Result);
        GetDlgCode(DlgCodes);
        if not (dcNative in DlgCodes) then
          Msg.Result := DlgCodesToDlgc(DlgCodes);
      end;
    else
      inherited WndProc(Msg);
    end;
    // TODO:
    // LM_NCPAINT isn't send by LCL, may be .Net highlighting can't be implemented.
    case Msg.Msg of // precheck message to prevent access violations on released controls
      CM_MOUSEENTER, CM_MOUSELEAVE, LM_KILLFOCUS, LM_SETFOCUS, LM_NCPAINT:
        if DotNetHighlighting then
          HandleDotNetHighlighting(Self, Msg, MouseOver, Color);
    end;
  end;
end;

//============================================================================

//******************** NOT CONVERTED
//WINCONTROL_IMPL_DEFAULT(HintWindow)

end.

