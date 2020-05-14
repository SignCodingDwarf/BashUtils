#!/bin/bash

# @file inclusions.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# @brief Definition of a set of macros used to check inclusion of files.

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
if [ -z ${ASSERT_INCLUSIONS_SH} ]; then

### Inclusions
SCRIPT_LOCATION_PRINT_ASSERT_INCLUSIONS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_ASSERT_INCLUSIONS_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_ASSERT_INCLUSIONS_SH}/assertUtils.sh"
. "${SCRIPT_LOCATION_PRINT_ASSERT_INCLUSIONS_SH}/../../Testing/files.sh"

ASSERT_INCLUSIONS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using ASSERT_INCLUSIONS_SH=""

##!
# @brief Turns a script path to the name of the corresponding inclusion control variable
# @param 1 : Script path
# @ouput Name of inclusion control variable
# @return 0 if extraction was successful
#         1 if no file path has been provided
#         2 if file path ends with / (i.e. not a valid character)
#
# File name allowed characters are letters, numbers, ., _ and -. 
# All other characters are ignored since they should not be in a script name.
#
## 
filePathToInclusionVariable()
{
    local filePath="$1"
    if [ -z "${filePath}" ]; then
        return 1
    fi

    if [[ "${filePath}" == */ ]]; then
        return 2
    fi
    local absolutePath=$(readlink -f "${filePath}")
    
    local moduleName=$(basename $(dirname "${absolutePath}")) # Get module name as directory containing file
    local fileName=$(basename ${filePath}) # Get filename with extension from path

    echo "${moduleName}_${fileName}" | tr . _ | tr - _ | tr a-z A-Z # Replaces extension's . by _, any - by _ and then does toupper (could use ${variable^^} but this is Bash>4.0 only and we don't have any special characters here that we don't have already replaced)

    return 0
}

##!
# @brief Checks that a bash file has not been already included
# @param 1 : File tested
# @return 0 if file is not included, exit 1 otherwise
#
# Check that a bash script has not been already included.
# The concerned files must use control inclusion variables defined in the format presented in this file.
# Returns the following error message :
# File @param_1 is already included
# Inclusion control variable ${controlVariableName} has value ${controlVariableContent}
#
##
ASSERT_FILE_NOT_INCLUDED()
{
    local fileTested="$1"
    local errorMessage=""

    if [ -z "${fileTested}" ]; then # File tested should not be empty
        errorMessage="Problem on provided arguments. Usage:${lineDelimiter}ASSERT_FILE_NOT_INCLUDED <file_tested>${lineDelimiter}"
        EndTestOnFailure "${errorMessage}"
    fi

    # Check the tested file is indeed a file
    isFilePath "${fileTested}"
    if [ "$?" -ne "0" ]; then
        errorMessage="File ${fileTested} is not a file"
        EndTestOnFailure "${errorMessage}"
    fi    

    # Compute variable name corresponding to file name
    local controlVariableName=""    
    controlVariableName=$(filePathToInclusionVariable "${fileTested}")
    if [ "$?" -ne "0" ]; then
        errorMessage="Cannot convert ${fileTested} to the associated inclusion control variable"
        EndTestOnFailure "${errorMessage}"
    fi      
    # Get associated content
    local controlVariableContent="${!controlVariableName}"

    # Check variable is empty
    if [ -n "${controlVariableContent}" ]; then
        errorMessage="File ${fileTested} is already included.\nInclusion control variable ${controlVariableName} has value ${controlVariableContent}"
        EndTestOnFailure "${errorMessage}"
    else
        return 0
    fi
}

