#!/bin/bash
git clone --depth 1 https://git.suckless.org/dwm dwm && rm -rf "$_"/.git
git clone --depth 1 https://git.suckless.org/st st && rm -rf "$_"/.git
git clone --depth 1 https://git.suckless.org/dmenu dmenu && rm -rf "$_"/.git
