unit uShortcutModel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  WinShell;

type
  TFrameShortcutModel = class(TFrame)
    recModel: TRectangle;
    lblModel: TLabel;
    imgModel: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetModel(AInfo: TShellLinkInfo; out ARec: TRectangle);
  end;

implementation

{$R *.fmx}


{ TS }

procedure TFrameShortcutModel.GetModel(AInfo: TShellLinkInfo; out ARec: TRectangle);
begin
  ARec.AddObject(lblModel);
  ARec.AddObject(imgModel);
end;

end.
