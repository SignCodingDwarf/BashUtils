#!/bin/bash

# @file utilsTest.sh
# @author SignC0dingDw@rf
# @version 1.4
# @date 29 November 2020
# @brief Unit testing of utils.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
. "${SCRIPT_LOCATION}/../../../Tools/testFunctions.sh"

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

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    # Delete test folders
    rm -rf /tmp/toto*
    rm -rf /tmp/tutu*
    rm -rf /tmp/fileRes
    rm -f /tmp/bar*

    # Restore variables
    ENV_T1=""
    ENV_T2=""
    ENV_T3=""
    ENV_T4=""
    ENV_T5=""
    ENV_T6=""    
    return 0
}

################################################################################
###                                                                          ###
###                            Helper functions                              ###
###                                                                          ###
################################################################################
##!
# @brief Check initial directories content
# @return 0 if setup is OK, exit 1 otherwise
#
## 
CheckInitialDirectories()
{
    ### toto
    local totoList=()
    for ((i=1;i<=10;i++)); do
        totoList+=("toto${i}")
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}

    ### dummy in toto8
    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}

    ### tutu
    local tutuList=()
    for ((i=1;i<=5;i++)); do
        tutuList+=("tutu${i}")
        tutuList+=("tutu${i}.utmv")
    done    
    CheckDirContent /tmp "tutu*" ${tutuList[@]}

    ### phi in fileRes
    local fileResList=("phi1.txt" "phi1.txt.utmv" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi4.txt.utmv" "phi5.txt" "phi6.txt" "phi6.txt.utmv" "phi7.txt" "phi7.txt.utmv")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}
}

##!
# @brief Check initial files content
# @return 0 if setup is OK, exit 1 otherwise
#
## 
CheckInitialFiles()
{
    printf "First Test Sentence\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testA" "/tmp/barRef"    

    printf "Second Test Sentence\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testB" "/tmp/barRef" 

    printf "Last Test Sentence\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testC" "/tmp/barRef" 

    printf "Creating a Test\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu3/testG" "/tmp/barRef" 

    printf "Running a Test\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu3/testH" "/tmp/barRef" 

    printf "Stopping a Test\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu3/testI" "/tmp/barRef" 

    printf "Test J\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4/testJ" "/tmp/barRef" 

    printf "Another file\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4/testK" "/tmp/barRef" 

    printf "The Last File\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu5/testL" "/tmp/barRef" 

    printf "First Work of Art\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1.utmv/testAA" "/tmp/barRef" 

    printf "Yet another string\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1.utmv/testBA" "/tmp/barRef" 

    printf "Oya Manda !!\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1.utmv/testCA" "/tmp/barRef" 

    printf "Here I am\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2.utmv/testD" "/tmp/barRef" 

    printf "Here you are\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2.utmv/testE" "/tmp/barRef" 

    printf "Here we go\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2.utmv/testF" "/tmp/barRef" 

    printf "The\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testW" "/tmp/barRef" 

    printf "Last\n" > /tmp/barRef 
    TestWrittenText "/tmp/tutu4.utmv/testX" "/tmp/barRef" 

    printf "Alphabet\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testY" "/tmp/barRef" 

    printf "Letters\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testZ" "/tmp/barRef" 

    printf "The world is mine\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi1.txt" "/tmp/barRef"

    printf "Escaping reality plan\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi2.txt" "/tmp/barRef"

    printf "Loading real virtuality\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi3.txt" "/tmp/barRef"

    printf "Summoning Chupacabra\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi4.txt" "/tmp/barRef"

    printf "Eating worms\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi6.txt" "/tmp/barRef"

    printf "Running applicative disturbance\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi7.txt" "/tmp/barRef"

    printf "I am a Wookie\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi1.txt.utmv" "/tmp/barRef"

    printf "Nothing can be done\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi2.txt.utmv" "/tmp/barRef"

    printf "I am virtually real\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi3.txt.utmv" "/tmp/barRef"

    printf "Some say ...\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi4.txt.utmv" "/tmp/barRef"
    
    printf "... Nothing\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi6.txt.utmv" "/tmp/barRef"

    printf "Returning to abnormality\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi7.txt.utmv" "/tmp/barRef"
}

