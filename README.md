# lego-flute-toy
A Flute toy made out of Lego and the DE1-Soc board. Plays a note while air is blown to a mic. 

# Introduction
To demonstrate the knowledge learned through ECE243’s lectures and labs, we built upon
existing lab modules to build the lego flute, using the De1-Soc board and lego controller provided by the faculty. 

- Created a Flute Toy made out of Lego with sensors, using Assembly Language Code and the DE1-Soc Board
- Audio Output triggered once air was blown to a microphone
- Note being played varied depending on the fingering positions

# Progress Report 
### March 18, 2018
#### Irene Lee: 
* Wrote code to get sensor values in state mode
* Loaded the sensors with its threshold values

#### Mei Jia Chen (Marinette):
* Built flute body using legos and sensors
* Got flute fingering positions to assign to sensors with corresponding notes

### March 28, 2018:
#### Irene Lee:
* Calculated the Sample Number for each note (ie. Middle C uses a sample of 92)
* Got the Interrupt handler to work for Audio Output, with only one Sample/Tone 

### March 29, 2018:
#### Irene Lee:
* Fixed Bug to have Interrupt Handler accommodate different samples/tones passed in a loop in the main,using a tracking system (of the current Sample index, and whether or not a full wave has been passed)
* Tested the Audio Output using 3 push buttons so that the corresponding note plays when the different keys were pressed.

### March 30, 2018:
#### Mei Jia Chen (Marinette):
* Created code to identify notes given the status of the sensors
* Linked sensor statuses to fingering positions as well as different frequency values
* Have JTAG UART print out what note is currently being played

### April 6, 2018:
#### Irene Lee:
* Linked Meggie’s code with mine
* Combined Audio output with the rest of the code (sensors and JTAG UART)


### April 7, 2018:
#### Mei Jia Chen (Marinette):
* added VGA Screen Display


