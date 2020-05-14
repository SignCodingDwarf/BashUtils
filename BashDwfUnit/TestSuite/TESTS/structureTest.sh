#!/bin/bash

# @file structureTest.sh
# @author SignC0dingDw@rf
# @version 2.1
# @date 14 May 2020
# @brief Unit testing of structure.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

### Exit Code
#
# 0 : Execution succeeded
# Number of failed tests otherwise
#

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

################################################################################
###                                                                          ###
###                  Redefinition of BashUnit basic functions                ###
###                                                                          ###
################################################################################
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../../Tools/TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -rf /tmp/bar*
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check if behavior of Test Suite management and of declaration functions
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestSuiteValueManagement()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../structure.sh" "1.1"

    # Initial states, arrays are empty, strings empty
    endTestIfAssertFails " -z  \"${_SUITE_NAME}\" " "_SUITE_NAME should be initialized to empty but has content ${_SUITE_NAME}\n"

    CheckArraySize _SUITE_TESTS 0
 
    CheckArraySize _SUITE_RUN_TESTS 0

    CheckArraySize _SUITE_RUN_RESULTS 0

    # Fill arrays with values and set _SUITE_NAME
    _SUITE_NAME="ExampleTestSuite"
    _SUITE_TESTS=("TestA" "TestB" "AnotherTest")
    CheckArraySize _SUITE_TESTS 3

    _SUITE_RUN_TESTS=("Test1" "Test3" "Test4" "SomeTest" "ATestToTest" "Alpha" "Omega")
    CheckArraySize _SUITE_RUN_TESTS 7

    _SUITE_RUN_RESULTS=("true" "false" "false" "true")
    CheckArraySize _SUITE_RUN_RESULTS 4

    # Empty _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS but do not alter _SUITE_TESTS
    ResetSuiteExecutionState
    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"ExampleTestSuite\" " "_SUITE_NAME should have value ExampleTestSuite but has value ${_SUITE_NAME}"

    local expectedArrayContent=("TestA" "TestB" "AnotherTest")
    CheckArrayContent _SUITE_TESTS expectedArrayContent

    CheckArraySize _SUITE_RUN_TESTS 0

    CheckArraySize _SUITE_RUN_RESULTS 0

    # Set values of _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS
    _SUITE_RUN_TESTS=("TheFirstTest" "TheLastTestBeforeTheEndOfTheWorld")
    CheckArraySize _SUITE_RUN_TESTS 2

    _SUITE_RUN_RESULTS=("false" "1" "false" "0" "true")
    CheckArraySize _SUITE_RUN_RESULTS 5 

    # Call DeclareTestSuite with no arguments => nothing changed
    DeclareTestSuite 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Error] : Test Suite should have a name provided\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef 

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"ExampleTestSuite\" " "_SUITE_NAME should have value ExampleTestSuite but has value ${_SUITE_NAME}"

    expectedArrayContent=("TestA" "TestB" "AnotherTest")
    CheckArrayContent _SUITE_TESTS expectedArrayContent

    expectedArrayContent=("TheFirstTest" "TheLastTestBeforeTheEndOfTheWorld")
    CheckArrayContent _SUITE_RUN_TESTS expectedArrayContent

    expectedArrayContent=("false" "1" "false" "0" "true")
    CheckArrayContent _SUITE_RUN_RESULTS expectedArrayContent

    # Call DeclareTestSuite with name, name is changed and everything else is reset
    DeclareTestSuite "Another Test Suite" 2> /tmp/barErrorOutput
    test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef 

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"Another Test Suite\" " "_SUITE_NAME should have value Another Test Suite but has value ${_SUITE_NAME}"

    CheckArraySize _SUITE_TESTS 0

    CheckArraySize _SUITE_RUN_TESTS 0

    CheckArraySize _SUITE_RUN_RESULTS 0

    return 0
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary if _SUITE_RUN_TESTS and _SUITE_RUN_RESULTS sizes do not match 
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DisplaySummarySizeNotMatching()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../structure.sh" "1.1"

    ### Set values
    _SUITE_RUN_TESTS=("TestA" "TestB" "TestC")
    _SUITE_RUN_RESULTS=("true")

    ### Execute command
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    ### Check output
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "[Error] : _SUITE_RUN_TESTS size 3 does not match size of _SUITE_RUN_RESULTS 1\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary with valid input and no failed tests
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DisplaySummaryNoErrors()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../structure.sh" "1.1"

    ### Set values
    _SUITE_NAME="Guess What ?"
    _SUITE_RUN_TESTS=("Test__T" "Test__E" "Test__S" "Test_-T" "Test__A" "Test__R" "Test__O" "Test_-S" "Test--S" "Test_-A" "ILoveIt")
    _SUITE_RUN_RESULTS=("true" "0" "true" "0" "true" "true" "0" "0" "0" "0" "true")

    ### Execute command
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    ### Check output
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
    TestWrittenText /tmp/barOutput /tmp/barRef  

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary with valid input and some failed tests
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DisplaySummaryWithErrors()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../structure.sh" "1.1"

    ### Set values
    _SUITE_NAME="Some Errors"
    _SUITE_RUN_TESTS=("Test1" "Test2" "Test3" "Test4" "Test5" "Test6" "Test7")
    _SUITE_RUN_RESULTS=("true" "true" "false" "true" "1" "false" "0")
   
    ### Execute command
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    ### Check output
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
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef 
}

##!
# @brief Check behavior of DisplayTestSuiteExeSummary with valid input and only failed tests
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DisplaySummaryAllErrors()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../structure.sh" "1.1"

    ### Set values
    _SUITE_NAME="That is not good"
    _SUITE_RUN_TESTS=("TestA" "TestB" "TestC")
    _SUITE_RUN_RESULTS=("false" "1" "false")

    ### Execute command
    DisplayTestSuiteExeSummary > /tmp/barOutput 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    ### Check output
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
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}


################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#Value Management
doTest TestSuiteValueManagement

#Display Summary
doTest DisplaySummarySizeNotMatching
doTest DisplaySummaryNoErrors
doTest DisplaySummaryWithErrors
doTest DisplaySummaryAllErrors

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
