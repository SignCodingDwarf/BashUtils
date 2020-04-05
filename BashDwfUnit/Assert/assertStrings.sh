#!/bin/bash

# @file assertStrings.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 18 March 2020
# @brief Definition of a set of macros used to check strings values.

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
if [ -z ${ASSERTSTRINGS_SH} ]; then

### Inclusions
SCRIPT_LOCATION_PRINT_ASSERTSTRINGS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_ASSERTSTRINGS_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_ASSERTSTRINGS_SH}/assertUtils.sh"

ASSERTSTRINGS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using ASSERTSTRINGS_SH=""

##!
# @brief Checks that a string is equal to an expected value
# @param 1 : Expected string value
# @param 2 : Tested string value
# @param 3 : Error Message Header. Default is "Provided strings are not identical"
# @return 0 if strings are identical, exit 1 otherwise
#
# Compare two strings using = test. Strict equality (i.e. no pattern matching) is checked.
# If tested and/or compared strings are empty, this triggers an error. 
# Returns the following error message :
# @param_3
# Expected : @param_1
# Got : @param_2
#
# Error message header (@param_3) can be multiline provided you insert \n characters in string
#
##
ASSERT_STRING_IS_EQUAL()
{
    local expected="$1"
    local tested="$2"
    local messageHeader="$3"
    local errorMessage=""

    if [ -z "${expected}" -o -z "${tested}" ]; then # If at least a value to compare is empty, error
        errorMessage="Problem on provided arguments. Usage:${lineDelimiter}ASSERT_STRING_IS_EQUAL <expected_string> <tested_string> [Message Header]${lineDelimiter}"
        EndTestOnFailure "${errorMessage}"
    fi

    if [ -z "${messageHeader}" ]; then
        messageHeader="Provided strings are not identical\n"
    fi
    errorMessage=$(AddSuffix "${messageHeader}" "${lineDelimiter}") ## Add delimiter in the end of line

    [ "${expected}" = "${tested}" ] 2> /dev/null # Test condition
    # Check error
    if [ "$?" -ne "0" ]; then
        errorMessage="${errorMessage}Expected : ${expected}${lineDelimiter}Got : ${tested}${lineDelimiter}"
        EndTestOnFailure "${errorMessage}"
    else
        return 0
    fi
}

fi # ASSERTSTRINGS_SH

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
