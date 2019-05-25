#!/bin/bash

# file :  cleanTest.sh
# author : SignC0dingDw@rf
# version : 0.1
# date : 23 May 2019
# Unit testing of cleanUtils file. Does not implement runTest framework because it tests functions this framework uses.

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
if [ ! -z ${CLEANUTILS_SH} ]; then 
    echo "CLEANUTILS_SH already has value ${CLEANUTILS_SH}"
    ((FAILED_TEST_NB++))
    exit ${FAILED_TEST_NB}
fi

### Include cleanUtils.sh
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../cleanUtils.sh"
VERBOSE=true

if [ ! "${CLEANUTILS_SH}" = "CLEANUTILS_SH" ]; then 
    echo "Loading of cleanUtils.sh failed"
    ((FAILED_TEST_NB++))
    exit ${FAILED_TEST_NB}
fi

### Functions
##!
# @brief Clean test environment
# @return 0 (errors are ignored)
#
##
CleanTestEnv()
{
    # Delete test folders
    rm -rf /tmp/toto*
    rm -rf /tmp/tutu*
    rm -rf /tmp/fileRes

    # Restore variables
    ENV_T1=""
    ENV_T2=""
    ENV_T3=""
    ENV_T4=""
    ENV_T5=""
    ENV_T6=""
}

##!
# @brief Check that file content is the expected string
# @param 1 : File
# @param 2 : Expected text
# @return 0 if content is correct, 1 otherwise
#
# Also increments FAILED_TEST_NB to ligthen test functions.
#
##
CheckFileContent()
{
    local content=$(cat $1)
    local expected=$2

    if [ "${content}" = "${expected}" ]; then
        return 0
    else
        echo "Wrong file content"
        echo ""
        echo "Got test : ${content}"
        echo "But expected : ${expected}"
        ((FAILED_TEST_NB++)) ## New invalid test
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
# Also increments FAILED_TEST_NB to ligthen test functions.
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
        echo "Expecting to get the content : ${expectedArray[@]}"
        echo ""
        echo "But got content : ${content[@]}"
        echo ""
        echo "Difference : ${differences[@]}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
}

##!
# @brief Test that the expected toto folders exist
# @param 1 : Location
# @param 2 : Minimum index
# @param 3 : Maximum index
# @return 0 if list is correct, 1 otherwise
#
# Checks if the directories toto${Minimum index} to toto${Maximum index} exist in ${Location} folder
# Also increments FAILED_TEST_NB to ligthen test "main" structure.
#
##
CheckTotoList()
{
    local location=$1
    local minIndex=$2
    local maxIndex=$3

    # Construct array of expected results
    local expectedArray=()
    for ((i=${minIndex};i<=${maxIndex};i++)); do
        local index=0
        ((index=${i}-${minIndex}))
        expectedArray[${index}]="toto${i}"
    done

    # Check directory content
    CheckDirContent ${location} "toto" ${expectedArray[@]}

    # Compute result
    local result=$?
    if [ ${result} -eq 0 ]; then
        return 0
    else
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi    
}

##!
# @brief Test that the expected dummy files exist
# @param 1 : Location
# @param 2 : Minimum index
# @param 3 : Maximum index
# @return 0 if list is correct, 1 otherwise
#
# Checks if the files dummy${Minimum index} to dummy${Maximum index} exist in ${Location} folder
# Also increments FAILED_TEST_NB to ligthen test "main" structure.
#
##
CheckDummyList()
{
    local location=$1
    local minIndex=$2
    local maxIndex=$3

    # Construct array of expected results
    local expectedArray=()
    for ((i=${minIndex};i<=${maxIndex};i++)); do
        local index=0
        ((index=${i}-${minIndex}))
        expectedArray[${index}]="dummy${i}"
    done

    # Check directory content
    CheckDirContent ${location} "dummy" ${expectedArray[@]} || return 1

    return 0 
}

