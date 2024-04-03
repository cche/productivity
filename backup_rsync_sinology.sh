#!/bin/bash

# Set the remote server IP address or hostname
REMOTE_SERVER="195.221.242.251"

# Delete old backups
function delete_old_backups() {
  # Get the number of backups to keep
  NUM_BACKUPS_TO_KEEP=$1

  # Get a list of all the backup directories on the remote server
  BACKUP_DIRS=$(ssh "$REMOTE_SERVER" "ls -d /volume1/homes/cristian.chaparro/batudahue/*")

  # Sort the backup directories by date, newest first
  BACKUP_DIRS_SORTED=$(echo "$BACKUP_DIRS" | sort -r)

  # Delete any older backups
  for i in $(seq "$NUM_BACKUPS_TO_KEEP" $((${#BACKUP_DIRS_SORTED[@]} - 1))); do
    ssh "$REMOTE_SERVER" "rm -rf /volume1/homes/cristian.chaparro/batudahue/${BACKUP_DIRS_SORTED[$i]}"
  done
}

# Check if the remote server is reachable
ping -c1 -W1 -q "$REMOTE_SERVER"

# Check the exit status of the ping command
if [[ $? -eq 0 ]]; then
  echo "The remote server is reachable."

  # Run rsync to create the incremental backup
  rsync -avz --delete --link-dest="$REMOTE_SERVER:/volume1/homes/cristian.chaparro/batudahue/$(date +%Y-%m-%d)" \
        --exclude=".git/" \
        --exclude=".gitignore" \
        --exclude="perso" \
        --exclude="libraries" \
        --exclude="fastq" \
        --exclude="bam" \
        --exclude="Downloads" \
      "/home/cristian/Documents /home/cristian/work" "$REMOTE_SERVER:/volume1/homes/cristian.chaparro/batudahue/$(date +%Y-%m-%d)"

  # Delete old backups
  delete_old_backups 4

  # Print a message to the user
  echo "Incremental backup complete!"
else
  echo "The remote server is not reachable."
fi
