unit ResizeCaptionU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  NCM: TNonClientMetrics;
  CaptionFont: TFont;
  ControlCanvas: TControlCanvas;
  BorderButtons, MinCaptionLen: Integer;
const
  CaptionOffset: array[0..4] of Byte = (8, 6, 4, 2, 2);
  ToolCaptionOffset: array[0..1] of Byte = (4, 0);
begin
  //All pointless if we have no caption bar
  if BorderStyle = bsNone then
    Exit;
  NCM.cbSize := SizeOf(NCM);
  SystemParametersInfo(
    SPI_GETNONCLIENTMETRICS, SizeOf(NCM), @NCM, Cardinal(False));
  CaptionFont := TFont.Create;
  try
    if BorderStyle in [bsToolWindow, bsSizeToolWin] then
      CaptionFont.Handle := CreateFontIndirect(NCM.lfSmCaptionFont)
    else
      CaptionFont.Handle := CreateFontIndirect(NCM.lfCaptionFont);
    ControlCanvas := TControlCanvas.Create;
    try
      ControlCanvas.Control := Self;
      ControlCanvas.Font := CaptionFont;
      BorderButtons := 0;
      //If the system menu is removed we get no border icons at all
      if biSystemMenu in Bordericons then
      begin
        Inc(BorderButtons); //we always have Close button, if anything
        if BorderStyle in [bsSingle, bsSizeable] then
        begin
          Inc(BorderButtons); //we have a system menu
          if [biMinimize, biMaximize] * Bordericons <> [] then
            Inc(BorderButtons, 2) //If one button is there the other is too
          else //Help button only there if min/max aren't
            if biHelp in Bordericons then
              Inc(BorderButtons);
        end
        else
        if (BorderStyle = bsDialog) and (biHelp in Bordericons) then
          Inc(BorderButtons);
      end;
      MinCaptionLen := ControlCanvas.TextWidth(Caption) + //caption text
        (BorderButtons * NCM.iCaptionWidth); //buttons
      if not (BorderStyle in [bsToolWindow, bsSizeToolWin]) then
        Inc(MinCaptionlen, CaptionOffset[BorderButtons])
      else
        Inc(MinCaptionlen, ToolCaptionOffset[BorderButtons]);
    finally
      ControlCanvas.Free
    end
  finally
    CaptionFont.Free
  end;
  if MinCaptionLen > ClientWidth then
    ClientWidth := MinCaptionLen;
end;

end.
