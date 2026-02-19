using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.Application;



class CustomWeather extends WatchUi.Drawable {

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
        
        if(isDay && drawWeather && !energySavingMode){
            var drawables = getBitmapArray() as Lang.Array<Lang.Dictionary>;

            for(var i=0; i < drawables.size(); i++){
                dc.drawBitmap(drawables[i][:x], drawables[i][:y], drawables[i][:drawable]);
            }
        }
    
    }

    function getBitmapArray() as Lang.Array<Lang.Dictionary> {
        
        var array = [];
        var weather;

        if(minSinceAppStart%15 == 0){weather = WeatherMod.getConditionType(); self.condition = weather; }
        else{weather = self.condition; }

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
        
        drawWeather = Application.Properties.getValue("ShowWeather");
        energySavingMode = Application.Properties.getValue("EnergySavingMode");
    }

    
}