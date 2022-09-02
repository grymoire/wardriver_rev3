This directory contains UNIX shell scripts that can process *.csv files
One set of scripts can be used to whitelist devices. If you do not want certain SSID or MAC addresses to
be uploaded to the Wigle.net databasem these scripes can help you do
this.

It can remove devices by geolocation, SSID, or MAC addresses.

You way want to do this to remove your own network, or your employer's
network, from the Wigle.net database. Some managers may not appreciate
their employee's increasing their company's attack surface.

The other set of scripts can be used to find stalkers - or those that might be tracking you.
It looks for MAC addresses seen in more than one location.


# Whitelist tools


First step is to remove the SD card and copy files onto a local directory. I use rsync.
You could copy these files onto the SD card and run the scripts there if you wish.


Summary - the filtering process should be tuned to meet your
requirements. You must collect all SSID and MAC addresses, and obtain
the geolocation. This can be done by using the wardriver.uk setup and
staying within the local boundary. Then use this information to modify the scripts.


There are three filter scripts - used to filter input. You pipe a
*.csv file into the filter and it outputs a subset of the lines.

    Here - Only prints devices in the local area
    NotHere - The opposite of Here - only prints devices not in the local area. 
    NotMine - Only prints lines with SSID or MAC addresses that are not whitelisted

Here and NotHere are almost identical - the only difference is the
decision is the opposite of each other.

These filters have to be modified to match your needs.

    Here and NotHere need to have the values MYLAT and MYLONG modified to meet your needs/

    NotMine contains a list of sed commands to delete lines. You need to add new 
    MAC addresses and SSID names.
    
Once tuned, the script Move2Scrub modifies the *.csv files and moves
them into a Scrub directory, whose files have been "scrubbed clean"
and no longer contain local SSID's or MAC addresses.

Here's a step-by-step set of directions.

step 1 - customize filters

    * Add MAC and SSID addresses to NotMine
    * Add local co-ordinates to scripts Here and NotHere

    Collect local data and get the LAT and LONG values from the *.csv files, 
    along with the MAC addresses and SSID values.

step 2 - test your filters

    cat *.csv | Here

    This will print devices near your location. if there are too many, make delta smaller. 
    If too few, make delta larger

step 3 - tune filters

        Adjust filters by modifying your location, and the delta values
        For each of the SSID and MAC addresses you  want to whilelist, add a line to NotLocal in the format

        /MACADDRESS/d
    or
        /SSIDNAME/d


    This is the sed command to delete any line that has that SSID or MAC address. Be aware that 
    it will match longer strings, so that

        /Burger/d
    will delete SSID's Burger, BurgerMax, BurgerQueen, SuperBurger, etc. You may have to include 
    the commas (The field seperators) in the string to prevent this, like
        /,Burger,/d
    

    
        
step 4 - make a directory for scrubbed files 

    mkdir Scrub - note - the script will do this for you now

step 5 - scrub each file

    ./Move2Scrub *.csv
    
step 6
        upload the scrubbed files    
        There are in the scrubbed directory you created

# Stalker tools

The script ./FindCreeps will look at all of the *.csv files in the
current directory, and identify those MAC addresses seen in more than
one location. It then sorts and reports the top 10 devices - showing
most frequent MAC address first. It then does a GREP to print the raw data
using "grep MACADDRESS *.csv"

Note that the GPS location is not precise and I have a fudge factor to
round up the location. This can be adjusted in the file FindCreeps.awk
