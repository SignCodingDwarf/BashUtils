#!/bin/bash

###
# @file parseVersionTest.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 29 November 2020
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
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION}/../../Tools/testUtils.sh"


################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
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

    return 0
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
# @brief Check behavior of parseDoxygenVersion if provided file does not exist
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testFileDoesNotExist()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    parseDoxygenVersion /tmp/filethat/does/not/exist "//"
    COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\" " "Trying to parse on a non existing file should return 1 but returned ${COMMAND_RESULT}"
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file does not contain version
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testFileNoVersion()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barNoVersion ";")
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"2\" " "Trying to parse a file with no version should return 2 but returned ${COMMAND_RESULT}"
    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"0.0\"" "Default version if version line not found should be 0.0 but was ${VERSION_PARSED}"

    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains version
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testFileVersion()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barVersion "//")
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Parsing should have succeeded with error code 0 but returned ${COMMAND_RESULT}"

    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"2.3.4\"" "Read Version should be 2.3.4 but was ${VERSION_PARSED}"

    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains multiple valid version definitions
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testFileMultiVersion()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barMultiVersion "!")
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Parsing should have succeeded with error code 0 but returned ${COMMAND_RESULT}"

    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"42.69rev666\"" "Read Version should be 42.69rev666 but was ${VERSION_PARSED}"

    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains a version definition in the middle of the line. It should be ignored 
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testFileFullLineVersion()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseDoxygenVersion /tmp/barFullLineVersion "//")
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Parsing should have succeeded with error code 0 but returned ${COMMAND_RESULT}"

    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"6.3.4\"" "Read Version should be 6.3.4 but was ${VERSION_PARSED}" # previous version is in the middle of a line so should be ignored

    return 0
}

##!
# @brief Check behavior of parseBashDoxygenVersion if provided file does not exist
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testBashFileDoesNotExist()
{
    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    parseBashDoxygenVersion /tmp/filethat/does/not/exist
    COMMAND_RESULT=$?

    # Process result
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\" " "Trying to parse on a non existing file should return 1 but returned ${COMMAND_RESULT}"
    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file does not contain version
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testBashFileNoVersion()
{
    # Pre test operations
    sed -i 's/;/#/g' /tmp/barNoVersion # Replace line head by bash comments

    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barNoVersion)
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"2\" " "Trying to parse a file with no version should return 2 but returned ${COMMAND_RESULT}"
    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"0.0\"" "Default version if version line not found should be 0.0 but was ${VERSION_PARSED}"

    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains version
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testBashFileVersion()
{
    # Pre test operations
    sed -i 's/\/\//#/g' /tmp/barVersion # Replace line head by bash comments

    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barVersion)
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Parsing should have succeeded with error code 0 but returned ${COMMAND_RESULT}"

    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"2.3.4\"" "Read Version should be 2.3.4 but was ${VERSION_PARSED}"

    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains multiple valid version definitions
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testBashFileMultiVersion()
{
    # Pre test operations
    sed -i 's/!/#/g' /tmp/barMultiVersion # Replace line head by bash comments

    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barMultiVersion "!")
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Parsing should have succeeded with error code 0 but returned ${COMMAND_RESULT}"

    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"42.69rev666\"" "Read Version should be 42.69rev666 but was ${VERSION_PARSED}"

    return 0
}

##!
# @brief Check behavior of parseDoxygenVersion if provided file contains a version definition in the middle of the line. It should be ignored 
# @return 0 if behavior ok, exit 1 otherwise
#
## 
testBashFileFullLineVersion()
{
    # Pre test operations
    sed -i 's/\/\//#/g' /tmp/barFullLineVersion # Replace line head by bash comments

    # Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../parseVersion.sh" "1.0"

    # Call command
    local COMMAND_RESULT=0
    local VERSION_PARSED="etc"
    VERSION_PARSED=$(parseBashDoxygenVersion /tmp/barFullLineVersion "//")
    COMMAND_RESULT=$?

    # Check results
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\" " "Parsing should have succeeded with error code 0 but returned ${COMMAND_RESULT}"

    endTestIfAssertFails "\"${VERSION_PARSED}\" = \"6.3.4\"" "Read Version should be 6.3.4 but was ${VERSION_PARSED}" # previous version is in the middle of a line so should be ignored

    return 0
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
# parseDoxygenVersion tests
doTest testFileDoesNotExist
doTest testFileNoVersion
doTest testFileVersion
doTest testFileMultiVersion
doTest testFileFullLineVersion

# parseBashDoxygenVersion tests
doTest testBashFileDoesNotExist
doTest testBashFileNoVersion
doTest testBashFileVersion
doTest testBashFileMultiVersion
doTest testBashFileFullLineVersion

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
