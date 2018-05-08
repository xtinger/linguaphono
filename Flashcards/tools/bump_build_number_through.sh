#!/bin/bash

# set new $IFS
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
FILES="$1/*-Info.plist"

for plist in $FILES
do
    echo "Updating $plist"

    if [[ -z "$CFBundleVersionNew" ]]
    then
        CFBundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$plist")
        echo "CFBundleVersion = $CFBundleVersion"
         CFBundleVersionNew=$(($CFBundleVersion + 1))
    fi

    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CFBundleVersionNew" "$plist"

    CFBuildDate=$(date)

    /usr/libexec/PlistBuddy -c "Set :CFBuildDate $CFBuildDate" "$plist"

    touch "$plist"
done
# restore $IFS
IFS=$SAVEIFS