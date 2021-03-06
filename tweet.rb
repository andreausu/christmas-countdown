#!/usr/bin/env ruby

require 'yaml'
require 'twitter'

config_file = File.dirname(__FILE__) + '/config.yml'

if !File.exist?(config_file)
  raise "Configuration file " + config_file + " missing!"
end

CONFIG = YAML.load_file(config_file)

client = Twitter::REST::Client.new do |config|
  config.consumer_key = CONFIG['twitter']['consumer_key']
  config.consumer_secret = CONFIG['twitter']['consumer_secret']
  config.access_token = CONFIG['twitter']['oauth_token']
  config.access_token_secret = CONFIG['twitter']['oauth_token_secret']
end

curtime = Time.new

year = curtime.year
if curtime.month == 12 && curtime.day > 25
  year += 1
end

christmas = Time.new(year, 12, 25) # 00:00:00 current timezone

seconds_diff = (christmas - curtime).to_f

if seconds_diff > 0
  days_to_christmas = (seconds_diff / (60 * 60 * 24)).ceil
else
  days_to_christmas = 0
end

if curtime.day == 25 && curtime.month != 12
	months_left = 12 - curtime.month
  month_text_prefix = ''
	if months_left == 1
		month_text = 'a month'
	else
		month_text = "#{months_left} months"
	end
  if months_left <= 3
    month_text_prefix = 'Only '
  end
	text = "#{month_text_prefix}#{month_text} left to Christmas! 🎅🏻🎄"
elsif days_to_christmas == 1
	text = "Only a few hours left to Christmas! 🎅🏻🎄"
elsif days_to_christmas == 0
	text = "Christmas has finally arrived! 🎅🏻🎄 Go open your presents! 🎁"
elsif days_to_christmas == 7
	text = "Only a week left to Christmas! Santa is coming to town! 🎅🏻🎄"
elsif days_to_christmas <= 100
	text = "Only #{days_to_christmas} days left to Christmas! 🎅🏻🎄"
else
	text = "#{days_to_christmas} days left to Christmas! 🎅🏻🎄"
end

puts text

client.update text
