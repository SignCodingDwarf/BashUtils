#!/bin/bash

###
# @file testFunctions.sh
# @author SignC0dingDw@rf
# @version 1.3
# @date 14 May 2020
# @brief A set of additional test functions used to mutualize commonly performed tests.
###

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
if [ -z ${TOOLS_TESTFUNCTIONS_SH} ]; then

# Definition of inclusion also contains the current library version
TOOLS_TESTFUNCTIONS_SH="1.3" # Reset using TOOLS_TESTFUNCTIONS_SH=""

# Inclusion of dependencies
SCRIPT_LOCATION_TOOLS_TESTFUNCTIONS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_TOOLS_TESTFUNCTIONS_SH}/testUtils.sh"
. "${SCRIPT_LOCATION_TOOLS_TESTFUNCTIONS_SH}/../../Testing/files.sh"

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

##!
# @brief Check that file content is the one expected
# @param 1 : Result File name
# @param 2 : Expected Result file name
# @return 0 if text has expected value, exit 1 otherwise
#
##
TestWrittenText()
{
    local resultFileName="$1"
    local expectedResultFileName="$2"

    local resultContent=$(cat ${resultFileName})
    local expectedContent=$(cat ${expectedResultFileName})
    
    # Test identity
    areFilesIdentical ${resultFileName} ${expectedResultFileName}
    local are_identical=$?
    endTestIfAssertFails "\"${are_identical}\" -eq \"0\"" "Wrong file content. Expected\n${resultContent}\nGot\n${expectedContent}"
    
    return 0
}

##!
# @brief Check if an array has expected content
# @param 1 : Name of the array to check
# @param 2 : Name of the expected array
# @return 0 if array has expected content, exit 1 otherwise
#
## 
CheckArrayContent()
{
    local arrayName="$1"
    local expectedName="$2"
    local -n arrayContent=${arrayName}
    local -n expectedArray=${expectedName}

    local differences=(`echo ${expectedArray[@]} ${arrayContent[@]} | tr ' ' '\n' | sort | uniq -u`) # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash

    # Compute result
    if [ ${#differences[@]} -eq 0 ]; then
        return 0
    else
        printf "Expecting to get the content : "
        printf "%s " "${expectedArray[*]}"
        printf "\n\n"
        printf "But array ${arrayName} has content : "
        printf "%s " "${arrayContent[*]}"
        printf "\n\n"
        printf "Difference : "
        printf "%s " "${differences[*]}"
        printf "\n"
        exit 1
    fi
}

##!
# @brief Check that directory content corresponds to expected elements according to filter
# @param 1 : Folder
# @param 2 : Filter of folder lists
# @param 3-@ : Expected elements array
# @return 0 if content is correct, exit 1 otherwise
#
##
CheckDirContent()
{
    local content=$(ls $1 | grep $2)
    local expectedArray=("${@:3}")

    # Compute differences as an array
    local differences=(`echo ${expectedArray[@]} ${content[@]} | tr ' ' '\n' | sort | uniq -u`) # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash

    # Compute result
    if [ ${#differences[@]} -eq 0 ]; then
        return 0
    else
        printf "Expecting to get the content : "
        printf "%s " "${expectedArray[*]}"
        printf "\n\n"
        printf "But folder ${1} has content : "
        printf "%s " "${content[*]}"
        printf "\n\n"
        printf "Difference : "
        printf "%s " "${differences[*]}"
        printf "\n"
        exit 1
    fi
}

##!
# @brief Check the size of an array
# @param 1 : Name of the array to check
# @param 2 : Expected Size
# @return 0 if array has expected size, exit 1 otherwise
#
## 
CheckArraySize()
{
    local arrayName="$1"
    local expectedSize="$2"
    local arrayContent=()
    eval arrayContent=\( \${${arrayName}[@]} \)

    endTestIfAssertFails " \"${#arrayContent[@]}\" -eq \"${expectedSize}\" " "Array ${arrayName} is expected to have size ${expectedSize} but has size ${#arrayContent[@]}"
    return 0
}

fi # TOOLS_TESTFUNCTIONS_SH

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