##!
# @brief Test that the expected folders and files for divertion folder test exist
# @return 0 if list is correct, 1 otherwise
#
##
CheckInitialTutu()
{
    # Construct array of expected folders
    local expectedArray=()
    for ((i=1;i<=5;i++)); do
        local index1=0
        local index2=0
        ((index1=(${i}-1)*2))
        ((index2=(${i}-1)*2+1))
        expectedArray[${index1}]="tutu${i}"
        expectedArray[${index2}]="tutu${i}.utmv"
    done

    # Check directory content
    CheckDirContent "/tmp" "tutu" ${expectedArray[@]} || return 1

    # Check files content
    CheckFileContent "/tmp/tutu1/testA" "First Test Sentence" || return 1
    CheckFileContent "/tmp/tutu1/testB" "Second Test Sentence" || return 1
    CheckFileContent "/tmp/tutu1/testC" "Last Test Sentence" || return 1
    CheckFileContent "/tmp/tutu3/testG" "Creating a Test" || return 1
    CheckFileContent "/tmp/tutu3/testH" "Running a Test" || return 1
    CheckFileContent "/tmp/tutu3/testI" "Stopping a Test" || return 1
    CheckFileContent "/tmp/tutu4/testJ" "Test J" || return 1
    CheckFileContent "/tmp/tutu4/testK" "Another file" || return 1
    CheckFileContent "/tmp/tutu5/testL" "The Last File" || return 1
    CheckFileContent "/tmp/tutu1.utmv/testAA" "First Work of Art" || return 1
    CheckFileContent "/tmp/tutu1.utmv/testBA" "Yet another string" || return 1
    CheckFileContent "/tmp/tutu1.utmv/testCA" "Oya Manda !!" || return 1
    CheckFileContent "/tmp/tutu2.utmv/testD" "Here I am" || return 1
    CheckFileContent "/tmp/tutu2.utmv/testE" "Here you are" || return 1
    CheckFileContent "/tmp/tutu2.utmv/testF" "Here we go" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testW" "The" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testX" "Last" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testY" "Alphabet" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testZ" "Letters" || return 1

    return 0
}

##!
# @brief Test that the expected folders and files are ok after first restauration test
# @return 0 if list is correct, 1 otherwise
#
##
CheckRestauration1Tutu()
{
    # Construct array of expected folders
    local expectedArray=("tutu1" "tutu2" "tutu2.utmv" "tutu3" "tutu4" "tutu4.utmv" "tutu5" "tutu5.utmv")

    # Check directory content
    CheckDirContent "/tmp" "tutu" ${expectedArray[@]} || return 1  

    # Check that tutu1 has been restored
    CheckDirContent "/tmp/tutu1" "test" "testAA" "testBA" "testCA" || return 1

    # Check that tutu3 has been emptied
    CheckDirContent "/tmp/tutu3" "test" "" || return 1 

    # Check files content
    CheckFileContent "/tmp/tutu4/testJ" "Test J" || return 1
    CheckFileContent "/tmp/tutu4/testK" "Another file" || return 1
    CheckFileContent "/tmp/tutu5/testL" "The Last File" || return 1
    CheckFileContent "/tmp/tutu1/testAA" "First Work of Art" || return 1
    CheckFileContent "/tmp/tutu1/testBA" "Yet another string" || return 1
    CheckFileContent "/tmp/tutu1/testCA" "Oya Manda !!" || return 1
    CheckFileContent "/tmp/tutu2.utmv/testD" "Here I am" || return 1
    CheckFileContent "/tmp/tutu2.utmv/testE" "Here you are" || return 1
    CheckFileContent "/tmp/tutu2.utmv/testF" "Here we go" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testW" "The" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testX" "Last" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testY" "Alphabet" || return 1
    CheckFileContent "/tmp/tutu4.utmv/testZ" "Letters" || return 1

    return 0
}

