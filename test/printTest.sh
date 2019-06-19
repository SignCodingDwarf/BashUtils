#!/bin/bash

# file :  printTest.sh
# author : SignC0dingDw@rf
# version : 1.1
# date : 19 June 2019
# Unit testing of printUtils file. Does not implement runTest framework because it tests functions this framework uses.

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

### Behavior Variables
FAILED_TEST_NB=0

### Test inclusion state before inclusion
if [ ! -z ${PRINTUTILS_SH} ]; then 
    echo "PRINTUTILS_SH already has value ${PRINTUTILS_SH}"
    ((FAILED_TEST_NB++))
    echo -e "\033[1;31mTest KO\033[0m"
    exit ${FAILED_TEST_NB}
fi

### Include printUtils.sh
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../printUtils.sh"

if [ ! "${PRINTUTILS_SH}" = "PRINTUTILS_SH" ]; then 
    echo "Loading of printUtils.sh failed"
    ((FAILED_TEST_NB++))
    echo -e "\033[1;31mTest KO\033[0m"
    exit ${FAILED_TEST_NB}
fi

### Test Functions
##!
# @brief Test that a color is the expected one
# @param 1 : Color name
# @param 2 : Expected value
# @param 3 : Current value
# @return 0 if color has expected value, 1 otherwise
#
# Also increments FAILED_TEST_NB to ligthen test "main" structure
#
##
TestColor()
{
    local colorName=$1
    local expectedValue=$2
    local currentValue=$3

    if [ "${currentValue}" = "${expectedValue}" ]; then
        return 0
    else
        echo "Invalid ${colorName}"
        echo "Expected ${expectedValue}"
        echo "Got ${currentValue}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1    
    fi
}

##!
# @brief Test that the result of a formatted print to file (i.e. not terminal) is the one expected
# @return 0 if function displays message as expected, or 1 if message is not printed correctly
#
# Also increments FAILED_TEST_NB to ligthen test "main" structure
#
##
TestPrintToFile()
{
    # Compute printed text and expected text
    FormattedPrint 1 "Head Terminal : " " : Foot Terminal" "Head File : " " : Foot File" "A" "small" "text" > toto
    local printedText=$(cat toto)
    local expectedText="Head File : A small text : Foot File"
    
    # Compute output
    if [ "${printedText}" = "${expectedText}" ]; then
        return 0
    else
        echo "Expected ${expectedText}"
        echo "but ${printedText} was printed"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi    
}

##!
# @brief Test that the result of a print method is indeed the one expected
# @param 1 : Function name
# @param 2 : Verbose enabled
# @param 3 : Message
# @return 0 if function displays message as expected, 1 if message is not printed correctly or 2 if function name is unknown
#
# Also increments FAILED_TEST_NB to ligthen test "main" structure
#
##
TestPrint()
{
    local functionName=$1
    local isVerbose=$2
    local message=$3

    # Construct expected result
    if [ "${functionName}" = "PrintInfo" ]; then
        if [ "${isVerbose}" = true ]; then
            local expectedMessage="[Info] : ${message}"
        else
            local expectedMessage=""
        fi
    elif [ "${functionName}" = "PrintWarning" ]; then
        local expectedMessage="[Warning] : ${message}"
    elif [ "${functionName}" = "PrintError" ]; then
        local expectedMessage="[Error] : ${message}"
    else
        echo "Unknown function ${functionName}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 2
    fi

    # Run function and get Written message
    ${functionName} "${message}" 2> toto # Print message on test
    writtenMessage=$(cat toto)

    # Compute output
    if [ "${writtenMessage}" = "${expectedMessage}" ]; then
        return 0
    else
        echo "Expected ${functionName} to print ${expectedMessage}"
        echo "but ${writtenMessage} was printed"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
}

### Test colors
TestColor "usage color" "\033[1;34m" ${usageColor}
TestColor "description color" "\033[1;31m" ${descriptionColor}
TestColor "help options color" "\033[1;32m" ${helpOptionsColor}
TestColor "help category color" "\033[1;33m" ${helpCategoryColor}
TestColor "info color" "\033[1;34m" ${infoColor}
TestColor "warning color" "\033[1;33m" ${warningColor}
TestColor "error color" "\033[1;31m" ${errorColor}
TestColor "No format" "\033[0m" ${NC}

### Test IsWrittenToTerminal
IsWrittenToTerminal 1 # Standard output to terminal
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "[IsWrittenToTerminal] : Standard output is not written to a terminal"
fi

IsWrittenToTerminal 1 > toto # Detection of redirection
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "[IsWrittenToTerminal] : Standard output is not redirected to file"
fi

IsWrittenToTerminal # Invalid input
if [ $? -ne 2 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "[IsWrittenToTerminal] : Wrong detection of invalid input"
fi

IsWrittenToTerminal 2 > toto # Error is not redirected
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "[IsWrittenToTerminal] : Error output should not be redirected"
fi

IsWrittenToTerminal 2 2> toto # Error is redirected
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "[IsWrittenToTerminal] : Error output should be redirected"
fi

### Test FormattedPrint
TestPrintToFile # We only test redirection to file because printing to terminal does not allow us to capture flux

### Test print with no verbosity 
# Only redirection to file is tested
TestPrint PrintInfo false "Some info message" # Should display nothing
TestPrint PrintWarning false "Some warning message"
TestPrint PrintError false "Some error message"

VERBOSE=true # Enable verbosity
TestPrint PrintInfo false "Some other info message" # Still displays nothing because funtion is defined once and for all at fisrt call

### No reloading
. "${SCRIPT_LOCATION}/../printUtils.sh" # Reload does nothing
TestPrint PrintInfo false "Still an info message" # Still displays nothing because funtion was no loaded once again

### Test print with verbosity 
PRINTUTILS_SH="" # Allows script to be reloaded
. "${SCRIPT_LOCATION}/../printUtils.sh" # Reload print utils to "reset" PrintInfo
TestPrint PrintInfo true "Yet another info message"
TestPrint PrintWarning true "Yet another warning message"
TestPrint PrintError true "Yet another error message"

VERBOSE=false # Disable verbosity
TestPrint PrintInfo true "The last info message" # Still displays because funtion is defined once and for all at fisrt call

### Clean up
rm toto

### Test result
if [ ${FAILED_TEST_NB} -eq 0 ]; then
    echo -e "\033[1;32mTest OK\033[0m"
else
    echo -e "\033[1;31mTest KO\033[0m"
fi

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
