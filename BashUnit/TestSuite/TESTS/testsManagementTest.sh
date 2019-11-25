#!/bin/bash

# @file testsManagementTests.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 01 December 2019
# @brief Unit testing of testsManagement.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
# @brief Check if an array has expected content
# @param 1 : Name of the array to check
# @param 2 : Name of the expected array
# @return 0 if array has expected content, 1 otherwise
#
## 
CheckArrayContent()
{
    local arrayName="$1"
    local expectedName="$2"
    local -n arrayContent=${arrayName}
    local -n expectedArray=${expectedName}

    local differences=(`echo ${expectedArray[@]} ${arrayContent[@]} | tr ' ' '\n' | sort | uniq -u`) # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash

    # Compute result
    if [ ${#differences[@]} -eq 0 ]; then
        return 0
    else
        printf "Expecting to get the content : "
        printf "%s " "${expectedArray[*]}"
        printf "\n\n"
        printf "But array ${arrayName} has content : "
        printf "%s " "${arrayContent[*]}"
        printf "\n\n"
        printf "Difference : "
        printf "%s " "${differences[*]}"
        printf "\n"
        return 1
    fi
}

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
    if [ ! -z ${TESTSMANAGEMENT_SH} ]; then 
        echo "TESTSMANAGEMENT_SH already has value ${TESTSMANAGEMENT_SH}"
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
    . "${SCRIPT_LOCATION}/../testsManagement.sh"

    if [ ! "${TESTSMANAGEMENT_SH}" = "1.0" ]; then 
        echo "Loading of testsManagement.sh failed. Content is ${TESTSMANAGEMENT_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if script is included, 1 otherwise
#
## 
AddTestsNoParam()
{
    AddTests 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function AddTests to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local emptyArray=()
    CheckArrayContent _SUITE_TESTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Empty list of tests to add\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if script is included, 1 otherwise
#
## 
AddTestsOnlyAddFailures()
{
    _SUITE_TESTS=() # Make sure list of tests is empty
    AddTests "NotATest" "FailingToBeTested" "NoWay" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "3" ]; then
        printf "Expected function AddTests to exit with code 3 but exited with code ${result}\n"
        return 1
    fi
    local emptyArray=()
    CheckArrayContent _SUITE_TESTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Failed to add test NotATest because it is not a function\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to add test FailingToBeTested because it is not a function\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to add test NoWay because it is not a function\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if script is included, 1 otherwise
#
## 
AddTestsAddFailures()
{
    _SUITE_TESTS=() # Make sure list of tests is empty
    AddTests "Aloha" "NeverDeclared" "ATest" "NotATest" "CanItBeATest?" "TerminatorTest" "WillNotBeAdded" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "4" ]; then
        printf "Expected function AddTests to exit with code 4 but exited with code ${result}\n"
        return 1
    fi
    local referenceArray=("Aloha" "ATest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS referenceArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Failed to add test NeverDeclared because it is not a function\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to add test NotATest because it is not a function\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to add test CanItBeATest? because it is not a function\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to add test WillNotBeAdded because it is not a function\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if script is included, 1 otherwise
#
## 
AddTestsOnlyAddSuccess()
{
    _SUITE_TESTS=() # Make sure list of tests is empty
    AddTests "ATest" "TerminatorTest" "AnotherTest" "Aloha"  2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function AddTests to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local referenceArray=("ATest" "TerminatorTest" "AnotherTest" "Aloha")
    CheckArrayContent _SUITE_TESTS referenceArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "" > /tmp/barErrorRef # We ignore the info messages
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if script is included, 1 otherwise
#
## 
AddTestsAddRedundant()
{
    _SUITE_TESTS=("Aloha" "AnotherTest" "ATest") # Initial test list
    AddTests "ATest" "TerminatorTest" "AnotherTest" "Aloha"  2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "3" ]; then
        printf "Expected function AddTests to exit with code 3 but exited with code ${result}\n"
        return 1
    fi
    local referenceArray=("Aloha" "AnotherTest" "ATest" "TerminatorTest" )
    CheckArrayContent _SUITE_TESTS referenceArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Test ATest is already included in suite TestSuite\n" > /tmp/barErrorRef 
    printf "[Warning] : Test AnotherTest is already included in suite TestSuite\n" >> /tmp/barErrorRef 
    printf "[Warning] : Test Aloha is already included in suite TestSuite\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if no arguments are provided
# @return 0 if script is included, 1 otherwise
#
## 
RunTestsNoParam()
{
    RunTests 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RunTests to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local emptyArray=()
    CheckArrayContent _SUITE_RUN_TESTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Empty list of tests to run\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if only tests to run are not in test suite 
# @return 0 if script is included, 1 otherwise
#
## 
RunTestsOnlyRunFailures()
{
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunTests "NotInList" "NeverATest" "Test" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "3" ]; then
        printf "Expected function RunTests to exit with code 3 but exited with code ${result}\n"
        return 1
    fi
    local emptyArray=()
    CheckArrayContent _SUITE_RUN_TESTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : NotInList is not in test suite list\n" > /tmp/barErrorRef
    printf "[Warning] : NeverATest is not in test suite list\n" >> /tmp/barErrorRef
    printf "[Warning] : Test is not in test suite list\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if some tests to run are not in test suite
# @return 0 if script is included, 1 otherwise
#
## 
RunTestsRunFailures()
{
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunTests "Aloha" "SomeTest" "TerminatorTest" "Test" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function RunTests to exit with code 2 but exited with code ${result}\n"
        return 1
    fi
    local expectedRunTests=("Aloha" "TerminatorTest")
    local expectedResults=("true" "false")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS expectedResults
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : SomeTest is not in test suite list\n" > /tmp/barErrorRef
    printf "[Warning] : Test is not in test suite list\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if all tests are run
# @return 0 if script is included, 1 otherwise
#
## 
RunTestsOnlyRunSuccess()
{
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunTests "Aloha" "AnotherTest" "TerminatorTest" "ATest" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RunTests to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local expectedRunTests=("Aloha" "AnotherTest" "TerminatorTest" "ATest")
    local expectedResults=("true" "true" "false" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS expectedResults
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "" > /tmp/barErrorRef # We ignore the info messages
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if some tests are already run
# @return 0 if script is included, 1 otherwise
#
## 
RunTestsRunRedundant()
{
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunTests "TerminatorTest" "Aloha" "AnotherTest" "AnotherTest" "TerminatorTest" "ATest" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function RunTests to exit with code 2 but exited with code ${result}\n"
        return 1
    fi
    local expectedRunTests=("Aloha" "AnotherTest" "TerminatorTest" "ATest")
    local expectedResults=("false" "true" "true" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS expectedResults
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Test AnotherTest has already been run\n" > /tmp/barErrorRef 
    printf "[Warning] : Test TerminatorTest has already been run\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTests behavior if there are no tests in suite
# @return 0 if script is included, 1 otherwise
#
## 
RunAllTestsEmpty()
{
    _SUITE_TESTS=() # Empty tests list
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunAllTests 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RunAllTests to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local emptyArray=()
    CheckArrayContent _SUITE_RUN_TESTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS emptyArray
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Empty list of tests to run\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTests behavior in nominal case
# @return 0 if script is included, 1 otherwise
#
## 
RunAllTestsNominal()
{
    _SUITE_TESTS=("Aloha" "TerminatorTest" "AnotherTest" "ATest") # Empty tests list
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunAllTests 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RunAllTests to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local expectedRunTests=("Aloha" "TerminatorTest" "AnotherTest" "ATest")
    local expectedResults=("true" "false" "true" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS expectedResults
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTests behavior if there are duplicates in it
# @return 0 if script is included, 1 otherwise
#
## 
RunAllTestsDuplicates()
{
    _SUITE_TESTS=("Aloha" "TerminatorTest" "AnotherTest" "TerminatorTest" "ATest" "Aloha") # Empty tests list
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    RunAllTests 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function RunAllTests to exit with code 2 but exited with code ${result}\n"
        return 1
    fi
    local expectedRunTests=("Aloha" "TerminatorTest" "AnotherTest" "ATest")
    local expectedResults=("true" "false" "true" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArrayContent _SUITE_RUN_RESULTS expectedResults
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi     
    printf "[Warning] : Test TerminatorTest has already been run\n" > /tmp/barErrorRef 
    printf "[Warning] : Test Aloha has already been run\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}


################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp
CURRENT_VERBOSE=${VERBOSE}
VERBOSE=false # Disable verbosity because we are not interested by 

# A few functions and variables for array testing
function Aloha()
{
    echo "Hello World"
    return 0 
}

function ATest()
{
    return 0
}

NotATest="I am not a test" # A variable should not be detected as a function

function AnotherTest()
{
    local content=$(ls /tmp)
    return $?
}

function TerminatorTest()
{
    echo "I'll be back"
    return 101
}

### Do Tests
#Inclusion
doTest "testsManagement.sh not included" scriptNotIncluded
doTest "testsManagement.sh included" scriptIncluded
_SUITE_TESTS=() # Make sure list of tests is empty
_SUITE_NAME="TestSuite" # Set up global test suite name

#AddTests
doTest "AddTests with no parameters" AddTestsNoParam
doTest "AddTests with only addition failures" AddTestsOnlyAddFailures
doTest "AddTests with addition failures" AddTestsAddFailures
doTest "AddTests with only successful additions" AddTestsOnlyAddSuccess
doTest "AddTests with redundant additions" AddTestsAddRedundant

#RunTests
_SUITE_TESTS=("Aloha" "ATest" "AnotherTest" "TerminatorTest") # Test list for all tests
doTest "RunTests with no parameters" RunTestsNoParam
doTest "RunTests with only run failures" RunTestsOnlyRunFailures
doTest "RunTests with run failures" RunTestsRunFailures
doTest "RunTests with only successful run" RunTestsOnlyRunSuccess
doTest "RunTests with redundant additions" RunTestsRunRedundant

# RunAllTests
doTest "RunTests with empty test in suite" RunAllTestsEmpty
doTest "RunTests with some tests in it" RunAllTestsNominal
doTest "RunTests with duplicates in it" RunAllTestsDuplicates

### Clean Up
rm /tmp/barErrorOutput
rm /tmp/barErrorRef
VERBOSE=${CURRENT_VERBOSE} # Restaure VERBOSE value
_SUITE_TESTS=()
_SUITE_NAME=""

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
