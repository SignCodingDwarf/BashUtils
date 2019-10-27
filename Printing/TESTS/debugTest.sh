#!/bin/bash

# @file debugTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 27 October 2019
# @brief Unit testing of debug.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
# @brief Test that the result of a print method is indeed the one expected
# @param 1 : Function name
# @param 2 : Verbose enabled
# @param 3 : Message
# @return 0 if function displays message as expected, 1 if message is not printed correctly or 2 if function name is unknown
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
    ${functionName} "${message}" 2> /tmp/bar # Print message on test
    writtenMessage=$(cat /tmp/bar)

    # Compute output
    if [ "${writtenMessage}" = "${expectedMessage}" ]; then
        return 0
    else
        echo "Expected ${functionName} to print ${expectedMessage}"
        echo "but ${writtenMessage} was printed"
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
    if [ ! -z ${DEBUG_SH} ]; then 
        echo "DEBUG_SH already has value ${DEBUG_SH}"
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
    . "${SCRIPT_LOCATION}/../debug.sh"

    if [ ! "${DEBUG_SH}" = "1.0" ]; then 
        echo "Loading of debug.sh failed. Content is ${DEBUG_SH}"
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
testFormat()
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
# @brief Test the behavior of printing methods
# @return 0 if behavior is the one expected, 1 otherwise or 2 if an unknown method has been called
#
# Only redirection to file is tested since we cannot capture output to terminal
# - Initial conditions VERBOSE=false
#       PrintInfo displays nothing, PrintWarning and PrintError display messages
# - Verbose=true
#       PrintInfo still displays nothing because no reloading was done
# - No reloading (i.e. not resetting file version) has no effect
# - Reloading
#       PrintInfo, PrintWarning and PrintError display messages
# - Verbose=false
#       PrintInfo still displays because no reloading was done
#
##
testDebugPrint()
{
    # Only redirection to file is tested
    TestPrint PrintInfo false "Some info message" # Should display nothing
    local RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi
    TestPrint PrintWarning false "Some warning message"
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi
    TestPrint PrintError false "Some error message"
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi

    VERBOSE=true # Enable verbosity
    TestPrint PrintInfo false "Some other info message" # Still displays nothing because funtion is defined once and for all at fisrt call
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi

    ### No reloading
    . "${SCRIPT_LOCATION}/../debug.sh" # Reload does nothing
    TestPrint PrintInfo false "Still an info message" # Still displays nothing because funtion was no loaded once again
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi

    ### Test print with verbosity 
    DEBUG_SH="" # Allows script to be reloaded
    . "${SCRIPT_LOCATION}/../debug.sh" # Reload print utils to "reset" PrintInfo
    TestPrint PrintInfo true "Yet another info message"
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi
    TestPrint PrintWarning true "Yet another warning message"
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi
    TestPrint PrintError true "Yet another error message"

    VERBOSE=false # Disable verbosity
    TestPrint PrintInfo true "The last info message" # Still displays because funtion is defined once and for all at fisrt call
    RETURN=$?
    if [ "${RETURN}" -ne "0" ]; then
        return ${RETURN}
    fi

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp
CURRENT_VERBOSE=${VERBOSE}
VERBOSE=false # Because testDebugPrint assumes that it is false at start

### Do Tests
#Inclusion
doTest "debug.sh not included" scriptNotIncluded
doTest "debug.sh included" scriptIncluded

#Format
doTest "Info Format definition" "testFormat \"\033[1;34m\" \"${infoFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Warning Format definition" "testFormat \"\033[1;33m\" \"${warningFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Error Format definition" "testFormat \"\033[1;31m\" \"${errorFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions

#Print Messages
doTest "Test debug message printing methods" testDebugPrint

### Clean Up
rm /tmp/bar
VERBOSE=${CURRENT_VERBOSE} # Restaure VERBOSE value

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
