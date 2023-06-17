#!/bin/bash
#
#== == Date : May 18, 2022
#== == Name :
#== Creator : Jay Vasallo - Clanwarz Inc.
#== =====================================>

#== Script Variables
scriptName="XXX"

#== Colors
rt=$(tput sgr0); r=$(tput setaf 1); g=$(tput setaf 2); y=$(tput setaf 3); c=$(tput setaf 6); b=$(tput bold);

#== Remote Directories
wDir="$(realpath .)"

#== Time
start="$(date +%s)"

#== Let's Begin
#== ===========
echo "${b}${r}[${rt}${b}${y}$(date +"%m-%d-%Y %H:%M:%S")${b}${r}]${rt} - ${b}${g}Starting:${rt} ${b}${c}${scriptName}${rt} ${b}${y}...${rt}"; sleep 1