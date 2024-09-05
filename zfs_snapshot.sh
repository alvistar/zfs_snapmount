#!/bin/bash

# ARG_POSITIONAL_SINGLE([dataset],[ZFS dataset to snapshot])
# ARG_POSITIONAL_SINGLE([snapshot_name],[Name of the snapshot])
# ARG_OPTIONAL_SINGLE([mountpoint],[m],[Mount point for the snapshot],[/mnt/snapshots])
# ARG_OPTIONAL_SINGLE([exec],[e],[Command to execute after mounting the snapshot])
# ARG_OPTIONAL_BOOLEAN([unmount],[u],[Unmount the snapshot recursively])
# ARG_OPTIONAL_BOOLEAN([create-snapshot],[c],[Create a new snapshot])
# ARG_OPTIONAL_BOOLEAN([keep],[k],[Keep the created snapshot (only applicable with --create-snapshot)])
# ARG_HELP([Create a ZFS snapshot of a dataset, optionally mount it, execute a command, unmount it, or keep the snapshot])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='meuckh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_mountpoint="/mnt/snapshots"
_arg_exec=
_arg_unmount="off"
_arg_create_snapshot="off"
_arg_keep="off"


print_help()
{
	printf '%s\n' "Create a ZFS snapshot of a dataset, optionally mount it, execute a command, unmount it, or keep the snapshot"
	printf 'Usage: %s [-m|--mountpoint <arg>] [-e|--exec <arg>] [-u|--(no-)unmount] [-c|--(no-)create-snapshot] [-k|--(no-)keep] [-h|--help] <dataset> <snapshot_name>\n' "$0"
	printf '\t%s\n' "<dataset>: ZFS dataset to snapshot"
	printf '\t%s\n' "<snapshot_name>: Name of the snapshot"
	printf '\t%s\n' "-m, --mountpoint: Mount point for the snapshot (default: '/mnt/snapshots')"
	printf '\t%s\n' "-e, --exec: Command to execute after mounting the snapshot (no default)"
	printf '\t%s\n' "-u, --unmount, --no-unmount: Unmount the snapshot recursively (off by default)"
	printf '\t%s\n' "-c, --create-snapshot, --no-create-snapshot: Create a new snapshot (off by default)"
	printf '\t%s\n' "-k, --keep, --no-keep: Keep the created snapshot (only applicable with --create-snapshot) (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-m|--mountpoint)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_mountpoint="$2"
				shift
				;;
			--mountpoint=*)
				_arg_mountpoint="${_key##--mountpoint=}"
				;;
			-m*)
				_arg_mountpoint="${_key##-m}"
				;;
			-e|--exec)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_exec="$2"
				shift
				;;
			--exec=*)
				_arg_exec="${_key##--exec=}"
				;;
			-e*)
				_arg_exec="${_key##-e}"
				;;
			-u|--no-unmount|--unmount)
				_arg_unmount="on"
				test "${1:0:5}" = "--no-" && _arg_unmount="off"
				;;
			-u*)
				_arg_unmount="on"
				_next="${_key##-u}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-u" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-c|--no-create-snapshot|--create-snapshot)
				_arg_create_snapshot="on"
				test "${1:0:5}" = "--no-" && _arg_create_snapshot="off"
				;;
			-c*)
				_arg_create_snapshot="on"
				_next="${_key##-c}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-c" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-k|--no-keep|--keep)
				_arg_keep="on"
				test "${1:0:5}" = "--no-" && _arg_keep="off"
				;;
			-k*)
				_arg_keep="on"
				_next="${_key##-k}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-k" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'dataset' and 'snapshot_name'"
	test "${_positionals_count}" -ge 2 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 2 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_dataset _arg_snapshot_name "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

