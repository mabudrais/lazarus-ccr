unit lazedit_translations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TTranslations }

  TTranslations = class(TObject)
  public
    { Main form }
    {  mnuEditPasteTableContentTab: TMenuItem;
      mnuEditPasteSpecial: TMenuItem;
      mnuAbout: TMenuItem;
      mnuViewFont: TMenuItem;}
    //File menu
    mnuFile,
      mnuFileOpen,
      mnuFileNewFromTemplate,
      mnuFileNew,
        mnuFileNewText,
{        mnuFileNewHtml: TMenuItem;
        mnuFileNewXml: TMenuItem;
        mnuFileNewCss: TMenuItem;
        mnuFileNewJS: TMenuItem;
        mnuFileNewFpc: TMenuItem;
        mnuFileNewC: TMenuItem;
        mnuFileNewPy: TMenuItem;
        mnuFileNewPhp: TMenuItem;
        mnuFileNewPerl: TMenuItem;
        mnuFileNewShellScript: TMenuItem;
        mnuFileNewBat: TMenuItem;
        mnuFileNewIni: TMenuItem;}
      mnuFileSave,
      mnuFileSaveAs,
      mnuFileSaveAll,
      mnuFileCloseCurrent,
      //mnuSep1: TMenuItem;
      mnuFileOpenInBrowser,
      //mnuSepAboveMru: TMenuItem;
      mnuFileCloseApp: string;
    //Edit menu
    mnuEdit,
      mnuEditUndo,
      mnuEditRedo,
      //mnuSep11: TMenuItem;
      mnuEditCopy,
      mnuEditCut,
      mnuEditPaste,
      mnuEditSelectAll,
      //mnuSep12: TMenuItem;
      mnuEditReplace,
      mnuEditFindNext,
      mnuEditFind: string;
    //Insert menu
    mnuHTMLTools,
     mnuInsertAnchor,
{    mnuInsertList,
      mnuInsertUList: TMenuItem;
      mnuInsertNList: TMenuItem;
      mnuInsertWordList: TMenuItem;
      mnuInsetListItem: TMenuItem;
      mnuInsertWordTerm: TMenuItem;
      mnuInsertWordDefinition: TMenuItem;
    mnuInsertTable: TMenuItem;
      mnInsertNewTable: TMenuItem;
      mnuInsertTableCell: TMenuItem;
      mnuInsertTableRow: TMenuItem;
    mnuInsertPicture: TMenuItem;
    mnuInsertSpecialChars: TMenuItem;
    mnuInsertLineBreak: TMenuItem;
    mnuInsertSep1: TMenuItem;
    mnuInsertHtmlComment: TMenuItem;
    mnuInsertJS: TMenuItem;
    mnuInsertCssStyle: TMenuItem;}
    //Layout menu
    mnuLayout,
      mnuLayoutBold,
      mnuLayoutAlignJustify,
      mnuLayoutItalic,
      mnuLayoutUnderline,
      mnuLayoutSub,
      mnuLayoutSup,
      mnuLayoutEmphasis,
      mnuLayoutStrong,
      mnuLayoutHeadings,
{        mnuLayoutH1: TMenuItem;
        mnuLayoutH2: TMenuItem;
        mnuLayoutH3: TMenuItem;
        mnuLayoutH4: TMenuItem;
        mnuLayoutH5: TMenuItem;
        mnuLayoutH6: TMenuItem;
      mnuLayoutAlign: TMenuItem;
        mnuLayoutAlignLeft: TMenuItem;
        mnuLayoutAlignRight: TMenuItem;
        mnuLayoutAlignCenter: TMenuItem;
      mnuLayoutCode: TMenuItem;
      mnuLayoutQuote: TMenuItem;
      mnuLayoutBlockQuote: TMenuItem;
      mnuLayoutPreformatted: TMenuItem;}
    //Grouping menu
    mnuGrouping,
      mnuGroupingParagraph,
      mnuGroupingDiv,
      mnuGroupingSpan,
    //View menu
    mnuView,
      mnuViewFontsize: string;
{        mnuViewFontSizeUp: TMenuItem;
        mnuViewFontsizeDown: TMenuItem;
      mnuViewHighlighter: TMenuItem;
        //these menu items MUST have names that are built like this:
        //'mnuViewHL' + eftNames[SomeIndex]
        mnuViewHLeftNone: TMenuItem;
        mnuViewHLeftHtml: TMenuItem;
        mnuViewHLeftXml: TMenuItem;
        mnuViewHLeftCss: TMenuItem;
        mnuViewHLeftJS: TMenuItem;
        mnuViewHLeftFpc: TMenuItem;
        mnuViewHLeftLfm: TMenuItem;
        mnuViewHLeftC: TMenuItem;
        mnuViewHLeftPy: TMenuItem;
        mnuViewHLeftPhp: TMenuItem;
        mnuViewHLeftPerl: TMenuItem;
        mnuViewHLeftUNIXShell: TMenuItem;
        mnuViewHLeftBat: TMenuItem;
        mnuViewHLeftDiff: TMenuItem;
        mnuViewHLeftIni: TMenuItem;
        mnuViewHLeftPo: TMenuItem;
    //Popup menus
    //Popup menu for editor
    EditorPopupMenu: TPopupMenu;
      mnuEditPopupSelectAll: TMenuItem;
      mnuEditPopupPaste: TMenuItem;
      mnuEditPopupCut: TMenuItem;
      mnuEditPopupCopy: TMenuItem;
    //Dropdownmenu for HeadingBtn
    HeadingDropDownMenu: TPopupMenu;
      mnuPopupLayoutH6: TMenuItem;
      mnuPopupLayoutH5: TMenuItem;
      mnuPopupLayoutH4: TMenuItem;
      mnuPopupLayoutH3: TMenuItem;
      mnuPopupLayoutH2: TMenuItem;
      mnuPopupLayoutH1: TMenuItem;   }
    { About box strings }
