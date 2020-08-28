#! /usr/bin/env bash
### The Markdown Injector (MDI)
###
### Usage:
###  mdi <command> [flags] [options] <file>
###
### Commands:
###  inject     Injects already compiled code blocks
###
### Options:
###
### Version: 0.0.0-9000
### Copyright: Henrik Bengtsson (2020)
### License: GPL (>= 3.0) [https://www.gnu.org/licenses/gpl.html]
### Source: https://github.com/UCSF-TI/C4-sysadm/
#call="$0 $*"

# -------------------------------------------------------------------------
# Output utility functions
# -------------------------------------------------------------------------
_tput() {
    if [[ $theme == "none" ]]; then
        return
    fi
    tput "$@" 2> /dev/null
}

mdebug() {
    if ! $debug; then
        return
    fi
    {
        _tput setaf 8 ## gray
        echo "DEBUG: $*"
        _tput sgr0    ## reset
    } 1>&2
}

error() {
    {
        _tput setaf 1 ## red
        echo "ERROR: $*"
        _tput sgr0    ## reset
    } >&2
    exit 1
}

_exit() {
    local value

    value=${1:-0}
    [[ "$(LC_ALL=C type -t _cleanup)" = function ]] && _cleanup
    mdebug "Exiting with exit code $value"
    exit "$value"
}

assert_file() {
    [[ -f "$1" ]] || error "No such file: $1"
}


# -------------------------------------------------------------------------
# CLI utility functions
# -------------------------------------------------------------------------
version() {
    grep -E "^###[ ]*Version:[ ]*" "$0" | sed 's/###[ ]*Version:[ ]*//g'
}

help() {
    local res
    res=$(grep "^###" "$0" | grep -vE '^(####|### whatis: )' | cut -b 5-)
    printf "%s\\n" "${res[@]}"
}


# -------------------------------------------------------------------------
# RPM utility functions
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Main
# -------------------------------------------------------------------------
theme=
action=
debug=false
file=

# Parse command-line options
while [[ $# -gt 0 ]]; do
    ## Commands:
    if [[ "$1" == "inject" ]]; then
        action=inject
        
    ## Options (--flags):
    elif [[ "$1" == "--help" ]]; then
        action=help
    elif [[ "$1" == "--version" ]]; then
        action=version
    elif [[ "$1" == "--debug" ]]; then
        debug=true

    ## Options (--key=value):
    elif [[ "$1" =~ ^--.*=.*$ ]]; then
        key=${1//--}
        key=${key//=*}
        value=${1//--[[:alpha:]]*=}
        mdebug "Key-value option '$1' parsed to key='$key', value='$value'"
        if [[ -z $value ]]; then
            merror "Option '--$key' must not be empty"
        fi
    else
        if [[ -z "$file" ]]; then
            file="$1"
        else
            extras="$extras $1"
        fi
    fi
    shift
done

## --help should always be available prior to any validation errors
if [[ -z $action ]]; then
    help
    _exit 0
elif [[ $action == "help" ]]; then
    help
    _exit 0
fi

if [[ $action == "inject" ]]; then
    assert_file "$file"
    path=$(dirname "$file")
    filename=$(basename "$file")
    echo "filename=$filename"
    echo "path=$path"
    cd "$path"
    readarray lines < "$filename"
    echo "Number of lines: ${#lines[@]}"
    pattern='<!--[[:space:]]+(.*)[[:space:]]+-->'
    grep -n -E "$pattern" "$filename"
fi
