#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mp3info' # [sudo] gem install ruby-mp3info

CONFIG    = YAML.load_file('config.yml')
URL       = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=1&user=#{CONFIG['user']}&api_key=#{CONFIG['api']}"

file      = "/Volumes/#{ARGV.join(' ').gsub(':', '/')}"
sleep     10 #just give some time for rss to be updated
xml       = Nokogiri::XML(open(URL))

if xml
  Mp3Info.open(file) do |mp3|
    mp3.tag.title   = xml.search("track > name").text
    mp3.tag.artist  = xml.search("track > artist").text
    mp3.tag.album   = xml.search("track > album").text
  end
end