//    lpSupport, lpSupportInfo, lpLicense, lpLicenseInfo, lpAuthors,
//     lpContributorsTitle, lpAboutWindow, lpClose, lpInformation: string;
    { Methods }
    procedure TranslateToEnglish;
    procedure TranslateToDutch;
    procedure TranslateToPortuguese;
    procedure TranslateToLanguageID(AID: Integer);
  end;

var
  vTranslations: TTranslations;

implementation

{ TTranslations }

procedure TTranslations.TranslateToEnglish;
begin
  mnuFile := 'File';
    mnuFileOpen := 'Open';
    mnuFileNewFromTemplate := 'New from template ...';
    mnuFileNew := 'New';
  {        mnuFileNewText,
      mnuFileNewHtml: TMenuItem;
      mnuFileNewXml: TMenuItem;
      mnuFileNewCss: TMenuItem;
      mnuFileNewJS: TMenuItem;
      mnuFileNewFpc: TMenuItem;
      mnuFileNewC: TMenuItem;
      mnuFileNewPy: TMenuItem;
      mnuFileNewPhp: TMenuItem;
      mnuFileNewPerl: TMenuItem;
      mnuFileNewShellScript: TMenuItem;
      mnuFileNewBat: TMenuItem;
      mnuFileNewIni: TMenuItem;}
    mnuFileSave := 'Save';
    mnuFileSaveAs := 'Save as';
    mnuFileSaveAll := 'Save all';
    mnuFileCloseCurrent := 'Close current';
    //mnuSep1: TMenuItem;
    mnuFileOpenInBrowser := 'Open in browser';
    //mnuSepAboveMru: TMenuItem;
    mnuFileCloseApp := 'Close application';
  //Edit menu
  mnuEdit := 'Edit';
    mnuEditUndo := 'Undo';
    mnuEditRedo := 'Redo';
    //mnuSep11: TMenuItem;
    mnuEditCopy := 'Copy';
    mnuEditCut := 'Cut';
    mnuEditPaste := 'Paste';
    //mnuEditPasteSpecial := 'Plakken speciaal';
    mnuEditSelectAll := 'Select all';
    //mnuSep12: TMenuItem;
    mnuEditReplace := '&Replace';
    mnuEditFindNext := 'Find &Next';
    mnuEditFind := '&Find';
  //HTML Tools menu
  mnuHTMLTools := '&HTML Tools';
    mnuInsertAnchor := 'Insert Hyperlink';
  {    mnuInsertList,
      mnuInsertUList: TMenuItem;
      mnuInsertNList: TMenuItem;
      mnuInsertWordList: TMenuItem;
      mnuInsetListItem: TMenuItem;
      mnuInsertWordTerm: TMenuItem;
      mnuInsertWordDefinition: TMenuItem;
    mnuInsertTable: TMenuItem;
      mnInsertNewTable: TMenuItem;
      mnuInsertTableCell: TMenuItem;
      mnuInsertTableRow: TMenuItem;
    mnuInsertPicture: TMenuItem;
    mnuInsertSpecialChars: TMenuItem;
    mnuInsertLineBreak: TMenuItem;
    mnuInsertSep1: TMenuItem;
    mnuInsertHtmlComment: TMenuItem;
    mnuInsertJS: TMenuItem;
    mnuInsertCssStyle: TMenuItem;}
    //Layout menu
    mnuLayout := '&Layout';
      mnuLayoutBold := 'Bold';
      mnuLayoutItalic := 'Italic';
      mnuLayoutUnderline := 'Underline';
      mnuLayoutSub := 'Subscript';
      mnuLayoutSup := 'Superscript';
      mnuLayoutEmphasis := 'Emphasis';
      mnuLayoutStrong := 'Strong';
      mnuLayoutHeadings := 'Headings';
  {        mnuLayoutH1: TMenuItem;
        mnuLayoutH2: TMenuItem;
        mnuLayoutH3: TMenuItem;
        mnuLayoutH4: TMenuItem;
        mnuLayoutH5: TMenuItem;
        mnuLayoutH6: TMenuItem;
      mnuLayoutAlign: TMenuItem;
        mnuLayoutAlignLeft: TMenuItem;
        mnuLayoutAlignRight: TMenuItem;
        mnuLayoutAlignCenter: TMenuItem;
        mnuLayoutAlignJustify := 'Volledig uitlijnen';
      mnuLayoutCode: TMenuItem;
      mnuLayoutQuote: TMenuItem;
      mnuLayoutBlockQuote: TMenuItem;
      mnuLayoutPreformatted: TMenuItem;}
    //Grouping menu
    mnuGrouping := '&Grouping';
      mnuGroupingParagraph := 'Paragraph';
      mnuGroupingDiv := 'Div';
      mnuGroupingSpan := 'Span';
  //View menu
  mnuView := '&View';
    mnuViewFontsize := '&Font Size';
