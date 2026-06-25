#!/usr/bin/env bash

getdate() {
    date '+%Y-%m-%d_%H.%M.%S'
}
getaudiooutput() {
    pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
}
getactivemonitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

xdgvideo="$(xdg-user-dir VIDEOS)"
if [[ $xdgvideo = "$HOME" ]]; then
  unset xdgvideo
fi
mkdir -p "${xdgvideo:-$HOME/Videos}"
cd "${xdgvideo:-$HOME/Videos}" || exit

if pgrep wf-recorder > /dev/null; then
    notify-send "Recording Stopped" "Stopped" -a 'Recorder' &
    pkill wf-recorder &
else
    if [[ "$1" == "--fullscreen-sound" ]]; then
        notify-send "Starting recording" 'recording_'"$(getdate)"'.mkv' -a 'Recorder' & disown
        wf-recorder -o "$(getactivemonitor)" \
            -c hevc_vaapi \
            -F "scale_vaapi=out_range=full:format=nv12" \
            -p qp=20 \
            -p profile=main \
            -f './recording_'"$(getdate)"'.mkv' \
            --audio="$(getaudiooutput)"
    elif [[ "$1" == "--fullscreen" ]]; then
        notify-send "Starting recording" 'recording_'"$(getdate)"'.mkv' -a 'Recorder' & disown
        wf-recorder -o "$(getactivemonitor)" \
            -c hevc_vaapi \
            -F "scale_vaapi=out_range=full:format=nv12" \
            -p qp=20 \
            -p profile=main \
            -f './recording_'"$(getdate)"'.mkv'
    else
        if ! region="$(slurp 2>&1)"; then
            notify-send "Recording cancelled" "Selection was cancelled" -a 'Recorder' & disown
            exit 1
        fi
        notify-send "Starting recording" 'recording_'"$(getdate)"'.mkv' -a 'Recorder' & disown
        if [[ "$1" == "--sound" ]]; then
            wf-recorder \
                -c hevc_vaapi \
                -F "scale_vaapi=out_range=full:format=nv12" \
                -p qp=20 \
                -p profile=main \
                -f './recording_'"$(getdate)"'.mkv' \
                --geometry "$region" \
                --audio="$(getaudiooutput)"
        else
            wf-recorder \
                -c hevc_vaapi \
                -F "scale_vaapi=out_range=full:format=nv12" \
                -p qp=20 \
                -p profile=main \
                -f './recording_'"$(getdate)"'.mkv' \
                --geometry "$region"
        fi
    fi
fi