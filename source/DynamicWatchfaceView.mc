import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian as Greg;


var ISHIGHPOWERON as Lang.Boolean = true;

var isPartialUpdate as Lang.Boolean = false;
var haveToReload as Lang.Boolean = false;

//incrementato a ogni update
var minSinceAppStart = 0;

class DynamicWatchfaceView extends WatchUi.WatchFace {


    private var fallback_position;

    function initialize() {
        WatchFace.initialize();
        getAppSettings();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(minSinceAppStart%60 == 0 || SETTINGSCHANGED){//Inizio e ogni 60 min
            Astronomy.refreshData(fallback_position);
        }
        if(minSinceAppStart%15 == 0 || haveToReload){//Inizio e ogni 15 min OPPURE refresh forzato
            WeatherMod.refreshData();
            updateSunPosition = true;
        }
      
        minSinceAppStart += 1;

        View.onUpdate(dc);
        
        SETTINGSCHANGED = false;
        isPartialUpdate = false;
        haveToReload = false;
    }

  
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        ISHIGHPOWERON = true;
        haveToReload = true;
        WatchUi.requestUpdate();//ricarica tutti i dati
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        ISHIGHPOWERON = false;
    }

    function getAppSettings(){
        fallback_position = [Properties.getValue("DefaultPositionLat") as Lang.Float, Properties.getValue("DefaultPositionLon") as Lang.Float];

    }

   
}