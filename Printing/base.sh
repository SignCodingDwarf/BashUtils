#!/bin/bash

# @file base.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 27 October 2019
# @brief Definition of base format and of functions used to format prints

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
if [ -z ${BASE_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_FORMAT_BASE_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_FORMAT_BASE_SH}/../Parsing/parseVersion.sh"

BASE_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using BASE_SH=""

### Formats
NF='\033[0m' # Clear all formats

### Functions
##!
# @brief Detect if output is written to a terminal or not
# @param 1 : Terminal name
# @return 0 if terminal, 1 if not a terminal, 2 if input is invalid
#
# From https://stackoverflow.com/questions/911168/how-to-detect-if-my-shell-script-is-running-through-a-pipe
#
##
IsWrittenToTerminal()
{
    if [ -z "$1" ]; then
        return 2
    fi
    if [ -t $1 ]; then
        return 0
    else
        return 1
    fi 
}

##!
# @brief Manages print with handling of destination and format
# @param 1  : desired output id
# @param 2  : Begin format for terminal outputs
# @param 3  : End format for terminal outputs
# @param 4  : Begin format for non terminal outputs
# @param 5  : End format for non terminal outputs
# @param 6* : Elements to print
# @output The elements to print with the required format applied
# @return 0 if printing was successful, >0 otherwise
#
# Format depends on output type (terminal or not)
#
##
FormattedPrint()
{
    local output=$1
    local formatBeing=""
    local formatEnd=""

     IsWrittenToTerminal ${output}
     if [ $? -eq 0 ]; then
         formatBegin=$2
         formatEnd=$3
    else
         formatBegin=$4
         formatEnd=$5
    fi

    if [[ "${formatBegin}" == -* ]]; then # When first char starts with - it is mistaken for an option so should be handled
        printf "%s%s${formatEnd}\n" "${formatBegin}" "${*:6}" >&${output}
    else
        printf "${formatBegin}%s${formatEnd}\n" "${*:6}" >&${output}
    fi
}


fi # BASE_SH

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
