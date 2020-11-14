#!/bin/bash

# @file teardown.sh
# @author SignC0dingDw@rf
# @version 2.1
# @date 14 May 2020
# @brief Definition of the teardown function used to clean up environment after execution of TestSuite tests.

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
if [ -z ${TEARDOWN_TEARDOWN_SH} ]; then

### Include parseVersion.sh
SCRIPT_LOCATION_PRINT_TEARDOWN_TEARDOWN_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_PRINT_TEARDOWN_TEARDOWN_SH}/../../Parsing/parseVersion.sh"
. "${SCRIPT_LOCATION_PRINT_TEARDOWN_TEARDOWN_SH}/../../Printing/debug.sh"
. "${SCRIPT_LOCATION_PRINT_TEARDOWN_TEARDOWN_SH}/../../Testing/function.sh"
. "${SCRIPT_LOCATION_PRINT_TEARDOWN_TEARDOWN_SH}/utils.sh"

TEARDOWN_TEARDOWN_SH=$(parseBashDoxygenVersion ${BASH_SOURCE}) # Reset using TEARDOWN_TEARDOWN_SH=""

##!
# @brief Test teardown phase
# @return 0 if setup was successful, otherwise adds one of more of following values
#         16  : Element deletion failed
#         32  : Restoring diverted elements failed
#         64 : Restoring environment variables failed
#         128 : User defined TestTeardown failed
#
##
Teardown()
{
    local exitCode=0

    # Delete created elements
    DeleteElements "${ELEMENTS_CREATED[@]}"
    if [ "$?" -ne "0" ]; then
        ((exitCode+=16))
    fi

    # Restore diverted elements
    RestoreElements "${ELEMENTS_DIVERTED[@]}"
    if [ "$?" -ne "0" ]; then
        ((exitCode+=32))
    fi

    # Restore environment variables
    RestoreEnvVars "${ENV_VARS_VALUES_TO_RESTORE[@]}"
    if [ "$?" -ne "0" ]; then
        ((exitCode+=64))
    fi

    # Check if user has defined specific operations
    FunctionExists TestTeardown
    if [ "$?" -eq "0" ]; then
        TestTeardown
        if [ "$?" -ne "0" ]; then
            ((exitCode+=128))
        fi
    else
        PrintWarning "No User defined teardown is to be performed"
    fi
    return ${exitCode}
}

fi # TEARDOWN_TEARDOWN_SH

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
