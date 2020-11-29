#!/bin/bash

# file :  setupTest.sh
# author : SignC0dingDw@rf
# version : 1.2
# date : 29 November 2020
# Unit testing of setup.sh file.

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
. "${SCRIPT_LOCATION}/../../../Tools/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    ELEMENTS_CREATED=("Something")
    ELEMENTS_DIVERTED=("A" "Stuff")
    ENV_VARS_VALUES_TO_RESTORE=("Not" "an" "Empty" "Array")

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -rf /tmp/barError*
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check Setup behavior if no user defined actions are perfomed
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
SetupNoAction()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../setup.sh" "1.1"

    ### Execute Command
    Setup 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent ELEMENTS_CREATED emptyArray
    CheckArrayContent ELEMENTS_DIVERTED emptyArray
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE emptyArray

    ### Check Output
    printf "[Warning] : No User defined setup is to be performed\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Setup behavior if user defined setup is successful
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
SetupOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../setup.sh" "1.1"

    ### Prepare actions
    TestSetup()
    {
        return 0
    }

    ### Execute Command
    Setup 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent ELEMENTS_CREATED emptyArray
    CheckArrayContent ELEMENTS_DIVERTED emptyArray
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE emptyArray

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Setup behavior if user defined setup fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
SetupError()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../setup.sh" "1.1"

    ### Prepare actions
    TestSetup()
    {
        return 42
    }

    ### Execute Command
    Setup 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"4\" " "Expected function to exit with code 4 but exited with code ${test_result}"

    local emptyArray=()
    CheckArrayContent ELEMENTS_CREATED emptyArray
    CheckArrayContent ELEMENTS_DIVERTED emptyArray
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE emptyArray

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest SetupNoAction
doTest SetupOK
doTest SetupError

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