##!
# @brief Check files content after RestoreElementsNominalInput test
# @return 0 if setup is OK, exit 1 otherwise
#
## 
CheckNominalInputFiles()
{
    printf "First Work of Art\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testAA" "/tmp/barRef" 

    printf "Yet another string\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testBA" "/tmp/barRef" 

    printf "Oya Manda !!\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testCA" "/tmp/barRef" 

    printf "Test J\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4/testJ" "/tmp/barRef" 

    printf "Another file\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4/testK" "/tmp/barRef" 

    printf "The Last File\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu5/testL" "/tmp/barRef" 

    printf "Here I am\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2.utmv/testD" "/tmp/barRef" 

    printf "Here you are\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2.utmv/testE" "/tmp/barRef" 

    printf "Here we go\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2.utmv/testF" "/tmp/barRef" 

    printf "The\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testW" "/tmp/barRef" 

    printf "Last\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testX" "/tmp/barRef" 

    printf "Alphabet\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testY" "/tmp/barRef" 

    printf "Letters\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu4.utmv/testZ" "/tmp/barRef" 

    printf "I am a Wookie\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi1.txt" "/tmp/barRef"

    printf "Escaping reality plan\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi2.txt" "/tmp/barRef"

    printf "Loading real virtuality\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi3.txt" "/tmp/barRef"

    printf "Some say ...\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi4.txt" "/tmp/barRef"

    printf "... Nothing\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi6.txt" "/tmp/barRef"

    printf "Running applicative disturbance\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi7.txt" "/tmp/barRef"

    printf "Nothing can be done\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi2.txt.utmv" "/tmp/barRef"

    printf "I am virtually real\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi3.txt.utmv" "/tmp/barRef"

    printf "Returning to abnormality\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi7.txt.utmv" "/tmp/barRef"
}

##!
# @brief Check files content after RestoreElementsNotExisting test
# @return 0 if setup is OK, exit 1 otherwise
#
## 
CheckErrorInputFiles()
{
    printf "First Test Sentence\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testA" "/tmp/barRef"    

    printf "Second Test Sentence\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testB" "/tmp/barRef" 

    printf "Last Test Sentence\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1/testC" "/tmp/barRef" 

    printf "Here I am\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2/testD" "/tmp/barRef" 

    printf "Here you are\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2/testE" "/tmp/barRef" 

    printf "Here we go\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu2/testF" "/tmp/barRef"  

    printf "Creating a Test\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu3/testG" "/tmp/barRef" 

    printf "Running a Test\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu3/testH" "/tmp/barRef" 

    printf "Stopping a Test\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu3/testI" "/tmp/barRef" 

    printf "First Work of Art\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1.utmv/testAA" "/tmp/barRef" 

    printf "Yet another string\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1.utmv/testBA" "/tmp/barRef" 

    printf "Oya Manda !!\n" > /tmp/barRef
    TestWrittenText "/tmp/tutu1.utmv/testCA" "/tmp/barRef" 

    printf "The world is mine\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi1.txt" "/tmp/barRef"

    printf "Nothing can be done\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi2.txt" "/tmp/barRef"

    printf "I am virtually real\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi3.txt" "/tmp/barRef"

    printf "Summoning Chupacabra\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi4.txt" "/tmp/barRef"

    printf "Eating worms\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi6.txt" "/tmp/barRef"

    printf "Returning to abnormality\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi7.txt" "/tmp/barRef"

    printf "I am a Wookie\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi1.txt.utmv" "/tmp/barRef"

    printf "Some say ...\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi4.txt.utmv" "/tmp/barRef"
    
    printf "... Nothing\n" > /tmp/barRef
    TestWrittenText "/tmp/fileRes/phi6.txt.utmv" "/tmp/barRef"
}


