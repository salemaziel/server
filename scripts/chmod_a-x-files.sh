#!/bin/bash
## Script searches filesystem tree from current working directory and removes executable permissions unless it is an executable that *should* have that permission

## Then it changes all directories to 775 permissions aka drwxrwxr-x


# Traverse all files in the current directory and its subdirectories
find . -type f -executable -print0 | while IFS= read -r -d $'\0' file; do
    # Use MIME type for accurate binary detection
    mimetype=$(file --mime-type -b "$file")
    case "$mimetype" in
        application/x-executable|application/x-sharedlib|application/x-dosexec|application/vnd.microsoft.portable-executable)
            echo "Skipping binary file: $file"
            ;;
        *)
            # More comprehensive filesystem check
            fstype=$(stat -f -c %T "$file")
            if [[ "$fstype" != "ntfs" && "$fstype" != "vfat" && "$fstype" != "fuseblk" ]]; then
                # Remove execute permissions for user, group, and others
                chmod a-x "$file"
                echo "Removed execute permission from: $file"
            else
                echo "Skipping file on non-Unix filesystem: $file"
            fi
            ;;
    esac
done

# Change permissions of all directories
find . -type d -exec chmod 775 {} +
