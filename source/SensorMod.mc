using Toybox.System;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.Activity;
using Toybox.SensorHistory;
using Toybox.Weather;
using Toybox.Math;

module SensorMod{

    enum Sensortype{
        
        SENSOR_HEARTRATE,          
        SENSOR_TEMPERATURE,        
        SENSOR_ALTITUDE,           
        SENSOR_BAROMETER,          
        SENSOR_COMPASS,            
        SENSOR_OXYGEN_SATURATION,  
        SENSOR_RESPIRATION_RATE,   
        SENSOR_STEPS,               
        SENSOR_DISTANCE,
        SENSOR_FLOORS, 
        SENSOR_ACTIVE_MINUTES,
        SENSOR_ACTIVE_CALORIES,
        SENSOR_STRESS_LEVEL,       
        SENSOR_BODY_BATTERY,       
        SENSOR_BATTERY,
        SENSOR_VO2_MAX,            
        SENSOR_RECOVERY_TIME,      
        SENSOR_HR_VARIABILITY,
        SENSOR_NOTIFICATIONS,
        SENSOR_ALARMS,
        SENSOR_SUNRISE,
        SENSOR_SUNSET,
        SENSOR_WEATHER,
        SENSOR_HUMIDITY,
        SENSOR_MOONPHASE,
        SENSOR_EMPTY,
        SENSOR_NOTIFICATIONS_PHONE
        
    }
   
    enum PressUnits{
        UNIT_HPASCAL,
        UNIT_ATM,
        UNIT_MMHG
    }

    enum InfoIcons{
        ICON_ALARMS = "D",
        ICON_NOTIFICATIONS = "E",
        ICON_BATTERY = "A",
        ICON_NOTIFICATIONS_ACTIVE = "F",
        ICON_NOTIFICATIONS_INACTIVE = "G",
        ICON_PHONE_CONNECTED = "H",
        ICON_PHONE_DISCONNECTED = "J",
        ICON_TEMPERATURE = "B",  
        ICON_HUMIDITY = "C" 
    }

   
    
    function getSensorDataAndTitle(sensor as Sensortype) as [Lang.String?, Lang.String]{

        var data = "--", title = "";

        var systemStats = System.getSystemStats();
        var activityMonitor = ActivityMonitor.getInfo();
        var weather = Weather.getCurrentConditions();
        var sunEvents = Astronomy.SunEvents;

        switch(sensor){
            case SENSOR_ALTITUDE: 
                data = getAlt(); 
                title = "ALT";
                break;
            case SENSOR_HEARTRATE: 
                data = SensorHistory.getHeartRateHistory({:period => 1}).getMax().format("%d");
                title = "HR";
                break;
            case SENSOR_BAROMETER: 
                data = getPress(UNIT_HPASCAL); 
                title = "PRES";
                break;
            case SENSOR_OXYGEN_SATURATION: 
                data = SensorHistory.getOxygenSaturationHistory({:period => 1}).getMax().format("%d"); 
                title = "SAT";
                break;
            case SENSOR_TEMPERATURE: 
                data = getTemp(); 
                title = "TEMP";
                break;
            case SENSOR_ACTIVE_CALORIES: 
                title = "CAL";  
                data = activityMonitor.calories.format("%d"); 
                break;
            case SENSOR_ACTIVE_MINUTES: 
                data = activityMonitor.activeMinutesDay.total.format("%d"); 
                title = "MIN"; 
                break;
            case SENSOR_BATTERY: 
                data = systemStats.battery.format("%d"); 
                title = "BATT";
                break;
            case SENSOR_DISTANCE: 
                data = getDist();
                title = "DIST"; 
                break;
            case SENSOR_FLOORS: 
                data = activityMonitor.floorsClimbed.format("%d"); 
                title = "FLOOR";
                break;
            case SENSOR_HUMIDITY: 
                data = weather.relativeHumidity.format("%.1f");
                title = "HUM"; 
                break;
            case SENSOR_STEPS: 
                data = getStep(); 
                title = "STEP"; 
                break;
            case SENSOR_SUNRISE: 
                data = (Math.floor(sunEvents[:sunrise])*100 as Lang.Number + ((sunEvents[:sunrise]-Math.floor(sunEvents[:sunrise])) as Lang.Number)*60).format("%04d"); 
                title = "RISE"; 
                break;
            case SENSOR_SUNSET: 
                data = (Math.floor(sunEvents[:sunset])*100 as Lang.Number + ((sunEvents[:sunset]-Math.floor(sunEvents[:sunset])) as Lang.Number)*60).format("%04d"); 
                title = "SET"; 
                break;
            case SENSOR_EMPTY:
                data = ""; 
        }

        return [data, title];
    }

