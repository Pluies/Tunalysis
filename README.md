Tunalysis
=========

Tunalysis is a little script that will analyse your iTunes library.

It uses [Bleything's plist](https://github.com/bleything/plist) to parse your XML library file, then crunches numbers and gives you a few facts about your library and musical addiction, such as:

* Total number of songs
* Total number of playlists
* Average song length
* Average/max/min bitrate
* Average play count
* Average skip count
* Total time spent listening to music
* Guesses favourite and less appreciated songs

And more to come!


How does it work?
=================

Why, amazingly simply of course:

	$ ruby tunalysis.rb


Bundler integration means the plist and colorize gem are included in the package.

