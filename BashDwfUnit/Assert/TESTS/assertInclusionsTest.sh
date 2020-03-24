#!/bin/bash

# file :  assertInclusionsTest.sh
# author : SignC0dingDw@rf
# version : 1.0
# date : 19 March 2020
# Unit testing of assertInclusions.sh file.

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
. "${SCRIPT_LOCATION}/../../../Tools/TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    touch /tmp/barTestFile.sh

    touch /tmp/barNoScript.txt
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." > /tmp/barNoScript.txt

    touch /tmp/barFailingScript.sh
    echo "#!/bin/bash" > /tmp/barFailingScript.sh
    echo "BARFAILINGSCRIPT_SH=12.3" >> /tmp/barFailingScript.sh
    echo "ErrorFunction()" >> /tmp/barFailingScript.sh
    echo "{" >> /tmp/barFailingScript.sh
    echo "return 27" >> /tmp/barFailingScript.sh
    echo "}" >> /tmp/barFailingScript.sh    
    echo "ErrorFunction" >> /tmp/barFailingScript.sh

    touch /tmp/barSuccessScript.sh
    echo "#!/bin/bash" > /tmp/barSuccessScript.sh
    echo "BARSUCCESSSCRIPT_SH=75.4" >> /tmp/barSuccessScript.sh    

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -rf /tmp/bar*
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check filePathToInclusionVariable behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testToInclusionVariableNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local inclusionVariable="Default"
    inclusionVariable=$(filePathToInclusionVariable 2> /tmp/barError)
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}" 

    endTestIfAssertFails "\"${inclusionVariable}\" = \"\" " "Inclusion variable name should be empty but has value ${inclusionVariable}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check filePathToInclusionVariable behavior with empty argument provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testToInclusionVariableEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local inclusionVariable="Default"
    inclusionVariable=$(filePathToInclusionVariable "" 2> /tmp/barError)
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    endTestIfAssertFails "\"${inclusionVariable}\" = \"\" " "Inclusion variable name should be empty but has value ${inclusionVariable}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check filePathToInclusionVariable behavior with classic bash script name provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testToInclusionVariableNominalCase()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local inclusionVariable="Default"
    inclusionVariable=$(filePathToInclusionVariable "../../someBashScript.sh" 2> /tmp/barError)
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    endTestIfAssertFails "\"${inclusionVariable}\" = \"SOMEBASHSCRIPT_SH\" " "Inclusion variable name should be SOMEBASHSCRIPT_SH but has value ${inclusionVariable}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check filePathToInclusionVariable behavior with script name without extension provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testToInclusionVariableNoExtension()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local inclusionVariable="Default"
    inclusionVariable=$(filePathToInclusionVariable "/tmp/AnExampleOfExecutable" 2> /tmp/barError)
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    endTestIfAssertFails "\"${inclusionVariable}\" = \"ANEXAMPLEOFEXECUTABLE\" " "Inclusion variable name should be ANEXAMPLEOFEXECUTABLE but has value ${inclusionVariable}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check filePathToInclusionVariable behavior with script name containing _ or -
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testToInclusionVariableSpecialCharacters()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local inclusionVariable="Default"
    inclusionVariable=$(filePathToInclusionVariable "/tmp/A_file_name-1.0.sh" 2> /tmp/barError)
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    endTestIfAssertFails "\"${inclusionVariable}\" = \"A_FILE_NAME_1_0_SH\" " "Inclusion variable name should be A_FILE_NAME_1_0_SH but has value ${inclusionVariable}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check filePathToInclusionVariable behavior with script name ending by /
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testToInclusionVariableFolderEnding()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local inclusionVariable="Default"
    inclusionVariable=$(filePathToInclusionVariable "/tmp/aFolder/" 2> /tmp/barError)
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    endTestIfAssertFails "\"${inclusionVariable}\" = \"\" " "Inclusion variable name should be empty but has value ${inclusionVariable}"

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_NOT_INCLUDED behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testNotIncludedNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_NOT_INCLUDED > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_NOT_INCLUDED <file_tested>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_NOT_INCLUDED behavior with empty argument provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testNotIncludedEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_NOT_INCLUDED "" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_NOT_INCLUDED <file_tested>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_NOT_INCLUDED behavior with provided argument not being a file
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testNotIncludedNotAFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_NOT_INCLUDED "NotAFile.sh" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File NotAFile.sh is not a file\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_NOT_INCLUDED behavior with provided argument being a file not included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testNotIncludedOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_NOT_INCLUDED "/tmp/barTestFile.sh" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_NOT_INCLUDED behavior with provided argument being a file included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testNotIncludedKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local BARTESTFILE_SH="I should be empty"
    (ASSERT_FILE_NOT_INCLUDED "/tmp/barTestFile.sh" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File /tmp/barTestFile.sh is already included.\n" > /tmp/barRef
    printf "[Assertion Failure] : Inclusion control variable BARTESTFILE_SH has value I should be empty\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_NOT_INCLUDED <file_tested>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED behavior with empty argument provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED "" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_NOT_INCLUDED <file_tested>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED behavior with provided argument not being a file
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedNotAFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED "NotAFile.sh" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File NotAFile.sh is not a file\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED behavior with provided argument being a file included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local BARTESTFILE_SH="I am included"
    (ASSERT_FILE_INCLUDED "/tmp/barTestFile.sh" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED behavior with provided argument being a file not included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED "/tmp/barTestFile.sh" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File /tmp/barTestFile.sh is not included\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED_WITH_VERSION > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_INCLUDED_WITH_VERSION <file_tested> <expected_version>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with missing argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionMissingArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED_WITH_VERSION "../notAFile/" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_INCLUDED_WITH_VERSION <file_tested> <expected_version>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with empty argument provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED_WITH_VERSION "" "2.3" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILE_INCLUDED_WITH_VERSION <file_tested> <expected_version>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with file argument not being a file
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionNotAFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED_WITH_VERSION "./thisIsNotAFile" "2.3" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File ./thisIsNotAFile is not a file\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with provided argument being a file included with correct version
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local BARTESTFILE_SH="42.666"
    (ASSERT_FILE_INCLUDED_WITH_VERSION "/tmp/barTestFile.sh" "42.666" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with wrong version on provided argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local BARTESTFILE_SH="121"
    (ASSERT_FILE_INCLUDED_WITH_VERSION "/tmp/barTestFile.sh" "21" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File /tmp/barTestFile.sh is not correctly included\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : 21\n" >> /tmp/barRef
    printf "[Assertion Failure] : Got : 121\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILE_INCLUDED_WITH_VERSION behavior with provided argument being a file not included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testIncludedVersionKONotIncluded()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (ASSERT_FILE_INCLUDED_WITH_VERSION "/tmp/barTestFile.sh" "42.666" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File /tmp/barTestFile.sh is not correctly included\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : 42.666\n" >> /tmp/barRef
    printf "[Assertion Failure] : Got : \n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : INCLUDE_AND_ASSERT_VERSION <file_tested> <expected_version>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with missing argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionMissingArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "../notAFile/" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : INCLUDE_AND_ASSERT_VERSION <file_tested> <expected_version>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with empty argument provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "" "" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : INCLUDE_AND_ASSERT_VERSION <file_tested> <expected_version>\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with file argument not being a file
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionNotAFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "./thisIsNotAFile" "2.3" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File ./thisIsNotAFile is not a file\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with a file that has already been included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionAlreadyIncluded()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    local BARTESTFILE_SH="42.666"
    (INCLUDE_AND_ASSERT_VERSION "/tmp/barTestFile.sh" "21" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File /tmp/barTestFile.sh is already included.\n" > /tmp/barRef
    printf "[Assertion Failure] : Inclusion control variable BARTESTFILE_SH has value 42.666\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with file to include not being a script
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionNotAScript()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "/tmp/barNoScript.txt" "666" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Inclusion of file /tmp/barNoScript.txt failed with error 127\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "/tmp/barNoScript.txt: line 1: Lorem: command not found\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with file to include failing during inclusion
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionScriptFailure()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "/tmp/barFailingScript.sh" "33" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Inclusion of file /tmp/barFailingScript.sh failed with error 27\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with wrong version of file included
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionInclusionWrongVersion()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "/tmp/barSuccessScript.sh" "121" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : File /tmp/barSuccessScript.sh is not correctly included\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected : 121\n" >> /tmp/barRef
    printf "[Assertion Failure] : Got : 75.4\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check INCLUDE_AND_ASSERT_VERSION behavior with successful file inclusion
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertVersionOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertInclusions.sh" "1.0"

    ### Execute Command
    (INCLUDE_AND_ASSERT_VERSION "/tmp/barSuccessScript.sh" "75.4" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# filePathToInclusionVariable
doTest testToInclusionVariableNoArg
doTest testToInclusionVariableEmptyArg
doTest testToInclusionVariableNominalCase
doTest testToInclusionVariableNoExtension
doTest testToInclusionVariableSpecialCharacters
doTest testToInclusionVariableFolderEnding

# ASSERT_FILE_NOT_INCLUDED
doTest testNotIncludedNoArg
doTest testNotIncludedEmptyArg
doTest testNotIncludedNotAFile
doTest testNotIncludedOK
doTest testNotIncludedKO

# ASSERT_FILE_INCLUDED
doTest testIncludedNoArg
doTest testIncludedEmptyArg
doTest testIncludedNotAFile
doTest testIncludedOK
doTest testIncludedKO

# ASSERT_FILE_INCLUDED_WITH_VERSION
doTest testIncludedVersionNoArg
doTest testIncludedVersionMissingArg
doTest testIncludedVersionEmptyArg
doTest testIncludedVersionNotAFile
doTest testIncludedVersionOK
doTest testIncludedVersionKO
doTest testIncludedVersionKONotIncluded

# INCLUDE_AND_ASSERT_VERSION
doTest testAssertVersionNoArg
doTest testAssertVersionMissingArg
doTest testAssertVersionEmptyArg
doTest testAssertVersionNotAFile
doTest testAssertVersionAlreadyIncluded
doTest testAssertVersionNotAScript
doTest testAssertVersionScriptFailure
doTest testAssertVersionInclusionWrongVersion
doTest testAssertVersionOK

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
