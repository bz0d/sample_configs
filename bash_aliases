
# Search a maillog file (or a gzip'ed rotated copy) for a string, then pull the message-id and re-search for it in the same log.  
# This is useful when for example looking for something that initiated mail send at a given timestamp, but may not have completed 
# in that same second or minute (and this method lets you be specific about the timestamp and still limit results to relevant entries 
# in the maillog. Note:  "MMM DD HH:MM:SS" - the day is padded with a space when day is 1 .. 9 
function grep_maillog () {
        logfile="$1"
        sstring="$2"
        cd /var/log/
        sstr=`zgrep -E "${sstring}" "${logfile}"  |awk '{print $6}'|awk -F':' '{print $1}' | sort| uniq|xargs -I{} echo -n "{}|" |sed -e 's/|$//'`
        if [ x"${sstr}" != "x" ]
        then
                zgrep -E "(${sstr})" "${logfile}"
                #echo "searched for : ${sstr}"
                return
        else
                echo "no matches found for ${sstring}"
                return 99
        fi
}

# Get the git status info for each directory in a parent dir - useful if you have a directory containing a set of working copies of cloned/etc 
# git repos
function git_statuses () { 
	for i in */
	do 
		if [ -d "$i/.git" ]
		then 
			cd $i && echo "** $i **" && git status && echo "" && cd .. 
		fi
	done 
}
