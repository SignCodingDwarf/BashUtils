#!/bin/bash

# @file structure.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# @brief Definition of the variables used to store TestSuite data and functions to reset TestSuite content and display execution results.

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
if [ -z ${TESTSUITE_STRUCTURE_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_PRINT_TESTSUITE_STRUCTURE_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_TESTSUITE_STRUCTURE_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSUITE_STRUCTURE_SH}/../Utils/testStatus.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSUITE_STRUCTURE_SH}/../../Testing/types.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSUITE_STRUCTURE_SH}/../../Printing/debug.sh"

TESTSUITE_STRUCTURE_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using TESTSUITE_STRUCTURE_SH=""

### Test suite control variables
# They are prefixed with "_" because they are "internals" to TestSuite structure and thus should not be used directly
_SUITE_NAME="" # Name of the test suite
_SUITE_TESTS=() # List of tests in test suite
_SUITE_RUN_TESTS=() # List of tests run in current test suite
_SUITE_RUN_RESULTS=() # List of results of last tests execution

### Functions
##!
# @brief Reset test suite execution state
# @return 0
#
##
ResetSuiteExecutionState()
{
    _SUITE_RUN_TESTS=()
    _SUITE_RUN_RESULTS=()   
    return 0
}

##!
# @brief Reset test suite status to initial state
# @param 1 : Name of the test suite
# @return 0 if test suite was correctly declared
#         1 if No test suite name provided
#
##
DeclareTestSuite()
{
    if [ -z "$1" ]; then
        PrintError "Test Suite should have a name provided"
        return 1
    fi
    _SUITE_NAME="$1"
    _SUITE_TESTS=() 
    ResetSuiteExecutionState  
}

##!
# @brief Display Summaery of TestSuite execution
# @output Execution summary of tests
# @return 0 if display was performed well
#         1 if _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS have different sizes
#
##
DisplayTestSuiteExeSummary()
{
    if [ "${#_SUITE_RUN_TESTS[@]}" -ne "${#_SUITE_RUN_RESULTS[@]}" ] ; then
        PrintError "_SUITE_RUN_TESTS size ${#_SUITE_RUN_TESTS[@]} does not match size of _SUITE_RUN_RESULTS ${#_SUITE_RUN_RESULTS[@]}"
        return 1
    fi

    # Headers
    local summaryTitle="*     Execution Summary of Test Suite : ${_SUITE_NAME}     *"
    local summaryWidth=${#summaryTitle}
    local spacesNumber=0
    ((spacesNumber=${summaryWidth}-2))
    printf "%0.s*" $(seq 1 ${summaryWidth})
    printf "\n*"
    printf "%0.s " $(seq 1 ${spacesNumber})
    printf "*\n"
    printf "${summaryTitle}"
    printf "\n*"
    printf "%0.s " $(seq 1 ${spacesNumber})
    printf "*\n"
    printf "%0.s*" $(seq 1 ${summaryWidth})
    printf "\n"

    # Display test Results
    local index=0
    local failedTestNb=0
    local runTestNb=${#_SUITE_RUN_TESTS[@]}
    for (( index = 0; index < ${#_SUITE_RUN_TESTS[@]}; index++ )); do
        printf ">   "
        PrintTestSummary ${_SUITE_RUN_TESTS[${index}]} ${_SUITE_RUN_RESULTS[${index}]}
        if [ "${_SUITE_RUN_RESULTS[${index}]}" = "false" ] || [ "${_SUITE_RUN_RESULTS[${index}]}" = "1" ];  then 
            ((failedTestNb++))
        fi
    done

    # Display Overall Summary
    printf "%0.s*" $(seq 1 ${summaryWidth})
    printf "\n"
    ((spacesNumber=(${summaryWidth}-(7+${#runTestNb}+1+${#failedTestNb}+5))/2)) # Nombre d'espaces avant le texte, (Taille totale - longueur du texte)/2
    printf "%0.s " $(seq 1 ${spacesNumber})
    PrintRunSummary ${runTestNb} ${failedTestNb} 
    printf "%0.s*" $(seq 1 ${summaryWidth})
    printf "\n"
  

    return 0
}

fi # TESTSUITE_STRUCTURE_SH

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
