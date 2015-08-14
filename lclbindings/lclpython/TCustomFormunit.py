import PyMinMod
from TScrollingWinControlunit import*
import TMainMenuunit
import TControlunit
import TWinControlunit
class TCustomForm(TScrollingWinControl):
    def AfterConstruction(self):
        r=PyMinMod.TCustomFormAfterConstruction(self.pointer)
    def BeforeDestruction(self):
        r=PyMinMod.TCustomFormBeforeDestruction(self.pointer)
    def Close(self):
        r=PyMinMod.TCustomFormClose(self.pointer)
    def CloseQuery(self):
        r=PyMinMod.TCustomFormCloseQuery(self.pointer)
        return r
    def DefocusControl(self,Removing,Control):
        r=PyMinMod.TCustomFormDefocusControl(self.pointer,Removing,Control.pointer)
    def DestroyWnd(self):
        r=PyMinMod.TCustomFormDestroyWnd(self.pointer)
    def EnsureVisible(self,AMoveToTop):
        r=PyMinMod.TCustomFormEnsureVisible(self.pointer,AMoveToTop)
    def FocusControl(self,WinControl):
        r=PyMinMod.TCustomFormFocusControl(self.pointer,WinControl.pointer)
    def FormIsUpdating(self):
        r=PyMinMod.TCustomFormFormIsUpdating(self.pointer)
        return r
    def Hide(self):
        r=PyMinMod.TCustomFormHide(self.pointer)
    def IntfHelp(self,AComponent):
        r=PyMinMod.TCustomFormIntfHelp(self.pointer,AComponent.pointer)
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TCustomFormAutoSizeDelayedHandle(self.pointer)
        return r
    def Release(self):
        r=PyMinMod.TCustomFormRelease(self.pointer)
    def CanFocus(self):
        r=PyMinMod.TCustomFormCanFocus(self.pointer)
        return r
    def SetFocus(self):
        r=PyMinMod.TCustomFormSetFocus(self.pointer)
    def SetFocusedControl(self,Control):
        r=PyMinMod.TCustomFormSetFocusedControl(self.pointer,Control.pointer)
        return r
    def SetRestoredBounds(self,AHeight,AWidth,ATop,ALeft):
        r=PyMinMod.TCustomFormSetRestoredBounds(self.pointer,AHeight,AWidth,ATop,ALeft)
    def Show(self):
        r=PyMinMod.TCustomFormShow(self.pointer)
    def ShowModal(self):
        r=PyMinMod.TCustomFormShowModal(self.pointer)
        return r
    def ShowOnTop(self):
        r=PyMinMod.TCustomFormShowOnTop(self.pointer)
    def RemoveAllHandlersOfObject(self,AnObject):
        r=PyMinMod.TCustomFormRemoveAllHandlersOfObject(self.pointer,AnObject.pointer)
    def ActiveMDIChild(self):
        r=PyMinMod.TCustomFormActiveMDIChild(self.pointer)
        ro=TCustomForm()
        ro.pointer=r
        return ro
    def GetMDIChildren(self,AIndex):
        r=PyMinMod.TCustomFormGetMDIChildren(self.pointer,AIndex)
        ro=TCustomForm()
        ro.pointer=r
        return ro
    def MDIChildCount(self):
        r=PyMinMod.TCustomFormMDIChildCount(self.pointer)
        return r
    def getActive(self):
        r=PyMinMod.TCustomFormgetActive(self.pointer)
        return r
    def setActiveControl(self,a1):
        r=PyMinMod.TCustomFormsetActiveControl(self.pointer,a1.pointer)
    def getActiveControl(self):
        r=PyMinMod.TCustomFormgetActiveControl(self.pointer)
        ro=TWinControl()
        ro.pointer=r
        return ro
    ActiveControl=property(getActiveControl,setActiveControl)
    def setActiveDefaultControl(self,a1):
        r=PyMinMod.TCustomFormsetActiveDefaultControl(self.pointer,a1.pointer)
    def getActiveDefaultControl(self):
        r=PyMinMod.TCustomFormgetActiveDefaultControl(self.pointer)
        ro=TControl()
        ro.pointer=r
        return ro
    ActiveDefaultControl=property(getActiveDefaultControl,setActiveDefaultControl)
    def setAllowDropFiles(self,a1):
        r=PyMinMod.TCustomFormsetAllowDropFiles(self.pointer,a1)
    def getAllowDropFiles(self):
        r=PyMinMod.TCustomFormgetAllowDropFiles(self.pointer)
        return r
    AllowDropFiles=property(getAllowDropFiles,setAllowDropFiles)
    def setAlphaBlend(self,a1):
        r=PyMinMod.TCustomFormsetAlphaBlend(self.pointer,a1)
    def getAlphaBlend(self):
        r=PyMinMod.TCustomFormgetAlphaBlend(self.pointer)
        return r
    AlphaBlend=property(getAlphaBlend,setAlphaBlend)
    def setCancelControl(self,a1):
        r=PyMinMod.TCustomFormsetCancelControl(self.pointer,a1.pointer)
    def getCancelControl(self):
        r=PyMinMod.TCustomFormgetCancelControl(self.pointer)
        ro=TControl()
        ro.pointer=r
        return ro
    CancelControl=property(getCancelControl,setCancelControl)
    def setDefaultControl(self,a1):
        r=PyMinMod.TCustomFormsetDefaultControl(self.pointer,a1.pointer)
    def getDefaultControl(self):
        r=PyMinMod.TCustomFormgetDefaultControl(self.pointer)
        ro=TControl()
        ro.pointer=r
        return ro
    DefaultControl=property(getDefaultControl,setDefaultControl)
    def setDesignTimeDPI(self,a1):
        r=PyMinMod.TCustomFormsetDesignTimeDPI(self.pointer,a1)
    def getDesignTimeDPI(self):
        r=PyMinMod.TCustomFormgetDesignTimeDPI(self.pointer)
        return r
    DesignTimeDPI=property(getDesignTimeDPI,setDesignTimeDPI)
    def setHelpFile(self,a1):
        r=PyMinMod.TCustomFormsetHelpFile(self.pointer,a1)
    def getHelpFile(self):
        r=PyMinMod.TCustomFormgetHelpFile(self.pointer)
        return r
    HelpFile=property(getHelpFile,setHelpFile)
    def setKeyPreview(self,a1):
        r=PyMinMod.TCustomFormsetKeyPreview(self.pointer,a1)
    def getKeyPreview(self):
        r=PyMinMod.TCustomFormgetKeyPreview(self.pointer)
        return r
    KeyPreview=property(getKeyPreview,setKeyPreview)
    def getMDIChildren(self,I):
        r=PyMinMod.TCustomFormgetMDIChildren(self.pointer,I)
        ro=TCustomForm()
        ro.pointer=r
        return ro
    def setMenu(self,a1):
        r=PyMinMod.TCustomFormsetMenu(self.pointer,a1.pointer)
    def getMenu(self):
        r=PyMinMod.TCustomFormgetMenu(self.pointer)
        ro=TMainMenu()
        ro.pointer=r
        return ro
    Menu=property(getMenu,setMenu)
    def setPopupParent(self,a1):
        r=PyMinMod.TCustomFormsetPopupParent(self.pointer,a1.pointer)
    def getPopupParent(self):
        r=PyMinMod.TCustomFormgetPopupParent(self.pointer)
        ro=TCustomForm()
        ro.pointer=r
        return ro
    PopupParent=property(getPopupParent,setPopupParent)
    def setOnActivate(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnCreate(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnDeactivate(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnDestroy(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnHide(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnShow(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def getRestoredLeft(self):
        r=PyMinMod.TCustomFormgetRestoredLeft(self.pointer)
        return r
    def getRestoredTop(self):
        r=PyMinMod.TCustomFormgetRestoredTop(self.pointer)
        return r
    def getRestoredWidth(self):
        r=PyMinMod.TCustomFormgetRestoredWidth(self.pointer)
        return r
    def getRestoredHeight(self):
        r=PyMinMod.TCustomFormgetRestoredHeight(self.pointer)
        return r
