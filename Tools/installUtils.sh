#!/bin/bash

# @file installUtils.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 30 March 2020
# Definition of functions used by the install.sh script.

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
if [ -z ${INSTALLUTILS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_INSTALLUTILS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_INSTALLUTILS_SH}/../Testing/arrays.sh"
. "${SCRIPT_LOCATION_INSTALLUTILS_SH}/../BashDwfUnit/TestSuite/testsManagement.sh"
. "${SCRIPT_LOCATION_INSTALLUTILS_SH}/../Updating/stringContent.sh"

INSTALLUTILS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using INSTALLUTILS_SH=""

################################################################################
###                                                                          ###
###                            Control Variables                             ###
###                                                                          ###
################################################################################

################################################################################
###                                                                          ###
###                                Functions                                 ###
###                                                                          ###
################################################################################
##!
# @brief Clean up currently installed version
# @return 0 if previous installation was successfully deleted or if there is no previous version to delete
#         1 if deletion failed
#
# It is assumed a previous version exists if installation path variable BASH_UTILS_LIB exists.
# The content of this variable is the folder that will be deleted.
#
## 
InstallCleanUp()
{
    if [ -n "${BASH_UTILS_LIB}" ]; then
        PrintInfo "Uninstalling previous installation by deleting folder ${BASH_UTILS_LIB}"
        rm -r ${BASH_UTILS_LIB}
        local executionResult=$?
        if [ "${executionResult}" -ne "0" ]; then
            PrintError "Failed to uninstall previous installation located at ${BASH_UTILS_LIB} with error ${executionResult}."
            PrintError "Uninstall it manually, delete BASH_UTILS_LIB content and try again"
            return 1
        else
            return 0
        fi
    else
        PrintInfo "No previously installed version to uninstall"
        return 0
    fi
}

##!
# @brief Create install directory
# @param 1 : Location where install directory will be created
# @return 0 if install directory has been created
#         1 if install location does not exist
#         2 if install driectory already exists
#         3 if creation failed
#
# It is assumed a previous version exists if installation path variable BASH_UTILS_LIB exists.
# The content of this variable is the folder that will be deleted.
#
## 
CreateInstallDirectory()
{
    local installLocation="$1"
    installLocation=$(AddSuffix "${installLocation}" "/")
    if [ ! -d "${installLocation}" ]; then
        PrintError "Desired install location ${installLocation} does not exist"
        return 1
    fi
    
    local installDirectory="${installLocation}BashUtils"
    if [ -d "${installDirectory}" ]; then
        PrintError "Install directory ${installDirectory} already exists. Aborting"
        return 2
    fi

    mkdir ${installDirectory}
    local executionResult=$? 
    if [ "${executionResult}" -ne "0" ]; then
        PrintError "Failed to created installation directory ${installDirectory} with error ${executionResult}."
        return 3
    else
        return 0
    fi
}

##!
# @brief Copy files to install directory
# @param 1 : Location where install directory is located
# @param 2 : Location of files to install
# @return 0 if copy went fine
#         1 if install location does not exist
#         2 if location of files to copy does not exist 
#         3 if copy failed
#
# It is assumed a previous version exists if installation path variable BASH_UTILS_LIB exists.
# The content of this variable is the folder that will be deleted.
#
## 
CopyContentToInstallDirectory()
{
    ### Check argument
    local installLocation="$1"
    installLocation=$(AddSuffix "${installLocation}" "/")
    installLocation="${installLocation}BashUtils"
    if [ ! -d "${installLocation}" ]; then
        PrintError "Desired install location ${installLocation} does not exist"
        return 1
    fi
    
    local filesLocation="$2"
    filesLocation=$(AddSuffix "${filesLocation}" "/")
    if [ ! -d "${filesLocation}" ]; then
        PrintError "Location of files to install ${filesLocation} does not exist"
        return 2
    fi
    
    ### If verbose execution, run cp in verbose mode
    local verbosityFlag=""
    if [ "${VERBOSE}" = true ]; then
        verbosityFlag="-v"
    fi

    cp -r ${verbosityFlag} ${filesLocation}* ${installLocation}
    local executionResult=$? 
    if [ "${executionResult}" -ne "0" ]; then
        PrintError "Failed to copy content of ${filesLocation} to ${installLocation} with error ${executionResult}."
        return 3
    else
        return 0
    fi
}

##!
# @brief Create reference to install directory location for use by dependencies
# @param 1 : Location where install directory is located
# @return 0 if reference is well created
#         1 if install location does not exist
#         2 if .bashrc does not exist
#         3 if write to .bashrc failed
#
# The variable BASH_UTILS_LIB is created or updated with the appropriate content.
#
## 
CreateInstallDirectoryReference()
{
    ### Check argument
    local installLocation="$1"
    installLocation=$(AddSuffix "${installLocation}" "/")
    installLocation="${installLocation}BashUtils"
    if [ ! -d "${installLocation}" ]; then
        PrintError "Desired install location ${installLocation} does not exist"
        return 1
    fi
    
    ### Check that ${HOME}/.bashrc exists
    if [ ! -f "${HOME}/.bashrc" ]; then
        PrintError "${HOME}/.bashrc file does not exist"
        return 2
    fi

    ### Check if content exists in .bashrc
    grep "${HOME}/.bashrc" -q -e "export BASH_UTILS_LIB=.*" # Use grep to know if it exists
    local referenceAlreadyExists="$?"
    if [ "${referenceAlreadyExists}" -eq "0" ]; then
        PrintInfo "Replacing previous entry of BASH_UTILS_LIB in ${HOME}/.bashrc by new install location"
        sed -i "s|export BASH_UTILS_LIB=.*|export BASH_UTILS_LIB=${installLocation}|g" ~/.bashrc
    else
        PrintInfo "Adding BASH_UTILS_LIB to ${HOME}/.bashrc"
        echo -e "\n## BashUtils location" >> ~/.bashrc
		echo "export BASH_UTILS_LIB=${installLocation}" >> ~/.bashrc 
    fi

    ### Check new value is correctly written to .bashrc
    grep "${HOME}/.bashrc" -q -e "export BASH_UTILS_LIB=${installLocation}" # Use grep to know if it exists 
    referenceAlreadyExists="$?"
    if [ "${referenceAlreadyExists}" -eq "0" ]; then
        PrintInfo "Successfully set BASH_UTILS_LIB"
        PrintInfo "Do"
        PrintInfo "   source ${HOME}/.bashrc"
        PrintInfo "to use it straightaway"
        return 0
    else
        PrintError "Setting of BASH_UTILS_LIB in ${HOME}/.bashrc failed"
        return 3
    fi
}

fi # INSTALLUTILS_SH

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
