#!/bin/bash

###
# @file parseVersionTest.sh
# @author SignC0dingDw@rf
# @version 0.1
# @date 23 October 2019
# @brief Unit testing of parseVersion.sh file. Reimplements BashUnit basic test features because it is used by this framework.
###

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
    eval "${TEST_CONTENT}"

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
    if [ ! -z ${PARSEVERSION_SH} ]; then 
        echo "PARSEVERSION_SH already has value ${PARSEVERSION_SH}"
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
    . "${SCRIPT_LOCATION}/../parseVersion.sh"

    if [ ! "${PARSEVERSION_SH}" = "1.0" ]; then 
        echo "Loading of parseVersion.sh failed. Content is ${PARSEVERSION_SH}"
        return 1
    else
        return 0
    fi
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file does not exist
# @return 0 if behavior ok, 1 otherwise
#
## 
testFileDoesNotExist()
{
    parseDoxygenVersion /tmp/filethat/does/not/exist "//"
    local RESULT=$?
    if [ $RESULT -ne "1" ]; then
        echo "Trying to parse on a non existing file should return 1"
        echo "but returned ${RESULT}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file does not contain version
# @return 0 if behavior ok, 1 otherwise
#
## 
testFileNoVersion()
{
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barNoVersion ";")
    local RESULT=$?
    if [ $RESULT -ne "2" ]; then
        echo "Trying to parse a file with no version should return 2"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "0.0" ]; then
        echo "Default version if version line not found should be 0.0"
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains version
# @return 0 if behavior ok, 1 otherwise
#
## 
testFileVersion()
{
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barVersion "//")
    local RESULT=$?
    if [ $RESULT -ne "0" ]; then
        echo "Parsing should have succeeded"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "2.3.4" ]; then
        echo "Read Version should be 2.3.4"
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains multiple valid version definitions
# @return 0 if behavior ok, 1 otherwise
#
## 
testFileMultiVersion()
{
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barMultiVersion "!")
    local RESULT=$?
    if [ $RESULT -ne "0" ]; then
        echo "Parsing should have succeeded"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "42.69rev666" ]; then
        echo "Read Version should be 42.69rev666" # first version encountered should be displayed
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains a version definition in the middle of the line. It should be ignored 
# @return 0 if behavior ok, 1 otherwise
#
## 
testFileFullLineVersion()
{
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barFullLineVersion "//")
    local RESULT=$?
    if [ $RESULT -ne "0" ]; then
        echo "Parsing should have succeeded"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "6.3.4" ]; then
        echo "Read Version should be 6.3.4" # previous version is in the middle of a line so should be ignored
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseBashDoxygenVersion if provided file does not exist
# @return 0 if behavior ok, 1 otherwise
#
## 
testBashFileDoesNotExist()
{
    parseBashDoxygenVersion /tmp/filethat/does/not/exist
    local RESULT=$?
    if [ $RESULT -ne "1" ]; then
        echo "Trying to parse on a non existing file should return 1"
        echo "but returned ${RESULT}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file does not contain version
# @return 0 if behavior ok, 1 otherwise
#
## 
testBashFileNoVersion()
{
    local VERSION_PARSED="etc"
    sed -i 's/;/#/g' /tmp/barNoVersion # Replace line head by bash comments

    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barNoVersion)
    local RESULT=$?
    if [ $RESULT -ne "2" ]; then
        echo "Trying to parse a file with no version should return 2"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "0.0" ]; then
        echo "Default version if version line not found should be 0.0"
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains version
# @return 0 if behavior ok, 1 otherwise
#
## 
testBashFileVersion()
{
    local VERSION_PARSED="etc"
    sed -i 's/\/\//#/g' /tmp/barVersion # Replace line head by bash comments
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barVersion)
    local RESULT=$?
    if [ $RESULT -ne "0" ]; then
        echo "Parsing should have succeeded"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "2.3.4" ]; then
        echo "Read Version should be 2.3.4"
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains multiple valid version definitions
# @return 0 if behavior ok, 1 otherwise
#
## 
testBashFileMultiVersion()
{
    local VERSION_PARSED="etc"
    sed -i 's/!/#/g' /tmp/barMultiVersion # Replace line head by bash comments
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barMultiVersion)
    local RESULT=$?
    if [ $RESULT -ne "0" ]; then
        echo "Parsing should have succeeded"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "42.69rev666" ]; then
        echo "Read Version should be 42.69rev666" # first version encountered should be displayed
        echo "but was ${VERSION_PARSED}"
        return 1
    fi
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains a version definition in the middle of the line. It should be ignored 
# @return 0 if behavior ok, 1 otherwise
#
## 
testBashFileFullLineVersion()
{
    local VERSION_PARSED="etc"
    sed -i 's/\/\//#/g' /tmp/barFullLineVersion # Replace line head by bash comments
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barFullLineVersion)
    local RESULT=$?
    if [ $RESULT -ne "0" ]; then
        echo "Parsing should have succeeded"
        echo "but returned ${RESULT}"
        return 1
    fi
    if [ ! "${VERSION_PARSED}" = "6.3.4" ]; then
        echo "Read Version should be 6.3.4" # previous version is in the middle of a line so should be ignored
        echo "but was ${VERSION_PARSED}"
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
# Create file with no version
touch /tmp/barNoVersion
echo "; @file barNoVersion" >> /tmp/barNoVersion
echo "; @author Chewbacca" >> /tmp/barNoVersion
echo "; @brief The Empire Sucks" >> /tmp/barNoVersion
echo "; version 4.5.6" >> /tmp/barNoVersion
echo "print version : E.N.V2" >> /tmp/barNoVersion

