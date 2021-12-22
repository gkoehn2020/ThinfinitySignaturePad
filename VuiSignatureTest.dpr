program VuiSignatureTest;

uses
  VirtualUI_AutoRun,
  Vcl.Forms,
  VuiSignature.Main in 'VuiSignature.Main.pas' {frmUIMain},
  Vui.Signature.Pad in 'Vui.Signature.Pad.pas',
  VuiSignature.Dlg in 'VuiSignature.Dlg.pas' {frmSignatureDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmUIMain, frmUIMain);
  Application.CreateForm(TfrmSignatureDlg, frmSignatureDlg);
  Application.Run;
end.
