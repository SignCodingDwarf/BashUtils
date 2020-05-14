#!/bin/bash

# @file cmdHelp.sh
# @author SignC0dingDw@rf
# @version 1.2
# @date 14 May 2020
# @brief Definition of formats and functions used to display help and usage of commands

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
if [ -z ${PRINTING_CMDHELP_SH} ]; then

### Include printUtils.sh
SCRIPT_LOCATION_PRINTING_CMDHELP_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINTING_CMDHELP_SH}/../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINTING_CMDHELP_SH}/debug.sh"

PRINTING_CMDHELP_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using PRINTING_CMDHELP_SH=""

### Format
# Usage
usageFormat='\033[1;34m' # Help on command is printed in light blue
descriptionFormat='\033[1;31m' # Help on command is printed in light red
helpOptionsFormat='\033[1;32m' # Help on options is printed in light green
helpCategoryFormat="\033[1;33m" # Help options categories are printed in yellow

### Functions
##!
# @brief Print usage of a script
# @param 1  : Cmd name
# @param 2* : Cmd arguments
# @return 0 if print was successful, >0 otherwise
#
##
PrintUsage()
{
    printf "Usage \n"
    FormattedPrint 1 "${usageFormat}" "${NF}" "" "" " ./${1} ${*:2}" 
}

##!
# @brief Print description of a cmd action
# @param *  : Description
# @return 0 if print was successful, >0 otherwise
#
##
PrintDescription()
{
    FormattedPrint 1 "${descriptionFormat}" "${NF}" "" "" "$*"
}

##!
# @brief Print category of options
# @param * : Category name
# @return 0 if print was successful, >0 otherwise
#
##
PrintOptionCategory()
{
    FormattedPrint 1 "${helpCategoryFormat}----- " " -----${NF}" "----- " " -----" "$*"
}

##!
# @brief Check if option is long option (i.e. starts with --)
# @param 1 : Option name (with - or --)
# @return 0 if option is long, 1 otherwise
#
##
IsLongOption()
{
    local option=$1
    if [[ ${option} == --[A-Za-z0-9][A-Za-z0-9]* ]]; then # long options have at least two characters
        return 0
    else
        return 1
    fi         
}

##!
# @brief Check if option is short option (i.e. starts with -)
# @param 1 : Option name (with - or --)
# @return 0 if option is short, 1 otherwise
#
##
IsShortOption()
{
    local option=$1
    if [[ ${option} == -[A-Za-z0-9] ]]; then # long options have at least two characters
        return 0
    else
        return 1
    fi
}

##!
# @brief Print option with both long and short options
# @param 1 : Short option (if used) or long option (if used)
# @param 2 : Short option (if used) or long option (if used)
# @param 2/3* : Option description (depends on option position)
# @return 0 if print was successful, 255 if no option is defined, 254 if an option is defined twice, >0 otherwise
#
# The function starts printing the description at a fixed column (25) so that all displays are consistent and good looking.
#
##
PrintOption()
{
    local shortOpt=""
    local longOpt=""
    local description=""
    local descriptionColumn=24 # The text will be displayed at column 25 (24+1)

    ### Check First argument. Must be an option
    if IsShortOption "$1"; then
        shortOpt="$1"
    elif IsLongOption "$1"; then
        longOpt="$1"
    else
        PrintError "$1 is not a valid option name"
        return 255
    fi

    ### Check Second argument. Can be an option
    if IsShortOption "$2"; then
        if [ -n "${shortOpt}" ]; then
            PrintError "Defined twice short option with ${shortOpt} and $2"
            return 254
        fi
        shortOpt="$2"
        description="${*:3}"
    elif IsLongOption "$2"; then
        if [ -n "${longOpt}" ]; then
            PrintError "Defined twice long option with ${longOpt} and $2"
            return 254
        fi
        longOpt="$2"
        description="${*:3}"        
    else
        description="${*:2}" # Only one option with description
    fi

    ### Compute separator between options and description
    local optionString=""
    local separator=""
    # We compute the option content. Thus we have its length and can compute the length of the separator
    if [ -n "${shortOpt}" ]; then
        if [ -n "${longOpt}" ]; then
            optionString="${shortOpt} or ${longOpt}"
        else
            optionString="${shortOpt}"
        fi
    else
        optionString="${longOpt}"
    fi
    # Compute separator content
    if [ "${descriptionColumn}" -gt "${#optionString}" ]; then
        local numberSpaces=$((${descriptionColumn}-${#optionString}))
        separator=$(printf '%0.s ' $(seq 1 ${numberSpaces}))
    else
        separator=$(printf '%0.s ' $(seq 1 ${descriptionColumn}))
        separator="\n${separator}" # Add Line jump
    fi

    ### Print (we do not use FormattedPrint because there is sytling in the middle of the text)
    if [ -n "${shortOpt}" ]; then
        if [ -n "${longOpt}" ]; then
            if IsWrittenToTerminal 1; then
                printf "${helpOptionsFormat}%s${NF} or ${helpOptionsFormat}%s${NF}${separator}%s\n" "${shortOpt}" "${longOpt}" "${description}"  
            else
                printf "%s or %s${separator}%s\n" "${shortOpt}" "${longOpt}" "${description}"
            fi
        else
            if IsWrittenToTerminal 1; then
                printf "${helpOptionsFormat}%s${NF}${separator}%s\n" "${shortOpt}" "${description}"  
            else
                printf "%s${separator}%s\n" "${shortOpt}" "${description}" 
            fi
        fi
    else
        if IsWrittenToTerminal 1; then
            printf "${helpOptionsFormat}%s${NF}${separator}%s\n" "${longOpt}" "${description}"  
        else
            printf "%s${separator}%s\n" "${longOpt}" "${description}" 
        fi
    fi
}

fi # PRINTING_CMDHELP_SH

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
