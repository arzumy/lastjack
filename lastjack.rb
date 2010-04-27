#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'mp3info' # [sudo] gem install ruby-mp3info

LOCATION  = "/Users/arzumy/Music/Audio\ Hijack/" # Audio Hijack Name recordings with: %name %date %time
USER      = "arzumy"
URL       = "http://ws.audioscrobbler.com/2.0/user/#{USER}/recenttracks.rss"
file      = LOCATION+ARGV.join(" ").to_s.split(":").last
sleep     10 #just give some time for rss to be updated
rss       = SimpleRSS.parse open(URL)
track     = rss.items.first.title.split("\342\200\223").map { |r| r.strip }

unless track.empty?
  Mp3Info.open(file) do |mp3|
    mp3.tag.title   = track.last
    mp3.tag.artist  = track.first
  end
end