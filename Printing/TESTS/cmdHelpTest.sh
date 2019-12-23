#!/bin/bash

# @file cmdHelpTest.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 26 December 2019
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
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                            Helper functions                              ###
###                                                                          ###
################################################################################
##!
# @brief Test that a format is the expected one
# @param 1 : Expected value
# @param 2 : Current value
# @return 0 if format has expected value, exit 1 otherwise
#
##
testFormat()
{
    local expectedValue="$1"
    local currentValue="$2"

    if [ "${currentValue}" = "${expectedValue}" ]; then
        return 0
    else
        echo "Invalid Format"
        echo "Expected ${expectedValue}"
        echo "Got ${currentValue}"
        exit 1    
    fi
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -f /tmp/bar*
    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check usageFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testUsageFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    testFormat "\033[1;34m" "${usageFormat}"
    return 0    
}

##!
# @brief Check descriptionFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testDescriptionFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    testFormat "\033[1;31m" "${descriptionFormat}"
    return 0    
}

##!
# @brief Check helpOptionsFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testHelpOptionsFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    testFormat "\033[1;32m" "${helpOptionsFormat}"
    return 0    
}

##!
# @brief Check helpCategoryFormat value
# @return 0 if format has expected value, exit 1 otherwise
#
## 
testHelpCategoryFormat()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    testFormat "\033[1;33m" "${helpCategoryFormat}"
    return 0    
}

##!
# @brief Check PrintUsage behavior with arguments
# @return 0 if PrintUsage has expected behavior, exit 1 otherwise
#
##
TestPrintUsageArguments()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintUsage "dummyCmd" "<options>" "[arg1]" "[arg2]" "[arg3]" > /tmp/barOutput
    printf "Usage \n" > /tmp/barRef
    printf " ./dummyCmd <options> [arg1] [arg2] [arg3]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief Check PrintUsage behavior without argument
# @return 0 if PrintUsage has expected behavior, exit 1 otherwise
#
##
TestPrintUsageNoArgument()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintUsage "simpleCmd" > /tmp/barOutput
    printf "Usage \n" > /tmp/barRef
    printf " ./simpleCmd \n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 
}

##!
# @brief check PrintDescription behavior
# @return 0 if PrintDescription has expected behavior, exit 1 otherwise
#
##
TestPrintDescription()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintDescription "Description of a command" > /tmp/barOutput
    printf "Description of a command\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef

    return 0  
}

##!
# @brief Check PrintOptionCategory behavior
# @return 0 if PrintOptionCategory has expected behavior, exit 1 otherwise
#
##
TestPrintOptionCategory()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintOptionCategory "A category of options" > /tmp/barOutput
    printf "%s\n" "----- A category of options -----" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    return 0
}

##!
# @brief Check if IsLongOption detects valid long options
# @return 0 if option detection works as expected, exit 1 otherwise
#
##
TestIsLongOptionValid()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    IsLongOption "--longOpt"
    local is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"0\" " "--longOpt is a valid long option"

    return 0
}

##!
# @brief Check if IsLongOption detects invalid long options
# @return 0 if option detection works as expected, exit 1 otherwise
#
##
TestIsLongOptionInvalid()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    IsLongOption "-shortOpt"
    local is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "-shortOpt is not a valid long option"

    IsLongOption "--a"
    is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "--a is not a valid long option"

    IsLongOption "--"
    is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "-- is not a valid long option"

    IsLongOption "--,z"
    is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "--,z is not a valid long option"

    IsLongOption "foo--bar"
    is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "foo--bar is not a valid long option"

    IsLongOption ""
    is_long_option=$?
    endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "empty string is not a valid long option"
 
   IsLongOption "notAnOption"
   is_long_option=$?
   endTestIfAssertFails "\"${is_long_option}\" -eq \"1\" " "notAnOption is not a valid long option"

    return 0
}

