#!/bin/bash

# file :  assertStringsTest.sh
# author : SignC0dingDw@rf
# version : 1.0
# date : 18 March 2020
# Unit testing of assertStrings.sh file.

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
# @brief Check ASSERT_STRING_IS_EQUAL behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_STRING_IS_EQUAL <expected_string> <tested_string> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with missing argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityMissingArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "Reference" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_STRING_IS_EQUAL <expected_string> <tested_string> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with tested string equal to expected string
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "AString" "AString" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with tested string equal to expected string and changed error header
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityOKHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "AString" "AString" "A comparison of strings" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with tested string not equal to expected string
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "AString" "AnotherText" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Provided strings are not identical\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : AString\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : AnotherText\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with tested string not equal to expected string and changed error header
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityKOHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "MySpeech" "TheTextIRead" "\n" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : \n" > /tmp/barRef 
    printf "[Assertion Failure] : Expected : MySpeech\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : TheTextIRead\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with arguments being empty strings
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityEmptyString()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "" "" "NotWorkingOnEmptyStrings" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_STRING_IS_EQUAL <expected_string> <tested_string> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with tested string being a part of reference string
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityTestedPartOfReference()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "A very long string" "ery" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Provided strings are not identical\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : A very long string\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : ery\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_STRING_IS_EQUAL behavior with reference string being a part of tested string
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertStringEqualityReferencePartOfTested()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertStrings.sh" "1.0"

    ### Execute Command
    (ASSERT_STRING_IS_EQUAL "eTe" "SomeText" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Provided strings are not identical\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : eTe\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got : SomeText\n" >> /tmp/barRef 
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
# ASSERT_String_CODE_VALUE
doTest testAssertStringEqualityNoArg
doTest testAssertStringEqualityMissingArg
doTest testAssertStringEqualityOK
doTest testAssertStringEqualityOKHeader
doTest testAssertStringEqualityKO
doTest testAssertStringEqualityKOHeader
doTest testAssertStringEqualityEmptyString
doTest testAssertStringEqualityTestedPartOfReference
doTest testAssertStringEqualityReferencePartOfTested

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
