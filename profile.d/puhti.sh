#!/bin/bash

# Default project (edit)

export PROJECT=project_2002239


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

project () {
    echo "${SLURM_JOB_ACCOUNT:-$PROJECT}"
}

projappl () {
    readlink -e "/projappl/${SLURM_JOB_ACCOUNT:-$PROJECT}"
}

scratch () {
    readlink -e "/scratch/${SLURM_JOB_ACCOUNT:-$PROJECT}"
}

workspaces () {
    eval local -A projects=( $PROJECTS )
    local scratches=$(cd /scratch; readlink -e $(id -Gn))
    local format="%-17s %-29s %14s %15s\n"
    local d a
    printf "$format" Description Directory Capacity Files
    for d in /users/$USER ${scratches//scratch/projappl} ${scratches}; do
	a=($(lfs project -d $d))
	a=($(lfs quota -hqp ${a[0]} $d))
	printf "$format" "${projects[${d##*/}]}" ${a[0]} \
	    ${a[1]}/${a[2]} $((a[5]/1000))k/$((a[6]/1000))k
    done | sort
}

puhti-top-running () {
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

puhti-node-status () {
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

export -f project projappl scratch workspaces puhti-top-running puhti-node-status
