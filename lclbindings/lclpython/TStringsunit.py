import PyMinMod
from TPersistentunit import*
import TObjectunit
class TStrings(TPersistent):
    def Add(self,S):
        r=PyMinMod.TStringsAdd(self.pointer,S)
        return r
    def AddObject(self,AObject,S):
        r=PyMinMod.TStringsAddObject(self.pointer,AObject.pointer,S)
        return r
    def Append(self,S):
        r=PyMinMod.TStringsAppend(self.pointer,S)
    def AddStrings(self,TheStrings):
        r=PyMinMod.TStringsAddStrings(self.pointer,TheStrings.pointer)
    def BeginUpdate(self):
        r=PyMinMod.TStringsBeginUpdate(self.pointer)
    def Clear(self):
        r=PyMinMod.TStringsClear(self.pointer)
    def Delete(self,Index):
        r=PyMinMod.TStringsDelete(self.pointer,Index)
    def EndUpdate(self):
        r=PyMinMod.TStringsEndUpdate(self.pointer)
    def Equals(self,Obj):
        r=PyMinMod.TStringsEquals(self.pointer,Obj.pointer)
        return r
    def Equals(self,TheStrings):
        r=PyMinMod.TStringsEquals(self.pointer,TheStrings.pointer)
        return r
    def Exchange(self,Index2,Index1):
        r=PyMinMod.TStringsExchange(self.pointer,Index2,Index1)
    def IndexOf(self,S):
        r=PyMinMod.TStringsIndexOf(self.pointer,S)
        return r
    def IndexOfName(self,Name):
        r=PyMinMod.TStringsIndexOfName(self.pointer,Name)
        return r
    def IndexOfObject(self,AObject):
        r=PyMinMod.TStringsIndexOfObject(self.pointer,AObject.pointer)
        return r
    def Insert(self,S,Index):
        r=PyMinMod.TStringsInsert(self.pointer,S,Index)
    def LoadFromFile(self,FileName):
        r=PyMinMod.TStringsLoadFromFile(self.pointer,FileName)
    def Move(self,NewIndex,CurIndex):
        r=PyMinMod.TStringsMove(self.pointer,NewIndex,CurIndex)
    def SaveToFile(self,FileName):
        r=PyMinMod.TStringsSaveToFile(self.pointer,FileName)
    def GetNameValue(self,AValue,AName,Index):
        r=PyMinMod.TStringsGetNameValue(self.pointer,AValue,AName,Index)
    def setValueFromIndex(self,a1,Index):
        r=PyMinMod.TStringssetValueFromIndex(self.pointer,a1,Index)
    def getValueFromIndex(self,Index):
        r=PyMinMod.TStringsgetValueFromIndex(self.pointer,Index)
        return r
    def setCapacity(self,a1):
        r=PyMinMod.TStringssetCapacity(self.pointer,a1)
    def getCapacity(self):
        r=PyMinMod.TStringsgetCapacity(self.pointer)
        return r
    Capacity=property(getCapacity,setCapacity)
    def setCommaText(self,a1):
        r=PyMinMod.TStringssetCommaText(self.pointer,a1)
    def getCommaText(self):
        r=PyMinMod.TStringsgetCommaText(self.pointer)
        return r
    CommaText=property(getCommaText,setCommaText)
    def getCount(self):
        r=PyMinMod.TStringsgetCount(self.pointer)
        return r
    def getNames(self,Index):
        r=PyMinMod.TStringsgetNames(self.pointer,Index)
        return r
    def setObjects(self,a1,Index):
        r=PyMinMod.TStringssetObjects(self.pointer,a1.pointer,Index)
    def getObjects(self,Index):
        r=PyMinMod.TStringsgetObjects(self.pointer,Index)
        ro=TObject()
        ro.pointer=r
        return ro
    def setValues(self,a1,Name):
        r=PyMinMod.TStringssetValues(self.pointer,a1,Name)
    def getValues(self,Name):
        r=PyMinMod.TStringsgetValues(self.pointer,Name)
        return r
    def setStrings(self,a1,Index):
        r=PyMinMod.TStringssetStrings(self.pointer,a1,Index)
    def getStrings(self,Index):
        r=PyMinMod.TStringsgetStrings(self.pointer,Index)
        return r
    def setText(self,a1):
        r=PyMinMod.TStringssetText(self.pointer,a1)
    def getText(self):
        r=PyMinMod.TStringsgetText(self.pointer)
        return r
    Text=property(getText,setText)
