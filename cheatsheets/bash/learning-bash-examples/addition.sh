#!/bin/bash

echo -n "enter first number"
read first
echo -n "enter second number"
read second

 RESULT=$(( first + second ))

echo result is $RESULT

RESULT=$(( first * second ))

echo RESULT is $RESULT
