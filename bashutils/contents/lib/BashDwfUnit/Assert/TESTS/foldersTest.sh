#!/bin/bash

# file :  foldersTest.sh
# author : SignC0dingDw@rf
# version : 1.2
# date : 29 November 2020
# Unit testing of folders.sh file.

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
    mkdir /tmp/foo
    mkdir /tmp/foo/foo1
    mkdir /tmp/foo/foo2
    touch /tmp/foo/bar1
    touch /tmp/foo/foo1/bar12
    touch /tmp/foo/foo1/bar34
    touch /tmp/foo/foo1/bar56
    mkdir /tmp/foo/foo1/foo
    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -rf /tmp/foo
    rm -rf /tmp/bar*
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FOLDER_HAS_EXPECTED_CONTENT <expected_content_name> <tested_folder> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with missing argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentMissingArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "expectedContent" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FOLDER_HAS_EXPECTED_CONTENT <expected_content_name> <tested_folder> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with empty argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "" "/tmp/foo" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FOLDER_HAS_EXPECTED_CONTENT <expected_content_name> <tested_folder> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with expected argument not being a variable
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentExpectedNotVariable()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "NotAVariable" "/tmp/foo" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : NotAVariable is not the name of an array.\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with expected argument not being an array
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentExpectedNotArray()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    local someVariable="NotAnArray"
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "someVariable" "/tmp/foo" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : someVariable is not the name of an array.\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with tested argument not being a folder
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentTestedNotFolder()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    local someVariable=("bar1" "foo1" "foo2")
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "someVariable" "/tmp/foo/bar1" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : /tmp/foo/bar1 is not a directory.\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with folder and expected content matching
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    local someVariable=("bar1" "foo1" "foo2")
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "someVariable" "/tmp/foo" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with folder and expected content matching and modified header
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentOKHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    local someVariable=("bar1" "foo1" "foo2")
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "someVariable" "/tmp/foo" "Foo is a good directory" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with folder and expected content not matching
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    local someVariable=("bar1" "foo1" "foo3")
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "someVariable" "/tmp/foo" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Folder has not expected content\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected :\n" >> /tmp/barRef
    printf "[Assertion Failure] : bar1 foo1 foo3\n" >> /tmp/barRef
    printf "[Assertion Failure] : Got :\n" >> /tmp/barRef
    printf "[Assertion Failure] : bar1 foo1 foo2 \n" >> /tmp/barRef
    printf "[Assertion Failure] : Differences :\n" >> /tmp/barRef
    printf "[Assertion Failure] : foo2 foo3\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FOLDER_HAS_EXPECTED_CONTENT behavior with folder and expected content not matching and modified header
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFolderContentKOHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../folders.sh" "1.1"

    ### Execute Command
    local someVariable=("bar12" "foo")
    (ASSERT_FOLDER_HAS_EXPECTED_CONTENT "someVariable" "/tmp/foo/foo1" "foo1 is not the folder I expected" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : foo1 is not the folder I expected\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected :\n" >> /tmp/barRef
    printf "[Assertion Failure] : bar12 foo\n" >> /tmp/barRef
    printf "[Assertion Failure] : Got :\n" >> /tmp/barRef
    printf "[Assertion Failure] : bar12 bar34 bar56 foo \n" >> /tmp/barRef
    printf "[Assertion Failure] : Differences :\n" >> /tmp/barRef
    printf "[Assertion Failure] : bar34 bar56\n" >> /tmp/barRef
#    diff -ay /tmp/barOutput /tmp/barRef 
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
# ASSERT_FOLDER_HAS_EXPECTED_CONTENT
doTest testAssertFolderContentNoArg
doTest testAssertFolderContentMissingArg
doTest testAssertFolderContentEmptyArg
doTest testAssertFolderContentExpectedNotVariable
doTest testAssertFolderContentExpectedNotArray
doTest testAssertFolderContentTestedNotFolder
doTest testAssertFolderContentOK
doTest testAssertFolderContentOKHeader
doTest testAssertFolderContentKO
doTest testAssertFolderContentKOHeader

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
