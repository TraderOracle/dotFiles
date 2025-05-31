#!/usr/bin/osascript
# sketchybar/scripts/emails.applescript
on run
  tell application "Mail"
    return the unread count of inbox
  end tell
end run
