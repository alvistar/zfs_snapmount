# ZFS Snapshot and Mount Script

This script allows you to mount recursive ZFS snapshots of a dataset (optionally creating new ones), execute a command, and finally unmount them.

## Prerequisites

- ZFS must be installed on your system.
- Ensure you have the necessary permissions to create and manage ZFS datasets and snapshots.

## Usage

```bash
./zfs_snapmount.sh [OPTIONS] <dataset> <snapshot_name>
```

### Options

- `-m, --mountpoint <arg>`: Mount point for the snapshot (default: `/mnt/snapshots`).
- `-e, --exec <arg>`: Command to execute after mounting the snapshot.
- `-u, --unmount`: Unmount the snapshot recursively (off by default).
- `-c, --create-snapshot`: Create a new snapshot (off by default).
- `-k, --keep`: Keep the created snapshot (only applicable with `--create-snapshot`) (off by default).
- `-h, --help`: Prints help.

### Examples

1. Create a new snapshot and mount it:
   ```bash
   ./zfs_snapmount.sh -c mydataset mysnapshot
   ```

2. Use an existing snapshot, mount it, and execute a command:
   ```bash
   ./zfs_snapmount.sh -e "ls -la /mnt/snapshots" mydataset mysnapshot
   ```

3. Unmount the snapshot after executing a command:
   ```bash
   ./zfs_snapmount.sh -u -e "ls -la /mnt/snapshots" mydataset mysnapshot
   ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
