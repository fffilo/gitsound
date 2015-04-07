Git sounds
==========

This script creates git template directory and changes global `init.templatedir` configuration:
on every `git init` new templete is added to `.git` directory.

Script is created for each [git hook](http://githooks.com/) which plays some sound if wav file exists.
By default some super mario sounds are downloaded (thanks to [this site](http://themushroomkingdom.net/media/smw/wav)),
but you can customize your own sound theme by adding `{hook-name}.wav` file in `~/.git_sound/` directory...

Enjoy!
