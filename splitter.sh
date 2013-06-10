#!/bin/bash

# splitter.sh - split a file into more parts
# Copyright (C) 2013 Sergio Sicari
#
# Ex.: ./splitter.sh -f annuncidaimportare.csv -s .php -p k_ -l 10000 -r 's/;/,/' -t "<?php \$aIds=array(" -b ");" -b ");" -z 3 -d

function usage(){
cat << EOF
NAME
		splitter.sh - split a file in more parts

SYNOPSIS
        $0 [OPTIONS]

DESCRIPTION
        The script create more files
        Ex.: ./splitter.sh -f annuncidaimportare.csv -s .php -p k_ -l 10000 -r 's/;/,/' -t "<?php \$aIds=array(" -b ");" -z 3 -d
        
		-s, --suffix
			Set a suffix [optional]
		
		-p, --prefix PATH
			Set a prefix [optional]
		
		-l, --limit
			Set file limit [required]
		
		-f, --filesource
			Set filesource to split [required]
			
		-r, --replace
			Set a sed replace pattern (it's apply to every row) [optional]

		-t, --top
			Set a file header (it's apply to every generated file) [optional]
		
		-b, --bottom
			Set a file footer (it's apply to every generated file) [optional]

		-z, --zero-padding
			Set how long zero padding (it's apply to every generated file) [optional]
			
		-d, --debug
			Output more info about execution [optional]
        	
		-h, --help
			Output this brief help message
			
EOF
}

# debug mode
DEBUG_OUTPUT=0
# suffix part file
SUFFIX=''
# prefix part file
PREFIX=''
# limit part file size
LIMIT=0
# sed pattern (apply on every row)
SED_PATTERN=''
# header
TOP=''
# footer
FOOTER=''
# zero padding
PADDING=0

BIN=/usr/bin

if [ $# == 0 ]; then
    usage
    exit
fi
while true; do
    case $# in
        0)
            ;;
    esac
    case $1 in
		-f|--filesource)
			shift
    	    		FILE_SOURCE=$1
    	    		shift
    	    		;;
    		-s|--suffix)
    			shift
    			#set suffix
			SUFFIX=$1
    			shift
    			;;
    		-p|--prefix)
    			shift
    			#set prefix
			PREFIX=$1
			shift
			;;
		-l|--limit)
			shift
			#set limit
			LIMIT=$1
			shift
			;;
		-r|--replace)
			shift
			#set a sed pattern 
			SED_PATTERN=$1
			shift
			;;
		-t|--top)
			shift
			#set a file header
			TOP=$1
			shift
			;;
		-b|--bottom)
			shift
			#set a file footer
			BOTTOM=$1
			shift
			;;
		-z|--zero-padding)
			shift
			#set how zero padding
			PADDING=$1
			shift
			;;
		-d|--debug)
			#set debug mode
    			DEBUG_OUTPUT=1
    			shift
    			;;
        	-h|--help)
            		usage
            		exit
            		;;
        	*)
            break
            ;;
    esac
done

# limit is required ...
if [ $LIMIT -eq 0 ]; then
	usage
	exit
fi

# file source is required ...
if [ "x$FILE_SOURCE" == "x" ]; then
	usage
	exit
fi

split -d -l $LIMIT $FILE_SOURCE

# header php in tmp file
cat << EOF > tmpHeader
$TOP
EOF

#sed -i 's/;/,/' x*
if [ "x$SED_PATTERN" != "x" ]; then
	sed -i $SED_PATTERN x*
fi

LOOP=0
for f in ./x*
do
	cat tmpHeader > tmpBody
	cat $f >> tmpBody
	echo $BOTTOM >> tmpBody
	# if is set pad option
	if [ $PADDING -gt 0 ]; then
		CURRENT_PART=`printf "%0"$PADDING"d" $LOOP`
	else
		CURRENT_PART=$LOOP
	fi
	if [ $DEBUG_OUTPUT -eq 1 ]; then
		echo -e "\033[1;32m[File $CURRENT_PART.php - OK]\033[0m"
	fi
	cat tmpBody > $PREFIX$CURRENT_PART$SUFFIX 
	let "LOOP=LOOP+1"
done

if [ $DEBUG_OUTPUT -eq 1 ]; then
	echo -e "\033[1;32m[Clean temporary files]\033[0m"
fi

# remove temp file
rm x*
rm tmpHeader
rm tmpBody
		
