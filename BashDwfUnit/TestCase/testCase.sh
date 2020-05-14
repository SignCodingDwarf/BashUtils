#!/bin/bash

# @file testCase.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# @brief Definition of the function used to execute a test case.

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

### Protection against multiple inclusions
if [ -z ${TESTCASE_TESTCASE_SH} ]; then

### Inclusions
SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH}/../../Printing/debug.sh"
. "${SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH}/../../Testing/function.sh"
. "${SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH}/../Utils/testStatus.sh"
. "${SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH}/../Setup/setup.sh"
. "${SCRIPT_LOCATION_PRINT_TESTCASE_TESTCASE_SH}/../Teardown/teardown.sh"

TESTCASE_TESTCASE_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using TESTCASE_TESTCASE_SH=""

##!
# @brief Execute a test case
# @param 1 : Name of the test to run
# @return 0 if test execution is successful
#         1 : Provided test name is not a function
#         otherwise returns the sum of one or more of the following values :
#         2 : Test failed
#         4 : User defined setup failed
#         8 : Reserved (for future setup return code extension)
#         16  : Element deletion failed during teardown
#         32  : Restoring diverted elements failed during teardown
#         64 : Restoring environment variables failed during teardown
#         128 : User defined TestTeardown failed during teardown
#
##
runTestCase()
{
    local testName="$1"
    local testResult=0

    FunctionExists "${testName}"
    if [ "$?" -ne "0" ]; then
        PrintError "${testName} is not a test (i.e. function) name"
        return 1
    fi

    PrintTestName ${testName}    
    (
        local runStatus=0
        # Setup
        Setup
        ((runStatus+=$?))
        if [ "${runStatus}" -ne "0" ]; then
            exit ${runStatus} # If setup failed we don't clean up anything becuase we can't really know what state we're in
        fi   

        # Test
        (eval "${testName}")
        if [ "$?" -ne "0" ]; then
            ((runStatus+=2)) # Even if test fails we go to clean up
        fi

        # Teardown
        Teardown
        ((runStatus+=$?))

        exit ${runStatus} # All went fine
    )
    testResult=$?
    return ${testResult}
}

fi # TESTCASE_TESTCASE_SH

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
