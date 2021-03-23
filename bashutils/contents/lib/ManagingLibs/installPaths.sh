#!/bin/bash

# @file installPaths.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 22 March 2021
# @brief Definition of utilitaries used to create install path variables in .bashrc file and update them.

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

### Protection against multiple inclusions
if [ -z ${MANAGINGLIBS_INSTALLPATHS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_MANAGINGLIBS_INSTALLPATHS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_MANAGINGLIBS_INSTALLPATHS_SH}/../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_MANAGINGLIBS_INSTALLPATHS_SH}/../Testing/files.sh"
. "${SCRIPT_LOCATION_MANAGINGLIBS_INSTALLPATHS_SH}/../Printing/debug.sh"

MANAGINGLIBS_INSTALLPATHS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using MANAGINGLIBS_INSTALLPATHS_SH=""

### Content variables
INSTALL_FILE="debian/install"
ROOT_PREFIX="/"

### Functions
##!
# @brief Check if Install file exists in package root folder
# @param 1 : Package root folder
# @return 0 if package exists, >0 otherwise
#
##
InstallFileExists()
{
    local packageFolder=${1:-.} # If no argument provided, will look into current folder
    isFilePath "${packageFolder}/${INSTALL_FILE}"
}

### Functions
##!
# @brief Get install location of package element if element components are installed
# @param 1 : Package root folder
# @param 2 : Package element
# @output Install location of element if found
# @return 0 if element location could be found
#         1 if element is not specified
#         2 if install file does not exist
#         3 if install file does not contain element install
#
##
GetElemLocation()
{
    local elementName="$1"
    local packageFolder=${2:-.} # If no argument provided, will look into current folder

    if [ -z "${elementName}" ]; then
        PrintError "No element to check for installation path"
        return 1
    fi

    InstallFileExists ${packageFolder}
    if [ "$?" -ne 0 ]; then
        PrintWarning "No file ${INSTALL_FILE} in ${packageFolder} folder"
        return 2
    fi
    
    local libLocation=""
    libLocation=$(grep "^contents/${elementName}/*" "${packageFolder}/${INSTALL_FILE}")
    if [ "$?" -ne "0" ]; then
        PrintWarning "No ${elementName} installed in package ${packageFolder}"
        return 3
    else
        libLocation=$(echo ${libLocation} | cut -d' ' -f2 )
        echo "${ROOT_PREFIX}${libLocation}"       
    fi
          
    return 0
}

##!
# @brief Get install location of package libraries if library components are installed
# @param 1 : Package root folder
# @output Install location of libraries if found
# @return 0 if library location could be found
#         1 if element is not specified
#         2 if install file does not exist
#         3 if install file does not contain library install
#
##
GetLibLocation()
{
    GetElemLocation "lib" $1 
}

##!
# @brief Get install location of package binaries if binary components are installed
# @param 1 : Package root folder
# @output Install location of binaries if found
# @return 0 if binary location could be found
#         1 if element is not specified
#         2 if install file does not exist
#         3 if install file does not contain binary install
#
##
GetBinLocation()
{
    GetElemLocation "bin" $1 
}

##!
# @brief Get install location of package shared data if shared data components are installed
# @param 1 : Package root folder
# @output Install location of shared data if found
# @return 0 if shared data location could be found
#         1 if element is not specified
#         2 if install file does not exist
#         3 if install file does not contain shared data install
#
##
GetShareLocation()
{
    GetElemLocation "share" $1 
}

fi # MANAGINGLIBS_INSTALLPATHS_SH

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
