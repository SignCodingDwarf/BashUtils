#!/bin/bash

# @file testsManagementTests.sh
# @author SignC0dingDw@rf
# @version 2.0
# @date 08 February 2020
# @brief Unit testing of testsManagement.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
. "${SCRIPT_LOCATION}/../../../TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
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

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -f /tmp/barError*
    VERBOSE=${CURRENT_VERBOSE} # Restaure VERBOSE value
    _SUITE_TESTS=()
    _SUITE_NAME=""
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
AddTestsNoParam()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=() # Make sure list of tests is empty
    _SUITE_NAME="TestSuite" # Set up global test suite name

    ### Execute Command
    AddTests 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent _SUITE_TESTS emptyArray

    printf "[Warning] : Empty list of tests to add\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
AddTestsOnlyAddFailures()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=() # Make sure list of tests is empty
    _SUITE_NAME="TestSuite" # Set up global test suite name
    
    ### A variable
    local NotATest="IamDefinitelyNotATest"    

    ### Execute Command
    AddTests "NotATest" "FailingToBeTested" "NoWay" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"3\" " "Expected function to exit with code 3 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent _SUITE_TESTS emptyArray

    printf "[Warning] : Failed to add test NotATest because it is not a function\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to add test FailingToBeTested because it is not a function\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to add test NoWay because it is not a function\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if no arguments are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
