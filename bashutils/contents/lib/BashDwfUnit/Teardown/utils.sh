#!/bin/bash

# @file utils.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# @brief Definition of functions used to restore environment state after test execution.

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
if [ -z ${TEARDOWN_UTILS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_PRINT_TEARDOWN_UTILS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_TEARDOWN_UTILS_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_TEARDOWN_UTILS_SH}/../../Printing/debug.sh"

TEARDOWN_UTILS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using TEARDOWN_UTILS_SH=""

### Functions
##!
# @brief Delete all the provided elements (directories or files)
# @param @ : List of elements to delete
# @return 0 if all elements where deleted, >0 for every element not deleted
#
# A deletion is considered a failure if and only if the element still exists and deletion failed.
# If the element does not exist for whatever reason, we do not consider deletion a failure
#
##
DeleteElements()
{
    local nbFails=0 # Number of elements delete failures
    local elems=("$@")
    for elem in "${elems[@]}"; do 
        PrintInfo "Deleting ${elem}"
        rm -rf ${elem}
        if [ "$?" -ne "0" ]; then # Command is expected to return 0 when not failing
            PrintError "Failed to delete ${elem}"
            ((nbFails++))
        fi
    done

    return ${nbFails}
}

##!
# @brief Restore provided elements (directories or files)
# @param @ : List of elements to restore
# @return 0 if all elements where restored, >0 for every failure
#
# A restauration is considered a failure either if the altered element cannot be deleted or if the diverted element cannot be moved back (it does not exist for instance).
#
##
RestoreElements()
{
    local nbFails=0 # Number of directory delete failures
    local elems=("$@")
    for elem in "${elems[@]}"; do 
        PrintInfo "Restoring ${elem}"
        rm -rf ${elem}
        if [ "$?" -ne "0" ]; then # Command is expected to return 0 when not failing
            PrintError "Failed to delete ${elem}"
            ((nbFails++))
        else
           mv ${elem}.utmv ${elem} # Move back the element
           if [ "$?" -ne "0" ]; then # Command is expected to return 0 when not failing
                PrintError "Failed to restore ${elem} with ${elem}.utmv"
              ((nbFails++))
           fi
        fi
    done
    return ${nbFails}
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
    local nbFails=0 # Number of file delete failures
    local envVarsValues=("$@")
    if [ ${#envVarsValues[@]} -ne 0 ]; then # Failure with indexes if empty array
        local envVarsIndexes=(${!envVarsValues[@]}) # Get the list of indexes as an array
        local envVarsMaxIndex=${envVarsIndexes[-1]} # Last element is the maximum index
        if [ $((envVarsMaxIndex%2)) -eq 0 ]; then # If the last index is even, we miss one value since arrays are 0-indexed
            PrintError "Value ${envVarsValues[-1]} has no associated value to restore. Ignoring it."
            ((nbFails++)) # last value will not be set so it is an error
            ((envVarsMaxIndex--)) # We decrement the value to get the termination index
        fi

        local index=0
        while [ "${index}" -lt "${envVarsMaxIndex}" ]; do
            local varName=${envVarsValues[${index}]}
            local value=${envVarsValues[${index}+1]}
            PrintInfo "Restoring variable ${varName} with value ${value}"
            read ${varName} <<< ${value} # https://unix.stackexchange.com/questions/68346/is-it-possible-to-use-indirection-for-setting-variables
            local currentValue=${varName}
            if [ ! "${!currentValue}" = "${value}" ]; then
                PrintError "Failed to affect ${varName} with value ${value}. Current value is ${!currentValue}"
                ((nbFails++))
            fi
            ((index+=2))
        done
    fi

    return ${nbFails}
}

fi # TEARDOWN_UTILS_SH

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
