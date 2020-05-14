#!/bin/bash

# @file declareDeletion.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# Definition of functions used to declare directories and files to delete

###
# MIT License
#
# Copyright (c) 2020 SignC0dingDw@rf
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
###

###
# Copywrong (w) 2020 SignC0dingDw@rf. All profits reserved.
#
# This program is dwarven software: you can redistribute it and/or modify
# it provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copywrong 
#      notice and this list of conditions and the following disclaimer 
#      or you will be chopped to pieces AND eaten alive by a Bolrag.
#
#    * Redistributions in binary form must reproduce the above copywrong
#      notice, this list of conditions and the following disclaimer in 
#      the documentation and other materials provided with it or they
#      will be axe-printed on your stupid-looking face.
# 
#    * Any commercial use of this program is allowed provided you offer
#      99% of all your benefits to the Dwarven Tax Collection Guild. 
# 
#    * This software is provided "as is" without any warranty and especially
#      the implied warranty of merchantability or fitness to purport. 
#      In the event of any direct, indirect, incidental, special, examplary 
#      or consequential damages (including, but not limited to, loss of use;
#      loss of data; beer-drowning; business interruption; goblin invasion;
#      procurement of substitute goods or services; beheading; or loss of profits),   
#      the author and all dwarves are not liable of such damages even 
#      the ones they inflicted you on purpose.
# 
#    * If this program "does not work", that means you are an elf 
#      and are therefore too stupid to use this program.
# 
#    * If you try to copy this program without respecting the 
#      aforementionned conditions, then you're wrong.
# 
# You should have received a good beat down along with this program.  
# If not, see <http://www.dwarfvesaregonnabeatyoutodeath.com>.
###

### Protection against multiple inclusions
if [ -z "${SETUP_DECLAREDELETION_SH}" ]; then

SCRIPT_LOCATION_SETUP_DECLAREDELETION_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_SETUP_DECLAREDELETION_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_SETUP_DECLAREDELETION_SH}/../../Printing/debug.sh"

SETUP_DECLAREDELETION_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using SETUP_DECLAREDELETION_SH=""

##!
# @brief Declare elements to delete
# @param @ : List of elements to delete at the end of test
# @return 0 if all elements are added to deletion list
#         1 if no elements were provided
#
##
DeclElementsToDel()
{
    local elements=("$@")
    local element=""
    if [ "${#elements[@]}" -eq "0" ]; then 
        PrintError "You should specify elements to delete"
        return 1       
    fi

    PrintInfo "Adding the following elements for deletion : "
    PrintInfo "${elements[@]}"
    ELEMENTS_CREATED+=("${elements[@]}") # Append elements to the array
    return 0
}

##!
# @brief Create folders then declare them as elements to delete
# @param @ : List of folders to create and delete at the end of test
# @return 0 if all folders could be created
#         1 if no folder to create is specified
#         >0 the number of folders that were not created
#
# If a folder already exists, creation is considered a failure and folder is not added to list of elements to delete.
# Only creates folder not its parents. If parents do not exist, creation fails.
#
##
DeclMkFoldersToDel()
{
    local folders=("$@")
    local failedCreation=0

    if [ "${#folders[@]}" -eq "0" ]; then 
        PrintError "You should specify folders to create"
        return 1       
    fi

    for folder in ${folders[@]}; do
        PrintInfo "Creating ${folder} folder"
        mkdir ${folder}
        local result=$?
        if [ ${result} -eq 0 ]; then
            DeclElementsToDel ${folder} # Declare folder to be deleted
        else
            PrintWarning "Failed to create ${folder} directory with code ${result}"
            ((failedCreation++))
        fi
    done
    return ${failedCreation}
}

##!
# @brief Create files then declare them as elements to delete
# @param @ : List of files to create and delete at the end of test
# @return 0 if all files could be created
#         1 if no file to create is specified
#         >0 the number of files that were not created
#
# If a file already exists, creation is considered a failure and file is not added to list of elements to delete.
# Only creates file not its parents. If parents do not exist, creation fails.
#
##
DeclMkFilesToDel()
{
    local files=("$@")
    local failedCreation=0

    if [ "${#files[@]}" -eq "0" ]; then 
        PrintError "You should specify files to create"
        return 1       
    fi

    for f in ${files[@]}; do
        PrintInfo "Creating ${f} file"
        if [[ ! -e ${f} ]]; then
            touch ${f}
            local result=$?
            if [ "${result}" -eq "0" ]; then
                DeclElementsToDel ${f} # Declare file to be deleted
            else
                PrintWarning "Failed to create ${f} file with code ${result}"
                ((failedCreation++))
            fi
        else
            PrintWarning "File ${f} already exists. It should be diverted."
            ((failedCreation++))
        fi
    done
    return ${failedCreation}
}


fi # SETUP_DECLAREDELETION_SH

#  ______________________________ 
# |                              |
# |    ______________________    |
# |   |                      |   |
# |   |         Sign         |   |
# |   |        C0ding        |   |
# |   |        Dw@rf         |   |
# |   |         1.0          |   |
# |   |______________________|   |
# |                              |
# |______________________________|
#               |  |
#               |  |
#               |  |
#               |  |
#               |  |
#               |  |
#               |  |
#               |  |
#               |  |
#               |  |
#               |__|
