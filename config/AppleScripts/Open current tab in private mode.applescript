#!/usr/bin/osascript
tell application "System Events" to keystroke "n" using {shift down, command down}
delay 1
tell application "Safari" to close current tab of second window
tell application "System Events" to click at {1416, 89}
