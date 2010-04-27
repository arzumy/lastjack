#!/usr/bin/env ruby -wKU

begin require 'rubygems'; rescue LoadError; end
begin require File.expand_path(File.dirname(__FILE__))+'/track'; rescue LoadError; end
%W{simple-rss nokogiri open-uri mp3info}.map { |i| begin require i; rescue LoadError; end }

CONFIG    = YAML.load_file(File.expand_path(File.dirname(__FILE__))+'/config.yml') rescue {}
file      = "/Volumes/#{ARGV.join(' ').gsub(':', '/')}"
sleep     10 #just give some time for rss to be updated
track     = Track.new

Mp3Info.open(file) do |mp3|
  mp3.tag.title   = track.title
  mp3.tag.artist  = track.artist
  mp3.tag.album   = track.album
end if track.valid?