program TestWtsApi;

uses
  Vcl.Forms,
  MainU in 'MainU.pas' {frmMain},
  WtsApi in '..\Lib\WtsApi.pas',
  WtsClasses in '..\Lib\WtsClasses.pas';

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
