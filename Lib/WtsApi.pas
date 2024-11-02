unit WtsApi;

interface

  // See: https://docs.microsoft.com/en-us/windows/win32/api/wtsapi32/

uses
  Winapi.Windows;

const
  rdpapidll = 'Wtsapi32.dll';

  // Handle to use when quering local server
  WTS_CURRENT_SERVER_HANDLE  = 0;

  // From 'winsta.h'
//  WDPREFIX_LENGTH          =  12;
//  STACK_ADDRESS_LENGTH     = 128;
//  MAX_BR_NAME              =  65;
//  DIRECTORY_LENGTH         = 256;
//  INITIALPROGRAM_LENGTH    = 256;
  USERNAME_LENGTH          =  20;
  DOMAIN_LENGTH            =  17;
//  PASSWORD_LENGTH          =  14;
//  NASISPECIFICNAME_LENGTH  =  14;
//  NASIUSERNAME_LENGTH      =  47;
//  NASIPASSWORD_LENGTH      =  24;
//  NASISESSIONNAME_LENGTH   =  16;
//  NASIFILESERVER_LENGTH    =  47;

//  CLIENTDATANAME_LENGTH    =   7;
//  CLIENTNAME_LENGTH        =  20;
//  CLIENTADDRESS_LENGTH     =  30;
//  IMEFILENAME_LENGTH       =  32;
//  DIRECTORY_LENGTH         = 256;
//  CLIENTLICENSE_LENGTH     =  32;
//  CLIENTMODEM_LENGTH       =  40;
//  CLIENT_PRODUCT_ID_LENGTH =  32;
//  MAX_COUNTER_EXTENSIONS   =   2;
  WINSTATIONNAME_LENGTH    =  32;


type
  TS_HANDLE = THandle;

  TWTSOpenServerA = function(pServerName: PAnsiChar): TS_HANDLE; stdcall;
  TWTSOpenServerW = function(pServerName: PWideChar): TS_HANDLE; stdcall;
  TWTSCloseServer = procedure(aHandle: TS_HANDLE); stdcall;

var
  WTSOpenServerA: TWTSOpenServerA;
  WTSOpenServerW: TWTSOpenServerW;
  WTSOpenServerExA: TWTSOpenServerA;
  WTSOpenServerExW: TWTSOpenServerW;
  WTSCloseServer: TWTSCloseServer;

{$IFDEF UNICODE}
  WTSOpenServer: TWTSOpenServerW;
  WTSOpenServerEx: TWTSOpenServerW;
{$ELSE}
  WTSOpenServer: TWTSOpenServerA;
  WTSOpenServerEx: TWTSOpenServerA;
{$ENDIF}

type
  //  void WTSFreeMemory(
  //    IN PVOID pMemory
  //  );
  TWTSFreeMemory = procedure(pMemory: Pointer); stdcall;

var
  WTSFreeMemory: TWTSFreeMemory;

