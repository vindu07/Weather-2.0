using Toybox.System;
using Toybox.Lang;
using Toybox.Application.Properties;
using Toybox.WatchUi;
using Toybox.Complications;


class DynamicWatchfaceDelegate extends WatchUi.WatchFaceDelegate {

    function initialize(){
        WatchFaceDelegate.initialize();
    }
    
    function onPress(event as WatchUi.ClickEvent){

        var y = event.getCoordinates();
        var x = y[0];
        y = y[1];

        // upper part
        if(y < 100){
            Complications.exitTo(new Complications.Id(Complications.COMPLICATION_TYPE_CURRENT_WEATHER));
        }
        // time/date
        else if(x>60 && x<200 && y<160) {
            Complications.exitTo(new Complications.Id(Complications.COMPLICATION_TYPE_DATE));
        }
        // lower part
        else if(y > 180){   
            //Complications.exitTo(new Complications.Id(Complications.COMPLICATION_TYPE_TRAINING_STATUS));

        }
        
        return true;
    }
}