Git sounds
==========

This script creates git template directory and This:
on every `git init` new templete is added to `.git` directory.

Script is created for each [git hook](http://githooks.com/) which plays some sound if wav file exists.
By default some super mario sounds are downloaded (thanks to [this site](http://themushroomkingdom.net/media/smw/wav)),
but you can customize your own sound theme by adding `{hook-name}.wav` file in `~/.git_sounds/` directory...

### How to install

	# clone repository
	git clone https://github.com/fffilo/gitsound.git
	cd gitsound

	# make script executable
	chmod +x gitsound.sh

	# execute script
	./gitsound.sh
	#######################
	# follow instructions #
	#######################

	# remove repository
	cd ..
	rm gitsound -rf

### How to use sounds on existing git repositiories

Script changes global `init.templatedir` configuration, so sounds will be available only on new repositories (after executing `git init`).
To play sounds for existing repositories just copy hooks from template directory to `.git/hooks/` directory:

	cp ~/.git_template/hooks/* /path/to/git/repository/.git/hooks

Enjoy!
