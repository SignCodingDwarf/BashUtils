#!/bin/bash

# @file testStatus.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2019
# @brief Definition of test state and results formats and function used for printing

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
if [ -z ${UTILS_TESTSTATUS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_PRINT_UTILS_TESTSTATUS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_UTILS_TESTSTATUS_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_UTILS_TESTSTATUS_SH}/../../Printing/debug.sh"
. "${SCRIPT_LOCATION_PRINT_UTILS_TESTSTATUS_SH}/../../Testing/types.sh"

UTILS_TESTSTATUS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using UTILS_TESTSTATUS_SH=""

### Formats
testNameFormat='\033[1;34m' # Test name is printed in light blue
successFormat='\033[1;32m' # Successes are printed in light green
failureFormat='\033[1;31m' # Failures are printed in light red

### Functions
##!
# @brief Print test name
# @param 1  : Test Name
# @return 0 if print was successful, >0 otherwise
#
##
PrintTestName()
{
    FormattedPrint 1 "${testNameFormat}***** " " *****${NF}" "***** " " *****" "Running Test : ${1}" 
}

##!
# @brief Print that a test was successful
# @return 0 if print was successful, >0 otherwise
#
##
PrintSuccess()
{
    FormattedPrint 1 "${successFormat}" "${NF}" "" "" "[Result] : Test Successful" 
}

##!
# @brief Print that a test was failed
# @param 1 : Error description or command return code
# @return 0 if print was successful, >0 otherwise
#
##
PrintFailure()
{
    FormattedPrint 1 "${failureFormat}" "${NF}" "" "" "[Result] : Test Failed with error $1" 
}

##!
# @brief Print result of test in summary
# @param 1 : Test name
# @param 2 : Test status (true/0 if test is successful, false/1 if test failed)
# @return 0 if print was successful
#         1 if test name is missing
#         2 if test status is missing
#
##
PrintTestSummary()
{
    local testName="$1"
    local testStatus="$2"  

    if [ -z "${testName}" ];  then 
        PrintError "No test name provided"
        return 1
    fi 

    if [ "${testStatus}" = "true" ] || [ "${testStatus}" = "0" ];  then 
        resultFormat="${successFormat}"
        resultStatus="OK"
    elif [ "${testStatus}" = "false" ] || [ "${testStatus}" = "1" ];  then 
        resultFormat="${failureFormat}"
        resultStatus="KO"
    else
        PrintError "Status ${testStatus} is not a valid test status"
        return 2
    fi 

    FormattedPrint 1 "${resultFormat}" "${NF}" "" "" "${testName} = ${resultStatus}"
    return 0  
}

##!
# @brief Print summary of test running
# @param 1 : Number of tests run
# @param 2 : Number of tests failed
# @return 0 if print was successful
#         1 if number of tests run is missing or wrong
#         2 if number of tests failed is missing or wrong
#         3 if number of tests failed > number of tests run
#
##
PrintRunSummary()
{
    local testsRunNb=$1
    local testsFailedNb=$2

    IsUnsignedInteger ${testsRunNb}
    local return=$?
    if [ "${return}" -ne "0" ];  then # test if it is an unsigned integer
        PrintError "Tests Run Number ${testsRunNb} is not an unsigned integer"
        return 1
    fi

    IsUnsignedInteger ${testsFailedNb}
    local return=$?
    if [ "${return}" -ne "0" ];  then # test if it is an unsigned integer
        PrintError "Tests Failed Number ${testsFailedNb} is not an unsigned integer"
        return 2
    fi

    if [ "${testsFailedNb}" -gt "${testsRunNb}" ]; then
        PrintError "Tests Failed Number ${testsFailedNb} is superior to Tests Run Number ${testsRunNb}"
        return 3
    fi

    local successfulTests=0
    local resultFormat=""
    local resultStatus=""
    ((successfulTests=${testsRunNb}-${testsFailedNb}))
    if [ ${testsFailedNb} -eq 0 ]; then
        resultFormat="${successFormat}"
        resultStatus="OK"
    else
        resultFormat="${failureFormat}"
        resultStatus="KO"
    fi   
    FormattedPrint 1 "${resultFormat}" "${NF}" "" "" "Passed ${successfulTests}/${testsRunNb} : ${resultStatus}" 
}

fi # UTILS_TESTSTATUS_SH

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
