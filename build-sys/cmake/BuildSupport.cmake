#
# Copyright (C) 2016-2018 Wind River Systems, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software  distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, either express or implied.
#

include( CMakeParseArguments )

### SET_COMPILER_FLAG
# checks to see if a particular compiler supports the given flag and
# added the definition to the compile if it is supported
# Arguments:
# - flag           name of first compiler flag to test
# - ...            additional compiler flags to test
macro( SET_COMPILER_FLAG_IF_SUPPORTED FLAG )
	foreach( _flag ${FLAG} ${ARGN} )
		check_c_compiler_flag( "${_flag}" _flag_exists )
		if ( _flag_exists )
			add_definitions( "${_flag}" )
		endif( _flag_exists )
	endforeach( _flag )
endmacro( SET_COMPILER_FLAG_IF_SUPPORTED )

### GET_SHORT_NAME
# Build a short name from a longer name
# Examples:
# - Internet of Things->iot;
# - Helix Device Cloud->hdc;
# - Operating System Abstraction Layer->osal
# Arguments:
# - _var          output variable
# - _name ...     long name
function( GET_SHORT_NAME _var _name )
	set( _name ${_name} ${ARGN} )
	string( TOLOWER "${_name}" NAME_SPLIT )
	string( REGEX REPLACE "[ -_:.]" ";" NAME_SPLIT "${NAME_SPLIT}" )
	set( NAME_SHORT "" )
	foreach( WORD ${NAME_SPLIT} )
		string( REGEX REPLACE "([a-z0-9]).+" "\\1" WORD "${WORD}" )
		set( NAME_SHORT "${NAME_SHORT}${WORD}" )
	endforeach( WORD )
	string( LENGTH "${NAME_SHORT}" NAME_SHORT_LENGTH )
	if ( NAME_SHORT_LENGTH LESS 2 )
		set( NAME_SHORT "${_name}" )
	endif ( NAME_SHORT_LENGTH LESS 2 )
	string( REGEX REPLACE "[^a-z0-9]" "" NAME_SHORT "${NAME_SHORT}" )
	set( ${_var} "${NAME_SHORT}" PARENT_SCOPE )
endfunction( GET_SHORT_NAME )

get_short_name( PACKAGE_NAME_SHORT "${PACKAGE_NAME}" )
get_short_name( PROJECT_NAME_SHORT "${PROJECT_NAME}" )

### Generate Copyright String ###
if( WIN32 )
	execute_process( COMMAND "cmd" "/C" "date" "/T" OUTPUT_VARIABLE CURRENT_YEAR )
	# Windows 10 format
	string( REGEX REPLACE "([0-9]+)-[0-9]+-[0-9]+" "\\1" CURRENT_YEAR "${CURRENT_YEAR}" )
	# Windows XP format
	string( REGEX REPLACE "[0-9]+/[0-9]+/([0-9]+)" "\\1" CURRENT_YEAR "${CURRENT_YEAR}" )
	string( REPLACE "\n" "" CURRENT_YEAR "${CURRENT_YEAR}" )
	string( STRIP "${CURRENT_YEAR}" CURRENT_YEAR )
else()
	execute_process( COMMAND "date" "+%Y" OUTPUT_VARIABLE CURRENT_YEAR )
	string( REGEX REPLACE "(....).*" "\\1" CURRENT_YEAR "${CURRENT_YEAR}" )
endif()
set( COPYRIGHT_RANGE "2017" )
if( NOT "${COPYRIGHT_RANGE}" STREQUAL "${CURRENT_YEAR}" )
	set( COPYRIGHT_RANGE "${COPYRIGHT_RANGE}-${CURRENT_YEAR}" )
endif()
set( PROJECT_COPYRIGHT "Copyright (C) ${COPYRIGHT_RANGE} ${PROJECT_VENDOR}, All Rights Reserved." )

