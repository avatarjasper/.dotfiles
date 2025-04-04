This is all the things to remember when doing a new arch linux install/good applications to have, and personal things i made.


# dotfiles

dotfiles should be present in the GitHub. They can be downloaded from there, then the .installed_packages can be used to install all the packages in the following way:

    sudo pacman -S $(cat .installed_packages)


# installed_packages

If you are to add and remove packages, and want to update the .installed_packages list, you can use the bash script in

    ~/installed_packages/get_installed_packages.sh

This will update the .installed_packages and .installed_packages_verbose files.


## Alias for adding changes to the online dotfiles

You will most likely want to add the changes to the dotfiles.

for this you need the git folder to be present. See Arch:dotfiles page:

    https://wiki.archlinux.org/title/Dotfiles

as can be seen, an alias is needed, which can be made using the command given in:

    ~/.dotfiles/alias_dotfiles


