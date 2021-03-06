"""
Example Commands:
    python .\MRI\pythonscript\id_new_python_3.py --list_of_numbers 4 6 5 4 4 4 5 6 6 4 4 4 5 4 5 6 6 4 4 5 4 5 6 5 4 6 4 5 4 6 4 4
    python .\MRI\pythonscript\id_new_python_3.py --number_to_ratio_dict 5=0.25, 4=0.5, 6=0.25
"""
from time import *
import random 
import argparse
import datetime
import collections 

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
            break
    return True

def calculate_moving_averages(list_of_numbers, number_per_group=8):
    """
    Count the number of numbers for each group within a list of numbers

    Parameters
    ----------
    list_of_numbers: list

    number_per_group: int
        Can be either 8, 16, or 20
    """
    list_of_averages = []
    # iterating through each group that has the length of number_per_group
    for i in range(len(list_of_numbers) - number_per_group):
        slice_of_list_of_numbers = list_of_numbers[i:i + number_per_group]
        # counting the number of number in each group
        number_of_numbers = collections.Counter(slice_of_list_of_numbers)
        # sorting the dictionary so that the keys are in the same order
        ordered_number_of_numbers = collections.OrderedDict(sorted(number_of_numbers.items()))
        list_of_averages.append(ordered_number_of_numbers)
    return list_of_averages

def check_moving_average_is_close(list_of_numbers, number_per_group=8, number_to_ratio_dict=None):
    """
    Check if every n-number of elements have 50% of 4, and 25% of 5 and 6
    
    Parameters
    ----------
    list_of_numbers: list
    
    number_per_group: int
        8, 12, 16, or 20 is recommended
        
    number_to_ratio_dict: dict 
    """
    if number_to_ratio_dict is None:
        number_to_ratio_dict = {4:0.5, 5:0.25, 6:0.25}
    
    number_per_group_dict = {}
    for key, value in number_to_ratio_dict.items():
        # calculating the number of number needed for each key
        number_per_group_dict[key] = number_per_group * value
    
    for i in range(len(list_of_numbers)-number_per_group):
        slice_of_list_of_numbers = list_of_numbers[i:(number_per_group+i)]
        # checks to see if the difference of the number for each number
        # is less than the chosen percentile 
        for key, value in number_per_group_dict.items():
            if abs(slice_of_list_of_numbers.count(key) - value) > 1:
                return False
    return True

def check_moving_average_is_exact(list_of_numbers, number_per_group=8, number_to_ratio_dict=None):
    """
    Check if every n-number of elements have 50% of 4, and 25% of 5 and 6
    
    Parameters
    ----------
    list_of_numbers: list
    
    number_per_group: int
        8, 12, 16, or 20 is recommended
        
    number_to_ratio_dict: dict 
    """
    if number_to_ratio_dict is None:
        number_to_ratio_dict = {4:0.5, 5:0.25, 6:0.25}
    
    number_per_group_dict = {}
    for key, value in number_to_ratio_dict.items():
        # calculating the number of number needed for each key
        number_per_group_dict[key] = number_per_group * value
    
    for i in range(len(list_of_numbers)-number_per_group):
        slice_of_list_of_numbers = list_of_numbers[i:(number_per_group+i)]
        # checks to see if the difference of the number for each number
        # is less than the chosen percentile 
        for key, value in number_per_group_dict.items():
            if abs(slice_of_list_of_numbers.count(key) - value) >= 1:
                return False
    return True

def make_close_criteria_list(list_of_numbers=None, number_per_group=8, number_to_ratio_dict=None):
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
        list_of_numbers = [4] * 16 + [5] * 8 + [6] * 8
    random.shuffle(list_of_numbers)
    
    if number_to_ratio_dict is None:
        number_to_ratio_dict = {4:0.5, 5:0.25, 6:0.25}
    
    # Continues to shuffle numbers until each 12 number slice 
    # Has the correct number of each number
    while not check_moving_average_is_close(list_of_numbers=list_of_numbers, \
        number_per_group=number_per_group, number_to_ratio_dict=number_to_ratio_dict):    
        random.shuffle(list_of_numbers)
    return list_of_numbers 

def make_exact_criteria_list(list_of_numbers=None, number_per_group=8, number_to_ratio_dict=None):
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
        list_of_numbers = [4] * 16 + [5] * 8 + [6] * 8
    random.shuffle(list_of_numbers)

    if number_to_ratio_dict is None:
        number_to_ratio_dict = {4:0.5, 5:0.25, 6:0.25}
    
    # Continues to shuffle numbers until each 12 number slice 
    # Has the correct number of each number
    while not check_moving_average_is_exact(list_of_numbers=list_of_numbers, \
        number_per_group=number_per_group, number_to_ratio_dict=number_to_ratio_dict):    
        random.shuffle(list_of_numbers)
    return list_of_numbers 

class ParseKwargs(argparse.Action):
    """
    Class that overrides the __call__ method in argparse.Action 
    so that we can parse out key, value pairs. Each key and value pair
    needs to be seperated by a '=' and a ' ' between pairs. 

    Parameters
    ----------
    argparse.Action: argparse Action subclass
    
    Credit: https://sumit-ghosh.com/articles/parsing-dictionary-key-value-pairs-kwargs-argparse-python/
    """
    def __call__(self, parser, namespace, values, option_string=None):
        # Updating namespace.dest to a dict
        setattr(namespace, self.dest, dict())
        for value in values:
            # parsing out the key, value pair by equal sign
            key, value = value.split('=')
            # converting from string to numbers
            numerical_key, numerical_value = int(key), float(value)
            # Updating the namespace.dest dictionary with the key, value pair
            getattr(namespace, self.dest)[numerical_key] = numerical_value

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Creates a list of numbers that has every n-number of slices with the same ratio of numbers')
    parser.add_argument('--output_file', type=str,
                        action='store', default="./ed_out_new.txt",
                        nargs="?", const="./ed_out_new.txt",
                        help='path to output file')

    parser.add_argument('--count', type=int,
                        action='store', default=1,
                        nargs="?", const=1,
                        help='number of times to make a criteria list')

    parser.add_argument('--number_per_group', type=int,
                        action='store', default=8,
                        nargs="?", const=8,
                        help='number of numbers for each slice')

    parser.add_argument('--list_of_numbers', type=int,
                        action='store', default=None,
                        nargs="+", help='List of numbers to make a criteria list from')

    parser.add_argument('--number_to_ratio_dict', nargs='*', 
                        action=ParseKwargs, default=None,
                        help="The number to the ratio of the number in each slice. \
                        Make sure that the key and value is seperated by an '='\
                        and each pair by a ' ', space")

    args = parser.parse_args()

    output_file = open(args.output_file, 'a');
    output_file.write(str(datetime.datetime.now()) + "\n")

    for i in range(args.count):
        criteria_list = make_close_criteria_list(list_of_numbers=args.list_of_numbers, \
            number_per_group=args.number_per_group, number_to_ratio_dict=args.number_to_ratio_dict)
        output_file.write(str(criteria_list) + "\n")

    output_file.close()
