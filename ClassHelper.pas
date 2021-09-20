unit ClassHelper;

interface

uses
  System.Classes,
  FMX.ListBox,
  System.Generics.Collections,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Effects,
  FMX.ListView.Appearances,
  FMX.ListView.Types,
  Winapi.Windows,
  FMX.MultiResBitmap;
type

  {$SCOPEDENUMS ON}
  TFileType = (Shortcut, Directory, Other);

  TClassFile = class
    private
      FName: String;
      FType: TFileType;
    public
    constructor Create(AName: String; AType: TFileType);
  end;

  TClassFiles = class
  public
    class function  ListDesktopFiles: TObjectList<TClassFile>;

    class function  GetIcon(AFileName: String): TMemoryStream;
  end;

  TClassShortcut = class
  public
    class function  CreateListBoxShortcut(AFile: TClassFile): TMetropolisUIListBoxItem;
    class procedure CreateShortcutItem(AFile: TClassFile; AItem: TListViewItem);

  end;

implementation

uses
  Vcl.Graphics,
  Winapi.ShellAPI,
  System.SysUtils,
  System.IOUtils,
  FMX.Dialogs,
  WinShell, uHome;

{ TClassFiles }
class function TClassFiles.GetIcon(AFileName: String): TMemoryStream;
var
 tmpIcon: Vcl.Graphics.TIcon;
 w: Word;
begin
  tmpIcon := TIcon.Create;
  Result  := TMemoryStream.Create;
  try
    try
      if (UpperCase(TPath.GetExtension(AFileName)).Equals('.EXE')) or (TPath.GetExtension(AFileName).Equals('.lnk')) then
          tmpIcon.Handle := ExtractIcon(HInstance, PChar(AFileName), 0)
      else
        tmpIcon.Handle := ExtractAssociatedIcon(HInstance, PChar(AFileName), w);

      if tmpIcon.Handle = 0 then Exit;
      tmpIcon.SaveToStream(Result);
    except
    end;
  finally
    tmpIcon.Free;
  end;
end;

class function TClassFiles.ListDesktopFiles: TObjectList<TClassFile>;

  function HasAttribute(Attr, Val: Integer): Boolean;
  begin
    Result := Attr and Val = Val;
  end;

var
  F  : TSearchRec;
  Ret: Integer;
  Dir: String;
  a  : TClassFile;
begin
  Result := TObjectList<TClassFile>.Create;
  Dir    := GetSpecialFolderPath(SpecialFolders[11].ID, False) + TPath.DirectorySeparatorChar;

  Ret := FindFirst(Dir + '*.*', faAnyFile, F);

  while Ret = 0 do
  begin
    if HasAttribute(F.Attr, faDirectory) then
    begin
      if (F.Name <> '.') And (F.Name <> '..') then
        Result.Add(TClassFile.Create(Dir+F.Name, TFileType.Directory))
    end else
    begin
      if TPath.GetExtension(Dir+F.Name).Equals('.lnk') then
        Result.Add(TClassFile.Create(Dir+F.Name, TFileType.Shortcut))
      else
        Result.Add(TClassFile.Create(Dir+F.Name, TFileType.Other))
    end;
    Ret := FindNext(F);
  end;
end;

{ TClassShortcut }

class function TClassShortcut.CreateListBoxShortcut(AFile: TClassFile): TMetropolisUIListBoxItem;
var
  {item: TListBoxItem;
  rec : TRectangle;
  lbl : TLabel;
  img : TImage;
  eff : TShadowEffect;}

  info: TShellLinkInfo;
begin
  if AFile.FType = TFileType.Shortcut then
    GetShellLinkInfo(AFile.FName, info);

{  item := TListBoxItem.Create(ListBox);

  item.Height := 100;

  rec := TRectangle.Create(item);
  lbl := TLabel.Create(rec);
  img := TImage.Create(rec);
  eff := TShadowEffect.Create(rec);

  eff.Distance := 1;

  rec.AddObject(lbl);
  rec.AddObject(img);
  rec.AddObject(eff);
  rec.Stroke.Color := TAlphaColorRec.Null;
  rec.Fill.Color   := TAlphaColorRec.White;
  rec.TagString    := Data.Data.AsString;

  rec.Align := TAlignLayout.Client;
  lbl.Align := TAlignLayout.Bottom;
  img.Align := TAlignLayout.Client;

  lbl.Text := Copy(ExtractFileName(Data.Data.AsString), 0, Length(ExtractFileName(Data.Data.AsString)) - Length(ExtractFileExt(Data.Data.AsString)));
  img.Bitmap := ImageList1.Source[0].MultiResBitmap[0].Bitmap;
  item.AddObject(rec);
  ListBox.AddObject(item); }

  Result := TMetropolisUIListBoxItem.Create(nil);
  Result.Height := 80;
  Result.Margins.Left   := 5;
  Result.Margins.Right  := 5;
  Result.Margins.Top    := 5;
  Result.Margins.Bottom := 5;

  var name : String := TPath.GetFileName(AFile.FName);//TPath.GetFileNameWithoutExtension(AFile.FName);
  var title, sub, desc: String;
  if Length(name) > 20 then
  begin
    title := Copy(name, 0, 20);
    sub   := Copy(name, 21, 40);
    desc  := Copy(name, 41, 60);
  end else
    title := name;

  Result.Title       := title;
  Result.SubTitle    := sub;
  Result.Description := desc;
  Result.TagString   := AFile.FName;

  case AFile.FType of
    TFileType.Shortcut, TFileType.Other, TFileType.Directory:
      begin
        var ms: TMemoryStream;
        try
          ms := TClassFiles.GetIcon(AFile.FName);
          if ms.Size > 0 then
            Result.Icon.LoadFromStream(ms)
          else
            Result.Icon.LoadFromFile(DirImg + 'no-image.png');
        finally
          ms.Free;
        end;
      end;

    {TFileType.Directory:
      begin
        Result.Icon.LoadFromFile(DirImg + 'folder.png');
      end;

    TFileType.Other:
      begin
        TPath.GetExtension(AFile.FName);
      end;}
  end;
end;

class procedure TClassShortcut.CreateShortcutItem(AFile: TClassFile; AItem: TListViewItem);
var
  info: TShellLinkInfo;
begin
  if AFile.FType = TFileType.Shortcut then
    GetShellLinkInfo(AFile.FName, info);

  with AItem do
  begin
    Height := 110;

    TagString := AFile.FName;
    TListItemText(Objects.FindDrawable('txtDescription')).Text    := TPath.GetFileNameWithoutExtension(AFile.FName);
    TListItemImage(Objects.FindDrawable('imgImage')).ImageIndex := 0;
  end;

  case AFile.FType of
    TFileType.Shortcut:
      begin
        var ms: TMemoryStream;
        try
          ms := TClassFiles.GetIcon(info.PathName);
          if ms.Size > 0 then
            TListItemImage(AItem.Objects.FindDrawable('imgImage')).Bitmap.LoadFromStream(ms);
        finally
          ms.Free;
        end;
      end;
    TFileType.Directory:
      begin
        TListItemImage(AItem.Objects.FindDrawable('imgImage')).Bitmap := FrmHome.ImageList1.Source[1].MultiResBitmap[0].Bitmap;
      end;
  end;
end;

{ TClassFile }

constructor TClassFile.Create(AName: String; AType: TFileType);
begin
  FName := AName;
  FType := AType;
end;

end.
