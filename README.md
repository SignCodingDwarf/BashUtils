# BashUtils
A set of utilitary functions to use in bash scripts.

### Requirements

Bash >= 4.4

### Installation 

run 

`./install.sh`

By default this will install the files in the folder __/usr/local/lib__. You can specify a different installation folder using :

`./install.sh -d=<install_directory>`

The install location is defined in the environment variable **BASH_UTILS_LIB**. It is exported in your .bashrc file

If you need to run the installer as superuser, run :

`sudo -E ./install.sh`

If you already had a previous version of the library installed (based on **BASH_UTILS_LIB** value), it is uninstalled.

### Test

#### Test environment

The folder __TestEnv__ provides you with an example docker file with all required packages to test BashUnit in a dedicated environment.

To build container from Dockerfile run
`cd TestEnv`
`tag_name=$(cat tagName)`
`docker build -t ${tag_name} .`

#### Run Tests

You can run unit tests of all the modules to check the library is working on your system using :

`${BASH_UTILS_LIB}/runTests.sh`

### Content

BashUtils contains the following modules :

##### BashDwfUnit

A framework to perform unit testing in Bash.

##### Parsing

A set of functions used to parse file contents.

##### Printing

A set of functions to display information and logs.

##### Testing

A set of functions used to perform tests in bash.

##### Tools

Internal utilities used by installation and unit testing. You should not use them 

##### Updating

A set of functions used to alter variable content.


