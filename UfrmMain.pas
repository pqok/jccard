unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, Inifiles, IdHashMessageDigest,
  IdHash,IdHTTP,IdIPWatch,HTTPApp, DosMove, IdBaseComponent, IdComponent,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,StrUtils,
  ComCtrls, ActnList, LYLed, Menus;

type
  TfrmMain = class(TForm)
    StringGrid1: TStringGrid;
    DosMove1: TDosMove;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    LabeledEdit1: TLabeledEdit;
    BitBtn1: TBitBtn;
    LabeledEdit4: TLabeledEdit;
    Panel4: TPanel;
    ComboBox3: TComboBox;
    BitBtn2: TBitBtn;
    Panel5: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    Label3: TLabel;
    Panel6: TPanel;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    LYLed1: TLYLed;
    Label4: TLabel;
    ComboBox4: TComboBox;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BitBtn2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UCommFunction, superobject;

var
  g_hDevice:Pointer = Pointer(-1);  //Must init as -1

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
var
  ConfigIni:tinifile;
  selFactory,selProfessionType:integer;
  
  IdHTTP_Tmp1:TIdHTTP;
  SSLIO: TIdSSLIOHandlerSocketOpenSSL;
  RespData:TStringStream;
  ssParam:TStringStream;

  SS:STRING;
  aJson: ISuperObject;
  aSuperArray: TSuperArray;
  i:integer;
begin
  frmLogin.ShowModal;

  StringGrid1.Cells[0,0]:='帐号';
  StringGrid1.Cells[1,0]:='姓名';
  StringGrid1.Cells[2,0]:='手机号';
  StringGrid1.Cells[3,0]:='IC卡号';
  StringGrid1.Cells[4,0]:='userFactoryId';
  StringGrid1.ColWidths[0]:=1;//隐藏列
  StringGrid1.ColWidths[1]:=100;
  StringGrid1.ColWidths[2]:=100;
  StringGrid1.ColWidths[3]:=250;
  StringGrid1.ColWidths[4]:=1;//隐藏列

  StatusBar1.Panels[1].Text:=gBASE_URL;
  StatusBar1.Panels[2].Text:=gClientId;
  StatusBar1.Panels[3].Text:=gUserId;

  //加载工厂列表
  //[工厂代码]工厂名称
  IdHTTP_Tmp1:=TIdHTTP.Create(nil);
  
  IdHTTP_Tmp1.HTTPOptions := IdHTTP_Tmp1.HTTPOptions + [hoKeepOrigProtocol]; //必须有这行才使设置协议版本生效
  IdHTTP_Tmp1.Request.ContentType:='application/json';
  IdHTTP_Tmp1.Request.CustomHeaders.Values['authen-type'] := 'V2';
  IdHTTP_Tmp1.Request.CustomHeaders.Values['clientId'] := gClientId;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['accessToken'] := gAccessToken;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['userId'] := gUserId;

  SSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLIO.SSLOptions.Method:=sslvSSLv23;//sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1

  IdHTTP_Tmp1.IOHandler:=SSLIO;
  
  ssParam:=TStringStream.Create('');
  RespData:=TStringStream.Create('');
  
  try
    IdHTTP_Tmp1.Post(gBASE_URL+URL_GetUserFactory,ssParam,RespData);
    ss:=UTF8Decode(RespData.DataString);//返回信息//IdHTTP是同步的
  except
    on E:Exception do
    begin
      MESSAGEDLG('请求出错:'+E.Message,mtError,[mbOK],0);
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
  SSLIO.Close;
  IdHTTP_Tmp1.Disconnect;
  FreeAndNil(SSLIO);
  FreeAndNil(IdHTTP_Tmp1);

  aJson:=SO(ss);

  if not aJson.N['successful'].AsBoolean then
  begin
    MESSAGEDLG(ss,mtError,[mbOK],0);
    exit;
  end;
  
  ComboBox1.Clear;
  aSuperArray:= aJson['result.list'].AsArray;
  for i:=0 to  aSuperArray.Length-1 do
  begin
    ComboBox1.Items.Add('['+aSuperArray[i]['factoryNo'].AsString+']'+aSuperArray[i]['abbrName'].AsString);
  end;

  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  selFactory:=configini.ReadInteger('Interface','selFactory',0);{记录选择的工厂}
  selProfessionType:=configini.ReadInteger('Interface','selProfessionType',0);{记录选择的工种}

  configini.Free;

  ComboBox1.ItemIndex:=selFactory;
  ComboBox2.ItemIndex:=selProfessionType;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  configini.WriteInteger('Interface','selProfessionType',ComboBox2.ItemIndex);{记录选择的工种}
  configini.WriteInteger('Interface','selFactory',ComboBox1.ItemIndex);{记录选择的工厂}

  configini.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  gBASE_URL:=configini.ReadString('Interface','BASE_URL','https://qa-open.szzhijing.com');
  gClientId:=configini.ReadString('Interface','ClientId','5F9AD657CE4043A584EC4304322CFCA0');

  configini.Free;
  
  SetWindowLong(LabeledEdit4.Handle, GWL_STYLE, GetWindowLong(LabeledEdit4.Handle, GWL_STYLE) or ES_NUMBER);//只能输入数字
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  IdHTTP_Tmp1:TIdHTTP;
  SSLIO: TIdSSLIOHandlerSocketOpenSSL;
  RespData:TStringStream;
  ssParam:TStringStream;

  SS:STRING;
  aJson: ISuperObject;
  aSuperArray: TSuperArray;
  i:integer;
  s2:string;
  factoryNo:string;

  j:integer;

  ssName:string;
  ssPhone:string;
  ssProfessionType:string;
  ssStatus:string;
