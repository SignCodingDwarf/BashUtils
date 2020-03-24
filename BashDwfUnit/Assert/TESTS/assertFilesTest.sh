#!/bin/bash

# file :  assertFilesTest.sh
# author : SignC0dingDw@rf
# version : 1.0
# date : 19 March 2020
# Unit testing of assertFiles.sh file.

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
    touch /tmp/barCmpReference.txt
    echo "This is the list of the Dwarves in the Eddas" > /tmp/barCmpReference.txt
    echo "" >> /tmp/barCmpReference.txt
    echo "Motsognir" >> /tmp/barCmpReference.txt
    echo "Durin" >> /tmp/barCmpReference.txt
    echo "Nyi" >> /tmp/barCmpReference.txt
    echo "Nithi" >> /tmp/barCmpReference.txt
    echo "Northri" >> /tmp/barCmpReference.txt
    echo "Suthri" >> /tmp/barCmpReference.txt
    echo "Austri" >> /tmp/barCmpReference.txt
    echo "Vestri" >> /tmp/barCmpReference.txt
    echo "And so on" >> /tmp/barCmpReference.txt

    touch /tmp/barCmpTested.txt
    echo "This is the list of the Dwarves in the Eddas" > /tmp/barCmpTested.txt
    echo "" >> /tmp/barCmpTested.txt
    echo "Motsognir" >> /tmp/barCmpTested.txt
    echo "Durin" >> /tmp/barCmpTested.txt
    echo "Nyi" >> /tmp/barCmpTested.txt
    echo "Nithi" >> /tmp/barCmpTested.txt
    echo "Northri" >> /tmp/barCmpTested.txt
    echo "Suthri" >> /tmp/barCmpTested.txt
    echo "Austri" >> /tmp/barCmpTested.txt
    echo "Vestri" >> /tmp/barCmpTested.txt
    echo "And so on" >> /tmp/barCmpTested.txt

    touch /tmp/barCmpTested2.txt
    echo "" >> /tmp/barCmpTested2.txt
    echo "Northri" >> /tmp/barCmpTested2.txt
    echo "Suthri" >> /tmp/barCmpTested2.txt
    echo "Austri" >> /tmp/barCmpTested2.txt
    echo "Vestri" >> /tmp/barCmpTested2.txt

    touch /tmp/barCmpTested3.txt
    echo "This is the list of the Dwarves in the Eddas" > /tmp/barCmpTested3.txt
    echo "" >> /tmp/barCmpTested3.txt
    echo "Motsognir" >> /tmp/barCmpTested3.txt
    echo "Durin" >> /tmp/barCmpTested3.txt
    echo "Nyi" >> /tmp/barCmpTested3.txt
    echo "Nithi" >> /tmp/barCmpTested3.txt
    echo "Northri" >> /tmp/barCmpTested3.txt
    echo "Suthri" >> /tmp/barCmpTested3.txt
    echo "Austri" >> /tmp/barCmpTested3.txt
    echo "Vestri" >> /tmp/barCmpTested3.txt
    echo "There is also Gandalf and Oakenshield of course" >> /tmp/barCmpTested3.txt
    echo "And so on" >> /tmp/barCmpTested3.txt

    touch /tmp/barCmpEmpty1.txt

    touch /tmp/barCmpEmpty2.txt

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
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with no arguments provided
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILES_ARE_IDENTICAL <expected_file> <tested_file> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with missing argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityMissingArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "Reference" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILES_ARE_IDENTICAL <expected_file> <tested_file> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with empty argument
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "" "SomeContent" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Problem on provided arguments. Usage:\n" > /tmp/barRef
    printf "[Assertion Failure] : ASSERT_FILES_ARE_IDENTICAL <expected_file> <tested_file> [Message Header]\n" >> /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with reference not being a file
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityReferenceNotAFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "./notAFile" "/tmp/barCmpTested.txt" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Expected argument ./notAFile is not a file\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with tested not being a file
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityTestedNotAFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "/tmp/barCmpReference.txt" "/tmp/isItAFile" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Tested argument /tmp/isItAFile is not a file\n" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with tested string equal to expected string
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityOK()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "/tmp/barCmpEmpty1.txt" "/tmp/barCmpEmpty2.txt" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with tested string equal to expected string and changed error header
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityOKHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "/tmp/barCmpReference.txt" "/tmp/barCmpTested.txt" "Comparison of the infamous Catalog of The Dwarves" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    printf "" > /tmp/barRef
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with tested string not equal to expected string
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityKO()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "/tmp/barCmpReference.txt" "/tmp/barCmpTested2.txt" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Files are not identical\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected :\n" >> /tmp/barRef 
    printf "[Assertion Failure] : This is the list of the Dwarves in the Eddas\n" >> /tmp/barRef 
    printf "\n" >> /tmp/barRef
    printf "Motsognir\n" >> /tmp/barRef 
    printf "Durin\n" >> /tmp/barRef 
    printf "Nyi\n" >> /tmp/barRef 
    printf "Nithi\n" >> /tmp/barRef 
    printf "Northri\n" >> /tmp/barRef 
    printf "Suthri\n" >> /tmp/barRef 
    printf "Austri\n" >> /tmp/barRef 
    printf "Vestri\n" >> /tmp/barRef 
    printf "And so on\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got :\n" >> /tmp/barRef 
    printf "[Assertion Failure] : \n" >> /tmp/barRef 
    printf "Northri\n" >> /tmp/barRef 
    printf "Suthri\n" >> /tmp/barRef 
    printf "Austri\n" >> /tmp/barRef 
    printf "Vestri\n" >> /tmp/barRef 
    TestWrittenText /tmp/barOutput /tmp/barRef 

    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Check ASSERT_FILES_ARE_IDENTICAL behavior with tested string not equal to expected string and changed error header