# Create file with single version
touch /tmp/barVersion
echo "// @file barVersion" >> /tmp/barVersion
echo "// @author A dwarf" >> /tmp/barVersion
echo "// @version 2.3.4" >> /tmp/barVersion
echo "// @brief Fortune and fame" >> /tmp/barVersion
echo "Doing things" >> /tmp/barVersion
echo "More things" >> /tmp/barVersion

# Create file with multiple versions
touch /tmp/barMultiVersion
echo "! @file barMultiVersion" >> /tmp/barMultiVersion
echo "! @author A dwarf" >> /tmp/barMultiVersion
echo "! @version 42.69rev666" >> /tmp/barMultiVersion
echo "! @brief The answer" >> /tmp/barMultiVersion
echo "Busy working" >> /tmp/barMultiVersion
echo "More work ?" >> /tmp/barMultiVersion
echo "! @version 7.497" >> /tmp/barMultiVersion
echo "D'oh" >> /tmp/barMultiVersion
echo "! @version 12.34" >> /tmp/barMultiVersion

# Create file with version definition in the middle of a line
touch /tmp/barFullLineVersion
echo "// @file barStartVersion" >> /tmp/barFullLineVersion
echo "// @author A dwarf" >> /tmp/barFullLineVersion
echo "// The versions is indicated with // @version <VERSION>" >> /tmp/barFullLineVersion
echo "// @brief The line other this one shoud be ignored" >> /tmp/barFullLineVersion
echo "// @version 6.3.4" >> /tmp/barFullLineVersion

### Do Tests
doTest "parseVersion.sh not included" scriptNotIncluded
doTest "parseVersion.sh included" scriptIncluded
# parseDoxygenVersion tests
doTest "parseDoxygenVersion with unexisting file" testFileDoesNotExist
doTest "parseDoxygenVersion with no version line" testFileNoVersion
doTest "parseDoxygenVersion with valid version line" testFileVersion
doTest "parseDoxygenVersion with multiple valid version lines" testFileMultiVersion
doTest "parseDoxygenVersion with version definition in the middle of a line" testFileFullLineVersion
# apply same tests with parseBashDoxygenVersion
doTest "parseBashDoxygenVersion with unexisting file" testBashFileDoesNotExist
doTest "parseBashDoxygenVersion with no version line" testBashFileNoVersion
doTest "parseBashDoxygenVersion with valid version line" testBashFileVersion
doTest "parseBashDoxygenVersion with multiple valid version lines" testBashFileMultiVersion
doTest "parseBashDoxygenVersion with version definition in the middle of a line" testBashFileFullLineVersion

### Clean Up
rm -f /tmp/bar*

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
