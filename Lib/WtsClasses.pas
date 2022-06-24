unit WtsClasses;

interface

uses
  System.SysUtils, WtsApi;

type
  EWtsException = class(Exception);

  TWtsHandle = type TS_HANDLE;
  TWtsSessionId = type SESSION_ID;

  IWtsSession = interface;
  IWtsSessions = interface;

  IWtsServerHandle = interface
    ['{1C1B2EC7-F9F6-4525-9410-634D971A44C6}']
    function GetHandle: TWtsHandle;
    function GetIsLocal: Boolean;
    function GetIsOpen: Boolean;
    function GetServerName: string;

    /// <summary>
    /// The underlying terminal server handle provided by Windows in a call to WTSOpenServer.
    /// </summary>
    property Handle: TWtsHandle read GetHandle;

    /// <summary>
    /// Gets a value indicating whether this server is the local terminal server.
    /// </summary>
    property IsLocal: Boolean read GetIsLocal;

    /// <summary>
    /// Returns <c>true</c> if a connection to the server is currently open.
    /// </summary>
    property IsOpen: Boolean read GetIsOpen;

    /// <summary>
    /// The name of the terminal server for this connection.
    /// </summary>
    /// <remarks>
    /// It is not necessary to have a connection to the server open before
    /// retrieving this value.
    /// </remarks>
    property ServerName: string read GetServerName;

    /// <summary>
    /// Opens the terminal server handle.
    /// </summary>
    procedure Open;

    /// <summary>
    /// Closes the connection to the server.
    /// </summary>
    procedure Close;
  end;

  IWtsObject = interface
    ['{1EE8457E-AE06-4F34-BA0E-63DE259A7D24}']
    function GetServerHandle: IWtsServerHandle;

    /// <summary>
    /// The underlying terminal server handle object.
    /// </summary>
    property ServerHandle: IWtsServerHandle read GetServerHandle;
  end;


  IWtsServer = interface(IWtsObject)
    ['{94F4540E-06A7-49B2-8EC6-7398280DBC63}']

    /// <summary>
    /// Lists the sessions on the terminal server.
    /// </summary>
    /// <returns>A list of sessions.</returns>
    function GetSessions: IWtsSessions;

    /// <summary>
    /// Retrieves information about a particular session on the server.
    /// </summary>
    /// <param name="sessionId">The ID of the session.</param>
    /// <returns>Information about the requested session.</returns>
    function GetSession(SessionId: TWtsSessionId): IWtsSession;

//    /// <summary>
//    /// Retrieves a list of processes running on the terminal server.
//    /// </summary>
//    /// <returns>A list of processes.</returns>
//    IList<ITerminalServicesProcess> GetProcesses();
//
//    /// <summary>
//    /// Retrieves information about a particular process running on the server.
//    /// </summary>
//    /// <param name="processId">The ID of the process.</param>
//    /// <returns>Information about the requested process.</returns>
//    ITerminalServicesProcess GetProcess(int processId);
//
//    /// <summary>
//    /// Shuts down the terminal server.
//    /// </summary>
//    /// <param name="type">Type of shutdown requested.</param>
//    void Shutdown(ShutdownType type);
  end;

  IWtsSessions = interface(IWtsObject)
    ['{713A493E-B8F0-4F5F-8B8C-861694F77D6A}']
    function GetCount: Integer;
    function GetItems(Index: Integer): IWtsSession;
    function HasActiveSession: Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: IWtsSession read GetItems; default;
  end;

  TWtsInfos = set of TWtsInfoClass;

  IWtsSession = interface(IWtsObject)
    ['{5F3ABF2D-65DB-4B51-B2BF-A07DC9E153E1}']
    function GetSessionId: TWtsSessionId;
    function GetConnectionState: TWtsConnectstate;
    function GetWindowStationName: string;
    function GetUsername: string;
    function GetDomainName: string;

    /// <summary>
    ///     The ID of the session.
    /// </summary>
    property SessionId: TWtsSessionId read GetSessionId;

    /// <summary>
    ///     The connection state of the session.
    /// </summary>
    property ConnectionState: TWtsConnectstate read GetConnectionState;

    /// <summary>
    ///     The name of the session's window station.
    /// </summary>
    property WindowStationName: string read GetWindowStationName;

    /// <summary>
    ///     Refreshes session information
    /// </summary>
    procedure Refresh(Flags: TWtsInfos);

    /// <summary>
    ///     The name of the user account that last connected to the session.
    /// </summary>
    property UserName: string read GetUsername;

    /// <summary>
    ///     The domain of the user account that last connected to the session.
    /// </summary>
    property DomainName: string read GetDomainName;

