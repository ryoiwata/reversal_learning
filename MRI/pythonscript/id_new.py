'''This script is used to generate the input for scanner version of ALL ED movie.
'''
from time import *
from random import *
import math
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
		print "output file coule not be opened!!"

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
		print "PASSED - moving avg. ", group, " : " , inList
	else:
		print i
	return rtnVal
def checkApproxMovingAverage(list_of_numbers, number_of_groups=8):
	"""
    Check if every 12 contiguous elemets have 50% of 4, and 25% of 5 and 6
    
    Parameters
    ----------
    list_of_numbers: list
    
    number_of_groups: int
		Can be either 8, 16, or 20
	"""
	# TODO: See if it is necessary to make groupStr global

	rtnVal = True
	percentile_50th = number_of_groups//2
	percentile_25th = number_of_groups//4
	print(percentile_25th)
	print(percentile_25th)
    
	for i in range(len(list_of_numbers)-number_of_groups):
		slice_of_list_of_numbers = list_of_numbers[i:(number_of_groups+i)]
		print(slice_of_list_of_numbers)
		if abs(slice_of_list_of_numbers.count(4) - percentile_50th) > 1 or \
        abs(slice_of_list_of_numbers.count(5) - percentile_25th) > 1 or \
        abs(slice_of_list_of_numbers.count(6) - percentile_25th) > 1:
			print(slice_of_list_of_numbers.count(4))
        	print(slice_of_list_of_numbers.count(5))
        	print(slice_of_list_of_numbers.count(6))
        	break
			rtnVal = False
			break
	return rtnVal


def makeCriteriaList():
	ed = [4] * 17 + [5] * 8 + [6] * 8
	done = 0
	tmpED = ed[:]
	while(done==0):
		shuffle(tmpED)
		if ( checkApproxMovingAverage(tmpED, 8) ):
		#or checkApproxMovingAverage(tmpED, 16) or checkApproxMovingAverage(tmpED, 20) ):
			done = 1
		else:
			tmpED = ed[:]
	print tmpED
	return tmpED

	return outList
def main(count=1):
	oFile = openOutFile()
	oFile.write("\n" + ctime() + "\n")
	try:
		global groupStr
		for i in range(count):
			'''
			stmList = makeInputStim()
			criteriaList = makeCriteriaList()
			'''
			criteriaList = makeCriteriaList()
			oFile.write(groupStr + "\n")
			oFile.write("\n" + repr(criteriaList)+"\n")
	finally:
		oFile.close()
