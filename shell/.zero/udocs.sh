#!/usr/bin/env bash
#
# Author: peter@uskee.org
# Created: 2015-09-08
#

export _HELP_PREFIX="__help_"
export _INIT_PREFIX="__init_"
export _SH_LIST="srcin.sh umark.sh umisc.sh udocker.sh udocs.sh"


## --------------------------
## os package management tool
_zero_pm() {
    local os=`uname` pm="" plist=""
    if [ "$os" = "Darwin" ]; then
        plist="brew port"
    elif [ "$os" = "Linux" ]; then
        plist="yum aptitude apt-get"
    fi

    for k in $plist; do
        pm=`which $k 2>/dev/null` && break
    done
    [ -z "$pm" ] && return 1

    if [[ ! "$pm" =~ "brew" ]]; then
        [ `whoami` != "root" ] && pm="sudo $pm"
    fi
    $pm $*
}
alias zpm="_zero_pm"


## -----------------
## update for ztools
_zero_update() {
    git=$(which git 2>/dev/null) || return 1
    (
        jump ...
        echo "[*] Entering <$(pwd)> ..."
        echo "[*] Then auto-update will start ..."
        $git pull
        echo
    )
    return 0
}
alias zero-update="_zero_update"


## --------------
## set for ztools
_zero_set() {
    [ $# -eq 1 ] && action="$1"
    sh=$(which bash 2>/dev/null) || return 1
    (
        jump ...
        echo "[*] Entering <$(pwd)> ..."
        echo "[*] Then set for shell ..."
        $sh zero_setting.sh $action
    )
    return 0
}
alias zero-set="_zero_set"


## ---------------------------
## print all ztools commands
_zhelp_pnx() {
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
_zero_help() {
    if [ $# -eq 1 ]; then
        local hfunc="${_HELP_PREFIX}$1"
        declare -f "$hfunc" >/dev/null && eval "$hfunc" || printf "[WARN] no help for <$1>\n\n"
        return 0
    fi

    local index=0
    local helps=""
    for item in $_SH_LIST; do
        item="$HOME/.zero/$item"
        local ulist1=$(cat $item | grep "^[a-z][a-z_-]\+() " | awk -F" " '{print $1}')
        local ulist2=$(cat $item | grep "^alias [a-z][a-z_-]\+=" | awk -F"=" '{print $1}' | sed 's#alias ##')
        if [ ${#ulist1} -gt 0 -o ${#ulist2} -gt 0 ]; then
            echo "[$index] $(basename $item) tools:"
            _zhelp_pnx "${ulist1}"
            _zhelp_pnx "${ulist2}"
            index=$((index+1))
        fi

        local hlist=$(cat $item | grep "^${_HELP_PREFIX}[a-z_]\+() " | awk -F"(" '{print $1}')
        for h in $hlist; do
            h=${h/#${_HELP_PREFIX}/}
            [ "$helps" = "" ] && helps="$h" || helps="$helps $h"
        done
    done
    printf "\n[*] Help [key]:\n"
    _zhelp_pnx "$helps"
    echo
}
alias Help="_zero_help"

## To parse functions with prefix "__help_xxx".
_Help() {
    local helps=""
    for item in $_SH_LIST; do
        item="$HOME/.zero/$item"
        local hlist=$(cat $item | grep "^${_HELP_PREFIX}[a-z_]\+() " | awk -F"(" '{print $1}')
        for h in $hlist; do
            h=${h/#${_HELP_PREFIX}/}
            [ "$helps" = "" ] && helps="$h" || helps="$helps $h"
        done
    done
    _tablist "Help" "$helps"
}
complete -F _Help Help


## -----------------
## string regex help
_regex_pnx() {
    if [ $# -eq 4 ]; then
        printf "     %-24s%s %-16s%s\n"    "$1" "$2" "$3," "$4"
    else
        printf "$*\n"
    fi
}
__help_regex() {
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



## ---------------------------------------------------
## global init scripts: 
##      To call functions with prefix of "__init_xxx".
_init_func() {
    for item in $_SH_LIST; do
        item="$HOME/.zero/$item"
        local func_list=$(cat $item | grep "^${_INIT_PREFIX}[a-z_]\+() " | awk -F"(" '{print $1}')
        for func in $func_list; do
            eval "$func" 2>/dev/null
        done
    done
}
_init_func

