Iterate over an object endlessly in Python.


from itertools import cycle

my_list = ['list element 1', 'list element 2']

for list_element in cycle(my_list):
    print(list_element)
"""
The above for loop would output:
list element 1
list element 2
list element 1
list element 2
list element 1
list element 2
and so on...
"""



BETA Snippet explanation automatically generated by OpenAI:
Here is what the above code is doing:
1. Cycle through the my_list list.
2. Print the list element.
3. Go back to the beginning of the list and continue.

This is an infinite loop.

Note: This is a very powerful function.