#!/dev/null

################################################
# -Werror=shadow
# for i in "${FARR[@]}"; do
#   type "$i" 2>/dev/null && {
#     echo "$i shadows"
#     err "abort"
#     # https://unix.stackexchange.com/a/127295/
#     return
#   }
# done
################################################

# path to tracker directory
# TRACKER_D=/home/darren/cet/trackers
TRACKER_D=/home/darren/cet/

# suffix
# TRACKER_S=""
# TRACKER_S=".txt"
TRACKER_S=".tracker"

FARR=(
  selftest
  help2
  new
  verify
  inspect
)

# private function, not in FARR
function err {
  printf "\e[31m%s\e[0m\n" "$1"
}

function selftest {
  local SELF="$(realpath -s "${BASH_SOURCE[0]}")"
  local SC=(
    shellcheck
    -e2155
    "$SELF"
  )
  echo "${SC[@]}"
  "${SC[@]}"
  echo
}

# printf "\\$(printf %o $((RANDOM%26+65)))" &&
# printf $((RANDOM%10)) &&
# printf "\\$(printf %o $((RANDOM%26+65)))\n"

# cannot check if value exists in associate array
# declare -A state
# state['ITS']="T9A"
# state['FIN']="Y4B"
# state['WIP']="H9J"
# state['???']="S7H"
STATE_ARR=(
  # (A/AHI)
  T9A
  Y4B
  H9J
)
function help2 {
  echo
  printf "\e[33m%s\e[0m " "${FARR[@]/%/()}"
  echo
  echo
  # (H/AHI)
  printf    "\e[2m%s\e[0m" "nil"; echo " - untouched"
  printf "\e[1;34m%s\e[0m" "T9A"; echo " - interesting/high-priority/aforementioned (not finished yet)"
  printf    "\e[0m%s\e[0m" "Y4B"; echo " - finished/skipped"
  printf "\e[1;31m%s\e[0m" "H9J"; echo " - WIP"
  echo
  printf "exercises with numbers printed in "
  printf "\e[31m%s\e[0m"   "red(pink) "
  printf "have "
  printf "\e[35;2m%s\e[0m" "Homework Hints "
  printf "at\n"
  echo   "https://www.stewartcalculus.com/media/17_inside_homework_hints.php"
  echo
}

function new {

  { ((2==$#)) && [[ "$2" =~ ^[1-9][0-9]+$ ]]; } || {
    echo "${FUNCNAME[0]} <ID> <N_problems>"
    return
  }

  # local FN="$1.tracker"
  local FN="$1$TRACKER_S"
  [ -e "$FN" ] && { echo "$FN exists"; return; }
  read -erp "create skel '$(realpath "$FN")' ?"

  seq -f $'\e[2m%g\e[0m' -s '.' 1 "$2"

  # for i in $(seq 1 "$2"); do
  #   printf >>
  # done
  S=$' '
  echo "$(seq -s "$S"$'\n' -w 1 "$2")$S" >>"$FN"
  echo "done"

}

function verify {

  ((1<=$#)) || {
    echo "${FUNCNAME[0]} <ID> [quiet]"
    return 1
  }
  local FN="$1$TRACKER_S"

  [ -f "$FN" ] || return 2

  n=0
  while IFS="" read -r l || [ -n "$l" ]; do

    ((n=n+1))
    # printf "[line %d] #%s#\n" "$n" "$l"

    [[ "$l" =~ ^([0-9]+)\ (.*) ]] || return 3
    # [[ "$l" =~ ([0-9]+) ]] || return 3
    local   line_0="${BASH_REMATCH[0]}"
    local number_1="${BASH_REMATCH[1]}"
    local  state_2="${BASH_REMATCH[2]}"
    # echo "$n"
    [ "$l" = "$line_0" ] || return 4
    [ "$n" -eq $((10#$number_1)) ] || return 5
    # https://stackoverflow.com/a/47541882/
    { [ -z "$state_2" ] || printf '%s\0' "${STATE_ARR[@]}" | grep -Fxz "$state_2" 1>/dev/null; } || return 6

  done <"$FN"

  [ "quiet" = "$2" ] || printf "\e[032m%s\e[0m\n" pass
  return 0

}

function inspect {
  ((1==$#)) || {
    echo "${FUNCNAME[0]} <ID>"
    return 1
  }
  local R; verify "$1" quiet; R="$?"; ((0==R)) || return "$R"
  local FN="$1$TRACKER_S"
  while IFS="" read -r l || [ -n "$l" ]; do
    [[ "$l" =~ ^([0-9]+)\ (.*) ]] || return 3
    local number_1="${BASH_REMATCH[1]}"
    local  state_2="${BASH_REMATCH[2]}"
    # (I/AHI)
    case "$state_2" in
    # https://stackoverflow.com/a/11123849/8243991
    "")
      # printf         "%s "        "$((10#$number_1))"
      printf    "\e[2m%s\e[0m "  $((10#$number_1))
      ;;
    "T9A")
      printf "\e[1;34m%s\e[0m " $((10#$number_1))
      ;;
    "Y4B")
      # printf    "\e[2m%s\e[0m "        .
      ;;
    "H9J")
      printf "\e[1;31m%s\e[0m " $((10#$number_1))
      ;;
    *)
      err "err"
      return 255
      ;;
    esac
  done <"$FN"
  echo
}

function _comp {
  # echo "${COMP_CWORDS[*]}"
  # echo "${COMP_CWORDS[@]}"
  local _A=()
  if shopt -s | grep nullglob; then
    _A=(*.tracker)
  else
    shopt -s nullglob
    _A=(*.tracker)
    shopt -u nullglob
  fi
  _A=( "${_A[@]%.*}" )
  # echo "${_A[*]}"
  if [ 1 -eq "$COMP_CWORD" ]; then
    COMPREPLY=()
    # COMPREPLY=( $(compgen -W "${_A[*]}" -- "${COMP_WORDS[COMP_CWORD]}") )
    # sha1sum <<<"$(compgen -W "${_A[*]}" -- "${COMP_WORDS[COMP_CWORD]}")"
    mapfile -t COMPREPLY <<<"$(compgen -W "${_A[*]}" -- "${COMP_WORDS[COMP_CWORD]}")"
    # Doesn't work
    # compgen -W "${_A[*]}" -- "${COMP_WORDS[COMP_CWORD]}" | sha1sum
    # compgen -W "${_A[*]}" -- "${COMP_WORDS[COMP_CWORD]}" | mapfile -t COMPREPLY
  fi
}

complete -F _comp verify
complete -F _comp inspect

cd "$TRACKER_D" || { err "cd fail"; return; }
help2
