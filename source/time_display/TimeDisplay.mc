using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.WatchUi as Ui;



class TimeDisplay extends Ui.Drawable {

    private var useMilitaryFormat;
    private var removeZerosFromHour;
    private var is24Hour;

    private var xPOS as Lang.Number = System.getDeviceSettings().screenWidth/2; // center
    private var yPOS as Lang.Numeric = System.getDeviceSettings().screenHeight*.45; // 45% height
    private var FONT as Gfx.FontType = WatchUi.loadResource(Rez.Fonts.FONT_40) as Gfx.FontType;
    private var TEXTCOLOR;

        
    function initialize(params){
        Drawable.initialize(params);
        getAppSettings();
    }

    public function draw(dc as Gfx.Dc) as Void{
        
        if(SETTINGSCHANGED){
            getAppSettings();
        }
        
        var time = getCurrentTime();

        // Cover first with black rectangle to avoid overlaps
        
            dc.setClip(xPOS - 80, yPOS, 160, 41);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xPOS - 80, yPOS, 160, 41);
        
        
        dc.setColor(TEXTCOLOR, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPOS, yPOS, FONT, time, Graphics.TEXT_JUSTIFY_CENTER);
        dc.clearClip();
    }
    

    private function getCurrentTime() as Lang.String{
        var timeString = "--:--";
        var timeFormat = "$1$:$2$";
        var hourFormat = "%02u";

        try{
            var currentTime = Greg.info(Time.now(), Time.FORMAT_SHORT);
            
            var hour = currentTime.hour;
            var minInfo = currentTime.min;

            if(hour == null || minInfo == null){
                System.println("ERROR -- TimeDisplay.getCurrentTime -- Hour or min is null");
                return "--:--";
            }
            
            var min = minInfo.format("%02u");

            if(useMilitaryFormat){ // Military format - NOTE: overrides other formats
                timeFormat = "$1$$2$";
            }
            else{
                if(removeZerosFromHour){ // Remove leading zero from hour
                    hourFormat = "%u";
                }

                if(!is24Hour && hour>12){
                    hour %= 12; //ora tra 0-12
                }
            }
      
            //formatta la stringa
            hour = hour.format(hourFormat).toString();
           
            timeString = format(timeFormat, [hour, min]) as Lang.String;
        }
        catch(ex){
            System.println("ERROR -- TimeDisplay.getCurrentTime -- " + ex.getErrorMessage());
            timeString = "--:--";
        }

        return timeString;
    }

    private function getAppSettings() as Void{
        try{
            var useMilitary = Properties.getValue("UseMilitaryFormat" as Application.PropertyKeyType);
            useMilitaryFormat = (useMilitary != null) ? useMilitary : false;
            
            var removeZeros = Properties.getValue("RemoveZerosFromHour" as Application.PropertyKeyType);
            removeZerosFromHour = (removeZeros != null) ? removeZeros : false;
            
            var settings = System.getDeviceSettings();
            is24Hour = (settings != null && settings.is24Hour != null) ? settings.is24Hour : true;

            var timeCol = Properties.getValue("TimeColor");
            TEXTCOLOR = (timeCol != null) ? timeCol : Gfx.COLOR_WHITE;
        }
        catch(ex){
            System.println("ERROR -- TimeDisplay.getAppSettings -- " + ex.getErrorMessage());
            useMilitaryFormat = false;
            removeZerosFromHour = false;
            is24Hour = true;
            TEXTCOLOR = Gfx.COLOR_WHITE;
        }
    }
}