end;

procedure TTranslations.TranslateToDutch;
begin
  mnuFile := 'Bestand';
    mnuFileOpen := 'Open';
    mnuFileNewFromTemplate := 'Nieuw van sjabloon ...';
    mnuFileNew := 'Open';
      mnuFileNewText := 'Leeg blad';
{      mnuFileNewHtml: TMenuItem;
      mnuFileNewXml: TMenuItem;
      mnuFileNewCss: TMenuItem;
      mnuFileNewJS: TMenuItem;
      mnuFileNewFpc: TMenuItem;
      mnuFileNewC: TMenuItem;
      mnuFileNewPy: TMenuItem;
      mnuFileNewPhp: TMenuItem;
      mnuFileNewPerl: TMenuItem;
      mnuFileNewShellScript: TMenuItem;
      mnuFileNewBat: TMenuItem;
      mnuFileNewIni: TMenuItem;}
    mnuFileSave := 'Op&slaan';
    mnuFileSaveAs := 'Opslaan &als ...';
    mnuFileSaveAll := '&Alles opslaan';
    mnuFileCloseCurrent := 'Sl&uiten';
    //mnuSep1: TMenuItem;
    mnuFileOpenInBrowser := 'Open in &browser';
    //mnuSepAboveMru: TMenuItem;
    mnuFileCloseApp := 'Afsluiten';
  //Edit menu
  mnuEdit := 'Be&werken';
    mnuEditUndo := '&Ongedaan maken';
    mnuEditRedo := '&Herhalen';
    //mnuSep11: TMenuItem;
    mnuEditCopy := '&Kopiëren';
    mnuEditCut := 'K&nippen';
    mnuEditPaste := '&Plakken';
    //mnuEditPasteSpecial := 'Plakken speciaal';
    mnuEditSelectAll := '&Alles selecteren';
    //mnuSep12: TMenuItem;
    mnuEditReplace := 'Ve&rvangen';
    mnuEditFindNext := '&Volgende zoeken';
    mnuEditFind := '&Zoeken';
  //Insert menu
  mnuHTMLTools := '&HTML Tools';
    mnuInsertAnchor := 'Hyperlink invoegen';
  {    mnuInsertList,
      mnuInsertUList: TMenuItem;
      mnuInsertNList: TMenuItem;
      mnuInsertWordList: TMenuItem;
      mnuInsetListItem: TMenuItem;
      mnuInsertWordTerm: TMenuItem;
      mnuInsertWordDefinition: TMenuItem;
    mnuInsertTable: TMenuItem;
      mnInsertNewTable: TMenuItem;
      mnuInsertTableCell: TMenuItem;
      mnuInsertTableRow: TMenuItem;
    mnuInsertPicture: TMenuItem;
    mnuInsertSpecialChars: TMenuItem;
    mnuInsertLineBreak: TMenuItem;
    mnuInsertSep1: TMenuItem;
    mnuInsertHtmlComment: TMenuItem;
    mnuInsertJS: TMenuItem;
    mnuInsertCssStyle: TMenuItem;}
    //Layout menu
    mnuLayout := '&Opmaak';
      mnuLayoutBold := 'Vet';
      mnuLayoutItalic := 'Cursief';
      mnuLayoutUnderline := 'Onderstreept';
      mnuLayoutSub := 'Subscript';
      mnuLayoutSup := 'Superscript';
      mnuLayoutEmphasis := 'Nadruk';
      mnuLayoutStrong := 'Sterke nadruk';
      mnuLayoutHeadings := 'Kop';
  {        mnuLayoutH1: TMenuItem;
        mnuLayoutH2: TMenuItem;
        mnuLayoutH3: TMenuItem;
        mnuLayoutH4: TMenuItem;
        mnuLayoutH5: TMenuItem;
        mnuLayoutH6: TMenuItem;
      mnuLayoutAlign: TMenuItem;
        mnuLayoutAlignLeft: TMenuItem;
        mnuLayoutAlignRight: TMenuItem;
        mnuLayoutAlignCenter: TMenuItem;
        mnuLayoutAlignJustify := 'Volledig uitlijnen';
      mnuLayoutCode: TMenuItem;
      mnuLayoutQuote: TMenuItem;
      mnuLayoutBlockQuote: TMenuItem;
      mnuLayoutPreformatted: TMenuItem;}
    //Grouping menu
    mnuGrouping := 'In&deling';
      mnuGroupingParagraph := 'Alinea';
      mnuGroupingDiv := 'Div';
      mnuGroupingSpan := 'Span';
  //View menu
  mnuView := 'Bee&ld';
    mnuViewFontsize := '&Tekengrootte';
