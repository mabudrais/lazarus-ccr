unit spkt_Items;

{$mode delphi}
{.$Define EnhancedRecordSupport}

(*******************************************************************************
*                                                                              *
*  Plik: spkt_Items.pas                                                        *
*  Opis: Modu³ zawiera klasê kolekcji elementów tafli.                         *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

uses Classes, Controls, SysUtils, Dialogs,
     spkt_Appearance, spkt_Dispatch, spkt_BaseItem, spkt_Types,
     spkt_Buttons, spkt_Checkboxes;

type TSpkItems = class(TSpkCollection)
     private
       FToolbarDispatch : TSpkBaseToolbarDispatch;
       FAppearance : TSpkToolbarAppearance;
       FImages : TImageList;
       FDisabledImages : TImageList;
       FLargeImages : TImageList;
       FDisabledLargeImages : TImageList;

     // *** Gettery i settery ***
       procedure SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);
       function GetItems(index: integer): TSpkBaseItem; reintroduce;
       procedure SetAppearance(const Value: TSpkToolbarAppearance);
       procedure SetImages(const Value: TImageList);
       procedure SetDisabledImages(const Value : TImageList);
       procedure SetLargeImages(const Value : TImageList);
       procedure SetDisabledLargeImages(const Value : TImageList);
     public
     // *** Konstruktor, destruktor ***
       constructor Create(RootComponent : TComponent); override;
       destructor Destroy; override;

       function AddLargeButton : TSpkLargeButton;
       function AddSmallButton : TSpkSmallButton;
       function AddCheckbox: TSpkCheckbox;
       function AddRadioButton: TSpkRadioButton;

     // *** Reakcja na zmiany listy ***
       procedure Notify(Item: TComponent; Operation : TOperation); override;
       procedure Update; override;

       property Items[index : integer] : TSpkBaseItem read GetItems; default;
       property ToolbarDispatch : TSpkBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
       property Appearance : TSpkToolbarAppearance read FAppearance write SetAppearance;
       property Images : TImageList read FImages write SetImages;
       property DisabledImages : TImageList read FDisabledImages write SetDisabledImages;
       property LargeImages : TImageList read FLargeImages write SetLargeImages;
       property DisabledLargeImages : TImageList read FDisabledLargeImages write SetDisabledLargeImages;
     end;

implementation

{ TSpkItems }

function TSpkItems.AddLargeButton: TSpkLargeButton;

var Owner, Parent : TComponent;
    i: Integer;

begin
if FRootComponent<>nil then
   begin
   Owner:=FRootComponent.Owner;
   Parent:=FRootComponent;
   end
else
   begin
   Owner:=nil;
   Parent:=nil;
   end;

result:=TSpkLargeButton.Create(Owner);
result.Parent:=Parent;

if FRootComponent<>nil then
   begin
   i:=0;
   while FRootComponent.Owner.FindComponent('SpkLargeButton'+inttostr(i))<>nil do
         inc(i);

   result.Name:='SpkLargeButton'+inttostr(i);
   end;

AddItem(result);
end;

function TSpkItems.AddSmallButton: TSpkSmallButton;

var Owner, Parent : TComponent;
    i: Integer;

begin
if FRootComponent<>nil then
   begin
   Owner:=FRootComponent.Owner;
   Parent:=FRootComponent;
   end
else
   begin
   Owner:=nil;
   Parent:=nil;
   end;

result:=TSpkSmallButton.Create(Owner);
result.Parent:=Parent;

if FRootComponent<>nil then
   begin
   i:=0;
   while FRootComponent.Owner.FindComponent('SpkSmallButton'+inttostr(i))<>nil do
         inc(i);

   result.Name:='SpkSmallButton'+inttostr(i);
   end;

AddItem(result);
end;

function TSpkItems.AddCheckbox: TSpkCheckbox;
var
  Owner, Parent : TComponent;
  i: Integer;
begin
  if FRootComponent <> nil then begin
    Owner := FRootComponent.Owner;
    Parent := FRootComponent;
  end else begin
    Owner := nil;
    Parent := nil;
  end;
  result := TSpkCheckbox.Create(Owner);
  result.Parent := Parent;

  if FRootComponent <> nil then begin
    i := 0;
    while FRootComponent.Owner.FindComponent('SpkCheckbox'+IntToStr(i)) <> nil do
      inc(i);
    result.Name := 'SpkCheckbox' + IntToStr(i);
  end;

  AddItem(result);
end;

