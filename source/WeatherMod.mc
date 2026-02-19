using Toybox.Weather;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Weather as Wtr;
using Toybox.Lang;
using Astronomy;
using Toybox.Time;
using Toybox.System;
import Toybox.Application.Storage;

module WeatherMod {

    typedef Conditions as {
        :condition as Lang.Number, :cloudCover as Lang.Number, :pressure as Lang.Float, 
        :temperature as Lang.Numeric, :relativeHumidity as Lang.Number, :windSpeed as Lang.Float
    };

    var WeatherConditions as Conditions = {
        :condition => 53, :cloudCover => 0, :pressure => 0.0, 
        :temperature => 0.0, :relativeHumidity => 0, :windSpeed => 0.0
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
    
    function getCondition() as Wtr.Condition{
        
        self.getCurrentConditions();

        var condition = self.WeatherConditions;

        //meteo real time
        if(!hasNullValues(condition)){
            return condition[:condition] as Wtr.Condition;
        }
        
        //fallback su memoria
        condition = self.getData() as Conditions;
        
        if(!hasNullValues(condition)){
            return condition[:condition] as Wtr.Condition;
        }
        
        //lascia invariato
        return WeatherConditions[:condition] as Weather.Condition;
    }
    
    function isCovered() as Lang.Boolean{

        var isCovered = (WeatherConditions[:cloudCover] >= 50);

        return isCovered as Lang.Boolean;
    }

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



    function refreshData(){
        self.getCurrentConditions();
        self.storeData();
    }
    function storeData(){
        Storage.setValue("condition", self.WeatherConditions[:condition]);
        Storage.setValue("temperature", self.WeatherConditions[:temperature]);
        Storage.setValue("pressure", self.WeatherConditions[:pressure]);
        Storage.setValue("windSpeed", self.WeatherConditions[:windSpeed]);
        Storage.setValue("cloudCover", self.WeatherConditions[:cloudCover]);
        Storage.setValue("relativeHumidity", self.WeatherConditions[:relativeHumidity]);
    }
    function getData(){
        
        self.WeatherConditions[:condition] = Storage.getValue("condition");
        self.WeatherConditions[:temperature] = Storage.getValue("temperature");
        self.WeatherConditions[:pressure] = Storage.getValue("pressure");
        self.WeatherConditions[:windSpeed] = Storage.getValue("windSpeed");
        self.WeatherConditions[:cloudCover] = Storage.getValue("cloudCover");
        self.WeatherConditions[:relativeHumidity] = Storage.getValue("relativeHumidity");
    }

}