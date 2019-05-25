#!/bin/bash

# file :  printUtils.sh
# author : SignC0dingDw@rf
# version : 0.2
# date : 05 May 2019
# Definition of utilitaries and variables used to display information

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
if [ -z ${PRINTUTILS_SH} ]; then

PRINTUTILS_SH="PRINTUTILS_SH" # Reset using PRINTUTILS_SH=""

### Colors
# Usage
usageColor='\033[1;34m' # Help on command is printed in light blue
descriptionColor='\033[1;31m' # Help on command is printed in light red
helpOptionsColor='\033[1;32m' # Help on options is printed in light green
helpCategoryColor="\033[1;33m" # Help options categories are printed in yellow

# Messages
infoColor='\033[1;34m' # Infos are printed in light blue
warningColor='\033[1;33m' # Errors are printed in yellow
errorColor='\033[1;31m' # Errors are printed in light red

# No format
NC='\033[0m' # No Color

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
# @brief Print an information formatted message to the stderr
# @param * : Elements to display
# @return 0 if printing was successful, >0 otherwise
#
# From https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
# Uses the environment defined VERBOSE to determine whether printg should be done.
# Uses the principle of collapsing functions in bash 
# https://wiki.bash-hackers.org/howto/collapsing_functions 
# Format depends on output type (terminal or not)
#
##
PrintInfo()
{
    if [ "${VERBOSE}" = true ]; then
        PrintInfo() # Print is defined as verbose at first call
        {
            local formatBegin=""
            local formatEnd=""
            IsWrittenToTerminal 2
            if [ $? -eq 0 ]; then
                formatBegin=${infoColor}
                formatEnd=${NC}
            else
                formatBegin="[Info] : "
            fi
            printf "${formatBegin}%s${formatEnd}\n" "$*" >&2 # Concatenate args into a string, print it and redirect to stderr 
        }
        PrintInfo "$*" # We print the first thing we wanted to print
    else
        PrintInfo() 
        {
            : # Does nothing if verbosity is disabled
        } 
    fi
}

##!
# @brief Print a warning formatted message to the stderr
# @param * : Elements to display
# @return 0 if printing was successful, >0 otherwise
#
# From https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
# Format depends on output type (terminal or not)
#
##
PrintWarning()
{
    local formatBegin=""
    local formatEnd=""
    IsWrittenToTerminal 2
    if [ $? -eq 0 ]; then
        formatBegin=${warningColor}
        formatEnd=${NC}
    else
        formatBegin="[Warning] : "
    fi
    printf "${formatBegin}%s${formatEnd}\n" "$*" >&2 # Concatenate args into a string, print it and redirect to stderr
}

##!
# @brief Print an error formatted message to the stderr
# @param * : Elements to display
# @return 0 if printing was successful, >0 otherwise
#
# From https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
# Format depends on output type (terminal or not)
#
##
PrintError()
{
    local formatBegin=""
    local formatEnd=""
    IsWrittenToTerminal 2
    if [ $? -eq 0 ]; then
        formatBegin=${errorColor}
        formatEnd=${NC}
    else
        formatBegin="[Error] : "
    fi
    printf "${formatBegin}%s${formatEnd}\n" "$*" >&2 # Concatenate args into a string, print it and redirect to stderr 
}

fi # PRINTUTILS_SH

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
