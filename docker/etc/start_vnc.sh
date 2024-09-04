#!/bin/bash

# # Start Xvfb
Xvfb :0 -screen 0 1280x720x16 & > /dev/null 2>&1

# start fluxbox
fluxbox & > /dev/null 2>&1

# Start x11vnc
x11vnc -forever -usepw -create -display :0