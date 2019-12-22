#!/bin/bash

# @file runTests.sh
# @author SignC0dingDw@rf
# @version 0.2
# @date 23 December 2019
# @brief Script allowing to run tests scripts in all BashUtils modules and display results

### Exit Code
#
# 0 
#

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

### Get script location
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

### Functions
##!
# @brief List all TESTS folders
# @output The list of TESTS folders of BashUnit
# @return 0 if test is successful, see find for other error codes
#
## 
ListTestFolderPaths()
{
    find ${SCRIPT_LOCATION} -type d -name '*TESTS' | grep -v "${SCRIPT_LOCATION}/TESTS" # Ignore TESTS folder not in a module because it only contains help utils
}

### Functions
##!
# @brief Convert a test folder to module
# @input 1 : Test folder path
# @output The module name. If module has submodule (i.e. subdirectories), submodules are separated by ":"
# @return 0 if test is successful, see find for other error codes
#
## 
TestFolderToModule()
{
    echo $1 | sed -r "s|${SCRIPT_LOCATION}/||" | sed -r 's|/TESTS||' | sed -r 's|/|:|'
}

################################################################################
###                                                                          ###
###                                Main Loop                                 ###
###                                                                          ###
################################################################################
### List test folders
TEST_FOLDERS=$(ListTestFolderPaths)

### Result control variables
TESTS_NAMES=()
TESTS_RESULTS=()

### Run tests
for test_folder in ${TEST_FOLDERS}; do
    MODULE=$(TestFolderToModule ${test_folder}) # Get module name from test folder
    printf "****** Running tests of module ${MODULE} ******\n"
    ## List test files
    TEST_FILES=$(ls ${test_folder}/*.sh)
    for test_file in ${TEST_FILES}; do
        (. ${test_file}) # Displays the output but does not exit when a test ends
        TEST_RESULT=$?
        TESTS_NAMES+=("${MODULE}:${test_file##*/}") # Add running test tests list with only file path
        TESTS_RESULTS+=("${TEST_RESULT}") # Add result to results list
    done
done

### Display tests summary
for index in "${!TESTS_NAMES[@]}"; do 
    printf "KO for Test ${TESTS_NAMES[${index}]} = ${TESTS_RESULTS[${index}]}\n"
done

exit 0

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
