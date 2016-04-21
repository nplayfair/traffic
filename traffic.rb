#!/usr/bin/env ruby

require 'rubygems'
require 'wiringpi'

begin

# Setup Pins
lights = {
  :red    => 0,
  :amber  => 1,
  :green  => 2
}

BUTTON = 3

# Instantiate object
io = WiringPi::GPIO.new

io.pin_mode BUTTON, WiringPi::INPUT

lights.each do |led|
  io.pin_mode led, WiringPi::OUTPUT
end

# Set initial state
state = 1

# Wait for button to be pressed, then start traffic light routine
loop do
  state = io.digital_read BUTTON
  if state == 0
    # Button pressed
  end
end