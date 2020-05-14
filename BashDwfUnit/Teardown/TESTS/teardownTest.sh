#!/bin/bash

# @file teardownTest.sh
# @author SignC0dingDw@rf
# @version 1.3
# @date 14 May 2020
# @brief Unit testing of teardown.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
    rm -rf /tmp/toto*
    rm -rf /tmp/tutu*

    # Restore variables
    ENV_T1=""
    ENV_T2=""
    ENV_T3=""

    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check Teardown behavior if nothing is to be done
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TeardownNoAction()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../teardown.sh" "2.1"

    ### Execute Command
    Teardown 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "[Warning] : No User defined teardown is to be performed\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if everything works fine
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TeardownAllOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../teardown.sh" "2.1"

    ### Prepare actions 
    ELEMENTS_CREATED=("/tmp/toto1" "/tmp/toto8/dummy2")
    ELEMENTS_DIVERTED=("/tmp/tutu1" "/tmp/tutu4")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T1" "ValZ")
    TestTeardown()
    {
        return 0
    }

    ### Execute Command
    Teardown 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if user defined TestTeardown fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TeardownTestTeardownError()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../teardown.sh" "2.1"

    ### Prepare actions 
    ELEMENTS_CREATED=("/tmp/toto6" "/tmp/toto8/dummy4")
    ELEMENTS_DIVERTED=("/tmp/tutu5")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T2" "ValY")
    TestTeardown()
    {
        return 1
    }

    ### Execute Command
    Teardown 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"128\" " "Expected function to exit with code 128 but exited with code ${test_result}"

    ### Check Output
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if restauring environment variables fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TeardownTestEnvVarError()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../teardown.sh" "2.1"

    ### Prepare actions 
    ELEMENTS_CREATED=("/tmp/toto7" "/tmp/toto8/dummy6")
    ELEMENTS_DIVERTED=("/tmp/tutu2")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T3")
    TestTeardown()
    {
        return 0
    }

    ### Execute Command
    Teardown 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"64\" " "Expected function to exit with code 64 but exited with code ${test_result}"

    ### Check Output
    printf "[Error] : Value ENV_T3 has no associated value to restore. Ignoring it.\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check Teardown behavior if restauring diverted element fails
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TeardownTestDivertionError()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../teardown.sh" "2.1"

    ### Prepare actions 
    ELEMENTS_CREATED=("/tmp/toto10" "/tmp/toto8/dummy8")
    ELEMENTS_DIVERTED=("/tmp/tutu3")
    ENV_VARS_VALUES_TO_RESTORE=("ENV_T3" "ValU")
    TestTeardown()
    {
        return 0
    }

    ### Execute Command
    Teardown 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"32\" " "Expected function to exit with code 32 but exited with code ${test_result}"

    ### Check Output
    printf "mv: cannot stat '/tmp/tutu3.utmv': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/tutu3 with /tmp/tutu3.utmv\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest TeardownNoAction
doTest TeardownAllOK
doTest TeardownTestTeardownError
doTest TeardownTestEnvVarError
doTest TeardownTestDivertionError

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
