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

# TODO: Update docstring
def check_frequency_of_number_per_slice(list_of_numbers, number_to_count=0, slice_length=1, frequency=1):
	"""
    Check the nearest elements for maximum allowed equals 'num'

    Parameters
    ----------
    input_list: list#
	list_of_numbers: 
		List to check for the nearest items
	number_to_count: 
		Maximum number allowed to appear in list_of_numbers in a row
    slice_length: int
	
	frequency: int

	"""

	for i in range(len(list_of_numbers) - num):
		if list_of_numbers[i:slice_length].count(number_to_count) >= num:
			return False
	return True

def check_if_neighbor_item_is_different(input_list):
    """
    Checks if the item before and after each item is different
    
    Parameters
    ----------
    input_list: list
    """
    for i in range(len(input_list)-1):
        # Comparing each item and the item after
        if (input_list[i] == input_list[i+1]):
            return False
    return True

def testExactMovingAverage(list_of_numbers, group):
	'''Test if the moving average is exact for the group
	'''
	rtnVal = True
	pct50 = group/2
	pct25 = group/4
	for i in range(len(list_of_numbers)-group):
		myList = list_of_numbers[i:(group+i)]
		if( (myList.count(4) - pct50) == 0 ):
			if( (myList.count(5) - pct25) == 0 ):
				if( (myList.count(6) - pct25) == 0 ):
				 	pass
		else:
			rtnVal = False
			break
	if(rtnVal == True):
		print("PASSED - exact moving avg. ", group, " : " , list_of_numbers)
	else:
		print("Exact Moving Average failed at the item starting from : " , i)
	return rtnVal
def checkApproxMovingAverage(list_of_numbers, group, mylook_up_list, highestNumInList):
	'''	Check if every group (number of item in the group to estimate the moving average) 
	contiguous elemets have 50% of 4, and 25% of 5 and 6
	'''
	#print "moving avg. ", group
	global groupStr
	rtnVal = True
	pct50 = group/2
	pct25 = group/4
	#The first three should not contain 6
	if(list_of_numbers[:3].count(highestNumInList)>0):
		return False
	for i in range(len(list_of_numbers)-group):
		myList = list_of_numbers[i:(group+i)]
		if( abs(myList.count(mylook_up_list[0]) - pct50) < 2): # One more or less is accepted in the group
			if( abs(myList.count(mylook_up_list[1]) - pct25) < 2 ):
				if( abs(myList.count(mylook_up_list[2]) - pct25) < 2 ):
				 	pass
		else:
			rtnVal = False
			break
	if(rtnVal == True):
		rtnVal = checkNearest(list_of_numbers, mylook_up_list, 2)
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
