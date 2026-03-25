using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.WatchUi as Ui;



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

        // Cover first with black rectangle to avoid overlaps

            dc.setClip(xPOS - 80, yPOS, 160, 25);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(xPOS - 80, yPOS, 160, 25);
        

        dc.setColor(TEXTCOLOR, Gfx.COLOR_BLACK);
        dc.drawText(xPOS, yPOS, FONT, date, Graphics.TEXT_JUSTIFY_CENTER);
        dc.clearClip();
    }

    private function getCurrentDate() as Lang.String{
        var date = "ERROR"; // fallback
        var dateFormat = "$1$ $2$ $3$";
        
        try{
        
            var dateInfo = Greg.info(Time.now(), Time.FORMAT_MEDIUM);
            
            var dayOfWeek = dateInfo.day_of_week;
            var month = dateInfo.month;
            var day = dateInfo.day;

            if(dayOfWeek == null || month == null || day == null){
                System.println("ERROR -- DateDisplay.getCurrentDate -- Some date components are null");
                return "--";
            }

            // Add code if needed to format in different languages

            // Format the string
            date = format(dateFormat, [dayOfWeek.toString().toUpper(), day, month.toString().toUpper()]) as Lang.String;

        }
        catch(ex){
            System.println("ERROR -- DateDisplay.getCurrentDate -- " + ex.toString());
            date = "--";
        }

        return date;
    }

    private function getAppSettings() as Void{
        try{
            var timeCol = Properties.getValue("DateColor");
            TEXTCOLOR = (timeCol != null) ? timeCol : Gfx.COLOR_WHITE;
        }
        catch(ex){
            System.println("ERROR -- DateDisplay.getAppSettings -- " + ex.getErrorMessage());
            TEXTCOLOR = Gfx.COLOR_WHITE;
        }
    }
}

