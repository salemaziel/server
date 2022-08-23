#!/bin/bash
NAME[0]="Vicky"
NAME[1]="Tony"
NAME[2]="Vampire"
NAME[3]="Twilight"

echo "output of array*: ${NAME[*]}"
echo "output of array@ : ${NAME[@]}"
echo "output of !array@ : ${!NAME[@]}"
echo "output of #array@ : ${#NAME[@]}"
echo "output of array0 : ${#NAME[0]}"



