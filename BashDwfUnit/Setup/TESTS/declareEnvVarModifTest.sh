#!/bin/bash

# file :  declareEnvVarModifTest.sh
# author : SignC0dingDw@rf
# version : 1.0
# date : 12 January 2020
# Unit testing of declareEnvVarModif.sh file.

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
. "${SCRIPT_LOCATION}/../../../Tools/TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    ### Initialize lists
    ENV_VARS_VALUES_TO_RESTORE=()

    ### Create Environment variables for the test
    ENV_T1="ValA"
    ENV_T2="ValB"
    ENV_T3="ValC"
    ENV_T4="ValD"
    ENV_T6="ValF"

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    ENV_VARS_VALUES_TO_RESTORE=()

    # Restore variables
    ENV_T1=""
    ENV_T2=""
    ENV_T3=""
    ENV_T4=""
    ENV_T5=""
    ENV_T6=""  

    rm -f /tmp/barError*

    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check DeclareEnvVars behavior if no input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclEnvVarsNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareEnvVarModif.sh" "1.0"

    ### Test command
    DeclEnvVars 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Error] : You should specify an environment variable to restore\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclareEnvVars behavior with standard input
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclEnvVarsNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareEnvVarModif.sh" "1.0"

    ### Add a few variables
    DeclEnvVars "ENV_T2" "ENV_T6" > /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("ENV_T2" "ValB" "ENV_T6" "ValF")
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE referenceArray

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Add a variable and an empty variable
    DeclEnvVars "ENV_T1" "ENV_T5" > /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    referenceArray=("ENV_T2" "ValB" "ENV_T6" "ValF" "ENV_T1" "ValA" "ENV_T5" "")
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE referenceArray

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Add a singel variable
    DeclEnvVars "ENV_T4" > /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    referenceArray=("ENV_T2" "ValB" "ENV_T6" "ValF" "ENV_T1" "ValA" "ENV_T5" "" "ENV_T4" "ValD")
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE referenceArray

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclareModEnvVar behavior if no input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclModEnvVarNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareEnvVarModif.sh" "1.0"

    ### Test command
    DeclModEnvVar 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Error] : You should specify an environment variable to restore\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclareModEnvVar behavior with standard input
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclModEnvVarNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareEnvVarModif.sh" "1.0"

    ### First variable
    DeclModEnvVar "ENV_T3" "ValX" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("ENV_T3" "ValC")
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE referenceArray

    local expectedVariables=("ValA" "ValB" "ValX" "ValD" "" "ValF")
    local variablesContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    CheckArrayContent variablesContent expectedVariables
 
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Fill Empty variable (ignore additional arguments)
    DeclModEnvVar "ENV_T5" "SomeContent" 1 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("ENV_T3" "ValC" "ENV_T5" "")
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE referenceArray

    local expectedVariables=("ValA" "ValB" "ValX" "ValD" "SomeContent" "ValF")
    local variablesContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    CheckArrayContent variablesContent expectedVariables
 
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Empty value of existing variable
    DeclModEnvVar "ENV_T1" "" 1 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("ENV_T3" "ValC" "ENV_T5" "" "ENV_T1" "ValA")
    CheckArrayContent ENV_VARS_VALUES_TO_RESTORE referenceArray

    local expectedVariables=("" "ValB" "ValX" "ValD" "SomeContent" "ValF")
    local variablesContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    CheckArrayContent variablesContent expectedVariables
 
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# DeclEnvVars
doTest TestDeclEnvVarsNoInput
doTest TestDeclEnvVarsNominalInput

# DeclModEnvVar
doTest TestDeclModEnvVarNoInput
doTest TestDeclModEnvVarNominalInput

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
