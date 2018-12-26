#! /bin/sh

set -u

usage() {
  test $# -gt 1 && test -n "$2" && printf "${0##*/}: $2\n" >&2
  cat <<USAGE >&2
Usage: ${0##*/} [-P max-procs] [-Z] [-h] [SSH Options] host1 host2 ... hostN -- command
Options:
    -P max-procs   run up to max-procs processes at a time (default: 10)
    -Z             print result compact
    -h             show this help
    SSH Options    see OpenSSH client man page
USAGE
  exit "$1"
}


type ssh >/dev/null 2>&1 || usage 1 "ssh not found"

HOSTS=
SSH=ssh
COMMAND=
COMPACT_OUTPUT=false
MAX_PROCS=10

OPTIONS=$(getopt :P:h1246AaCfGgKkMNnqsTtVvXxYyb:c:D:E:e:F:I:i:J:L:l:m:O:o:p:Q:R:S:W:w: -- "$*" 2>/dev/null) || usage 1
set $OPTIONS
while [ $# -gt 0 ]; do
  case "$1" in
    --)  shift
         COMMAND="$*"
         break
         ;;
    -P*) MAX_PROCS="${1:2}"
         shift
         if test -z "$MAX_PROCS"; then
           MAX_PROCS="$1"
           shift
         fi
         ;;
    -1|-2|-4|-6|-A|-a|-C|-f|-G|-g|-K|-k|-M|-N|-n|-q|-s|-T|-t|-V|-v|-X|-x|-Y|-y)
         SSH="$SSH $1"
         shift
         ;;
    -b*|-c*|-D*|-E*|-e*|-F*|-I*|-i*|-J*|-L*|-l*|-m*|-O*|-o*|-p*|-Q*|-R*|-S*|-W*|-w*)
         OPT="${1::2}"
         PARAM="${1:2}"
         shift
         if test -z "$PARAM"; then
           PARAM="$1"
           shift
         fi
         SSH="$SSH $OPT $PARAM"
         ;;
    -Z)  COMPACT_OUTPUT=true
         shift
         ;;
    -h)  usage 0
         ;;
    -*)  usage 1 "unknown option $1"
         ;;
     *)  HOSTS="$HOSTS\n$1"
         shift
         ;;
  esac
done

test -z "$HOSTS" || test -z "$COMMAND" && usage 1

if $COMPACT_OUTPUT ; then
  printf "$HOSTS" |\
  xargs -I {} -P "$MAX_PROCS" $SSH {} "echo {}\> \$($COMMAND 2>&1) [\$?]" |\
  sort
else
  printf "$HOSTS" |\
  xargs -I {} -P "$MAX_PROCS" $SSH {} "$COMMAND"
fi