##!
# @brief Checks that a bash file has already been included
# @param 1 : File tested
# @return 0 if file is not included, exit 1 otherwise
#
# Check that a bash script has been included.
# The concerned files must use control inclusion variables defined in the format presented in this file.
# Returns the following error message :
# File @param_1 is not included
#
##
ASSERT_FILE_INCLUDED()
{
    local fileTested="$1"
    local errorMessage=""

    if [ -z "${fileTested}" ]; then # File tested should not be empty
        errorMessage="Problem on provided arguments. Usage:${lineDelimiter}ASSERT_FILE_NOT_INCLUDED <file_tested>${lineDelimiter}"
        EndTestOnFailure "${errorMessage}"
    fi

    # Check the tested file is indeed a file
    isFilePath "${fileTested}"
    if [ "$?" -ne "0" ]; then
        errorMessage="File ${fileTested} is not a file"
        EndTestOnFailure "${errorMessage}"
    fi    

    # Compute variable name corresponding to file name
    local controlVariableName=""    
    controlVariableName=$(filePathToInclusionVariable "${fileTested}")
    if [ "$?" -ne "0" ]; then
        errorMessage="Cannot convert ${fileTested} to the associated inclusion control variable"
        EndTestOnFailure "${errorMessage}"
    fi      
    # Get associated content
    local controlVariableContent="${!controlVariableName}"

    # Check variable is not empty
    if [ -z "${controlVariableContent}" ]; then
        errorMessage="File ${fileTested} is not included"
        EndTestOnFailure "${errorMessage}"
    else
        return 0
    fi
}

##!
# @brief Checks that a bash file has already been included with a given version
# @param 1 : File tested
# @param 2 : Expected version
# @return 0 if file is not included, exit 1 otherwise
#
# Check that a bash script has been included.
# The concerned files must use control inclusion variables defined in the format presented in this file.
# Returns the following error message :
# File @param_1 is not correctly included
# Expected : @param_2
# Got : ${controlVariableContent}
#
##
ASSERT_FILE_INCLUDED_WITH_VERSION()
{
    local fileTested="$1"
    local expectedVersion="$2"
    local errorMessage=""

    if [ -z "${fileTested}" -o -z "${expectedVersion}" ]; then # Arguments should have value
        errorMessage="Problem on provided arguments. Usage:${lineDelimiter}ASSERT_FILE_INCLUDED_WITH_VERSION <file_tested> <expected_version>${lineDelimiter}"
        EndTestOnFailure "${errorMessage}"
    fi

    # Check the tested file is indeed a file
    isFilePath "${fileTested}"
    if [ "$?" -ne "0" ]; then
        errorMessage="File ${fileTested} is not a file"
        EndTestOnFailure "${errorMessage}"
    fi    

    # Compute variable name corresponding to file name
    local controlVariableName=""    
    controlVariableName=$(filePathToInclusionVariable "${fileTested}")
    if [ "$?" -ne "0" ]; then
        errorMessage="Cannot convert ${fileTested} to the associated inclusion control variable"
        EndTestOnFailure "${errorMessage}"
    fi      
    # Get associated content
    local controlVariableContent="${!controlVariableName}"

    # Check variable is not empty
    if [ "${controlVariableContent}" != "${expectedVersion}" ]; then
        errorMessage="File ${fileTested} is not correctly included\nExpected : ${expectedVersion}\nGot : ${controlVariableContent}\n"
        EndTestOnFailure "${errorMessage}"
    else
        return 0
    fi
}

##!
# @brief Includes a bash script and asserts that it has been included with the correct version.
# @param 1 : File tested
# @param 2 : Expected version
# @return 0 if file is not included, exit 1 otherwise
#
# Include a bash script and check that it has been included with correct version.
# Note that script inclusion means sourcing it in this context.
# The concerned files must use control inclusion variables defined in the format presented in this file.
# Before inclusion, the macro tests that the file has not already been included.
#
##
INCLUDE_AND_ASSERT_VERSION()
{
    local fileTested="$1"
    local expectedVersion="$2"
    local errorMessage=""

    if [ -z "${fileTested}" -o -z "${expectedVersion}" ]; then # Arguments should have value
        errorMessage="Problem on provided arguments. Usage:${lineDelimiter}INCLUDE_AND_ASSERT_VERSION <file_tested> <expected_version>${lineDelimiter}"
        EndTestOnFailure "${errorMessage}"
    fi

    # No need to check fileTested is a file because this is performed by functions called below
    # Check file is not already included
    ASSERT_FILE_NOT_INCLUDED "${fileTested}"

    # Inclusion
    . "${fileTested}"
    local returnCode="$?"
    if [ "${returnCode}" -ne "0" ]; then
        errorMessage="Inclusion of file ${fileTested} failed with error ${returnCode}"
        EndTestOnFailure "${errorMessage}"
    fi

    # Check inclusion 
    ASSERT_FILE_INCLUDED_WITH_VERSION "${fileTested}" "${expectedVersion}"
}

fi # ASSERT_INCLUSIONS_SH

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
