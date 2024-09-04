#!/bin/bash

# ARG_POSITIONAL_SINGLE([dataset],[Parent ZFS dataset])
# ARG_POSITIONAL_SINGLE([snapshot],[Specific snapshot name to mount])
# ARG_OPTIONAL_SINGLE([mountpoint],[m],[Base mount point],[/mnt/snapshots])
# ARG_HELP([Mount or unmount ZFS snapshots recursively])
# ARGBASH_GO

# [ <-- needed because of Argbash

# vvv  PLACE YOUR CODE HERE  vvv

mount_snapshots() {
    local PARENT_DATASET="$1"
    local BASE_MOUNTPOINT="$2"
    local SNAPSHOT_NAME="$3"

    # Get the list of snapshots
    snapshots=$(zfs list -H -t snapshot -o name -r "${PARENT_DATASET}" | grep "@${SNAPSHOT_NAME}$")

    # Array to store mount commands
    declare -a mount_commands
    declare -a mountpoints

    # Loop through each snapshot and prepare mount commands
    while read -r snapshot; do
        # Extract the dataset path and snapshot name
        dataset_path=$(echo "$snapshot" | cut -d'@' -f1)
        snapshot_name=$(echo "$snapshot" | cut -d'@' -f2)
        
        # Create the mount point using the full dataset path
        if [ "$dataset_path" = "$PARENT_DATASET" ]; then
            # For the root dataset, use BASE_MOUNTPOINT directly
            mountpoint="$BASE_MOUNTPOINT"
        else
            relative_path=${dataset_path#$PARENT_DATASET/}
            mountpoint="${BASE_MOUNTPOINT}/${relative_path}"
        fi
        echo "Mountpoint: $mountpoint"

        # Prepare the mount command
        mount_command="mount -t zfs \"$snapshot\" \"$mountpoint\""
        echo "Mount command: $mount_command"
        
        # Store the mount command and mountpoint
        mount_commands+=("$mount_command")
        mountpoints+=("$mountpoint")
    done <<< "$snapshots"

    # Ask for confirmation to execute all mount commands
    read -p "Do you want to execute these mount commands? (y/n): " confirm
    
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        for i in "${!mount_commands[@]}"; do
            mountpoint="${mountpoints[$i]}"
            mount_command="${mount_commands[$i]}"
            
            # Mount the snapshot
            if eval "$mount_command"; then
                echo "Snapshot mounted on $mountpoint"
            else
                echo "Error mounting to $mountpoint"
            fi
        done
    else
        echo "Skipping all mounts"
    fi
}

# Main execution

 mount_snapshots "$_arg_dataset" "$_arg_mountpoint" "$_arg_snapshot"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
