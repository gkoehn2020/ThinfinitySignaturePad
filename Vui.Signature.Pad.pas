unit Vui.Signature.Pad;
{$WARN SYMBOL_PLATFORM OFF}
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls,VirtualUI_SDK,Soap.EncdDecd,Vcl.Imaging.pngimage,Vcl.Imaging.jpeg;

type
  TVuiSignaturePad = class
  private
    FSigRo: TJSObject;
    FFilename : string;
    FOnSignatureChanged: TNotifyEvent;
    function Base64ToImg(AData: String): TGraphic;
    function GetXTagDir: string;
    function GetHtmlDir: string;
  public
    constructor Create(AControl:TWinControl);
    destructor Destroy;override;
    procedure Clear;
    procedure SaveToFile(const AFilename:string);
    property  OnSignatureChanged:TNotifyEvent read FOnSignatureChanged write FOnSignatureChanged;
  end;

implementation

uses
  System.IOUtils
, System.NetEncoding
  ;

{ TVuiSignaturePad }

constructor TVuiSignaturePad.Create(AControl:TWinControl);
var
  lXtagDir: string;
  lHtmlDir: string;
begin
  var lAppName := ParamStr(0);
  lXtagDir := GetXTagDir;
  if lXtagDir <> '' then
    begin
      VirtualUI.HTMLDoc.CreateSessionURL('x-tag',lXtagDir);
      VirtualUI.HTMLDoc.LoadScript('/x-tag/x-tag-core.min.js','');
    end;

  lHtmlDir := GetHtmlDir;
  if lHtmlDir <> '' then
    begin
      VirtualUI.HTMLDoc.CreateSessionURL('HtmlToAdd', lHtmlDir);
      VirtualUI.HTMLDoc.ImportHTML('/HtmlToAdd/vui-signature-pad.html','');
    end;

  FSigRo := TJSObject.Create(AControl.Name);
  FSigRo.Properties.Add('data')
    .OnSet(TJSBinding.Create(
      procedure(const Parent: IJSObject; const Prop: IJSProperty)
      var
        Img : TGraphic;
        lData: string;
      begin
        lData := Prop.AsString;
        {2021-12-22 Property is coming in with spaces. Need to replace them with plus symbol.}
        lData := StringReplace(lData, ' ', '+', [rfReplaceAll]);
        {---}
        Img := Base64ToImg(lData);
        try
          if Assigned(OnSignatureChanged) then
            OnSignatureChanged(Img);
        finally
          Img.Free;
        end;
      end))
    .AsString := '';
  FSigRo.Events.Add('clear');
  FSigRo.Events.Add('save').AddArgument('type',JSDT_STRING);
  FSigRo.ApplyModel;
  VirtualUI.HTMLDoc.CreateComponent(AControl.Name,'vui-signature-pad',AControl.Handle);
end;

destructor TVuiSignaturePad.Destroy;
begin
  FSigRo := nil;
  inherited;
end;

function TVuiSignaturePad.GetHtmlDir: string;
var
  lBaseDir : string;
  lHtmlDirTest: string;
begin
  result := '';
  lBaseDir := ExtractFilePath(ParamStr(0));
  while (lBaseDir <> '') and (length(lBaseDir) > 2) do
    begin
      lHtmlDirTest := lBaseDir + 'html\';
      if DirectoryExists(lHtmlDirTest) then
        begin
          result := lHtmlDirTest;
          break;
        end;
      lBaseDir := ExtractFilePath(ExcludeTrailingBackSlash(lBaseDir));
    end;
end;

function TVuiSignaturePad.GetXTagDir: string;
var
  lBaseDir : string;
  lXtagDirTest: string;
begin
  result := '';
  lBaseDir := ExtractFilePath(ParamStr(0));
  while (lBaseDir <> '') and (length(lBaseDir) > 2) do
    begin
      lXtagDirTest := lBaseDir + 'x-tag\';
      if DirectoryExists(lXtagDirTest) then
        begin
          result := lXtagDirTest;
          break;
        end;
      lBaseDir := ExtractFilePath(ExcludeTrailingBackSlash(lBaseDir));
    end;
end;

function TVuiSignaturePad.Base64ToImg(AData: String): TGraphic;
var
  Input: TStringStream;
  Output: TBytesStream;
  Idx : Integer;
  Mime : string;
begin
  Result := nil;
  Idx := Pos(',',AData);
  if Idx > 0 then
    begin
      Mime := Copy(AData,1,idx-1);
      if Pos('png',Mime)>0 then
        Result := TPngImage.Create
      else
        Result := TJpegImage.Create;
      AData := Copy(AData,Idx+1,Length(AData));
      Input := TStringStream.Create(AData, TEncoding.ASCII);
      Output := TBytesStream.Create;
      try
        DecodeStream(Input, Output);
        Output.Position := 0;
        Result.LoadFromStream(Output);
      finally
        Input.Free;
        Output.Free;
      end;
    end;
end;

procedure TVuiSignaturePad.Clear;
begin
  FSigRo.Events['clear'].Fire;
end;

procedure TVuiSignaturePad.SaveToFile(const AFilename: string);
begin
  FFilename := AFilename;
  FSigRo.Events['save'].ArgumentAsString('type','png').Fire;
end;

end.
