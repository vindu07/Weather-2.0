using Toybox.Lang;
using Toybox.Math;
using Toybox.Position;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;


module Astronomy{

    // Updated on every call to SunEvents or Moonphase
    var SunEvents as Lang.Dictionary = {:sunrise => 6.0, :sunset => 18.0, :solar_midday => 12.0};
    var MoonPhase as MoonCalc.MOON_PHASE = 0 as MoonCalc.MOON_PHASE; 


    typedef SunPositionReturn as {
        :x as Lang.Number,
        :y as Lang.Number
    };

    // gets sun events from SunCalc
    public function sunCalcEvents(Custom_Position as [Lang.Float, Lang.Float] or Null, Fallback_Position as [Lang.Float, Lang.Float] or Null){

        var returnValue = {:sunrise => 6.0, :sunset => 18.0, :solar_midday => 12.0};

        try{
            var sc = new SunCalc();            

            var currentPosition, currentTime;
            var sunset_moment;
            var sunrise_moment;
            var noon_moment;

            // Position fallback: custom > GPS > fallback > default (Greenwich)
            if(Custom_Position != null){
                currentPosition = new Position.Location({:latitude => Custom_Position[0], :longitude => Custom_Position[1], :format => :degrees});
            }
            else if(isValidPosition(Position.getInfo())){
                currentPosition = Position.getInfo().position; 
            }
            else if(Fallback_Position != null){
                currentPosition = new Position.Location({:latitude => Fallback_Position[0], :longitude => Fallback_Position[1], :format => :degrees});
            }
            else{
                currentPosition = new Position.Location({:latitude => 51.5, :longitude => 0.001, :format => :degrees}); // Greenwich
            }

            //position to radians
            var toRadians = currentPosition.toRadians() as [Lang.Double, Lang.Double];

            var lat = toRadians[0];
            var lon = toRadians[1];

            currentTime = Time.today();

            sunrise_moment = sc.calculate(currentTime, [lat, lon], sc.SUNRISE) as Time.Moment;
            sunset_moment = sc.calculate(currentTime, [lat, lon], sc.SUNSET) as Time.Moment;
            noon_moment = sc.calculate(currentTime, [lat, lon], sc.NOON) as Time.Moment;

            //moment to decimal time format
            sunrise_moment = formatTime(sunrise_moment);
            sunset_moment = formatTime(sunset_moment);
            noon_moment = formatTime(noon_moment);


            returnValue = {:sunrise => sunrise_moment, :sunset => sunset_moment, :solar_midday => noon_moment};

            SunEvents[:sunrise] = sunrise_moment;
            SunEvents[:sunset] = sunset_moment;
            SunEvents[:solar_midday] = noon_moment;

            return returnValue;
        }
        catch(ex){
            System.println("ERROR - Astronomy.sunCalcEvents - " + ex);
            return returnValue;
        }
    }

    // Function to validate position
    function isValidPosition(pos as Position.Info?) as Lang.Boolean { 
    
        if(pos != null){
            var degPos = pos.position.toDegrees();

            return (degPos[0] != null && degPos[1] != null &&
            degPos[0] >= -90 && degPos[0] <= 90 &&
            degPos[1] >= -180 && degPos[1] <= 180 && degPos[1] != 0.0);
        }
        else{
            return false;
        } 
    }

    // Angle (0 - 180°) based on the proportion of time since sunrise / day duration
    public function getSunAngle(time as Time.Moment) as Lang.Float{
        // Angle in radians of the sun's position in the sky
        // 0 = sunrise, PI = sunset

        // time in hours with decimals
        var normalizedTime = formatTime(time);
        
        var sunAngle = 0.0;
        var timeSinceSunrise = (normalizedTime - SunEvents[:sunrise]) as Lang.Float;
        var solarDay = (SunEvents[:sunset] - SunEvents[:sunrise]) as Lang.Float;

        sunAngle = (timeSinceSunrise/solarDay)*Math.PI as Lang.Float;

        return sunAngle as Lang.Float;
    }

    var DELTA = 0.25; // margin in hours for day / twilight calculations

    // True if the current time is more than DELTA after sunrise and before sunset
    public function isDay(time as Time.Moment) as Lang.Boolean{
        var isDay = true;

        // time in hours with decimals
        var normalizedTime = formatTime(time);

        var isAfterSunrise = (normalizedTime > SunEvents[:sunrise] - DELTA);
        var isBeforeSunset = (normalizedTime < SunEvents[:sunset] + DELTA);

        if(!(isAfterSunrise && isBeforeSunset)){
            isDay = false;
        }

        return isDay;
    }
    
    // True if the time distance to sunrise/set is less than DELTA
    public function isTwilight(time as Time.Moment) as Lang.Boolean{
        var isTwilight = false;
        

        // time in hours with decimals
        var normalizedTime = formatTime(time);

        var nearSunrise = (normalizedTime - SunEvents[:sunrise]).abs() < DELTA;
        var nearSunset = (normalizedTime - SunEvents[:sunset]).abs() < DELTA;

        if(nearSunrise || nearSunset){
            isTwilight = true;
        }

        return isTwilight;
    }

    // Converts a time moment to a decimal number representing the local hours (0.0 - 23.99..)
    public function formatTime(time_input as Time.Moment) as Lang.Float{
        // time in hours with decimals

        try{

            var timeInfo = Greg.info(time_input, Time.FORMAT_SHORT);
            

            var normalizedTime = timeInfo.hour;
            normalizedTime += timeInfo.min/60.0 as Lang.Float;

            if(normalizedTime < 0.0){
                normalizedTime += 24.0;
            }
            else if(normalizedTime >= 24.0){
                normalizedTime -= 24;
            }
            return normalizedTime;
        }catch(ex){
            System.println("Astronomy.formatTime -- " + ex.getErrorMessage());
            return 0.0; // fallback value
        }
    }

    // gets current moon phase from MoonCalc
    public function getMoonPhase(time as Time.Moment?){
        var moonCalc = new MoonCalc();
        var phase = moonCalc.getPhase(time);

        MoonPhase = phase as MoonCalc.MOON_PHASE;
        return phase as MoonCalc.MOON_PHASE;
    }

    // Called in View.mc
    public function refreshData(fallback_position as [Lang.Float, Lang.Float] or Null){
        sunCalcEvents(/*[60.0, -110.0]*/null, fallback_position);
        getMoonPhase(null);
    }

   
}