##!
# @brief Check if IsShortOption detects valid short options
# @return 0 if option detection works as expected, exit 1 otherwise
#
##
TestIsShortOptionValid()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    IsShortOption "-a"
    local is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"0\" " "-a is a valid short option"

    IsShortOption "-6"
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"0\" " "-6 is a valid short option"

    return 0
}

##!
# @brief Check if IsShortOption detects invalid short options
# @return 0 if option detection works as expected, exit 1 otherwise
#
##
TestIsShortOptionInvalid()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    IsShortOption "--longOpt"
    local is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "--longOpt is not a valid short option"

    IsShortOption "-shortOpt"
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "-shortOpt is not a valid short option"

    IsShortOption "--"
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "-- is not a valid short option"

    IsShortOption "-!"
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "-! is not a valid short option"

    IsShortOption "foo-bar"
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "foo-bar is not a valid short option"

    IsShortOption ""
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "empty string is not a valid short option"

    IsShortOption "notAnOption"
    is_short_option=$?
    endTestIfAssertFails "\"${is_short_option}\" -eq \"1\" " "notAnOption is not a valid short option"

    return 0
}

##!
# @brief Check PrintOption behavior with valid option cases
# @return 0 if PrintOption has expected behavior, exit 1 otherwise
#
##
TestPrintOptionValidCases()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintOption "-v" "--verbose" "set verbosity" > /tmp/barOutput
    local print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"0\" " "option should be displayed without error"
    printf "%s\t\t %s\n" "-v or --verbose" "set verbosity" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "-h" "print help" > /tmp/barOutput
    print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"0\" " "option should be displayed without error"
    printf "%s\t\t %s\n" "-h" "print help" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "--test" "testing stuff" > /tmp/barOutput
    print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"0\" " "option should be displayed without error"
    printf "%s\t\t %s\n" "--test" "testing stuff" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "--foo" "-f" "what" "a" "bar" > /tmp/barOutput
    print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"0\" " "option should be displayed without error"
    printf "%s\t\t %s\n" "-f or --foo" "what a bar" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "--long" "-s" "--fail" "after arg 3 : not viewed as an option" > /tmp/barOutput
    print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"0\" " "option should be ignored at argumùent 3"
    printf "%s\t\t %s\n" "-s or --long" "--fail after arg 3 : not viewed as an option" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    return 0
}

##!
# @brief Check PrintOption detects option absence
# @return 0 if PrintOption has expected behavior, exit 1 otherwise
#
##
TestPrintOptionNoOption()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintOption "no option" "present" > /tmp/barOutput
    local print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"255\" " "Option absence should be detected"
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "the option" "comes" "--after" > /tmp/barOutput
    print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"255\" " "Option absence should be detected"
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    return 0
}

##!
# @brief Check PrintOption detects if there are two short or two long options
# @return 0 if PrintOption has expected behavior, exit 1 otherwise
#
##
TestPrintOptionDuplication()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../cmdHelp.sh" "1.0"

    PrintOption "-v" "-w" "twice a short option" > /tmp/barOutput
    local print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"254\" " "Option duplication should be detected"
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    PrintOption "--long" "--verylong" "twice a long option" > /tmp/barOutput
    print_result=$?
    endTestIfAssertFails "\"${print_result}\" -eq \"254\" " "Option duplication should be detected"
    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#Format
doTest testUsageFormat
doTest testDescriptionFormat
doTest testHelpOptionsFormat
doTest testHelpCategoryFormat

#Print usage
doTest TestPrintUsageArguments
doTest TestPrintUsageNoArgument

#Print description
doTest TestPrintDescription

#Print option category
doTest TestPrintOptionCategory

#Options detection
doTest TestIsLongOptionValid
doTest TestIsLongOptionInvalid
doTest TestIsShortOptionValid
doTest TestIsShortOptionInvalid

#Print option
doTest TestPrintOptionValidCases
doTest TestPrintOptionNoOption
doTest TestPrintOptionDuplication

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
