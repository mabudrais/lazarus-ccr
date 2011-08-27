program fpchess;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lnetbase, mainform, chessdrawer, chessgame, chessconfig,
  chesstcputils, chessmodules, mod_singleplayer
  {$ifdef FPCHESS_WEBSERVICES}
  ,IDelphiChess_Intf
  {$endif};

//{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformChess, formChess);
  Application.Run;
end.

