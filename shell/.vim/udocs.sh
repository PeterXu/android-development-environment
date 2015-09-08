#!/usr/bin/env bash
#
# Author: peter@uskee.org
# Created: 2015-09-08
#


## -----------------
## autoupdate ztools
_ztools_update() {
    git=$(which git 2>/dev/null) || return 1
    (
        jump ...
        echo "Entering <$(pwd)> ..."
        echo "Then auto-update will start ..."
        $git pull
        echo
    )
    return 0
}
alias ztools-update="_ztools_update"

_zero_set() {
    [ "$#" -ne 1 ] && echo "ztools-set set|clear|prepare" && return 1
    action="$1"
    sh=$(which bash 2>/dev/null) || return 1
    (
        jump ...
        echo "Entering <$(pwd)> ..."
        echo "Then set for shell ..."
        $sh zero_setting.sh $action
        echo
    )
    return 0
}
alias zero-set="_zero_set"


## ---------------------------
## print all avaiable commands
_zlist_pnx() {
    local max=7
    local pos=0
    local ulist=($*)
    local len=${#ulist[@]}
    while [ $len -gt $pos ]; do
        local tmp
        if [ $len -gt $max ]; then
            tmp=${ulist[@]:$pos:$max} && pos=$((pos+max))
        else
            tmp=${ulist[@]} && pos=$len
        fi
        echo "        => "${tmp##\n}
    done
}
zlist() {
    local index=0
    local flist="umark.sh umisc.sh udocker.sh udocs.sh"
    for item in $flist; do
        item="$HOME/.vim/$item"
        local ulist1=$(cat $item | grep "^[a-z][a-z_-]\+() " | awk -F" " '{print $1}')
        local ulist2=$(cat $item | grep "^alias [a-z][a-z_-]\+=" | awk -F"=" '{print $1}' | sed 's#alias ##')
        if [ ${#ulist1} -gt 0 -o ${#ulist2} -gt 0 ]; then
            echo "[$index] $(basename $item) tools:"
            _zlist_pnx "${ulist1}"
            _zlist_pnx "${ulist2}"
            index=$((index+1))
        fi
    done
    echo
}
alias Help="zlist"


## -----------------
## string regex help
_regex_pnx() {
    if [ $# -eq 4 ]; then
        printf "     %-24s%s %-16s%s\n"    "$1" "$2" "$3," "$4"
    else
        printf "$*\n"
    fi
}
_regex_help() {
    local str="abcde.abcde"
    _regex_pnx  "usage:  e.g., str=\"${str}\""
    _regex_pnx  "  0. strlen"
    _regex_pnx  "expr \"\$str\" : \".*\""  "=>"  "$(expr "$str" : ".*")" "the length of string"
    _regex_pnx  "\${#str}"        "=>"  "${#str}"       "the length of string"
    _regex_pnx
    _regex_pnx  "  1. substr"
    _regex_pnx  "\${str:2}"       "=>"  "${str:2}"      "[2, the right end]"
    _regex_pnx  "\${str:2:3}"     "=>"  "${str:2:3}"    "[2, 5(from the 2th+3)]"
    _regex_pnx  "\${str:(-6):5}"  "=>"  "${str:(-6):5}" "[0, (-6)from the right end]"
    _regex_pnx  "\${str#a*c}"     "=>"  "${str#a*c}"    "del the shortest from the leftmost <#>"
    _regex_pnx  "\${str##a*c}"    "=>"  "${str##a*c}"   "del the longest from the leftmost <#>"
    _regex_pnx  "\${str%c*e}"     "=>"  "${str%c*e}"    "del the shortest from the right end <%>"
    _regex_pnx  "\${str%%c*e}"    "=>"  "${str%%c*e}"   "del the longest from the right end <%>"
    _regex_pnx
    _regex_pnx  "  2. replace"
    _regex_pnx  "\${str/bcd/x}"   "=>"  "${str/bcd/x}"  "the first matched from the leftmost"
    _regex_pnx  "\${str//bcd/x}"  "=>"  "${str//bcd/x}" "all matched string from the leftmost"
    _regex_pnx  "\${str/#bcd/x}"  "=>"  "${str/#bcd/x}" "the leftmost: 'bcd'"
    _regex_pnx  "\${str/#abc/x}"  "=>"  "${str/#abc/x}" "the leftmost: 'abc'"
    _regex_pnx  "\${str/%bcd/x}"  "=>"  "${str/%bcd/x}" "the right end: 'bcd'"
    _regex_pnx  "\${str/%cde/x}"  "=>"  "${str/%cde/x}" "the right end: 'cde'"
    _regex_pnx
    _regex_pnx  "  3. compare - logic true"
    _regex_pnx  "     [[ "$str" == "a*" ]]"
    _regex_pnx  "     [[ "$str" =~ .*\.abcde ]]"
    _regex_pnx  "     [[ \"11\" < \"2\" ]]"
    _regex_pnx

    local fpath="/tmp/README.md" fname="README.md"
    _regex_pnx  "  e.g. fpath=\"$fpath\" && fname=\"$fname\""
    _regex_pnx  "echo \${fpath##*/}"      "=>"  "${fpath##*/}"  "get the file"
    _regex_pnx  "echo \${fpath%/*}"       "=>"  "${fpath%/*}"   "get the path"
    _regex_pnx  "echo \${fname%%.*}"      "=>"  "${fname%%.*}"  "get the file basename" 
    _regex_pnx  "echo \${fname##*.}"      "=>"  "${fname##*.}"  "get the file extension name" 
    _regex_pnx  "echo -e \${fname/./'\t'}"  "=>"  "$(echo -e ${fname/./'\t'})" "replace '.' with tab"
    _regex_pnx
}
alias regex-help="_regex_help"

