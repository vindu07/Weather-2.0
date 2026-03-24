using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Sensor;
using Toybox.SensorHistory;
using Toybox.System;
using Toybox.Weather;
using Toybox.Application;

module SensorMod{

    enum Sensortype {
        SENSOR_HEARTRATE,          
        SENSOR_DEVICE_TEMPERATURE,        
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
        SENSOR_NOTIFICATIONS_PHONE,
        SENSOR_FORECAST_TEMPERATURE,
        SENSOR_WINDSPEED   
    }
    enum PressUnits{
        UNIT_HPASCAL,
        UNIT_MBAR,
        UNIT_ATM,
        UNIT_MMHG,
        UNIT_INHG
    }
    enum WindUnits{
        WIND_MS,
        WIND_KPH,
        WIND_MPH,
        WIND_KN
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

        WeatherMod.getCurrentConditions();

        var systemStats = System.getSystemStats();
        var activityMonitor = ActivityMonitor.getInfo();
        var sunEvents = Astronomy.SunEvents;

        try{
            switch(sensor){
                case SENSOR_ALTITUDE: 
                    data = getAlt(); 
                    title = "ALT";
                    break;
                case SENSOR_HEARTRATE: 
                    data = getHr();
                    title = "HR";
                    break;
                case SENSOR_BAROMETER: 
                    data = getPress(); 
                    title = "PRES";
                    break;
                case SENSOR_WINDSPEED: 
                    data = getWindSpeed(); 
                    title = "WIND";
                    break;
                case SENSOR_OXYGEN_SATURATION: 
                    var o2History = SensorHistory.getOxygenSaturationHistory({:period => 1});
                    if(o2History != null){
                        var o2Max = o2History.getMax();
                        data = (o2Max != null) ? o2Max.format("%d") : "--";
                    }
                    title = "SAT";
                    break;
                case SENSOR_DEVICE_TEMPERATURE: 
                    data = getTemp(true); 
                    title = "TEMP";
                    break;
                case SENSOR_FORECAST_TEMPERATURE: 
                    data = getTemp(false); 
                    title = "TEMP";
                    break;
                case SENSOR_ACTIVE_CALORIES: 
                    title = "CAL";  
                    if(activityMonitor.calories != null){
                        data = activityMonitor.calories.format("%d");
                    }
                    break;
                case SENSOR_ACTIVE_MINUTES: 
                    if(activityMonitor.activeMinutesDay != null){
                        data = activityMonitor.activeMinutesDay.total.format("%d");
                    }
                    title = "MIN"; 
                    break;
                case SENSOR_BATTERY: 
                    if(systemStats != null && systemStats.battery != null){
                        data = systemStats.battery.format("%d");
                    }
                    title = "BATT";
                    break;
                case SENSOR_DISTANCE: 
                    data = getDist();
                    title = "DIST"; 
                    break;
                case SENSOR_FLOORS: 
                    if(activityMonitor != null){
                        data = activityMonitor.floorsClimbed.format("%d");
                    }
                    title = "FLOOR";
                    break;
                case SENSOR_HUMIDITY: 
                    data = getHum();
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
        }
        catch(ex){
            System.println("ERROR -- SensorMod.getSensorDataAndTitle -- " + ex.getErrorMessage());
            data = "--";
        }

        return [data, title];
    }

