#!/bin/bash

# ARG_OPTIONAL_SINGLE([dataset],[d],[Parent ZFS dataset],[tank/data])
# ARG_OPTIONAL_SINGLE([mountpoint],[m],[Base mount point],[/mnt/snapshots])
# ARG_OPTIONAL_SINGLE([snapshot],[s],[Specific snapshot name to mount/unmount],[])
# ARG_POSITIONAL_SINGLE([command],[Mount or unmount snapshots],[mount])
# ARG_HELP([Mount or unmount ZFS snapshots recursively])
# ARGBASH_GO

# [ <-- needed because of Argbash

# vvv  PLACE YOUR CODE HERE  vvv

mount_snapshots() {
    local PARENT_DATASET="$1"
    local BASE_MOUNTPOINT="$2"
    local SNAPSHOT_NAME="$3"

    # Get the list of snapshots
    if [ -n "$SNAPSHOT_NAME" ]; then
        snapshots=$(zfs list -H -t snapshot -o name -r "${PARENT_DATASET}" | grep "@${SNAPSHOT_NAME}$")
    else
        snapshots=$(zfs list -H -t snapshot -o name -r "${PARENT_DATASET}")
    fi

    # Loop through each snapshot and mount it
    while read -r snapshot; do
        # Extract the snapshot name
        snapshot_name=$(echo "$snapshot" | cut -d'@' -f2)
        
        # Create the mount point
        mountpoint="${BASE_MOUNTPOINT}/${snapshot_name}"
        echo $mountpoint
        # mkdir -p "$mountpoint"
        
        # Mount the snapshot
        # if mount -t zfs -o ro "$snapshot" "$mountpoint"; then
        #     echo "Snapshot $snapshot mounted on $mountpoint"
        # else
        #     echo "Error mounting $snapshot"
        #     rmdir "$mountpoint"
        # fi
    done <<< "$snapshots"
}

unmount_snapshots() {
    local PARENT_DATASET="$1"
    local BASE_MOUNTPOINT="$2"
    local SNAPSHOT_NAME="$3"

    # Get the list of snapshots
    if [ -n "$SNAPSHOT_NAME" ]; then
        snapshots=$(zfs list -H -t snapshot -o name -r "${PARENT_DATASET}" | grep "@${SNAPSHOT_NAME}$")
    else
        snapshots=$(zfs list -H -t snapshot -o name -r "${PARENT_DATASET}")
    fi

    # Loop through each snapshot and unmount it
    while read -r snapshot; do
        # Extract the snapshot name
        snapshot_name=$(echo "$snapshot" | cut -d'@' -f2)
        
        # Unmount the snapshot
        zfs unmount "$snapshot"
        
        if [ $? -eq 0 ]; then
            echo "Snapshot $snapshot unmounted"
            # Remove the mount point directory
            rmdir "${BASE_MOUNTPOINT}/${snapshot_name}"
        else
            echo "Error unmounting $snapshot"
        fi
    done <<< "$snapshots"
}

# Main execution
case "$_arg_command" in
    mount)
        mount_snapshots "$_arg_dataset" "$_arg_mountpoint" "$_arg_snapshot"
        ;;
    unmount)
        unmount_snapshots "$_arg_dataset" "$_arg_mountpoint" "$_arg_snapshot"
        ;;
    *)
        echo "Invalid command. Use 'mount' or 'unmount'."
        exit 1
        ;;
esac

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
