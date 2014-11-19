#!/bin/bash

# RasPiComm+ Example Project LED Array

# prints general info
function print_info() {
  echo "RasPiComm+ Example Project 1"
  echo "Controlling an LED-Array with an potentiometer"
  echo ""
}

# exports the supplied gpio and configues it as an output
function init_gpio() {
  if [[ ! -d /sys/class/gpio/gpio$1 ]]; then
    echo $1 > /sys/class/gpio/export
    sleep 0.5 # insert a small delay, as the gpio is not instantly available and the direction change may fail
  fi
  echo out > /sys/class/gpio/gpio$1/direction
}

# sets the specified output high
function set_output() {
  echo 1 > /sys/class/gpio/gpio$1/value
}

# sets the specified output low
function clear_output() {
  echo 0 > /sys/class/gpio/gpio$1/value
}

# initializes the gpios
function init_gpios() {
  echo "initializing gpios"
  init_gpio 55;
  init_gpio 56;
  init_gpio 57;
  init_gpio 58;
  init_gpio 59;
  init_gpio 60;
  init_gpio 61;
  init_gpio 62;
}

# sets the leds according to the supplied value
function set_led() {
  local value=$1
  local led_count="$(( ($value / 500) ))"

  # debugging statement 
  #echo "-> led_count: ${led_count}"

  local index=0
  while [[ $index -lt 8 ]]
  do

    if [[ $index -lt $led_count ]]; then
      set_output $(($index+55))
    else
      clear_output $(($index+55))
    fi

    index=$(($index+1))
  done
}

# read the value of the analog input into the variable VALUE
function get_analog_value() {
  # we read the value of the of port 0 of the analog input in module 1
  VALUE=`cat /proc/rpc+/module1/inputanalog0`
}

function main() {

  # print the startup info
  print_info;

  # initialize the gpios
  init_gpios;

  echo "reading analog input and setting outputs..."

  # keep looping forever
  while [[ 1 ]]
  do
    get_analog_value;
    local analog_value=$VALUE

    # when debugging, uncomment the following line to view the analog value
    #echo $analog_value;

    set_led $analog_value;

    # when debugging, uncomment the following line!
    # sleep 1;
  done
}

# main entry point
main;
