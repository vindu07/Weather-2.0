using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Greg;
import Toybox.Application;
import Toybox.System;
import Toybox.Lang;



class DateDisplay extends Ui.Drawable {

    
    private  var xPOS;
    private var yPOS;
    private var FONT as Gfx.FontType= Gfx.FONT_SYSTEM_TINY;
    private var TEXTCOLOR;

    
        
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);
        getAppSettings();

        xPOS = params[:x];
        yPOS = params[:y];
    }

    public function draw(dc as Gfx.Dc) as Void{

        if(SETTINGSCHANGED){
            getAppSettings();
        }

        var date = getCurrentDate();

        //copro prima con rettangolo nero per evitare sovrapposizioni

            dc.setClip(xPOS - 80, yPOS, 160, 25);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xPOS - 80, yPOS, 160, 25);
        

        dc.setColor(TEXTCOLOR, Gfx.COLOR_BLACK);
        dc.drawText(xPOS, yPOS, FONT, date, Graphics.TEXT_JUSTIFY_CENTER);
        dc.clearClip();
    }

    private function getCurrentDate() as String{
        var date = "404";///togliere
        var dateFormat = "$1$ $2$ $3$";
        
        try{
        
        var today = Greg.info(Time.now(), Time.FORMAT_MEDIUM);
        var dayOfWeek = today.day_of_week.toString().toUpper();
        var month = today.month.toString().toUpper();
        var day = today.day;

        //aggiungere eventuale codice per formattare in diverse lingue

        //formatta la stringa
        date = format(dateFormat, [dayOfWeek, day, month]) as String;

        }
        catch(ex){
            System.println("ERROR -- DateDisplay.getCurrentDate -- " + ex.toString());
        }

        return date;
    }

    private function getAppSettings() as Void{
        TEXTCOLOR = Properties.getValue("TimeColor") as Gfx.ColorType;
    }
}

