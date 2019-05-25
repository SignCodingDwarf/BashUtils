#!/bin/bash

# file :  cleanUtils.sh
# author : SignC0dingDw@rf
# version : 1.0
# date : 25 May 2019
# Definition of utility functions to clean environment after test

###
# MIT License
#
# Copyright (c) 2019 SignC0dingDw@rf
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
# Copywrong (w) 2019 SignC0dingDw@rf. All profits reserved.
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
if [ -z ${CLEANUTILS_SH} ]; then

CLEANUTILS_SH="CLEANUTILS_SH" # Reset using CLEANUTILS_SH=""

### Inclusions
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/printUtils.sh"

### Functions
##!
# @brief Delete all the provided directories
# @param 1 : List of dirs to delete
# @return 0 if all dirs where deleted, >0 for every dir not deleted
#
# A deletion is considered a failure if and only if the directory still exists and deletion failed.
# If the directory does not exist for whatever reason, we do not consider deletion a failure
#
##
DeleteDirs()
{
    local NB_FAILS=0 # Number of directory delete failures
    local DIRS=("$@")
    for dir in "${DIRS[@]}"; do 
        PrintInfo "Deleting ${dir}"
        rm -rf ${dir}
        if [ $? -gt 0 ]; then # Command is expected to return 0 when not failing
            ((NB_FAILS++))
        fi
    done

    return $NB_FAILS
}

##!
# @brief Delete all the provided files
# @param 1 : List of files to delete
# @return 0 if all files where deleted, >0 for every file not deleted
#
# A deletion is considered a failure if and only if the file still exists and deletion failed.
# If the file does not exist for whatever reason, we do not consider deletion a failure
#
##
DeleteFiles()
{
    local NB_FAILS=0 # Number of file delete failures
    local FILES=("$@")
    for file in "${FILES[@]}"; do 
        PrintInfo "Deleting ${file}"
        rm -f ${file}
        if [ $? -gt 0 ]; then # Command is expected to return 0 when not failing
            ((NB_FAILS++))
        fi
    done

    return $NB_FAILS
}

##!
# @brief Restore provided dirs
# @param 1 : List of dirs to restore
# @return 0 if all dirs where restored, >0 for every failure
#
# A restauration is considered a failure either if the altered dir cannot be deleted or if the diverted dir cannot be moved back (it does not exist for instance).
#
##
RestoreDirs()
{
    local NB_FAILS=0 # Number of directory delete failures
    local DIRS=("$@")
    for dir in "${DIRS[@]}"; do 
        PrintInfo "Restoring ${dir}"
        rm -rf ${dir}
        if [ $? -gt 0 ]; then # Command is expected to return 0 when not failing
            ((NB_FAILS++))
        else
           mv ${dir}.utmv ${dir} # Move back the directory
           if [ $? -gt 0 ]; then # Command is expected to return 0 when not failing
              ((NB_FAILS++))
           fi
        fi
    done
    return $NB_FAILS
}

##!
# @brief Restore provided files
# @param 1 : List of files to restore
# @return 0 if all files where restored, >0 for every failure
#
# A restauration is considered a failure either if the altered file cannot be deleted or if the diverted file cannot be moved back (it does not exist for instance).
#
##
RestoreFiles()
{
    local NB_FAILS=0 # Number of file delete failures
    local FILES=("$@")
    for file in "${FILES[@]}"; do 
        PrintInfo "Restoring ${file}"
        rm -f ${file}
        if [ $? -gt 0 ]; then # Command is expected to return 0 when not failing
            ((NB_FAILS++))
        else
           mv ${file}.utmv ${file} # Move back the file
           if [ $? -gt 0 ]; then # Command is expected to return 0 when not failing
              ((NB_FAILS++))
           fi
        fi
    done
    return $NB_FAILS
}

##!
# @brief Restore environment variables
# @param 1 : List of variables to restore paired with the associated values
# @return 0 if all variables where restored, >0 for every failure
#
# After assigning value to restore to variable, we check it has been applied effectively. If not, it is a failure. If a value does not exist for the variable, it is a failure as well.
# Management of dynamic variables coming from
# https://stackoverflow.com/questions/16553089/dynamic-variable-names-in-bash
#
##
RestoreEnvVars()
{
    local NB_FAILS=0 # Number of file delete failures
    local ENV_VARS_VALUES=("$@")
    if [ ${#ENV_VARS_VALUES[@]} -ne 0 ]; then # Failure with indexes if empty array
        local ENV_VARS_INDEXES=(${!ENV_VARS_VALUES[@]}) # Get the list of indexes as an array
        local ENV_VARS_MAX_INDEX=${ENV_VARS_INDEXES[-1]} # Last element is the maximum index
        if [ $((ENV_VARS_MAX_INDEX%2)) -eq 0 ]; then # If the last index is even, we miss one value since arrays are 0-indexed
            ((NB_FAILS++)) # last value will not be set so it is an error
            ((ENV_VARS_MAX_INDEX--)) # We decrement the value to get the termination index
        fi

        local index=0
        while [ ${index} -lt ${ENV_VARS_MAX_INDEX} ]; do
            local VARIABLE=${ENV_VARS_VALUES[${index}]}
            local VALUE=${ENV_VARS_VALUES[${index}+1]}
            PrintInfo "Restoring variable ${VARIABLE} with value ${VALUE}"
            read ${VARIABLE} <<< ${VALUE} # https://unix.stackexchange.com/questions/68346/is-it-possible-to-use-indirection-for-setting-variables
            local VAR_NAME=${VARIABLE}
            if [ ! "${!VAR_NAME}" = "${VALUE}" ]; then
                PrintError "Failed to affect ${VARIABLE} with value ${VALUE}. Current value is ${!VAR_NAME}"
                ((NB_FAILS++))
            fi
            ((index+=2))
        done
    fi

    return $NB_FAILS
}

fi # CLEANUTILS_SH

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
