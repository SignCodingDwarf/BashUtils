#!/bin/bash

# @file paths.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 15 May 2020
# @brief Definition of functions used to convert paths 

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
if [ -z ${CONVERTING_PATHS_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_CONVERTING_PATHS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_CONVERTING_PATHS_SH}/../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_CONVERTING_PATHS_SH}/../Printing/debug.sh"
. "${SCRIPT_LOCATION_CONVERTING_PATHS_SH}/../Testing/commands.sh"

CONVERTING_PATHS_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using CONVERTING_PATHS_SH=""

##!
# @brief Convert an existing path to the corresponding absolute path with symlinks resolved
# @param 1 : Path
# @output Absolute path is path exists
# @return 0 if path can be converted, 
#         1 if file does not exist
#         >0 otherwise (see readlink or realpath output or pwd)
#
##
ToAbsolutePath()
{
    if [ -f "$1" ]; then
        local rootFolder=$(dirname "$1")
        local element=$(basename "$1")
    elif [ -d "$1" ]; then 
        local rootFolder="$1"
        local element=""   
    else
        PrintError "Path $1 does not exist"
        return 1
    fi

    IsCommand "realpath"
    local realpathExists=$?
    if [ "${realpathExists}" -eq "0" ]; then
        realpath "${rootFolder}/${element}"
    else        
        IsCommand "readlink"
        local readlinkExists=$?
        if [ "${readlinkExists}" -eq "0" ]; then
            readlink -f "${rootFolder}/${element}"
        else
            cd ${rootFolder} > /dev/null
            local absPath=`pwd -P`
            cd - > /dev/null
            echo "${absPath}/${element}"
            return 0
        fi
    fi
}

fi # CONVERTING_PATHS_SH

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
