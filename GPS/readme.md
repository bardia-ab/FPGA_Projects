# Introduction
A geographical coordinate system is a framework used to specify locations on the Earth. **Latitude**, **longitude**, and **altitude** are three key geographic coordinates used to specify the location of a point on Earth:

**1. Latitude:**  Latitude is the angular distance north or south of the equator, measured in degrees. It ranges from -90 degrees (at the South Pole) to +90 degrees (at the North Pole). The equator is at 0 degrees latitude, and lines of latitude run parallel to it. Latitude is used to indicate how far north or south a location is from the equator.

<p align="center"><img src="Latitude.png" alt="drawing" style="width:300px;"/>


**2. Longitude:** Longitude is the angular distance east or west of the Prime Meridian, which is an arbitrary line that runs from the North Pole to the South Pole. It is also measured in degrees and ranges from -180 degrees to +180 degrees. Lines of longitude intersect at the poles and are used to indicate how far east or west a location is from the Prime Meridian.

<p align="center"><img src="Longitude.png" alt="drawing" style="width:300px;"/>

**3. Altitude:** Altitude, or elevation, is the vertical distance above or below a reference point, typically the Earth's surface. It is usually measured in meters or feet above sea level. Altitude is used to describe how high or low a point is relative to a specific reference point, like sea level.

# Coordinate Reperesentation
Latitude and longitude are typically represented in degrees (°), minutes ('), and seconds ("). For example, the coordinates for a specific location might be expressed as:

- Latitude: 40° 41' 21" N (North) or 40° 41' 21" S (South)
- Longitude: 74° 0' 30" W (West) or 74° 0' 30" E (East)

These values can also be represented in decimal degrees, where minutes and seconds are converted to decimal fractions of a degree. For example, the coordinates above in decimal degrees would be:

- Latitude: 40.6892° N or -40.6892° S
- Longitude: -74.0083° W or 74.0083° E

Altitude is represented in meters or feet above or below a specific reference point, usually mean sea level. For example, you might express the altitude of a mountain peak as "3,000 meters above sea level" or "10,000 feet above sea level." The reference point is crucial, as altitude measurements can vary based on the chosen reference, and there are different vertical datums used in different regions.

To convert minutes ('), and seconds (") into degrees, you use the following relationships:

- 1 degree (°) = 60 minutes (')
- 1 minute (') = 60 seconds (") 

So, to convert minutes to degrees, you divide the number of minutes by 60. Similarly, to convert seconds to degrees, you divide the number of seconds by 3,600 (which is 60 minutes times 60 seconds).

For example, to convert 30 minutes into degrees:

- 30 minutes = 30 / 60 = 0.5 degrees

And to convert 45 seconds into degrees:

- 45 seconds = 45 / 3,600 = 0.0125 degrees

So, you can express coordinates in degrees with minutes and seconds by converting these smaller units into fractions of a degree.

# NMEA Protocol
The National Marine Electronics Association (NMEA) protocol is a widely used standard for communication between marine electronic devices, such as GPS receivers, fishfinders, and chartplotters. It defines a set of sentences or data strings that allow these devices to exchange information. NMEA sentences are ASCII text-based and are typically transmitted over serial communication channels, making them easy to read and parse.

Some common NMEA sentences include:

**1. $GPGGA** (Global Positioning System Fix Data): This sentence provides essential information about the position, time, fix quality, and the number of satellites in view.

**2. $GPGSA** (GPS DOP and Active Satellites): This sentence contains information about the current operating mode, the number of satellites used for the fix, and dilution of precision (DOP) values.

**3. $GPRMC** (Recommended Minimum Navigation Information): This sentence includes data about latitude, longitude, ground speed, course over ground, and the date.

**4. $GPGLL** (Geographic Position - Latitude/Longitude): It provides latitude and longitude information in degrees, minutes, and seconds, along with information about the status of the fix.

**5. $GPVTG** (Track Made Good and Ground Speed): This sentence offers information on ground speed and course over ground.

**6. $GPZDA** (Time & Date - UTC, Day, Month, Year): It provides time and date information in Coordinated Universal Time (UTC).

These sentences are prefixed with a "$" symbol and a three-letter code, such as "GPGGA" or "GPGLL," to identify the type of data contained in the sentence. NMEA sentences are commonly used in marine navigation, but they are also employed in various other applications that require GPS or location-based data communication.

## GPGGA Sentence
The GPGGA sentence, part of the NMEA protocol, provides essential information about the Global Positioning System (GPS) fix data. It contains details about the position, time, fix quality, and the number of satellites in view. Here's a breakdown of the elements typically found in a GPGGA sentence:

**1. UTC Time:** The time of the fix in hours, minutes, and seconds, given in Coordinated Universal Time (UTC). It's expressed as hhmmss.sss (hours, minutes, seconds, and fractions of a second).

**2. Latitude:** The latitude of the fix. It's typically presented as ddmm.mmmm (degrees and minutes, with a decimal fraction of a minute) and indicates the north or south hemisphere with "N" or "S."

**3. Longitude:** The longitude of the fix. It's usually presented as dddmm.mmmm (degrees and minutes, with a decimal fraction of a minute) and indicates the east or west hemisphere with "E" or "W."

**4. Fix Quality Indicator:** This field provides information about the quality of the GPS fix. Common values include:
   - "0" for no fix.
   - "1" for a GPS fix.
   - "2" for a DGPS (Differential GPS) fix.

**5. Number of Satellites in View:** The number of GPS satellites used in the fix.

**6. Horizontal Dilution of Precision (HDOP):** HDOP is a measure of the precision of the horizontal position. Lower values typically indicate better accuracy.

**7. Altitude:** The altitude above mean sea level. It's expressed in meters.

**8. Altitude Unit:** Indicates the unit of measurement for altitude, typically "M" for meters.

**9. Geoidal Separation:** The difference between the WGS-84 ellipsoidal altitude and the mean sea level altitude. It's expressed in meters.

**10. Geoidal Separation Unit:** Indicates the unit of measurement for geoidal separation, typically "M" for meters.

**11. Age of Differential GPS Data:** If a Differential GPS fix is used, this field provides information about the age of the correction data in seconds.

**12. Differential Reference Station ID:** In DGPS applications, this field identifies the reference station providing correction data.

A sample GPGGA sentence might look like this:


$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47


In this example, the GPGGA sentence provides information about a GPS fix at 12:35:19 UTC with a latitude of 48 degrees 07.038 minutes North and a longitude of 11 degrees 31.000 minutes East. The fix has a quality indicator of "1" (GPS fix), and it's based on signals from 8 satellites. The altitude is 545.4 meters above sea level, and the horizontal dilution of precision (HDOP) is 0.9.