import PyMinMod
from TCustomFormunit import*
class TForm(TCustomForm):
    def Create(self,TheOwner):
        r=PyMinMod.TFormCreate(self.pointer,TheOwner.pointer)
        ro=TForm()
        ro.pointer=r
        return ro
    def Tile(self):
        r=PyMinMod.TFormTile(self.pointer)
    def setLCLVersion(self,a1):
        r=PyMinMod.TFormsetLCLVersion(self.pointer,a1)
    def getLCLVersion(self):
        r=PyMinMod.TFormgetLCLVersion(self.pointer)
        return r
    LCLVersion=property(getLCLVersion,setLCLVersion)