##!
# @brief Check if setup worked as expected
# @return 0 if setup is OK, exit 1 otherwise
#
## 
CheckInitialState()
{
    CheckInitialDirectories
    CheckInitialFiles
    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValA" "ValB" "ValC" "ValD" "ValE" "ValF")
    CheckArrayContent "envVarsContent" "envVarsExpected"
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check DeleteElements behavior if empty input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DeleteElementsNoInput()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    DeleteElements 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local totoList=()
    for ((i=1;i<=10;i++)); do
        totoList+=("toto${i}")
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}

    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeleteElements behavior if nominal input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DeleteElementsNominalInput()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    ## Only Directories
    DeleteElements "/tmp/toto3" "/tmp/toto7" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local totoList=()
    for ((i=1;i<=10;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}

    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ## Only Files
    local dummyToDelete=("/tmp/toto8/dummy6" "/tmp/toto8/dummy20" "/tmp/toto8/dummy10" "/tmp/toto8/dummy1")
    DeleteElements "${dummyToDelete[@]}"  2> /tmp/barErrorOutput
    test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    totoList=()
    for ((i=1;i<=10;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}

    dummyList=()
    for ((i=2;i<=19;i++)); do
        if [ "${i}" -eq "6" -o "${i}" -eq "10" ]; then
            : # Do nothing
        else
            dummyList+=("dummy${i}")
        fi
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ## Combined
    local deleteList=("/tmp/toto8/dummy14" "/tmp/toto5" "/tmp/toto8/dummy15" "/tmp/toto4" "/tmp/toto10" "/tmp/toto8/dummy2")
    DeleteElements "${deleteList[@]}"  2> /tmp/barErrorOutput
    test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    totoList=()
    for ((i=1;i<=9;i++)); do
        if [ "${i}" -eq "3" -o "${i}" -eq "7" -o "${i}" -eq "5" -o "${i}" -eq "4"  ]; then
            : # Do nothing
        else
            totoList+=("toto${i}")
        fi
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}

    dummyList=()
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
# @brief Check DeleteElements behavior if provided elements do not exist
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
DeleteElementsNotExisting()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    DeleteElements "/tmp/toto11" "/tmp/toto8/dummy42" "/tmp/NothingToSeeInHere" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local totoList=()
    for ((i=1;i<=10;i++)); do
        totoList+=("toto${i}")
    done    
    CheckDirContent /tmp "toto*" ${totoList[@]}

    local dummyList=()
    for ((i=1;i<=20;i++)); do
        dummyList+=("dummy${i}")
    done    
    CheckDirContent /tmp/toto8 "dummy*" ${dummyList[@]}

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreElements behavior if empty input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RestoreElementsNoInput()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    RestoreElements 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local tutuList=()
    for ((i=1;i<=5;i++)); do
        tutuList+=("tutu${i}")
        tutuList+=("tutu${i}.utmv")
    done    
    CheckDirContent /tmp "tutu*" ${tutuList[@]}

    local fileResList=("phi1.txt" "phi1.txt.utmv" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi4.txt.utmv" "phi5.txt" "phi6.txt" "phi6.txt.utmv" "phi7.txt" "phi7.txt.utmv")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}

    CheckInitialFiles

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreElements behavior if nominal input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RestoreElementsNominalInput()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    RestoreElements "/tmp/fileRes/phi6.txt" "/tmp/tutu1" "/tmp/fileRes/phi1.txt" "/tmp/fileRes/phi4.txt" "/tmp/tutu3" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local tutuList=("tutu1" "tutu2" "tutu2.utmv" "tutu3" "tutu4" "tutu4.utmv" "tutu5" "tutu5.utmv")
    CheckDirContent /tmp "tutu*" ${tutuList[@]}

    local fileResList=("phi1.txt" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi5.txt" "phi6.txt" "phi7.txt" "phi7.txt.utmv")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}

    CheckNominalInputFiles

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreElements behavior if some divertion are not existing
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RestoreElementsNotExisting()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    rm -r /tmp/tutu4.utmv # We delete a folder divertion to create an error
    local elementsToRestore=("/tmp/fileRes/phi2.txt" "/tmp/fileRes/phi3.txt" "/tmp/tutu2" "/tmp/fileRes/phi5.txt" "/tmp/fileRes/phi7.txt" "/tmp/tutu4" "/tmp/tutu5")
    RestoreElements "${elementsToRestore[@]}"  2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local tutuList=("tutu1" "tutu1.utmv" "tutu2" "tutu3" "tutu3.utmv" "tutu5" )
    CheckDirContent /tmp "tutu*" ${tutuList[@]}

    local fileResList=("phi1.txt" "phi1.txt.utmv" "phi2.txt" "phi3.txt" "phi4.txt" "phi4.txt.utmv" "phi6.txt" "phi6.txt.utmv" "phi7.txt")
    CheckDirContent /tmp/fileRes "phi*" ${fileResList[@]}

    CheckErrorInputFiles

    printf "mv: cannot stat '/tmp/fileRes/phi5.txt.utmv': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/fileRes/phi5.txt with /tmp/fileRes/phi5.txt.utmv\n" >> /tmp/barErrorRef
    printf "mv: cannot stat '/tmp/tutu4.utmv': No such file or directory\n" >> /tmp/barErrorRef
    printf "[Error] : Failed to restore /tmp/tutu4 with /tmp/tutu4.utmv\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreEnvVars behavior if empty input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RestoreEnvVarsNoInput()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    RestoreEnvVars 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValA" "ValB" "ValC" "ValD" "ValE" "ValF")
    CheckArrayContent "envVarsContent" "envVarsExpected"

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreEnvVars behavior if working input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RestoreEnvVarsNominalInput()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    VARS_RES=("ENV_T1" "ValZ" "ENV_T4" "" "ENV_T3" "ValX")
    RestoreEnvVars "${VARS_RES[@]}" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValZ" "ValB" "ValX" "" "ValE" "ValF")
    CheckArrayContent "envVarsContent" "envVarsExpected"

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check RestoreEnvVars behavior if a variable with no value is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
RestoreEnvVarsWithError()
{
    ### Initial folder state
    CheckInitialState

    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../utils.sh" "1.1"

    ### Test command
    VARS_RES=("ENV_T2" "ValY" "ENV_T6" "ValU" "ENV_T5" "ValV" "ENV_T4") # No value for T4 => error
    RestoreEnvVars "${VARS_RES[@]}" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local envVarsContent=("${ENV_T1}" "${ENV_T2}" "${ENV_T3}" "${ENV_T4}" "${ENV_T5}" "${ENV_T6}")
    local envVarsExpected=("ValA" "ValY" "ValC" "ValD" "ValV" "ValU")
    CheckArrayContent "envVarsContent" "envVarsExpected"

    printf "[Error] : Value ENV_T4 has no associated value to restore. Ignoring it.\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
#DeleteElements
doTest DeleteElementsNoInput
doTest DeleteElementsNominalInput
doTest DeleteElementsNotExisting

#RestoreElements
doTest RestoreElementsNoInput
doTest RestoreElementsNominalInput
doTest RestoreElementsNotExisting

#RestoreEnvVars
doTest RestoreEnvVarsNoInput
doTest RestoreEnvVarsNominalInput
doTest RestoreEnvVarsWithError

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
