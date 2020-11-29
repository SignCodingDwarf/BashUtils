#!/bin/bash

# file :  declareDivertionTest.sh
# author : SignC0dingDw@rf
# version : 1.2
# date : 29 November 2020
# Unit testing of declareDivertion.sh file.

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
    ### Initialize lists
    ELEMENTS_DIVERTED=()

    ### Create folders
    mkdir /tmp/foo
    mkdir /tmp/foo1
    mkdir /tmp/foo2
    mkdir /tmp/foo3

    ### Create files
    touch /tmp/foo/bar1
    echo "First Avenger" > /tmp/foo/bar1 
    touch /tmp/foo/bar2
    echo "Second to none" > /tmp/foo/bar2
    touch /tmp/foo/bar3
    echo "Third" > /tmp/foo/bar3
    touch /tmp/foo/bar4
    echo "May the Fourth be with you" > /tmp/foo/bar4

    ### Symlink 
    ln -sf /tmp/foo2 /tmp/fooL

    ### Reference folder for replacement
    mkdir /tmp/ref
    touch /tmp/ref/barXXX

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    ELEMENTS_DIVERTED=()

    rm -f /tmp/bar*
    rm -rf /tmp/toto*
    rm -rf /tmp/foo*
    rm -rf /tmp/ref

    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check DivertCopyElement behavior if no input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertCopyElementNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertCopyElement 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local expectedDiverted=()
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Error] : You should specify elements to divert\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DivertCopyElement behavior if nominal input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertCopyElementNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertCopyElement /tmp/foo1 /tmp/foo/bar1 /tmp/foo3 /tmp/fooL /tmp/foo/bar4 /tmp/foo/bar2 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo1" "/tmp/foo/bar1" "/tmp/foo3" "/tmp/fooL" "/tmp/foo/bar4" "/tmp/foo/bar2")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo1" "foo1.utmv" "foo2" "foo3" "foo3.utmv" "fooL" "fooL.utmv"
    CheckDirContent "/tmp/foo" "bar" "bar1" "bar1.utmv" "bar2" "bar2.utmv" "bar3" "bar4" "bar4.utmv"  
    TestWrittenText "/tmp/foo/bar1" "/tmp/foo/bar1.utmv"
    TestWrittenText "/tmp/foo/bar2" "/tmp/foo/bar2.utmv"
    TestWrittenText "/tmp/foo/bar4" "/tmp/foo/bar4.utmv"
}

##!
# @brief Check DivertCopyElement behavior if already diverted elements are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertCopyElementAlreadyDivertedElements()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Create divertion of element
    touch /tmp/foo/bar1.utmv

    ### Test command
    DivertCopyElement /tmp/foo1 /tmp/foo/bar1 /tmp/fooL /tmp/foo1 /tmp/foo/bar2 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo1" "/tmp/fooL" "/tmp/foo/bar2")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Warning] : Divertion of element /tmp/foo/bar1 failed because it is already diverted.\n" > /tmp/barErrorRef
    printf "[Warning] : Divertion of element /tmp/foo1 failed because it is already diverted.\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo1" "foo1.utmv" "foo2" "foo3" "fooL" "fooL.utmv"
    CheckDirContent "/tmp/foo" "bar" "bar1" "bar1.utmv" "bar2" "bar2.utmv" "bar3" "bar4"   
}

##!
# @brief Check DivertCopyElement behavior if divertion errors occur
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertCopyElementErrors()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertCopyElement /tmp/DoesNOTExist /tmp/foo1 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo1")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "cp: cannot stat '/tmp/DoesNOTExist': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Divertion of element /tmp/DoesNOTExist failed because of error 1\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo1" "foo1.utmv" "foo2" "foo3" "fooL"      
}

##!
# @brief Check DivertMoveElement behavior if no input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertMoveElementNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertCopyElement 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local expectedDiverted=()
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Error] : You should specify elements to divert\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DivertMoveElement behavior if nominal input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertMoveElementNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertMoveElement /tmp/foo1 /tmp/foo/bar1 /tmp/foo3 /tmp/fooL /tmp/foo/bar4 /tmp/foo/bar2 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo1" "/tmp/foo/bar1" "/tmp/foo3" "/tmp/fooL" "/tmp/foo/bar4" "/tmp/foo/bar2")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo1.utmv" "foo2" "foo3.utmv" "fooL.utmv"
    CheckDirContent "/tmp/foo" "bar" "bar1.utmv" "bar2.utmv" "bar3" "bar4.utmv"  
    echo "First Avenger" > /tmp/barRef 
    TestWrittenText /tmp/foo/bar1.utmv /tmp/barRef 
    echo "Second to none" > /tmp/barRef 
    TestWrittenText /tmp/foo/bar2.utmv /tmp/barRef 
    echo "May the Fourth be with you" > /tmp/barRef 
    TestWrittenText /tmp/foo/bar4.utmv /tmp/barRef
}

