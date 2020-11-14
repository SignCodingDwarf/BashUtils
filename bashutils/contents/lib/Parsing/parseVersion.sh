#!/bin/bash

###
# @file parseVersion.sh
# @author SignC0dingDw@rf
# @version 1.1
# @date 14 May 2020
# @brief Definition of utilitaries used to parse version from a file
###

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
if [ -z ${PARSING_PARSEVERSION_SH} ]; then

# Definition of inclusion also contains the current library version
PARSING_PARSEVERSION_SH="1.0" # Reset using PARSING_PARSEVERSION_SH=""

### Functions
##!
# @brief Parse version of a file with doxygen-like header
# @param 1 : file name
# @param 2 : Comment String
# @output The version string if found (return 0), nothing if file does not exist, "0.0" otherwise
# @return 0 if version was parsed
#         1 if file does not exist 
#         2 if version string could not be found 
#
# Parses the version in a file, assuming it uses a doxygen-like comment header.
# The means the file header should contain the line "# @version <VERSION>" for a bash script
# Formatting of the version string itself does not matter as long as it does not contain spaces
# If several header lines define version, all but the first one are ignored
#
##
parseDoxygenVersion()
{
    ## Retrieve arguments (additionals are dropped), and check them
    local FILE="$1"
    local COMMENT_STR="$2"

    if [ ! -f ${FILE} ]; then
        return 1
    fi  

    ## Internal variables initialization
    local FILE_VERSION="0.0" # Default value
    local RETURN_CODE=2 # KO code unless we find a version
    local LINE_EXTRACTED="" # Empty string by default

    ## Extract lines containing format from file   
    LINE_EXTRACTED=$(cat ${FILE} | grep -m 1 "^${COMMENT_STR} @version ") # The option -m 1 allows us to consider only the first line

    ## If extraction could find a version line
    if [ "$?" -eq "0" ]; then
        FILE_VERSION=$(echo ${LINE_EXTRACTED} | cut -d' ' -f3 ) # Split using :space: as delimiter and extract field containing version
        # Does not care if multiple spaces separate @version and version string
        RETURN_CODE=0
    fi

    ## Function End : display result and return execution code
    echo ${FILE_VERSION}
    return ${RETURN_CODE}
}

##!
# @brief Parse version of a bash script
# @param 1 : file name
# @output The version string if found (return 0), nothing if file does not exist, "0.0" otherwise
# @return 0 if version was parsed
#         1 if file does not exist 
#         2 if version string could not be found 
#
# Overlay of parseDoxygenVersion defining comment string as #
#
##
parseBashDoxygenVersion()
{
    parseDoxygenVersion $1 "#" 
}

fi # PARSING_PARSEVERSION_SH

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