##!
# @brief Test that the expected folders and files are ok after second restauration test
# @return 0 if list is correct, 1 otherwise
#
##
CheckRestauration2Tutu()
{
    # Construct array of expected folders
    local expectedArray=("tutu1" "tutu2" "tutu3" "tutu5") # tutu4 is suppressed but not restored

    # Check directory content
    CheckDirContent "/tmp" "tutu" ${expectedArray[@]} || return 1

    # Check that tutu2 has been restored
    CheckDirContent "/tmp/tutu2" "test" "testD" "testE" "testF" || return 1

    # Check that tutu5 has been emptied
    CheckDirContent "/tmp/tutu5" "test" "" || return 1

    # Check files content
    CheckFileContent "/tmp/tutu1/testAA" "First Work of Art" || return 1
    CheckFileContent "/tmp/tutu1/testBA" "Yet another string" || return 1
    CheckFileContent "/tmp/tutu1/testCA" "Oya Manda !!" || return 1
    CheckFileContent "/tmp/tutu2/testD" "Here I am" || return 1
    CheckFileContent "/tmp/tutu2/testE" "Here you are" || return 1
    CheckFileContent "/tmp/tutu2/testF" "Here we go" || return 1

    return 0
}

##!
# @brief Test that the expected folders and files for divertion file test exist
# @return 0 if list is correct, 1 otherwise
#
##
CheckInitialFileRes()
{
    # Construct array of expected folders
    local expectedArray=()
    for ((i=1;i<=4;i++)); do
        local index1=0
        local index2=0
        ((index1=(${i}-1)*2))
        ((index2=(${i}-1)*2+1))
        expectedArray[${index1}]="phi${i}.txt"
        expectedArray[${index2}]="phi${i}.txt.utmv"
    done
    expectedArray=("${expectedArray[@]}" "phi5.txt" "phi6.txt" "phi6.txt.utmv" "phi7.txt" "phi7.txt.utmv")

    # Check directory content
    CheckDirContent "/tmp/fileRes" "phi" ${expectedArray[@]} || return 1

    # Check files content
    CheckFileContent "/tmp/fileRes/phi1.txt" "The world is mine" || return 1
    CheckFileContent "/tmp/fileRes/phi2.txt" "Escaping reality plan" || return 1
    CheckFileContent "/tmp/fileRes/phi3.txt" "Loading real virtuality" || return 1
    CheckFileContent "/tmp/fileRes/phi4.txt" "Summoning Chupacabra" || return 1
    CheckFileContent "/tmp/fileRes/phi6.txt" "Eating worms" || return 1
    CheckFileContent "/tmp/fileRes/phi7.txt" "Running applicative disturbance" || return 1
    CheckFileContent "/tmp/fileRes/phi1.txt.utmv" "I am a Wookie" || return 1
    CheckFileContent "/tmp/fileRes/phi2.txt.utmv" "Nothing can be done" || return 1
    CheckFileContent "/tmp/fileRes/phi3.txt.utmv" "I am virtually real" || return 1
    CheckFileContent "/tmp/fileRes/phi4.txt.utmv" "Some say ..." || return 1
    CheckFileContent "/tmp/fileRes/phi6.txt.utmv" "... Nothing" || return 1
    CheckFileContent "/tmp/fileRes/phi7.txt.utmv" "Returning to abnormality" || return 1

    return 0
}