type
  //  typedef enum _WTS_CONNECTSTATE_CLASS {
  //    WTSActive,
  //    WTSConnected,
  //    WTSConnectQuery,
  //    WTSShadow,
  //    WTSDisconnected,
  //    WTSIdle,
  //    WTSListen,
  //    WTSReset,
  //    WTSDown,
  //    WTSInit
  //  } WTS_CONNECTSTATE_CLASS;
  TWTS_CONNECTSTATE_CLASS = (
      WTSActive,
      WTSConnected,
      WTSConnectQuery,
      WTSShadow,
      WTSDisconnected,
      WTSIdle,
      WTSListen,
      WTSReset,
      WTSDown,
      WTSInit);
  TWtsConnectstate = TWTS_CONNECTSTATE_CLASS;

  SESSION_ID = DWORD;

  //  typedef struct _WTS_SESSION_INFOA {
  //    DWORD                  SessionId;
  //    LPSTR                  pWinStationName;
  //    WTS_CONNECTSTATE_CLASS State;
  //  } WTS_SESSION_INFOA, *PWTS_SESSION_INFOA;
  TWTS_SESSION_INFOA = record
    SessionId: SESSION_ID;
    pWinStationName: PAnsiChar;
    State: TWTS_CONNECTSTATE_CLASS;
  end;
  PWTS_SESSION_INFOA = ^TWTS_SESSION_INFOA;

  TWTSEnumerateSessionsA = function(
      hServer: TS_HANDLE;
      Reserved: DWORD;
      Version: DWORD;
      ppSessionInfo: PWTS_SESSION_INFOA;
      pCount: PDWORD
    ): BOOL; stdcall;

  //  typedef struct _WTS_SESSION_INFOW {
  //    DWORD                  SessionId;
  //    LPWSTR                 pWinStationName;
  //    WTS_CONNECTSTATE_CLASS State;
  //  } WTS_SESSION_INFOW, *PWTS_SESSION_INFOW;
  TWTS_SESSION_INFOW = record
    SessionId: SESSION_ID;
    pWinStationName: PWideChar;
    State: TWTS_CONNECTSTATE_CLASS;
  end;
  PWTS_SESSION_INFOW = ^TWTS_SESSION_INFOW;

  TWTSEnumerateSessionsW = function(
      hServer: TS_HANDLE;
      Reserved: DWORD;
      Version: DWORD;
      ppSessionInfo: PWTS_SESSION_INFOW;
      pCount: PDWORD
    ): BOOL; stdcall;

{$IFDEF UNICODE}
  TWTS_SESSION_INFO = TWTS_SESSION_INFOW;
  PWTS_SESSION_INFO = PWTS_SESSION_INFOW;
{$ELSE}
  TWTS_SESSION_INFO = TWTS_SESSION_INFOA;
  PWTS_SESSION_INFO = PWTS_SESSION_INFOA;
{$ENDIF}

  TWtsSessionInfo = TWTS_SESSION_INFO;
  PWtsSessionInfo = PWTS_SESSION_INFO;

var
  WTSEnumerateSessionsA: TWTSEnumerateSessionsA;
  WTSEnumerateSessionsW: TWTSEnumerateSessionsW;
{$IFDEF UNICODE}
  WTSEnumerateSessions: TWTSEnumerateSessionsW;
{$ELSE}
  WTSEnumerateSessions: TWTSEnumerateSessionsA;
{$ENDIF}

type
  WTS_INFO_CLASS = (
      WTSInitialProgram,
      WTSApplicationName,
      WTSWorkingDirectory,
      WTSOEMId,
      WTSSessionId,
      WTSUserName,
      WTSWinStationName,
      WTSDomainName,
      WTSConnectState,
      WTSClientBuildNumber,
      WTSClientName,
      WTSClientDirectory,
      WTSClientProductId,
      WTSClientHardwareId,
      WTSClientAddress,
      WTSClientDisplay,
      WTSClientProtocolType,
      WTSIdleTime,
      WTSLogonTime,
      WTSIncomingBytes,
      WTSOutgoingBytes,
      WTSIncomingFrames,
      WTSOutgoingFrames,
      WTSClientInfo,
      WTSSessionInfo,
      WTSSessionInfoEx,
      WTSConfigInfo,
      WTSValidationInfo,
      WTSSessionAddressV4,
      WTSIsRemoteSession
    );
  TWtsInfoClass = WTS_INFO_CLASS;

  //  BOOL WTSQuerySessionInformationA(
  //    IN HANDLE         hServer,
  //    IN DWORD          SessionId,
  //    IN WTS_INFO_CLASS WTSInfoClass,
  //    LPSTR             *ppBuffer,
  //    DWORD             *pBytesReturned
  //  );
  TWTSQuerySessionInformationA = function(
      hServer: TS_HANDLE;
      SessionId: SESSION_ID;
      WTSInfoClass: WTS_INFO_CLASS;
      ppBuffer: PPAnsiChar;
      pBytesReturned: PDWORD
    ): BOOL; stdcall;

  //  BOOL WTSQuerySessionInformationW(
  //    IN HANDLE         hServer,
  //    IN DWORD          SessionId,
  //    IN WTS_INFO_CLASS WTSInfoClass,
  //    LPWSTR            *ppBuffer,
  //    DWORD             *pBytesReturned
  //  );
  TWTSQuerySessionInformationW = function(
      hServer: TS_HANDLE;
      SessionId: SESSION_ID;
      WTSInfoClass: WTS_INFO_CLASS;
      ppBuffer: PPWideChar;
      pBytesReturned: PDWORD
    ): BOOL; stdcall;

