#!/usr/bin/awk -f
# This program read wigle input files to look for MAC addresses at more than one location
# Note that GPS data is not precise, so there is a fudge factor involved
# I "round up" the data by multiplying the data by 100 - which you can change if you wish

# Input is 1 or more *.csv wigle files 
BEGIN {
    # define constants
    FS=","; # it's a CVS file
    FUDGE=100
}
# only match lines with a MAC address, and GPS location
# Note that some CSV files have 12 or more fields because the SSID contains a comma
# so let's ignore them for now

# Ignore lines not formatted correctly
($1 ~ /..:..:..:..:..:../) && (length($7)>0) && (length($8)>0) && (NF==11){
    # fields 1, 7 and 8 are the ones we want
    MAC=$1
    LAT=$7;
    LONG=$8;

    # round up location data
    long=int((LONG*FUDGE)-0.5)/FUDGE
    lat=int((LAT*FUDGE)+0.5)/FUDGE

    # Use thes two values to get a location descriptor used to match the same location
    location=sprintf("%6.2f %6.2f", lat, long)
    #printf("location is %s (really %f %f or %f)\n", location, LAT, LONG, L)

    # I will use two indexes into my associative arrays - i.e. the indexes are strings
    #    count[MACADDRESS] - used to tell me how many locations this mac address has
    #    seen[MACADDRESS location] - used to keep track of each combination
    #                              - I will concatenate the the two strings into one
    
    # have I've sen this MAC+location before?
    
    if  ((seen[MAC " " location]==0)) {
        # I've never seen this pair before - it's a new location
        seen[MAC " " location]++; # Rememember this MAC/location pair
        count[MAC]++;   # Count how many locations I have seen
        #printf("count[%s]=%d, seen[%s] %f %f\n", MAC, count[MAC], MAC " " location, LAT, LONG)
    }
}
#now at the end - when all of the files have been read
END {
    for (i in count) {
        if (count[i]>1) { # If I've seen this in more than one location
            printf("%d %s\n", count[i], i) # print "NumberOfLocations MACAddress"
        }
    }
}

            