(*
    /// <summary>
    ///     The name of the machine last connected to this session.
    /// </summary>
    string ClientName { get; }

    /// <summary>
    ///     The time at which the user connected to this session.
    /// </summary>
    /// <remarks>
    ///     May be <c>null</c>, e.g. for a listening session.
    /// </remarks>
    DateTime? ConnectTime { get; }

    /// <summary>
    ///     The current time in the session.
    /// </summary>
    /// <remarks>
    ///     May be <c>null</c>, e.g. for a listening session.
    /// </remarks>
    DateTime? CurrentTime { get; }

    /// <summary>
    ///     The time at which the user disconnected from this session.
    /// </summary>
    /// <remarks>
    ///     May be <c>null</c>, e.g. if the user has never disconnected from the session.
    /// </remarks>
    DateTime? DisconnectTime { get; }

    /// <summary>
    ///     The time at which this session last received input -- mouse movements, key presses, etc.
    /// </summary>
    /// <remarks>
    ///     May be <c>null</c>, e.g. for a listening session that receives no user input.
    /// </remarks>
    DateTime? LastInputTime { get; }

    /// <summary>
    ///     The time at which the user logged into this session for the first time.
    /// </summary>
    /// <remarks>
    ///     May be <c>null</c>, e.g. for a listening session.
    /// </remarks>
    DateTime? LoginTime { get; }

    /// <summary>
    ///     Length of time that the session has been idle.
    /// </summary>
    /// <remarks>
    ///     <para>
    ///         For connected sessions, this will return the time since the session
    ///         last received user input.
    ///     </para>
    ///     <para>
    ///         For disconnected sessions, this will return the length of time that the user
    ///         has been disconnected from the session.
    ///     </para>
    ///     <para>This will return <c>TimeSpan.Zero</c> if the idle time could not be determined.</para>
    /// </remarks>
    TimeSpan IdleTime { get; }

    /// <summary>
    ///     The user account that last connected to the session.
    /// </summary>
    NTAccount UserAccount { get; }

    /// <summary>
    ///     The IP address reported by the client.
    /// </summary>
    /// <remarks>
    ///     Note that this is not guaranteed to be the client's actual, remote
    ///     IP address -- if the client is behind a router with NAT, for example, the IP address
    ///     reported will be the client's internal IP address on its LAN.
    /// </remarks>
    IPAddress ClientIPAddress { get; }

    /// <summary>
    ///     The virtual IP address assigned to this session.
    /// </summary>
    /// <remarks>
    ///     This is only supported on Windows Server 2008 R2/Windows 7 and later. It will throw an exception if the session
    ///     does not have a virtual IP address.
    /// </remarks>
    IPAddress SessionIPAddress { get; }

    /// <summary>
    ///     The terminal server on which this session is located.
    /// </summary>
    ITerminalServer Server { get; }

    /// <summary>
    ///     The build number of the client.
    /// </summary>
    /// <remarks>
    ///     <para>
    ///         Note that this does not include the major version, minor
    ///         version, or revision number -- it is only the build number. For example, the full file version
    ///         of the RDP 6 client on Windows XP is 6.0.6001.18000, so this property will return 6001
    ///         for this client.
    ///     </para>
    ///     <para>May be zero, e.g. for a listening session.</para>
    /// </remarks>
    int ClientBuildNumber { get; }

    /// <summary>
    ///     Information about a client's display.
    /// </summary>
    IClientDisplay ClientDisplay { get; }

    /// <summary>
    ///     Directory on the client computer in which the client software is installed.
    /// </summary>
    /// <remarks>
    ///     This is typically the full path to the RDP ActiveX control DLL on the client machine; e.g.
    ///     <c>C:\WINDOWS\SYSTEM32\mstscax.dll</c>.
    /// </remarks>
    string ClientDirectory { get; }

    /// <summary>
    ///     Client-specific hardware identifier.
    /// </summary>
    /// <remarks>
    ///     This value is typically <c>0</c>.
    /// </remarks>
    int ClientHardwareId { get; }

    /// <summary>
    ///     Client-specific product identifier.
    /// </summary>
    /// <remarks>
    ///     This value is typically <c>1</c> for the standard RDP client.
    /// </remarks>
    short ClientProductId { get; }

    /// <summary>
    ///     The protocol that the client is using to connect to the session.
    /// </summary>
    ClientProtocolType ClientProtocolType { get; }

    /// <summary>
    ///     The working directory used when launching the initial program.
    /// </summary>
    /// <remarks>
    ///     This property may throw an exception for the console session (where
    ///     <see cref="ClientProtocolType" /> is <see cref="Cassia.ClientProtocolType.Console" />).
    /// </remarks>
    string WorkingDirectory { get; }

    /// <summary>
    ///     The initial program run when the session started.
    /// </summary>
    /// <remarks>
    ///     This property may throw an exception for the console session (where
    ///     <see cref="ClientProtocolType" /> is <see cref="Cassia.ClientProtocolType.Console" />).
    /// </remarks>
    string InitialProgram { get; }

    /// <summary>
    ///     The remote endpoint (IP address and port) of the client connected to the session.
    /// </summary>
    /// <remarks>
    ///     This property currently supports only IPv4 addresses, and will be <c>null</c> if
    ///     no client is connected to the session.
    /// </remarks>
    EndPoint RemoteEndPoint { get; }

    /// <summary>
    ///     Name of the published application that this session is running.
    /// </summary>
    /// <remarks>
    ///     This property may throw an exception for the console session (where
    ///     <see cref="ClientProtocolType" /> is <see cref="Cassia.ClientProtocolType.Console" />).
    /// </remarks>
    string ApplicationName { get; }

    /// <summary>
    ///     Gets a value indicating whether this session is running on the local terminal server.
    /// </summary>
    bool Local { get; }

    /// <summary>
    ///     Incoming protocol statistics for the session.
    /// </summary>
    IProtocolStatistics IncomingStatistics { get; }

    /// <summary>
    ///     Outgoing protocol statistics for the session.
    /// </summary>
    IProtocolStatistics OutgoingStatistics { get; }

    /// <overloads>
    ///     <summary>
    ///         Logs the session off, disconnecting any user that might be attached.
    ///     </summary>
    /// </overloads>
    /// <summary>
    ///     Logs the session off, disconnecting any user that might be attached.
    /// </summary>
    /// <remarks>
    ///     The logoff takes place synchronously; this method returns after the operation is complete.
    ///     This is the same as calling <c>Logoff(true)</c>.
    /// </remarks>
    void Logoff();

    /// <summary>
    ///     Logs the session off, disconnecting any user that might be attached.
    /// </summary>
    /// <param name="synchronous">
    ///     If <c>true</c>, waits until the session is fully logged off
    ///     before returning from the method. If <c>false</c>, returns immediately, even though
    ///     the session may not be completely logged off yet.
    /// </param>
    void Logoff(bool synchronous);

    /// <overloads>
    ///     <summary>
    ///         Disconnects any attached user from the session.
    ///     </summary>
    /// </overloads>
    /// <summary>
    ///     Disconnects any attached user from the session.
    /// </summary>
    /// <remarks>
    ///     The disconnection takes place synchronously; this method returns after the operation is complete.
    ///     This is the same as calling <c>Disconnect(true)</c>.
    /// </remarks>
    void Disconnect();

    /// <summary>
    ///     Disconnects any attached user from the session.
    /// </summary>
    /// <param name="synchronous">
    ///     If <c>true</c>, waits until the session is fully disconnected
    ///     before returning from the method. If <c>false</c>, returns immediately, even though
    ///     the session may not be completely disconnected yet.
    /// </param>
    void Disconnect(bool synchronous);

    /// <overloads>
    ///     <summary>
    ///         Displays a message box in the session.
    ///     </summary>
    /// </overloads>
    /// <summary>
    ///     Displays a message box in the session.
    /// </summary>
    /// <param name="text">The text to display in the message box.</param>
    void MessageBox(string text);

    /// <summary>
    ///     Displays a message box in the session.
    /// </summary>
    /// <param name="text">The text to display in the message box.</param>
    /// <param name="caption">The caption of the message box.</param>
    void MessageBox(string text, string caption);

    /// <summary>
    ///     Displays a message box in the session.
    /// </summary>
    /// <param name="text">The text to display in the message box.</param>
    /// <param name="caption">The caption of the message box.</param>
    /// <param name="icon">The icon to display in the message box.</param>
    void MessageBox(string text, string caption, RemoteMessageBoxIcon icon);

    /// <summary>
    ///     Displays a message box in the session and returns the user's response to the message box.
    /// </summary>
    /// <param name="text">The text to display in the message box.</param>
    /// <param name="caption">The caption of the message box.</param>
    /// <param name="buttons">The buttons to display in the message box.</param>
    /// <param name="icon">The icon to display in the message box.</param>
    /// <param name="defaultButton">The button that should be selected by default in the message box.</param>
    /// <param name="options">Options for the message box.</param>
    /// <param name="timeout">
    ///     The amount of time to wait for a response from the user
    ///     before closing the message box. The system will wait forever if this is set to <c>TimeSpan.Zero</c>.
    ///     This will be treated as a integer number of seconds --
    ///     specifying <c>TimeSpan.FromSeconds(2.5)</c> will produce the same result as
    ///     <c>TimeSpan.FromSeconds(2)</c>.
    /// </param>
    /// <param name="synchronous">
    ///     If <c>true</c>, wait for and return the user's response to the
    ///     message box. Otherwise, return immediately.
    /// </param>
    /// <returns>
    ///     The user's response to the message box. If <paramref name="synchronous" />
    ///     is <c>false</c>, the method will always return <see cref="RemoteMessageBoxResult.Asynchronous" />.
    ///     If the timeout expired before the user responded to the message box, the result will be
    ///     <see cref="RemoteMessageBoxResult.Timeout" />.
    /// </returns>
    RemoteMessageBoxResult MessageBox(string text, string caption, RemoteMessageBoxButtons buttons,
        RemoteMessageBoxIcon icon, RemoteMessageBoxDefaultButton defaultButton, RemoteMessageBoxOptions options,
        TimeSpan timeout, bool synchronous);

    /// <summary>
    ///     Retreives a list of processes running in this session.
    /// </summary>
    /// <returns>A list of processes.</returns>
    IList<ITerminalServicesProcess> GetProcesses();

    /// <summary>
    ///     Starts remote control of the session.
    /// </summary>
    /// <param name="hotkey">The key to press to stop remote control of the session.</param>
    /// <param name="hotkeyModifiers">The modifiers for the key to press to stop remote control.s</param>
    /// <remarks>
    ///     This method can only be called while running in a remote session. It blocks until remote control
    ///     has ended, which could result from pressing the hotkey, logging off the target session,
    ///     or disconnecting the target session (among other things).
    /// </remarks>
    void StartRemoteControl(ConsoleKey hotkey, RemoteControlHotkeyModifiers hotkeyModifiers);

    /// <summary>
    ///     Stops remote control of the session. The session must be running on the local server.
    /// </summary>
    /// <remarks>
    ///     This method should be called on the session that is being shadowed, not on the session that
    ///     is shadowing.
    /// </remarks>
    void StopRemoteControl();

    /// <summary>
    ///     Connects this session to an existing session. Both sessions must be running on the local server.
    /// </summary>
    /// <param name="target">The session to which to connect.</param>
    /// <param name="password">
    ///     The password of the user logged on to the target session.
    ///     If the user logged on to the target session is the same as the user logged on to this session,
    ///     this parameter can be an empty string.
    /// </param>
    /// <param name="synchronous">
    ///     If <c>true</c>, waits until the operation has completed
    ///     before returning from the method. If <c>false</c>, returns immediately, even though
    ///     the operation may not be complete yet.
    /// </param>
    /// <remarks>
    ///     The user logged on to this session must have permissions to connect to the target session.
    /// </remarks>
    void Connect(ITerminalServicesSession target, string password, bool synchronous);
*)
  end;

  /// <summary>
  ///   Open a connection to a terminal server.
  /// </summary>
  /// <remarks>
  ///   To connect to the local machine, keep the servername empty
  /// </remarks>
  function OpenServer(const ServerName: string): IWtsServer;

