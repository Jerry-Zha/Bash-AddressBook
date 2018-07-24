#!/bin/bash

Add(){
	#echo "Add has been selected"
	echo $1,$2,$3 >> ~/.book/info.csv
}

Remove(){
	#echo "Remove has been selected"
	#grep -P "$1,$2,.*" ~/.book/info.csv
	#sed 's/\(Bob\ went,home,gmail\).*/\1/' ~/.book/info.csv
	#FIRST_NAME=$(sed -n "/$1,$2,.*/p" ~/.book/info.csv | cut -d ',' -f 1)

	IFS=$'\n'
	for line in $(cat ~/.book/info.csv); do
		echo $line | sed -n "/$1,$2,.*/p" > temp.txt
	    if [[ -s temp.txt ]]; then
	    	EMAIL=$(cat temp.txt | cut -d ',' -f 3)
	    	echo "Would you like to remove $1 $2 with email address $EMAIL?(Y/N)"
	    	read input
	    	if [[ $input = Y ]]; then
	    		sed -i "/$1,$2,$EMAIL/d" ~/.book/info.csv
	    	fi
	    	rm temp.txt
	    fi
	done
	
	#cat temp.csv
	#sed -i '/first last email/d' .book/info.txt
	
}

Search(){

	echo -e "First Name\tLast Name\tEmail"
	echo "-------------------------------------------------------------"
	if [[ $# -eq 2 ]]; then
		IFS=$'\n'
		for line in $(cat ~/.book/info.csv); do
			echo $line | sed -n "/.*,$2,.*/p" > temp.txt
		    if [[ -s temp.txt ]]; then
		    	FIRST=$(cat temp.txt | cut -d ',' -f 1)
		    	LAST=$(cat temp.txt | cut -d ',' -f 2)
		    	EMAIL=$(cat temp.txt | cut -d ',' -f 3)
		    	echo -e "$FIRST\t\t$LAST\t\t$EMAIL"
		    fi
		    rm temp.txt
		done
		
	elif [[ $# -eq 3 ]]; then
		if [[ $3 = --whole-name ]]; then
			IFS=$'\n'
			for line in $(cat ~/.book/info.csv); do
				echo $line | sed -n "/.*$2.*,.*/p" > temp.txt
			    if [[ -s temp.txt ]]; then
			    	FIRST=$(cat temp.txt | cut -d ',' -f 1)
			    	LAST=$(cat temp.txt | cut -d ',' -f 2)
			    	EMAIL=$(cat temp.txt | cut -d ',' -f 3)
			    	echo -e "$FIRST\t\t$LAST\t\t$EMAIL"
			    fi
			    rm temp.txt
			done
		elif [[ $3 = --email ]]; then
			IFS=$'\n'
			for line in $(cat ~/.book/info.csv); do
				echo $line | sed -n "/.*,.*,.*$2.*/p" > temp.txt
			    if [[ -s temp.txt ]]; then
			    	FIRST=$(cat temp.txt | cut -d ',' -f 1)
			    	LAST=$(cat temp.txt | cut -d ',' -f 2)
			    	EMAIL=$(cat temp.txt | cut -d ',' -f 3)
			    	echo -e "$FIRST\t\t$LAST\t\t$EMAIL"
			    fi
			    rm temp.txt
			done
		else
			echo "Invalid"
		fi
	elif [[ $# -eq 4 ]]; then
		if [[ $3 = --whole-name && $4 = --email ]]; then
			IFS=$'\n'
			for line in $(cat ~/.book/info.csv); do
				echo $line | sed -n "/.*$2.*/p" > temp.txt
			    if [[ -s temp.txt ]]; then
			    	FIRST=$(cat temp.txt | cut -d ',' -f 1)
			    	LAST=$(cat temp.txt | cut -d ',' -f 2)
			    	EMAIL=$(cat temp.txt | cut -d ',' -f 3)
			    	echo -e "$FIRST\t\t$LAST\t\t$EMAIL"
			    fi
			    rm temp.txt
			done
		elif [[ $4 = --whole-name && $3 = --email ]]; then
			IFS=$'\n'
			for line in $(cat ~/.book/info.csv); do
				echo $line | sed -n "/.*$2.*/p" > temp.txt
			    if [[ -s temp.txt ]]; then
			    	FIRST=$(cat temp.txt | cut -d ',' -f 1)
			    	LAST=$(cat temp.txt | cut -d ',' -f 2)
			    	EMAIL=$(cat temp.txt | cut -d ',' -f 3)
			    	echo -e "$FIRST\t\t$LAST\t\t$EMAIL"
			    fi
			    rm temp.txt
			done
		else
			echo "Invalid"
		fi
	else
		echo "Invalid"
	fi
}

Help(){

	echo "ADD"
	echo "To add an entry to the addressbook use the keyword \"add\" follow by"
	echo "first name, last name, email address. There should only be a space"
	echo "between add, first name, last name and email adresss. Quotes"
	echo "can be used if the first and last name have spaces in them"
	echo "ex) ./addressbook add \"First name\" \"Last name\" <Email>"
	echo

	echo "REMOVE"
	echo "To remove an entry from the addressbook use the keywork \"remove\""
	echo "follow by the first and last name of the person. There should only"
	echo "be a space between remove, first name and last name"
	echo "ex) ./addressbook remove \"First name\" \"Last name\""
	echo

	echo "SEARCH"
	echo "To search the addressbook use the keyword \"search\" follow by"
	echo "the person's last name"
	echo "ex) ./adressbook search \"Last name\""
	echo "		Flags"
	echo "		--whole-name"
	echo "				Use this flag to search both the first and last name"
	echo "				ex) ./addressbook search \"keyword\" --whole-name"
	echo "		--email"
	echo "				Use this flag to search only the email"
	echo "				ex) ./addressbook search \"keyword\"--email"
	echo

	echo "HELP"
	echo "provides available commands and a brief description of what each command does"
	echo "ex ./addressbook help"
	echo
}


mkdir -p ~/.book
case $1 in
	add)
		if [[ $# -ne 4 ]]; then
		 	echo "Add takes exctly 3 parameters"
		 else
		 	Add "$2" "$3" $4
		 fi 
		;;
	remove) 
		if [[ $# -ne 3 ]]; then
		 	echo "Remove takes exctly 2 parameters"
		 else
		 	Remove "$2" "$3"
		 fi 
		;;
	search) Search $@;;
	help) Help;;
	*)
		echo "Invalid option"
		echo "Use help for more information"
		;;
esac	