var
  WTSQuerySessionInformationA: TWTSQuerySessionInformationA;
  WTSQuerySessionInformationW: TWTSQuerySessionInformationW;
{$IFDEF UNICODE}
  WTSQuerySessionInformation: TWTSQuerySessionInformationW;
{$ELSE}
  WTSQuerySessionInformation: TWTSQuerySessionInformationA;
{$ENDIF}

type
  //  typedef struct _WTSINFOA {
  //    WTS_CONNECTSTATE_CLASS State;
  //    DWORD                  SessionId;
  //    DWORD                  IncomingBytes;
  //    DWORD                  OutgoingBytes;
  //    DWORD                  IncomingFrames;
  //    DWORD                  OutgoingFrames;
  //    DWORD                  IncomingCompressedBytes;
  //    DWORD                  OutgoingCompressedBy;
  //    CHAR                   WinStationName[WINSTATIONNAME_LENGTH];
  //    CHAR                   Domain[DOMAIN_LENGTH];
  //    CHAR                   UserName[USERNAME_LENGTH + 1];
  //    LARGE_INTEGER          ConnectTime;
  //    LARGE_INTEGER          DisconnectTime;
  //    LARGE_INTEGER          LastInputTime;
  //    LARGE_INTEGER          LogonTime;
  //    LARGE_INTEGER          CurrentTime;
  //  } WTSINFOA, *PWTSINFOA;
  TWTSINFOA = record
    State: TWTS_CONNECTSTATE_CLASS;
    SessionId: SESSION_ID;
    IncomingBytes: DWORD;
    OutgoingBytes: DWORD;
    IncomingFrames: DWORD;
    OutgoingFrames: DWORD;
    IncomingCompressedBytes: DWORD;
    OutgoingCompressedBy: DWORD;
    WinStationName: array[0..WINSTATIONNAME_LENGTH - 1] of AnsiChar;
    Domain: array[0..DOMAIN_LENGTH - 1] of AnsiChar;
    UserName: array[0..USERNAME_LENGTH] of AnsiChar;
    ConnectTime: LARGE_INTEGER;
    DisconnectTime: LARGE_INTEGER;
    LastInputTime: LARGE_INTEGER;
    LogonTime: LARGE_INTEGER;
    CurrentTime: LARGE_INTEGER;
  end;
  PWTSINFOA = ^TWTSINFOA;

  //  typedef struct _WTSINFOW {
  //    WTS_CONNECTSTATE_CLASS State;
  //    DWORD                  SessionId;
  //    DWORD                  IncomingBytes;
  //    DWORD                  OutgoingBytes;
  //    DWORD                  IncomingFrames;
  //    DWORD                  OutgoingFrames;
  //    DWORD                  IncomingCompressedBytes;
  //    DWORD                  OutgoingCompressedBytes;
  //    WCHAR                  WinStationName[WINSTATIONNAME_LENGTH];
  //    WCHAR                  Domain[DOMAIN_LENGTH];
  //    WCHAR                  UserName[USERNAME_LENGTH + 1];
  //    LARGE_INTEGER          ConnectTime;
  //    LARGE_INTEGER          DisconnectTime;
  //    LARGE_INTEGER          LastInputTime;
  //    LARGE_INTEGER          LogonTime;
  //    LARGE_INTEGER          CurrentTime;
  //  } WTSINFOW, *PWTSINFOW;
  TWTSINFOW = record
    State: TWTS_CONNECTSTATE_CLASS;
    SessionId: SESSION_ID;
    IncomingBytes: DWORD;
    OutgoingBytes: DWORD;
    IncomingFrames: DWORD;
    OutgoingFrames: DWORD;
    IncomingCompressedBytes: DWORD;
    OutgoingCompressedBy: DWORD;
    WinStationName: array[0..WINSTATIONNAME_LENGTH - 1] of WideChar;
    Domain: array[0..DOMAIN_LENGTH - 1] of WideChar;
    UserName: array[0..USERNAME_LENGTH] of WideChar;
    ConnectTime: LARGE_INTEGER;
    DisconnectTime: LARGE_INTEGER;
    LastInputTime: LARGE_INTEGER;
    LogonTime: LARGE_INTEGER;
    CurrentTime: LARGE_INTEGER;
  end;
  PWTSINFOW = ^TWTSINFOW;

