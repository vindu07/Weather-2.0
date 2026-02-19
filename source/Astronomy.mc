using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Weather;
using Toybox.Position;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.Lang;
using Toybox.System;
using Toybox.Math;
using Toybox.Timer;


module Astronomy{

    //poi aggiornate a ogni chiamata di SunEvents e Moonphase
    var SunEvents as Lang.Dictionary = {:sunrise => 6.0, :sunset => 18.0, :solar_midday => 12.0};
    var MoonPhase as MOON_PHASE = 0 as MOON_PHASE; 

    typedef SunriseAndSunsetReturn as {
        :sunrise as Time.Moment,
        :sunset as Time.Moment
    };
    typedef SunPositionReturn as {
        :x as Lang.Number,
        :y as Lang.Number
    };
    typedef SunEventsReturn as {
        :sunrise as Lang.Numeric,
        :sunset as Lang.Numeric,
        :solar_midday as Lang.Numeric
    };

    enum MOON_PHASE {

        MOON_PHASE_NEW_MOON,
        MOON_PHASE_WAXING_CRESCENT,
        MOON_PHASE_FIRST_QUARTER,
        MOON_PHASE_WAXING_GIBBOUS,
        MOON_PHASE_FULL_MOON,
        MOON_PHASE_WANING_GIBBOUS,
        MOON_PHASE_LAST_QUARTER,
        MOON_PHASE_WANING_CRESCENT 
    }

    public function getApproxSunEvents(Custom_Position as [Lang.Float, Lang.Float] or Null, Fallback_Position as [Lang.Float, Lang.Float] or Null) as SunEventsReturn{
        
        //Calcolo di alba, tramonto, mezzogiorno solare basato su 
        //calcoli trigonometrici che approssimano l'orbita terrestre a una circonferenza
        //e la terra a una sfera.
        //
        //Il calcolo si basa sul giorno dell'anno per calcolare la declinazione solare
        //e sulla latitudine per calcolare la durata del giorno solare, aggiungendo un offset dovuto
        //alla eventuale distanza in longitudine dal meridiano centrale del fuso orario
        //
        //Non affidabile ma abbastanza preciso per l'utilizzo nella watchface
        //
        //Ore di bestemmie: teoriche(metodo quasi interamente pensato e realizzato dal sottoscritto) = 1.5; scrittura codice = 1; debugging = 6;
        //Finalmente funzionante dopo un pomeriggio intero, Primiero 10/01/2026
        
        var returnValue = {:sunrise => 6.0, :sunset => 18.0, :solar_midday => 12.0};
        
        var Sunrise;
        var Sunset;
        var Midday;

        try{
            var currentPosition;
            var currentTime;
            

            var halfDayDuration = 0 as Lang.Number;
            var sunDeclination;
            var latitude;
            var timeZone;
            var timeOffset;
            var longitudeFromCentralMeridian;
            var toRadians;
            var dayOfYear;
            var firstOfYear;

            var isDaylightSaving;

            //fallback per posizione: inserita > gps > impostazioni > default(greenwich)
            if(Custom_Position != null){
                currentPosition = new Position.Location({:latitude => Custom_Position[0], :longitude => Custom_Position[1], :format => :degrees});
            }
            else if(isValidPosition(Position.getInfo())){
                currentPosition = Position.getInfo().position; 
            }
            else if(Fallback_Position != null){
                currentPosition = new Position.Location({:latitude => Fallback_Position[0], :longitude => Fallback_Position[1], :format => :degrees});//greenwich
            }
            else{
                currentPosition = new Position.Location({:latitude => 51.5, :longitude => 0.001, :format => :degrees});//greenwich
            }
            currentTime = Time.now();

            firstOfYear = Greg.moment({:month => 1, :day => 1, :hour => 0, :minute => 0, :second => 0});
            dayOfYear = (currentTime.compare(firstOfYear).abs() / Greg.SECONDS_PER_DAY) + 1 as Lang.Number;

            timeZone = Math.round(currentPosition.toDegrees()[1] / 15) as Lang.Number;//circa
            
            isDaylightSaving = Greg.localMoment(currentPosition, currentTime);
            if(isDaylightSaving != null){
                isDaylightSaving = isDaylightSaving.isDaylightSavingsTime();
            }
            else{
                isDaylightSaving = false;
            }


            toRadians = currentPosition.toRadians();

            latitude = toRadians[0] as Lang.Float;
            longitudeFromCentralMeridian = (toRadians[1] - (timeZone*Math.PI/12)) as Lang.Float;
            timeOffset = -1*(longitudeFromCentralMeridian*Greg.SECONDS_PER_DAY/(2*Math.PI))/3600;

            sunDeclination = 0.4093*Math.sin((2*Math.PI/365)*(dayOfYear - 80)) as Lang.Float; //angolo in radianti
            halfDayDuration = ((Math.acos(-1*Math.tan(latitude)*Math.tan(sunDeclination))/(2*Math.PI))*Greg.SECONDS_PER_DAY)/3600.toNumber() as Lang.Number; //durata di metà giorno in ore
        
            
            //CORREZIONE PER ORBITA ELLITTICA (equazione del tempo)
            var B = 0, L = 0;
            var timeCorrection = 0.0;

            B = (2*Math.PI/365)*(dayOfYear - 81) as Lang.Float;
            L = (2*Math.PI/365)*(dayOfYear - 3.5) as Lang.Float;

            timeCorrection = -1*(7.65*Math.sin(B) - 9.86*Math.sin(2*L))/60 as Lang.Float; //in ore


            //FORMATTO I VALORI => ore in formato decimale per confronto piu semplice
            var hour12Today = 12.00;

            Midday = hour12Today + timeOffset + timeCorrection as Lang.Float;
            Sunrise = Midday - halfDayDuration as Lang.Float;
            Sunset = Midday + halfDayDuration as Lang.Float;
            

            if(isDaylightSaving){
                //ora legale
                Sunrise += 1;
                Sunset += 1;
                Midday += 1;
            }
            

            returnValue = {:sunrise => Sunrise, :sunset => Sunset, :solar_midday => Midday};

            SunEvents[:sunrise] = Sunrise;
            SunEvents[:sunset] = Sunset;
            SunEvents[:solar_midday] = Midday;

        }
        catch(ex){
            System.println("ERROR -- Astronomy.getApproxSunEvents -- Line 215 -- " + ex);
        }

        return returnValue as SunEventsReturn;

    }

