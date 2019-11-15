#!/bin/bash

# @file testStatusTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 16 November 2019
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
### Define a minimal working set allowing to have a readable test while not using BashUnit framework since it tests elements used by BashUtils
### Behavior Variables
FAILED_TEST_NB=0
RUN_TEST_NB=0
TEST_NAME_FORMAT='\033[1;34m' # Test name is printed in light blue
FAILURE_FORMAT='\033[1;31m' # A failure is printed in light red
SUCCESS_FORMAT='\033[1;32m' # A success is printed in light green
NF='\033[0m' # No Format

### Functions
##!
# @brief Do a test
# @param 1 : Test description (in quotes)
# @param 2 : Test to perform
# @return 0 if test is successful, 1 if test failed, 2 if no test has been specified
#
## 
doTest()
{
    local TEST_NAME="$1"
    local TEST_CONTENT="$2"

    if [ -z "${TEST_CONTENT}" ]; then
        printf "${FAILURE_FORMAT}Empty test ${TEST_NAME}${NF}\n"
        return 2
    fi

    printf "${TEST_NAME_FORMAT}***** Running Test : ${TEST_NAME} *****${NF}\n"
    ((RUN_TEST_NB++))
    eval ${TEST_CONTENT}

    local TEST_RESULT=$?
    if [ "${TEST_RESULT}" -ne "0" ]; then
        printf "${FAILURE_FORMAT}Test Failed with error ${TEST_RESULT}${NF}\n"
        ((FAILED_TEST_NB++))
        return 1
    else
        printf "${SUCCESS_FORMAT}Test Successful${NF}\n"
        return 0
    fi 
}

##!
# @brief Display test suite results
# @return 0 
#
## 
displaySuiteResults()
{
    local SUCCESSFUL_TESTS=0
    ((SUCCESSFUL_TESTS=${RUN_TEST_NB}-${FAILED_TEST_NB}))
    if [ ${FAILED_TEST_NB} -eq 0 ]; then
        printf "${SUCCESS_FORMAT}Passed ${SUCCESSFUL_TESTS}/${RUN_TEST_NB} : OK${NF}\n"
    else
        printf "${FAILURE_FORMAT}Passed ${SUCCESSFUL_TESTS}/${RUN_TEST_NB} : KO${NF}\n"
    fi    
}

