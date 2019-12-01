#!/bin/bash

# @file teardownTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 08 December 2019
# @brief Unit testing of teardown.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
# @brief Check if an array has expected content
# @param 1 : Name of the array to check
# @param 2 : Name of the expected array
# @return 0 if array has expected content, 1 otherwise
#
## 
CheckArrayContent()
{
    local arrayName="$1"
    local expectedName="$2"
    local -n arrayContent=${arrayName}
    local -n expectedArray=${expectedName}

    local differences=(`echo ${expectedArray[@]} ${arrayContent[@]} | tr ' ' '\n' | sort | uniq -u`) # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash

    # Compute result
    if [ ${#differences[@]} -eq 0 ]; then
        return 0
    else
        printf "Expecting to get the content : "
        printf "%s " "${expectedArray[*]}"
        printf "\n\n"
        printf "But array ${arrayName} has content : "
        printf "%s " "${arrayContent[*]}"
        printf "\n\n"
        printf "Difference : "
        printf "%s " "${differences[*]}"
        printf "\n"
        return 1
    fi
}

##!
# @brief Test that the text written to a file is not the one 
# @param 1 : Result File name
# @param 2 : Expected Result file name
# @return 0 if text has expected value, 1 otherwise
#
##
TestWrittenText()
{
    local resultFileName=$1
    local expectedResultFileName=$2

    local currentValue=$(cat ${resultFileName})
    local expectedValue=$(cat ${expectedResultFileName})

    if [ "${currentValue}" = "${expectedValue}" ]; then
        return 0
    else
        echo "Invalid Text"
        echo "Expected ${expectedValue}"
        echo "Got ${currentValue}"
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
    if [ ! -z ${TEARDOWN_SH} ]; then 
        echo "TEARDOWN_SH already has value ${TEARDOWN_SH}"
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
    . "${SCRIPT_LOCATION}/../teardown.sh"

    if [ ! "${TEARDOWN_SH}" = "1.0" ]; then 
        echo "Loading of teardown.sh failed. Content is ${TEARDOWN_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Check Teardown behavior if nothing is to be done
# @return 0 if behavior is as expected, 1 otherwise
#
## 
TeardownNoAction()
{
    Teardown 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function Teardown to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "[Warning] : No User defined teardown is to be performed" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if everything works fine
# @return 0 if behavior is as expected, 1 otherwise
#
## 
TeardownAllOK()
{
    ELEMENTS_CREATED=("/tmp/toto1" "/tmp/toto8/dummy2")
    ELEMENTS_DIVERTED=("/tmp/tutu1" "/tmp/tutu4")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T1" "ValZ")
    TestTeardown()
    {
        return 0
    }
    Teardown 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function Teardown to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if user defined TestTeardown fails
# @return 0 if behavior is as expected, 1 otherwise
#
## 
TeardownTestTeardownError()
{
    ELEMENTS_CREATED=("/tmp/toto6" "/tmp/toto8/dummy4")
    ELEMENTS_DIVERTED=("/tmp/tutu5")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T2" "ValY")
    TestTeardown()
    {
        return 1
    }
    Teardown 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "128" ]; then
        printf "Expected function Teardown to exit with code 128 but exited with code ${result}\n"
        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if restauring environment variables fails
# @return 0 if behavior is as expected, 1 otherwise
#
## 
TeardownTestEnvVarError()
{
    ELEMENTS_CREATED=("/tmp/toto7" "/tmp/toto8/dummy6")
    ELEMENTS_DIVERTED=("/tmp/tutu2")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T3")
    TestTeardown()
    {
        return 0
    }
    Teardown 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "4" ]; then
        printf "Expected function Teardown to exit with code 4 but exited with code ${result}\n"
        return 1
    fi
    printf "[Error] : Value ENV_T3 has no associated value to restore. Ignoring it." > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if restauring diverted element fails
# @return 0 if behavior is as expected, 1 otherwise
#
## 
TeardownTestDivertionError()
{
    ELEMENTS_CREATED=("/tmp/toto10" "/tmp/toto8/dummy8")
    ELEMENTS_DIVERTED=("/tmp/tutu3")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T3" "ValU")
    TestTeardown()
    {
        return 0
    }
    Teardown 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function Teardown to exit with code 2 but exited with code ${result}\n"
        return 1
    fi
    printf "mv: cannot stat '/tmp/tutu3.utmv': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/tutu3 with /tmp/tutu3.utmv" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp
# Create directories for the test
for ((i=1;i<=10;i++)); do
    mkdir /tmp/toto${i}
done
# Create files for the test
for ((i=1;i<=20;i++)); do
    touch /tmp/toto8/dummy${i}
done

### Divert Folders for the test
for ((i=1;i<=5;i++)); do
    mkdir /tmp/tutu${i}
    mkdir /tmp/tutu${i}.utmv
done
rm -r /tmp/tutu3.utmv

### Create Environment variables for the test
ENV_T1="ValA"
ENV_T2="ValB"
ENV_T3="ValC"

### Do Tests
#Inclusion
doTest "teardown.sh not included" scriptNotIncluded
doTest "teardown.sh included" scriptIncluded

doTest "Teardown with nothing to do" TeardownNoAction
doTest "Teardown with everything working fine" TeardownAllOK
doTest "Teardown with error TestTeardown" TeardownTestTeardownError
doTest "Teardown with error Environment Vars Restauration" TeardownTestEnvVarError
doTest "Teardown with error Element Divertion" TeardownTestDivertionError

### Clean Up
rm -rf /tmp/barError*
rm -rf /tmp/toto*
rm -rf /tmp/tutu*


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