##!
# @brief Test that the expected folders and files for divertion file test are ok after first test
# @return 0 if list is correct, 1 otherwise
#
##
CheckRestauration1FileRes()
{
    # Construct array of expected folders
    expectedArray=("phi1.txt" "phi2.txt" "phi2.txt.utmv" "phi3.txt" "phi3.txt.utmv" "phi4.txt" "phi5.txt" "phi6.txt" "phi7.txt" "phi7.txt.utmv")

    # Check directory content
    CheckDirContent "/tmp/fileRes" "phi" ${expectedArray[@]} || return 1

    # Check files content
    CheckFileContent "/tmp/fileRes/phi2.txt" "Escaping reality plan" || return 1
    CheckFileContent "/tmp/fileRes/phi3.txt" "Loading real virtuality" || return 1
    CheckFileContent "/tmp/fileRes/phi7.txt" "Running applicative disturbance" || return 1
    CheckFileContent "/tmp/fileRes/phi1.txt" "I am a Wookie" || return 1
    CheckFileContent "/tmp/fileRes/phi2.txt.utmv" "Nothing can be done" || return 1
    CheckFileContent "/tmp/fileRes/phi3.txt.utmv" "I am virtually real" || return 1
    CheckFileContent "/tmp/fileRes/phi4.txt" "Some say ..." || return 1
    CheckFileContent "/tmp/fileRes/phi6.txt" "... Nothing" || return 1
    CheckFileContent "/tmp/fileRes/phi7.txt.utmv" "Returning to abnormality" || return 1

    return 0
}

##!
# @brief Test that the expected folders and files for divertion file test are ok after second test
# @return 0 if list is correct, 1 otherwise
#
##
CheckRestauration2FileRes()
{
    # Construct array of expected folders
    expectedArray=("phi1.txt" "phi3.txt" "phi4.txt" "phi5.txt" "phi6.txt" "phi7.txt")

    # Check directory content
    CheckDirContent "/tmp/fileRes" "phi" ${expectedArray[@]} || return 1

    # Check files content
    CheckFileContent "/tmp/fileRes/phi1.txt" "I am a Wookie" || return 1 
    CheckFileContent "/tmp/fileRes/phi3.txt" "I am virtually real" || return 1
    CheckFileContent "/tmp/fileRes/phi4.txt" "Some say ..." || return 1
    CheckFileContent "/tmp/fileRes/phi6.txt" "... Nothing" || return 1
    CheckFileContent "/tmp/fileRes/phi7.txt" "Returning to abnormality" || return 1

    return 0
}

##!
# @brief Test that the environment variables are correcty restored after restauration step 1
# @return 0 if list is correct, 1 otherwise
#
# Also increments FAILED_TEST_NB to ligthen test "main" structure.
#
##
CheckRestauration1Vars()
{
    if [ ! "${ENV_T1}" = "ValZ" ]; then
        echo "Expected ENV_T1 to have value ValZ but got ${ENV_T1}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T2}" = "ValB" ]; then
        echo "Expected ENV_T2 to have value ValB but got ${ENV_T2}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T3}" = "ValX" ]; then
        echo "Expected ENV_T3 to have value ValX but got ${ENV_T3}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T4}" = "ValD" ]; then
        echo "Expected ENV_T4 to have value ValD but got ${ENV_T4}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T5}" = "ValE" ]; then
        echo "Expected ENV_T5 to have value ValE but got ${ENV_T5}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T6}" = "ValF" ]; then
        echo "Expected ENV_T6 to have value ValF but got ${ENV_T6}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    return 0
}

##!
# @brief Test that the environment variables are correcty restored after restauration step 2
# @return 0 if list is correct, 1 otherwise
#
# Also increments FAILED_TEST_NB to ligthen test "main" structure.
#
##
CheckRestauration2Vars()
{
    if [ ! "${ENV_T1}" = "ValZ" ]; then
        echo "Expected ENV_T1 to have value ValZ but got ${ENV_T1}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T2}" = "ValY" ]; then
        echo "Expected ENV_T2 to have value ValY but got ${ENV_T2}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T3}" = "ValX" ]; then
        echo "Expected ENV_T3 to have value ValX but got ${ENV_T3}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T4}" = "ValD" ]; then
        echo "Expected ENV_T4 to have value ValD but got ${ENV_T4}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T5}" = "ValV" ]; then
        echo "Expected ENV_T5 to have value ValV but got ${ENV_T5}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    if [ ! "${ENV_T6}" = "ValU" ]; then
        echo "Expected ENV_T6 to have value ValU but got ${ENV_T6}"
        ((FAILED_TEST_NB++)) ## New invalid test
        return 1
    fi
    return 0
}

