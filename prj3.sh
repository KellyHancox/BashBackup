#!/bin/bash

#These variables are used to display the count and silence options
silence=false
count=false

#These are counters for the number of backed up files 
backedup=0
notbackedup=0

#Checking for backup file, making one if there is not one
if test ! -d ./backup
then
       echo "Creating backup folder"	
       mkdir -p ./backup
       cd backup
fi

#If there are no arguments
if [ $# -eq 0 ];
then
	echo "No arguments provided"
	exit 1
fi

#Searches through all arguments
while test $# -gt 0
do
	arg=$1
	case "$arg" in

		#If -s is an argument, then it will silence the messages notifying of not backedup files
		-s)
			silence=true
			;;

		#If count is true, the count of backed up files and not backed up files will display
		-c)
			count=true
			;;

		#If help is asked for, this menu will display
		--help)
			echo "============================================================================"
			echo "The purpose of this program is to back up your files"
			echo "The command '-s' will silence the notification of any files not backed up"
			echo "The command '-c' will give you the current count of backed up files"
			echo "the command '--help' will give you this menu"
			echo "============================================================================="
			;;

		#If any other argument is provided, it will check if it is a file or directory already
		*)
			#If it is a directory
			if [ -f $arg ];
			then
				#if it already exists then it will check if it is newer than the one in the folder
				if [ -f /home/hancoxk/CIS241/$arg ]
				then
					#If it is newer than the one in backup, then it will update
					if [ /home/hancoxk/CIS241/$arg -nt /home/hancoxk/CIS241/backup/$arg ]
					then
						cp -u /home/hancoxk/CIS241/$arg /home/hancoxk/CIS241/backup
						echo "File updated"
						let "backedup=backedup+1"

					#If it is not newer, then it will not update
					else
						if [ ! "$silence" = true ]
						then
							echo "File not updated, not newer than before"
						fi
						
					let "notbackedup=notbackedup+1"
					fi

				#If it is not already in backup, then it will just be added for a first time
				else
					cp -u /home/hancoxk/CIS241/$arg /home/hancox/CIS241/backup
					let "backedup=backedup+1"
					echo "File has been backed up"
				fi

			#Same as before, but checks for directory
			elif [ -d $arg ]
			then
				#If already in backup, then it will check if the directory is newer than before
				if [ -d /home/hancoxk/CIS241/$arg ]
				then
					#If it is newer, it will backup again
					if [ /home/hancoxk/CIS241/$arg -nt /home/hancoxk/CIS241/backup/$arg ]
					then
						cp -u -R /home/hancoxk/CIS241/$arg /home/hancoxk/CIS241/backup
						echo "Directory has been updated"
						let "backedup=backedup+1"
					
					#If it is not newer, then it will not backup again
					else
						if [ ! "$silence" = true ]
						then
							echo "Directory not updated, not newer than before"
						fi

						let "notbackedup=notbackedup+1"
					fi
				
				#If it didn't exist in backup, it will just be backed up 
				else
					cp -u /home/hancoxk/CIS241/$arg /home/hancoxk/CIS241/backup
					let "backedup=backedup+1"
					echo "Directory has been backed up"
				fi

			#If it's not a file or a directory, then it will not be backed up
			else
				if [ ! "$silence" = true ]
				then
					echo "Not a valid file"
				fi
				
				let "notbackedup=notbackedup+1"
			fi
			;;
	esac
	shift
done

#If count is true, then it will display the final number of backed up files
if [ "$count" = true ]
then
	echo "Backed up items: $backedup"
	echo "Not backed up items: $notbackedup"
fi