end;

procedure TTranslations.TranslateToPortuguese;
begin
  mnuFile := '&Arquivo';
    mnuFileOpen := 'Abrir';
    mnuFileNewFromTemplate := 'Novo do modelo ...';
    mnuFileNew := 'Novo';
      mnuFileNewText := 'Texto';
      {mnuFileNewHtml: TMenuItem;
      mnuFileNewXml: TMenuItem;
      mnuFileNewCss: TMenuItem;
      mnuFileNewJS: TMenuItem;
      mnuFileNewFpc: TMenuItem;
      mnuFileNewC: TMenuItem;
      mnuFileNewPy: TMenuItem;
      mnuFileNewPhp: TMenuItem;
      mnuFileNewPerl: TMenuItem;
      mnuFileNewShellScript: TMenuItem;
      mnuFileNewBat: TMenuItem;
      mnuFileNewIni: TMenuItem;}
    mnuFileSave := 'Salvar';
    mnuFileSaveAs := 'Salvar como';
    mnuFileSaveAll := 'Salvar todos';
    mnuFileCloseCurrent := 'Fechar arquivo';
    //mnuSep1: TMenuItem;
    mnuFileOpenInBrowser := 'Abrir num navegador';
    //mnuSepAboveMru: TMenuItem;
    mnuFileCloseApp := 'Fechar o programa';
  //Edit menu
  mnuEdit := 'Editar';
    mnuEditUndo := 'Desfazer';
    mnuEditRedo := 'Refazer';
    //mnuSep11: TMenuItem;
    mnuEditCopy := 'Copiar';
    mnuEditCut := 'Cortar';
    mnuEditPaste := 'Colar';
    //mnuEditPasteSpecial := 'Plakken speciaal';
    mnuEditSelectAll := 'Selecionar tudo';
    //mnuSep12: TMenuItem;
    mnuEditReplace := '&Substituir';
    mnuEditFindNext := 'Procurar Próximo';
    mnuEditFind := '&Procurar';
  //HTML Tools menu
  mnuHTMLTools := 'Ferramentas &HTML';
    mnuInsertAnchor := 'Inserir Hyperlink';
  {    mnuInsertList,
      mnuInsertUList: TMenuItem;
      mnuInsertNList: TMenuItem;
      mnuInsertWordList: TMenuItem;
      mnuInsetListItem: TMenuItem;
      mnuInsertWordTerm: TMenuItem;
      mnuInsertWordDefinition: TMenuItem;
    mnuInsertTable: TMenuItem;
      mnInsertNewTable: TMenuItem;
      mnuInsertTableCell: TMenuItem;
      mnuInsertTableRow: TMenuItem;
    mnuInsertPicture: TMenuItem;
    mnuInsertSpecialChars: TMenuItem;
    mnuInsertLineBreak: TMenuItem;
    mnuInsertSep1: TMenuItem;
    mnuInsertHtmlComment: TMenuItem;
    mnuInsertJS: TMenuItem;
    mnuInsertCssStyle: TMenuItem;}
    //Layout menu
    mnuLayout := '&Layout';
      mnuLayoutBold := 'Negrito';
      mnuLayoutItalic := 'Italico';
      mnuLayoutUnderline := 'Sublinhado';
      mnuLayoutSub := 'Subscrito';
      mnuLayoutSup := 'Subrescrito';
      mnuLayoutEmphasis := 'Ênfase';
      mnuLayoutStrong := 'Forte';
      mnuLayoutHeadings := 'Título';
  {        mnuLayoutH1: TMenuItem;
        mnuLayoutH2: TMenuItem;
        mnuLayoutH3: TMenuItem;
        mnuLayoutH4: TMenuItem;
        mnuLayoutH5: TMenuItem;
        mnuLayoutH6: TMenuItem;
      mnuLayoutAlign: TMenuItem;
        mnuLayoutAlignLeft: TMenuItem;
        mnuLayoutAlignRight: TMenuItem;
        mnuLayoutAlignCenter: TMenuItem;
        mnuLayoutAlignJustify := 'Volledig uitlijnen';
      mnuLayoutCode: TMenuItem;
      mnuLayoutQuote: TMenuItem;
      mnuLayoutBlockQuote: TMenuItem;
      mnuLayoutPreformatted: TMenuItem;}
    //Grouping menu
    mnuGrouping := 'A&grupamento';
      mnuGroupingParagraph := 'Paragrafo';
      mnuGroupingDiv := 'Div';
      mnuGroupingSpan := 'Span';
  //View menu
  mnuView := '&Vizualização';
    mnuViewFontsize := 'Tamanho da &fonte';
end;

procedure TTranslations.TranslateToLanguageID(AID: Integer);
begin
  case AID of
  1: TranslateToDutch;
  2: TranslateToPortuguese;
  else
    TranslateToEnglish;
  end;
end;

initialization

vTranslations := TTranslations.Create;
vTranslations.TranslateToEnglish

finalization

FreeAndNil(vTranslations);

end.
