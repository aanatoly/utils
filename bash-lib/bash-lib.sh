# Bash Library
# * ansi colors
# * messages
# * argument parsing
# * size convertion to K, M, G

# shellcheck disable=SC2034
BASH_LIB_VERSION=1.0

# {{{ ansi colors
# arg="fg-green bold"
# echo -e "$(ansi_color $arg)$arg$(ansi_color reset)"

declare -A COLORS

COLORS=(
    [reset]="0"
    [bold]="1"
    [underline]="4"

    [fg]="3"
    [bg]="4"
    [fg_hi]="9"
    [bg_hi]="10"

    [black]="0"
    [red]="1"
    [green]="2"
    [yellow]="3"
    [blue]="4"
    [purple]="5"
    [magenta]="5"
    [cyan]="6"
    [white]="7"
)

ansi_color() {
    local rc=""

    for desc in "$@"; do
        if [ -n "${COLORS[$desc]}" ]; then
            rc+="${COLORS[$desc]};"
            continue
        fi
        if [[ "$desc" = *-* ]]; then
            local cname="${COLORS[${desc##*-}]}"
            local ctype="${COLORS[${desc%-*}]}"

            if [ -n "$cname" ] && [ -n "$ctype" ]; then
                rc+="$ctype$cname;"
                continue
            fi
        fi
        echo "unknown color description '$desc'" >&2
        return
    done
    # shellcheck disable=SC2028
    echo "\e[${rc%;}m"
}

# }}}

# {{{ messages
# Example
#   msg "$CWARN" "some warning"

CINFO=$(ansi_color fg-green bold)
CWARN=$(ansi_color fg-yellow bold)
CERROR=$(ansi_color fg-red bold)

msg() {
    echo -e "$1$PROG: $2\e[0m" >/dev/stderr
}

abort() {
    msg "$CERROR" "$2"
    exit "$1"
}

# }}}

# {{{ argument parsing
# Usage:
# * describe valid arguments in ARGS assosiative array
# * call `argparse` with "$@" or any other argument list
# * ARGS will have updated values, and ARGS_REST - all arguemnts after `--`
#   or first unknown argument
# Example:
#   ARGS=([FOO]="foo1" [BAR]="" [BAZ]="")
#   argparse "$@"
#   for k in "${!ARGS[@]}"; do echo "$k=${ARGS[$k]}"; done
#   for k in "${!ARGS_REST[@]}"; do echo "$k=${ARGS_REST[$k]}"; done

usage() {
    sed -n '2,/^$/ s/^#[[:space:]]*//p' "$0"
}

declare -A ARGS

set_var() {
    local name="${1%%=*}"
    name="${name//-/_}"
    name="${name^^}"
    if [[ -z "${ARGS[$name]+exists}" ]]; then
        abort 1 "$name: is undeclared"
    fi
    ARGS[$name]="${1#*=}"
}

argparse() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        --version)
            echo "$PROG $VERSION"
            exit 0
            ;;
        --*=*)
            set_var "${1:2}"
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            msg "$CERROR" "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            break
            ;;
        esac
    done
    ARGS_REST=("$@")
}
# }}}

size_in_bytes() {
    local size=$1
    local unit=$2

    case $unit in
    K | k) # Kilobytes
        echo $((size * 1024))
        ;;
    M | m) # Megabytes
        echo $((size * 1024 * 1024))
        ;;
    G | g) # Gigabytes
        echo $((size * 1024 * 1024 * 1024))
        ;;
    *)
        echo "Invalid unit '$unit'. Use K, M, or G."
        exit 1
        ;;
    esac
}

size_in_unit() {
    local size="$1"
    local iunit="$2"
    local ounit="$3"

    size=$(size_in_bytes "$size" "$iunit")
    for iunit in B K M G; do
        if [ -z "$ounit" ]; then
            echo "$size $iunit"
        elif [ "$iunit" = "$ounit" ]; then
            echo "$size"
            break
        fi
        size=$((size / 1024))
    done
}
