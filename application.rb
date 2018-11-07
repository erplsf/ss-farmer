require 'rubygems'

require 'watir'
require 'pry-byebug'
require 'dotenv/load'

def password_is_set?
  @password != nil
end

def setup_password!(browser)
  return if password_is_set? || !browser.text_field(placeholder: 'Password').exists?
  password = SecureRandom.hex(16)
  browser.text_field(placeholder: 'Password').set(password)
  sleep(1)
  browser.span(text: 'Next').click
  sleep(5)
  @password = password
end

opts = {headless: ENV['HEADLESS'].to_s == 'true'}
phone_number = ENV['PHONE_NUMBER']

browser = Watir::Browser.new :firefox, opts

browser.goto('https://10minutemail.net/')
email = browser.text_field(id: 'fe_text').value

browser.links.first.click(:command, :shift)
browser.goto('twitter.com/signup')
#browser.link(class: 'StaticLoggedOutHomePage-buttonSignup').click

username = SecureRandom.hex(16)
password = SecureRandom.hex(16)

browser.text_field(placeholder: 'Name').set(username)
browser.div(text: 'Use email instead').click
browser.text_field(placeholder: 'Email').set(email)

sleep(1)

browser.span(text: 'Next').click
browser.span(text: 'Next').click
browser.span(text: 'Sign up', dir: 'auto').click

sleep(2)

setup_password!(browser)

if browser.div(text: 'We sent you a code').exists?
  browser.window(index: 1).use

  browser.td(text: '<verify@twitter.com>').wait_until_present(timeout: 600, interval: 10)
  browser.td(text: '<verify@twitter.com>').click

  code = browser.td(class: ['h1', 'black']).text

  browser.window(index: 0).use

  browser.text_field(placeholder: 'Verification code').set(code)
  sleep(1)
  browser.span(text: 'Next').click

  sleep(5)
end

setup_password!(browser)

binding.pry

browser.text_field(id: 'phone_number').set(phone_number)
browser.input(name: 'call_me').click

print 'Enter code received in call: '
phone_code = gets.strip

browser.text_field(id: 'code').set(phone_code)
browser.button(text: 'Submit').click

setup_password!(browser)

binding.pry

puts 'Success!'
