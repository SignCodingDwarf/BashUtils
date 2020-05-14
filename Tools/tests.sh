#!/bin/bash

# @file tests.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# Definition of functions used by the runTests.sh script.

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

### Protection against multiple inclusions
if [ -z ${TOOLS_TESTS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_TOOLS_TESTS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_TOOLS_TESTS_SH}/../Testing/arrays.sh"
. "${SCRIPT_LOCATION_TOOLS_TESTS_SH}/../BashDwfUnit/TestSuite/testsManagement.sh"
. "${SCRIPT_LOCATION_TOOLS_TESTS_SH}/../Updating/stringContent.sh"

TOOLS_TESTS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using TOOLS_TESTS_SH=""

################################################################################
###                                                                          ###
###                            Control Variables                             ###
###                                                                          ###
################################################################################
_MODULE_ROOT="." # Path of the directory in which the modules are located. Internal. Modify using SetModuleRoot
_MODULES_LIST=() # List of modules that can be tested
_RESULT_FOLDER="" # Folder were tests results are to be stored
_MODULES_FAILED=() # List of modules which have failed tests

################################################################################
###                                                                          ###
###                                Functions                                 ###
###                                                                          ###
################################################################################
##!
# @brief Changes Module location
# @param 1 : Name of the folder in which to find the modules 
# @return 0 if root folder is updated successfully
#         1 if root folder does not exist
#
# Changes the module search folder. 
# If an error occurs (for instance, new path does not exist), previous value is kept
#
## 
SetModuleRoot()
{
    local newRoot="$1"

    if [ -d "${newRoot}" ]; then
        _MODULE_ROOT="${newRoot}"
        return 0
    else
        PrintWarning "Folder ${newRoot} does not exist. Module root remains ${_MODULE_ROOT}"
        return 1
    fi
}

##!
# @brief List all project modules
# @output The list of modules of BashUnit
# @return 0 if listing is successful, see find for other error codes
#
# A module is a folder containing a TESTS sub-folder.
# In case a folder contains other folders themselves containing a TESTS sub-folder,
# Main folder is only considered a module if it contains a TESTS sub-folder
#
## 
ListTestsFolders()
{
    find ${_MODULE_ROOT} -type d -name '*TESTS'
}

##!
# @brief Convert Test folder path to module name
# @param 1 : Test folder path
# @output converted module name
# @return 0
##
PathToModuleName()
{    
    echo $1 | sed -r "s|${_MODULE_ROOT}/||" | sed -r 's|/TESTS||' | sed -r 's|/|:|'
} 

##!
# @brief List all project modules
# @return 0
## 
ListModules()
{
    _MODULES_LIST=() # Reset modules list
    local foldersPath=$(ListTestsFolders)
    for folderPath in ${foldersPath[@]}; do
        _MODULES_LIST+=($(PathToModuleName ${folderPath}))
    done
}

##!
# @brief Print list of project modules
# @output The list of modules in module folder, 1 module per line
# @return 0
## 
PrintModulesList()
{
    printf "%s\n" "${_MODULES_LIST[@]}" 
}

##!
# @brief Check if module name is in module list
# @param 1 : Module name
# @return 0 if module is in list, >0 otherwise (see IsInArray for more details)
## 
IsInModuleList()
{
    IsInArray $1 "_MODULES_LIST"
}

##!
# @brief Convert Module name to test folder path
# @param 1 : Module name
# @output Converted folder path
# @return 0
##
ModuleNameToPath()
{    
    local modulePath=$(echo $1 | sed -r 's|:|/|')
    modulePath="${_MODULE_ROOT}/${modulePath}/TESTS/"
    echo "${modulePath}"
} 

##!
# @brief Create folder that will contain test results
# @param 1 : Source folder
# @return 0 if folder was successfully created
#         1 if source folder does not exist
#         2 if creation of folder failed
#
# Creates the folder $1/BashUnit_yyyy_mm_dd_hh_mm_ss/
#
## 
CreateResultFolder()
{
    local sourceFolder="$1"

    # Check argument
    if [ ! -d "${sourceFolder}" ]; then
        PrintError "The folder ${sourceFolder} does not exist. Cannot create test results folder"
        return 1
    fi
    sourceFolder=$(AddSuffix "${sourceFolder}" "/")

    # Current Date and time
    local currentDate=$(printf '%(%Y_%m_%d_%H_%M_%S)T')

    # Create folder
    _RESULT_FOLDER="${sourceFolder}/BashUnit_${currentDate}/"
    mkdir ${_RESULT_FOLDER}
    local creationResult=$?
    if [ "${creationResult}" -ne "0" ]; then
        PrintError "Failed to create folder ${_RESULT_FOLDER} with error ${creationResult}"
        return 2
    fi

    return 0
}

##!
# @brief Run tests of module
# @param 1 : Module name
# @return 0 if test could be run
#         1 if module name is empty
## 
TestModule()
{
    # Process argument
    local moduleName="$1"
    if [ -z "${moduleName}" ]; then
        PrintWarning "A module name must be specified"
        return 1
    fi  

    # List of test files to run
    local modulePath=$(ModuleNameToPath "${moduleName}")
    local filesTested=$(ls "${modulePath}" | grep ".sh") # List all scripts in test folder
    
    # Initialize test suite
    DeclareTestSuite "Module ${moduleName}"

    # Create test function for each file
    for fileTested in ${filesTested[@]}; do
        local functionName=$(echo ${fileTested} | sed -r 's|.sh||') # Function has name of test file without extension
        eval "${functionName}() { ${modulePath}/${fileTested}; }"
        AddTests ${functionName} # Add created function to test suite
    done
    
    # Execute all tests in suite
    RunAllTests

    # DisplayResults
    local fileName=$(echo ${moduleName} | sed -r 's| |_|' | sed -r 's|:|_|')
    DisplayTestSuiteExeSummary > "${_RESULT_FOLDER}/${fileName}.result"
    return 0
}

##!
# @brief Display stored execution result of module
# @param 1 : Module name
# @return 0 if result could be displayed
#         1 if module name is empty
## 
PrintModuleResult()
{
    # Process argument
    local moduleName="$1"
    if [ -z "${moduleName}" ]; then
        PrintWarning "A module name must be specified"
        return 1
    fi  

    # Compute result file
    local fileName=$(echo ${moduleName} | sed -r 's| |_|' | sed -r 's|:|_|')
    local resultFile="${_RESULT_FOLDER}/${fileName}.result"
        
    # Check failure
    cat ${resultFile} | grep -q "KO" # Look for any KO in file
    if [ "$?" -eq "0" ]; then # KO found
        _MODULES_FAILED+=(${moduleName})
    fi 

    # Display result
    cat ${resultFile}
}

##!
# @brief Display Summary of modules execution
# @output Either a success message or the list of failed modules
# @return 0 
## 
PrintExecutionSummary()
{
    if [ "${#_MODULES_FAILED[@]}" -eq "0" ]; then
        local format='\033[1;32m'
        printf "${format}All Tests are successful${NF}\n"
    else
        local format='\033[1;31m'
        printf "${format}The following modules have failed tests :\n%s${NF}\n" "${_MODULES_FAILED[@]}"
    fi
}

fi # TOOLS_TESTS_SH

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
