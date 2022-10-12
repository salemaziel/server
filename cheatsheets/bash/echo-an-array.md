How to Echo Array
You can define three elements array (there is no space between the name of an array variable, equal symbol, and starting bracket):

FILES=(report.jpg status.txt scan.jpg)
This command will write each element in the array:

echo ${FILES[*]}
Index in shell arrays starts from 0. So, if you want to write just the first element, you can do this command:

echo ${FILES[0]}
Output: report.jpg

Do you want to process each element in the array in the loop? Here is an example:

for ELEMENT in ${FILES[@]}
do
echo File: $ELEMENT.
done
If you want to get only indexes of the array, try this example:

echo ${!FILES[@]}
“${!FILES[@]}” is a relatively new bash feature, it was not included in the original array implementation.



https://linuxcent.com/bash-how-to-echo-array/