#!/bin/bash

# @file baseTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 27 October 2019
# @brief Unit testing of base.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
    if [ ! -z ${BASE_SH} ]; then 
        echo "BASE_SH already has value ${BASE_SH}"
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
    . "${SCRIPT_LOCATION}/../base.sh"

    if [ ! "${BASE_SH}" = "1.0" ]; then 
        echo "Loading of base.sh failed. Content is ${BASE_SH}"
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
TestFormat()
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
# @brief Check if IsWrittenToTerminal behavior when writting to standard output
# @return 0 if script is included, 1 otherwise
#
## 
testDetectionStdOutput()
{
    IsWrittenToTerminal 1 # Standard output to terminal
    if [ $? -ne 0 ]; then
        echo "Standard output is not written to a terminal"
        return 1
    fi  
    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior when redirecting standard output to file
# @return 0 if script is included, 1 otherwise
#
## 
testDetectionStdToFile()
{
    IsWrittenToTerminal 1 > /tmp/bar # Detection of redirection
    if [ $? -ne 1 ]; then
        echo "Standard output redirection to file has not been detected"
        return 1
    fi 
    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior with no input
# @return 0 if script is included, 1 otherwise
#
## 
testDetectionNoInput()
{
    IsWrittenToTerminal # No input
    if [ $? -ne 2 ]; then
        echo "Absence of input should appear as an invalid input"
        return 1
    fi 
    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior when writting to error output while standard output is redirected
# @return 0 if script is included, 1 otherwise
#
## 
testDetectionErrOutput()
{
    IsWrittenToTerminal 2 > /tmp/bar # Error is not redirected
    if [ $? -ne 0 ]; then
        echo "Error output is not written to a terminal"
        return 1
    fi  
    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior when redirecting error output to file
# @return 0 if script is included, 1 otherwise
#
## 
testDetectionErrToFile()
{
    IsWrittenToTerminal 2 2> /tmp/bar # Detection of redirection
    if [ $? -ne 1 ]; then
        echo "Standard output redirection to file has not been detected"
        return 1
    fi 
    return 0   
}

##!
# @brief Check if the result of a FormattedPrint to file (i.e. not terminal) is the one expected
# @return 0 if function displays message as expected, or 1 if message is not printed correctly
#
# We only test redirection to file because printing to terminal does not allow us to capture flux
#
##
TestFormattedPrintToFile()
{
    # Compute printed text and expected text
    FormattedPrint 1 "Head Terminal : " " : Foot Terminal" "Head File : " " : Foot File" "A" "small" "text" > /tmp/bar
    local printedText=$(cat /tmp/bar)
    local expectedText="Head File : A small text : Foot File"
    
    # Compute output
    if [ "${printedText}" = "${expectedText}" ]; then
        return 0
    else
        echo "Expected ${expectedText}"
        echo "but ${printedText} was printed"
        return 1
    fi    
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp

### Do Tests
#Inclusion
doTest "base.sh not included" scriptNotIncluded
doTest "base.sh included" scriptIncluded

#Format
doTest "No Format definition" "TestFormat \033[0m ${NF}"

# IsWrittenToTerminal
doTest "IsWrittenToTerminal detects standard output as terminal" testDetectionStdOutput
doTest "IsWrittenToTerminal detects standard output redirection" testDetectionStdToFile
doTest "IsWrittenToTerminal detects absence of input" testDetectionNoInput
doTest "IsWrittenToTerminal detects error output as terminal" testDetectionErrOutput
doTest "IsWrittenToTerminal detects error output redirection" testDetectionErrToFile

# FormattedPrint
doTest "FormattedPrint behavior" TestFormattedPrintToFile

### Clean Up
rm /tmp/bar

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
