#!/usr/bin/osascript

-- Get URL from Safari
tell application "Safari"
    set safariURL to URL of front document
    close current tab of window 1
end tell

-- Open URL in Chrome
do shell script "open -a 'Google Chrome' " & quoted form of safariURL & " --args --no-startup-window"
