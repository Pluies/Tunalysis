#!/usr/bin/ruby

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
# along with Tunalysis.  If not, see <http://www.gnu.org/licenses/>.
# ---------------------------------------------------------------------
#
# Tunalysis - Analyse your iTunes Library
#
# Copyright 2010 Florent Delannoy

require 'rubygems'
require 'bundler/setup'
require 'date'
require 'plist'
require 'colorize'

default_library_path = "/Users/" + `whoami`.chomp + "/Music/iTunes/iTunes Music Library.xml"

if File.exist? default_library_path
	library_path = default_library_path
else
	raise "No library file at default path (#{default_library_path}). :("
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

puts "\n|   Tunalysis report   |\n\n"
tracks = library["Tracks"]
puts "#{tracks.count} "+"songs".white
puts "#{library["Playlists"].count} "+"playlists".white

max_year = max_bitrate = year = year_count = bitrate = length = playtime = playcount = skipcount = 0
min_year = min_bitrate = (1/0.0) # i.e. infinity
ranking = {}
tracks.each do |key, song|
	play = song["Play Count"] = (song["Play Count"] or 0) # Initializes "Play count" to 0 if it doesn't exist
	skip = song["Skip Count"] = (song["Skip Count"] or 0) # used for displaying the ranking
	# Various calculations
	length += song["Total Time"]
	playtime += song["Total Time"] * play
	bitrate += song["Bit Rate"]
	max_bitrate = song["Bit Rate"] if song["Bit Rate"] > max_bitrate
	min_bitrate = song["Bit Rate"] if song["Bit Rate"] < min_bitrate
	if song["Year"]
		max_year = song["Year"] if song["Year"] > max_year
		min_year = song["Year"] if song["Year"] < min_year
		year += song["Year"]
		year_count += 1
	end
	playcount += play
	skipcount += skip
	# Ranking algorithm
	rank = play**4 / (skip+1)**3 + (play**3 - skip**2)
	ranking[key] = rank
	#p song["Name"]
	#p rank
end

def ms_to_hash milliseconds
	time = milliseconds / 1000
	hash = {}
	hash[:days] = time/86400
	remainder = time % 86400
	hash[:hours] = remainder/3600
	remainder = remainder % 3600
	hash[:minutes] = remainder/60
	remainder = remainder % 60
	hash[:seconds] = remainder
	return hash
end

avg_length = ms_to_hash length/tracks.count
puts "Average song length: ".white + "#{avg_length[:minutes]}:%2d" % avg_length[:seconds]
puts "Average bitrate: ".white + "#{bitrate/tracks.count}kbps (min #{min_bitrate}kbps, max #{max_bitrate}kbps)"
puts "Total songs played: ".white + "%d" % playcount
puts "Total songs skipped: ".white + "%d" % skipcount
puts "Average play count: ".white + "%.2f" % (playcount.to_f/tracks.count)
puts "Average skip count: ".white + "%.2f" % (skipcount.to_f/tracks.count)
puts "Average song age: ".white + "%.0f years (oldest is from #{min_year}, newest is from #{max_year})" % (Date.today.year-(year/year_count))

playhash = ms_to_hash playtime
puts "Total time spent listening to music: ".white + "#{playhash[:days]} days, #{playhash[:hours]} hours, #{playhash[:minutes]} minutes and #{playhash[:seconds]} seconds"

def top_5 (library, ranking)
	ranking.take(5).each do |key, rank|
		song = library["Tracks"][key]
		puts "#{song["Name"]} "+"by".white + " #{song["Artist"]}"+" (#{song["Play Count"]} plays, #{song["Skip Count"]} skips, computed score: #{rank})".white
	end
end

ranking = ranking.sort_by{|key, rank| -rank}
puts "\nYour five favourite songs according to my calculations:".green
top_5 library, ranking
puts "\nThe five songs that you might not like that much:".red
top_5 library, ranking.reverse


