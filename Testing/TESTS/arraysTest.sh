#!/bin/bash

# @file arraysTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 25 November 2019
# @brief Unit testing of arrays.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
    if [ ! -z ${ARRAYS_SH} ]; then 
        echo "ARRAYS_SH already has value ${ARRAYS_SH}"
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
    . "${SCRIPT_LOCATION}/../arrays.sh"

    if [ ! "${ARRAYS_SH}" = "1.0" ]; then 
        echo "Loading of arrays.sh failed. Content is ${ARRAYS_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Test IsArray in multiple ways
# @return 0 if all tests are successful, 1 otherwise
#
## 
testIsArray()
{
    ### Test variable that does not exist
    IsArray "variableThatDoesNotExist"
    local result=$?
    if [ $result -eq "0" ]; then
        echo "Test of non existing function should not return 0"
        return 1
    fi

    ### Test that function does not create symbol of array
    IsArray "variableThatDoesNotExist"
    result=$?
    if [ $result -eq "0" ]; then
        echo "Testing if element is array should not create array variable"
        return 1
    fi

    ### Test that empty string is not an array
    IsArray ""
    result=$?
    if [ $result -eq "0" ]; then
        echo "Empty string shoudl not be seen as an array"
        return 1
    fi

    ### Test that a regular variable is not considered an array
    local stringVariable="Some text"
    IsArray "stringVariable"
    result=$?
    if [ $result -eq "0" ]; then
        echo "Normal variable should not be considered an array"
        return 1
    fi

    ### Test that a regular variable is not turned into an array by function
    IsArray "stringVariable"
    result=$?
    if [ $result -eq "0" ]; then
        echo "Normal variable should not be considered an array"
        return 1
    fi

    ### Test detection of an empty array
    local emptyArray=()
    IsArray "emptyArray"
    result=$?
    if [ $result -ne "0" ]; then
        echo "Empty array is an array nonetheless"
        return 1
    fi

    ### Test detection of an array
    local anArray=("a" 33 "b" "c")
    IsArray "anArray"
    result=$?
    if [ $result -ne "0" ]; then
        echo "Failed to detect that variable is an array"
        return 1
    fi

    ### Test a simply declared array
    declare -a anotherArray
    IsArray "anotherArray"
    result=$?
    if [ $result -ne "0" ]; then
        echo "Failed to detect array declared with \"declare -a\""
        return 1
    fi

    return 0
}

##!
# @brief Check IsInArray behavior when no arguments are provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
IsInArrayNoArg()
{
    IsInArray
    local result=$?
    if [ "${result}" -ne "2" ]; then
        echo "IsInArray with no arguments should return error code 2 but returned ${result}"
        return 1
    fi
    return 0
}

##!
# @brief Check IsInArray behavior when no array name is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
IsInArrayNoArrayName()
{
    IsInArray "element"
    local result=$?
    if [ "${result}" -ne "3" ]; then
        echo "IsInArray with no array name provided should return error code 3 but returned ${result}"
        return 1
    fi
    return 0
}

##!
# @brief Check IsInArray behavior when second argument is not an array name
# @return 0 if behavior is as expected, 1 otherwise
#
## 
IsInArrayNotArrayName()
{
    local NotAnArray="notAnArray"
    IsInArray "element" "NotAnArray"
    local result=$?
    if [ "${result}" -ne "3" ]; then
        echo "IsInArray with not an array name provided should return error code 3 but returned ${result}"
        return 1
    fi
    return 0
}

##!
# @brief Check IsInArray behavior when element is indeed in array
# @return 0 if behavior is as expected, 1 otherwise
#
## 
IsInArrayInArray()
{
    local TestArray=("a" "b" "element" "42" "666")
    IsInArray "element" "TestArray"
    local result=$?
    if [ "${result}" -ne "0" ]; then
        echo "IsInArray should indicate element is in array with code 0 but returned ${result}"
        return 1
    fi
    return 0
}

##!
# @brief Check IsInArray behavior when element is not in array
# @return 0 if behavior is as expected, 1 otherwise
#
## 
IsInArrayNotInArray()
{
    local TestArray=("a" "b" "EpicFail" "42" "666")
    IsInArray "element" "TestArray"
    local result=$?
    if [ "${result}" -ne "1" ]; then
        echo "IsInArray should indicate element is not in array with code 1 but returned ${result}"
        return 1
    fi
    return 0
}

##!
# @brief Check IsInArray behavior when element tested is part of an array element but NOT an array element
# @return 0 if behavior is as expected, 1 otherwise
#
## 
IsInArrayPartOfElement()
{
    local TestArray=("a" "b" "elementispart" "containselement" "beforEelementAfter" "42" "666")
    IsInArray "element" "TestArray"
    local result=$?
    if [ "${result}" -ne "1" ]; then
        echo "IsInArray should indicate element is not in array with code 1 but returned ${result}"
        return 1
    fi
    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp

### Do Tests
doTest "arrays.sh not included" scriptNotIncluded
doTest "arrays.sh included" scriptIncluded
doTest "test IsArray" testIsArray

#IsInArray
doTest "IsInArray with no argument provided" IsInArrayNoArg
doTest "IsInArray with no array name provided" IsInArrayNoArrayName
doTest "IsInArray with not an array name provided" IsInArrayNotArrayName
doTest "IsInArray with element in array" IsInArrayInArray
doTest "IsInArray with element not in array" IsInArrayNotInArray
doTest "IsInArray with element part of array element" IsInArrayPartOfElement

### Clean Up

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
