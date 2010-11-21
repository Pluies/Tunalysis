Tunalysis
=========

Tunalysis is a little script that will analyse your iTunes library.

It uses [Bleything's plist](https://github.com/bleything/plist) to parse your XML library file, then crunches numbers and gives you a few facts about your library and musical addiction, such as:

* Total number of songs
* Total number of playlists
* Average song length
* Average bitrate
* Average play count
* Average skip count
* Total time spent listening to music

And more to come!

How does it work?
=================

First, you have to install the 'plist' gem by running:

	$ gem install plist

(Depending on your setup, you might need admin rights to install gems.)

Then it works amazingly simply:

	$ ruby tunalysis.rb

