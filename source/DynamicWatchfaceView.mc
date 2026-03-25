using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time.Gregorian as Greg;
using Toybox.WatchUi;
using Toybox.Graphics as Gfx;


var BackgroundUpdateInterval = 10;
var AstronomyUpdateInterval = 120;

//booleans for the updates
var ISHIGHPOWERON as Lang.Boolean = true;
var updateBackground as Lang.Boolean = false;

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
            updateBackground = true;
        }

        if(minSinceAppStart % AstronomyUpdateInterval == 0){ // Start and every n min
            Astronomy.refreshData(fallback_position);
        }
        if(minSinceAppStart % BackgroundUpdateInterval == 0){ // Start and every n min
            updateBackground = true;
        }

        if(!ISHIGHPOWERON){
            minSinceAppStart += 1; // update the minute counter
            System.println(minSinceAppStart);
        }
        
        View.onUpdate(dc); // redraw the screen
        
        // Reset the booleans
        SETTINGSCHANGED = false;
        updateBackground = false;
    }

    function onPartialUpdate(dc as Gfx.Dc) as Void {
        //future updates for seconds/live hr
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        ISHIGHPOWERON = true;
        updateBackground = true;
        WatchUi.requestUpdate(); // refresh the screen
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        ISHIGHPOWERON = false;
        WatchUi.requestUpdate();
    }

    
    function getAppSettings(){
        try{
            var lat = Properties.getValue("DefaultPositionLat");
            var lon = Properties.getValue("DefaultPositionLon");
            fallback_position = [(lat != null) ? lat : 51.5, (lon != null) ? lon : 0.001];

            BackgroundUpdateInterval = Properties.getValue("BackgroundUpdate") as Lang.Number;
            AstronomyUpdateInterval = Properties.getValue("AstronomyUpdate") as Lang.Number;
        }
        catch(ex){
            System.println("ERROR -- DynamicWatchfaceView.getAppSettings -- " + ex.getErrorMessage());
            fallback_position = [51.5, 0.001];
        }
    }

   
}