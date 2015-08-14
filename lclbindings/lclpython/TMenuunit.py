import PyMinMod
from TLCLComponentunit import*
import TMenuItemunit
import TComponentunit
class TMenu():
    def DestroyHandle(self):
        r=PyMinMod.TMenuDestroyHandle(self.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TMenuHandleAllocated(self.pointer)
        return r
    def IsRightToLeft(self):
        r=PyMinMod.TMenuIsRightToLeft(self.pointer)
        return r
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TMenuUseRightToLeftAlignment(self.pointer)
        return r
    def UseRightToLeftReading(self):
        r=PyMinMod.TMenuUseRightToLeftReading(self.pointer)
        return r
    def HandleNeeded(self):
        r=PyMinMod.TMenuHandleNeeded(self.pointer)
    def setParent(self,a1):
        r=PyMinMod.TMenusetParent(self.pointer,a1.pointer)
    def getParent(self):
        r=PyMinMod.TMenugetParent(self.pointer)
        ro=TComponent()
        ro.pointer=r
        return ro
    Parent=property(getParent,setParent)
    def setParentBidiMode(self,a1):
        r=PyMinMod.TMenusetParentBidiMode(self.pointer,a1)
    def getParentBidiMode(self):
        r=PyMinMod.TMenugetParentBidiMode(self.pointer)
        return r
    ParentBidiMode=property(getParentBidiMode,setParentBidiMode)
    def getItems(self):
        r=PyMinMod.TMenugetItems(self.pointer)
        ro=TMenuItem()
        ro.pointer=r
        return ro
