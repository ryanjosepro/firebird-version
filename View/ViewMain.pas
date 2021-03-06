unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ShellAPI, Vcl.StdCtrls, Vcl.ExtCtrls, MyUtils,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls;

type
  TWindowMain = class(TForm)
    PanelFirebirdVersion: TPanel;
    Actions: TActionList;
    ActEsc: TAction;
    ActEnter: TAction;
    LblFileName: TLabel;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PanelFirebirdVersionClick(Sender: TObject);
    procedure ActEscExecute(Sender: TObject);
    procedure ActEnterExecute(Sender: TObject);
  private
    procedure LoadFirebirdVersion(FileName: string);
  protected
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  end;

var
  WindowMain: TWindowMain;

implementation

{$R *.dfm}

procedure TWindowMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, true);
end;

procedure TWindowMain.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, false);
end;

procedure TWindowMain.WMDropFiles(var Msg: TMessage);
var
  hDrop: THandle;
  FileCount: Integer;
  NameLen: Integer;
  I: Integer;
  FileName: string;
begin
  hDrop:= Msg.wParam;
  FileCount:= DragQueryFile (hDrop , $FFFFFFFF, nil, 0);

  for I:= 0 to FileCount - 1 do begin
    NameLen:= DragQueryFile(hDrop, I, nil, 0) + 1;
    SetLength(FileName, NameLen);
    DragQueryFile(hDrop, I, Pointer(FileName), NameLen);

    LoadFirebirdVersion(FileName);
  end;

  DragFinish(hDrop);
end;

procedure TWindowMain.PanelFirebirdVersionClick(Sender: TObject);
var
  FileName: string;
begin
  if TUtils.OpenFile('Firebird Database (*.FDB)', '*.FDB', true, FileName) then
    LoadFirebirdVersion(FileName);
end;

procedure TWindowMain.ActEnterExecute(Sender: TObject);
begin
  PanelFirebirdVersionClick(Sender);
end;

procedure TWindowMain.LoadFirebirdVersion(FileName: string);
begin
  LblFileName.Caption := FileName;

  try
    ProgressBar.Position := 0;
    Screen.Cursor := crHourGlass;

    PanelFirebirdVersion.Caption := 'Firebird ' + TUtils.GetFirebirdFileVersion(FileName);

    PanelFirebirdVersion.Font.Color := clHighlight;
  finally
    ProgressBar.Position := 100;
    Screen.Cursor := crDefault;
  end;
end;

procedure TWindowMain.ActEscExecute(Sender: TObject);
begin
  Close;
end;

end.