implementation

uses
  System.Classes, Winapi.Windows;

type
  TWtsServerHandle = class(TInterfacedObject, IWtsServerHandle)
  private
  const
    HandleNotOpen = 0;
  var
    FHandle: TWtsHandle;
    FServerName: string;
  protected
    procedure Close;
    function GetHandle: TWtsHandle;
    function GetIsLocal: Boolean;
    function GetIsOpen: Boolean;
    function GetServerName: string;
    procedure Open;
  public
    constructor Create(const aServerName: string);
    destructor Destroy; override;
  end;

  TWtsObject = class(TInterfacedObject)
  strict private
    FServerHandle: IWtsServerHandle;
  strict protected
    function GetServerHandle: IWtsServerHandle;
  protected
    property ServerHandle: IWtsServerHandle read GetServerHandle;
  public
    constructor Create(aServerHandle: IWtsServerHandle);
  end;

  TWtsServer = class(TWtsObject, IWtsServer)
  protected
    function GetSession(SessionId: TWtsSessionId): IWtsSession;
    function GetSessions: IWtsSessions;
  end;

  TWtsSessions = class(TWtsObject, IWtsSessions)
  private
    FList: IInterfaceList;
    procedure DoList;
  protected
    function GetCount: Integer;
    function GetItems(Index: Integer): IWtsSession;
    function HasActiveSession: Boolean;
  public
    procedure AfterConstruction; override;
  end;

  TWtsSession = class(TWtsObject, IWtsSession)
  private
    FSessionId: TWtsSessionId;
    FWtsInfo: TWTSINFO;
    F_InfoSetOnCreate: Boolean;
    F_LoadedInfos: TWtsInfos;
    procedure EnsureInfo(aInfoClass: TWtsInfoClass);
    procedure InternalRefresh(aInfoClass: TWtsInfoClass);
    procedure RefreshSessionInfo;
  protected
    function GetConnectionState: TWtsConnectstate;
    function GetSessionId: TWtsSessionId;
    function GetWindowStationName: string;
    function GetUsername: string;
    function GetDomainName: string;
    procedure Refresh(Flags: TWtsInfos);
  public
    constructor Create(aServerHandle: IWtsServerHandle; aSessionId: TWtsSessionId); overload;
    constructor Create(aServerHandle: IWtsServerHandle; const aInfo: TWtsSessionInfo); overload;
  end;