################################################################################
###                                                                          ###
###                            Helper functions                              ###
###                                                                          ###
################################################################################
##!
# @brief Test that the text written to a file is not the one 
# @param 1 : Result File name
# @param 2 : Expected Result file name
# @return 0 if text has expected value, 1 otherwise
#
##
TestWrittenText()
{
    local resultFileName=$1
    local expectedResultFileName=$2

    local currentValue=$(cat ${resultFileName})
    local expectedValue=$(cat ${expectedResultFileName})

    if [ "${currentValue}" = "${expectedValue}" ]; then
        return 0
    else
        echo "Invalid Text"
        echo "Expected ${expectedValue}"
        echo "Got ${currentValue}"
        return 1    
    fi
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check if script is not included
# @return 0 if script is not included, 1 otherwise
#
## 
scriptNotIncluded()
{
    if [ ! -z ${TESTSTATUS_SH} ]; then 
        echo "TESTSTATUS_SH already has value ${TESTSTATUS_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Check if script is included with correct version
# @return 0 if script is included, 1 otherwise
#
## 
scriptIncluded()
{
    SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    . "${SCRIPT_LOCATION}/../testStatus.sh"

    if [ ! "${TESTSTATUS_SH}" = "1.0" ]; then 
        echo "Loading of testStatus.sh failed. Content is ${TESTSTATUS_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Test that a format is the expected one
# @param 1 : Expected value
# @param 2 : Current value
# @return 0 if format has expected value, 1 otherwise
#
##
testFormat()
{
    local expectedValue="$1"
    local currentValue="$2"

    if [ "${currentValue}" = "${expectedValue}" ]; then
        return 0
    else
        echo "Invalid Format"
        echo "Expected ${expectedValue}"
        echo "Got ${currentValue}"
        return 1    
    fi
}

##!
# @brief Check PrintTestName behavior with arguments
# @return 0 if PrintTestName has expected behavior, 1 otherwise
#
##
TestPrintTestName()
{
    PrintTestName "dummyTest" > /tmp/barOutput
    printf "***** Running Test : dummyTest *****\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintTestName behavior with arguments
# @return 0 if PrintTestName has expected behavior, 1 otherwise
#
##
TestPrintTestName()
{
    PrintTestName "dummyTest" > /tmp/barOutput
    printf "***** Running Test : dummyTest *****\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintSuccess behavior with arguments
# @return 0 if PrintSuccess has expected behavior, 1 otherwise
#
##
TestPrintSuccess()
{
    PrintSuccess > /tmp/barOutput
    printf "[Result] : Test Successful\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintFailure behavior with arguments
# @return 0 if PrintFailure has expected behavior, 1 otherwise
#
##
TestPrintFailure()
{
    PrintFailure 42 > /tmp/barOutput
    printf "[Result] : Test Failed with error 42\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintTestSummary behavior with no arguments
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummaryNoArgs()
{
    PrintTestSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "1" ]; then
        printf "Expected function to fail with code 1 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : No test name provided\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with no status provided
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummaryNoStatus()
{
    PrintTestSummary "a dummy test" > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function to fail with code 2 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : Status  is not a valid test status\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with invalid status provided
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummaryInvalidStatus()
{
    PrintTestSummary "a dummy test" notAStatus > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function to fail with code 2 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : Status notAStatus is not a valid test status\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to true
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummarySuccessTrue()
{
    PrintTestSummary "some successful test" true > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function to succeed with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "some successful test = OK" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to 0
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummarySuccessZero()
{
    PrintTestSummary "anotherSuccessfulTest" 0 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function to succeed with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "anotherSuccessfulTest = OK" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to false
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummaryFailedFalse()
{
    PrintTestSummary "aFailedTest" false > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function to succeed with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "aFailedTest = KO" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintTestSummary behavior with success status to 1
# @return 0 if PrintTestSummary has expected behavior, 1 otherwise
#
##
TestPrintTestSummaryFailedOne()
{
    PrintTestSummary "theLastTest" 1 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function to succeed with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "theLastTest = KO" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with no arguments
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummaryNoArgs()
{
    PrintRunSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "1" ]; then
        printf "Expected function to fail with code 1 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : Tests Run Number  is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with invalid test run number
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummaryInvalidTestRunNb()
{
    PrintRunSummary notANumber 12 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "1" ]; then
        printf "Expected function to fail with code 1 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : Tests Run Number notANumber is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with missing test failed number argument
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummaryMissingTestFailedNb()
{
    PrintRunSummary 7 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function to fail with code 2 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : Tests Failed Number  is not an unsigned integer\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with invalid test failed number
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummaryInvalidTestFailedNb()
{
    PrintRunSummary 7 -3 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function to fail with code 2 but exited with code ${result}\n"
        return 1
    fi
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
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummarySupTestFailedNb()
{
    PrintRunSummary 7 12 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "3" ]; then
        printf "Expected function to fail with code 3 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : Tests Failed Number 12 is superior to Tests Run Number 7\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with some tests failed
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummaryFailedTests()
{
    PrintRunSummary 7 3 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function to succeed with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "Passed 4/7 : KO" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check PrintRunSummary behavior with all tests successful
# @return 0 if PrintRunSummary has expected behavior, 1 otherwise
#
##
TestPrintRunSummarySuccessfulTests()
{
    PrintRunSummary 21 0 > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function to succeed with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "Passed 21/21 : OK" > /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp

### Do Tests
#Inclusion
doTest "testStatus.sh not included" scriptNotIncluded
doTest "testStatus.sh included" scriptIncluded

#Format
doTest "Test Name Format definition" "testFormat \"\033[1;34m\" \"${testNameFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Success Format definition" "testFormat \"\033[1;32m\" \"${successFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Failure Format definition" "testFormat \"\033[1;31m\" \"${failureFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions

#Print Functions
doTest "PrintTestName" TestPrintTestName
doTest "PrintSuccess" TestPrintSuccess
doTest "PrintFailure" TestPrintFailure

#PrintTestSummary
doTest "PrintTestSummary no arguments" TestPrintTestSummaryNoArgs
doTest "PrintTestSummary no test status" TestPrintTestSummaryNoStatus
doTest "PrintTestSummary invalid test status" TestPrintTestSummaryInvalidStatus
doTest "PrintTestSummary success true" TestPrintTestSummarySuccessTrue
doTest "PrintTestSummary success 0" TestPrintTestSummarySuccessZero
doTest "PrintTestSummary failed false" TestPrintTestSummaryFailedFalse
doTest "PrintTestSummary failed 1" TestPrintTestSummaryFailedOne

#PrintRunSummary
doTest "PrintRunSummary invalid no arguments" TestPrintRunSummaryNoArgs
doTest "PrintRunSummary invalid test run number" TestPrintRunSummaryInvalidTestRunNb
doTest "PrintRunSummary missing test failed number" TestPrintRunSummaryMissingTestFailedNb
doTest "PrintRunSummary invalid test failed number" TestPrintRunSummaryInvalidTestFailedNb
doTest "PrintRunSummary test failed number superior to test run number" TestPrintRunSummarySupTestFailedNb
doTest "PrintRunSummary with failed tests" TestPrintRunSummaryFailedTests
doTest "PrintRunSummary with successful tests" TestPrintRunSummarySuccessfulTests

### Clean Up
rm /tmp/barOutput
rm /tmp/barRef
rm /tmp/barErrorOutput
rm /tmp/barErrorRef

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