# @String 0 if behavior is as expected, exit 1 otherwise
#
##
testAssertFileEqualityKOHeader()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../assertFiles.sh" "1.0"

    ### Execute Command
    (ASSERT_FILES_ARE_IDENTICAL "/tmp/barCmpReference.txt" "/tmp/barCmpTested3.txt" "Oops there is an error in the Edda" > /tmp/barOutput 2> /tmp/barError) # To avoid exiting test on return code
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Assertion Failure] : Oops there is an error in the Edda\n" > /tmp/barRef
    printf "[Assertion Failure] : Expected :\n" >> /tmp/barRef 
    printf "[Assertion Failure] : This is the list of the Dwarves in the Eddas\n" >> /tmp/barRef 
    printf "\n" >> /tmp/barRef
    printf "Motsognir\n" >> /tmp/barRef 
    printf "Durin\n" >> /tmp/barRef 
    printf "Nyi\n" >> /tmp/barRef 
    printf "Nithi\n" >> /tmp/barRef 
    printf "Northri\n" >> /tmp/barRef 
    printf "Suthri\n" >> /tmp/barRef 
    printf "Austri\n" >> /tmp/barRef 
    printf "Vestri\n" >> /tmp/barRef 
    printf "And so on\n" >> /tmp/barRef 
    printf "[Assertion Failure] : Got :\n" >> /tmp/barRef 
    printf "[Assertion Failure] : This is the list of the Dwarves in the Eddas\n" >> /tmp/barRef 
    printf "\n" >> /tmp/barRef
    printf "Motsognir\n" >> /tmp/barRef 
    printf "Durin\n" >> /tmp/barRef 
    printf "Nyi\n" >> /tmp/barRef 
    printf "Nithi\n" >> /tmp/barRef 
    printf "Northri\n" >> /tmp/barRef 
    printf "Suthri\n" >> /tmp/barRef 
    printf "Austri\n" >> /tmp/barRef 
    printf "Vestri\n" >> /tmp/barRef 
    printf "There is also Gandalf and Oakenshield of course\n" >> /tmp/barRef
    printf "And so on\n" >> /tmp/barRef 
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
# ASSERT_FILES_ARE_IDENTICAL
doTest testAssertFileEqualityNoArg
doTest testAssertFileEqualityMissingArg
doTest testAssertFileEqualityEmptyArg
doTest testAssertFileEqualityReferenceNotAFile
doTest testAssertFileEqualityTestedNotAFile
doTest testAssertFileEqualityOK
doTest testAssertFileEqualityOKHeader
doTest testAssertFileEqualityKO
doTest testAssertFileEqualityKOHeader

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
