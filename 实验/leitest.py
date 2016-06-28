#!/usr/bin/python
# -*- coding: UTF-8 -*-
class SchoolMember:      #基础类
	def __init__(self,name,gender,nationality='CN'):
		self.name = name
		self.gender = gender
		self.nation = nationality
	def tell(self):
		print 'hi,my name is %s,i am from %s' %(self.name,self.nation)

class Student(SchoolMember):  #继承
	def __init__(self,Name,Gender,banji,Sroce,Nation,):
		SchoolMember.__init__(self,Name,Gender,Nation)
		self.banji = banji
		self.Sroce = Sroce
	def payTuition(self,amount):
		if amount < 6499:
			print 'fuck!!！！！'
		else:
			print 'welcome !!!!!!!!!'
class Teacher(SchoolMember):
	def __init__(self,Name,Gender,Course,Salary,Nation):
		SchoolMember.__init__(self,Name, Gender,Nation)
		self.Course = Course
		self.Salary = Salary
	def teachering(self):
		print 'HI.am teachering %s ,i am making %s permontth!!!!!!!' %(self.Course,self.Salary)

s1=Student('zhaichaoqun','Male','Python','a+','CN')
s1.tell()
s1.payTuition(4000)
