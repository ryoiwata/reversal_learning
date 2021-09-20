'''This script is used to generate the input for scanner version of ALL ED movie.
'''
from time import *
import random 
import argparse
import datetime

#Possible combination of ED and ID
MainList = ["L","R","T", "C", "B","W"]
lr = ["L", "R"]
tc = ["T", "C"]
bw = ["B", "W"]
ed_num = 22
id_num = 10
global groupStr


def check_if_neighbor_item_is_different(input_list):
	"""
    Checks if the item before and after each item is different
    
    Parameters
    ----------
    input_list: list
	"""
	for i in range(len(input_list)-1):
		if (input_list[i] == input_list[i+1]):
			return False
			break
	return True

def testExactMovingAverage(list_of_numbers, group):
	'''Test if the moving average is exact for the group
	'''
	average_is_valid = True
	percentile_50th = group/2
	percentile_25th = group/4
	for i in range(len(list_of_numbers)-group):
		slice_of_list_of_numbers = list_of_numbers[i:(group+i)]
		if( (slice_of_list_of_numbers.count(4) - percentile_50th) == 0 ):
			if( (slice_of_list_of_numbers.count(5) - percentile_25th) == 0 ):
				if( (slice_of_list_of_numbers.count(6) - percentile_25th) == 0 ):
				 	pass
		else:
			average_is_valid = False
			break
	if(average_is_valid == True):
		print("PASSED - moving avg. ", group, " : " , list_of_numbers)
	else:
		print(i)
	return average_is_valid

def check_moving_average(list_of_numbers, number_per_group=8):
	"""
    Check if every 12 contiguous elemets have 50% of 4, and 25% of 5 and 6
    
    Parameters
    ----------
    list_of_numbers: list
    
    number_per_group: int
		Can be either 8, 16, or 20
	"""
	# TODO: Update function so that you can change the numbers and the ratios

	average_is_valid = True
	percentile_50th = number_per_group//2
	percentile_25th = number_per_group//4
# 	print("25th: ", percentile_25th)
# 	print("50th: ", percentile_50th)
    
	for i in range(len(list_of_numbers)-number_per_group):
		slice_of_list_of_numbers = list_of_numbers[i:(number_per_group+i)]
# 		print(slice_of_list_of_numbers)
		# checks to see if the difference of the number for each number
		# is less than the chosen percentile 
		if abs(slice_of_list_of_numbers.count(4) - percentile_50th) > 1 or \
        abs(slice_of_list_of_numbers.count(5) - percentile_25th) > 1 or \
        abs(slice_of_list_of_numbers.count(6) - percentile_25th) > 1:
# 			print("4: ", slice_of_list_of_numbers.count(4))
# 			print("5: ", slice_of_list_of_numbers.count(5))
# 			print("6: ", slice_of_list_of_numbers.count(6))
			average_is_valid = False
			break
	return average_is_valid

def make_criteria_list(list_of_numbers=None, number_per_group=8):
    """
    Makes a criteria list based on shuffling a list of numbers 
    until the correct number of numbers in each contigous element
    
    Parameters
    ----------
    list_of_numbers: list
	
	number_per_group: int
		Can be either 8, 16, or 20
    """
    
    if list_of_numbers is None:
        list_of_numbers = [4] * 17 + [5] * 8 + [6] * 8
    # Continues to shuffle numbers until each 12 number slice 
	# Has the correct number of each number
    while not check_moving_average(list_of_numbers, number_per_group):    
        random.shuffle(list_of_numbers)
    return list_of_numbers 



if __name__ == "__main__":
	# TODO: Add Argparse description
	parser = argparse.ArgumentParser(description='')
	parser.add_argument('output_file', type=str,
			            help='path to output file', 
						action='store', default='./ed_out_new.txt')


	# Execute the parse_args() method
	args = my_parser.parse_args()
	
	output_file = open(args.output_file, 'a');
	output_file.write("\n" + datetime.datetime.now() + "\n")
	
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