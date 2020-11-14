#!/bin/bash

# @file runTests.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 27 March 2020
# @brief Script allowing to run tests scripts in all BashUtils modules and display results

### Exit Code
#
# 0 : Program executed successfully
# 1 : Failed to create results folder
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
SCRIPT_LOCATION_RUN_TESTS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. "${SCRIPT_LOCATION_RUN_TESTS_SH}/bashutils/contents/lib/Printing/cmdHelp.sh"
. "${SCRIPT_LOCATION_RUN_TESTS_SH}/bashutils/contents/lib/Tools/tests.sh"

################################################################################
###                                                                          ###
###                              Configuration                               ###
###                                                                          ###
################################################################################
# Set module working directory
SetModuleRoot "${SCRIPT_LOCATION_RUN_TESTS_SH}/bashutils/contents/lib/"
# Build list of modules
ListModules

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
    PrintUsage "runTests" "[options]" "[tested_module_1] .. [tested_module_N]" 
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
    PrintDescription "Command allowing to run tests of BashUtils modules (i.e. folders)."
    PrintDescription "Can specify one or more modules. If no modules is specified, all modules are tested."
    printf "\n"

    printf "Options:\n"
    PrintOptionCategory "General Options"
    PrintOption "-h" "--help" "show this help message and exit"
    PrintOption "-v" "--verbose" "get detailed execution information"
    printf "\n"
    PrintOptionCategory "Listing"
    PrintOption "-l" "--list-modules" "list available modules"
    printf "\n"
    PrintOptionCategory "Log"
    PrintOption "-r" "--results-location=<path>" "folder where the execution results are stored. Default is /tmp"
}

################################################################################
###                                                                          ###
###                            Control Variables                             ###
###                                                                          ###
################################################################################
VERBOSE=false
MODULES_TO_TEST=() # List of tested modules
RESULTS_LOCATION="/tmp"

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
        -l|--list-modules)
            PrintModulesList
            exit 0
        ;;
        -r=*|--results-location=*)
            RESULTS_LOCATION="${argument#*=}"
        ;;
        *) #default check if argument is in list       
            IsInModuleList ${argument}
            inList="$?"
            if [ "${inList}" -eq "0" ]; then
                MODULES_TO_TEST+=(${argument})
            else
                PrintWarning "Failed to add ${argument} to modules to test list"
            fi    
        ;;
    esac
done

# If no module to test is specified, fill the list with the complete modules list
if [ -z "${MODULES_TO_TEST}" ]; then
    MODULES_TO_TEST=($(PrintModulesList))
fi

# Create the folder storing results
CreateResultFolder "${RESULTS_LOCATION}"
if [ "$?" -ne "0" ]; then
    exit 1
fi 

################################################################################
###                                                                          ###
###                              Execute Tests                               ###
###                                                                          ###
################################################################################
for testedModule in ${MODULES_TO_TEST[@]}; do
    PrintInfo "********** Testing Module ${testedModule} **********"
    TestModule "${testedModule}"
done

################################################################################
###                                                                          ###
###                             Display Results                              ###
###                                                                          ###
################################################################################
for testedModule in ${MODULES_TO_TEST[@]}; do
    PrintModuleResult "${testedModule}"
done

PrintExecutionSummary

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
