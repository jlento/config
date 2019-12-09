#!/bin/bash

# Default project (edit)

export DEFAULT_PROJECT=project_2002239


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
    echo "${SLURM_JOB_ACCOUNT:-$DEFAULT_PROJECT}"
}

projappl () {
    readlink -e "/projappl/${SLURM_JOB_ACCOUNT:-$DEFAULT_PROJECT}"
}

scratch () {
    readlink -e "/scratch/${SLURM_JOB_ACCOUNT:-$DEFAULT_PROJECT}"
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

export -f project projappl scratch workspaces