    function getSensorInfo(sensor as Sensortype) as Lang.String?{

        var systemStats = System.getSystemStats();
        var settings = System.getDeviceSettings();
        var weather = Weather.getCurrentConditions();
        var sunEvents = Astronomy.SunEvents;
        var returnValue = "--";

        try{
            switch(sensor){
                
                case SENSOR_DEVICE_TEMPERATURE: 
                    var temp = getTemp(true);
                    returnValue = ICON_TEMPERATURE + (temp != null ? temp : "--"); 
                    break;
                case SENSOR_FORECAST_TEMPERATURE: 
                    temp = getTemp(false);
                    returnValue = ICON_TEMPERATURE + (temp != null ? temp : "--"); 
                    break;
                case SENSOR_ALARMS: 
                    if(settings != null){
                        returnValue = ICON_ALARMS + settings.alarmCount.format("%d");
                    }
                    break;
                case SENSOR_BATTERY: 
                    if(systemStats != null && systemStats.battery != null){
                        returnValue = ICON_BATTERY + systemStats.battery.format("%d");
                    }
                    break;
                case SENSOR_HUMIDITY: 
                    returnValue = ICON_HUMIDITY + getHum();
                    break;
                case SENSOR_NOTIFICATIONS: 
                    if(settings != null){
                        returnValue = ICON_NOTIFICATIONS + settings.notificationCount.format("%d");
                    }
                    break;
                case SENSOR_SUNRISE: 
                    returnValue = (Math.floor(sunEvents[:sunrise])*100 as Lang.Number + ((sunEvents[:sunrise]-Math.floor(sunEvents[:sunrise])) as Lang.Number)*60).format("%04d"); 
                    break;
                case SENSOR_SUNSET: 
                    returnValue = (Math.floor(sunEvents[:sunset])*100 as Lang.Number + ((sunEvents[:sunset]-Math.floor(sunEvents[:sunset])) as Lang.Number)*60).format("%04d"); 
                    break;
                case SENSOR_NOTIFICATIONS_PHONE: 
                    returnValue = getNotifIcon() + getPhoneIcon();
                    break;
                case SENSOR_EMPTY: 
                    returnValue = "";  
            }
        }
        catch(ex){
            System.println("ERROR -- SensorMod.getSensorInfo -- " + ex.getErrorMessage());
            returnValue = "--";
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
    function getTemp(fromDevice as Lang.Boolean) as Lang.String{
            try{
                var value;

                if(fromDevice){
                    var tempHistory = SensorHistory.getTemperatureHistory({:period => 1});
                    value = tempHistory.getMax();
                }
                else{
                    value = WeatherMod.WeatherConditions[:temperature];
                } 
                if(value == null){
                    System.println("WARNING -- SensorMod.getTemp -- Temperature value is null");
                    return "--";
                }
                else if(value < 0.0){return "--"; }

                var TempUnit = System.getDeviceSettings().temperatureUnits;
                
                if(TempUnit == System.UNIT_STATUTE){
                    value = value*1.8 + 32;
                }
                
                value = value.format("%.1f");
                return value;
            }
            catch(ex){
                System.println("ERROR -- SensorMod.getTemp -- " + ex.getErrorMessage());
                return "--";
            }
    }
    function getPress() as Lang.String{
        try{
            var value;
            var pressHistory = SensorHistory.getPressureHistory({:period => 1});
            
            if(pressHistory != null){
                value = pressHistory.getMax(); 
            }
            else{
                value = WeatherMod.WeatherConditions[:pressure];
            }
            
            if(value == null){
                System.println("WARNING -- SensorMod.getPress -- Pressure value is null");
                return "--";
            }
            else if(value < 0.0){return "--"; }

            var unit = Application.Properties.getValue("PressUnit") as PressUnits;
            
            switch(unit){
                case UNIT_HPASCAL: value /= 100; break;
                case UNIT_MBAR: value /= 100; break;
                case UNIT_ATM: value /= 101325; break;
                case UNIT_MMHG: value *= 0.0075; break;
                case UNIT_INHG: value *= 0.0002953;
            }
            value = value.format("%.1f");

            return value;
        }
        catch(ex){
            System.println("ERROR -- SensorMod.getPress -- " + ex.getErrorMessage());
            return "--";
        }
    }
    function getHum() as Lang.String{
        try{

            var humidity = WeatherMod.WeatherConditions[:relativeHumidity] as Lang.Number;

            if(humidity == null || humidity < 0){return "--"; }

            return humidity.format("%d");
        }
        catch(ex){
            System.error("ERROR -- SensorMod.getHum -- " + ex.getErrorMessage());
            return "--";
        }
    }
    function getDist() as Lang.String{
        try{
            var actInfo = ActivityMonitor.getInfo();
            if(actInfo == null || actInfo.distance == null){
                System.println("ERROR -- SensorMod.getDist -- ActivityMonitor info is null");
                return "--";
            }

            var value = actInfo.distance as Lang.Float;
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
        catch(ex){
            System.println("ERROR -- SensorMod.getDist -- " + ex.getErrorMessage());
            return "--";
        }
    }
    function getStep() as Lang.String{
        try{
            var actInfo = ActivityMonitor.getInfo();
            if(actInfo == null || actInfo.steps == null){
                System.println("ERROR -- SensorMod.getStep -- ActivityMonitor info is null");
                return "--";
            }
            
            var value = actInfo.steps;

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
        catch(ex){
            System.println("ERROR -- SensorMod.getStep -- " + ex.getErrorMessage());
            return "--";
        }
    }
    function getWindSpeed() as Lang.String{
        try{
            var value = WeatherMod.WeatherConditions[:windSpeed] as Lang.Float;

            if(value < 0.0){return "--"; }

            var windUnits = Application.Properties.getValue("WindUnit") as WindUnits;

            //conversion
            switch(windUnits as WindUnits){
                case WIND_KPH: value *= 3.6; break;
                case WIND_MPH: value *= 2.2369; break;
                case WIND_KN: value *= 1.9438;
            }

            return value.format("%.1f");
        }
        catch(ex){
            System.println("ERROR -- SensorMod.getWindSpeed -- " + ex.getErrorMessage());
            return "--";
        }
    }
    function getHr() as Lang.String{
        try{
            var value = ActivityMonitor.getHeartRateHistory(1, true).getMax() as Lang.Number;    

            if(value > 230){
                System.println("Warning -- SensorMod.getHr -- valori fuori range");
                return "--";
            } 

            return value.toString();
        }
        catch(ex){
            System.println("ERROR -- SensorMod.getHr -- " + ex.getErrorMessage());
            return "--";
        }
    }
    
}