begin
  s2:=leftstr(ComboBox1.Text,pos(']',ComboBox1.Text));
  factoryNo:=StringReplace(s2,'[','',[rfReplaceAll, rfIgnoreCase]);
  factoryNo:=StringReplace(factoryNo,']','',[rfReplaceAll, rfIgnoreCase]);

  if trim(factoryNo)='' then
  begin
    MESSAGEDLG('请选择工厂!',mtError,[mbOK],0);
    exit;
  end;

  IdHTTP_Tmp1:=TIdHTTP.Create(nil);
  
  IdHTTP_Tmp1.HTTPOptions := IdHTTP_Tmp1.HTTPOptions + [hoKeepOrigProtocol]; //必须有这行才使设置协议版本生效
  IdHTTP_Tmp1.Request.ContentType:='application/json';
  IdHTTP_Tmp1.Request.CustomHeaders.Values['authen-type'] := 'V2';
  IdHTTP_Tmp1.Request.CustomHeaders.Values['clientId'] := gClientId;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['accessToken'] := gAccessToken;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['userId'] := gUserId;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['orgCode'] := factoryNo;

  SSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLIO.SSLOptions.Method:=sslvSSLv23;//sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1

  IdHTTP_Tmp1.IOHandler:=SSLIO;

  RespData:=TStringStream.Create('');

  ssStatus:=',{"attributeName":"status","rangeType":"EQUAL","targetValue":[1]}';
  
  if trim(LabeledEdit1.Text)<>'' then
    ssName:=',{"attributeName":"userName","rangeType":"INCLUDE","targetValue":["'+UTF8Encode(LabeledEdit1.Text)+'"]}';//EQUAL

  if trim(LabeledEdit4.Text)<>'' then
    ssPhone:=',{"attributeName":"mobile","rangeType":"EQUAL","targetValue":["'+UTF8Encode(LabeledEdit4.Text)+'"]}';

  if ComboBox2.ItemIndex<>0 then
    ssProfessionType:=',{"attributeName":"professionType","rangeType":"EQUAL","targetValue":["'+copy(ComboBox2.Text,2,1)+'"]}';

  ssParam:=TStringStream.Create('{"pageNO":-1,"pageSize":-1,"conditions":[{"attributeName":"factoryNo","rangeType":"EQUAL","targetValue":["'+factoryNo+'"]}'+ssStatus+ssName+ssPhone+ssProfessionType+'],"orderBy":[{"attributeName":"createTime","rankType":"DESC"}]}');

  try
    IdHTTP_Tmp1.Post(gBASE_URL+URL_GetFactoryBaseUser,ssParam,RespData);
    ss:=UTF8Decode(RespData.DataString);//返回信息//IdHTTP是同步的
  except
    on E:Exception do
    begin
      MESSAGEDLG('请求出错:'+E.Message,mtError,[mbOK],0);
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
  SSLIO.Close;
  IdHTTP_Tmp1.Disconnect;
  FreeAndNil(SSLIO);
  FreeAndNil(IdHTTP_Tmp1);

  aJson:=SO(ss);

  if not aJson.N['successful'].AsBoolean then
  begin
    MESSAGEDLG(ss,mtError,[mbOK],0);
    exit;
  end;

  {//员工信息
			"userFactoryId": "78DAB90F5C99453F9F1FB322BD05454D",
			"enduserId": "BB00880",
			"factoryNo": "3C57B03D4A6048C6ADD1DF0C6BFFA2E8",
			"isDefault": 1,
			"userName": "林浩",
			"mobile": 13922202252,
			"gender": 1,
			"professionType": 1,
			"identifierNo": "440508198107012017",
			"identifierType": 1,
			"identifierAddress": "",
			"contactAddress": "",
			"education": "",
			"cardNo": "",
			"bankName": "",
			"userIcon": "",
			"createTime": "2019-07-13 09:00:12",
			"createUser": "BB00880",
			"createSystem": "FEE6626701E14CD1BC4CF9CFC191FA95",
			"updateTime": "2019-07-13 09:00:12",
			"updateUser": "",
			"updateSystem": "",
			"status": 1,
			"icCard": "",
			"salaryWay": 1,
			"basicSalary": 1200
		}

  for j :=0  to StringGrid1.RowCount-1 do
  begin
    if j=0 then continue;
    
    StringGrid1.Rows[j].Clear;
  end;

  aSuperArray:= aJson['result.list'].AsArray;
  StringGrid1.RowCount:=aSuperArray.Length+1;
  for i:=0 to  aSuperArray.Length-1 do
  begin
    StringGrid1.Cells[0,i+1]:=aSuperArray[i]['enduserId'].AsString;
    StringGrid1.Cells[1,i+1]:=aSuperArray[i]['userName'].AsString;
    StringGrid1.Cells[2,i+1]:=aSuperArray[i]['mobile'].AsString;
    StringGrid1.Cells[3,i+1]:=aSuperArray[i].N['icCard'].AsString;
    StringGrid1.Cells[4,i+1]:=aSuperArray[i]['userFactoryId'].AsString;
  end;
