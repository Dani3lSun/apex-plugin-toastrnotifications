# Oracle APEX DynamicAction Plugin - toastr Notifications
Dynamic Action Plugin using OpenSource JS framework "toastr" to display notifications.
This plugin can be used to display info, success, warning or error messages. (https://github.com/CodeSeven/toastr)


## Changelog
#### 1.0 - Initial Release

## Install
- Import plugin file "dynamic_action_plugin_de_danielh_toastrnotifications.sql" from source directory into your application
- (Optional) Deploy the CSS/JS files from "server" directory on your webserver and change the "File Prefix" to webservers folder.

## Plugin Settings
The plugin settings are highly customizable and you can change:
- Type: Info / Success / Warn / Error (different colors)
- Text: the notification text
- Position (Top Right, Bottom Right, Top Left, Bottom Left, Top Full Width, Bottom Full Width)
- Newest on Top: Display newest notification on top
- Progress Bar: Show a progress bar to visualize the time when a notification disappears.
- Prevent Duplicates: Block notifications with the same text/content to display multiple times.
- Timeout: How long the toast will display without user interaction (in ms). A value of 0 makes a sticky notification.
- Extended Timeout: How long the toast will display after a user hovers over it (in ms).

## How to use
Create a new Dynamic Action with event "on load" or on "Button --> Click". As Action choose "toastr Notifications".

## Demo Application
https://apex.oracle.com/pls/apex/f?p=57743:2

## Preview
![](https://github.com/Dani3lSun/apex-plugin-toastrnotifications/blob/master/preview.png)
---
