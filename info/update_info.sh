#!/bin/bash

pacman -Qqe > packages.txt
pacman -Qqm > aur-packages.txt

fc-list : family | sort -u > fonts.txt