end;

procedure TfrmMain.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  Panel2.Caption:=(Sender as TStringGrid).Cells[1,ARow];
  Panel3.Caption:=(Sender as TStringGrid).Cells[3,ARow];
  Panel6.Caption:=(Sender as TStringGrid).Cells[4,ARow];
  gStringGridRow:=ARow;
end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
const
  Data_Block_Address=5;//数据块地址
  Key_Block_Address=7;//数据块地址
  Key_B='FFFFFFFFFFFF';//KEY_B不改
  KEY_A_NEW='010203040506';//更改KEY_A
  KEY_A_OLD='000000000000';//更改KEY_A
  Key_Type_A=$60;
  Key_Type_B=$61;  
var
  IdHTTP_Tmp1:TIdHTTP;
  SSLIO: TIdSSLIOHandlerSocketOpenSSL;
  RespData:TStringStream;
  ssParam:TStringStream;

  SS:STRING;
  aJson: ISuperObject;
  s2:string;
  factoryNo:string;

   i,j{,m}:integer;
   word_temp:word;
   pSak_temp:byte;
   Read_Data_7_Len,Serial_Number_Len,Read_Data_5_Len:byte;
   buf_Serial_Number,buf_Read_Data_7,buf_Write_Data_7,buf_Read_Data_5:array[0..200] of byte;
   Serial_Number:Int64;

   buf_Write_Data,buf_Key_B:array[0..200] of byte;
   Write_Data:string;

   employee_name:string;
   Read_Data_7_Str,Read_Data_5_Str,employee_name_hex,employee_name_2:string;

   buf_Model:array[0..200] of byte;
   Model_Len:byte;

   Cart_Type_Code:byte;
   Cart_Type:string;
   
