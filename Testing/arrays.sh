#!/bin/bash

# @file arrays.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 25 November 2019
# @brief Definition of utilitaries to query information on arrays and their content

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
if [ -z ${ARRAYS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_ARRAYS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_ARRAYS_SH}/../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_ARRAYS_SH}/../Printing/debug.sh"

ARRAYS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using ARRAYS_SH=""

##!
# @brief Check if an variable is an array
# @param 1 : Variable name
# @return 0 if variable is array, >0 otherwise
#
# From https://fvue.nl/wiki/Bash:_Detect_if_variable_is_an_array
#
##
IsArray()
{
    declare -p "$1" 2> /dev/null | grep -q 'declare \-a'  
}

##!
# @brief Check if an array contains a given element
# @param 1 : Element to check
# @param 2 : Array name
# @return 0 if element is in array
#         1 if element is not in array
#         2 if element is an empty string
#         3 if argument two is not an array name
#
# From https://stackoverflow.com/questions/8063228/how-do-i-check-if-a-variable-exists-in-a-list-in-bash
#
##
IsInArray()
{
    local element="$1"
    local arrayName="$2"

    if [ -z "${element}" ]; then
        PrintError "You should indicate a non empty element name"
        return 2
    fi
    IsArray ${arrayName}
    local result=$?
    if [ "${result}" -ne "0" ]; then
        PrintError "${arrayName} is not the name of an array"
        return 3
    fi
    local arrayContent=()
    eval arrayContent=\( \${${arrayName}[@]} \)
    if [[ ${arrayContent[@]} =~ (^|[[:space:]])"${element}"($|[[:space:]]) ]]; then
        return 0
    else
        return 1
    fi
}

fi # ARRAYS_SH

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