### Create Folders for the test
for ((i=1;i<=10;i++)); do
    mkdir /tmp/toto${i}
done
CheckTotoList /tmp 1 10
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Failed to create required folders for test. Exiting"
    echo -e "\033[1;31mTest KO\033[0m"
    CleanTestEnv
    exit 1 # Test failed
fi

### Create Files for the test
for ((i=1;i<=20;i++)); do
    touch /tmp/toto8/dummy${i}
done
CheckDummyList /tmp/toto8 1 20
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Failed to create required files for test. Exiting"
    echo -e "\033[1;31mTest KO\033[0m"
    CleanTestEnv
    exit 1 # Test failed
fi

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

CheckInitialTutu

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

CheckInitialFileRes

### Create Environment variables for the test
ENV_T1="ValA"
ENV_T2="ValB"
ENV_T3="ValC"
ENV_T4="ValD"
ENV_T5="ValE"
ENV_T6="ValF"

### Test Folders deletion
DIRS=("/tmp/toto1" "/tmp/toto2" "/tmp/toto3")
DeleteDirs ${DIRS[@]}
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Directory deletion should work fine but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckTotoList /tmp 4 10

### Test Files Deletion
FILES=("/tmp/toto8/dummy1 /tmp/toto8/dummy2 /tmp/toto8/dummy3 /tmp/toto8/dummy4 /tmp/toto8/dummy5 /tmp/toto8/dummy18 /tmp/toto8/dummy19 /tmp/toto8/dummy20")
DeleteFiles ${FILES[@]} 
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Files deletion should work fine but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckDummyList /tmp/toto8 6 17

### Test Folders Restauration
DIRS_RES=("/tmp/tutu1" "/tmp/tutu3")
RestoreDirs ${DIRS_RES[@]}
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Dirs restauration should work fine but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckRestauration1Tutu

### Test Folders Restauration failure
rm -r /tmp/tutu4.utmv # We delete a folder divertion to create an error
DIRS_RES=("/tmp/tutu2" "/tmp/tutu4" "/tmp/tutu5")
RestoreDirs ${DIRS_RES[@]}
RETURN=$?
if [ ${RETURN} -ne 1 ]; then
    echo "Dirs restauration should have indicated one error but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckRestauration2Tutu

### Test Files Restauration
FILES_RES=("/tmp/fileRes/phi1.txt" "/tmp/fileRes/phi4.txt" "/tmp/fileRes/phi6.txt")
RestoreFiles ${FILES_RES[@]}
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Files restauration should work fine but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckRestauration1FileRes

### Test Files Restauration failure
rm "/tmp/fileRes/phi2.txt.utmv"
FILES_RES=("/tmp/fileRes/phi2.txt" "/tmp/fileRes/phi3.txt" "/tmp/fileRes/phi5.txt" "/tmp/fileRes/phi7.txt")
RestoreFiles ${FILES_RES[@]}
RETURN=$?
if [ ${RETURN} -ne 2 ]; then
    echo "Files restauration should  have indicated two errors but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckRestauration2FileRes

### Test Environment Variables Restauration
VARS_RES=("ENV_T1" "ValZ" "ENV_T3" "ValX")
RestoreEnvVars ${VARS_RES[@]}
RETURN=$?
if [ ${RETURN} -ne 0 ]; then
    echo "Files restauration should have run fine but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckRestauration1Vars

### Test Environment Variables Restauration with errors
VARS_RES=("ENV_T2" "ValY" "ENV_T6" "ValU" "ENV_T5" "ValV" "ENV_T4") # No value for T4 => error
RestoreEnvVars ${VARS_RES[@]}
RETURN=$?
if [ ${RETURN} -ne 1 ]; then
    echo "Files restauration should have indicated one error but exited with code ${RETURN}"
    ((FAILED_TEST_NB++)) ## New invalid test
fi
CheckRestauration2Vars

### Clean up
CleanTestEnv

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
