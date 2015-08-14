import PyMinMod
from TMenuunit import*
class TMainMenu(TMenu):
    def Create(self,AOwner):
        r=PyMinMod.TMainMenuCreate(self.pointer,AOwner.pointer)
        ro=TMainMenu()
        ro.pointer=r
        return ro
    def getHeight(self):
        r=PyMinMod.TMainMenugetHeight(self.pointer)
        return r
