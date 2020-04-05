#!/bin/bash

# file :  declareDeletionTest.sh
# author : SignC0dingDw@rf
# version : 1.0
# date : 12 January 2020
# Unit testing of declareDeletion.sh file.

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
    ### Initialize lists
    ELEMENTS_CREATED=()

    ### Create folders
    mkdir /tmp/toto
    mkdir /tmp/foo

    ### Create files
    touch /tmp/foo/bar1
    touch /tmp/foo/bar2

    return 0    
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    ELEMENTS_CREATED=()

    rm -f /tmp/bar*
    rm -rf /tmp/toto*
    rm -rf /tmp/foo*

    return 0
}

################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check DeclElementsToDel behavior if no input is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclElementsToDelNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclElementsToDel 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Error] : You should specify elements to delete\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclElementsToDel behavior with standard input
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclElementsToDelNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Add a few variables
    DeclElementsToDel "/tmp/foo" "/tmp/bar" "/tmp/tutu" > /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo" "/tmp/bar" "/tmp/tutu")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Add a variable
    DeclElementsToDel "../tmp/tuto" > /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo" "/tmp/bar" "/tmp/tutu" "../tmp/tuto")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFoldersToDel behavior if no input is provided 
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFoldersToDelNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFoldersToDel 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Error] : You should specify folders to create\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFoldersToDel behavior with standard input
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFoldersToDelNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFoldersToDel "/tmp/toto2" "/tmp/foo3" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("/tmp/toto2" "/tmp/foo3")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/" "foo" "foo" "foo3"
    CheckDirContent "/tmp/" "toto" "toto" "toto2"

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Create a single folder
    DeclMkFoldersToDel "/tmp/toto3" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("/tmp/toto2" "/tmp/foo3" "/tmp/toto3")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/" "foo" "foo" "foo3"
    CheckDirContent "/tmp/" "toto" "toto" "toto2" "toto3"

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFoldersToDel behavior if some folders to create already exist
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFoldersToDelExistingFolders()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFoldersToDel "/tmp/toto2" "/tmp/foo" "/tmp/toto" "/tmp/foo3" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local referenceArray=("/tmp/toto2" "/tmp/foo3")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/" "foo" "foo" "foo3"
    CheckDirContent "/tmp/" "toto" "toto" "toto2"

    printf "mkdir: cannot create directory '/tmp/foo': File exists\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/foo directory with code 1\n" >> /tmp/barErrorRef
    printf "mkdir: cannot create directory '/tmp/toto': File exists\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/toto directory with code 1\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFoldersToDel behavior if some folders have no path loading to them
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFoldersToDelNoPaths()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFoldersToDel "/tmp/NotExisting/CannotBeCreated" "/tmp/bar/foo" "/tmp/foo3" "DOESNOTEXIST/CRITICALFAILURE" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"3\" " "Expected function to exit with code 3 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo3")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/" "foo" "foo" "foo3"
    CheckDirContent "/tmp/" "toto" "toto"

    printf "mkdir: cannot create directory '/tmp/NotExisting/CannotBeCreated': No such file or directory\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/NotExisting/CannotBeCreated directory with code 1\n" >> /tmp/barErrorRef
    printf "mkdir: cannot create directory '/tmp/bar/foo': No such file or directory\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/bar/foo directory with code 1\n" >> /tmp/barErrorRef
    printf "mkdir: cannot create directory 'DOESNOTEXIST/CRITICALFAILURE': No such file or directory\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to create DOESNOTEXIST/CRITICALFAILURE directory with code 1\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFoldersToDel behavior if some folders to create already exist as files
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFoldersToDelExistingFiles()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFoldersToDel "/tmp/foo/bar1" "/tmp/foo/bar2" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local referenceArray=()
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/" "foo" "foo"
    CheckDirContent "/tmp/" "toto" "toto"

    printf "mkdir: cannot create directory '/tmp/foo/bar1': File exists\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/foo/bar1 directory with code 1\n" >> /tmp/barErrorRef
    printf "mkdir: cannot create directory '/tmp/foo/bar2': File exists\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/foo/bar2 directory with code 1\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFilesToDel behavior if no input is provided 
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFilesToDelNoInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFilesToDel 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    printf "[Error] : You should specify files to create\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFilesToDel behavior with standard input
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFilesToDelNominalInput()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFilesToDel "/tmp/foo/bar3" "/tmp/foo/bar4" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo/bar3" "/tmp/foo/bar4")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/foo" "bar" "bar1" "bar2" "bar3" "bar4"
    CheckDirContent "/tmp/toto" "bar" ""

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef

    ### Create a single folder
    DeclMkFilesToDel "/tmp/toto/bar2" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"0\" " "Expected function to exit with code 0 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo/bar3" "/tmp/foo/bar4" "/tmp/toto/bar2")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/foo" "bar" "bar1" "bar2" "bar3" "bar4"
    CheckDirContent "/tmp/toto" "bar" "bar2"

    printf "" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFilesToDel behavior if some folders to create already exist
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFilesToDelExistingFolders()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFilesToDel "/tmp/foo" "/tmp/foo/bar3" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"1\" " "Expected function to exit with code 1 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo/bar3")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/foo" "bar" "bar1" "bar2" "bar3"

    printf "[Warning] : File /tmp/foo already exists. It should be diverted.\n" > /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFilesToDel behavior if some files have no path leading to them
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFilesToDelNoPaths()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFilesToDel "/tmp/NotExisting/CannotBeCreated" "/tmp/foo/bar3" "DOESNOTEXIST/CRITICALFAILURE" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local referenceArray=("/tmp/foo/bar3")
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/foo" "bar" "bar1" "bar2" "bar3"

    printf "touch: cannot touch '/tmp/NotExisting/CannotBeCreated': No such file or directory\n" > /tmp/barErrorRef
    printf "[Warning] : Failed to create /tmp/NotExisting/CannotBeCreated file with code 1\n" >> /tmp/barErrorRef
    printf "touch: cannot touch 'DOESNOTEXIST/CRITICALFAILURE': No such file or directory\n" >> /tmp/barErrorRef
    printf "[Warning] : Failed to create DOESNOTEXIST/CRITICALFAILURE file with code 1\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

