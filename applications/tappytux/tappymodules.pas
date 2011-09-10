unit tappymodules;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type

  { TTappyModule }

  TTappyModule = class
  public
    imgBackground: TPortableNetworkGraphic;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure LoadImages; virtual;
  end;

procedure AddModule(AModule: TTappyModule);
function GetCurrentModule: TTappyModule;
function GetModule(AIndex: Integer): TTappyModule;
function GetModuleCount: Integer;
procedure SetCurrentModule(AIndex: Integer);

implementation

var
  gTappyModules: TFPList;
  gCurrentTappyModule: Integer = -1;

procedure AddModule(AModule: TTappyModule);
begin
  gTappyModules.Add(Pointer(AModule));
end;

function GetCurrentModule: TTappyModule;
begin
  Result := GetModule(gCurrentTappyModule);
end;

function GetModule(AIndex: Integer): TTappyModule;
begin
  Result := TTappyModule(gTappyModules.Items[AIndex]);
end;

function GetModuleCount: Integer;
begin
  Result := gTappyModules.Count;
end;

procedure SetCurrentModule(AIndex: Integer);
begin
  gCurrentTappyModule := AIndex;
end;

{ TTappyModule }

constructor TTappyModule.Create;
begin
  inherited Create;
end;

destructor TTappyModule.Destroy;
begin
  inherited Destroy;
end;

procedure TTappyModule.LoadImages;
begin
{  var
    lDir: string;
  begin
    lDir := vChessConfig.GetCurrentSkinDir();}

  {  imgBoard.LoadFromFile(lDir + 'base.png');
    imgWPawn.LoadFromFile(lDir + 'wpawn.png');
    imgWKnight.LoadFromFile(lDir + 'wknight.png');
    imgWBishop.LoadFromFile(lDir + 'wbishop.png');
    imgWRook.LoadFromFile(lDir + 'wrook.png');
    imgWQueen.LoadFromFile(lDir + 'wqueen.png');
    imgWKing.LoadFromFile(lDir + 'wking.png');
    imgBPawn.LoadFromFile(lDir + 'bpawn.png');
    imgBKnight.LoadFromFile(lDir + 'bknight.png');
    imgBBishop.LoadFromFile(lDir + 'bbishop.png');
    imgBRook.LoadFromFile(lDir + 'brook.png');
    imgBQueen.LoadFromFile(lDir + 'bqueen.png');
    imgBKing.LoadFromFile(lDir + 'bking.png');}

end;

initialization
  gTappyModules := TFPList.Create;
finalization
  gTappyModules.Free;
end.

