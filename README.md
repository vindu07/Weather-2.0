Here is the source code of my watch face called "Weather 2.0", which I have loaded on garmin's Connect IQ Store at the following link: https://apps.garmin.com/apps/ece0d4ff-ea0a-427a-b345-55456f084523.

THIS IS NOT meant to be an example of how to write good Monkey C code, and I am NOT a professional programmer. 
I loaded it on github mainly to keep trace of the different versions for recovery, which is not permitted on Connect IQ.

I TAKE NO RESPONSIBILITY FOR ANY MISUSE OF THIS CODE OR ANY DAMAGE TO DEVICES THAT MAY OCCUR.

----------------------------------------------------------------------------------------------------------------------------

The main functionalities are:

-Dynamic background depending on the weather and time of the day
-Dynamic sun position throughout the day to give a visual reference of the time
-4 background landscapes
-Data fields on the bottom
-Info fields on left and right
-Icons with weather condition and moon phase
-Settings to edit colors, fields, background and several boolean options

----------------------------------------------------------------------------------------------------------------------------

Here is a brief description of how it works:

- Due to the frequent null values returned by the Garmin APIs, I have created my own modules for the most important information, like the sunrise/sunset time and the moon phase.
  These functions are simplified and return quite rough values, but at least they are never null.
- Everything on the screen is an instance of a custom class that extends WatchUi.Drawable: they are declared in the layout.xml file and, after the initialization, at every update the draw() function is called.

UPPER PART:

- The sky is a rectangle filled with a different color depending on the time of day and the cloud cover. This information is provided by the Astronomy and WeatherMod modules.
- The sun is a circle filled in yellow. The position in the sky is calculated from a proportion between the time elapsed since sunrise and the solar day duration.
  The moon icon is drawn in a fixed position at night, with the correct phase (because the moonrise/set depend on the phase and could happen during the day, creating problems).
- The weather is based on a series of bitmaps in the resources/drawables/ folder. The condition is taken from WeatherMod module, and then the correct bitmaps are drawn on the screen.
- The landscape is then drawn, and consists in a 280x280 pixel bitmap. Future updates should remove the black lower part to improve memory usage and reduce the app size.

- The sun position and weather/sky color are updated once every about 10 minutes to improve battery life.

LOWER PART:

- Time is also a drawable object and contains some calculations for military/12 hour format and daylight saving time.
- The date is taken from Toybox.Time.Gregorian and is therefore automatically translated into all the garmin suported languages.
- Data fields and Info fields are two different classes and take information from the SensorMod module.
- Weather and moon icons are based on custom bitmap fonts and take information from Astronomy and WeatherMod modules.
- Battery indicator is a white rounded rectangle filled with another colored rectangle which is proportional to the battery percentage. The colors are customizable on app settings.

-The lower part is refreshed at every update, so the weather/moon icons could slightly differ from what is shown on the upper part for this reason.


