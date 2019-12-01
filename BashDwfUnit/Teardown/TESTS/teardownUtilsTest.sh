#!/bin/bash

# @file teardownUtilsTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 02 December 2019
# @brief Unit testing of teardownUtils.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
# @brief Check if an array has expected content
# @param 1 : Name of the array to check
# @param 2 : Name of the expected array
# @return 0 if array has expected content, 1 otherwise
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
        return 1
    fi
}

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

##!
# @brief Check that directory content corresponds to expected elements according to filter
# @param 1 : Folder
# @param 2 : Filter of folder lists
# @param 3-@ : Expected elements array
# @return 0 if content is correct, 1 otherwise
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
        return 1
    fi
}

##!
# @brief Check that file content is the expected string
# @param 1 : File
# @param 2 : Expected text
# @return 0 if content is correct, 1 otherwise
#
##
CheckFileContent()
{
    local content=$(cat $1)
    local expected="$2"

    if [ "${content}" = "${expected}" ]; then
        return 0
    else
        echo "Wrong file content"
        echo ""
        echo "Got test : ${content}"
        echo "But expected : ${expected}"
        return 1
    fi
}

##!
# @brief Clean up test environment
# @return 0 if clean up is OK, 1 otherwise
#
## 
CleanUpEnv()
{
    # Delete test folders
    rm -rf /tmp/toto*
    rm -rf /tmp/tutu*
    rm -rf /tmp/fileRes
    rm -f /tmp/barError*

    # Restore variables
    ENV_T1=""
    ENV_T2=""
    ENV_T3=""
    ENV_T4=""
    ENV_T5=""
    ENV_T6=""    
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check initial directories content
# @return 0 if setup is OK, 1 otherwise
#
## 
CheckInitialDirectories()
{
    local totoList=()
    for ((i=1;i<=10;i++)); do
        totoList+=("toto${i}")
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}
    local result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}
    local result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local tutuList=()
    for ((i=1;i<=5;i++)); do
        tutuList+=("tutu${i}")
        tutuList+=("tutu${i}.utmv")
    done    
    CheckDirContent /tmp "tutu*" ${tutuList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local fileResList=("phi1.txt" "phi1.txt.utmv" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi4.txt.utmv" "phi5.txt" "phi6.txt" "phi6.txt.utmv" "phi7.txt" "phi7.txt.utmv")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}
}

##!
# @brief Check initial files content
# @return 0 if setup is OK, 1 otherwise
#
## 
CheckInitialFiles()
{
    CheckFileContent "/tmp/tutu1/testA" "First Test Sentence"    
    local result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1/testB" "Second Test Sentence"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1/testC" "Last Test Sentence" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu3/testG" "Creating a Test" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu3/testH" "Running a Test" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu3/testI" "Stopping a Test" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4/testJ" "Test J" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4/testK" "Another file" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu5/testL" "The Last File" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1.utmv/testAA" "First Work of Art" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1.utmv/testBA" "Yet another string" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1.utmv/testCA" "Oya Manda !!" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2.utmv/testD" "Here I am" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2.utmv/testE" "Here you are" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2.utmv/testF" "Here we go" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testW" "The" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testX" "Last" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testY" "Alphabet" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testZ" "Letters" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi1.txt" "The world is mine"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi2.txt" "Escaping reality plan"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi3.txt" "Loading real virtuality"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi4.txt" "Summoning Chupacabra"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi6.txt" "Eating worms"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi7.txt" "Running applicative disturbance"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi1.txt.utmv" "I am a Wookie"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi2.txt.utmv" "Nothing can be done"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi3.txt.utmv" "I am virtually real"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi4.txt.utmv" "Some say ..."
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi6.txt.utmv" "... Nothing"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi7.txt.utmv" "Returning to abnormality"
}

##!
# @brief Check files content after RestoreElementsNominalInput test
# @return 0 if setup is OK, 1 otherwise
#
## 
CheckNominalInputFiles()
{
    CheckFileContent "/tmp/tutu1/testAA" "First Work of Art" 
    local result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1/testBA" "Yet another string" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1/testCA" "Oya Manda !!" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4/testJ" "Test J" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4/testK" "Another file" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu5/testL" "The Last File" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2.utmv/testD" "Here I am" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2.utmv/testE" "Here you are" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2.utmv/testF" "Here we go" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testW" "The" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testX" "Last" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testY" "Alphabet" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu4.utmv/testZ" "Letters" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi1.txt" "I am a Wookie"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi2.txt" "Escaping reality plan"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi3.txt" "Loading real virtuality"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi4.txt" "Some say ..."
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi6.txt" "... Nothing"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi7.txt" "Running applicative disturbance"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi2.txt.utmv" "Nothing can be done"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi3.txt.utmv" "I am virtually real"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi7.txt.utmv" "Returning to abnormality"
}

##!
# @brief Check files content after RestoreElementsNotExisting test
# @return 0 if setup is OK, 1 otherwise
#
## 
CheckErrorInputFiles()
{
    CheckFileContent "/tmp/tutu1/testAA" "First Work of Art" 
    local result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1/testBA" "Yet another string" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu1/testCA" "Oya Manda !!" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2/testD" "Here I am" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2/testE" "Here you are" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/tutu2/testF" "Here we go" 
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi1.txt" "I am a Wookie"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi2.txt" "Nothing can be done"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi3.txt" "I am virtually real"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi4.txt" "Some say ..."
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi6.txt" "... Nothing"
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckFileContent "/tmp/fileRes/phi7.txt" "Returning to abnormality"
}


##!
# @brief Check if setup worked as expected
# @return 0 if setup is OK, 1 otherwise
#
## 
CheckInitialState()
{
    CheckInitialDirectories
    local result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    CheckInitialFiles
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValA" "ValB" "ValC" "ValD" "ValE" "ValF")
    CheckArrayContent "envVarsContent" "envVarsExpected"
}

##!
# @brief Check if script is not included
# @return 0 if script is not included, 1 otherwise
#
## 
scriptNotIncluded()
{
    if [ ! -z ${TEARDOWNUTILS_SH} ]; then 
        echo "TEARDOWNUTILS_SH already has value ${TEARDOWNUTILS_SH}"
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
    . "${SCRIPT_LOCATION}/../teardownUtils.sh"

    if [ ! "${TEARDOWNUTILS_SH}" = "1.0" ]; then 
        echo "Loading of teardownUtils.sh failed. Content is ${TEARDOWNUTILS_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Check DeleteElements behavior if empty input is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DeleteElementsNoInput()
{
    DeleteElements 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function DeleteElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local totoList=()
    for ((i=1;i<=10;i++)); do
        totoList+=("toto${i}")
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeleteElements behavior if nominal input is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DeleteElementsNominalInput()
{
    ## Only Directories
    DeleteElements "/tmp/toto3" "/tmp/toto7" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function DeleteElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local totoList=()
    for ((i=1;i<=10;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    ## Only Files
    local dummyToDelete=("/tmp/toto8/dummy6" "/tmp/toto8/dummy20" "/tmp/toto8/dummy10" "/tmp/toto8/dummy1")
    DeleteElements "${dummyToDelete[@]}"  2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function DeleteElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    totoList=()
    for ((i=1;i<=10;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}
    local result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    dummyList=()
    for ((i=2;i<=19;i++)); do
        if [ "${i}" -eq "6" -o "${i}" -eq "10" ]; then
            : # Do nothing
        else
            dummyList+=("dummy${i}")
        fi
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    ## Combined
    local deleteList=("/tmp/toto8/dummy14" "/tmp/toto5" "/tmp/toto8/dummy15" "/tmp/toto4" "/tmp/toto10" "/tmp/toto8/dummy2")
    DeleteElements "${deleteList[@]}"  2> /tmp/barErrorOutput
    result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function DeleteElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    totoList=()
    for ((i=1;i<=9;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" -o "${i}" -eq "5" -o "${i}" -eq "4"  ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    dummyList=()
    for ((i=3;i<=19;i++)); do
        if [ "${i}" -eq "6" -o "${i}" -eq "10" -o "${i}" -eq "14" -o "${i}" -eq "15" ]; then
            : # Do nothing
        else
            dummyList+=("dummy${i}")
        fi
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
}

##!
# @brief Check DeleteElements behavior if provided elements do not exist
# @return 0 if behavior is as expected, 1 otherwise
#
## 
DeleteElementsNotExisting()
{
    DeleteElements "/tmp/toto11" "/tmp/toto8/dummy42" "/tmp/NothingToSeeInHere" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function DeleteElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local totoList=()
    for ((i=1;i<=9;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" -o "${i}" -eq "5" -o "${i}" -eq "4"  ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local dummyList=()
    for ((i=3;i<=19;i++)); do
        if [ "${i}" -eq "6" -o "${i}" -eq "10" -o "${i}" -eq "14" -o "${i}" -eq "15" ]; then
            : # Do nothing
        else
            dummyList+=("dummy${i}")
        fi
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreElements behavior if empty input is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
RestoreElementsNoInput()
{
    RestoreElements 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RestoreElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local tutuList=()
    for ((i=1;i<=5;i++)); do
        tutuList+=("tutu${i}")
        tutuList+=("tutu${i}.utmv")
    done    
    CheckDirContent /tmp "tutu*" ${tutuList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local fileResList=("phi1.txt" "phi1.txt.utmv" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi4.txt.utmv" "phi5.txt" "phi6.txt" "phi6.txt.utmv" "phi7.txt" "phi7.txt.utmv")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckInitialFiles
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreElements behavior if nominal input is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
RestoreElementsNominalInput()
{
    RestoreElements "/tmp/fileRes/phi6.txt" "/tmp/tutu1" "/tmp/fileRes/phi1.txt" "/tmp/fileRes/phi4.txt" "/tmp/tutu3" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RestoreElements to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local tutuList=("tutu1" "tutu2" "tutu2.utmv" "tutu3" "tutu4" "tutu4.utmv" "tutu5" "tutu5.utmv")
    CheckDirContent /tmp "tutu*" ${tutuList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local fileResList=("phi1.txt" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi5.txt" "phi6.txt" "phi7.txt" "phi7.txt.utmv")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckNominalInputFiles
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreElements behavior if some divertion are not existing
# @return 0 if behavior is as expected, 1 otherwise
#
## 
RestoreElementsNotExisting()
{
    rm -r /tmp/tutu4.utmv # We delete a folder divertion to create an error
    local elementsToRestore=("/tmp/fileRes/phi2.txt" "/tmp/fileRes/phi3.txt" "/tmp/tutu2" "/tmp/fileRes/phi5.txt" "/tmp/fileRes/phi7.txt" "/tmp/tutu4" "/tmp/tutu5")
    RestoreElements "${elementsToRestore[@]}"  2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "2" ]; then
        printf "Expected function RestoreElements to exit with code 2 but exited with code ${result}\n"
        return 1
    fi
    local tutuList=("tutu1" "tutu2" "tutu3" "tutu5" )
    CheckDirContent /tmp "tutu*" ${tutuList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    local fileResList=("phi1.txt" "phi2.txt" "phi3.txt" "phi4.txt" "phi6.txt" "phi7.txt")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    CheckErrorInputFiles
    result=$?
    if [ "${result}" -ne "0" ]; then

        return 1
    fi
    printf "mv: cannot stat '/tmp/fileRes/phi5.txt.utmv': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/fileRes/phi5.txt with /tmp/fileRes/phi5.txt.utmv\n" >> /tmp/barErrorRef
    printf "mv: cannot stat '/tmp/tutu4.utmv': No such file or directory\n" >> /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/tutu4 with /tmp/tutu4.utmv\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreEnvVars behavior if empty input is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
RestoreEnvVarsNoInput()
{
    RestoreEnvVars 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RestoreEnvVars to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValA" "ValB" "ValC" "ValD" "ValE" "ValF")
    CheckArrayContent "envVarsContent" "envVarsExpected"
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreEnvVars behavior if working input is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
RestoreEnvVarsNominalInput()
{
    VARS_RES=("ENV_T1" "ValZ" "ENV_T3" "ValX")
    RestoreEnvVars "${VARS_RES[@]}" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "0" ]; then
        printf "Expected function RestoreEnvVars to exit with code 0 but exited with code ${result}\n"
        return 1
    fi
    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValZ" "ValB" "ValX" "ValD" "ValE" "ValF")
    CheckArrayContent "envVarsContent" "envVarsExpected"
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreEnvVars behavior if a variable with no value is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
RestoreEnvVarsWithError()
{
    VARS_RES=("ENV_T2" "ValY" "ENV_T6" "ValU" "ENV_T5" "ValV" "ENV_T4") # No value for T4 => error
    RestoreEnvVars "${VARS_RES[@]}" 2> /tmp/barErrorOutput
    local result=$?
    if [ "${result}" -ne "1" ]; then
        printf "Expected function RestoreEnvVars to exit with code 1 but exited with code ${result}\n"
        return 1
    fi
    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValZ" "ValY" "ValX" "ValD" "ValV" "ValU")
    CheckArrayContent "envVarsContent" "envVarsExpected"
    result=$?
    if [ "${result}" -ne "0" ]; then
        return 1
    fi
    printf "[Error] : Value ENV_T4 has no associated value to restore. Ignoring it.\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### SetUp
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

echo "First Test Sentence" > /tmp/tutu1/testA
echo "Second Test Sentence" > /tmp/tutu1/testB
echo "Last Test Sentence" > /tmp/tutu1/testC
echo "Creating a Test" > /tmp/tutu3/testG
echo "Running a Test" > /tmp/tutu3/testH
echo "Stopping a Test" > /tmp/tutu3/testI
echo "Test J" > /tmp/tutu4/testJ
echo "Another file" > /tmp/tutu4/testK
echo "The Last File" > /tmp/tutu5/testL

echo "First Work of Art" > /tmp/tutu1.utmv/testAA
echo "Yet another string" > /tmp/tutu1.utmv/testBA
echo "Oya Manda !!" > /tmp/tutu1.utmv/testCA
echo "Here I am" > /tmp/tutu2.utmv/testD
echo "Here you are" > /tmp/tutu2.utmv/testE
echo "Here we go" > /tmp/tutu2.utmv/testF
echo "The" > /tmp/tutu4.utmv/testW
echo "Last" > /tmp/tutu4.utmv/testX
echo "Alphabet" > /tmp/tutu4.utmv/testY
echo "Letters" > /tmp/tutu4.utmv/testZ

### Divert Files for the test
mkdir /tmp/fileRes
mkdir /tmp/fileRes/phi5.txt # A folder for error detection
echo "The world is mine" > /tmp/fileRes/phi1.txt
echo "Escaping reality plan" > /tmp/fileRes/phi2.txt
echo "Loading real virtuality" > /tmp/fileRes/phi3.txt
echo "Summoning Chupacabra" > /tmp/fileRes/phi4.txt
echo "Eating worms" > /tmp/fileRes/phi6.txt
echo "Running applicative disturbance" > /tmp/fileRes/phi7.txt
echo "I am a Wookie" > /tmp/fileRes/phi1.txt.utmv
echo "Nothing can be done" > /tmp/fileRes/phi2.txt.utmv
echo "I am virtually real" > /tmp/fileRes/phi3.txt.utmv
echo "Some say ..." > /tmp/fileRes/phi4.txt.utmv
echo "... Nothing" > /tmp/fileRes/phi6.txt.utmv
echo "Returning to abnormality" > /tmp/fileRes/phi7.txt.utmv

### Create Environment variables for the test
ENV_T1="ValA"
ENV_T2="ValB"
ENV_T3="ValC"
ENV_T4="ValD"
ENV_T5="ValE"
ENV_T6="ValF"

# Test initial state
doTest "Initial State" CheckInitialState
if [ "${FAILED_TEST_NB}" -ne "0" ]; then
    printf "Invalid environment. Exiting test\n"
    CleanUpEnv  
    displaySuiteResults
    exit ${FAILED_TEST_NB}  
fi

### Do Tests
#Inclusion
doTest "teardownUtils.sh not included" scriptNotIncluded
doTest "teardownUtils.sh included" scriptIncluded

#DeleteElements
doTest "DeleteElements with no input" DeleteElementsNoInput
doTest "DeleteElements with nominal input" DeleteElementsNominalInput
doTest "DeleteElements which do not exist" DeleteElementsNotExisting
#doTest "RestoreEnvVars with error" RestoreEnvVarsWithError

#RestoreElements
doTest "RestoreElements with no input" RestoreElementsNoInput
doTest "RestoreElements with nominal input" RestoreElementsNominalInput
doTest "RestoreElements which do not exist" RestoreElementsNotExisting

#RestoreEnvVars
doTest "RestoreEnvVars with no input" RestoreEnvVarsNoInput
doTest "RestoreEnvVars with nominal input" RestoreEnvVarsNominalInput
doTest "RestoreEnvVars with error" RestoreEnvVarsWithError

### Clean Up
CleanUpEnv

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
