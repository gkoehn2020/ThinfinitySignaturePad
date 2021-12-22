unit VuiSignature.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vui.Signature.Pad,VuiSignature.Dlg;

type
  TfrmUIMain = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FSig : TVuiSignaturePad;
    procedure SignatureChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmUIMain: TfrmUIMain;

implementation

{$R *.dfm}

procedure TfrmUIMain.Button1Click(Sender: TObject);
begin
  FSig.Clear;
end;

procedure TfrmUIMain.Button2Click(Sender: TObject);
begin
  FSig.SaveToFile('');
end;

procedure TfrmUIMain.FormCreate(Sender: TObject);
begin
  FSig := TVuiSignaturePad.Create(Panel1);
  FSig.OnSignatureChanged := SignatureChanged;
end;

procedure TfrmUIMain.SignatureChanged(Sender: TObject);
begin
  frmSignatureDlg.SetImage(TGraphic(Sender));
  frmSignatureDlg.Show;
end;

end.