##!
# @brief Check DivertMoveElement behavior if already diverted elements are provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertMoveElementAlreadyDivertedElements()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Create divertion of element
    touch /tmp/foo/bar1.utmv

    ### Test command
    DivertMoveElement /tmp/foo1 /tmp/foo/bar1 /tmp/fooL /tmp/foo1 /tmp/foo/bar2 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo1" "/tmp/fooL" "/tmp/foo/bar2")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Warning] : Divertion of element /tmp/foo/bar1 failed because it is already diverted.\n" > /tmp/barErrorRef
    printf "[Warning] : Divertion of element /tmp/foo1 failed because it is already diverted.\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo1.utmv" "foo2" "foo3" "fooL.utmv"
    CheckDirContent "/tmp/foo" "bar" "bar1" "bar1.utmv" "bar2.utmv" "bar3" "bar4"   
    echo "First Avenger" > /tmp/barRef 
    TestWrittenText /tmp/foo/bar1 /tmp/barRef 
    printf "" > /tmp/barRef 
    TestWrittenText /tmp/foo/bar1.utmv /tmp/barRef 
    echo "Second to none" > /tmp/barRef 
    TestWrittenText /tmp/foo/bar2.utmv /tmp/barRef 
}

##!
# @brief Check DivertMoveElement behavior if divertion errors occur
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertMoveElementErrors()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertMoveElement /tmp/DoesNOTExist /tmp/foo1 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo1")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "mv: cannot stat '/tmp/DoesNOTExist': No such file or directory\n" > /tmp/barErrorRef
    printf "[Error] : Divertion of element /tmp/DoesNOTExist failed because of error 1\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo1.utmv" "foo2" "foo3" "fooL"      
}

##!
# @brief Check DivertReplaceElement behavior if no input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertReplaceElementNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertReplaceElement 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local expectedDiverted=()
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Error] : No replaced element defined\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DivertReplaceElement behavior if no replacing element is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertReplaceElementNoReplacingElement()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertReplaceElement /tmp/foo 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"3\" " "Expected function to exit with code 3 but exited with code ${test_result}"

    local expectedDiverted=()
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Error] : No replacing element defined\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DivertReplaceElement behavior if no replacing element is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertReplaceElementSuccess()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Test command
    DivertReplaceElement /tmp/foo /tmp/ref 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local expectedDiverted=("/tmp/foo")
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Check effect on elements
    CheckDirContent "/tmp/" "foo" "foo" "foo.utmv" "foo1" "foo2" "foo3" "fooL"   
    CheckDirContent "/tmp/foo.utmv" "bar" "bar1" "bar2" "bar3" "bar4" 
    CheckDirContent "/tmp/foo" "bar" "barXXX" 
    CheckDirContent "/tmp/ref" "bar" "barXXX" 
}

##!
# @brief Check DivertReplaceElement behavior if replaced element is already diverted
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDivertReplaceElementAlreadyDiverted()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDivertion.sh" "1.1"

    ### Create divertion
    mkdir /tmp/foo.utmv

    ### Test command
    DivertReplaceElement /tmp/foo /tmp/ref 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"5\" " "Expected function to exit with code 5 but exited with code ${test_result}"

    local expectedDiverted=()
    CheckArrayContent ELEMENTS_DIVERTED expectedDiverted

    printf "[Warning] : Divertion of element /tmp/foo failed because it is already diverted.\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# DivertCopyElement
doTest TestDivertCopyElementNoInput
doTest TestDivertCopyElementNominalInput
doTest TestDivertCopyElementAlreadyDivertedElements
doTest TestDivertCopyElementErrors

# DivertMoveElement
doTest TestDivertMoveElementNoInput
doTest TestDivertMoveElementNominalInput
doTest TestDivertMoveElementAlreadyDivertedElements
doTest TestDivertMoveElementErrors

# DivertReplaceElement
doTest TestDivertReplaceElementNoInput
doTest TestDivertReplaceElementNoReplacingElement
doTest TestDivertReplaceElementSuccess
doTest TestDivertReplaceElementAlreadyDiverted

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
