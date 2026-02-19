using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Greg;
import Toybox.Application;
import Toybox.System;
import Toybox.Lang;



class TimeDisplay extends Ui.Drawable {

    private var useMilitaryFormat;
    private var removeZerosFromHour;
    private var is24Hour;

    private var xPOS as Number = System.getDeviceSettings().screenWidth/2; //centro
    private var yPOS as Numeric = System.getDeviceSettings().screenHeight*.45; //45% altezza
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

        //copro prima con rettangolo nero per evitare sovrapposizioni
        
            dc.setClip(xPOS - 80, yPOS, 160, 41);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xPOS - 80, yPOS, 160, 41);
        
        
        dc.setColor(TEXTCOLOR, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPOS, yPOS, FONT, time, Graphics.TEXT_JUSTIFY_CENTER);
        dc.clearClip();
    }
    

    private function getCurrentTime() as String{
        var timeString;
        var timeFormat = "$1$:$2$";
        var hourFormat = "%02u";

        var currentTime = Greg.info(Time.now(), Time.FORMAT_SHORT);
        var hour = currentTime.hour;
        var min = currentTime.min.format("%02u");

        if(useMilitaryFormat){//formato militare N.B. sovrascrive le altre formattazioni
            timeFormat = "$1$$2$";
        }
        else{
            if(removeZerosFromHour){//toglie zero prima dell ora
                hourFormat = "%u";
            }

            if(!is24Hour && hour>12){
                hour %= 12; //ora tra 0-12
            }
        }
  
        //formatta la stringa
        hour = hour.format(hourFormat).toString();
       
        timeString = format(timeFormat, [hour, min]) as String;
        

        return timeString;
    }

    private function getAppSettings() as Void{
        useMilitaryFormat = Properties.getValue("UseMilitaryFormat" as PropertyKeyType) as Boolean;
        removeZerosFromHour = Properties.getValue("RemoveZerosFromHour" as PropertyKeyType) as Boolean;
        is24Hour = System.getDeviceSettings().is24Hour as Boolean;

        TEXTCOLOR = Properties.getValue("TimeColor") as Gfx.ColorType;
    }
}