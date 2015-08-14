import PyMinMod
from TLCLComponentunit import*
import TMenuunit
import TComponentunit
class TMenuItem():
    def Find(self,ACaption):
        r=PyMinMod.TMenuItemFind(self.pointer,ACaption)
        ro=TMenuItem()
        ro.pointer=r
        return ro
    def GetParentComponent(self):
        r=PyMinMod.TMenuItemGetParentComponent(self.pointer)
        ro=TComponent()
        ro.pointer=r
        return ro
    def GetParentMenu(self):
        r=PyMinMod.TMenuItemGetParentMenu(self.pointer)
        ro=TMenu()
        ro.pointer=r
        return ro
    def GetIsRightToLeft(self):
        r=PyMinMod.TMenuItemGetIsRightToLeft(self.pointer)
        return r
    def HandleAllocated(self):
        r=PyMinMod.TMenuItemHandleAllocated(self.pointer)
        return r
    def HasIcon(self):
        r=PyMinMod.TMenuItemHasIcon(self.pointer)
        return r
    def HasParent(self):
        r=PyMinMod.TMenuItemHasParent(self.pointer)
        return r
    def InitiateAction(self):
        r=PyMinMod.TMenuItemInitiateAction(self.pointer)
    def IntfDoSelect(self):
        r=PyMinMod.TMenuItemIntfDoSelect(self.pointer)
    def IndexOf(self,Item):
        r=PyMinMod.TMenuItemIndexOf(self.pointer,Item.pointer)
        return r
    def IndexOfCaption(self,ACaption):
        r=PyMinMod.TMenuItemIndexOfCaption(self.pointer,ACaption)
        return r
    def VisibleIndexOf(self,Item):
        r=PyMinMod.TMenuItemVisibleIndexOf(self.pointer,Item.pointer)
        return r
    def Add(self,Item):
        r=PyMinMod.TMenuItemAdd(self.pointer,Item.pointer)
    def AddSeparator(self):
        r=PyMinMod.TMenuItemAddSeparator(self.pointer)
    def Click(self):
        r=PyMinMod.TMenuItemClick(self.pointer)
    def Delete(self,Index):
        r=PyMinMod.TMenuItemDelete(self.pointer,Index)
    def HandleNeeded(self):
        r=PyMinMod.TMenuItemHandleNeeded(self.pointer)
    def Insert(self,Item,Index):
        r=PyMinMod.TMenuItemInsert(self.pointer,Item.pointer,Index)
    def RecreateHandle(self):
        r=PyMinMod.TMenuItemRecreateHandle(self.pointer)
    def Remove(self,Item):
        r=PyMinMod.TMenuItemRemove(self.pointer,Item.pointer)
    def IsCheckItem(self):
        r=PyMinMod.TMenuItemIsCheckItem(self.pointer)
        return r
    def IsLine(self):
        r=PyMinMod.TMenuItemIsLine(self.pointer)
        return r
    def IsInMenuBar(self):
        r=PyMinMod.TMenuItemIsInMenuBar(self.pointer)
        return r
    def Clear(self):
        r=PyMinMod.TMenuItemClear(self.pointer)
    def HasBitmap(self):
        r=PyMinMod.TMenuItemHasBitmap(self.pointer)
        return r
    def RemoveAllHandlersOfObject(self,AnObject):
        r=PyMinMod.TMenuItemRemoveAllHandlersOfObject(self.pointer,AnObject.pointer)
    def getCount(self):
        r=PyMinMod.TMenuItemgetCount(self.pointer)
        return r
    def getItems(self,Index):
        r=PyMinMod.TMenuItemgetItems(self.pointer,Index)
        ro=TMenuItem()
        ro.pointer=r
        return ro
    def setMenuIndex(self,a1):
        r=PyMinMod.TMenuItemsetMenuIndex(self.pointer,a1)
    def getMenuIndex(self):
        r=PyMinMod.TMenuItemgetMenuIndex(self.pointer)
        return r
    MenuIndex=property(getMenuIndex,setMenuIndex)
    def getMenu(self):
        r=PyMinMod.TMenuItemgetMenu(self.pointer)
        ro=TMenu()
        ro.pointer=r
        return ro
    def getParent(self):
        r=PyMinMod.TMenuItemgetParent(self.pointer)
        ro=TMenuItem()
        ro.pointer=r
        return ro
    def MenuVisibleIndex(self):
        r=PyMinMod.TMenuItemMenuVisibleIndex(self.pointer)
        return r
    def setAutoCheck(self,a1):
        r=PyMinMod.TMenuItemsetAutoCheck(self.pointer,a1)
    def getAutoCheck(self):
        r=PyMinMod.TMenuItemgetAutoCheck(self.pointer)
        return r
    AutoCheck=property(getAutoCheck,setAutoCheck)
    def setDefault(self,a1):
        r=PyMinMod.TMenuItemsetDefault(self.pointer,a1)
    def getDefault(self):
        r=PyMinMod.TMenuItemgetDefault(self.pointer)
        return r
    Default=property(getDefault,setDefault)
    def setRadioItem(self,a1):
        r=PyMinMod.TMenuItemsetRadioItem(self.pointer,a1)
    def getRadioItem(self):
        r=PyMinMod.TMenuItemgetRadioItem(self.pointer)
        return r
    RadioItem=property(getRadioItem,setRadioItem)
    def setRightJustify(self,a1):
        r=PyMinMod.TMenuItemsetRightJustify(self.pointer,a1)
    def getRightJustify(self):
        r=PyMinMod.TMenuItemgetRightJustify(self.pointer)
        return r
    RightJustify=property(getRightJustify,setRightJustify)
    def setOnClick(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
