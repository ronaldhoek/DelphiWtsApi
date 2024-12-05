unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, WtsClasses, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    btnGetSessions: TButton;
    edtServerName: TEdit;
    lblServername: TLabel;
    lblSessions: TLabel;
    lbSessionInfo: TListBox;
    lvSessions: TListView;
    tmrRefresh: TTimer;
    stsMain: TStatusBar;
    procedure btnGetSessionsClick(Sender: TObject);
    procedure edtServerNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvSessionsChange(Sender: TObject; Item: TListItem; Change:
        TItemChange);
    procedure tmrRefreshTimer(Sender: TObject);
  private
    FCurServer: IWtsServer;
    FRefreshTask: TThread;
    FWantToClose: Boolean;
    function CurServer: IWtsServer;
    procedure RefreshSessionList;
    procedure UpdateSessionList(sessions: IWtsSessions);
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
begin
  if edtServerName.Text > '' then
    RefreshSessionList;
end;

function TfrmMain.CurServer: IWtsServer;
begin
  Result := FCurServer;
  if Result = nil then
  begin
    Result := OpenServer(edtServerName.Text);
    FCurServer := Result;
  end;
end;

procedure TfrmMain.edtServerNameChange(Sender: TObject);
begin
  lvSessions.Items.Clear;
  lbSessionInfo.Clear;
  FCurServer := nil;

  tmrRefresh.Enabled := False;
  if Trim((Sender as TEdit).Text) > '' then
  begin
    tmrRefresh.Interval := 500;
    tmrRefresh.Enabled := True;
  end else
    stsMain.SimpleText := '<refresh not active>';
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FRefreshTask = nil;
  if not CanClose then
  begin
    FWantToClose := true;
    ShowMessage('Cannot close, please wait');
  end;
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
    if (session.UserName > '') then
      lbSessionInfo.Items.Add('User: ' + session.DomainName + '\' + session.UserName);

    // etc.
  end;
end;

procedure TfrmMain.RefreshSessionList;
begin
  if FRefreshTask <> nil then
    Exit;

  FRefreshTask := TThread.CreateAnonymousThread(
    procedure
    var
      sessions: IWtsSessions;
      msg: string;
    begin
      try
        sessions := CurServer.GetSessions;
        if sessions.LastError > 0 then
          raise Exception.Create(SysErrorMessage(sessions.LastError));

      except
        on E: Exception do
        begin
          FRefreshTask := nil;
          msg := E.Message;
          TThread.Synchronize(nil,
            procedure
            begin
              tmrRefresh.Enabled := False;
              if FWantToClose then
                Close
              else
                stsMain.SimpleText := 'Refresh failed: ' + msg;
            end);
          Exit;
        end;
      end;

      FRefreshTask := nil;
      TThread.Synchronize(nil,
        procedure
        begin
          if FWantToClose then
            Close
          else
            UpdateSessionList(sessions);
        end);
    end);

  FRefreshTask.FreeOnTerminate := True;
  FRefreshTask.Start;
end;

procedure TfrmMain.tmrRefreshTimer(Sender: TObject);
begin
  if edtServerName.Text > '' then
  begin
    stsMain.SimpleText := 'Refreshing...';
    RefreshSessionList;
    (Sender as TTimer).Interval := 5000;
  end;
end;

procedure TfrmMain.UpdateSessionList(sessions: IWtsSessions);
var
  I: Integer;
  sCaption: string;
  item: TListItem;
begin
  stsMain.SimpleText := 'Last refresh: ' + TimeToStr(Now);

  for I := 0 to sessions.Count - 1 do
  begin
    sCaption := IntToStr(sessions[I].SessionId);
    item := lvSessions.FindCaption(0, sCaption, False, True, False);
    if item = nil then
    begin
      item := lvSessions.Items.Add;
      item.Caption := sCaption;
    end else
      item.SubItems.Clear;

    item.Data := Pointer(sessions); // Non-ref-counting ref to session list
    item.SubItems.Add(sessions[i].WindowStationName);
    item.SubItems.Add(GetStateString(sessions[I].ConnectionState));
  end;

  // cleanup non valid sessions
  if lvSessions.Items.Count > sessions.Count then
    for I := lvSessions.Items.Count - 1 downto 0 do
      if lvSessions.Items[I].Data <> Pointer(sessions) then
        lvSessions.Items.Delete(I);
end;

end.
