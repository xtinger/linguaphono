#!/bin/sh
ppath="MeetingAt/MeetingAt-Info.plist"
#/usr/libexec/Plistbuddy -c "Print" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleDisplayName 'Roopr'" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleIdentifier 'com.emanor.roopr'" $ppath
/usr/libexec/Plistbuddy -c "Set BETAVERSION false" $ppath
/usr/libexec/Plistbuddy -c "Set ORGANIZATIONS false" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleURLTypes:1:CFBundleURLName 'com.emanor.roopr'" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleURLTypes:1:CFBundleURLSchemes:0 'vk5862699'" $ppath
/usr/libexec/Plistbuddy -c "Save" $ppath
ppath="MeetingAt/GoogleService-Info.plist"
/usr/libexec/Plistbuddy -c "Set BUNDLE_ID 'com.emanor.roopr'" $ppath
/usr/libexec/Plistbuddy -c "Set PROJECT_ID 'firebase-roopr'" $ppath
ppath="MeetingAt/RooprNotificationContentExtension/Info.plist"
/usr/libexec/Plistbuddy -c "Set CFBundleIdentifier 'com.emanor.roopr.RooprNotificationContentExtension'" $ppath
echo "PList set to PROD"
