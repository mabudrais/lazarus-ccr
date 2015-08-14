import PyMinMod
from TButtonControlunit import*
class TCustomButton(TButtonControl):
    def Create(self,TheOwner):
        r=PyMinMod.TCustomButtonCreate(self.pointer,TheOwner.pointer)
        ro=TCustomButton()
        ro.pointer=r
        return ro
    def Click(self):
        r=PyMinMod.TCustomButtonClick(self.pointer)
    def ExecuteDefaultAction(self):
        r=PyMinMod.TCustomButtonExecuteDefaultAction(self.pointer)
    def ExecuteCancelAction(self):
        r=PyMinMod.TCustomButtonExecuteCancelAction(self.pointer)
    def ActiveDefaultControlChanged(self,NewControl):
        r=PyMinMod.TCustomButtonActiveDefaultControlChanged(self.pointer,NewControl.pointer)
    def UpdateRolesForForm(self):
        r=PyMinMod.TCustomButtonUpdateRolesForForm(self.pointer)
    def getActive(self):
        r=PyMinMod.TCustomButtongetActive(self.pointer)
        return r
    def setDefault(self,a1):
        r=PyMinMod.TCustomButtonsetDefault(self.pointer,a1)
    def getDefault(self):
        r=PyMinMod.TCustomButtongetDefault(self.pointer)
        return r
    Default=property(getDefault,setDefault)
    def setCancel(self,a1):
        r=PyMinMod.TCustomButtonsetCancel(self.pointer,a1)
    def getCancel(self):
        r=PyMinMod.TCustomButtongetCancel(self.pointer)
        return r
    Cancel=property(getCancel,setCancel)
