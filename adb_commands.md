## Add WiFi

Installs a helper APK (if not present), then connects the device to a WPA network.

### Check if helper is installed
```
adb shell pm list packages | grep com.steinwurf.adbjoinwifi
```

### Install helper
```
adb install adb-join-wifi.apk
```

### Connect to network
```
adb shell am start -n com.steinwurf.adbjoinwifi/.MainActivity -e ssid <ssid> -e password_type WPA -e password <password>
```

### Stop helper app
```
adb shell am force-stop com.steinwurf.adbjoinwifi
```

---

## Airplane Mode

Options:
- On
- Off

> On unrooted devices the broadcast is skipped and a manual reboot is required.

### On
```
adb shell settings put global airplane_mode_on 1
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE
```

### Off
```
adb shell settings put global airplane_mode_on 0
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE
```

---

## Animation Scale

Sets window, transition, and animator duration scales simultaneously.

Options:
- off
- 0.5
- 1
- 1.5
- 2
- 5
- 10
- reset

### off
```
adb shell settings put global window_animation_scale 0.0
adb shell settings put global transition_animation_scale 0.0
adb shell settings put global animator_duration_scale 0.0
```

### 0.5
```
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
```

### 1
```
adb shell settings put global window_animation_scale 1.0
adb shell settings put global transition_animation_scale 1.0
adb shell settings put global animator_duration_scale 1.0
```

### 1.5
```
adb shell settings put global window_animation_scale 1.5
adb shell settings put global transition_animation_scale 1.5
adb shell settings put global animator_duration_scale 1.5
```

### 2
```
adb shell settings put global window_animation_scale 2.0
adb shell settings put global transition_animation_scale 2.0
adb shell settings put global animator_duration_scale 2.0
```

### 5
```
adb shell settings put global window_animation_scale 5.0
adb shell settings put global transition_animation_scale 5.0
adb shell settings put global animator_duration_scale 5.0
```

### 10
```
adb shell settings put global window_animation_scale 10.0
adb shell settings put global transition_animation_scale 10.0
adb shell settings put global animator_duration_scale 10.0
```

### reset
```
adb shell settings put global window_animation_scale 1.0
adb shell settings put global transition_animation_scale 1.0
adb shell settings put global animator_duration_scale 1.0
```

---

## Clear App Data

```
adb shell pm clear <package>
```

---

## Demo Mode

Configures the system status bar to a clean demo state (WiFi full, battery 100%, clock 14:00, no notifications).

Options:
- On
- Off

### On
```
adb shell settings put global sysui_demo_allowed 1
adb shell am broadcast -a com.android.systemui.demo -e command enter
adb shell am broadcast -a com.android.systemui.demo -e command network -e wifi show -e level 3 -e fully true
adb shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 1400
adb shell am broadcast -a com.android.systemui.demo -e command notifications -e visible false
adb shell am broadcast -a com.android.systemui.demo -e command battery -e plugged false
adb shell am broadcast -a com.android.systemui.demo -e command battery -e level 100
```

### Off
```
adb shell am broadcast -a com.android.systemui.demo -e command exit
adb shell settings put global sysui_demo_allowed 0
```

---

## Disable Audio

Lowers a stream's volume to its minimum by repeatedly decrementing it.

Options:
- voice_call
- system
- ring
- music
- alarm
- notification
- dtmf
- accessibility

### voice_call
```
adb shell media volume --stream 0 --adj lower
```
*(repeated 20 times)*

### system
```
adb shell media volume --stream 1 --adj lower
```
*(repeated 20 times)*

### ring
```
adb shell media volume --stream 2 --adj lower
```
*(repeated 20 times)*

### music
```
adb shell media volume --stream 3 --adj lower
```
*(repeated 20 times)*

### alarm
```
adb shell media volume --stream 4 --adj lower
```
*(repeated 20 times)*

### notification
```
adb shell media volume --stream 5 --adj lower
```
*(repeated 20 times)*

