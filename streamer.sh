#!/bin/bash

source ~/.config/twitch.key

CAPS="videorate ! video/x-raw, framerate=30/1 ! videoconvert"
MIXER="videomixer name=vmix ! $CAPS"
ENCODER=(
  x264enc
  bitrate=768
  speed-preset=faster # CPU/quality tradeoff
  qp-min=30 # quality/VBV-underflow tradeoff
  tune=zerolatency # rtmpsink crashes due to SIGPIPE if there is latency
)
MUXER="flvmux streamable=true"
SINK="rtmpsink location=rtmp://live.justin.tv/app/$KEY"

APPEND=""

function verbose {
  export GST_DEBUG="$@"
}

function debug {
  SINK="filesink location=debug.flv"
}

function add_src {
  APPEND="$@ ! queue ! $CAPS ! vmix. $APPEND"
}

function desktop {
  add_src ximagesrc $@
}

function webcam {
  add_src v4l2src $@
}

source <(cat)

PIPELINE="$MIXER ! queue ! ${ENCODER[@]} ! $MUXER ! queue ! $SINK $APPEND"
exec gst-launch-1.0 $PIPELINE
