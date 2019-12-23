#!/bin/bash

# @file arraysTest.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 23 December 2019
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
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../TESTS/testUtils.sh"

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Test IsArray in multiple ways
# @return 0 if all tests are successful, exit 1 after first test failure
#
## 
testIsArray()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    ### Test variable that does not exist
    IsArray "variableThatDoesNotExist"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Test of non existing array should return code 1 but returned code ${COMMAND_RESULT}"

    ### Test that function does not create symbol of array
    IsArray "variableThatDoesNotExist"
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "IsArray should not create array"

    ### Test that empty string is not an array
    IsArray ""
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Empty string should not be seen as an array"

    ### Test that a regular variable is not considered an array
    local stringVariable="Some text"
    IsArray "stringVariable"
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Normal variable should not be considered as an array"

    ### Test that a regular variable is not turned into an array by function
    IsArray "stringVariable"
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "IsArray should not turn regular variable into an array"

    ### Test detection of an empty array
    local emptyArray=()
    IsArray "emptyArray"
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Empty array is an array nonetheless"

    ### Test detection of an array
    local anArray=("a" 33 "b" "c")
    IsArray "anArray"
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Failed to detect variable is an array"

    ### Test a simply declared array
    declare -a anotherArray
    IsArray "anotherArray"
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Failed to detect array declared with \"declare -a\""

    return 0
}

##!
# @brief Check IsInArray behavior when no arguments are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
IsInArrayNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    IsInArray
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"2\"" "IsInArray with no arguments should return error code 2 but returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Check IsInArray behavior when no array name is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
IsInArrayNoArrayName()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    IsInArray "element"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"3\"" "IsInArray with no array name provided should return error code 3 but returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Check IsInArray behavior when second argument is not an array name
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
IsInArrayNotArrayName()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    local NotAnArray="notAnArray"
    IsInArray "element" "NotAnArray"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"3\"" "IsInArray with no array name provided should return error code 3 but returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Check IsInArray behavior when element is indeed in array
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
IsInArrayInArray()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    local TestArray=("a" "b" "element" "42" "666")
    IsInArray "element" "TestArray"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "IsInArray should indicate element is in array with code 0 but returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Check IsInArray behavior when element is not in array
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
IsInArrayNotInArray()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    local TestArray=("a" "b" "EpicFail" "42" "666")
    IsInArray "element" "TestArray"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "IsInArray should indicate element is not in array with code 1 but returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Check IsInArray behavior when element tested is part of an array element but NOT an array element
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
IsInArrayPartOfElement()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../arrays.sh" "1.0"

    local TestArray=("a" "b" "elementispart" "containselement" "beforEelementAfter" "42" "666")
    IsInArray "element" "TestArray"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "IsInArray should indicate element is in array with code 0 but returned code ${COMMAND_RESULT}"

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest testIsArray

#IsInArray
doTest IsInArrayNoArg
doTest IsInArrayNoArrayName
doTest IsInArrayNotArrayName
doTest IsInArrayInArray
doTest IsInArrayNotInArray
doTest IsInArrayPartOfElement

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
