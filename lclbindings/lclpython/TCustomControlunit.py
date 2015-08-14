import PyMinMod
from TWinControlunit import*
class TCustomControl(TWinControl):
    def setOnPaint(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
