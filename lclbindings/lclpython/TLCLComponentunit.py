import PyMinMod
import TMenuItemunit
import TComponentunit
class TLCLComponent():
    def DestroyHandle(self):
        r=PyMinMod.TLCLComponentDestroyHandle(self.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TLCLComponentHandleAllocated(self.pointer)
        return r
    def IsRightToLeft(self):
        r=PyMinMod.TLCLComponentIsRightToLeft(self.pointer)
        return r
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TLCLComponentUseRightToLeftAlignment(self.pointer)
        return r
    def UseRightToLeftReading(self):
        r=PyMinMod.TLCLComponentUseRightToLeftReading(self.pointer)
        return r
    def HandleNeeded(self):
        r=PyMinMod.TLCLComponentHandleNeeded(self.pointer)
    def setParent(self,a1):
        r=PyMinMod.TLCLComponentsetParent(self.pointer,a1.pointer)
    def getParent(self):
        r=PyMinMod.TLCLComponentgetParent(self.pointer)
        ro=TComponent()
        ro.pointer=r
        return ro
    Parent=property(getParent,setParent)
    def setParentBidiMode(self,a1):
        r=PyMinMod.TLCLComponentsetParentBidiMode(self.pointer,a1)
    def getParentBidiMode(self):
        r=PyMinMod.TLCLComponentgetParentBidiMode(self.pointer)
        return r
    ParentBidiMode=property(getParentBidiMode,setParentBidiMode)
    def getItems(self):
        r=PyMinMod.TLCLComponentgetItems(self.pointer)
        ro=TMenuItem()
        ro.pointer=r
        return ro
