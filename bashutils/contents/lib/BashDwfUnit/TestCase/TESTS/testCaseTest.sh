#!/bin/bash

# file :  testCaseTest.sh
# author : SignC0dingDw@rf
# version : 1.1
# date : 14 May 2020
# Unit testing of testCase.sh file.

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
    ELEMENTS_CREATED=()
    ELEMENTS_DIVERTED=()
    ENV_VARS_VALUES_TO_RESTORE=()

    rm -rf /tmp/barError*
    rm -rf /tmp/foo*
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check runTestCase behavior if no argumment is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runTestCaseNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Execute Command
    runTestCase 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    ### Check Output
    printf "[Error] :  is not a test (i.e. function) name\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check runTestCase behavior if argument provided is not a test
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runTestCaseNotTest()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Declare a variable
    local iAmAVariable="MyOwnContent"

    ### Execute Command
    runTestCase notATest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    ### Check Output
    printf "[Error] : notATest is not a test (i.e. function) name\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Execute Command
    runTestCase iAmAVariable 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    ### Check Output
    printf "[Error] : iAmAVariable is not a test (i.e. function) name\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check runTestCase behavior if every element execution goes fine
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runTestCaseOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Test Functions
    TestSetup()
    {
        return 0
    }

    MyTest()
    {
        return 0
    }

    TestTeardown()
    {
        return 0
    }


    ### Execute Command
    runTestCase MyTest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef    
}

##!
# @brief Check runTestCase behavior if setup fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runSetupFailure()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Test Functions
    TestSetup()
    {
        return 1
    }

    MyTest()
    {
        touch /tmp/fooTest
        return 0
    }

    TestTeardown()
    {
        touch /tmp/fooTeardown
        return 0
    }

    ### Execute Command
    runTestCase MyTest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"4\" " "Expected function to exit with code 4 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check execution
    CheckDirContent "/tmp/" "foo" # Should exit right after Setup
}

##!
# @brief Check runTestCase behavior if test fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runTestFailure()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Test Functions
    TestSetup()
    {
        return 0
    }

    MyTest()
    {
        touch /tmp/fooTest
        return 42
    }

    TestTeardown()
    {
        touch /tmp/fooTeardown
        return 0
    }

    ### Execute Command
    runTestCase MyTest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check execution
    CheckDirContent "/tmp/" "foo" "fooTest" "fooTeardown" # Teardown also run
}

##!
# @brief Check runTestCase behavior if teardown fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runTeardownFailure()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Test Functions
    TestSetup()
    {
        return 0
    }

    MyTest()
    {
        touch /tmp/fooTest
        return 0
    }

    TestTeardown()
    {
        touch /tmp/fooTeardown
        return 28
    }

    ### Execute Command
    runTestCase MyTest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"128\" " "Expected function to exit with code 128 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check execution
    CheckDirContent "/tmp/" "foo" "fooTest" "fooTeardown" # Teardown also run
}

##!
# @brief Check runTestCase behavior if both tewt and teardown fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runCombinedFailure()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Test Functions
    TestSetup()
    {
        ELEMENTS_DIVERTED=("/tmp/NonExisting")
        return 0
    }

    MyTest()
    {
        touch /tmp/fooTest
        return 3
    }

    TestTeardown()
    {
        touch /tmp/fooTeardown
        return 28
    }

    ### Execute Command
    runTestCase MyTest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"162\" " "Expected function to exit with code 162 but exited with code ${test_result}"

    ### Check Output
    printf "mv: cannot stat '/tmp/NonExisting.utmv': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/NonExisting with /tmp/NonExisting.utmv\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check execution
    CheckDirContent "/tmp/" "foo" "fooTest" "fooTeardown" # Teardown also run
}

##!
# @brief Check runTestCase behavior if both tewt and teardown fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
runCombinedFailure2()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../testCase.sh" "1.1"

    ### Test Functions
    TestSetup()
    {
        ENV_VARS_VALUES_TO_RESTORE=("BLABLABLA")
        return 0
    }

    MyTest()
    {
        touch /tmp/fooTest
        return 69
    }

    TestTeardown()
    {
        touch /tmp/fooTeardown
        return 0
    }

    ### Execute Command
    runTestCase MyTest 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"66\" " "Expected function to exit with code 66 but exited with code ${test_result}"

    ### Check Output
    printf "[Error] : Value BLABLABLA has no associated value to restore. Ignoring it.\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check execution
    CheckDirContent "/tmp/" "foo" "fooTest" "fooTeardown" # Teardown also run
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest runTestCaseNoArg
doTest runTestCaseNotTest
doTest runTestCaseOK
doTest runSetupFailure
doTest runTestFailure
doTest runTeardownFailure
doTest runCombinedFailure
doTest runCombinedFailure2

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
