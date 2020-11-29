#!/bin/bash

# @file filesTest.sh
# @author SignC0dingDw@rf
# @version 1.2
# @date 29 November 2020
# @brief Unit testing of files.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
. "${SCRIPT_LOCATION}/../../Tools/testUtils.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    # Test folders
    mkdir /tmp/foo
    ln -sf /tmp/foo /tmp/fooLN

    # Test files
    touch /tmp/bar1
    ln -sf /tmp/bar1 /tmp/bar2

    touch /tmp/bar3
    echo "Foo" >> /tmp/bar3
    echo "Bar" >> /tmp/bar3
    echo "Yet another line" >> /tmp/bar3
   
    touch /tmp/bar4
    echo "Not the same line" >> /tmp/bar4
    echo "Bar" >> /tmp/bar4
    echo "Yet another different line" >> /tmp/bar4

    touch /tmp/bar5
    echo "Foo" >> /tmp/bar5
    echo "Bar" >> /tmp/bar5
    echo "Yet another line" >> /tmp/bar5
    
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
    rm -f /tmp/bar*
    return 0
}


################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Check isFilePath behavior if no argument is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath 
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "isFilePath with no argument should return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if provided argument is empty string
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath ""
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "isFilePath of empty string should return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if provided argument is an unexisting element
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathUnexistingElement()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/UnexistingElement"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "isFilePath of unexisting element should return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if provided argument is not a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathNotFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/foo"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "isFilePath of non file argument should return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if provided argument is a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/bar1"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "isFilePath of file argument should return code 0 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if provided argument is a symlink to an element which is not a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathSymlinkNotFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/fooLN"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "isFilePath of non file symlink should return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if provided argument is a symlink to a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathSymlinkFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/bar2"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "isFilePath of file symlink should return code 0 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if multiple arguments are provided and first one is not a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathNotFileMultipleArgs()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/foo" "/tmp/bar1"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "isFilePath should ignore second argument and return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check isFilePath behavior if multiple arguments are provided and first one is a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testIsFilePathFileMultipleArgs()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    isFilePath "/tmp/bar1" "/tmp/notAFile"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "isFilePath should ignore second argument and return code 0 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check areFilesIdentical behavior if no argument is provided
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAreFilesIdenticalNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    areFilesIdentical 
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"2\"" "areFilesIdentical with no argument should return code 2 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check areFilesIdentical behavior if second argument is missing
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAreFilesIdenticalMissingArg2()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    areFilesIdentical  "/tmp/bar3"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"3\"" "areFilesIdentical with no second argument should return code 3 but returned code ${COMMAND_RESULT}"
}


##!
# @brief Check areFilesIdentical behavior if first argument is not a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAreFilesIdenticalArg1NotFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    areFilesIdentical  "/tmp/foo" "/tmp/bar3"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"2\"" "areFilesIdentical with first argument not a file should return code 2 but returned code ${COMMAND_RESULT}"
}


##!
# @brief Check areFilesIdentical behavior if second argument is not a file
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAreFilesIdenticalArg2NotFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    areFilesIdentical  "/tmp/bar3" "/tmp/NOTAFILE"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"3\"" "areFilesIdentical with second argument not a file should return code 3 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check areFilesIdentical behavior if files are different
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAreFilesIdenticalFilesDifferent()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    areFilesIdentical  "/tmp/bar3" "/tmp/bar4"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"1\"" "areFilesIdentical with different files should return code 1 but returned code ${COMMAND_RESULT}"
}

##!
# @brief Check areFilesIdentical behavior if files are identical
# @return 0 if behavior is as expected, exit 1 otherwise
#
##
testAreFilesIdenticalFilesIdentical()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../files.sh" "1.1"

    ### Call command
    areFilesIdentical  "/tmp/bar3" "/tmp/bar5"
    local COMMAND_RESULT=$?
    endTestIfAssertFails "\"${COMMAND_RESULT}\" -eq \"0\"" "areFilesIdentical with identical files should return code 0 but returned code ${COMMAND_RESULT}"
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
# isFilePath
doTest testIsFilePathNoArg
doTest testIsFilePathEmptyArg
doTest testIsFilePathUnexistingElement
doTest testIsFilePathNotFile
doTest testIsFilePathFile
doTest testIsFilePathSymlinkNotFile
doTest testIsFilePathSymlinkFile
doTest testIsFilePathNotFileMultipleArgs
doTest testIsFilePathFileMultipleArgs

# areFilesIdentical
doTest testAreFilesIdenticalNoArg
doTest testAreFilesIdenticalMissingArg2
doTest testAreFilesIdenticalArg1NotFile
doTest testAreFilesIdenticalArg2NotFile
doTest testAreFilesIdenticalFilesDifferent
doTest testAreFilesIdenticalFilesIdentical

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
