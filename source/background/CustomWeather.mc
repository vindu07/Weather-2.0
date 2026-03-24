using Toybox.Application;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.WatchUi;



class CustomWeather extends WatchUi.Drawable {


    // Resources
    private var cloudy = WatchUi.loadResource(Rez.Drawables.Cloudy) as WatchUi.BitmapResource;
    private var fog = WatchUi.loadResource(Rez.Drawables.Fog) as WatchUi.BitmapResource;
    private var wind = WatchUi.loadResource(Rez.Drawables.Wind) as WatchUi.BitmapResource;
    private var lightRain = WatchUi.loadResource(Rez.Drawables.LightRain) as WatchUi.BitmapResource;
    private var heavyRain = WatchUi.loadResource(Rez.Drawables.HeavyRain) as WatchUi.BitmapResource;
    private var thunderstorm = WatchUi.loadResource(Rez.Drawables.Thunderstorm) as WatchUi.BitmapResource;
    private var snow = WatchUi.loadResource(Rez.Drawables.Snow) as WatchUi.BitmapResource;
    private var extreme = WatchUi.loadResource(Rez.Drawables.Extreme) as WatchUi.BitmapResource;

    private var condition = WeatherMod.getConditionType();

    private var drawWeather;
    private var energySavingMode;

    
    function initialize(params){
        Drawable.initialize(params);
        getAppSettings();
    }

    public function draw(dc  as Gfx.Dc){

        if(SETTINGSCHANGED){
            getAppSettings();
        }
        
        var isDay = Astronomy.isDay(Time.now());
        var conditionType = WeatherMod.getConditionType();
        
        if(isDay && drawWeather && !energySavingMode && conditionType != null){
            
            var drawables = getBitmapArray() as Lang.Array<Lang.Dictionary>; //Gets all the bitmaps to draw

            for(var i=0; i < drawables.size(); i++){
                dc.drawBitmap(drawables[i][:x], drawables[i][:y], drawables[i][:drawable]);
            }
        }
    
    }

    // Returns an array containing bitmaps and positions related to the weather condition
    function getBitmapArray() as Lang.Array<Lang.Dictionary> {

        // This function will be modified in future with layout parameters for the compatibility
        // with 280x280 and 240x240 displays
        
        var array = [];
        var weather;

        if(updateBackground){
            weather = WeatherMod.getConditionType(); 
            self.condition = weather; 
        }
        else{
            weather = self.condition; 
        }

        try{
        switch(weather as WeatherMod.CustomCondition){
            case WeatherMod.CONDITION_Fog: 
                array.add({:x => -10, :y => -10, :drawable => fog});  
                break;
            case WeatherMod.CONDITION_Light_Rain: 
                array.add({:x => -10, :y => -10, :drawable => lightRain}); 
                break;
            case WeatherMod.CONDITION_Heavy_Rain:
                array.add({:x => -10, :y => -10, :drawable => heavyRain}); 
                break;
            case WeatherMod.CONDITION_Snow:
                array.add({:x => -10, :y => -10, :drawable => snow});  
                break;
            case WeatherMod.CONDITION_Thunderstorm:
                array.add({:x => -10, :y => -10, :drawable => heavyRain}); 
                array.add({:x => -10, :y => -10, :drawable => thunderstorm});  
                break;
            case WeatherMod.CONDITION_Wind:    
                array.add({:x => -10, :y => -10, :drawable => wind});  
                break;
            case WeatherMod.CONDITION_Covered:
                array.add({:x => -10, :y => -10, :drawable => cloudy});  
                break;
            case WeatherMod.CONDITION_Dust:
                array.add({:x => -10, :y => -10, :drawable => fog});  
                break;
            case WeatherMod.CONDITION_Extreme:
                array.add({:x => -10, :y => -10, :drawable => extreme});  
        }
        }catch(ex){
            System.println("ERROR - CustomWeather.getBitmapArray - " + ex.getErrorMessage());
        }

        return array;
    }

    function getAppSettings() as Void {
        try{
            drawWeather = Application.Properties.getValue("ShowWeather");
            if(drawWeather == null){
                drawWeather = false;
            }
            
            energySavingMode = Application.Properties.getValue("EnergySavingMode");
            if(energySavingMode == null){
                energySavingMode = false;
            }
        }
        catch(ex){
            System.println("ERROR -- CustomWeather.getAppSettings -- " + ex.getErrorMessage());
            drawWeather = false;
            energySavingMode = false;
        }
    }

    
}