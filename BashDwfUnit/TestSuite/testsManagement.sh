#!/bin/bash

# @file testsManagement.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 08 February 2020
# @brief Definition of the functions used to manage tests (add them to test suite and run them).

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
if [ -z ${TESTSMANAGEMENT_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH}/structure.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH}/../TestCase/testCase.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH}/../../Printing/debug.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH}/../../Testing/function.sh"
. "${SCRIPT_LOCATION_PRINT_TESTSMANAGEMENT_SH}/../../Testing/arrays.sh"

TESTSMANAGEMENT_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using TESTSMANAGEMENT_SH=""


### Functions
##!
# @brief Add a list of tests to test suite
# @param @ : Names of the tests to add
# @return 0 if all tests were added
#         >0 number of tests not added
#
# If list of tests to add is empty, the function will return 0 as well.
# A test can be added if it is identified as a function (It should return 0 if successful and >0 otherwise).
# A test addition is also refused if test is already part of test list.
#
##
AddTests()
{
    local testsToAdd=("$@")
    local additionsFailed=0
    if [ "${#testsToAdd[@]}" -eq "0" ]; then # list 
        PrintWarning "Empty list of tests to add"
        return 0
    fi
    for testToAdd in ${testsToAdd[@]}; do
        FunctionExists "${testToAdd}" # A test is a function
        local isFunction=$?
        if [ "${isFunction}" -eq "0" ]; then
            IsInArray ${testToAdd} _SUITE_TESTS
            local isAlreadyInList=$?
            if [ "${isAlreadyInList}" -ne "0" ]; then
                PrintInfo "Adding test ${testToAdd} to suite ${_SUITE_NAME}"
                _SUITE_TESTS+=("${testToAdd}")
            else
                PrintWarning "Test ${testToAdd} is already included in suite ${_SUITE_NAME}"
                ((additionsFailed++))
            fi
        else
            PrintWarning "Failed to add test ${testToAdd} because it is not a function"
            ((additionsFailed++))
        fi
    done
    return ${additionsFailed}
}

##!
# @brief Run a list of tests
# @param @ : Names of the tests to run
# @return 0 if all tests were run
#         >0 number of tests not run
#
# If list of tests to run is empty, the function will return 0 as well.
# Only tests identified in the suite (i.e. in _SUITE_TESTS) are to be run and tests are run only once.
# Test run and associated results are stored in the variables _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS.
#
##
RunTests()
{
    local testsToRun=("$@")
    local testsNotRun=0
    if [ "${#testsToRun[@]}" -eq "0" ]; then # list 
        PrintWarning "Empty list of tests to run"
        return 0
    fi
    for testToRun in ${testsToRun[@]}; do
        IsInArray ${testToRun} _SUITE_TESTS
        local inInSuite=$?
        if [ "${inInSuite}" -eq "0" ]; then # Test is in suite
            IsInArray ${testToRun} _SUITE_RUN_TESTS
            local hasAlreadyBeenRun=$?
            if [ "${hasAlreadyBeenRun}" -ne "0" ]; then
                runTestCase "${testToRun}" # Run test
                local testResult=$?
                _SUITE_RUN_TESTS+=("${testToRun}")
                if [ "${testResult}" -eq 0 ]; then
                    _SUITE_RUN_RESULTS+=("true")
                else
                    _SUITE_RUN_RESULTS+=("false")
                fi                
            else
                PrintWarning "Test ${testToRun} has already been run"
                ((testsNotRun++))
            fi
        else
            PrintWarning "${testToRun} is not in test suite list"
            ((testsNotRun++))
        fi
    done
    return ${testsNotRun}
}

##!
# @brief Run all tests of test suite
# @return 0 if all tests were run
#         >0 number of tests not run
#
# Run all tests in _SUITE_TESTS. Normally there is no duplicate in _SUITE_TESTS.
# Indeed AddTests protects against duplicatas. Nevertheless, structure is not private in bash so we have no guarantee at all.
# Test run and associated results are stored in the variables _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS.
# Tests are run in the order of addition to suite.
#
##
RunAllTests()
{
    RunTests "${_SUITE_TESTS[@]}"
}


fi # TESTSMANAGEMENT_SH

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
