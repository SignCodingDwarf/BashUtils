#!/bin/bash

# @file install.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 30 March 2020
# @brief Script allowing to install BashUtils on your system to a given location an have an environment variable with this location.

### Exit Code
#
# 0 : Program executed successfully
# 1 : Unknown argument received
# 2 : Desired installation folder does not exist
# 3 : Cannot uninstall previous version of the library
# 4 : Failed to create installation directory
# 5 : Failed to copy content to installation directory
# 6 : Failed to create environment location variable
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
###                                Inclusions                                ###
###                                                                          ###
################################################################################
### Get script location
SCRIPT_LOCATION_INSTALL_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. "${SCRIPT_LOCATION_INSTALL_SH}/Printing/cmdHelp.sh"
. "${SCRIPT_LOCATION_INSTALL_SH}/Tools/installUtils.sh"

################################################################################
###                                                                          ###
###                                  Usage                                   ###
###                                                                          ###
################################################################################
##!
# @brief Print usage of command
# @output Command usage
# @return 0 if print is successful, >0 otherwise
#
## 
Usage()
{
    PrintUsage "install" "[options]"
}

##!
# @brief Print command help
# @output Command help
# @return 0 if print is successful, >0 otherwise
#
## 
Help()
{
    Usage
    printf "\n"
    PrintDescription "Command allowing to install BashUtils to desired location."
    PrintDescription "You can choose your installation location and, if it is already installed, previous installation will be deleted."
    PrintDescription "Creates the BASH_UTILS_LIB environement variable, so that you can easily include it in other scripts."
    printf "\n"

    printf "Options:\n"
    PrintOptionCategory "General Options"
    PrintOption "-h" "--help" "show this help message and exit"
    PrintOption "-v" "--verbose" "get detailed execution information"
    printf "\n"
    PrintOptionCategory "Configuration"
    PrintOption "-d" "--install-directory=<directory>" "set directory where BashUtils will be installed. Default is /usr/local/lib"
}

################################################################################
###                                                                          ###
###                            Control Variables                             ###
###                                                                          ###
################################################################################
VERBOSE=false
INSTALL_LOCATION="/usr/local/lib"

################################################################################
###                                                                          ###
###                            Process Arguments                             ###
###                                                                          ###
################################################################################
for argument in "$@" # for every input argument
do
    case $argument in
        -h|--help) # if asked to render help
            Help # Print help and exit
            exit 0
        ;;
        -v|--verbose) # if asked to set verbose execution
            VERBOSE=true
        ;;
        -d=*|--install-directory=*)
            INSTALL_LOCATION="${argument#*=}"
        ;;
        *) #default check if argument is in list      
            PrintError "${argument} is not a valid argument" 
            Help
            exit 1 
        ;;
    esac
done

if [ ! -d "${INSTALL_LOCATION}" ]; then
    PrintError "Desired install directory ${INSTALL_LOCATION} does not exist"
    exit 2
fi

################################################################################
###                                                                          ###
###                       Cleanup previous installation                      ###
###                                                                          ###
################################################################################
PrintInfo "********** Uninstalling previous library version **********"
InstallCleanUp
if [ "$?" -ne "0" ]; then
    exit 3
fi

################################################################################
###                                                                          ###
###                                 Install                                  ###
###                                                                          ###
################################################################################
PrintInfo "********** Creating BashUtils directory in ${INSTALL_LOCATION} **********"
CreateInstallDirectory "${INSTALL_LOCATION}"
if [ "$?" -ne "0" ]; then
    exit 4
fi

PrintInfo "********** Copying BashUtils **********"
CopyContentToInstallDirectory "${INSTALL_LOCATION}" "${SCRIPT_LOCATION_INSTALL_SH}" # Assume install.sh is at root of directory
if [ "$?" -ne "0" ]; then
    exit 5
fi

################################################################################
###                                                                          ###
###                      Reference to new installation                       ###
###                                                                          ###
################################################################################
PrintInfo "********** Creating reference to BashUtils directory **********"
CreateInstallDirectoryReference "${INSTALL_LOCATION}"
if [ "$?" -ne "0" ]; then
    exit 6
fi

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