mount_snapshots() {
    local PARENT_DATASET="$1"
    local BASE_MOUNTPOINT="$2"
    local SNAPSHOT_NAME="$3"

    # Get the list of snapshots
    snapshots=$(zfs list -H -t snapshot -o name -r "${PARENT_DATASET}" | grep "@${SNAPSHOT_NAME}$")

    # Loop through each snapshot and mount directly
    while read -r snapshot; do
        # Extract the dataset path and snapshot name
        dataset_path=$(echo "$snapshot" | cut -d'@' -f1)
        snapshot_name=$(echo "$snapshot" | cut -d'@' -f2)

        # Check if the dataset has mountpoint set to legacy
        mountpoint_property=$(zfs get -H -o value mountpoint "$dataset_path")
        if [ "$mountpoint_property" = "legacy" ]; then
            echo "Skipping dataset $dataset_path with legacy mountpoint"
            continue
        fi

        # Create the mount point using the full dataset path
        if [ "$dataset_path" = "$PARENT_DATASET" ]; then
            # For the root dataset, use BASE_MOUNTPOINT directly
            mountpoint="$BASE_MOUNTPOINT"
        else
            relative_path=${dataset_path#$PARENT_DATASET/}
            mountpoint="${BASE_MOUNTPOINT}/${relative_path}"
        fi

		echo "Mounting snapshot $snapshot to $mountpoint"

        # Mount the snapshot
        if ! mount -t zfs "$snapshot" "$mountpoint"; then
            echo "Error mounting to $mountpoint"
			exit 1
        fi
    done <<< "$snapshots"
}

# Enable exit on error, but with exceptions
set -e

cleanup() {
    # Unmount the snapshot recursively if requested
    if [ "$_arg_unmount" = on ]; then
        echo "Unmounting snapshot recursively..."
        umount -R "$_arg_mountpoint" || echo "Warning: Failed to unmount snapshot"
    fi

    # Destroy the snapshot if it was created and --keep is not set
    if [ "$snapshot_created" = true ] && [ "$_arg_keep" = off ]; then
        echo "Destroying snapshot recursively..."
        zfs destroy -r ${_arg_dataset}@${_arg_snapshot_name} || echo "Warning: Failed to destroy snapshot"
    fi
}

trap cleanup EXIT

if ! command -v zfs &> /dev/null; then
    echo "Error: zfs command not found. Please ensure ZFS is installed."
    exit 1
fi

# Validate --keep option
if [ "$_arg_keep" = on ] && [ "$_arg_create_snapshot" = off ]; then
    echo "Error: --keep option can only be used with --create-snapshot"
    exit 1
fi

snapshot_created=false

if [ "$_arg_create_snapshot" = on ]; then
    echo "Creating recursive snapshot of $_arg_dataset with name $_arg_snapshot_name"
    zfs snapshot -r ${_arg_dataset}@${_arg_snapshot_name}
    echo "Snapshot created successfully: ${_arg_dataset}@${_arg_snapshot_name}"
    snapshot_created=true
else
    echo "Using existing snapshot: ${_arg_dataset}@${_arg_snapshot_name}"
fi

# Check if the snapshot exists
if ! zfs list -t snapshot -o name -Hr "$_arg_dataset" | grep -q "@${_arg_snapshot_name}$"; then
    echo "Error: Snapshot ${_arg_dataset}@${_arg_snapshot_name} does not exist."
    exit 1
fi

# Mount the snapshot using the mount_snapshots function
echo "Mounting snapshots..."
mount_snapshots "$_arg_dataset" "$_arg_mountpoint" "$_arg_snapshot_name"

# Execute the command if provided
if [ -n "$_arg_exec" ]; then
    echo "Executing command: $_arg_exec"
    set +e  # Temporarily disable exit on error
    eval "$_arg_exec"
    exec_exit_code=$?
    set -e  # Re-enable exit on error
    echo "Command exited with code: $exec_exit_code"
fi

# The cleanup function will handle unmounting and destroying the snapshot if needed
exit ${exec_exit_code:-0}

# ] <-- needed because of Argbash
