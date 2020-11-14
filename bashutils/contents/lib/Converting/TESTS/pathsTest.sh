#!/bin/bash

# @file pathsTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 15 May 2020
# @brief Unit testing of paths.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

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
. "${SCRIPT_LOCATION}/../../Tools/TESTS/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    originalPath=$(pwd)
    cd /tmp # Force root
    
    mkdir -p bar/bar2
    touch bar/foo
    mkdir bar5
    ln -sf bar5 bar3
    mkdir bar3/bar4
}

################################################################################
###                                                                          ###
###                                 Cleanup                                  ###
###                                                                          ###
################################################################################
Cleanup()
{
    rm -rf /tmp/bar*
    cd ${originalPath}
}


################################################################################
###                                                                          ###
###                              Declare Tests                               ###
###                                                                          ###
################################################################################
##!
# @brief Test ToAbsolutePath behavior when no argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsolutePathNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"\"" "Absolute path should be empty but has content ${absolutePath}"
    
    printf "[Error] : Path  does not exist\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"
}

##!
# @brief Test ToAbsolutePath behavior with argument not having a valid path
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsolutePathNotValidPath()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "../oooups/" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"\"" "Absolute path should be empty but has content ${absolutePath}"
    
    printf "[Error] : Path ../oooups/ does not exist\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"
}

##!
# @brief Test ToAbsolutePath behavior with argument being a file and default system path resolution method used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteDefaultFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "../tmp/bar/foo" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar/foo\"" "Absolute path should be /tmp/bar/foo but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef

    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being a folder and default system path resolution method used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteDefaultFolder()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "bar3/bar4/./.." 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar5\"" "Absolute path should be /tmp/bar5 but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being an absolute path and default system path resolution method used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteDefaultAbsolute()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "/tmp/bar" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar\"" "Absolute path should be /tmp/bar but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being a file and realpath method not used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteNoRealpathFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Force IsCommand to ignore realpath
    IsCommand()
    {
        if [ "$1" = "realpath" ]; then
            return 1
        fi
        command -v "${1}" > /dev/null
    }

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "../tmp/bar/foo" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar/foo\"" "Absolute path should be /tmp/bar/foo but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being a folder and realpath method not used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteNoRealpathFolder()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Force IsCommand to ignore realpath
    IsCommand()
    {
        if [ "$1" = "realpath" ]; then
            return 1
        fi
        command -v "${1}" > /dev/null
    }

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "bar3/bar4/./.." 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar5\"" "Absolute path should be /tmp/bar5 but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being an absolute path and realpath method not used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteNoRealpathAbsolute()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Force IsCommand to ignore realpath
    IsCommand()
    {
        if [ "$1" = "realpath" ]; then
            return 1
        fi
        command -v "${1}" > /dev/null
    }

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "/tmp/bar" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar\"" "Absolute path should be /tmp/bar but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}


##!
# @brief Test ToAbsolutePath behavior with argument being a file and realpath or readlink not used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteNoFunctionFile()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Force IsCommand to ignore realpath
    IsCommand()
    {
        return 1
    }

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "../tmp/bar/foo" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar/foo\"" "Absolute path should be /tmp/bar/foo but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being a folder and realpath or readlink not used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteNoFunctionFolder()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Force IsCommand to ignore realpath
    IsCommand()
    {
        return 1
    }

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "bar3/bar4/./.." 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar5/\"" "Absolute path should be /tmp/bar5/ but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

##!
# @brief Test ToAbsolutePath behavior with argument being an absolute path and realpath or readlink not used
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testToAbsoluteNoFunctionAbsolute()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../paths.sh" "1.0"

    ### Force IsCommand to ignore realpath
    IsCommand()
    {
        return 1
    }

    ### Test command
    local absolutePath="Not Updated"
    absolutePath=$(ToAbsolutePath "/tmp/bar" 2> /tmp/barError) 
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${absolutePath}\" = \"/tmp/bar/\"" "Absolute path should be /tmp/bar/ but has content ${absolutePath}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
    
    ### Current path is still /tmp
    local currentPath=`pwd`
    endTestIfAssertFails "\"${currentPath}\" = \"/tmp\"" "Current path should be /tmp but has content ${currentPath}"    
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest testToAbsolutePathNoArg
doTest testToAbsolutePathNotValidPath
doTest testToAbsoluteDefaultFile
doTest testToAbsoluteDefaultFolder
doTest testToAbsoluteDefaultAbsolute
doTest testToAbsoluteNoRealpathFile
doTest testToAbsoluteNoRealpathFolder
doTest testToAbsoluteNoRealpathAbsolute
doTest testToAbsoluteNoFunctionFile
doTest testToAbsoluteNoFunctionFolder
doTest testToAbsoluteNoFunctionAbsolute

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
