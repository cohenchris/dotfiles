#!/bin/bash

echo "********** WARNING ************"
read -p "CREATE A NEW BACKUP? (y/N) " yn

case $yn in
  [Yy]* ) ;;
  *     ) exit;;
esac

# Save terminal settings
cd ~/Projects/backup
#rm profile.dconf
#dconf dump /org/gnome/terminal/legacy/profiles:/ > profile.dconf

cd

declare -a dotfiles=(
  ~/.bashrc
  ~/.gitconfig
  ~/.config/i3/
  ~/.config/polybar/
  ~/.config/wallpapers/
  ~/.config/dunst/
  ~/.vimrc
  ~/.config/yadm/bootstrap
  ~/Projects/backup
  ~/Projects/scripts
)

for i in ${dotfiles[@]}
do
  echo "----- UPLOADING $i -----"
  yadm add $i
  echo
done

curr_date=$(date +"%m-%d-%Y_%T")
yadm commit -m "backup $curr_date"
yadm push origin master
