unit chessmodules;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Controls, StdCtrls,
  chessgame;

type
  TChessModuleKind = (cmkSameComputer, cmkInternet, cmkAgainstComputer);

  { TChessModule }

  TChessModule = class
  public
    Kind: TChessModuleKind;
    Description: string;
    procedure CreateUserInterface(); virtual; abstract;
    procedure ShowUserInterface(AParent: TWinControl); virtual; abstract;
    procedure HideUserInterface(); virtual; abstract;
    procedure FreeUserInterface(); virtual; abstract;
    procedure PrepareForGame(); virtual; abstract;
    function IsMovingAllowedNow(): Boolean; virtual;
    function GetSecondPlayerName(): string; virtual; abstract;
    procedure HandleOnMove(AFrom, ATo: TPoint); virtual; abstract;
  end;

var
  gSelectedModuleIndex: Integer = -1;
  gChessModulesDebugOutputDestiny: TMemo = nil;

procedure RegisterChessModule(AModule: TChessModule);
procedure PopulateChessModulesList(AList: TStrings);
function GetChessModule(AIndex: Integer): TChessModule;
function GetChessModuleCount(): Integer;
procedure ChessModuleDebugLn(AStr: string);

implementation

var
  gChessModules: TList;

procedure HandleOnMove(AFrom, ATo: TPoint);
var
  lModule: TChessModule;
begin
  lModule := GetChessModule(gSelectedModuleIndex);

  // If we are getting notified by a computer move, don't notify the module yet again
  if not lModule.IsMovingAllowedNow() then
    lModule.HandleOnMove(AFrom, ATo);
end;

procedure RegisterChessModule(AModule: TChessModule);
begin
  if AModule = nil then raise Exception.Create('[RegisterChessModule] Attempted to register a nil module');
  gChessModules.Add(AModule);
  AModule.CreateUserInterface();
end;

procedure PopulateChessModulesList(AList: TStrings);
var
  i: Integer;
  lModule: TChessModule;
begin
  AList.Clear;
  for i := 0 to gChessModules.Count - 1 do
  begin
    lModule := TChessModule(gChessModules.Items[i]);
    if lModule <> nil then
      AList.Add(lModule.Description);
  end;
end;

function GetChessModule(AIndex: Integer): TChessModule;
begin
  if AIndex < 0 then Exit(nil);
  Result := TChessModule(gChessModules.Items[AIndex]);
end;

function GetChessModuleCount: Integer;
begin
  Result := gChessModules.Count;
end;

procedure ChessModuleDebugLn(AStr: string);
begin
  if Assigned(gChessModulesDebugOutputDestiny) then
    gChessModulesDebugOutputDestiny.Lines.Add(AStr);
end;

{ TChessModule }

function TChessModule.IsMovingAllowedNow: Boolean;
begin
  Result := not (vChessGame.IsWhitePlayerTurn xor vChessGame.FirstPlayerIsWhite);
end;

initialization
  gChessModules := TList.Create;
  vChessGame.OnAfterMove := @HandleOnMove;
finalization
  gChessModules.Free;
end.

