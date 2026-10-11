#!/usr/bin/env zsh -f
# Runs _bb against the fixture with stubbed completion functions.
# Usage: zsh -f tests/run.zsh

root=${0:A:h:h}
cd $root/tests/fixture || exit 1
rm -f ran-danger

fpath=($root $fpath)
autoload -Uz _bb

typeset -a described added
typeset -i files_called failures

_describe() { local -a specs=("${(@P)4}"); described+=("${specs[@]%%:*}") }
compadd() { [[ $1 == -- ]] && shift; added+=("$@") }
_files() { files_called=1 }

complete() {
  words=(bb "$@")
  CURRENT=$#words
  PREFIX=$words[-1]
  described=() added=() files_called=0
  _bb
}

check() {
  local name=$1 expr=$2
  if eval $expr; then
    print "ok - $name"
  else
    print "not ok - $name"
    print "  described: $described"
    print "  added: $added"
    print "  files: $files_called"
    (( failures++ ))
  fi
}

complete ''
check 'tasks are listed' '(( ${described[(Ie)db]} && ${described[(Ie)danger]} ))'
check 'files are offered next to tasks' '(( files_called ))'

complete db ''
check 'commands of a :cmd task are listed' '[[ $described == "backup restore" ]]'
check 'no files next to commands' '(( ! files_called ))'

complete db res
check 'commands match a partial word' '[[ $described == "backup restore" ]]'

complete db restore --
check 'long flags are offered' '(( ${added[(Ie)--help]} ))'

complete db restore some-uri ''
check 'arguments fall back to files' '(( files_called && ! $#described ))'

complete danger ''
check 'plain tasks fall back to files' '(( files_called && ! $#described ))'
check 'plain tasks do not run' '[[ ! -e ran-danger ]]'

rm -f ran-danger
(( failures )) && print "$failures failed" && exit 1
print 'all passed'