// Public functiones

function OpenServer(const ServerName: string): IWtsServer;
begin
  Result := TWtsServer.Create(TWtsServerHandle.Create(ServerName));
end;

{ TWtsServerHandle }

procedure TWtsServerHandle.Close;
begin
  if FHandle <> HandleNotOpen then
  begin
    WTSCloseServer(FHandle);
    FHandle := HandleNotOpen;
  end;
end;

constructor TWtsServerHandle.Create(const aServerName: string);
begin
  if not WTSApiLibLoaded then
    raise Exception.Create('Wts library cannot be loaded');

  inherited Create;
  FServerName := aServerName;
end;

destructor TWtsServerHandle.Destroy;
begin
  Close;
  inherited;
end;

function TWtsServerHandle.GetHandle: TWtsHandle;
begin
  Result := FHandle;
end;

function TWtsServerHandle.GetIsLocal: Boolean;
begin
  Result := Length(FServerName) = 0;
end;

function TWtsServerHandle.GetIsOpen: Boolean;
begin
  Result := GetIsLocal or (FHandle <> HandleNotOpen);
end;

function TWtsServerHandle.GetServerName: string;
begin
  if GetIsLocal then
    Result := 'localhost'
  else
    Result := FServerName;
end;

procedure TWtsServerHandle.Open;
begin
  if not GetIsOpen then
    FHandle := WTSOpenServer(PChar(FServerName));
