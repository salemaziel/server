#!/usr/bin/env python3

import subprocess
import getpass

def run_command(command, input_data=None):
    result = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        input=input_data,
        check=True,
    )
    return result.stdout.strip()

def wipe_disk(disk, method):
    print(f"Securely wiping /dev/{disk} using method: {method}")

    if method == "slow":
        run_command(["dd", "if=/dev/zero", f"of=/dev/{disk}", "bs=4M", "status=progress"])
    else:
        run_command(
            [
                "sh",
                "-c",
                f"openssl enc -aes-256-ctr -pbkdf2 -pass pass:$(tr -cd '[:alnum:]' </dev/urandom | head -c128) -nosalt </dev/zero | dd of=/dev/{disk} bs=4M status=progress",
            ]
        )

def main():
    disk = input("Enter disk (e.g., sda, hda, mmcblk0, nvme0n1): ")

    print("Choose a wipe method:")
    print("1) Slow (dd if=/dev/zero)")
    print("2) Quick (using openssl + dd)")

    wipe_method = input("Enter your choice [1-2]: ")
    if wipe_method == "1":
        wipe_disk(disk, "slow")
    elif wipe_method == "2":
        wipe_disk(disk, "quick")
    else:
        print("Invalid choice")
        exit(1)

    # Wipe the existing partition table
    run_command(["wipefs", "-a", f"/dev/{disk}"])

    # Create a new partition
    run_command(["parted", "-s", f"/dev/{disk}", "mklabel", "gpt"])
    run_command(["parted", "-s", f"/dev/{disk}", "mkpart", "primary", "0%", "100%"])

    # Set up LUKS encryption on the partition
    partition = f"/dev/{disk}1"
    passphrase = getpass.getpass("Enter passphrase for the encrypted partition: ")
    run_command(["cryptsetup", "luksFormat", "--type", "luks2", partition], input=passphrase)
    run_command(["cryptsetup", "open", partition, "encrypted"], input=passphrase)

    # Create a file system and mount the encrypted partition
    run_command(["mkfs.ext4", "/dev/mapper/encrypted"])
    run_command(["mkdir", "/mnt/encrypted"])
    run_command(["mount", "/dev/mapper/encrypted", "/mnt/encrypted"])

    print("Encrypted partition has been set up and mounted at /mnt/encrypted")

if __name__ == "__main__":
    main()