function TSpkItems.AddRadioButton: TSpkRadioButton;
var
  Owner, Parent : TComponent;
  i: Integer;
begin
  if FRootComponent <> nil then begin
    Owner := FRootComponent.Owner;
    Parent := FRootComponent;
  end else begin
    Owner := nil;
    Parent := nil;
  end;
  result := TSpkRadioButton.Create(Owner);
  result.Parent := Parent;

  if FRootComponent <> nil then begin
    i := 0;
    while FRootComponent.Owner.FindComponent('SpkRadioButton'+IntToStr(i)) <> nil do
      inc(i);
    result.Name := 'SpkRadioButton' + IntToStr(i);
  end;

  AddItem(result);
end;

constructor TSpkItems.Create(RootComponent : TComponent);
begin
inherited Create(RootComponent);
FToolbarDispatch:=nil;
FAppearance:=nil;
FImages:=nil;
FDisabledImages:=nil;
FLargeImages:=nil;
FDisabledLargeImages:=nil;
end;

destructor TSpkItems.Destroy;
begin
  inherited Destroy;
end;

function TSpkItems.GetItems(index: integer): TSpkBaseItem;
begin
result:=TSpkBaseItem(inherited Items[index]);
end;

procedure TSpkItems.Notify(Item: TComponent;
  Operation : TOperation);
begin
  inherited Notify(Item, Operation);

  case Operation of
       opInsert: begin
                 // Ustawienie dyspozytora na nil spowoduje, ¿e podczas
                 // przypisywania w³asnoœci nie bêd¹ wo³ane metody Notify*
                 TSpkBaseItem(Item).ToolbarDispatch:=nil;

                 TSpkBaseItem(Item).Appearance:=FAppearance;
                 TSpkBaseItem(Item).Images:=FImages;
                 TSpkBaseItem(Item).DisabledImages:=FDisabledImages;
                 TSpkBaseItem(Item).LargeImages:=FLargeImages;
                 TSpkBaseItem(Item).DisabledLargeImages:=FDisabledLargeImages;
                 TSpkBaseItem(Item).ToolbarDispatch:=FToolbarDispatch;
                 end;
       opRemove: begin
                 if not(csDestroying in Item.ComponentState) then
                    begin
                    TSpkBaseItem(Item).ToolbarDispatch:=nil;
                    TSpkBaseItem(Item).Appearance:=nil;
                    TSpkBaseItem(Item).Images:=nil;
                    TSpkBaseItem(Item).DisabledImages:=nil;
                    TSpkBaseItem(Item).LargeImages:=nil;
                    TSpkBaseItem(Item).DisabledLargeImages:=nil;
                    end;
                 end;
  end;
end;

procedure TSpkItems.SetAppearance(const Value: TSpkToolbarAppearance);

var i: Integer;

begin
  FAppearance := Value;
  if self.Count>0 then
     for i := 0 to self.count - 1 do
         Items[i].Appearance:=FAppearance;
end;

procedure TSpkItems.SetDisabledImages(const Value: TImageList);

var i: Integer;

begin
  FDisabledImages := Value;
  if self.Count>0 then
     for i := 0 to self.count - 1 do
         Items[i].DisabledImages:=FDisabledImages;
end;

procedure TSpkItems.SetDisabledLargeImages(const Value: TImageList);

var i: Integer;

begin
  FDisabledLargeImages := Value;
  if self.Count>0 then
     for i := 0 to self.count - 1 do
         Items[i].DisabledLargeImages:=FDisabledLargeImages;
end;

procedure TSpkItems.SetImages(const Value: TImageList);

var i: Integer;

begin
  FImages := Value;
  if self.Count>0 then
     for i := 0 to self.count - 1 do
         Items[i].Images:=FImages;
end;

procedure TSpkItems.SetLargeImages(const Value: TImageList);

var i: Integer;

begin
  FLargeImages := Value;
  if self.Count>0 then
     for i := 0 to self.count - 1 do
         Items[i].LargeImages:=FLargeImages;
end;

procedure TSpkItems.SetToolbarDispatch(const Value: TSpkBaseToolbarDispatch);

var i : integer;

begin
  FToolbarDispatch := Value;
  if self.Count>0 then
     for i := 0 to self.count - 1 do
         Items[i].ToolbarDispatch:=FToolbarDispatch;
end;

procedure TSpkItems.Update;
begin
  inherited Update;

  if assigned(FToolbarDispatch) then
     FToolbarDispatch.NotifyItemsChanged;
end;

end.