end;

{ TWtsObject }

constructor TWtsObject.Create(aServerHandle: IWtsServerHandle);
begin
  inherited Create;
  FServerHandle := aServerHandle;
end;

function TWtsObject.GetServerHandle: IWtsServerHandle;
begin
  Result := FServerHandle;
end;

{ TWtsServer }

function TWtsServer.GetSession(SessionId: TWtsSessionId): IWtsSession;
begin
  Result := TWtsSession.Create(ServerHandle, SessionId);
end;

function TWtsServer.GetSessions: IWtsSessions;
begin
  Result := TWtsSessions.Create(ServerHandle);
end;

{ TWtsSessions }

procedure TWtsSessions.AfterConstruction;
begin
  inherited;
  DoList;
end;

procedure TWtsSessions.DoList;
var
  pSI, pCurSI: PWTS_SESSION_INFO;
  iCount: DWORD;
begin
  FList := TInterfaceList.Create;

  ServerHandle.Open;
  if WTSEnumerateSessions(ServerHandle.Handle, 0, 1, @pSI, @iCount) then
  try
    pCurSI := pSI;
    while iCount > 0 do
    begin
      Dec(iCount);
      FList.Add( TWtsSession.Create(ServerHandle, pCurSI^) as IWtsSession );
      Inc(pCurSI);
    end;
  finally
    WTSFreeMemory(pSI);
  end;
