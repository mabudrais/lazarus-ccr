import PyMinMod
from TWinControlunit import*
class TButtonControl(TWinControl):
    def Create(self,TheOwner):
        r=PyMinMod.TButtonControlCreate(self.pointer,TheOwner.pointer)
        ro=TButtonControl()
        ro.pointer=r
        return ro
