# ---------------------------------------------------------------------
# Tunalysis is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Tunalysis is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Seitunes.  If not, see <http://www.gnu.org/licenses/>.
# ---------------------------------------------------------------------
#
# Tunalysis — Analyse your iTunes Library
#
# Copyright 2010 Florent Delannoy

require 'rubygems'
require 'plist'

default_library_path = "/Users/" + `whoami`.chomp + "/Music/iTunes/iTunes Music Library.xml"

if File.exist? default_library_path
	library_path = default_library_path
else
	raise "No library file at default path. :("
end

library_size = File.size? library_path
message = case library_size
	  when 0..1024
		  "Hu... This library is tiny. Do you listen to music at all?"
	  when 1024..1024**2
		  "It's smallish. Shouldn't be long."
	  else
		  "Gosh, %.2f Mb?! You're a hoarder, aren't you?" % (library_size.to_f/1024/1024)
	  end

puts "Reading your XML library file... " + message
puts "Parsing your library..."

library = Plist::parse_xml(library_path)

puts "--- Tunalysis report ---"
tracks = library["Tracks"]
puts "#{tracks.count} songs"
puts "#{library["Playlists"].count} playlists"

bitrate = length = playtime = playcount = skipcount = 0
ranking = {}
tracks.each do |key, song|
	# Ranking algorithm
	play = (song["Play Count"] or 0)
	skip = (song["Skip Count"] or 0)
	rank = play# 10 / ((skip * 5)+1)
	ranking[key] = rank
	# Various calculations
	length += song["Total Time"]
	playtime += song["Total Time"] * play
	bitrate += song["Bit Rate"]
	playcount += play
	skipcount += skip
end

avg_length = length/tracks.count / 1000
s = avg_length%60
m = (avg_length-s)/60
puts "Average song length: #{m}:%2d" % s
puts "Average bitrate: #{bitrate/tracks.count}kbps (min kbps•max kbps)"
puts "Average play count: %.2f" % (playcount.to_f/tracks.count)
puts "Average skip count: %.2f" % (skipcount.to_f/tracks.count)

playtime /= 1000
d = playtime/86400
remainder = playtime % 86400
h = remainder/3600
remainder = remainder % 3600
m = remainder/60
remainder = remainder % 60
s = remainder
puts "Total time spent listening to music: #{d} days, #{h} hours, #{m} minutes and #{s} seconds"
puts "Ten songs you should delete according to my calculations: to come..."

