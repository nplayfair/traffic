#!/usr/bin/env ruby

require 'rubygems'
require 'wiringpi'

begin

  ## Functions
  
  # Reset GPIO
  def reset_gpio (io, lights)
    lights.each do |name, pin|
      io.digital_write pin, 0
    end
  end

  # Blink
  def blink (io, led, blinks)
    # Blink the LED of the passed in GPIO object
    blinks.times do
      io.digital_write led, 1
      sleep 0.5
      io.digital_write led, 0
      sleep 0.5
    end
  end

  # Setup Pins
  lights = {
    :red    => 0,
    :amber  => 1,
    :green  => 2,
    :walk   => 6
  }
  BUTTON = 3

  # Instantiate object
  io = WiringPi::GPIO.new

  io.pin_mode BUTTON, WiringPi::INPUT

  lights.each do |key, led|
    io.pin_mode led, WiringPi::OUTPUT
  end

  # Set initial state
  state = 0
  lights.each do |name, led|
    io.digital_write led, 0
  end
  io.digital_write lights[:green], 1

  # TESTS
  # blink(io, lights[:walk], 3)

  # Wait for button to be pressed, then start traffic light routine
  loop do
    state = io.digital_read BUTTON
    if state == 1 # Button pressed

      # Wait
      blink io, lights[:walk], 4

      # Traffic lights to amber
      io.digital_write lights[:green], 0
      io.digital_write lights[:amber], 1
      sleep 3

      # Traffic lights to red
      io.digital_write lights[:amber], 0
      io.digital_write lights[:red], 1

      # Walk light on
      io.digital_write lights[:walk], 1
      sleep 7

      # Flash walk light, traffic lights to red + amber
      # blink(lights.[:amber])
      io.digital_write lights[:amber], 1
      sleep 3

      # Traffic lights to green, walk light off
      lights.each do |name, led|
        if name == :green
          io.digital_write led, 1
        else
          io.digital_write led, 0
        end
      end
    end # button if
  end # loop
rescue SignalException
  reset_gpio io, lights
  puts "\nClosing program...\n"
end # program
