#!/bin/bash

# @file declareDivertion.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 26 January 2020
# Definition of functions used to divert directories and files and add them to the restauration list

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
if [ -z ${DECLAREDIVERTION_SH} ]; then

SCRIPT_LOCATION_DECLAREDIVERTION_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_DECLAREDIVERTION_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_DECLAREDIVERTION_SH}/../../Printing/debug.sh"

DECLAREDIVERTION_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using DECLAREDIVERTION_SH="""

##!
# @brief Divert elements by copying them
# @param @ : Elements to divert
# @return 0 if all elements were diverted
#         1 if no elements were provided 
#         >0 the number of elements that were not diverted
#
##
DivertCopyElement()
{
    local elements=("$@")
    local failedDivertion=0

    if [ "${#elements[@]}" -eq "0" ]; then 
        PrintError "You should specify elements to divert"
        return 1       
    fi

    for element in ${elements[@]}; do
        # Element path to absolute path without symlink resolution (because we may want to divert a symlink)
        local elementPath=$(cd "$(dirname "${element}")"; pwd)/$(basename "${element}")
        local result="$?"
        if [ "${result}" -ne "0" ]; then # If error in element path (example, element does not exist)
            PrintError "Divertion of element ${element} failed because of error ${result}"
            ((failedDivertion++))
            continue # Go to next element
        fi

        # Check if element is not already diverted
        if [ -e "${elementPath}.utmv" ]; then
            PrintWarning "Divertion of element ${elementPath} failed because it is already diverted."
            ((failedDivertion++))
            continue # Go to next element
        fi    

        # Divertion
        PrintInfo "Diverting folder ${elementPath} to ${elementPath}.utmv"
        cp -r ${elementPath} ${elementPath}.utmv
        result=$?
        if [ "${result}" -eq "0" ]; then
            ELEMENTS_DIVERTED+=("${elementPath}") # Append to the restoration array
        else
            PrintError "Divertion of element ${elementPath} failed because of error ${result}"
            ((failedDivertion++))  
        fi     
    done
    return ${failedDivertion}
}

##!
# @brief Divert elements by moving them
# @param @ : Elements to divert
# @return 0 if all elements were diverted
#         1 if no elements were provided 
#         >0 the number of elements that were not diverted
#
##
DivertMoveElement()
{
    local elements=("$@")
    local failedDivertion=0

    if [ "${#elements[@]}" -eq "0" ]; then 
        PrintError "You should specify elements to divert"
        return 1       
    fi

    for element in ${elements[@]}; do
        # Element path to absolute path without symlink resolution (because we may want to divert a symlink)
        local elementPath=$(cd "$(dirname "${element}")"; pwd)/$(basename "${element}")
        local result="$?"
        if [ "${result}" -ne "0" ]; then # If error in element path (example, element does not exist)
            PrintError "Divertion of element ${element} failed because of error ${result}"
            ((failedDivertion++))
            continue # Go to next element
        fi

        # Check if element is not already diverted
        if [ -e "${elementPath}.utmv" ]; then
            PrintWarning "Divertion of element ${elementPath} failed because it is already diverted."
            ((failedDivertion++))
            continue # Go to next element
        fi    

        # Divertion
        PrintInfo "Diverting folder ${elementPath} to ${elementPath}.utmv"
        mv ${elementPath} ${elementPath}.utmv
        result=$?
        if [ "${result}" -eq "0" ]; then
            ELEMENTS_DIVERTED+=("${elementPath}") # Append to the restoration array
        else
            PrintError "Divertion of element ${elementPath} failed because of error ${result}"
            ((failedDivertion++))  
        fi     
    done
    return ${failedDivertion}
}

##!
# @brief Divert element by replacing it
# @param 1 : Element to divert
# @param 2 : Element replacing it
# @return 0 if divertion succeeded
#         1 if replaced element does is not defined
#         2 if replaced element does not exist
#         3 if replacing element does is not defined
#         4 if replacing element does not exist
#         5 if divertion of replaced failed 
#         6 if replacement of element failed
#
# Note that replacing a folder by a file or a file by a folder is not checked
# Thus it is not forbidden to do so because a test may require that behavior
#
##
DivertReplaceElement()
{
    local replacedElement="$1"
    local replacingElement="$2"

    # Check replaced element
    if [ -z "${replacedElement}" ]; then
        PrintError "No replaced element defined"
        return 1
    fi
    # Element path to absolute path without symlink resolution (because we may want to divert a symlink)
    local replacedElementPath=$(cd "$(dirname "${replacedElement}")"; pwd)/$(basename "${replacedElement}")
    local result="$?"
    if [ "${result}" -ne "0" ]; then # If error in element path (example, element does not exist)
        PrintError "Replaced element ${replacedElement} does not exist. Divertion cancelled"
        return 2
    fi
    
    # Check replacing element
    if [ -z "${replacingElement}" ]; then
        PrintError "No replacing element defined"
        return 3
    fi
    # Element path to absolute path without symlink resolution (because we may want to divert a symlink)
    local replacingElementPath=$(cd "$(dirname "${replacingElement}")"; pwd)/$(basename "${replacingElement}")
    result="$?"
    if [ "${result}" -ne "0" ]; then # If error in element path (example, element does not exist)
        PrintError "Replacing element ${replacingElement} does not exist. Divertion cancelled"
        return 4
    fi

    # Try to divert move element
    DivertMoveElement "${replacedElementPath}"
    result="$?"
    if [ "${result}" -ne "0" ]; then # Element not diverted
        return 5
    fi

    # Copy replacing element
    PrintInfo "Copying ${replacingElementPath} as ${replacedElementPath}"
    cp -r ${replacingElementPath} ${replacedElementPath}
    result="$?"
    if [ "${result}" -ne "0" ]; then
        PrintError "Replacement of ${replacedElementPath} by ${replacingElementPath} failed because of error ${result}"
        return 6   
    fi
    return 0
}

fi # DECLAREDIVERTION_SH

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
