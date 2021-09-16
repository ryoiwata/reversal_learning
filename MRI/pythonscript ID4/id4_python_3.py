'''This script is used to generate the input for scanner version of ID3S movie.
	RULE
	There should be 30 elements of L, R, M - 10 each
	Criteria List should be of 4,5,6 of 30 items.
	50% of 4, 25% of 5 and 25% of 6
	The moving average group is of 12. So, every 12 in a row will have and approximate distribution of
	50% of 4, 25% of 5 and 25% of 6
	The first three items can not have 6.
'''
from time import *
from random import *
import math

CriteriaList1 = [4,5,6]
CriteriaList2 = [8,9,10]
global groupStr

def openOutFile():
	'''Open a file to write output
	'''
	try:
		outFile = open("id4.txt", 'a');
		return outFile
	except:
		print("output file coule not be opened!!")
def checkNearest(inList, lkpList, num):
	'''Check the nearest elements for maximum allowed equals 'num'
	'''
#inList => List to check for the nearest items
#lkpList=> Lookup List which has the list of items to check if that item exist more than 'num' of times in a row in inList
#num=> Maximum number allowed to appear in inList in a row
	for i in range(len(inList)-num):
		for itm in lkpList:
			if(inList[i:i+num+1].count(itm)>num):
				return False
	return True
def checkTwoNearest(tempList):
	''' Two nearest elements in the list should be different
	'''
	rtnVal = True
	for i in range(len(tempList)-1):
		if (tempList[i] == tempList[i+1]):
			rtnVal = False
			break
	return rtnVal

def testExactMovingAverage(inList, group):
	'''Test if the moving average is exact for the group
	'''
	rtnVal = True
	pct50 = group/2
	pct25 = group/4
	for i in range(len(inList)-group):
		myList = inList[i:(group+i)]
		if( (myList.count(4) - pct50) == 0 ):
			if( (myList.count(5) - pct25) == 0 ):
				if( (myList.count(6) - pct25) == 0 ):
				 	pass
		else:
			rtnVal = False
			break
	if(rtnVal == True):
		print("PASSED - exact moving avg. ", group, " : " , inList)
	else:
		print("Exact Moving Average failed at the item starting from : " , i)
	return rtnVal
def checkApproxMovingAverage(inList, group, myLkpList, highestNumInList):
	'''	Check if every group (number of item in the group to estimate the moving average) 
	contiguous elemets have 50% of 4, and 25% of 5 and 6
	'''
	#print "moving avg. ", group
	global groupStr
	rtnVal = True
	pct50 = group/2
	pct25 = group/4
	#The first three should not contain 6
	if(inList[:3].count(highestNumInList)>0):
		return False
	for i in range(len(inList)-group):
		myList = inList[i:(group+i)]
		if( abs(myList.count(myLkpList[0]) - pct50) < 2): # One more or less is accepted in the group
			if( abs(myList.count(myLkpList[1]) - pct25) < 2 ):
				if( abs(myList.count(myLkpList[2]) - pct25) < 2 ):
				 	pass
		else:
			rtnVal = False
			break
	if(rtnVal == True):
		rtnVal = checkNearest(inList, myLkpList, 2)
		print("Passed moving avg. ", group)
		groupStr = "Passed moving avg. " + str(group)
	return rtnVal
def makeInputStim():
	tmpList = [] + StimList * 10
	done = 0
	while(done==0):
		shuffle(tmpList)
		if ( checkNearest(tmpList, StimList, 1) == True ):
		#or checkApproxMovingAverage(tmpED, 16) or checkApproxMovingAverage(tmpED, 20) ):
			done = 1
	print(tmpList)
	return tmpList

def makeCriteriaList():
	tmpCList1 = [4] * 15 + [5] * 8 + [6] * 7
	tmpCList2 = [8] * 15 + [9] * 8 + [10] * 7
	group = 12
	while(1):
		shuffle(tmpCList1)
		if(checkApproxMovingAverage(tmpCList1, group, CriteriaList1, max(CriteriaList1))==True):
			break
	testExactMovingAverage(tmpCList1, group)
	print(tmpCList1)
	while(1):
		shuffle(tmpCList2)
		if(checkApproxMovingAverage(tmpCList2, group, CriteriaList2, max(CriteriaList2))==True):
			break
	testExactMovingAverage(tmpCList2, group)
	print(tmpCList2)
	return tmpCList1, tmpCList2
	
def main(count=1):
	oFile = openOutFile()
	oFile.write("\n" + ctime() + "\n")
	try:
		global groupStr
		for i in range(count):
			'''
			criteriaList = makeCriteriaList()
			'''
			list1, list2 = makeCriteriaList()
			oFile.write(groupStr + "\n")
			oFile.write("\n" + repr(list1)+"\n")
			oFile.write("\n" + repr(list2)+"\n")
	finally:
		oFile.close()
