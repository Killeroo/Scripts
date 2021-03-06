#!/bin/bash

# Generate text files of installed and upgradable packages
apt-mark showmanual > installed.txt
apt list --upgradable | cut -d/ -f1 > updates.txt
grep -v -x -f updates.txt installed.txt > new.txt
tail -n +2 "updates.txt" > "updates.tmp" && mv "updates.tmp" "updates.txt"

# Mark entries for later post processing
sed -e 's/$/ YYYYY/' -i new.txt
sed -e 's/$/ ZZZZZ/' -i updates.txt

# Sort and combine
cat new.txt updates.txt | sort > combo.txt

# Mark packages using ANSI colors
printf '\n\e[4mPACKAGES:\e[0m\n'
while read line
do
    if [[ $line == *"YYYYY"* ]]; then
    	string=${line/YYYYY/ }
    	printf '\e[30m\e[102m[UP-TO-DATE]\e[0m %s \n' "$string"
    elif [[ $line == *"ZZZZZ"* ]]; then
	string=${line/ZZZZZ/ }
	printf '\e[30m\e[101m\e[5m[OUT-OF-DATE]\e[0m %s \n' "$string"
    fi
done < "combo.txt"

# Count entries in each file
installed_packages=$(cat installed.txt | wc -l)
outdated_packages=$(cat updates.txt | wc -l)
percent=$(awk "BEGIN { pc=100*${outdated_packages}/${installed_packages}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

# Display stats
echo "$installed_packages installed, $outdated_packages can be upgraded"
echo

# Cleanup
rm installed.txt updates.txt combo.txt new.txt
