#!/bin/bash

###
# @file testFunctions.sh
# @author SignC0dingDw@rf
# @version 1.0
# @date 26 December 2019
# @brief A set of additional test functions used to mutualize commonly performed tests.
###

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
if [ -z ${TESTFUNCTIONS_SH} ]; then

# Definition of inclusion also contains the current library version
TESTFUNCTIONS_SH="1.0" # Reset using TESTFUNCTIONS_SH=""

# Inclusion of dependencies
SCRIPT_LOCATION_TESTFUNCTIONS_SH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. "${SCRIPT_LOCATION_TESTFUNCTIONS_SH}/testUtils.sh"
. "${SCRIPT_LOCATION_TESTFUNCTIONS_SH}/../Testing/files.sh"

################################################################################
###                                                                          ###
###                            Helper functions                              ###
###                                                                          ###
################################################################################
##!
# @brief Check that file content is the one expected
# @param 1 : Result File name
# @param 2 : Expected Result file name
# @return 0 if text has expected value, exit 1 otherwise
#
##
TestWrittenText()
{
    local resultFileName="$1"
    local expectedResultFileName="$2"

    local resultContent=$(cat ${resultFileName})
    local expectedContent=$(cat ${expectedResultFileName})
    
    # Test identity
    areFilesIdentical ${resultFileName} ${expectedResultFileName}
    local are_identical=$?
    endTestIfAssertFails "\"${are_identical}\" -eq \"0\"" "Wrong file content. Expected\n${resultContent}\nGot\n${expectedContent}"
    
    return 0
}

fi # TESTFUNCTIONS_SH

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