    function getSensorInfo(sensor as Sensortype) as Lang.String?{

        var systemStats = System.getSystemStats();
        var settings = System.getDeviceSettings();
        var weather = Weather.getCurrentConditions();
        var sunEvents = Astronomy.SunEvents;
        var returnValue = "^_^";

        switch(sensor){
            
            case SENSOR_TEMPERATURE: returnValue = ICON_TEMPERATURE + getTemp(); 
            break;
            case SENSOR_ALARMS: returnValue = ICON_ALARMS + settings.alarmCount.format("%d"); 
            break;
            case SENSOR_BATTERY: returnValue = ICON_BATTERY + systemStats.battery.format("%d"); 
            break;
            case SENSOR_HUMIDITY: returnValue = ICON_HUMIDITY + weather.relativeHumidity.format("%.1f"); 
            break;
            case SENSOR_NOTIFICATIONS: returnValue =  ICON_NOTIFICATIONS + settings.notificationCount.format("%d"); 
            break;
            case SENSOR_SUNRISE: returnValue = (Math.floor(sunEvents[:sunrise])*100 as Lang.Number + ((sunEvents[:sunrise]-Math.floor(sunEvents[:sunrise])) as Lang.Number)*60).format("%04d"); 
            break;
            case SENSOR_SUNSET: returnValue = (Math.floor(sunEvents[:sunset])*100 as Lang.Number + ((sunEvents[:sunset]-Math.floor(sunEvents[:sunset])) as Lang.Number)*60).format("%04d"); 
            break;
            case SENSOR_NOTIFICATIONS_PHONE: returnValue = getNotifIcon() + getPhoneIcon();
            break;
            case SENSOR_EMPTY: returnValue = "";  
        }

        return returnValue;
    }
    function getNotifIcon(){
        var temp = System.getDeviceSettings();
        var doNotDisturb;
        if(temp has :doNotDisturb){
            doNotDisturb = temp.doNotDisturb;
        }
        else{
            doNotDisturb = false;
        }

        if(doNotDisturb){
            return ICON_NOTIFICATIONS_INACTIVE;
        }
        return ICON_NOTIFICATIONS_ACTIVE;
    }
    function getPhoneIcon(){
        var connected = System.getDeviceSettings().phoneConnected;
               

        if(connected){
            return ICON_PHONE_CONNECTED;
        }
        return ICON_PHONE_DISCONNECTED;
    }

      
 

    function getAlt() as Lang.String{
            
        var altUnit = System.getDeviceSettings().elevationUnits;
        var value = Activity.getActivityInfo().altitude;

        if(value == null){
            value = "--";
        }
        else{
            if(altUnit == System.UNIT_STATUTE){
                value *= 3.2808;
            }
            if(value > 9000){
                value /= 1000;
                value = value.format("%2.1f") + "K";
            }
            else{
                value = value.format("%d");
            }
        }

        
            
        return value;
    }
    function getTemp() as Lang.String?{
            var value = SensorHistory.getTemperatureHistory({:period => 1}).getMax();

            var TempUnit = System.getDeviceSettings().temperatureUnits;
            
            if(TempUnit == System.UNIT_STATUTE){
                value = value*1.8 + 32;
              
            }
            
            value = value.format("%.1f");
            return value;
    }
    function getPress(unit as PressUnits) as Lang.String?{
        
            var value = SensorHistory.getPressureHistory({:period => 1}).getMax();
            
            switch(unit){
                case UNIT_HPASCAL: value /= 100; break;
                case UNIT_ATM: value /= 101325; break;
                case UNIT_MMHG: value *= 0.0075;
            }
            value = value.format("%.1f");

            return value;
    }
    function getDist() as Lang.String?{

        var value = ActivityMonitor.getInfo().distance as Lang.Float;
        var DistUnit = System.getDeviceSettings().distanceUnits;

        if(DistUnit == System.UNIT_STATUTE){
            value /= 160934.0 as Lang.Float;//miglia
        }
        else{
            value /= 100000.0 as Lang.Float;//kmetri
        }
        value = value.format("%.1f");

        return value;
    }
    function getStep() as Lang.String?{
        var value = ActivityMonitor.getInfo().steps;

        if(value > 9999){
            if(value > 99000){
                value = (value/1000).format("%d") + "K";
            }
            else{
                value = (value/1000.0).format("%.1f") + "K";
            }
        }
        else{
            value = value.format("%d");
        }

        return value;
    }
   
}