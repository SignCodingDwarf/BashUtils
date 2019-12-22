#!/bin/bash

###
# @file testUtils.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 23 December 2019
# @brief Reimplements BashDwfUnit basic test features to allow testing of elements used by this framework.
###

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

### Protection against multiple inclusions
if [ -z ${TESTUTILS_SH} ]; then

# Definition of inclusion also contains the current library version
TESTUTILS_SH="1.0" # Reset using TESTUTILS_SH=""

################################################################################
###                                                                          ###
###                Redefinition of BashDwfUnit basic functions               ###
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
# @brief Setup test environment
# @return 0 if setup is successful
#         1 otherwise
#
#   Default definition, does nothing. 
#   Overload by redefining Setup to perform specific operations.
#
##
Setup()
{
    return 0
}

##!
# @brief Cleanup test environment
# @return 0 if cleanup is successful
#         1 otherwise
#
#   Default definition, does nothing. 
#   Overload by redefining Cleanup to perform specific operations.
#
##
Cleanup()
{
    return 0
}

##!
# @brief Run a test case (setup + test + cleaup)
# @param 1 : Test name
# @return 0 if test is successful
#         1 if test failed
#         2 if test setup failed
#         3 if test cleanup failed
#         4 if no test has been specified
#
## 
doTest()
{
    local TEST_NAME="$1"
    local TEST_RESULT=0

    if [ -z "${TEST_NAME}" ]; then
        printf "${FAILURE_FORMAT}Empty test ${TEST_NAME}${NF}\n"
        return 4
    fi

    printf "${TEST_NAME_FORMAT}***** Running Test : ${TEST_NAME} *****${NF}\n"    
    (
        # Setup
        Setup
        local RESULT=$?
        if [ "${RESULT}" -ne "0" ]; then
            exit 2 # If setup failed we don't clean up anything becuase we can't really know what state we're in
        fi   

        # Test
        (eval "${TEST_NAME}")
        local TEST_RESULT=$? # Even if test fails we go to clean up

        # Cleanup
        Cleanup
        RESULT=$?
        if [ "${TEST_RESULT}" -ne "0" ]; then # If test failed, return test exit code error
            exit 1
        elif [ "${RESULT}" -ne "0" ]; then # Otherwise, return potential error of cleanup
            exit 3
        fi
        exit 0 # All went fine
    )
    TEST_RESULT="$?"
    ((RUN_TEST_NB++))
    if [ "${TEST_RESULT}" -eq "0" ]; then
        printf "${SUCCESS_FORMAT}Test Successful${NF}\n"
    else
        ((FAILED_TEST_NB++)) 
        printf "${FAILURE_FORMAT}Test failed${NF}\n"
    fi
    return ${TEST_RESULT}
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

##!
# @brief Check the result of an assertion and ends test with an error message if it fails
# @param 1 : Tested assertion
# @param 2 : Error message if assertion fails
# @return exit 1 if test fails does nothing otherwise
#
# Should be called in your test function to stop test after every assertion.
#
## 
endTestIfAssertFails()
{
    eval "test $1"
    if [ "$?" -ne "0" ]; then
        if [ ! -z "$2" ]; then
            printf "$2\n"
            exit 1
        fi
    fi   
}

################################################################################
###                                                                          ###
###                            Helper functions                              ###
###                                                                          ###
################################################################################
##!
# @brief Turns a script path to the name of the inclusion control variable
# @param 1 : Script path
# @ouput Name of inclusion control variable
# @return 0 if extraction was successful
#         1 if no file path has been provided
#
## 
filePathToInclusionVariable()
{
    local FILE_PATH="$1"
    if [ -z "${FILE_PATH}" ]; then
        return 1
    fi
    
    local FILE_NAME=$(basename ${FILE_PATH}) # Get filename with extension from path

    echo "${FILE_NAME}" | tr . _ | tr a-z A-Z # Replaces extension's . by _, if any and then does toupper (could use ${variable^^} but this is Bash>4.0 only and we don't have any special characters here)

    return 0
}

##!
# @brief Include a tested script and check its inclusion by verifying inclusion control variable contains expected version.
# @param 1 : Script path
# @param 2 : Expected version
# @return 0 if inclusion went fine
#         exit 1 in case of error to stop test
#
# Should be called at the beginning of a test function to include any script used by the test.
#
## 
testScriptInclusion()
{
    # Check arguments
    local SCRIPT_PATH="$1"
    endTestIfAssertFails "-n ${SCRIPT_PATH}" "Script to include not provided"

    local EXPECTED_VERSION="$2"
    endTestIfAssertFails "-n ${EXPECTED_VERSION}" "Expected version not provided"
    
    # Process Arguments        
    local CONTROL_VARIABLE_NAME=""
    CONTROL_VARIABLE_NAME=$(filePathToInclusionVariable "${SCRIPT_PATH}")
    local RESULT=$?
    endTestIfAssertFails "\"${RESULT}\" -eq \"0\"" "Cannot extract inclusion control variable name"

    # Test no inclusion
    local CONTROL_VARIABLE_CONTENT="${!CONTROL_VARIABLE_NAME}"
    endTestIfAssertFails "-z ${CONTROL_VARIABLE_CONTENT}" "Inclusion Control Variable ${CONTROL_VARIABLE_NAME} already has value ${CONTROL_VARIABLE_CONTENT}"
    
    # Inclusion
    . ${SCRIPT_PATH}

    # Test inclusion
    CONTROL_VARIABLE_CONTENT="${!CONTROL_VARIABLE_NAME}"
    endTestIfAssertFails "\"${CONTROL_VARIABLE_CONTENT}\" = \"${EXPECTED_VERSION}\"" "Inclusion Failed.\nInclusion Control Variable ${CONTROL_VARIABLE_NAME} should have value ${EXPECTED_VERSION} but has value ${CONTROL_VARIABLE_CONTENT}"

    return 0
}

fi # TESTUTILS_SH

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