{$IFDEF UNICODE}
  TWTSINFO = TWTSINFOW;
  PWTSINFO = PWTSINFOW;
{$ELSE}
  TWTSINFO = TWTSINFOA;
  PWTSINFO = PWTSINFOA;
{$ENDIF}

  function WTSApiLibLoaded: Boolean;
  procedure InitWTSApiLib;

implementation

var
  _loaded: boolean;
  _libhandle: THandle;

function WTSApiLibLoaded: Boolean;
begin
  Result := _loaded;
end;

procedure InitWTSApiLib;
begin
  if _loaded then Exit;

  _libhandle := LoadLibrary(rdpapidll);
  if _libhandle = 0 then Exit;

  // Open/closing server ref
  WTSOpenServerA := GetProcAddress(_libhandle, 'WTSOpenServerA');
  WTSOpenServerW := GetProcAddress(_libhandle, 'WTSOpenServerW');
  WTSOpenServerExA := GetProcAddress(_libhandle, 'WTSOpenServerExA');
  WTSOpenServerExW := GetProcAddress(_libhandle, 'WTSOpenServerExW');
{$IFDEF UNICODE}
  WTSOpenServer := WTSOpenServerW;
  WTSOpenServerEx := WTSOpenServerExW;
{$ELSE}
  WTSOpenServer := WTSOpenServerA;
  WTSOpenServerEx := WTSOpenServerExA;
{$ENDIF}
  WTSCloseServer := GetProcAddress(_libhandle, 'WTSCloseServer');

  // Globe memory free
  WTSFreeMemory := GetProcAddress(_libhandle, 'WTSFreeMemory');

  // Session enum
  WTSEnumerateSessionsA := GetProcAddress(_libhandle, 'WTSEnumerateSessionsA');
  WTSEnumerateSessionsW := GetProcAddress(_libhandle, 'WTSEnumerateSessionsW');
{$IFDEF UNICODE}
  WTSEnumerateSessions := WTSEnumerateSessionsW;
{$ELSE}
  WTSEnumerateSessions := WTSEnumerateSessionsA;
{$ENDIF}

  // session querying
  WTSQuerySessionInformationA := GetProcAddress(_libhandle, 'WTSQuerySessionInformationA');
  WTSQuerySessionInformationW := GetProcAddress(_libhandle, 'WTSQuerySessionInformationW');
{$IFDEF UNICODE}
  WTSQuerySessionInformation := WTSQuerySessionInformationW;
{$ELSE}
  WTSQuerySessionInformation := WTSQuerySessionInformationA;
{$ENDIF}

  _loaded := True;
end;

initialization

  _loaded := false;
  InitWTSApiLib;

end.
