# Makefile used for processing *.csv files created by wardriver.uk
# I unplug the SD card and plug it into my computer
# I use it the following ways
#
# 1) make <no arguments>

#     This copies files from the SD card onto the current directory
#     Then filters the results (removing entries based on SSID, MAC
#     addresses, and geolocation (approximately) see README for more
#     information it then moves them into a "Scrub" directory and
#     packages just the new ones into a gzip tar file for uploading
#     into wigle.net's database NOTE - you have to edit the value of
#     $SDCARD to match the ID of your card

SDCARD=1234-5678

# 2) make creeps
#
#     This runs the FindCreeps script - which identied those MAC
#     addresses you see based on number of different geolocations,-
#     that is - those that might be stalking you.  p.s. It might be
#     your spouse's MAC address. See the FindCreep script for more infomation


#	3) make open

#	Runs a script that counts how many WiFi networks you see that have an SSID, and an OPEN (no encryption), or WEP

all:
	@ [ ! -d /media/$$USER/${SDCARD}/ ] && echo SD card /media/$$USER/${SDCARD} not available && exit 1
	# copy new files
	rsync -av /media/bgb/$SDCARD/*.csv .
	# create ./Scrub directory if it doesn;t exist
	[ ! -d ./Scrub ] && mkdir ./Scrub
	# filter results and move them to the Scrub directory
	./Move2Scrub *.csv

	# now create an upload file of the new results after scrubbing them
	cd ./Scrub
	tar cvf a.tar 	$$( find . -mtime -1 -type f -name \*.csv )
	/bin/rm a.tar.gz
	gzip a.tar
	echo now upload $(pwd)/a.tar.gz to wigle.net

creeps:
	./FindCreeps

count:
	find . -name \*.csv -print0 | xargs -0 cat | ./CalcRatio

