#!/bin/bash

# file :  functionsTest.sh
# author : SignC0dingDw@rf
# version : 1.1
# date : 14 May 2020
# Unit testing of functions.sh file.

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
    testFunction()
    {
        return 42
    }
    testFunction2()
    {
        return 69
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
    rm -rf /tmp/bar*
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check ASSERT_RETURN_CODE_VALUE behavior with no arguments provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertReturnEqualityNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../functions.sh" "1.1"

    ### Execute Command
    testFunction # Call test function just before calling test
    (ASSERT_RETURN_CODE_VALUE > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_RETURN_CODE_VALUE <expected_code> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_RETURN_CODE_VALUE behavior with return code equal to expected code
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertReturnEqualityOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../functions.sh" "1.1"

    ### Execute Command
    testFunction # Call test function just before calling test
    (ASSERT_RETURN_CODE_VALUE 42 > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_RETURN_CODE_VALUE behavior with return code equal to expected code and changed error header
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertReturnEqualityOKHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../functions.sh" "1.1"

    ### Execute Command
    testFunction2 # Call test function just before calling test
    (ASSERT_RETURN_CODE_VALUE 69 "This message will not be printed" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_RETURN_CODE_VALUE behavior with return code different than expected code
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertReturnEqualityKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../functions.sh" "1.1"

    ### Execute Command
    testFunction2 # Call test function just before calling test
    (ASSERT_RETURN_CODE_VALUE 42 > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Function does not have expected return code\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : 42\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : 69\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_RETURN_CODE_VALUE behavior with return code different than expected code and changed error header
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertReturnEqualityKOHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../functions.sh" "1.1"

    ### Execute Command
    testFunction # Call test function just before calling test
    (ASSERT_RETURN_CODE_VALUE 69 "Call of the Wild failed\n\n" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Call of the Wild failed\n" > /tmp/barRef
    printf "[Assertion Failure] : \n" >> /tmp/barRef 
    printf "[Assertion Failure] : Expected : 69\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : 42\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_RETURN_CODE_VALUE behavior with argument not being a number
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertReturnEqualityNotANumber()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../functions.sh" "1.1"

    ### Execute Command
    echo "Toto" # Call test function just before calling test
    (ASSERT_RETURN_CODE_VALUE "NotANumber" "You should have sent a number" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : You should have sent a number\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : NotANumber\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : 0\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# ASSERT_RETURN_CODE_VALUE
doTest testAssertReturnEqualityNoArg
doTest testAssertReturnEqualityOK
doTest testAssertReturnEqualityOKHeader
doTest testAssertReturnEqualityKO
doTest testAssertReturnEqualityKOHeader
doTest testAssertReturnEqualityNotANumber

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
