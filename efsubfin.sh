#!/bin/bash

# Banner
figlet "EfSubFin"

# Taking domain input
echo "Please enter the target domain"
read -p "=> " domain
echo ""

# Taking ping test input
echo "Would you like to check weather the host is up or not?"
read -p "(y/n)=> " up_or_not
echo ""

# Dividing tasks
case $up_or_not in
	y)
		echo -e "\033[0;32m[+] Executing ping test\033[0m"
		ping -c 2 $domain;;
	n)
		echo -e "\033[0;32m[*] Executing without ping test\033[0m";;
	*)
		echo -e "033[0;31m[-] Invalid option !\033[0m";;
	esac

echo ""

# Taking tool choice
echo "===== Available options ====="
echo "{1} for Sublist3r [dosent work now-a-days]"
echo "{2} for amass [efficient but slow]"
echo "{3} for subfinder [fastest + recommanded]"
echo "{4} to quit"
read -p "=> " choice
echo ""
echo ""

# Making/entering directory
if [[ -d ./$domain ]]
then
	cd $domain
else
	mkdir ./$domain
	cd ./$domain
fi

# Performing tasks accordingly
if [[ $choice == 1 ]]
then
	# Starting sublist3r
	touch $domain.sublist3r.txt
	echo -e "Executing command: \033[0;31msublist3r -d $domain > $domain.sublist3r.txt\033[0m"
	echo -e "Please be patient..."
	sublist3r -d $domain > $domain.sublit3r.txt
	echo "\033[0;32m[output saved in]: $domain.sublist3r.txt\033[0m"
elif [[ $choice == 2 ]]
then	
	# Starting amass
	touch $domain.amass.txt
	echo -e "Executing command: \033[0;31mamass enum -d $domain > $domain.amass.txt\033[0m"
	echo "Please be patient..."
	amass enum -d $domain > $domain.amass.txt
	echo -e "\033[0;32m[output saved in]: $domain.amass.txt\033[0m"
elif [[ $choice == 3 ]]
then
	# Starting subfinder
	touch $domain.subfinder.txt
	echo -e "Executing command: \033[0;31msubfinder -d $domain >  $domain.subfinder.txt\033[0m"
	echo "This will be quick"
	subfinder -d $domain > $domain.subfinder.txt
	echo -e "\033[0;32m[output saved in]: $domain.subfinder.txt\033[0m"
	echo ""
elif [[ $choice == 4 ]]
then
	echo "See You !!!"
	exit
else
	echo -e "\033[0;31mInvalid option\033[0m"
fi

# Merger and sort output
echo "Would you like to merger and sort the output or keep it raw ?"
echo "(1). Keep Raw"
echo "(2). Merger and Sort [Recommanded]"
read -p "=> " choice2

# Dividing tasks
if [[ $choice2 == 1 ]]
then
	echo -e "\033[0;33mOhk, Keeping raw data"
	exit
elif [[ $choice2 == 2 ]]
then
	echo -e "\033[0;32mMerging and sorting data...\033[0m"
	cat *.txt | sort -u > $domain.sorted.txt
	total_s_doms=$(cat $domain.sorted.txt | wc -l)
	echo "Total sorted domains: ${total_s_doms}"
	echo ""
else
	echo "Invalid input !"
	exit
fi

# Using httprobe for working domains
echo "Do you want to use httprobe to check for working domains ?"
read -p "(y/n)=> " choice3

# Dividing tasks
if [[ $choice3 == "y" ]]
then
	echo -e "\033[0;33mStarting httprobe..."
	cat $domain.sorted.txt | httprobe | tee -a $domain.httprobe.txt
elif [[ $choice3 == "n" ]]
then
	echo -e "Ohk, Thanks for usign the script !"
	exit
else
	"Invalid option !"
fi
