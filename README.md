splitter
========

splitter is a shell script that split a file in more part (using split command). With splitter you can set header/footer, prefix/suffix and apply a sed pattern for replace recursively every row in source file  

NAME
  	    splitter.sh - split a file in more parts

SYNOPSIS
        $0 [OPTIONS]

DESCRIPTION

        The script create more files
        
        Ex.: ./splitter.sh -f annuncidaimportare.csv -s .php -p k_ -l 10000 -r 's/;/,/' -t "<?php \$aIds=array(" -b ");" -d
        
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
			
		-d, --debug
			Output more info about execution [optional]
        	
		-h, --help
			Output this brief help message
