using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;


class MoonCalc {

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

    function initialize(){

    }

    // Current moon phase (0 - 7)
    public function getPhase(day as Time.Moment?) as MOON_PHASE{
        // Approximation of moon phase by calculating moon age
        // from a known new moon and the average duration
        // of a lunar cycle -- not precise but sufficient for watchface

        var returnValue = 0;
                
        if(day == null){
            // day = Greg.moment({:year => 2026, :month => 1, :day => 18}); // debug
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
        
        
        return returnValue as MOON_PHASE;
    }
}