##!
# @brief Check DeclMkFilesToDel behavior if some folders to create already exist as files
# @return 0 if behavior is as expected, exit 1 otherwise
#
## 
TestDeclMkFilesToDelExistingFiles()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../declareDeletion.sh" "1.0"

    ### Test command
    DeclMkFilesToDel "/tmp/foo/bar1" "/tmp/foo/bar2" 2> /tmp/barErrorOutput
    local test_result=$?
    endTestIfAssertFails "\"${test_result}\" -eq \"2\" " "Expected function to exit with code 2 but exited with code ${test_result}"

    local referenceArray=()
    CheckArrayContent ELEMENTS_CREATED referenceArray

    CheckDirContent "/tmp/foo" "bar" "bar1" "bar2"

    printf "[Warning] : File /tmp/foo/bar1 already exists. It should be diverted.\n" > /tmp/barErrorRef
    printf "[Warning] : File /tmp/foo/bar2 already exists. It should be diverted.\n" >> /tmp/barErrorRef
    TestWrittenText /tmp/barErrorOutput /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# DeclElementsToDel
doTest TestDeclElementsToDelNoInput
doTest TestDeclElementsToDelNominalInput

# DeclMkFoldersToDel
doTest TestDeclMkFoldersToDelNoInput
doTest TestDeclMkFoldersToDelNominalInput
doTest TestDeclMkFoldersToDelExistingFolders
doTest TestDeclMkFoldersToDelNoPaths
doTest TestDeclMkFoldersToDelExistingFiles

# DeclMkFilesToDel
doTest TestDeclMkFilesToDelNoInput
doTest TestDeclMkFilesToDelNominalInput
doTest TestDeclMkFilesToDelExistingFolders
doTest TestDeclMkFilesToDelNoPaths
doTest TestDeclMkFilesToDelExistingFiles

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
