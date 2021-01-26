#!/bin/bash

# Short project descptions (edit)

export PROJECTS='
    [jlento]="Account jlento"
    [project_2002239]="CSC Juhas"
    [project_2001659]="CSC Staff"
    [project_2001029]="UH OpenEPS"
    [project_2000652]="UH CMIP6"
    [atm]="UH INAR"
    [project_2002037]="FMI CSC Staff"
    [project_2001635]="FMI Staff"
    [project_2001634]="FMI Pilot"
'

workspaces () {
    eval local -A projects=( $PROJECTS )
    local scratches=$(cd /scratch; readlink -e $(id -Gn))
    local format="%-17s %-29s %14s %15s\n"
    local d a c f
    printf "$format" Description Directory Capacity Files
    for d in /users/$USER ${scratches//scratch/projappl} ${scratches}; do
	a=($(lfs project -d $d))
	a=($(lfs quota -hqp ${a[0]} $d))
	c=''; f=''
	[ -z "${a[1]##*\*}" ] && a[1]=${a[1]%\*} && c='*'
	[ -z "${a[5]##*\*}" ] && a[5]=${a[5]%\*} && f='*'
	printf "$format" "${projects[${d##*/}]}" ${a[0]} \
	    $c${a[1]}/${a[2]} $f$((a[5]/1000))k/$((a[6]/1000))k
    done | sort
}

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

projects () {
    local dataroot=/appl/system/data/project_info/int
    local projects=$(
	while read_dom; do
	    [ "${ENTITY}" = "project" ] && echo "$CONTENT"
	done < ${dataroot}/user/$USER.xml
    )
    local p r="[[:space:]]"
    for p in $projects ; do
	if [ -f ${dataroot}/project/$p.xml ]; then
	    echo "----------------------------------------------------"
	    while read_dom; do
		if [ -n "$ENTITY" ] && [[ ! "$CONTENT" =~ $r ]]; then
		    echo "${ENTITY}: ${CONTENT}"
		fi
	    done < ${dataroot}/project/$p.xml
	fi
    done
}

mahti-top-running () {
    squeue -h -t R -o "%u %C" | \
	awk '{
                n[$1] += $2
                if (length($1) > l) l = length($1)
             }
             END{
                for (i in n) printf "%-*s%s\n", l + 2, i, n[i]
             }' | \
	sort -r -n -k 2
}

mahti-node-status () {
    local p="fmi,fmitest"
    printf "In partitions %s\n" "$p"
    sinfo -h -p "$p" --Node -O nodelist,statelong | sort -u | \
	awk '{
                 n[$2]++;t++
             }
             END{
                 print "    total    ", t
                 for (i in n) printf "    %-10s%s\n", i, n[i]
             }'
    local p="gpu,gputest,hugemem,hugemem_longrun,large,longrun,small*,test"
    printf "In partitions %s\n" "$p"
    sinfo -h -p "$p" --Node -O nodelist,statelong | sort -u | \
	awk '{
                 n[$2]++;t++
             }
             END{
                 print "    total    ", t
                 for (i in n) printf "    %-10s%s\n", i, n[i]
             }'
}

partitions () {
    usage="$0 [-u USER] [-A account]"
    local user account
    while [ -n "$1" ]
    do
	case "$1" in
	    -u) shift; user="User=$1" ;;
	    -A) shift; account="Account=$1" ;;
	    *) echo "$usage" ;;
	esac
	shift
    done
    [ -z "$user" -a -z "$account" ] && user="User=$USER"
    echo "Available partitions and their limits:"
    sacctmgr -p show associations where ${user} ${account} | awk -F '|' '{print $2,$4,$8?$8:"-",$12,$15}' | column -t
}

export -f workspaces read_dom projects mahti-top-running mahti-node-status partitions