    // Funzione per validare la posizione
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

    public function getSunAngle(time as Time.Moment, fallback_position as [Lang.Float, Lang.Float] or Null) as Lang.Float{
        //Angolo in radianti della posizione del sole nel cielo
        //0 = alba, PI = tramonto

        me.refreshData(fallback_position);

        //tempo in ore con decimali
        var normalizedTime = normalizeTime(time);
        
        var sunAngle = 0.0;
        var timeSinceSunrise = (normalizedTime - SunEvents[:sunrise]) as Lang.Float;
        var solarDay = (SunEvents[:sunset] - SunEvents[:sunrise]) as Lang.Float;

        sunAngle = (timeSinceSunrise/solarDay)*Math.PI as Lang.Float;

        return sunAngle as Lang.Float;
    }


    var DELTA = 0.25;//scarto in ore
    public function isDay(time as Time.Moment) as Lang.Boolean{
        var isDay = true;

        //tempo in ore con decimali
        var normalizedTime = normalizeTime(time);

        var isAfterSunrise = (normalizedTime > SunEvents[:sunrise] - DELTA);
        var isBeforeSunset = (normalizedTime < SunEvents[:sunset] + DELTA);

        if(!(isAfterSunrise && isBeforeSunset)){
            isDay = false;
        }

        return isDay;
    }
    public function isTwilight(time as Time.Moment) as Lang.Boolean{
        var isTwilight = false;
        

        //tempo in ore con decimali
        var normalizedTime = normalizeTime(time);

        var nearSunrise = (normalizedTime - SunEvents[:sunrise]).abs() < DELTA;
        var nearSunset = (normalizedTime - SunEvents[:sunset]).abs() < DELTA;

        if(nearSunrise || nearSunset){
            isTwilight = true;
        }

        return isTwilight;
    }
    
    public function getMoonPhase(day as Time.Moment?) as MOON_PHASE{
        //approssimazione della fase lunare calcolando l'età della luna
        //a partire da una luna nuova conosciuta e dalla durata
        //media di un ciclo lunare -- non precisa ma abbastanza per la watchface

        var returnValue = 0;
                
        if(day == null){
            //day = Greg.moment({:year => 2026, :month => 1, :day => 18});//debug
            day = Time.now(); 
        }
   

        try{

            var medMoonLife = 29.53;
            var knownMoon = Greg.moment({:year => 2020, :month => 1, :day => 24, :hour => 22, :minute => 42});

        
            var daysSince = knownMoon.compare(day).abs() / Greg.SECONDS_PER_DAY as Lang.Float;
            var mod = 0;

            while(daysSince > medMoonLife){
                daysSince -= medMoonLife;
            }
            mod = daysSince;

            returnValue  = Math.round(mod*(8/medMoonLife)).toNumber() as Lang.Number;
            returnValue %= 8;

        }catch(ex){
            System.println("ERROR -- Astronomy.getMoonPhase -- " +  ex.toString());
        }
        
        MoonPhase = returnValue as MOON_PHASE;
        return returnValue as MOON_PHASE;
    }

    public function normalizeTime(time as Time.Moment?) as Lang.Float{
        //tempo in ore con decimali

        try{
            var normalizedTime = Greg.info(time, Time.FORMAT_SHORT).hour as Lang.Float;
            normalizedTime += Greg.info(time, Time.FORMAT_SHORT).min/60.0 as Lang.Float;
            return normalizedTime;
        }catch(ex){
            System.println("ERROR -- normalizeTime -- " + ex.toString());
            return 0.0; // valore di fallback
    }
    }

    function refreshData(fallback_position as [Lang.Float, Lang.Float] or Null){
        getApproxSunEvents(null, fallback_position);
        getMoonPhase(null);
    }

   
}
