using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Weather;

// Functions to get weather information for the other modules and classes

module WeatherMod {

    typedef Conditions as {
        :condition as Lang.Number, :cloudCover as Lang.Number, :pressure as Lang.Float, 
        :temperature as Lang.Numeric, :relativeHumidity as Lang.Number, :windSpeed as Lang.Float
    };

    enum CustomCondition {
        CONDITION_Clear,
        CONDITION_Covered,
        CONDITION_Fog,
        CONDITION_Light_Rain,
        CONDITION_Heavy_Rain,
        CONDITION_Thunderstorm,
        CONDITION_Snow,
        CONDITION_Extreme,
        CONDITION_Wind,
        CONDITION_Dust
    }
    

    // Fallback data to avoid unexpected app crashes due to null values
    var WeatherConditions as Conditions = {
        :condition => 53, :cloudCover => 0, :pressure => 1013.5, 
        :temperature => 20.0, :relativeHumidity => 50, :windSpeed => 0.0
    };

    // Returns the current condition from garmin or memory
    function getCondition() as Weather.Condition{
        
        self.getCurrentConditions();

        var condition = self.WeatherConditions;

        // Real-time weather
        if(!hasNullValues(condition)){
            return condition[:condition] as Weather.Condition;
        }
        
        // Fallback to storage
        condition = self.getData() as Conditions;
        
        if(!hasNullValues(condition)){
            return condition[:condition] as Weather.Condition;
        }
        
        // Leave unchanged if no data available
        return WeatherConditions[:condition] as Weather.Condition;
    }
    
    //true if the cloud cover is more than 70%
    function isCovered() as Lang.Boolean{

        var isCovered = (WeatherConditions[:cloudCover] >= 70);

        return isCovered as Lang.Boolean;
    }

    // Custom condition for the dynamic weather background
    function getConditionType() as CustomCondition{

        var condition = self.getCondition() as Lang.Number;
        
        if([0, 22, 23, 40, 53].indexOf(condition) != -1){
            condition = self.CONDITION_Clear;
        }
        else if([1, 2, 20, 52].indexOf(condition) != -1){
            condition = self.CONDITION_Covered;
        }
        else if([8, 9, 29, 39].indexOf(condition) != -1){
            condition = self.CONDITION_Fog;
        }
        else if([3, 11, 12, 13, 14, 24, 27, 28, 31, 45].indexOf(condition) != -1){
            condition = self.CONDITION_Light_Rain;
        }
        else if([15, 25, 26].indexOf(condition) != -1){
            condition = self.CONDITION_Heavy_Rain;
        }
        else if([6, 10].indexOf(condition) != -1){
            condition = self.CONDITION_Thunderstorm;
        }
        else if([5].indexOf(condition) != -1){
            condition = self.CONDITION_Wind;
        }
        else if([4, 7, 16, 17, 18, 19, 21, 34, 43, 44, 46, 47, 48, 49, 50, 51].indexOf(condition) != -1){
            condition = self.CONDITION_Snow;
        }
        else if([30, 33, 35, 38].indexOf(condition) != -1){
            condition = self.CONDITION_Dust;
        }
        else if([32, 36, 37, 41, 42].indexOf(condition) != -1){
            condition = self.CONDITION_Extreme;
        }
        
        return condition;
    }

    // Updates the condition dictionary
    function getCurrentConditions() as Conditions{

        var conditions = {};
        
        try{
        
        
        var temp = Weather.getCurrentConditions();

        if(temp != null){
            conditions[:condition] = temp.condition;
            conditions[:cloudCover] = temp.cloudCover;
            conditions[:pressure] = temp.pressure;
            conditions[:temperature] = temp.temperature;
            conditions[:relativeHumidity] = temp.relativeHumidity;
            conditions[:windSpeed] = temp.windSpeed;

            if(!hasNullValues(conditions)){

                WeatherConditions = conditions;
                return conditions;
            }
        }

        temp = Weather.getHourlyForecast();

        if(temp != null){
            temp = temp[0];
            
            conditions[:condition] = temp.condition;
            conditions[:cloudCover] = temp.cloudCover;
            conditions[:pressure] = 101350;
            conditions[:temperature] = temp.temperature;
            conditions[:relativeHumidity] = temp.relativeHumidity;
            conditions[:windSpeed] = temp.windSpeed;

            if(!hasNullValues(conditions)){

                 WeatherConditions = conditions;
                return conditions;
            }
        }

        }
        catch(ex){
            System.println("ERROR - WeatherMod.getCurrentConditions");
        }
        
        return {};

    }

    // Checks the conditions dictionary to make sure there are no null values
    function hasNullValues(conditions as Conditions?) as Lang.Boolean{

        if(conditions == null){    
            return true;
        }

        var hasNull1 = (conditions[:condition] == null);
        var hasNull2 = (conditions[:cloudCover] == null);
        var hasNull3 = (conditions[:pressure] == null);
        var hasNull4 = (conditions[:temperature] == null);
        var hasNull5 = (conditions[:relativeHumidity] == null);
        var hasNull6 = (conditions[:windSpeed] == null);
       
        if(hasNull1 || hasNull2 || hasNull3 || hasNull4 || hasNull5 || hasNull6){    
            return true;
        }
        return false;
    }

    // Called in the View.mc file
    function refreshData(){
        self.getCurrentConditions();
        self.storeData();
    }

    function storeData(){
        Application.Storage.setValue("condition", self.WeatherConditions[:condition]);
        Application.Storage.setValue("temperature", self.WeatherConditions[:temperature]);
        Application.Storage.setValue("pressure", self.WeatherConditions[:pressure]);
        Application.Storage.setValue("windSpeed", self.WeatherConditions[:windSpeed]);
        Application.Storage.setValue("cloudCover", self.WeatherConditions[:cloudCover]);
        Application.Storage.setValue("relativeHumidity", self.WeatherConditions[:relativeHumidity]);
    }

    function getData(){
        
        self.WeatherConditions[:condition] = Application.Storage.getValue("condition");
        self.WeatherConditions[:temperature] = Application.Storage.getValue("temperature");
        self.WeatherConditions[:pressure] = Application.Storage.getValue("pressure");
        self.WeatherConditions[:windSpeed] = Application.Storage.getValue("windSpeed");
        self.WeatherConditions[:cloudCover] = Application.Storage.getValue("cloudCover");
        self.WeatherConditions[:relativeHumidity] = Application.Storage.getValue("relativeHumidity");
    }

}