### dtmf
```
adb shell media volume --stream 8 --adj lower
```
*(repeated 20 times)*

### accessibility
```
adb shell media volume --stream 10 --adj lower
```
*(repeated 20 times)*

---

## Display Info

```
adb shell wm density
adb shell wm size
```

---

## Display Scale

Adjusts display density relative to the physical density.

Options:
- small (×0.85)
- default
- large (×1.1)
- larger (×1.2)
- largest (×1.3)

### small
```
adb shell wm density
adb shell wm density <physical_density * 0.85>
```

### default
```
adb shell wm density reset
```

### large
```
adb shell wm density
adb shell wm density <physical_density * 1.1>
```

### larger
```
adb shell wm density
adb shell wm density <physical_density * 1.2>
```

### largest
```
adb shell wm density
adb shell wm density <physical_density * 1.30>
```

---

## Font Scale

Options:
- small (0.85)
- default (1.0)
- large (1.15)
- largest (1.30)

### small
```
adb shell settings put system font_scale 0.85
```

### default
```
adb shell settings put system font_scale 1
```

### large
```
adb shell settings put system font_scale 1.15
```

### largest
```
adb shell settings put system font_scale 1.3
```

---

## Launch App

```
adb shell monkey --pct-syskeys 0 -p <package> 1
```

---

## Launch System Settings

```
adb shell am start -a android.settings.SETTINGS
```

---

## Layout Bounds

Options:
- Show
- Hide

> Pokes the system after each `setprop` so the change takes effect without a reboot.

### Show
```
adb shell setprop debug.layout true
adb shell service call activity 1599295570
```

### Hide
```
adb shell setprop debug.layout false
adb shell service call activity 1599295570
```

---

## List Packages

```
adb shell pm list packages
```

---

## Max Brightness

```
adb shell settings put system screen_brightness 255
```

---

## Night Mode

Options:
- On
- Off
- Auto

### On
```
adb shell "cmd uimode night yes"
```

### Off
```
adb shell "cmd uimode night no"
```

### Auto
```
adb shell "cmd uimode night auto"
```

---

## Permissions

Lists granted and denied permissions for a package.

```
adb shell dumpsys package <package>
```
*(output filtered for `granted=true` / `granted=false`)*

---

## Processor Info

```
adb shell cat /proc/cpuinfo
```

---

## Pull APKs

Downloads all APK splits for a package from the device.

### Get APK path(s)
```
adb shell pm path <package>
```

### Pull each APK
```
adb pull <location> [destination]
```

---

## Reboot

Reboots the device and waits until boot is complete.

```
adb reboot
adb wait-for-device
adb shell getprop sys.boot_completed
```
*(polls `sys.boot_completed` every second, up to 60 s)*

---

## Screenshot

```
adb exec-out screencap -p > <filename>.png
```

---

## Shared Prefs

Options:
- list
- list \<filename\>
- remove \<filename\> \<pref_name\>

### list (all files)
```
adb shell
  run-as <package>
  ls -al /data/data/<package>/shared_prefs
```

### list \<filename\>
```
adb shell
  run-as <package>
  cat /data/data/<package>/shared_prefs/<filename>
```

### remove \<filename\> \<pref_name\>
```
adb shell
  run-as <package>
  if [ -e /data/data/<package>/shared_prefs/<filename> ]; then echo true; else echo false; fi
  sed -i '/^.*name="<pref_name>".*$/d' /data/data/<package>/shared_prefs/<filename>
```

---

## TalkBack

Options:
- On
- Off

### On
```
adb shell settings put secure enabled_accessibility_services com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService
```

### Off
```
adb shell settings put secure enabled_accessibility_services com.android.talkback/com.google.android.marvin.talkback.TalkBackService
```

---

## Uninstall Package

```
adb uninstall <package>
```

---

## Version Name

```
adb shell dumpsys package <package>
```
*(output filtered for `versionName`)*
