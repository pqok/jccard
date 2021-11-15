program jccard;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UfrmLogin in 'UfrmLogin.pas' {frmLogin},
  UCommFunction in 'UCommFunction.pas',
  superobject in 'superobject.pas',
  supertypes in 'supertypes.pas',
  superdate in 'superdate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
