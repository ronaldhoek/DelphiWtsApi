unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, WtsClasses;

type
  TfrmMain = class(TForm)
    btnGetSessions: TButton;
    edtServerName: TEdit;
    lblServername: TLabel;
    Sessions: TLabel;
    lvSessions: TListView;
    lbSessionInfo: TListBox;
    procedure btnGetSessionsClick(Sender: TObject);
    procedure edtServerNameChange(Sender: TObject);
    procedure lvSessionsChange(Sender: TObject; Item: TListItem; Change:
        TItemChange);
  private
    FCurServer: IWtsServer;
    function CurServer: IWtsServer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  System.TypInfo, WtsApi;

function GetStateString(aStatus: TWtsConnectstate): string;
begin
  Result := Copy(GetEnumName(TypeInfo(TWtsConnectstate), Integer(aStatus)), 4, 100);
end;

procedure TfrmMain.btnGetSessionsClick(Sender: TObject);
var
  FServer: IWtsServer;
  sessions: IWtsSessions;
  I: Integer;
  item: TListItem;
begin
  lvSessions.Items.Clear;


  sessions := CurServer.GetSessions;
  for I := 0 to sessions.Count - 1 do
  begin
    item := lvSessions.Items.Add;
    item.Caption := IntToStr(sessions[I].SessionId);
    item.SubItems.Add(sessions[i].WindowStationName);
    item.SubItems.Add(GetStateString(sessions[I].ConnectionState))
  end;
end;

function TfrmMain.CurServer: IWtsServer;
begin
  if FCurServer = nil then
    FCurServer := OpenServer(edtServerName.Text);
  Result := FCurServer;
end;

procedure TfrmMain.edtServerNameChange(Sender: TObject);
begin
  lvSessions.Items.Clear;
  FCurServer := nil;
end;

procedure TfrmMain.lvSessionsChange(Sender: TObject; Item: TListItem; Change:
    TItemChange);
var
  session: IWtsSession;
begin
  lbSessionInfo.Clear;
  if Assigned(Item) then
  begin
    session := CurServer.GetSession(StrToInt(Item.Caption));
    lbSessionInfo.Items.Add('SessionId: ' + IntToStr(session.SessionId));
    lbSessionInfo.Items.Add('State: ' + GetStateString(session.ConnectionState));
    lbSessionInfo.Items.Add('Winstation: ' + session.WindowStationName);

    // etc.
  end;
end;

end.
