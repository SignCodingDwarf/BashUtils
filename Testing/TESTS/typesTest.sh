#!/bin/bash

# @file typesTest.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 23 December 2019
# @brief Unit testing of types.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
. "${SCRIPT_LOCATION}/../../Tools/TESTS/testUtils.sh"

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Test IsUnsignedInteger with no parameters
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntEmptyPar()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with string
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntString()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger "aDummyString"
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with floating number
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntFloat()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger 42.69
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with negative integer
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntNegativeInteger()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger -666
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with a string containing an integer
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntContainInteger()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger aString187withAnInteger
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with a string starting with an integer
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntStartInteger()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger 1499startsSequence
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with a string ending with an integer
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntFinishInteger()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger stringEnd654
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with a single argument with string an spaces
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntStringAndSpace()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger "1492 Columbus discovers America"
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with a string and then an integer
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntMultipleArgFail()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger NotANumber 42 # Second argument should be ignored
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "Expected test to return code 1 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with zero
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntZero()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger 0
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Expected test to return code 0 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with valid unsigned integer
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntSuccess()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger 42
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Expected test to return code 0 but test returned code ${COMMAND_RESULT}"

    return 0
}

##!
# @brief Test IsUnsignedInteger with an integer and then a float
# @return 0 if IsUnsignedInteger has expected behavior, exit 1 otherwise
#
## 
testUIntMultipleArgSuccess()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../types.sh" "1.0"

    # Call command
    IsUnsignedInteger 069 12.94
    local COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "Expected test to return code 0 but test returned code ${COMMAND_RESULT}"

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#Unsigned Integer
doTest testUIntEmptyPar
doTest testUIntString
doTest testUIntFloat
doTest testUIntNegativeInteger
doTest testUIntContainInteger
doTest testUIntStartInteger
doTest testUIntFinishInteger
doTest testUIntStringAndSpace
doTest testUIntMultipleArgFail
doTest testUIntZero
doTest testUIntSuccess
doTest testUIntMultipleArgSuccess

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
