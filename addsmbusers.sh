#!/usr/bin/env bash

# Create a system + samba account for each user of the given file.

if [ $# != 1 ]
then
    echo "Usage: ./addsmbusers.sh users.txt"
    echo "<users.txt> being a CSV file where each line is structured as follows:"
    echo "    login,group,password,last name,first name"
    exit
fi

FILE=$1

# Create the necessary groups
groupadd dev
groupadd system

while read USER;
do
    LOGIN=$(echo $USER | cut -d ',' -f 1)
    GROUP=$(echo $USER | cut -d ',' -f 2)
    PASSWD=$(echo $USER | cut -d ',' -f 3)
    LASTNAME=$(echo $USER | cut -d ',' -f 4)
    FIRSTNAME=$(echo $USER | cut -d ',' -f 5)

    # Add user to system
	useradd -M -g "$GROUP" -c "$LASTNAME $FIRSTNAME" -p $PASSWD $LOGIN
    # Add user to samba
	(echo $PASSWD; echo $PASSWD) | smbpasswd -as "$LOGIN"

    # In case we want to remove all users, uncomment:
	#pdbedit -x "$LOGIN"
	#if [ $? != 0 ]
	#then
	#	echo "Erreur smbpasswd"
	#fi
	#userdel "$LOGIN"
	#if [ $? != 0 ]
	#then
	#	echo "Erreur userdel"
	#fi
done < "$FILE"
