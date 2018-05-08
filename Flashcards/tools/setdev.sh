
#!/bin/sh
ppath="MeetingAt/MeetingAt-Info.plist"
#/usr/libexec/Plistbuddy -c "Print" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleDisplayName 'Roopr β'" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleIdentifier 'com.emanor.meetingat.beta'" $ppath
/usr/libexec/Plistbuddy -c "Set BETAVERSION true" $ppath
/usr/libexec/Plistbuddy -c "Set ORGANIZATIONS true" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleURLTypes:1:CFBundleURLName 'com.emanor.meetingat.beta'" $ppath
/usr/libexec/Plistbuddy -c "Set CFBundleURLTypes:1:CFBundleURLSchemes:0 'vk5662242'" $ppath
/usr/libexec/Plistbuddy -c "Save" $ppath
ppath="MeetingAt/GoogleService-Info.plist"
/usr/libexec/Plistbuddy -c "Set BUNDLE_ID 'com.emanor.meetingat.beta'" $ppath
/usr/libexec/Plistbuddy -c "Set PROJECT_ID 'firebase-roopr'" $ppath
ppath="MeetingAt/RooprNotificationContentExtension/Info.plist"
/usr/libexec/Plistbuddy -c "Set CFBundleIdentifier 'com.emanor.meetingat.beta.RooprNotificationContentExtension'" $ppath
echo "PList set to DEV"
