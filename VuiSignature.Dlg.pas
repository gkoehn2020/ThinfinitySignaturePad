unit VuiSignature.Dlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfrmSignatureDlg = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetImage(aImage: TGraphic);
  end;

var
  frmSignatureDlg: TfrmSignatureDlg;

implementation

{$R *.dfm}

{ TfrmSignatureDlg }

procedure TfrmSignatureDlg.SetImage(aImage: TGraphic);
begin
  image1.Picture.Assign(aImage);
end;

end.