AddTestsAddFailures()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=() # Make sure list of tests is empty
    _SUITE_NAME="TestSuite" # Set up global test suite name
    
    ### A variable
    local NotATest="IamDefinitelyNotATest"    

    ### Execute Command
    AddTests "Aloha" "NeverDeclared" "ATest" "NotATest" "CanItBeATest?" "TerminatorTest" "WillNotBeAdded" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"4\" " "Expected function to exit with code 4 but exited with code ${test_result}"

    local referenceArray=("Aloha" "ATest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS referenceArray

    printf "[Warning] : Failed to add test NeverDeclared because it is not a function\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to add test NotATest because it is not a function\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to add test CanItBeATest? because it is not a function\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to add test WillNotBeAdded because it is not a function\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if all tests addition is successful
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
AddTestsOnlyAddSuccess()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=() # Make sure list of tests is empty
    _SUITE_NAME="TestSuite" # Set up global test suite name 

    ### Execute Command
    AddTests "ATest" "TerminatorTest" "AnotherTest" "Aloha"  2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("ATest" "TerminatorTest" "AnotherTest" "Aloha")
    CheckArrayContent _SUITE_TESTS referenceArray

    printf "" > /tmp/barErrorRef # We ignore the info messages
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check AddTests behavior if redundant tests are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
AddTestsAddRedundant()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "AnotherTest" "ATest") # Initial test list
    _SUITE_NAME="TestSuite" # Set up global test suite name 

    ### Execute Command
    AddTests "ATest" "TerminatorTest" "AnotherTest" "TerminatorTest" "Aloha"  2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"4\" " "Expected function to exit with code 4 but exited with code ${test_result}"

    local referenceArray=("Aloha" "AnotherTest" "ATest" "TerminatorTest" )
    CheckArrayContent _SUITE_TESTS referenceArray

    printf "[Warning] : Test ATest is already included in suite TestSuite\n" > /tmp/barErrorRef 
    printf "[Warning] : Test AnotherTest is already included in suite TestSuite\n" >> /tmp/barErrorRef 
    printf "[Warning] : Test TerminatorTest is already included in suite TestSuite\n" >> /tmp/barErrorRef 
    printf "[Warning] : Test Aloha is already included in suite TestSuite\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if no arguments are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunTestsNoParam()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "ATest" "AnotherTest" "TerminatorTest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 

    ### Execute Command
    RunTests 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent _SUITE_RUN_TESTS emptyArray

    CheckArrayContent _SUITE_RUN_RESULTS emptyArray
    
    local testListRef=("Aloha" "ATest" "AnotherTest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"

    printf "[Warning] : Empty list of tests to run\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if only tests to run are not in test suite 
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunTestsOnlyRunFailures()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "ATest" "AnotherTest" "TerminatorTest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunTests "NotInList" "NeverATest" "Test" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"3\" " "Expected function to exit with code 3 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent _SUITE_RUN_TESTS emptyArray

    CheckArrayContent _SUITE_RUN_RESULTS emptyArray
    
    local testListRef=("Aloha" "ATest" "AnotherTest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"

    printf "[Warning] : NotInList is not in test suite list\n" > /tmp/barErrorRef
    printf "[Warning] : NeverATest is not in test suite list\n" >> /tmp/barErrorRef
    printf "[Warning] : Test is not in test suite list\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if some tests to run are not in test suite
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunTestsRunFailures()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "ATest" "AnotherTest" "TerminatorTest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunTests "Aloha" "SomeTest" "TerminatorTest" "Test" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local expectedRunTests=("Aloha" "TerminatorTest")
    local expectedResults=("true" "false")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests

    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "ATest" "AnotherTest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"
    
    printf "[Warning] : SomeTest is not in test suite list\n" > /tmp/barErrorRef
    printf "[Warning] : Test is not in test suite list\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if all tests are run
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunTestsOnlyRunSuccess()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "ATest" "AnotherTest" "TerminatorTest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunTests "Aloha" "AnotherTest" "TerminatorTest" "ATest" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedRunTests=("Aloha" "AnotherTest" "TerminatorTest" "ATest")
    local expectedResults=("true" "true" "false" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests
 
    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "ATest" "AnotherTest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"
   
    printf "" > /tmp/barErrorRef # We ignore the info messages
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if some tests are already run
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunTestsRunDuplicates()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "ATest" "AnotherTest" "TerminatorTest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunTests "TerminatorTest" "Aloha" "AnotherTest" "AnotherTest" "TerminatorTest" "ATest" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local expectedRunTests=("TerminatorTest" "Aloha" "AnotherTest" "ATest")
    local expectedResults=("false" "true" "true" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests

    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "ATest" "AnotherTest" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"
  
    printf "[Warning] : Test AnotherTest has already been run\n" > /tmp/barErrorRef 
    printf "[Warning] : Test TerminatorTest has already been run\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunTests behavior if some elements of suite are not tests
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunTestsRunNotTests()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Variables
    local someVariable="tutu"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "NotATest" "someVariable" "TerminatorTest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunTests "TerminatorTest" "Aloha" "NotATest" "someVariable" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedRunTests=("TerminatorTest" "Aloha" "NotATest" "someVariable")
    local expectedResults=("false" "true" "false" "false")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests

    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "NotATest" "someVariable" "TerminatorTest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"
  
    printf "[Error] : NotATest is not a test (i.e. function) name\n" > /tmp/barErrorRef
    printf "[Error] : someVariable is not a test (i.e. function) name\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTests behavior if there are no tests in suite
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunAllTestsEmpty()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=() # Empty Test List
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunAllTests 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent _SUITE_RUN_TESTS emptyArray

    CheckArrayContent _SUITE_RUN_RESULTS emptyArray

    CheckArrayContent _SUITE_TESTS emptyArray

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"

    printf "[Warning] : Empty list of tests to run\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTests behavior in nominal case
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunAllTestsNominal()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "TerminatorTest" "AnotherTest" "ATest") # Test list for all tests
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunAllTests 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedRunTests=("Aloha" "TerminatorTest" "AnotherTest" "ATest")
    local expectedResults=("true" "false" "true" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests

    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "TerminatorTest" "AnotherTest" "ATest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTests behavior if there are duplicates in it
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunAllTestsDuplicates()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "TerminatorTest" "AnotherTest" "TerminatorTest" "ATest" "Aloha")
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunAllTests 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local expectedRunTests=("Aloha" "TerminatorTest" "AnotherTest" "ATest")
    local expectedResults=("true" "false" "true" "true")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests

    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "TerminatorTest" "AnotherTest" "ATest")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"

    printf "[Warning] : Test TerminatorTest has already been run\n" > /tmp/barErrorRef 
    printf "[Warning] : Test Aloha has already been run\n" >> /tmp/barErrorRef 
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RunAllTestsNotTests behavior if there are some elements that are not tests in suite
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RunAllTestsNotTests()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testsManagement.sh" "1.1"

    ### Variables
    local someVariable="tutu"

    ### Declare Test suite
    _SUITE_TESTS=("Aloha" "TerminatorTest" "AnotherTest" "NotATest" "ATest" "someVariable")
    _SUITE_NAME="TestSuite" # Set up global test suite name 
    _SUITE_RUN_TESTS=() # Make sure list of run tests is empty
    _SUITE_RUN_RESULTS=() # Make sure list of run results is empty
    TestSetup() # Declare user Setup to remove warnings
    {
        return 0
    }
    TestTeardown() # Declare user Teardown to remove warnings
    {
        return 0
    }

    ### Execute Command
    RunAllTests 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedRunTests=("Aloha" "TerminatorTest" "AnotherTest" "NotATest" "ATest" "someVariable")
    local expectedResults=("true" "false" "true" "false" "true" "false")
    CheckArrayContent _SUITE_RUN_TESTS expectedRunTests

    CheckArrayContent _SUITE_RUN_RESULTS expectedResults

    local testListRef=("Aloha" "TerminatorTest" "AnotherTest" "NotATest" "ATest" "someVariable")
    CheckArrayContent _SUITE_TESTS testListRef

    endTestIfAssertFails "\"${_SUITE_NAME}\" = \"TestSuite\" " "_SUITE_NAME value should not have been altered by RunTest. But now is ${_SUITE_NAME}"

    printf "[Error] : NotATest is not a test (i.e. function) name\n" > /tmp/barErrorRef
    printf "[Error] : someVariable is not a test (i.e. function) name\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#AddTests
doTest AddTestsNoParam
doTest AddTestsOnlyAddFailures
doTest AddTestsAddFailures
doTest AddTestsOnlyAddSuccess
doTest AddTestsAddRedundant

#RunTests
doTest RunTestsNoParam
doTest RunTestsOnlyRunFailures
doTest RunTestsRunFailures
doTest RunTestsOnlyRunSuccess
doTest RunTestsRunDuplicates
doTest RunTestsRunNotTests

# RunAllTests
doTest RunAllTestsEmpty
doTest RunAllTestsNominal
doTest RunAllTestsDuplicates
doTest RunAllTestsNotTests

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
