#!/bin/bash

# @file testStatusTest.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 28 December 2019
# @brief Unit testing of testStatus.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

### Exit Code
#
# 0 : Execution succeeded
# Number of failed tests otherwise
#

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

################################################################################
###                                                                          ###
###                  Redefinition of BashUnit basic functions                ###
###                                                                          ###
################################################################################
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../../Tools/TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -f /tmp/bar*
    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check nameFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testNameFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    testFormat "\033[1;34m" "${testNameFormat}"
    return 0    
}

##!
# @brief Check successFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testSuccessFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    testFormat "\033[1;32m" "${successFormat}"
    return 0    
}

##!
# @brief Check failureFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testFailureFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    testFormat "\033[1;31m" "${failureFormat}"
    return 0    
}

##!
# @brief Check PrintTestName behavior with arguments
# @return 0 if PrintTestName has expected behavior, exit 1 otherwise
#
##
TestPrintTestName()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    PrintTestName "dummyTest" > /tmp/barOutput
    printf "***** Running Test : dummyTest *****\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintSuccess behavior with arguments
# @return 0 if PrintSuccess has expected behavior, exit 1 otherwise
#
##
TestPrintSuccess()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    PrintSuccess > /tmp/barOutput
    printf "[Result] : Test Successful\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintFailure behavior with arguments
# @return 0 if PrintFailure has expected behavior, exit 1 otherwise
#
##
TestPrintFailure()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    PrintFailure 42 > /tmp/barOutput
    printf "[Result] : Test Failed with error 42\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintTestSummary behavior with no arguments
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummaryNoArgs()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to fail with code 1 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : No test name provided\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with no status provided
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummaryNoStatus()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary "a dummy test" > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to fail with code 2 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Status  is not a valid test status\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with invalid status provided
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummaryInvalidStatus()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary "a dummy test" notAStatus > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to fail with code 2 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Status notAStatus is not a valid test status\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to true
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummarySuccessTrue()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary "some successful test" true > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to succeed with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "some successful test = OK\n" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to 0
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummarySuccessZero()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary "anotherSuccessfulTest" 0 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to succeed with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "anotherSuccessfulTest = OK\n" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to false
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummaryFailedFalse()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary "aFailedTest" false > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to succeed with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "aFailedTest = KO\n" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to 1
# @return 0 if PrintTestSummary has expected behavior, exit 1 otherwise
#
##
TestPrintTestSummaryFailedOne()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintTestSummary "theLastTest" 1 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to succeed with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "theLastTest = KO\n" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with no arguments
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummaryNoArgs()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to fail with code 1 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Tests Run Number  is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with invalid test run number
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummaryInvalidTestRunNb()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary notANumber 12 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to fail with code 1 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Tests Run Number notANumber is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with missing test failed number argument
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummaryMissingTestFailedNb()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary 7 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to fail with code 2 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Tests Failed Number  is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with invalid test failed number
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummaryInvalidTestFailedNb()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary 7 -3 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to fail with code 2 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Tests Failed Number -3 is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with test failed number superior to test run number
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummarySupTestFailedNb()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary 7 12 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"3\" " "Expected function to fail with code 3 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barRef
    printf "[Error] : Tests Failed Number 12 is superior to Tests Run Number 7\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with some tests failed
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummaryFailedTests()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary 7 3 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to succeed with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "Passed 4/7 : KO\n" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with all tests successful
# @return 0 if PrintRunSummary has expected behavior, exit 1 otherwise
#
##
TestPrintRunSummarySuccessfulTests()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testStatus.sh" "1.0"

    ### Execute Command
    PrintRunSummary 21 0 > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to succeed with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "Passed 21/21 : OK\n" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#Format
doTest testNameFormat
doTest testSuccessFormat
doTest testFailureFormat

#Print Functions
doTest TestPrintTestName
doTest TestPrintSuccess
doTest TestPrintFailure

#PrintTestSummary
doTest TestPrintTestSummaryNoArgs
doTest TestPrintTestSummaryNoStatus
doTest TestPrintTestSummaryInvalidStatus
doTest TestPrintTestSummarySuccessTrue
doTest TestPrintTestSummarySuccessZero
doTest TestPrintTestSummaryFailedFalse
doTest TestPrintTestSummaryFailedOne

#PrintRunSummary
doTest TestPrintRunSummaryNoArgs
doTest TestPrintRunSummaryInvalidTestRunNb
doTest TestPrintRunSummaryMissingTestFailedNb
doTest TestPrintRunSummaryInvalidTestFailedNb
doTest TestPrintRunSummarySupTestFailedNb
doTest TestPrintRunSummaryFailedTests
doTest TestPrintRunSummarySuccessfulTests

### Tests result
displaySuiteResults

exit ${FAILED_TEST_NB}


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
