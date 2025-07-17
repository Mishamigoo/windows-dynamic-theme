Windows Dynamic Theme Changer
This repository contains two PowerShell scripts that allow you to dynamically change your Windows theme between Light and Dark modes based on the time of day, and a script to revert your theme to Light mode.

Files
ChangeTheme.ps1: This script automatically switches your Windows theme between Light and Dark mode based on the sunrise and sunset times for a specified location (currently São Paulo, Brazil). It uses a public API to get the precise sunrise and sunset times.

ReverseChangeTheme.ps1: This script forces your Windows theme back to Light mode. It's useful if you want to quickly revert your theme or if the dynamic script causes an unexpected state.

How it Works
ChangeTheme.ps1
Registry Path: It targets the Windows theme settings in the registry (HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize).

Get Current Theme: It reads the AppsUseLightTheme and SystemUsesLightTheme values to determine the current theme (Light, Dark, or Undefined).

Geolocation and Sunrise/Sunset: It uses the https://api.sunrisesunset.io API to fetch sunrise and sunset times for São Paulo, Brazil (latitude: -23.5505, longitude: -46.6333). You can modify these coordinates to your desired location.

Determine Desired Theme: If the current time is between sunrise and sunset, the desired theme is Light; otherwise, it's Dark.

Set Theme: If the desired theme is different from the current theme, it updates the registry values accordingly:

Light Theme: AppsUseLightTheme = 1, SystemUsesLightTheme = 1

Dark Theme: AppsUseLightTheme = 0, SystemUsesLightTheme = 0

Restart Explorer: After changing the theme, it restarts explorer.exe to apply the changes immediately.

ReverseChangeTheme.ps1
Registry Path: Similar to ChangeTheme.ps1, it targets the same registry path.

Set Light Theme: It sets both AppsUseLightTheme and SystemUsesLightTheme values to 1 (Light mode).

Clean Up (Optional but Included): It attempts to remove and then re-add the registry keys to ensure a clean state for Light mode, which can be helpful if automatic theme settings are interfering.

Restart Explorer: If the theme was not already in Light mode, it restarts explorer.exe to apply the changes.

Usage
ChangeTheme.ps1
You can run this script manually, but its primary purpose is to be scheduled to run periodically (e.g., via Task Scheduler) to automatically switch your theme.

PowerShell

.\ChangeTheme.ps1
ReverseChangeTheme.ps1
Run this script directly whenever you want to force your theme back to Light mode.

PowerShell

.\ReverseChangeTheme.ps1
Prerequisites
Windows operating system.

PowerShell 5.1 or later (included by default in Windows 10/11).

Internet connection for ChangeTheme.ps1 to fetch sunrise/sunset data.
