#!/bin/bash

# @file installPathsTest.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 23 March 2021
# @brief Unit testing of installPaths.sh file. Does not implement BashUnit framework because it tests functions this framework uses.

### Exit Code
#
# 0 : Execution succeeded
# Number of failed tests otherwise
#

###
# MIT License
#
# Copyright (c) 2021 SignC0dingDw@rf
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
# Copywrong (w) 2021 SignC0dingDw@rf. All profits reserved.
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
. "${SCRIPT_LOCATION}/../../Tools/testFunctions.sh"

################################################################################
###                                                                          ###
###                                  Setup                                   ###
###                                                                          ###
################################################################################
Setup()
{
    originalPath=$(pwd)
    cd /tmp # Force root
    
    mkdir -p bar/debian
    mkdir -p bar2/debian
    mkdir -p bar3/debian
    mkdir -p bar4/debian
    touch "bar/debian/install"
    echo "contents/lib/* usr/lib/BarFoo" > "bar/debian/install"
    touch "bar3/debian/install"
    echo "contents/toto/* usr/lib/BarFoo" > "bar3/debian/install"
    touch "bar4/debian/install"
    echo "contents/bin/* usr/bin/" > "bar4/debian/install"
    echo "contents/lib/* usr/lib/Chewbacca" >> "bar4/debian/install"
    echo "contents/share/* somewhere/near/here" >> "bar4/debian/install"
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
# @brief Test InstallFileExists behavior when no argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testInstallFileExistsNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    InstallFileExists 2> /tmp/barError
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test without argument and not in package folder should return code 1 but returned code ${commandResult}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef

    ### Test command in package folder
    cd /tmp/bar
    InstallFileExists 2> /tmp/barError 
    commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument and in package folder should return code 0 but returned code ${commandResult}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test InstallFileExists behavior when empty argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testInstallFileExistsEmptyArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    InstallFileExists "" 2> /tmp/barError
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test with empty arg and not in package folder should return code 1 but returned code ${commandResult}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef

    ### Test command in package folder
    cd /tmp/bar
    InstallFileExists "" 2> /tmp/barError 
    commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test with empty arg and in package folder should return code 0 but returned code ${commandResult}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test InstallFileExists behavior when argument is package folder containing install file
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testInstallFileExistsFileExisting()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    InstallFileExists "/tmp/bar" 2> /tmp/barError
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test with package folder containing install file should return code 0 but returned code ${commandResult}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test InstallFileExists behavior when argument is package folder not containing install file
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testInstallFileExistsFileNotExisting()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    InstallFileExists "/tmp/bar2" 2> /tmp/barError
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test with package folder not containing install file should return code 1 but returned code ${commandResult}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetElemLocation behavior when no argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetElemLocationNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local libLocation="Not Updated" 
    libLocation=$(GetElemLocation 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"1\"" "Test without argument and not in package folder should return code 1 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${libLocation}\" = \"\"" "Lib location should be empty but has content ${libLocation}"
    
    printf "[Error] : No element to check for installation path\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetLibLocation behavior when no argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetLibLocationNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local libLocation="Not Updated" 
    libLocation=$(GetLibLocation 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"2\"" "Test without argument and not in package folder should return code 2 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${libLocation}\" = \"\"" "Lib location should be empty but has content ${libLocation}"
    
    printf "[Warning] : No file debian/install in . folder\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef

    ### Test command in package folder
    cd /tmp/bar
    libLocation=$(GetLibLocation 2> /tmp/barError) 
    commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument and in package folder should return code 0 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${libLocation}\" = \"/usr/lib/BarFoo\"" "Lib location should be /usr/lib/BarFoo but has content ${libLocation}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetLibLocation behavior when install file does not exist
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetLibLocationFileNotExisting()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local libLocation="Not Updated" 
    libLocation=$(GetLibLocation /tmp/bar2 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"2\"" "Test without install file in package folder should return code 2 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${libLocation}\" = \"\"" "Lib location should be empty but has content ${libLocation}"
    
    printf "[Warning] : No file debian/install in /tmp/bar2 folder\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetLibLocation behavior when install file does not contain lib
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetLibLocationNoLibInstall()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local libLocation="Not Updated" 
    libLocation=$(GetLibLocation /tmp/bar3 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"3\"" "Test with no lib element in install file should return code 3 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${libLocation}\" = \"\"" "Lib location should be empty but has content ${libLocation}"
    
    printf "[Warning] : No lib installed in package /tmp/bar3\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetLibLocation behavior when install file contains lib
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetLibLocationLibInstall()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local libLocation="Not Updated" 
    libLocation=$(GetLibLocation /tmp/bar4 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test lib in install file should return code 0 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${libLocation}\" = \"/usr/lib/Chewbacca\"" "Lib location should be /usr/lib/Chewbacca but has content ${libLocation}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetBinLocation behavior when no argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetBinLocationNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local binLocation="Not Updated" 
    binLocation=$(GetBinLocation 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"2\"" "Test without argument and not in package folder should return code 2 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${binLocation}\" = \"\"" "Bin location should be empty but has content ${binLocation}"
    
    printf "[Warning] : No file debian/install in . folder\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef

    ### Test command in package folder
    cd /tmp/bar4
    binLocation=$(GetBinLocation 2> /tmp/barError) 
    commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument and in package folder should return code 0 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${binLocation}\" = \"/usr/bin/\"" "Bin location should be /usr/bin/ but has content ${binLocation}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetBinLocation behavior when install file does not exist
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetBinLocationFileNotExisting()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local binLocation="Not Updated" 
    binLocation=$(GetBinLocation /tmp/bar2 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"2\"" "Test without install file in package folder should return code 2 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${binLocation}\" = \"\"" "Bin location should be empty but has content ${binLocation}"
    
    printf "[Warning] : No file debian/install in /tmp/bar2 folder\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetBinLocation behavior when install file does not contain bin
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetBinLocationNoBinInstall()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local binLocation="Not Updated" 
    binLocation=$(GetBinLocation /tmp/bar3 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"3\"" "Test with no bin element in install file should return code 3 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${binLocation}\" = \"\"" "Bin location should be empty but has content ${binLocation}"
    
    printf "[Warning] : No bin installed in package /tmp/bar3\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetBinLocation behavior when install file contains bin
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetBinLocationBinInstall()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local binLocation="Not Updated" 
    binLocation=$(GetBinLocation /tmp/bar4 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test lib in install file should return code 0 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${binLocation}\" = \"/usr/bin/\"" "Lib location should be /usr/bin/ but has content ${binLocation}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetShareLocation behavior when no argument is provided
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetShareLocationNoArg()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local shareLocation="Not Updated" 
    shareLocation=$(GetShareLocation 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"2\"" "Test without argument and not in package folder should return code 2 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${shareLocation}\" = \"\"" "Share location should be empty but has content ${shareLocation}"
    
    printf "[Warning] : No file debian/install in . folder\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef

    ### Test command in package folder
    cd /tmp/bar4
    shareLocation=$(GetShareLocation 2> /tmp/barError) 
    commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test without argument and in package folder should return code 0 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${shareLocation}\" = \"/somewhere/near/here\"" "Share location should be /somewhere/near/here but has content ${shareLocation}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetShareLocation behavior when install file does not exist
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetShareLocationFileNotExisting()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local shareLocation="Not Updated" 
    shareLocation=$(GetShareLocation /tmp/bar2 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"2\"" "Test without install file in package folder should return code 2 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${shareLocation}\" = \"\"" "Share location should be empty but has content ${shareLocation}"
    
    printf "[Warning] : No file debian/install in /tmp/bar2 folder\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetShareLocation behavior when install file does not contain share
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetShareLocationNoShareInstall()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local shareLocation="Not Updated" 
    shareLocation=$(GetShareLocation /tmp/bar3 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"3\"" "Test with no bin element in install file should return code 3 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${shareLocation}\" = \"\"" "Share location should be empty but has content ${shareLocation}"
    
    printf "[Warning] : No share installed in package /tmp/bar3\n" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

##!
# @brief Test GetShareLocation behavior when install file contains share
# @return 0 if behavior is as expected, 1 otherwise
#
## 
testGetShareLocationShareInstall()
{
    ### Include tested script
    testScriptInclusion "${SCRIPT_LOCATION}/../installPaths.sh" "1.0"

    ### Test command
    local shareLocation="Not Updated" 
    shareLocation=$(GetShareLocation /tmp/bar4 2> /tmp/barError)
    local commandResult=$?
    endTestIfAssertFails "\"${commandResult}\" -eq \"0\"" "Test lib in install file should return code 0 but returned code ${commandResult}"
    
    endTestIfAssertFails "\"${shareLocation}\" = \"/somewhere/near/here\"" "Share location should be /somewhere/near/here but has content ${shareLocation}"
    
    printf "" > /tmp/barErrorRef 
    TestWrittenText /tmp/barError /tmp/barErrorRef
}

################################################################################
###                                                                          ###
###                              Execute tests                               ###
###                                                                          ###
################################################################################
### Do Tests
doTest testInstallFileExistsNoArg
doTest testInstallFileExistsEmptyArg
doTest testInstallFileExistsFileExisting
doTest testInstallFileExistsFileNotExisting
doTest testGetElemLocationNoArg
doTest testGetLibLocationNoArg
doTest testGetLibLocationFileNotExisting
doTest testGetLibLocationNoLibInstall
doTest testGetLibLocationLibInstall
doTest testGetBinLocationNoArg
doTest testGetBinLocationFileNotExisting
doTest testGetBinLocationNoBinInstall
doTest testGetBinLocationBinInstall
doTest testGetShareLocationNoArg
doTest testGetShareLocationFileNotExisting
doTest testGetShareLocationNoShareInstall
doTest testGetShareLocationShareInstall

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
