program Desktop;

uses
  System.StartUpCopy,
  FMX.Forms,
  uHome in 'uHome.pas' {FrmHome},
  WinShell in 'WinShell.pas',
  ClassHelper in 'ClassHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmHome, FrmHome);
  Application.Run;
end.
