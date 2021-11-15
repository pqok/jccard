unit UCommFunction;

interface
uses Windows{MAX_PATH},SysUtils{fileexists},ComObj{createcomobject},ActiveX{IPersistFile},ShlObj{IShellLink},Classes{TStrings};

const
  URL_Grant_Code='/uac/iuauthen/passwordSignOnGrant';
  URL_Token='/uac/authen/getAccessTokenByPassword';
  URL_GetUserFactory='/mes/common/userFactory/listMyFactory';
  URL_GetFactoryBaseUser='/mes/common/userFactory/getFactoryBaseUser';
  URL_updateFactoryBaseUser='/mes/common/userFactory/updateFactoryBaseUser';

var
  gBASE_URL:string;
  gClientId:string;
  gAccessToken:string;
  gUserId:string;
  gOrgCode:string;
  gStringGridRow:integer;

    //============================================== System Function ====================================================
    function Sys_GetDeviceNum(vid:Word; pid:Word; var pNum:LongInt):integer;stdcall;external 'hfrdapi.dll';

    function Sys_GetHidSerialNumberStr(deviceIndex:LongInt;
                                       vid:Word;
                                       pid:Word;
                                       deviceString:PChar;
                                       deviceStringLength:LongInt):integer;stdcall;external 'hfrdapi.dll';

    function Sys_Open(var device:Pointer;
                      index:LongInt;
                      vid:Word;
                      pid:Word):integer;stdcall;external 'hfrdapi.dll';

    //功能：读取读写卡器型号信息
    //原型：int WINAPI Sys_GetModel(HID_DEVICE?device,BYTE *pData, BYTE *pLen)
    function Sys_GetModel(device:Pointer;var pModel:Byte;var pModelLen:Byte):integer;stdcall;external 'hfrdapi.dll';

    //function Sys_IsOpen(device:Pointer):LongBool;stdcall;external 'hfrdapi.dll';

    function Sys_Close(var device:Pointer):integer;stdcall;external 'hfrdapi.dll';

    function Sys_SetLight(device:Pointer; color:Byte):integer;stdcall;external 'hfrdapi.dll';

    function Sys_SetBuzzer(device:Pointer; msec:Byte):integer;stdcall;external 'hfrdapi.dll';

    function Sys_SetAntenna(device:Pointer; mode:Byte):integer;stdcall;external 'hfrdapi.dll';

    function Sys_InitType(device:Pointer; workType:Byte):integer;stdcall;external 'hfrdapi.dll';
    

    //=============================================== M1 Function =======================================================
    function TyA_Request(device:Pointer; mode:Byte; var pTagType:Word):integer;stdcall;external 'hfrdapi.dll';

    function TyA_Anticollision(device:Pointer;
                               bcnt:Byte;
                               var pSnr:Byte;
                               var pLen:Byte):integer;stdcall;external 'hfrdapi.dll';

    function TyA_Select(device:Pointer;
                        var pSnr:Byte;
                        snrLen:Byte;
                        var pSak:Byte):integer;stdcall;external 'hfrdapi.dll';

    function TyA_Halt(device:Pointer):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Authentication2(device:Pointer;
                                    mode:Byte;
                                    block:Byte;
                                    var pKey:Byte):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Read(device:Pointer;
                         block:Byte;
                         var pData:Byte;
                         var pLen:Byte):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Write(device:Pointer; block:Byte; var pData:Byte):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_InitValue(device:Pointer; block:Byte; value:LongInt):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_ReadValue(device:Pointer; block:Byte; var pValue:LongInt):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Decrement(device:Pointer; block:Byte; value:LongInt):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Increment(device:Pointer; block:Byte; value:LongInt):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Restore(device:Pointer; block:Byte):integer;stdcall;external 'hfrdapi.dll';

    function TyA_CS_Transfer(device:Pointer; block:Byte):integer;stdcall;external 'hfrdapi.dll';
  
implementation


end.
