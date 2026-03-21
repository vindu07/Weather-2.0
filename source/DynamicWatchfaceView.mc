using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time.Gregorian as Greg;
using Toybox.WatchUi;
using Toybox.Graphics as Gfx;


var WeatherUpdateInterval = 10;
var AstronomyUpdateInterval = 120;

//booleans for the updates
var ISHIGHPOWERON as Lang.Boolean = true;
var isPartialUpdate as Lang.Boolean = false;
var ReloadWeather as Lang.Boolean = false;

//Counter
var minSinceAppStart = 0;

class DynamicWatchfaceView extends WatchUi.WatchFace {


    private var fallback_position;

    function initialize() {
        WatchFace.initialize();
        getAppSettings();
    }

    // Load your resources here
    function onLayout(dc as Gfx.Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        
    }

  
    function onUpdate(dc as Gfx.Dc) as Void {

        if(SETTINGSCHANGED){
            getAppSettings();
            Astronomy.refreshData(fallback_position);
        }

        if(minSinceAppStart % AstronomyUpdateInterval == 0){ // Start and every n min OR settings changed
            Astronomy.refreshData(fallback_position);
        }
        if(minSinceAppStart % WeatherUpdateInterval == 0 || ReloadWeather){ // Start and every n min OR forced refresh
            WeatherMod.refreshData();
            updateSunPosition = true;
        }
      
        minSinceAppStart += 1; // update the minute counter

        View.onUpdate(dc); // redraw the screen
        
        // Reset the booleans
        SETTINGSCHANGED = false;
        isPartialUpdate = false;
        ReloadWeather = false;
    }

  
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        ISHIGHPOWERON = true;
        ReloadWeather = true;
        WatchUi.requestUpdate(); // refresh the screen
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        ISHIGHPOWERON = false;
    }

    
    function getAppSettings(){
        try{
            var lat = Properties.getValue("DefaultPositionLat");
            var lon = Properties.getValue("DefaultPositionLon");
            fallback_position = [(lat != null) ? lat : 51.5, (lon != null) ? lon : 0.001];

            WeatherUpdateInterval = Properties.getValue("WeatherUpdate") as Lang.Number;
            AstronomyUpdateInterval = Properties.getValue("AstronomyUpdate") as Lang.Number;
        }
        catch(ex){
            System.println("ERROR -- DynamicWatchfaceView.getAppSettings -- " + ex.getErrorMessage());
            fallback_position = [51.5, 0.001];
        }
    }

   
}