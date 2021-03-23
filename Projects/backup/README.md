# Current Dotfiles

- .bashrc
- .gitconfig
- .config/i3/
- .config/polybar/
- .config/wallpapers/
- .vimrc
- .config/yadm/bootstrap
- Projects/backup
- Projects/scripts

## Backup Script
- Uploads all dotfiles/important files via 'yadm'
- Asks before doing so, since this could potentially overwrite files in the GitHub repository
- Available anywhere via the command `backup`
- Adds current timestamp to commit message

## YADM Bootstrap Script
- Installs all packages from 'packages.txt', and sets up the system how I want
- VIM customization with Vundle
- i3-gaps + polybar
- Custom i3 lock screen
- Customizes GRUB2 theme
- Disables splash screen
- Removes unnecessary home directory folders to clean up
- Sets desired terminal configuration
- Installs PIA VPN
- ... and much more!
