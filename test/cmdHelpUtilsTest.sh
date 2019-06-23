#!/bin/bash

# file :  cmdHelpUtilsTest.sh
# author : SignC0dingDw@rf
# version : 1.1
# date : 23 June 2019
# Unit testing of cmdHelpUtils file. Does not implement runTest framework because it tests functions this framework uses.

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

### Behavior Variables
FAILED_TEST_NB=0

### Test inclusion state before inclusion
if [ ! -z ${CMDHELPUTILS_SH} ]; then 
    echo "CMDHELPUTILS_SH already has value ${CMDHELPUTILS_SH}"
    ((FAILED_TEST_NB++))
    echo -e "\033[1;31mTest KO\033[0m"
    exit ${FAILED_TEST_NB}
fi

### Include printUtils.sh
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../cmdHelpUtils.sh"

if [ ! "${CMDHELPUTILS_SH}" = "CMDHELPUTILS_SH" ]; then 
    echo "Loading of cmdHelpUtils.sh failed"
    ((FAILED_TEST_NB++))
    echo -e "\033[1;31mTest KO\033[0m"
    exit ${FAILED_TEST_NB}
fi

### Test Functions
##!
# @brief Test that the text written to a file is not the one 
# @param 1 : Result File name
# @param 2 : Expected Result file name
# @return 0 if text has expected value, 1 otherwise
#
# Also increments FAILED_TEST_NB to ligthen test "main" structure
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
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1    
    fi
}

### Test PrintUsage with arguments
PrintUsage "dummyCmd" "<options>" "[arg1]" "[arg2]" "[arg3]" > toto
printf "Usage \n" > ref
printf " ./dummyCmd <options> [arg1] [arg2] [arg3]\n" >> ref
TestWrittenText toto ref 

### Test PrintUsage without arguments
PrintUsage "simpleCmd" > toto
printf "Usage \n" > ref
printf " ./simpleCmd \n" >> ref
TestWrittenText toto ref 

### Test PrintDescription
PrintDescription "Description of a command" > toto
printf "Description of a command\n" > ref
TestWrittenText toto ref 

### Test PrintOptionCategory
PrintOptionCategory "A category of options" > toto
printf "%s\n" "----- A category of options -----" > ref
TestWrittenText toto ref 

### Test IsLongOption
IsLongOption "--longOpt"
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "--longOpt is a valid long option"
fi

IsLongOption "-shortOpt"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-shortOpt is not a valid long option"
fi

IsLongOption "--a"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "--a is not a valid long option"
fi

IsLongOption "--"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-- is not a valid long option"
fi

IsLongOption "--,z"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "--,z is not a valid long option"
fi

IsLongOption "foo--bar"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "foo--bar is not a valid long option"
fi

IsLongOption ""
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "empty string is not a valid long option"
fi

IsLongOption "notAnOption"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "notAnOption is not a valid long option"
fi

### Test IsShortOption
IsShortOption "--longOpt"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "--longOpt is not a valid short option"
fi

IsShortOption "-shortOpt"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-shortOpt is not a valid short option"
fi

IsShortOption "-a"
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-a is a valid short option"
fi

IsShortOption "-6"
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-6 is a valid short option"
fi

IsShortOption "--"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-- is not a valid short option"
fi

IsShortOption "-!"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "-! is not a valid short option"
fi

IsShortOption "foo-bar"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "foo-bar is not a valid short option"
fi

IsShortOption ""
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "empty string is not a valid short option"
fi

IsShortOption "notAnOption"
if [ $? -ne 1 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "notAnOption is not a valid short option"
fi

### Test PrintOption working cases
PrintOption "-v" "--verbose" "set verbosity" > toto
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option should be displayed without error"
fi
printf "%s\t\t %s\n" "-v or --verbose" "set verbosity" > ref
TestWrittenText toto ref 

PrintOption "-h" "print help" > toto
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option should be displayed without error"
fi
printf "%s\t\t %s\n" "-h" "print help" > ref
TestWrittenText toto ref 

PrintOption "--test" "testing stuff" > toto
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option should be displayed without error"
fi
printf "%s\t\t %s\n" "--test" "testing stuff" > ref
TestWrittenText toto ref 

PrintOption "--foo" "-f" "what" "a" "bar" > toto
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option should be displayed without error"
fi
printf "%s\t\t %s\n" "-f or --foo" "what a bar" > ref
TestWrittenText toto ref 

PrintOption "--long" "-s" "--fail" "after arg 3 : not viewed as an option" > toto
if [ $? -ne 0 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option shoudl be ignored at argument 3"
fi
printf "%s\t\t %s\n" "-s or --long" "--fail after arg 3 : not viewed as an option" > ref
TestWrittenText toto ref 

### Test PrintOption error cases
echo "" > toto
PrintOption "no option" "present" > toto
if [ $? -ne 255 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option absence should be detected"
fi
printf "" > ref
TestWrittenText toto ref 

PrintOption "the option" "comes" "--after" > toto
if [ $? -ne 255 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option absence should be detected"
fi
printf "" > ref
TestWrittenText toto ref 

PrintOption "-v" "-w" "twice a short option" > toto
if [ $? -ne 254 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option duplication should be detected"
fi
printf "" > ref
TestWrittenText toto ref 

PrintOption "--long" "--verylong" "twice a long option" > toto
if [ $? -ne 254 ]; then
    ((FAILED_TEST_NB++)) ## New invalid test
    echo "Option duplication should be detected"
fi
printf "" > ref
TestWrittenText toto ref 


### Clean up
rm toto
rm ref

### Test result
if [ ${FAILED_TEST_NB} -eq 0 ]; then
    echo -e "\033[1;32mTest OK\033[0m"
else
    echo -e "\033[1;31mTest KO\033[0m"
fi
 
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