begin
  //===== Get card serial number and select card begin =====
  if Sys_GetModel(g_hDevice,buf_Model[0], Model_Len)<>0 then
  //if not Sys_IsOpen(g_hDevice)then//Check whether the reader is connected or not
  begin
    MESSAGEDLG('发卡器未连接!',mtError,[mbOK],0);
    exit;
  end;

  //Request
  if TyA_Request(g_hDevice, $52, word_temp)<>0 then
  begin
    MESSAGEDLG('寻卡失败!',mtError,[mbOK],0);
    exit;
  end;

  //Anticollision
  if TyA_Anticollision(g_hDevice, 0, buf_Serial_Number[0], Serial_Number_Len)<>0 then
  begin
    MESSAGEDLG('获取卡号失败!',mtError,[mbOK],0);
    exit;
  end;

  if Serial_Number_Len=4 then
  begin
    Serial_Number:=buf_Serial_Number[0]*16777216+buf_Serial_Number[1]*65536+buf_Serial_Number[2]*256+buf_Serial_Number[3]
  end else
  begin
    MESSAGEDLG('卡号非4字节!',mtError,[mbOK],0);
    exit;
  end;

  //Select card
  if TyA_Select(g_hDevice, buf_Serial_Number[0], 4, pSak_temp)<>0 then
  begin
    MESSAGEDLG('激活IC卡失败!',mtError,[mbOK],0);
    exit;
  end;

  for i:=0 to 5 do val('$'+midstr(Key_B,i*2+1,2),buf_Key_B[i],j);//KEY_B

  //Authentication
  if TyA_CS_Authentication2(g_hDevice, Key_Type_B, Key_Block_Address, buf_Key_B[0])<>0 then
  begin
    MESSAGEDLG('IC卡密码错误!',mtError,[mbOK],0);
    exit;
  end;

  //读数据区,避免误写在用卡begin
  if TyA_CS_Read(g_hDevice, Data_Block_Address, buf_Read_Data_5[0], Read_Data_5_Len)<>0 then
  begin
    MESSAGEDLG('读卡失败!',mtError,[mbOK],0);
    exit;
  end;
  
  Read_Data_5_Str := '';
  for i:=0 to Read_Data_5_Len-1 do begin
    Read_Data_5_Str := Read_Data_5_Str+inttohex(buf_Read_Data_5[i],2);
  end;

  Cart_Type_Code:=strtoint('$'+copy(Read_Data_5_Str,29,2));
  case Cart_Type_Code of
    1:Cart_Type:='[1]挡车工卡';
    2:Cart_Type:='[2]机修卡';
    3:Cart_Type:='[3]管理员卡';
    4:Cart_Type:='[4]超级权限卡';
    else
      Cart_Type:='['+inttostr(Cart_Type_Code)+']未知卡类别';
  end;

  employee_name_hex:=leftstr(Read_Data_5_Str,28);

  for i := 1 to (length(employee_name_hex) div 2) do
  begin
    j := strtoint('$' + employee_name_hex[2 * i - 1] + employee_name_hex[2 * i]);
    employee_name_2 := employee_name_2 + chr(j);
  end;

  if trim(employee_name_2)<>'' then
  begin
    if MESSAGEDLG('卡号【'+inttostr(Serial_Number)+'】有主人【'+trim(employee_name_2)+'】了！确定要重写吗？'+#$0D+#$0D+
                  '卡类别:'+Cart_Type+#$0D+
                  '权限:'+inttostr(strtoint('$'+copy(Read_Data_5_Str,31,2)))
                  ,mtWarning,[mbYes, mbNo],0) <> mrYes then exit;
  end;
  //读数据区,避免误写在用卡end

  if TyA_CS_Read(g_hDevice, Key_Block_Address, buf_Read_Data_7[0], Read_Data_7_Len)<>0 then
  begin
    MESSAGEDLG('读卡失败!',mtError,[mbOK],0);
    exit;
  end;

  Read_Data_7_Str := '';
  for i:=0 to Read_Data_7_Len-1 do begin
    Read_Data_7_Str := Read_Data_7_Str+inttohex(buf_Read_Data_7[i],2);
  end;
  
  if rightstr(Read_Data_7_Str,12)<>'010203040506' then//需要设置(写)key_a
  begin
    //Get the data to be written
    delete(Read_Data_7_Str,1,12);
    Read_Data_7_Str:='010203040506'+Read_Data_7_Str;

    for i:=0 to 15 do val('$'+midstr(Read_Data_7_Str,i*2+1,2),buf_Write_Data_7[i],j);

    // Write card--data block
    if TyA_CS_Write(g_hDevice, Key_Block_Address, buf_Write_Data_7[0])<>0 then
    begin
      MESSAGEDLG('Key写入失败!',mtError,[mbOK],0);
      exit;
    end;
  end;

  //Get the data to be written
  employee_name := Panel2.Caption;
  for i:=1 to Length(employee_name) do
    Write_Data := Write_Data +IntToHex(Ord(employee_name[i]),2);
  Write_Data:=leftstr(Write_Data+'0000000000000000000000000000',28);
  Write_Data:=Write_Data+IntToHex(strtoint(copy(ComboBox4.Text,2,1)),2);
  Write_Data:=Write_Data+IntToHex(strtoint(ComboBox3.Text),2);

  for i:=0 to 15 do val('$'+midstr(Write_Data,i*2+1,2),buf_Write_Data[i],j);

  // Write card--data block
  //m:=TyA_CS_Write(g_hDevice, Data_Block_Address, buf_Write_Data[0]);
  //showmessage(inttostr(m));
  //exit;
  if TyA_CS_Write(g_hDevice, Data_Block_Address, buf_Write_Data[0])<>0 then
  begin
    MESSAGEDLG('写入失败!',mtError,[mbOK],0);
    exit;
  end;

  s2:=leftstr(ComboBox1.Text,pos(']',ComboBox1.Text));
  factoryNo:=StringReplace(s2,'[','',[rfReplaceAll, rfIgnoreCase]);
  factoryNo:=StringReplace(factoryNo,']','',[rfReplaceAll, rfIgnoreCase]);

  if trim(factoryNo)='' then
  begin
    MESSAGEDLG('请选择工厂!',mtError,[mbOK],0);
    exit;
  end;
  
  if (trim(Panel6.Caption)='') or (Panel6.Caption='userFactoryId') then
  begin
    MESSAGEDLG('请选择有效用户!',mtError,[mbOK],0);
    exit;
  end;

  if Serial_Number<=0 then
  begin
    MESSAGEDLG('无效卡号!',mtError,[mbOK],0);
    exit;
  end;

  if (MessageDlg('确实要发卡？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then exit;

  IdHTTP_Tmp1:=TIdHTTP.Create(nil);
  
  IdHTTP_Tmp1.HTTPOptions := IdHTTP_Tmp1.HTTPOptions + [hoKeepOrigProtocol]; //必须有这行才使设置协议版本生效
  IdHTTP_Tmp1.Request.ContentType:='application/json';
  IdHTTP_Tmp1.Request.CustomHeaders.Values['authen-type'] := 'V2';
  IdHTTP_Tmp1.Request.CustomHeaders.Values['clientId'] := gClientId;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['accessToken'] := gAccessToken;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['userId'] := gUserId;
  IdHTTP_Tmp1.Request.CustomHeaders.Values['orgCode'] := factoryNo;

  SSLIO := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLIO.SSLOptions.Method:=sslvSSLv23;//sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1

  IdHTTP_Tmp1.IOHandler:=SSLIO;

  RespData:=TStringStream.Create('');

  ssParam:=TStringStream.Create('{"userFactoryId":"'+Panel6.Caption+'","icCard":"'+inttostr(Serial_Number)+'"}');

  try
    IdHTTP_Tmp1.Post(gBASE_URL+URL_updateFactoryBaseUser,ssParam,RespData);
    ss:=UTF8Decode(RespData.DataString);//返回信息//IdHTTP是同步的
  except
    on E:Exception do
    begin
      MESSAGEDLG('请求出错:'+E.Message,mtError,[mbOK],0);
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
  SSLIO.Close;
  IdHTTP_Tmp1.Disconnect;
  FreeAndNil(SSLIO);
  FreeAndNil(IdHTTP_Tmp1);

  aJson:=SO(ss);

  if (aJson['successful']<>nil) and (not aJson['successful'].AsBoolean) then
  begin
    MESSAGEDLG(aJson.N['responseInfo.tips'].AsString,mtError,[mbOK],0);
    exit;
  end;
  if not aJson.N['successful'].AsBoolean then
  begin
    MESSAGEDLG(ss,mtError,[mbOK],0);
    exit;
  end;

  StringGrid1.Cells[3,gStringGridRow]:=inttostr(Serial_Number);
  Panel3.Caption:=inttostr(Serial_Number);

  MESSAGEDLG('发卡成功!',mtInformation,[mbOK],0);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
//连接读卡器
var
  status:integer;

   buf_Model:array[0..200] of byte;
   Model_Len:byte;
begin
  if Sys_GetModel(g_hDevice,buf_Model[0], Model_Len)=0 then
  //if Sys_IsOpen(g_hDevice) then
  begin
    LYLed1.Value:=true;
    exit;
  end else
  begin
    LYLed1.Value:=false;
  end;
  
  //Connect
  status := Sys_Open(g_hDevice, 0, $0416, $8020);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '打开发卡器失败!';
      exit;
  end;

  //------------- Init the reader before operating the card -------------
  //Close antenna of the reader
  status := Sys_SetAntenna(g_hDevice, 0);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '关闭发卡器天线失败!';
      exit;
  end;
  Sleep(5); //Appropriate delay after Sys_SetAntenna operating

  //Set the reader's working mode
  status := Sys_InitType(g_hDevice, Byte('A'));
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '设置发卡器工作方式失败!';
      exit;
  end;
  Sleep(5); //Appropriate delay after Sys_InitType operating

  //Open antenna of the reader
  status := Sys_SetAntenna(g_hDevice, 1);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '打开发卡器天线失败!';
      exit;
  end;
  Sleep(5); //Appropriate delay after Sys_SetAntenna operating

  //---------------------------- Success Tips ----------------------------
  //Beep 200 ms
  status := Sys_SetBuzzer(g_hDevice, 20);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '设置发卡器蜂鸣器失败!';
      exit;
  end;

  StatusBar1.Panels[4].Text := 'Connect succeed !';
end;

procedure TfrmMain.N2Click(Sender: TObject);
//连接读卡器
var
  status:integer;

   buf_Model:array[0..200] of byte;
   Model_Len:byte;
begin
   //-------------------------- Connect reader -------------------------
  //Check whether the reader is connected or not
  //If the reader is already open , close it firstly
  if Sys_GetModel(g_hDevice,buf_Model[0], Model_Len)=0 then
  //if(true=Sys_IsOpen(g_hDevice))then
  begin
      status := Sys_Close(g_hDevice);
      if(status<>0)then
      begin
          StatusBar1.Panels[4].Text := '关闭发卡器失败!';
          exit;
      end;
  end;

  //Connect
  status := Sys_Open(g_hDevice, 0, $0416, $8020);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '打开发卡器失败!';
      exit;
  end;

  //------------- Init the reader before operating the card -------------
  //Close antenna of the reader
  status := Sys_SetAntenna(g_hDevice, 0);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '关闭发卡器天线失败!';
      exit;
  end;
  Sleep(5); //Appropriate delay after Sys_SetAntenna operating

  //Set the reader's working mode
  status := Sys_InitType(g_hDevice, Byte('A'));
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '设置发卡器工作方式失败!';
      exit;
  end;
  Sleep(5); //Appropriate delay after Sys_InitType operating

  //Open antenna of the reader
  status := Sys_SetAntenna(g_hDevice, 1);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '打开发卡器天线失败!';
      exit;
  end;
  Sleep(5); //Appropriate delay after Sys_SetAntenna operating

  //---------------------------- Success Tips ----------------------------
  //Beep 200 ms
  status := Sys_SetBuzzer(g_hDevice, 20);
  if(status<>0)then
  begin
      StatusBar1.Panels[4].Text := '设置发卡器蜂鸣器失败!';
      exit;
  end;

  StatusBar1.Panels[4].Text := 'Connect succeed !';
end;

procedure TfrmMain.N3Click(Sender: TObject);
const
  Data_Block_Address=5;//数据块地址
  Key_Block_Address=7;//数据块地址
  Key_B='FFFFFFFFFFFF';//KEY_B不改
  Key_Type_B=$61;  
var
   word_temp:word;
   buf_Serial_Number,buf_Read_Data_5,buf_Key_B:array[0..200] of byte;
   Read_Data_5_Len,Serial_Number_Len:byte;
   Serial_Number:Int64;

   i,j:integer;
   pSak_temp:byte;

   Read_Data_5_Str,employee_name_hex,employee_name:string;
   Cart_Type:string;
   Cart_Type_Code:byte;

   buf_Model:array[0..200] of byte;
   Model_Len:byte;

   SS:STRING;
begin
  //===== Get card serial number and select card begin =====
  if Sys_GetModel(g_hDevice,buf_Model[0], Model_Len)<>0 then
  //if not Sys_IsOpen(g_hDevice)then//Check whether the reader is connected or not
  begin
    MESSAGEDLG('发卡器未连接!',mtError,[mbOK],0);
    exit;
  end;

  for i := 0 to Model_Len-1 do ss:=ss+char(buf_Model[i]);
  ShowMessage ('读卡器类型:'+SS);

  //Request
  if TyA_Request(g_hDevice, $52, word_temp)<>0 then
  begin
    MESSAGEDLG('寻卡失败!',mtError,[mbOK],0);
    exit;
  end;

  //Anticollision
  if TyA_Anticollision(g_hDevice, 0, buf_Serial_Number[0], Serial_Number_Len)<>0 then
  begin
    MESSAGEDLG('获取卡号失败!',mtError,[mbOK],0);
    exit;
  end;

  if Serial_Number_Len=4 then
  begin
    Serial_Number:=buf_Serial_Number[0]*16777216+buf_Serial_Number[1]*65536+buf_Serial_Number[2]*256+buf_Serial_Number[3]
  end else
  begin
    MESSAGEDLG('卡号非4字节!',mtError,[mbOK],0);
    exit;
  end;

  //Select card
  if TyA_Select(g_hDevice, buf_Serial_Number[0], 4, pSak_temp)<>0 then
  begin
    MESSAGEDLG('激活IC卡失败!',mtError,[mbOK],0);
    exit;
  end;

  for i:=0 to 5 do val('$'+midstr(Key_B,i*2+1,2),buf_Key_B[i],j);//KEY_B

  //Authentication
  if TyA_CS_Authentication2(g_hDevice, Key_Type_B, Key_Block_Address, buf_Key_B[0])<>0 then
  begin
    MESSAGEDLG('IC卡密码错误!',mtError,[mbOK],0);
    exit;
  end;

  if TyA_CS_Read(g_hDevice, Data_Block_Address, buf_Read_Data_5[0], Read_Data_5_Len)<>0 then
  begin
    MESSAGEDLG('读卡失败!',mtError,[mbOK],0);
    exit;
  end;
  
  Read_Data_5_Str := '';
  for i:=0 to Read_Data_5_Len-1 do begin
    Read_Data_5_Str := Read_Data_5_Str+inttohex(buf_Read_Data_5[i],2);
  end;

  Cart_Type_Code:=strtoint('$'+copy(Read_Data_5_Str,29,2));
  case Cart_Type_Code of
    1:Cart_Type:='[1]挡车工卡';
    2:Cart_Type:='[2]机修卡';
    3:Cart_Type:='[3]管理员卡';
    4:Cart_Type:='[4]超级权限卡';
    else
      Cart_Type:='['+inttostr(Cart_Type_Code)+']未知卡类别';
  end;

  employee_name_hex:=leftstr(Read_Data_5_Str,28);

  for i := 1 to (length(employee_name_hex) div 2) do
  begin
    j := strtoint('$' + employee_name_hex[2 * i - 1] + employee_name_hex[2 * i]);
    employee_name := employee_name + chr(j);
  end;

  MESSAGEDLG('卡号:'+inttostr(Serial_Number)+#$0D+
             '卡类别:'+Cart_Type+#$0D+
             '权限:'+inttostr(strtoint('$'+copy(Read_Data_5_Str,31,2)))+#$0D+
             '姓名:'+employee_name
             ,mtInformation,[mbOK],0);
end;

end.
