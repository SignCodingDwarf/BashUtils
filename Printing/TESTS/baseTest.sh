#!/bin/bash

# @file baseTest.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 24 December 2019
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
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../TESTS/testUtils.sh"

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -f /tmp/bar
    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check NF (i.e. no format) value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
TestNoFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"
 
    # Test format
    if [ "\033[0m" = "${NF}" ]; then
        return 0
    else
        echo "Invalid Format"
        echo "Expected \033[0m"
        echo "Got ${NF}"
        exit 1
    fi
}

##!
# @brief Check if IsWrittenToTerminal behavior when writting to standard output
# @return 0 if script is included, exit 1 otherwise
#
## 
testDetectionStdOutput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"

    IsWrittenToTerminal 1 # Standard output to terminal
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Local output is not written to terminal. Got code ${COMMAND_RESULT}"

    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior when redirecting standard output to file
# @return 0 if script is included, exit 1 otherwise
#
## 
testDetectionStdToFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"

    IsWrittenToTerminal 1 > /tmp/bar # Detection of redirection
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\" " "Standard output redirection to file has not been detected. Got code ${COMMAND_RESULT}"

    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior with no input
# @return 0 if script is included, exit 1 otherwise
#
## 
testDetectionNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"

    IsWrittenToTerminal # No input
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"2\" " "Absence of input should appear as an invalid input with code 2 but got code ${COMMAND_RESULT}"

    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior when writting to error output while standard output is redirected
# @return 0 if script is included, exit 1 otherwise
#
## 
testDetectionErrOutput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"

    IsWrittenToTerminal 2 > /tmp/bar # Error is not redirected
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Error output is not written to terminal. Got code ${COMMAND_RESULT}"

    return 0   
}

##!
# @brief Check if IsWrittenToTerminal behavior when redirecting error output to file
# @return 0 if script is included, exit 1 otherwise
#
## 
testDetectionErrToFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"

    IsWrittenToTerminal 2 2> /tmp/bar # Detection of redirection
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\" " "Error output redirection to file has not been detected. Got code ${COMMAND_RESULT}"

    return 0   
}

##!
# @brief Check if the result of a FormattedPrint to file (i.e. not terminal) is the one expected
# @return 0 if function displays message as expected, or exit 1 if message is not printed correctly
#
# We only test redirection to file because printing to terminal does not allow us to capture flux
#
##
TestFormattedPrintToFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../base.sh" "1.0"

    # Compute printed text and expected text
    FormattedPrint 1 "Head Terminal : " " : Foot Terminal" "Head File : " " : Foot File" "A" "small" "text" > /tmp/bar
    local printedText=$(cat /tmp/bar)
    local expectedText="Head File : A small text : Foot File"
    
    # Process output
    endTestIfAssertFails "\"${printedText}\" = \"${expectedText}\" " "Expected\n${expectedText}\nBut\n${printedText}\nwas printed"

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
#Format
doTest TestNoFormat

# IsWrittenToTerminal
doTest testDetectionStdOutput
doTest testDetectionStdToFile
doTest testDetectionNoInput
doTest testDetectionErrOutput
doTest testDetectionErrToFile

# FormattedPrint
doTest TestFormattedPrintToFile

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
