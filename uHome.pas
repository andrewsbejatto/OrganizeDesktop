unit uHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.ImageList, FMX.ImgList, FMX.Effects, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo,
  FMX.Platform.Win;

type
  TFrmHome = class(TForm)
    ListBox: TListBox;
    recModel: TRectangle;
    lblModel: TLabel;
    imgModel: TImage;
    ImageList1: TImageList;
    ShadowEffect1: TShadowEffect;
    Button1: TButton;
    PanelOpacity: TPanel;
    procedure ListBoxDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
    procedure ListBoxDragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure MetropolisUIListBoxItem1Click(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure Button1Click(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    procedure LoadShortcut;
  public
    { Public declarations }
  end;

var
  FrmHome: TFrmHome;

implementation

uses Winapi.ShellAPI, WinApi.Windows, Vcl.Graphics, System.IOUtils,
  ActiveX, ComObj, Winapi.ShlObj, System.Generics.Collections,
  WinShell, ClassHelper;

{$R *.fmx}

procedure TFrmHome.Button1Click(Sender: TObject);
begin
//  Image1.Bitmap.LoadFromStream(GetIcon('c:\saac\saac.exe'));
  LoadShortcut;
//    CreateListBoxShortcut('C:\Users\music\Desktop\Genshin Impact.lnk');
end;

procedure TFrmHome.FormCreate(Sender: TObject);
var h : HWND;
    aStyle : integer;
    alphaValue : byte;
begin
    h := WindowHandleToPlatform(self.Handle).Wnd;
    AStyle := GetWindowLong(h, GWL_EXSTYLE);
    SetWindowLong(h, GWL_EXSTYLE, AStyle or WS_EX_LAYERED);

    AlphaValue := 125;
    SetLayeredWindowAttributes(h, 0, alphaValue, LWA_ALPHA);
end;

procedure TFrmHome.ListBoxDblClick(Sender: TObject);
begin
  if (ListBox.Count > 0) and (ListBox.Selected.Index > 0) then
  begin
    ShowMessage(TMetropolisUIListBoxItem(ListBox.Selected).Title);
//  ShowMessage(TMetropolisUIListBoxItem(Item).TagString);

//  ShellExecute(WindowHandleToPlatform(Handle).Wnd, PChar('open'), PChar(TMetropolisUIListBoxItem(Item).TagString), '', '', 0);
  end;
end;

procedure TFrmHome.ListBoxDragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
begin
//  ListBox.AddObject(TClassShortcut.CreateListBoxShortcut(Data.Data.AsString, 'Shortcut'));
end;

procedure TFrmHome.ListBoxDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  Operation := TDragOperation.Move;
end;

procedure TFrmHome.ListBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
//  ShowMessage(TMetropolisUIListBoxItem(Item).Title);
//  ShowMessage(TMetropolisUIListBoxItem(Item).TagString);

//  ShellExecute(WindowHandleToPlatform(Handle).Wnd, PChar('open'), PChar(TMetropolisUIListBoxItem(Item).TagString), '', '', 0);
end;

procedure TFrmHome.ListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
Begin
  Self.StartWindowDrag;
end;

procedure TFrmHome.LoadShortcut;
var
  list: TObjectList<TClassFile>;
  f   : TClassFile;
  I   : Integer;
begin
  list := TClassFiles.ListDesktopFiles;
  for f in list do
    ListBox.AddObject(TClassShortcut.CreateListBoxShortcut(f));
end;

procedure TFrmHome.MetropolisUIListBoxItem1Click(Sender: TObject);
begin
//  ShowMessage(TMetropolisUIListBoxItem(Sender).Title);
end;

end.
