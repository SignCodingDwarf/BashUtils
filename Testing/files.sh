#!/bin/bash

# @file files.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 24 December 2019
# @brief Definition of functions used to perform tests on files

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

### Protection against multiple inclusions
if [ -z ${FILES_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_FILES_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_FILES_SH}/../Parsing/parseVersion.sh"

FILES_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using FILES_SH=""

##!
# @brief Check if a path is path of a file
# @param 1 : Path
# @return 0 if file path, 1 otherwise
#
##
isFilePath()
{
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

##!
# @brief Compare files content
# @param 1 : File 1
# @param 2 : File 2
# @return 0 if files are identical
#         1 if files are different
#         2 if first argument is not a file
#         3 if second argument is not a file
#
##
areFilesIdentical()
{
    ### Get arguments
    local file_1="$1"
    local file_2="$2"
    
    ### Check arguments
    isFilePath "${file_1}"
    local is_file_1=$?
    if [ "${is_file_1}" -ne "0" ]; then
        return 2
    fi

    ### Check arguments
    isFilePath "${file_2}"
    local is_file_2=$?
    if [ "${is_file_2}" -ne "0" ]; then
        return 3
    fi

    ### Compoare
    cmp -s "${file_1}" "${file_2}"
    local are_identical=$?
    if [ "${are_identical}" -eq "0" ]; then
        return 0
    else
        return 1
    fi
}

fi # FILES_SH

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
