#!/bin/bash

cd /app/spice-html5

# Static HTML
python -m SimpleHTTPServer 8080 &

cd /app/

sudo service dbus start

mkdir /tmp/audio_fifo

FIFO=/tmp/audio_fifo/audio.fifo

sudo chmod a+w /etc/pulse/client.conf
sudo chmod a+w /etc/pulse/default.pa

echo "default-sink = fifo_output" >> /etc/pulse/client.conf

echo "load-module module-x11-publish" >> /etc/pulse/default.pa
echo "load-module module-pipe-sink sink_name=fifo_output file=$FIFO format=s16 rate=48000 channels=2" >> /etc/pulse/default.pa

# #DISPLAY set to :99 in base container
sudo Xspice --port 5900 --audio-fifo-dir=/tmp/audio_fifo $DISPLAY &

sleep 1.0

# For use with gstreamer
#/app/pulse/spice-pulseaudio.sh &

#mkfifo -m 666 $FIFO

#gst-launch-1.0 -v alsasrc ! audio/x-raw, channels=2, rate=44100 ! audioconvert ! capsfilter caps = audio/x-raw,format=S16BE,channels=2,rate=44100 ! filesink location = $FIFO &
#gst-launch-1.0 -v alsasrc ! audio/x-raw, channels=2, rate=48000 ! filesink location = $FIFO &


websockify 6080 localhost:5900 > /dev/null 2>&1 &

run_browser google-chrome-stable --no-default-browser-check --disable-popup-blocking --disable-background-networking --disable-client-side-phishing-detection --disable-component-update --safebrowsing-disable-auto-update

