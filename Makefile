install:
	cd dwm && make && sudo make install
	cd st && make && sudo make install
	cd dmenu && make && sudo make install

download:
	git clone --depth 1 https://git.suckless.org/dwm dwm && rm -rf dwm/.git
	git clone --depth 1 https://git.suckless.org/st st && rm -rf st/.git
	git clone --depth 1 https://git.suckless.org/dmenu dmenu && rm -rf dmenu/.git
