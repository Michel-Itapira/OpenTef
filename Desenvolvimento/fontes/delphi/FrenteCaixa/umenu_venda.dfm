object F_MenuVenda: TF_MenuVenda
  Left = 1759
  Top = 265
  Caption = 'OpenTef'
  ClientHeight = 441
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object PImagem: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 463
    Height = 200
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    Visible = False
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
  object PBotao: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 395
    Width = 463
    Height = 43
    Align = alBottom
    AutoSize = True
    BevelOuter = bvSpace
    TabOrder = 1
  end
  object PDados: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 256
    Width = 463
    Height = 41
    Align = alTop
    TabOrder = 2
    Visible = False
    object EDados: TEdit
      Left = 1
      Top = 1
      Width = 461
      Height = 39
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 23
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
    object LMensagem: TLabel
      Left = 1
      Top = 1
      Width = 461
      Height = 39
      Align = alClient
      ExplicitWidth = 3
      ExplicitHeight = 15
    end
  end
end
