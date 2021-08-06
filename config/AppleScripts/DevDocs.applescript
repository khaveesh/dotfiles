#!/usr/bin/osascript

on run {theURL}
	set found to false
	set targetUrl to "https://devdocs.io"
	
	tell application "Safari Technology Preview"
		repeat with tabIt in tabs of window 1
			if URL of tabIt contains targetUrl then
				set found to true
				set the URL of tabIt to theURL
				tell window 1 to set current tab to tabIt
				activate
			end if
		end repeat
	end tell
	
	if not found then
		do shell script "open " & quoted form of theURL
	end if
end run