end;

function TWtsSessions.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TWtsSessions.GetItems(Index: Integer): IWtsSession;
begin
  Result := FList[Index] as IWtsSession;
end;

function TWtsSessions.HasActiveSession: Boolean;
var
  I: Integer;
begin
  for I := 0 to GetCount - 1 do
    if GetItems(I).ConnectionState = TWtsConnectstate.WTSActive then
      Exit(True);

  Result := False;
end;

{ TWtsSession }

constructor TWtsSession.Create(aServerHandle: IWtsServerHandle; aSessionId:
    TWtsSessionId);
begin
  inherited Create(aServerHandle);
  FSessionId := aSessionId;
end;

constructor TWtsSession.Create(aServerHandle: IWtsServerHandle; const aInfo:
    TWtsSessionInfo);
begin
  Create(aServerHandle, aInfo.SessionId);
  FWtsInfo.State := aInfo.State;
  StrPLCopy(FWtsInfo.WinStationName, aInfo.pWinStationName, WINSTATIONNAME_LENGTH);
  F_InfoSetOnCreate := True;
end;

procedure TWtsSession.EnsureInfo(aInfoClass: TWtsInfoClass);
begin
  if not (aInfoClass in F_LoadedInfos) then
    InternalRefresh(aInfoClass);
end;

function TWtsSession.GetConnectionState: TWtsConnectstate;
begin
  if not F_InfoSetOnCreate then
    EnsureInfo(WTSSessionInfo);
  Result := FWtsInfo.State;
end;

function TWtsSession.GetDomainName: string;
begin
  EnsureInfo(WTSSessionInfo);
  Result := FWtsInfo.Domain;
end;

function TWtsSession.GetSessionId: TWtsSessionId;
begin
  Result := FSessionId;
end;

function TWtsSession.GetUsername: string;
begin
  EnsureInfo(WTSSessionInfo);
  Result := FWtsInfo.UserName;
end;

function TWtsSession.GetWindowStationName: string;
begin
  if not F_InfoSetOnCreate then
    EnsureInfo(WTSSessionInfo);
  Result := FWtsInfo.WinStationName;
end;

procedure TWtsSession.InternalRefresh(aInfoClass: TWtsInfoClass);
begin
  case aInfoClass of
//    WTSInitialProgram: ;
//    WTSApplicationName: ;
//    WTSWorkingDirectory: ;
//    WTSOEMId: ;
//    WTSSessionId: ;
//    WTSUserName: ;
//    WTSWinStationName: ;
//    WTSDomainName: ;
//    WTSConnectState: ;
//    WTSClientBuildNumber: ;
//    WTSClientName: ;
//    WTSClientDirectory: ;
//    WTSClientProductId: ;
//    WTSClientHardwareId: ;
//    WTSClientAddress: ;
//    WTSClientDisplay: ;
//    WTSClientProtocolType: ;
//    WTSIdleTime: ;
//    WTSLogonTime: ;
//    WTSIncomingBytes: ;
//    WTSOutgoingBytes: ;
//    WTSIncomingFrames: ;
//    WTSOutgoingFrames: ;
//    WTSClientInfo: ;
    WTSSessionInfo: RefreshSessionInfo;
//    WTSSessionInfoEx: ;
//    WTSConfigInfo: ;
//    WTSValidationInfo: ;
//    WTSSessionAddressV4: ;
//    WTSIsRemoteSession: ;
  else
    raise EWtsException.Create('Refresh of info class not supported');
  end;
  Include(F_LoadedInfos, aInfoClass);
end;

procedure TWtsSession.Refresh(Flags: TWtsInfos);
var
  f: TWtsInfoClass;
begin
  for f := Low(TWtsInfoClass) to High(TWtsInfoClass) do
    if f in Flags then
      InternalRefresh(f);
end;

procedure TWtsSession.RefreshSessionInfo;
var
  pSI: PWTSINFO;
  iByteCount: DWORD;
begin
  if WTSQuerySessionInformation(ServerHandle.Handle, FSessionId, WTSSessionInfo, @pSI, @iByteCount) then
  try
    FWtsInfo := pSI^;
  finally
    WTSFreeMemory(pSI);
  end;
end;

end.
