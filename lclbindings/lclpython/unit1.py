#!/usr/bin/env python
# -*- coding: utf-8 -*-
from TButtonunit import*
from TMemounit import*
from TEditunit import*
class TForm1:
	def __init__(self):
		self.Button1=TButton()
		self.Memo1=TMemo()
		self.Edit1=TEdit()
	def onlic(self):
		print self.Button1.Width
		self.Button1.setWidth(self.Button1.getWidth()+10)
		self.Button1.setTop(self.Button1.getTop()+8)
		self.Button1.setCaption(('hello'))
		self.Memo1.getLines().Add('lll')
		print self.Memo1.getLines().getStrings(0)
		self.Edit1.setCaption(self.Memo1.getLines().getStrings(0))
