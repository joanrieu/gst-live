#debug
verbose 3,h264enc:6

#add_src videotestsrc
desktop endx=1919 #! videoscale ! video/x-raw, height=720
webcam ! videoscale ! video/x-raw, height=180
