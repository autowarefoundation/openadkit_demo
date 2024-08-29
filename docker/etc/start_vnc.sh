#!/bin/bash

# # Start Xvfb
Xvfb :0 -screen 0 1280x720x16 &

# start fluxbox
fluxbox &

# Start x11vnc
x11vnc -forever -usepw -create -display :0