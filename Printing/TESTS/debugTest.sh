#!/bin/bash

# @file debugTest.sh
# @author SignC0dingDw@rf
# @version 1.2
# @date 28 December 2019
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
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../Tools/TESTS/testFunctions.sh"

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
# @return 0 if function displays message as expected
#         exit 1 if message is not printed correctly or if function name is unknown
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
        endTestIfAssertFails '0 -eq 1' "Unknown function ${functionName}" # Dummy assertion to make test fail
    fi

    # Run function and get Written message
    ${functionName} "${message}" 2> /tmp/bar # Print message on test
    writtenMessage=$(cat /tmp/bar)

    # Compute output
    endTestIfAssertFails "\"${writtenMessage}\" = \"${expectedMessage}\"" "Expected ${functionName} to print\n${expectedMessage}\nBut\n ${writtenMessage}\nwas printed"   

    return 0
}

################################################################################
###                                                                          ###
###                             Global Variables                             ###
###                                                                          ###
################################################################################
CURRENT_VERBOSE=""

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    CURRENT_VERBOSE=${VERBOSE}
    VERBOSE=false # Because testDebugPrint assumes that it is false at start
    return 0
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -f /tmp/bar
    VERBOSE=${CURRENT_VERBOSE} # Restaure VERBOSE value
    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check infoFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testInfoFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../debug.sh" "1.0"

    testFormat "\033[1;34m" "${infoFormat}"
    return 0    
}

##!
# @brief Check warningFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testWarningFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../debug.sh" "1.0"

    testFormat "\033[1;33m" "${warningFormat}"
    return 0    
}

##!
# @brief Check errorFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testErrorFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../debug.sh" "1.0"

    testFormat "\033[1;31m" "${errorFormat}"
    return 0    
}

##!
# @brief Test the behavior of printing methods
# @return 0 if behavior is the one expected, ecit 1 otherwise
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
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../debug.sh" "1.0"

    # Only redirection to file is tested
    ### Test print without verbosity 
    TestPrint PrintInfo false "Some info message" # Should display nothing
    TestPrint PrintWarning false "Some warning message"
    TestPrint PrintError false "Some error message"
    VERBOSE=true # Enable verbosity
    TestPrint PrintInfo false "Some other info message" # Still displays nothing because funtion is defined once and for all at fisrt call

    ### No reloading
    . "${SCRIPT_LOCATION}/../debug.sh" # Reload does nothing
    TestPrint PrintInfo false "Still an info message" # Still displays nothing because funtion was no loaded once again

    ### Test print with verbosity 
    DEBUG_SH="" # Allows script to be reloaded
    . "${SCRIPT_LOCATION}/../debug.sh" # Reload print utils to "reset" PrintInfo
    TestPrint PrintInfo true "Yet another info message"
    TestPrint PrintWarning true "Yet another warning message"
    TestPrint PrintError true "Yet another error message"
    VERBOSE=false # Disable verbosity
    TestPrint PrintInfo true "The last info message" # Still displays because funtion is defined once and for all at fisrt call

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#Format
doTest testInfoFormat
doTest testWarningFormat
doTest testErrorFormat

#Print Messages
doTest testDebugPrint

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
