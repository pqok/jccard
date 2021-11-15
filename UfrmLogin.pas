unit UfrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DosMove, IdHashMessageDigest,
  IdHash,IdHTTP,IdIPWatch,HTTPApp,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  TfrmLogin = class(TForm)
    DosMove1: TDosMove;
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
function  frmLogin: TfrmLogin;

implementation

uses UCommFunction, superobject;

var
  ffrmLogin: TfrmLogin;

{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////
function  frmLogin: TfrmLogin;        {��̬�������庯��}
begin
  if ffrmLogin=nil then ffrmLogin:=TfrmLogin.Create(application.mainform);
  result:=ffrmLogin;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmLogin=self then ffrmLogin:=nil;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmLogin.BitBtn2Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TfrmLogin.BitBtn1Click(Sender: TObject);
var
  IdHTTP_Tmp1:TIdHTTP;
  RespData,RespData2:TStringStream;
  ssParam,ssParam2:TStringStream;
  SSLIO: TIdSSLIOHandlerSocketOpenSSL;

  aJson: ISuperObject;
  ss:string;
  grantCode:string;
begin
  //���ذ汾:indy_OpenSSL096m
  //https://indy.fulgan.com/SSL/Archive/

  //SuperObject(Json֧�ֿ�)����
  //https://github.com/ekapujiw2002/delphi7-json-parser-superobject
  
  IdHTTP_Tmp1:=TIdHTTP.Create(nil);
  //������
  //���������磬������HTTP�������ʱ���粻�ӳ�ʱ����һֱ����
  //���������磬���㲻�ӳ�ʱҲû����
  //IdHTTP_Tmp1.ReadTimeout:=2*1000;//����
  //IdHTTP_Tmp1.ConnectTimeout:=2*1000;//Connect��ʱ����//indy9�޸�����.��Ҫ��װindy10
  IdHTTP_Tmp1.HTTPOptions := IdHTTP_Tmp1.HTTPOptions + [hoKeepOrigProtocol]; //���������в�ʹ����Э��汾��Ч
  IdHTTP_Tmp1.Request.CustomHeaders.Values['authen-type'] := 'V2';
  IdHTTP_Tmp1.Request.ContentType:='application/json';

  SSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLIO.SSLOptions.Method:=sslvSSLv23;//sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1

  IdHTTP_Tmp1.IOHandler:=SSLIO;  

  RespData:=TStringStream.Create('');
  //"loginAccount": "13922202252"
  ssParam:=TStringStream.Create('{"clientId": "'+gClientId+'","loginAccount": "'+UTF8Encode(LabeledEdit1.Text)+'"}');

  try
    IdHTTP_Tmp1.Post(gBASE_URL+URL_Grant_Code,ssParam,RespData);
    ss:=UTF8Decode(RespData.DataString);//������Ϣ//IdHTTP��ͬ����
  except
    on E:Exception do
    begin
      MESSAGEDLG('�������:'+E.Message,mtError,[mbOK],0);
      ssParam.Free;
      RespData.Free;
      SSLIO.Close;
      IdHTTP_Tmp1.Disconnect;
      FreeAndNil(SSLIO);
      FreeAndNil(IdHTTP_Tmp1);
      exit;
    end;
  end;

  ssParam.Free;
  RespData.Free;

  aJson:=SO(ss);
  if (aJson['ok']<>nil) and (not aJson['ok'].AsBoolean) then//��V2
  begin
    MESSAGEDLG(aJson.N['message'].AsString,mtError,[mbOK],0);
    SSLIO.Close;
    IdHTTP_Tmp1.Disconnect;
    FreeAndNil(SSLIO);
    FreeAndNil(IdHTTP_Tmp1);
    exit;
  end;
  if (aJson['successful']<>nil) and (not aJson['successful'].AsBoolean) then//�ʺŲ���ȷ
  begin
    MESSAGEDLG(aJson.N['responseInfo.tips'].AsString,mtError,[mbOK],0);
    SSLIO.Close;
    IdHTTP_Tmp1.Disconnect;
    FreeAndNil(SSLIO);
    FreeAndNil(IdHTTP_Tmp1);
    exit;
  end;
  if not aJson.N['successful'].AsBoolean then
  begin
    MESSAGEDLG(ss,mtError,[mbOK],0);
    SSLIO.Close;
    IdHTTP_Tmp1.Disconnect;
    FreeAndNil(SSLIO);
    FreeAndNil(IdHTTP_Tmp1);
    exit;
  end;

  grantCode:=aJson.N['result.grantCode'].AsString;

  RespData2:=TStringStream.Create('');
  ssParam2:=TStringStream.Create('{"grantCode": "'+grantCode+'","password": "'+LabeledEdit2.Text+'","clientId": "'+gClientId+'"}');
  try
    IdHTTP_Tmp1.Post(gBASE_URL+URL_Token,ssParam2,RespData2);
    ss:=UTF8Decode(RespData2.DataString);//������Ϣ//IdHTTP��ͬ����
  except
    on E:Exception do
    begin
      MESSAGEDLG('�������:'+E.Message,mtError,[mbOK],0);
      ssParam2.Free;
      RespData2.Free;
      SSLIO.Close;
      IdHTTP_Tmp1.Disconnect;
      FreeAndNil(SSLIO);
      FreeAndNil(IdHTTP_Tmp1);
      exit;
    end;
  end;

  ssParam2.Free;
  RespData2.Free;

  SSLIO.Close;
  IdHTTP_Tmp1.Disconnect;
  FreeAndNil(SSLIO);
  FreeAndNil(IdHTTP_Tmp1);

  aJson:=SO(ss);
  if (aJson['successful']<>nil) and (not aJson['successful'].AsBoolean) then//�ʺŲ���ȷ
  begin
    MESSAGEDLG(aJson.N['responseInfo.debugInfo'].AsString,mtError,[mbOK],0);
    exit;
  end;
  if not aJson.N['successful'].AsBoolean then
  begin
    MESSAGEDLG(ss,mtError,[mbOK],0);
    exit;
  end;

  gAccessToken:=aJson.N['result.accessToken'].AsString;
  gUserId:=aJson.N['result.userId'].AsString;

  close;
end;

initialization
  ffrmLogin:=nil;

end.
