#!/bin/bash

# @file functionTest.sh
# @author SignC0dingDw@rf
# @version 2.3
# @date 14 May 2020
# @brief Unit testing of function.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
. "${SCRIPT_LOCATION}/../../Tools/TESTS/testUtils.sh"

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Test FunctionExists in multiple ways
# @return 0 if all tests are successful, exit 1 after first test failure
#
## 
testFunctionExists()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../function.sh" "1.3"

    ### Test before function exists
    FunctionExists DummyFunction
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Test of non existing function should return code 1 but returned code ${COMMAND_RESULT}"

    ### Test that function does not create symbol of function
    FunctionExists DummyFunction
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Test of non existing function should return code 1 but returned code ${COMMAND_RESULT}"

    ### Declare function
    DummyFunction()
    {
        echo "Does nothing"
    }

    ### Test existing function
    FunctionExists DummyFunction
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Test of existing function should return code 0 but returned code ${COMMAND_RESULT}"
   
 ### Delete Function symbol
    unset -f DummyFunction

    ### Test function deletion
    FunctionExists DummyFunction
    COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Test of non existing function should return code 1 but returned code ${COMMAND_RESULT}"


    return 0
}

##!
# @brief Check FunctionExists if no argument is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
testNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../function.sh" "1.3"

    ## Test command
    FunctionExists 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test without argument should return code 1 but returned code ${commandResult}"
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest testFunctionExists
doTest testNoArg

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
