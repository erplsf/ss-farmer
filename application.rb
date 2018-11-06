require 'rubygems'

require 'watir'
require 'pry-byebug'
require 'dotenv/load'

opts = {headless: ENV['HEADLESS'].to_s == 'true'}

browser = Watir::Browser.new :firefox, opts

browser.goto('https://10minutemail.net/')
binding.pry

puts page
