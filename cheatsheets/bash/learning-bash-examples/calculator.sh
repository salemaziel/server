#!/bin/bash

echo enter the first number 
read num1
echo enter the second number 
read num2

echo enter the condition to perform
echo "choose the option: add, sub"
read condition

if [[ "$condition" -eq "add" ]]; then 
sum=`expr $num1 + $num2`
echo "The result is $sum"
fi

