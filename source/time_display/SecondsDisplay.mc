using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.WatchUi as Ui;



class SecondsDisplay extends Ui.Drawable {

    private var TEXTCOLOR;

    private var ShowSeconds;

    private var _x;
    private var _y;
    private var _width;
    private var _height;

        
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);
        getAppSettings();

        _x = params[:x];
        _y = params[:y];
        _width = params[:width];
        _height = params[:height];
    }

    public function draw(dc as Gfx.Dc) as Void{
        
        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(ShowSeconds && ISHIGHPOWERON){
        
            var seconds = Greg.info(Time.now(), Time.FORMAT_SHORT).sec as Lang.Number;
            var string = seconds.format("%02d");


            // Cover first with black rectangle to avoid overlaps
            
            dc.setClip(_x, _y, _width, _height);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(_x, _y, _width, _height);
            
            
            dc.setColor(TEXTCOLOR, Gfx.COLOR_TRANSPARENT);
            dc.drawText(_x + _width/3, _y, Gfx.FONT_GLANCE_NUMBER, string, Graphics.TEXT_JUSTIFY_CENTER);
            dc.clearClip();
        }
    }
    


    private function getAppSettings() as Void{
        try{
            
            TEXTCOLOR = Properties.getValue("SecondsColor");
            ShowSeconds = Properties.getValue("ShowSeconds");
        }
        catch(ex){
            System.println("ERROR -- TimeDisplay.getAppSettings -- " + ex.getErrorMessage());
            TEXTCOLOR = Gfx.COLOR_WHITE;
            ShowSeconds = true;
        }
    }
}