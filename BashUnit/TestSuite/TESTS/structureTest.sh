#!/bin/bash

# @file structureTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 16 November 2019
# @brief Unit testing of structure.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
# @brief Check the size of an array
# @param 1 : Name of the array to check
# @param 2 : Expected Size
# @return 0 if array has expected size, 1 otherwise
#
## 
CheckArraySize()
{
    local arrayName="$1"
    local expectedSize="$2"
    local arrayContent=()
    eval arrayContent=\( \${${arrayName}[@]} \)
    if [ "${#arrayContent[@]}" -eq "${expectedSize}" ]; then
        return 0
    else
        printf "Array ${arrayName} has expected size ${expectedSize} but has size ${#arrayContent[@]}\n"
        return 1
    fi
}

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
    local arrayContent=()
    local expectedArray=()
    eval arrayContent=\( \${${arrayName}[@]} \)
    eval expectedArray=\( \${${expectedName}[@]} \)

    local differences=(`echo ${expectedArray[@]} ${arrayContent[@]} | tr ' ' '\n' | sort | uniq -u`) # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash

    # Compute result
    if [ ${#differences[@]} -eq 0 ]; then
        return 0
    else
        printf "Expecting to get the content : ${expectedArray[@]}\n"
        printf "\n"
        printf "But array ${arrayName} has content : ${arrayContent[@]}\n"
        printf "\n"
        printf "Difference : ${differences[@]}\n"
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
    if [ ! -z ${STRUCTURE_SH} ]; then 
        echo "STRUCTURE_SH already has value ${STRUCTURE_SH}"
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
    . "${SCRIPT_LOCATION}/../structure.sh"

    if [ ! "${STRUCTURE_SH}" = "1.0" ]; then 
        echo "Loading of structure.sh failed. Content is ${STRUCTURE_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Check if behavior of Test Suite management and of declaration functions
# @return 0 if behavior is as expected, 1 otherwise
#
## 
TestSuiteValueManagement()
{
    # Initial states, arrays are empty, strings empty
    if [ ! -z ${_SUITE_NAME} ]; then
        printf "_SUITE_NAME should be initialized to empty but has content ${_SUITE_NAME}\n"
        return 1
    fi
    CheckArraySize _SUITE_TESTS 0
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArraySize _SUITE_RUN_TESTS 0
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi   
    CheckArraySize _SUITE_RUN_RESULTS 0
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi  

    # Fill arrays with values and set _SUITE_NAME
    _SUITE_NAME="ExampleTestSuite"
    _SUITE_TESTS=("TestA" "TestB" "AnotherTest")
    CheckArraySize _SUITE_TESTS 3
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    _SUITE_RUN_TESTS=("Test1" "Test3" "Test4" "SomeTest" "ATestToTest" "Alpha" "Omega")
    CheckArraySize _SUITE_RUN_TESTS 7
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi  
    _SUITE_RUN_RESULTS=("true" "false" "false" "true")
    CheckArraySize _SUITE_RUN_RESULTS 4
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi  

    # Empty _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS but do not alter _SUITE_TESTS
    ResetSuiteExecutionState
    if [ "${_SUITE_NAME}" != "ExampleTestSuite" ]; then
        printf "_SUITE_NAME should have value ExampleTestSuite but has value ${_SUITE_NAME}\n"
        return 1
    fi
    CheckArraySize _SUITE_TESTS 3
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    local expectedArrayContent=("TestA" "TestB" "AnotherTest")
    CheckArrayContent _SUITE_TESTS expectedArrayContent
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArraySize _SUITE_RUN_TESTS 0
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi   
    CheckArraySize _SUITE_RUN_RESULTS 0
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi  

    # Set values of _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS
    _SUITE_RUN_TESTS=("TheFirstTest" "TheLastTestBeforeTheEndOfTheWorld")
    CheckArraySize _SUITE_RUN_TESTS 2
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi  
    _SUITE_RUN_RESULTS=("false" "1" "false" "0" "true")
    CheckArraySize _SUITE_RUN_RESULTS 5
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi   

    # Call DeclareTestSuite with no arguments => nothing changed
    DeclareTestSuite 2> /tmp/barErrorOutput
    printf "[Error] : Test Suite should have a name provided\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    if [ "${_SUITE_NAME}" != "ExampleTestSuite" ]; then
        printf "_SUITE_NAME should have value ExampleTestSuite but has value ${_SUITE_NAME}\n"
        return 1
    fi
    CheckArraySize _SUITE_TESTS 3
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    expectedArrayContent=("TestA" "TestB" "AnotherTest")
    CheckArrayContent _SUITE_TESTS expectedArrayContent
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArraySize _SUITE_RUN_TESTS 2
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi   
    expectedArrayContent=("TheFirstTest" "TheLastTestBeforeTheEndOfTheWorld")
    CheckArrayContent _SUITE_RUN_TESTS expectedArrayContent
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArraySize _SUITE_RUN_RESULTS 5
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    expectedArrayContent=("false" "1" "false" "0" "true")
    CheckArrayContent _SUITE_RUN_RESULTS expectedArrayContent
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi  

    # Call DeclareTestSuite with name, name is changed and everything else is reset
    DeclareTestSuite "Another Test Suite" 
    if [ "${_SUITE_NAME}" != "Another Test Suite" ]; then
        printf "_SUITE_NAME should have value Another Test Suite but has value ${_SUITE_NAME}\n"
        return 1
    fi
    CheckArraySize _SUITE_TESTS 0
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 
    CheckArraySize _SUITE_RUN_TESTS 0
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi   
    CheckArraySize _SUITE_RUN_RESULTS 0
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi 

    return 0
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary if _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS sizes do not match 
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DisplaySummarySizeNotMatching()
{
    _SUITE_RUN_TESTS=("TestA" "TestB" "TestC")
    _SUITE_RUN_RESULTS=("true")

    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "1" ]; then
        printf "Expected function to fail with code 1 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barRef
    printf "[Error] : _SUITE_RUN_TESTS size 3 does not match size of _SUITE_RUN_RESULTS 1\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary with valid input and no failed tests
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DisplaySummaryNoErrors()
{
    _SUITE_NAME="Guess What ?"
    _SUITE_RUN_TESTS=("Test__T" "Test__E" "Test__S" "Test_-T" "Test__A" "Test__R" "Test__O" "Test_-S" "Test--S" "Test_-A" "ILoveIt")
    _SUITE_RUN_RESULTS=("true" "0" "true" "0" "true" "true" "0" "0" "0" "0" "true")
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected DisplayTestSuiteExeSummary to succeed but exited with code ${result}\n"
        return 1
    fi
    printf "**********************************************************\n" > /tmp/barRef
    printf "*                                                        *\n" >> /tmp/barRef
    printf "*     Execution Summary of Test Suite : Guess What ?     *\n" >> /tmp/barRef
    printf "*                                                        *\n" >> /tmp/barRef
    printf "**********************************************************\n" >> /tmp/barRef
    printf ">   Test__T = OK\n" >> /tmp/barRef
    printf ">   Test__E = OK\n" >> /tmp/barRef
    printf ">   Test__S = OK\n" >> /tmp/barRef
    printf ">   Test_-T = OK\n" >> /tmp/barRef
    printf ">   Test__A = OK\n" >> /tmp/barRef
    printf ">   Test__R = OK\n" >> /tmp/barRef
    printf ">   Test__O = OK\n" >> /tmp/barRef
    printf ">   Test_-S = OK\n" >> /tmp/barRef
    printf ">   Test--S = OK\n" >> /tmp/barRef
    printf ">   Test_-A = OK\n" >> /tmp/barRef
    printf ">   ILoveIt = OK\n" >> /tmp/barRef
    printf "**********************************************************\n" >> /tmp/barRef
    printf "                     Passed 11/11 : OK\n" >> /tmp/barRef
    printf "**********************************************************\n" >> /tmp/barRef
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef  
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary with valid input and some failed tests
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DisplaySummaryWithErrors()
{
    _SUITE_NAME="Some Errors"
    _SUITE_RUN_TESTS=("Test1" "Test2" "Test3" "Test4" "Test5" "Test6" "Test7")
    _SUITE_RUN_RESULTS=("true" "true" "false" "true" "1" "false" "0")
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected DisplayTestSuiteExeSummary to succeed but exited with code ${result}\n"
        return 1
    fi
    printf "*********************************************************\n" > /tmp/barRef
    printf "*                                                       *\n" >> /tmp/barRef
    printf "*     Execution Summary of Test Suite : Some Errors     *\n" >> /tmp/barRef
    printf "*                                                       *\n" >> /tmp/barRef
    printf "*********************************************************\n" >> /tmp/barRef
    printf ">   Test1 = OK\n" >> /tmp/barRef
    printf ">   Test2 = OK\n" >> /tmp/barRef
    printf ">   Test3 = KO\n" >> /tmp/barRef
    printf ">   Test4 = OK\n" >> /tmp/barRef
    printf ">   Test5 = KO\n" >> /tmp/barRef
    printf ">   Test6 = KO\n" >> /tmp/barRef
    printf ">   Test7 = OK\n" >> /tmp/barRef
    printf "*********************************************************\n" >> /tmp/barRef
    printf "                     Passed 4/7 : KO\n" >> /tmp/barRef
    printf "*********************************************************\n" >> /tmp/barRef    
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef 
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary with valid input and only failed tests
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DisplaySummaryAllErrors()
{
    _SUITE_NAME="That is not good"
    _SUITE_RUN_TESTS=("TestA" "TestB" "TestC")
    _SUITE_RUN_RESULTS=("false" "1" "false")
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected DisplayTestSuiteExeSummary to succeed but exited with code ${result}\n"
        return 1
    fi
    printf "**************************************************************\n" > /tmp/barRef
    printf "*                                                            *\n" >> /tmp/barRef
    printf "*     Execution Summary of Test Suite : That is not good     *\n" >> /tmp/barRef
    printf "*                                                            *\n" >> /tmp/barRef
    printf "**************************************************************\n" >> /tmp/barRef
    printf ">   TestA = KO\n" >> /tmp/barRef
    printf ">   TestB = KO\n" >> /tmp/barRef
    printf ">   TestC = KO\n" >> /tmp/barRef
    printf "**************************************************************\n" >> /tmp/barRef
    printf "                       Passed 0/3 : KO\n" >> /tmp/barRef
    printf "**************************************************************\n" >> /tmp/barRef  
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
doTest "structure.sh not included" scriptNotIncluded
doTest "structure.sh included" scriptIncluded

#Value Management
doTest "Management of TestSuite content" TestSuiteValueManagement

#Display Summary
doTest "Display Summary error size matching" DisplaySummarySizeNotMatching
doTest "Display Summary no errors" DisplaySummaryNoErrors
doTest "Display Summary with errors" DisplaySummaryWithErrors
doTest "Display Summary all errors" DisplaySummaryAllErrors

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
