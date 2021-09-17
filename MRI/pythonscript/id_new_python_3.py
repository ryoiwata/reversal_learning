'''This script is used to generate the input for scanner version of ALL ED movie.
'''
from time import *
import random 
#Possible combination of ED and ID
MainList = ["L","R","T", "C", "B","W"]
lr = ["L", "R"]
tc = ["T", "C"]
bw = ["B", "W"]
ed_num = 22
id_num = 10
global groupStr
#outFile = open("out_new.txt", 'a')
def openOutFile():
	'''Open a file to write output
	'''
	try:
		outFile = open("ed_out_new.txt", 'a');
		return outFile
	except:
		print("output file coule not be opened!!")

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
		print("PASSED - moving avg. ", group, " : " , inList)
	else:
		print(i)
	return rtnVal
def checkApproxMovingAverage(inList, group):
	'''Check if every 12 contiguous elemets have 50% of 4, and 25% of 5 and 6
	'''
	#print "moving avg. ", group
	global groupStr
	rtnVal = True
	pct50 = group/2
	pct25 = group/4
	for i in range(len(inList)-group):
		myList = inList[i:(group+i)]
		if( (myList.count(4) - pct50) in [-1, 0, 1]): # One more or less is accepted in the group
			if( (myList.count(5) - pct25) in [-1, 0, 1] ):
				if( (myList.count(6) - pct25) in [-1, 0, 1] ):
				 	pass
		else:
			rtnVal = False
			break
	if(rtnVal == True):
		print("Passed moving avg. ", group)
		groupStr = "Passed moving avg. " + str(group)
		#oFile.write("\n" + "Passed moving avg. " + repr(group) +"\n")
	return rtnVal

def make_criteria_list(list_of_numbers=None, number_of_groups=8):
    """
    Makes a criteria list based on shuffling a list of numbers 
    until the correct number of numbers in each contigous element
    
    Parameters
    ----------
    number_of_groups: int
    """
    
    if list_of_numbers is None:
        list_of_numbers = [4] * 17 + [5] * 8 + [6] * 8
    
    while not checkApproxMovingAverage(list_of_numbers, number_of_groups):    
        random.shuffle(list_of_numbers)
    return list_of_numbers 

def main(count=1):
	oFile = openOutFile()
	oFile.write("\n" + ctime() + "\n")
	try:
		global groupStr
		for i in range(count):
			'''
			stmList = makeInputStim()
			criteriaList = make_criteria_list()
			'''
			criteriaList = make_criteria_list()
			oFile.write(groupStr + "\n")
			oFile.write("\n" + repr(criteriaList)+"\n")
	finally:
		oFile.close()
