[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xinput set-prop $(xinput | grep Touchpad | cut -c 55-56) $(xinput list-props $(xinput | grep Touchpad | cut -c 55-56) | grep -i "tapping enabled (" | cut -c 28-30) 1
xinput set-prop $(xinput | grep Touchpad | cut -c 55-56) $(xinput list-props $(xinput | grep Touchpad | cut -c 55-56) | grep -i "Natural Scrolling Enabled (" | cut -c 38-40) 1
exec i3
