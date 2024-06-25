object F_MenuVenda: TF_MenuVenda
  Left = 0
  Top = 0
  Caption = 'OpenTef'
  ClientHeight = 441
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PBotao: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 395
    Width = 463
    Height = 43
    Align = alBottom
    AutoSize = True
    BevelOuter = bvSpace
    TabOrder = 0
    ExplicitLeft = -16
    ExplicitTop = 256
  end
  object PDados: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 256
    Width = 463
    Height = 41
    Align = alTop
    TabOrder = 1
    Visible = False
    ExplicitLeft = -16
    ExplicitTop = 258
    object EDados: TEdit
      Left = 1
      Top = 1
      Width = 461
      Height = 39
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 21
    end
  end
  object PImagem: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 463
    Height = 200
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    Visible = False
    ExplicitLeft = -16
    object Imagem: TImage
      Left = 1
      Top = 1
      Width = 461
      Height = 177
      Align = alTop
      ExplicitLeft = 104
      ExplicitTop = -136
      ExplicitWidth = 273
    end
  end
  object PMensagem: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 209
    Width = 463
    Height = 41
    Align = alTop
    TabOrder = 3
    Visible = False
    ExplicitLeft = -16
    object LMensagem: TLabel
      Left = 1
      Top = 1
      Width = 461
      Height = 39
      Align = alClient
      ExplicitWidth = 3
      ExplicitHeight = 13
    end
  end
end
