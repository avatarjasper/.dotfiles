#!/bin/bash
pacman -Q|cut -d " " -f1 > ~/installed_packages/.installed_packages
pacman -Qe > ~/installed_packages/.installed_packages_verbose
