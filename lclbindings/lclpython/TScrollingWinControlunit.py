import PyMinMod
from TCustomControlunit import*
class TScrollingWinControl(TCustomControl):
    def UpdateScrollbars(self):
        r=PyMinMod.TScrollingWinControlUpdateScrollbars(self.pointer)
