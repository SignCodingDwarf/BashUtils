#!/bin/bash

# file :  assertUtilsTest.sh
# author : SignC0dingDw@rf
# version : 1.2
# date : 14 May 2020
# Unit testing of assertUtils.sh file.

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
# @brief Check errorMessageFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testErrorMessageFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Test Pattern
    testFormat "\033[1;31m" "${errorMessageFormat}"
    return 0  
}

##!
# @brief Check lineDelimiter value
# @return 0 if lineDelimiter has expected value, exit 1 otherwise
#
## 
testDelimiterValue()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Test lineDelimiter
    endTestIfAssertFails "\"${lineDelimiter}\" = \"\n\" " "Line delimiter must be \n but has value ${lineDelimiter}"
    return 0  
}

##!
# @brief Check PrintErrorLine behavior with arguments
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorLine()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorLine "This is an error message" > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : This is an error message\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintErrorMessage behavior with no arguments provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorMessageNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorMessage > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : \n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintErrorMessage behavior with single line message not ending with delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorMessageSingleLine()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorMessage "This is the bottom line" > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : This is the bottom line\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintErrorMessage behavior with single line message ending with delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorMessageSingleLineDelimiterEnding()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorMessage "I am on the line\n" > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : I am on the line\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintErrorMessage behavior with multiline line message not ending with delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorMessageMultiLine()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorMessage "First line\nAnother Line\nStill online" > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : First line\n" > /tmp/barRef
    printf "[Assertion Failure] : Another Line\n" >> /tmp/barRef
    printf "[Assertion Failure] : Still online\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintErrorMessage behavior with multiline line message ending with delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorMessageMultiLineDelimiterEnding()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorMessage "Mario\nPikachu\nFox\nSamus\nLink\nYoshi\nDK\nKirby\n" > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : Mario\n" > /tmp/barRef
    printf "[Assertion Failure] : Pikachu\n" >> /tmp/barRef
    printf "[Assertion Failure] : Fox\n" >> /tmp/barRef
    printf "[Assertion Failure] : Samus\n" >> /tmp/barRef
    printf "[Assertion Failure] : Link\n" >> /tmp/barRef
    printf "[Assertion Failure] : Yoshi\n" >> /tmp/barRef
    printf "[Assertion Failure] : DK\n" >> /tmp/barRef
    printf "[Assertion Failure] : Kirby\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintErrorMessage behavior with message containing consecutive delimiters
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testPrintErrorMessageConsecutiveDelimiters()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    PrintErrorMessage "Header\nSubheader\n\nText\nnot again a text !!\n\nFooter\n" > /tmp/barOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "[Assertion Failure] : Header\n" > /tmp/barRef
    printf "[Assertion Failure] : Subheader\n" >> /tmp/barRef
    printf "[Assertion Failure] : \n" >> /tmp/barRef
    printf "[Assertion Failure] : Text\n" >> /tmp/barRef
    printf "[Assertion Failure] : not again a text !!\n" >> /tmp/barRef
    printf "[Assertion Failure] : \n" >> /tmp/barRef
    printf "[Assertion Failure] : Footer\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check EndTestOnFailure behavior with no arguments provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : \n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with single line message provided not ending with \n delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureSingleLine()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "This is a mistake" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : This is a mistake\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with single line message provided ending with \n delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureSingleLineDelimiterEnding()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "An error\n" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : An error\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with multi line message provided not ending with \n delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureMultilineLine()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "Several\nErrors" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Several\n" > /tmp/barRef
    printf "[Assertion Failure] : Errors\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with multi line message provided ending with \n delimiter
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureMultiLineDelimiterEnding()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "Falcon\nJigglypluff\nNess\nLuigi\n" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Falcon\n" > /tmp/barRef
    printf "[Assertion Failure] : Jigglypluff\n" >> /tmp/barRef
    printf "[Assertion Failure] : Ness\n" >> /tmp/barRef
    printf "[Assertion Failure] : Luigi\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with multi line message with consecutive \n delimiters
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureMultiLineConsecutiveDelimiters()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "I\n\n'm\nBored\n\n!!!!!!" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : I\n" > /tmp/barRef
    printf "[Assertion Failure] : \n" >> /tmp/barRef
    printf "[Assertion Failure] : 'm\n" >> /tmp/barRef
    printf "[Assertion Failure] : Bored\n" >> /tmp/barRef
    printf "[Assertion Failure] : \n" >> /tmp/barRef
    printf "[Assertion Failure] : !!!!!!\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with return code being an unsigned integer in range ] 0 - 255]
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureValidReturnCode()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "In range" 42 > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"42\" " "Expected function to exit with code 42 but exited with code ${test_result}"

    printf "[Assertion Failure] : In range\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with return code being an unsigned integer > 255
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureOutOfRangeReturnCode()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "Out of\n range" 256 > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Out of\n" > /tmp/barRef
    printf "[Assertion Failure] :  range\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef

    printf "[Warning] : Out of ]0 - 255] range error code 256 set back to 1\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with return code being 0
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureZeroReturnCode()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "Zero Suit Samus\n" 0 > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Zero Suit Samus\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef

    printf "[Warning] : Out of ]0 - 255] range error code 0 set back to 1\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check EndTestOnFailure behavior with return code being a string
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testEndTestOnFailureStringReturnCode()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertUtils.sh" "1.2"

    ### Execute Command
    (EndTestOnFailure "A\nB\nC\n" "Not A valid exit code" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : A\n" > /tmp/barRef
    printf "[Assertion Failure] : B\n" >> /tmp/barRef
    printf "[Assertion Failure] : C\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef

    printf "[Warning] : Invalid error code Not A valid exit code set back to 1\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}
################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# Formats
doTest testErrorMessageFormat

# Delimiters
doTest testDelimiterValue

# Print
doTest testPrintErrorLine
doTest testPrintErrorMessageNoArg
doTest testPrintErrorMessageSingleLine
doTest testPrintErrorMessageSingleLineDelimiterEnding
doTest testPrintErrorMessageMultiLine
doTest testPrintErrorMessageMultiLineDelimiterEnding
doTest testPrintErrorMessageConsecutiveDelimiters

# EndTestOnFailure
doTest testEndTestOnFailureNoArg
doTest testEndTestOnFailureSingleLine
doTest testEndTestOnFailureSingleLineDelimiterEnding
doTest testEndTestOnFailureMultilineLine
doTest testEndTestOnFailureMultiLineDelimiterEnding
doTest testEndTestOnFailureMultiLineConsecutiveDelimiters
doTest testEndTestOnFailureValidReturnCode
doTest testEndTestOnFailureOutOfRangeReturnCode
doTest testEndTestOnFailureZeroReturnCode
doTest testEndTestOnFailureStringReturnCode

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
