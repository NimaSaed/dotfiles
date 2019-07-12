[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xinput disable $(xinput | grep TouchPad | cut -c 55-56)
#xinput set-prop $(xinput | grep TouchPad | cut -c 55-56) $(xinput list-props $(xinput | grep TouchPad | cut -c 55-56) | grep "Tapping Enabled (" | cut -c 28-30) 1
#xinput set-prop $(xinput | grep TouchPad | cut -c 55-56) $(xinput list-props $(xinput | grep TouchPad | cut -c 55-56) | grep "Accel Speed (" | cut -c 24-26) 0.3
xinput set-prop $(xinput | grep TrackPoint | cut -c 55-56) $(xinput list-props $(xinput | grep TrackPoint | cut -c 55-56) | grep -i "accel speed (" | cut -c 24-26) 0.7
exec i3
