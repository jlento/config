#!/bin/bash

# Default project (edit)

PROJECT=project_2001659


# Short project descptions (edit)

declare -A PROJECTS=(
    [jlento]="Account jlento"
    [project_2001659]="CSC Staff"
    [project_2001029]="HY OpenEPS"
    [project_2000652]="HY CMIP6"
    [atm]="HY INAR"
    [project_2002037]="FMI CSC Staff"
    [project_2001635]="FMI Staff"
    [project_2001634]="FMI Pilot"
)


# Default directories based on PROJECT

SCRATCH=$(cd /scratch; readlink -e $PROJECT)
PROJAPPL=${SCRATCH//scratch/projappl}


# Lists home, application and scratch directories, and their quotas

workspaces () {
    local scratches=$(cd /scratch; readlink -e $(id -Gn))
    local format="%-17s %-29s %14s %15s\n"
    local d a
    printf "$format" Description Directory Capacity Files
    for d in /users/$USER ${scratches//scratch/projappl} ${scratches}; do
	a=($(lfs project -d $d))
	a=($(lfs quota -hqp ${a[0]} $d))
	printf "$format" "${PROJECTS[${d##*/}]}" ${a[0]} \
	    ${a[1]}/${a[2]} $((a[5]/1000))k/$((a[6]/1000))k
    done | sort
}


export PROJECT PROJECTS SCRATCH PROJAPPL
export -f workspaces
