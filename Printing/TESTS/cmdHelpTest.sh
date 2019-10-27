#!/bin/bash

# @file cmdHelpTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 27 October 2019
# @brief Unit testing of cmdHelp.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
    if [ ! -z ${CMDHELP_SH} ]; then 
        echo "CMDHELP_SH already has value ${CMDHELP_SH}"
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
    . "${SCRIPT_LOCATION}/../cmdHelp.sh"

    if [ ! "${CMDHELP_SH}" = "1.0" ]; then 
        echo "Loading of cmdHelp.sh failed. Content is ${CMDHELP_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Test that a format is the expected one
# @param 1 : Expected value
# @param 2 : Current value
# @return 0 if format has expected value, 1 otherwise
#
##
TestFormat()
{
    local expectedValue="$1"
    local currentValue="$2"

    if [ "${currentValue}" = "${expectedValue}" ]; then
        return 0
    else
        echo "Invalid Format"
        echo "Expected ${expectedValue}"
        echo "Got ${currentValue}"
        return 1    
    fi
}

##!
# @brief Check PrintUsage behavior with arguments
# @return 0 if PrintUsage has expected behavior, 1 otherwise
#
##
TestPrintUsageArguments()
{
    PrintUsage "dummyCmd" "<options>" "[arg1]" "[arg2]" "[arg3]" > /tmp/barOutput
    printf "Usage \n" > /tmp/barRef
    printf " ./dummyCmd <options> [arg1] [arg2] [arg3]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintUsage behavior without argument
# @return 0 if PrintUsage has expected behavior, 1 otherwise
#
##
TestPrintUsageNoArgument()
{
    PrintUsage "simpleCmd" > /tmp/barOutput
    printf "Usage \n" > /tmp/barRef
    printf " ./simpleCmd \n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief check PrintDescription behavior
# @return 0 if PrintDescription has expected behavior, 1 otherwise
#
##
TestPrintDescription()
{
    PrintDescription "Description of a command" > /tmp/barOutput
    printf "Description of a command\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef  
}

##!
# @brief Check PrintOptionCategory behavior
# @return 0 if PrintOptionCategory has expected behavior, 1 otherwise
#
##
TestPrintOptionCategory()
{
    PrintOptionCategory "A category of options" > /tmp/barOutput
    printf "%s\n" "----- A category of options -----" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check if IsLongOption detects valid long options
# @return 0 if option detection works as expected, 1 otherwise
#
##
TestIsLongOptionValid()
{
    IsLongOption "--longOpt"
    if [ $? -ne 0 ]; then
        echo "--longOpt is a valid long option"
        return 1
    fi
    return 0
}

##!
# @brief Check if IsLongOption detects invalid long options
# @return 0 if option detection works as expected, 1 otherwise
#
##
TestIsLongOptionInvalid()
{
    IsLongOption "-shortOpt"
    if [ $? -ne 1 ]; then
       echo "-shortOpt is not a valid long option"
       return 1
    fi
    IsLongOption "--a"
    if [ $? -ne 1 ]; then
        echo "--a is not a valid long option"
        return 1
    fi

    IsLongOption "--"
    if [ $? -ne 1 ]; then
        echo "-- is not a valid long option"
        return 1
    fi

    IsLongOption "--,z"
    if [ $? -ne 1 ]; then
        echo "--,z is not a valid long option"
        return 1        
    fi

    IsLongOption "foo--bar"
    if [ $? -ne 1 ]; then
        echo "foo--bar is not a valid long option"
        return 1
    fi

    IsLongOption ""
    if [ $? -ne 1 ]; then
        echo "empty string is not a valid long option"
        return 1
    fi

    IsLongOption "notAnOption"
    if [ $? -ne 1 ]; then
        echo "notAnOption is not a valid long option"
        return 1
    fi
    return 0
}

##!
# @brief Check if IsShortOption detects valid short options
# @return 0 if option detection works as expected, 1 otherwise
#
##
TestIsShortOptionValid()
{
    IsShortOption "-a"
    if [ $? -ne 0 ]; then
        echo "-a is a valid short option"
        return 1
    fi

    IsShortOption "-6"
    if [ $? -ne 0 ]; then
        echo "-6 is a valid short option"
        return 1
    fi
    return 0
}

##!
# @brief Check if IsShortOption detects invalid short options
# @return 0 if option detection works as expected, 1 otherwise
#
##
TestIsShortOptionInvalid()
{
    IsShortOption "--longOpt"
    if [ $? -ne 1 ]; then
        echo "--longOpt is not a valid short option"
        return 1
    fi

    IsShortOption "-shortOpt"
    if [ $? -ne 1 ]; then
        echo "-shortOpt is not a valid short option"
        return 1
    fi

    IsShortOption "--"
    if [ $? -ne 1 ]; then
        echo "-- is not a valid short option"
        return 1
    fi

    IsShortOption "-!"
    if [ $? -ne 1 ]; then
        echo "-! is not a valid short option"
        return 1
    fi

    IsShortOption "foo-bar"
    if [ $? -ne 1 ]; then
        echo "foo-bar is not a valid short option"
        return 1
    fi

    IsShortOption ""
    if [ $? -ne 1 ]; then
        echo "empty string is not a valid short option"
        return 1
    fi

    IsShortOption "notAnOption"
    if [ $? -ne 1 ]; then
        echo "notAnOption is not a valid short option"
        return 1
    fi
    return 0
}

##!
# @brief Check PrintOption behavior with valid option cases
# @return 0 if PrintOption has expected behavior, 1 otherwise
#
##
TestPrintOptionValidCases()
{
    PrintOption "-v" "--verbose" "set verbosity" > /tmp/barOutput
    if [ $? -ne 0 ]; then
        return 1
        echo "Option should be displayed without error"
    fi
    printf "%s\t\t %s\n" "-v or --verbose" "set verbosity" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "Invalid text displayed"
        return 1
    fi

    PrintOption "-h" "print help" > /tmp/barOutput
    if [ $? -ne 0 ]; then
        return 1
        echo "Option should be displayed without error"
    fi
    printf "%s\t\t %s\n" "-h" "print help" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "Invalid text displayed"
        return 1
    fi

    PrintOption "--test" "testing stuff" > /tmp/barOutput
    if [ $? -ne 0 ]; then
        return 1
        echo "Option should be displayed without error"
    fi
    printf "%s\t\t %s\n" "--test" "testing stuff" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "Invalid text displayed"
        return 1
    fi

    PrintOption "--foo" "-f" "what" "a" "bar" > /tmp/barOutput
    if [ $? -ne 0 ]; then
        return 1
        echo "Option should be displayed without error"
    fi
    printf "%s\t\t %s\n" "-f or --foo" "what a bar" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "Invalid text displayed"
        return 1
    fi

    PrintOption "--long" "-s" "--fail" "after arg 3 : not viewed as an option" > /tmp/barOutput
    if [ $? -ne 0 ]; then
        return 1
        echo "Option shoudl be ignored at argument 3"
    fi
    printf "%s\t\t %s\n" "-s or --long" "--fail after arg 3 : not viewed as an option" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "Invalid text displayed"
        return 1
    fi
    return 0
}

##!
# @brief Check PrintOption detects option absence
# @return 0 if PrintOption has expected behavior, 1 otherwise
#
##
TestPrintOptionNoOption()
{
    PrintOption "no option" "present" > /tmp/barOutput
    if [ $? -ne 255 ]; then
        echo "Option absence should be detected"
        return 1
    fi
    printf "" > /tmp/barRef
    if [ $? -ne 0 ]; then
        echo "No text should be displayed with no option"
        return 1
    fi
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "the option" "comes" "--after" > /tmp/barOutput
    if [ $? -ne 255 ]; then
        echo "Option absence should be detected"
        return 1
    fi
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "No text should be displayed with no option"
        return 1
    fi
    return 0
}

##!
# @brief Check PrintOption detects if there are two short or two long options
# @return 0 if PrintOption has expected behavior, 1 otherwise
#
##
TestPrintOptionDuplication()
{
    PrintOption "-v" "-w" "twice a short option" > /tmp/barOutput
    if [ $? -ne 254 ]; then
        echo "Option duplication should be detected"
        return 1
    fi
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "No text should be displayed with short option duplication"
        return 1
    fi

    PrintOption "--long" "--verylong" "twice a long option" > /tmp/barOutput
    if [ $? -ne 254 ]; then
        echo "Option duplication should be detected"
        return 1
    fi
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
    if [ $? -ne 0 ]; then
        echo "No text should be displayed with long option duplication"
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
#Inclusion
doTest "cmdHelp.sh not included" scriptNotIncluded
doTest "cmdHelp.sh included" scriptIncluded

#Format
doTest "Usage Format definition" "TestFormat \"\033[1;34m\" \"${usageFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Description Format definition" "TestFormat \"\033[1;31m\" \"${descriptionFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Help Options Format definition" "TestFormat \"\033[1;32m\" \"${helpOptionsFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions
doTest "Help Category Format definition" "TestFormat \"\033[1;33m\" \"${helpCategoryFormat}\"" # Quotes are needed otherwise ";" is considered splitting instructions

#Print usage
doTest "PrintUsage with arguments" TestPrintUsageArguments
doTest "PrintUsage without argument" TestPrintUsageNoArgument

#Print description
doTest "PrintDescription" TestPrintDescription

#Print option category
doTest "PrintOptionCategory" TestPrintOptionCategory

#Options detection
doTest "IsLongOption valid options" TestIsLongOptionValid
doTest "IsLongOption invalid options" TestIsLongOptionInvalid
doTest "IsShortOption valid options" TestIsShortOptionValid
doTest "IsShortOption invalid options" TestIsShortOptionInvalid

#Print option
doTest "PrintOption valid cases" TestPrintOptionValidCases
doTest "PrintOption no option" TestPrintOptionNoOption
doTest "PrintOption option duplication" TestPrintOptionDuplication

### Clean Up
rm /tmp/bar*

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
