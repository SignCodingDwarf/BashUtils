#!/bin/bash

# @file assertUtils.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 11 February 2020
# @brief Definition of the utilities used to indicate assertion errors.

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
if [ -z ${ASSERTUTILS_SH} ]; then

### Inclusions
SCRIPT_LOCATION_PRINT_ASSERTUTILS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_ASSERTUTILS_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_ASSERTUTILS_SH}/../../Printing/debug.sh"
. "${SCRIPT_LOCATION_PRINT_ASSERTUTILS_SH}/../../Testing/types.sh"

ASSERTUTILS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using ASSERTUTILS_SH=""

### Formats
errorMessageFormat='\033[1;31m' # Error Messages are printed in light red

### Functions
##!
# @brief Print error message line
# @param 1 : Error message line
# @return 0 if print was successful, >0 otherwise
#
##
PrintErrorLine()
{
    FormattedPrint 1 "${errorMessageFormat}" "${NF}" "[Assertion Failure] : " "" "${1}" 
}

##!
# @brief Print a multiline error message delimited with \n
# @param 1 : Error message
# @return 0 if print was successful, >0 otherwise
#
# A message can be displayed on mutilple lines by separating them using \n delimiter
#
##
PrintErrorMessage()
{
    local delimiter="\n"
    local message="$1"

    if [[ ! "${message}" == *"${delimiter}" ]]; then # If message does not end with delimiter, we add delimiter to the end for parsing
        message="${message}${delimiter}"
    fi

    while [ -n "${message}" ]; do # While we don't have removed all message content
        PrintErrorLine "${message%%"${delimiter}"*}"
        message=${message#*"${delimiter}"}
    done
}

##!
# @brief Display error message and exit test on failure
# @param 1 : Error message
# @param 2 : Error code. Default is 1
# @return Exit on provided error code.
#
# Currently error codes different than ones are not specifically reported or used.
# But who knows ...
#
##
EndTestOnFailure()
{
    local message="${1}"
    local errorCode="${2:-1}" # Default is 1

    # Check our return code is an unsigned integer
    IsUnsignedInteger "${errorCode}"
    local isUInt=$?
    if [ "${isUInt}" -ne "0" ]; then # Otherwise it is set back to 1
        PrintWarning "Invalid error code ${errorCode} set back to 1"
        errorCode=1
    fi

    # Check if error code is in ]0 - 255] range (because 0 indicates success so test should not exit)
    if [ "${errorCode}" -gt "255" -o "${errorCode}" -eq "0" ]; then # Otherwise it is set back to 1
        PrintWarning "Out of ]0 - 255] range error code ${errorCode} set back to 1"
        errorCode=1
    fi 

    # Display message and exit
    PrintErrorMessage "${message}"
    exit ${errorCode}
}

fi # ASSERTUTILS_SH

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
