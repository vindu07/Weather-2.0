using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.WatchUi as Ui;

class SunOrMoon extends Ui.Drawable {

    typedef sunPosition as {
        :x as Lang.Numeric, 
        :y as Lang.Numeric
    };

    var SunPosition;

    private var fallback_position;

    private var changeSunPosition;
    private var changeMoonPhase;
    private var energySavingMode;

    private var _xCenter as Lang.Number;
    private var _yCenter as Lang.Number;
    private var _radius as Lang.Number;
    
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);

        _xCenter = params[:xCenter] as Lang.Number;
        _yCenter = params[:yCenter] as Lang.Number;
        _radius = params[:radius] as Lang.Number;

        getAppSettings();
    }

    function draw(dc){

        if(SETTINGSCHANGED){
            getAppSettings();
        }
        
        if(!energySavingMode){
            var isDay = Astronomy.isDay(Time.now());
            var isCovered = WeatherMod.isCovered();

            
            if(isDay){
                drawSun(dc);
            }
            else{
                
                if(!isCovered){
                    drawStars(dc);
                }
                drawMoonIcon(dc);
            }
        }
        
    }

    function drawMoonIcon(dc as Gfx.Dc){

        var icon = WatchUi.loadResource(Rez.Drawables.MoonPhases);
        var phase = Astronomy.MoonPhase as Lang.Number;

        if(!changeMoonPhase){
            phase = 4; // full moon
        }

        // Crop the correct part of bitmap - each phase has a width of 20px
        var Xcut = 20*phase;
        
        // Screen position = 45° (fixed)
        var x = _xCenter - _radius*0.7071;
        var y = _yCenter - _radius*0.7071;

        // Draw the part of bitmap with current phase
        dc.drawBitmap2(x-Xcut, y, icon, {:bitmapX => Xcut, :bitmapY => 0, :bitmapWidth => 20});

        
    }

    function drawStars(dc as Gfx.Dc) as Void {
        
        var stars = WatchUi.loadResource(Rez.Drawables.Stars);

        dc.drawBitmap(-10, -10, stars); // To edit for future compatibility with 280x280 screens
    }

    function drawSun(dc as Gfx.Dc){
        
        var position = self.SunPosition;

        if(updateBackground){
            
            position = getSunPosition(dc) as sunPosition;
            self.SunPosition = position;
        }
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(position[:x], position[:y], 10);
    }
    
    // Calls Astronomy module and calculates the position in pixels from the given angle
    function getSunPosition(dc as Gfx.Dc) as sunPosition{
        
        var R = _radius;
        var x, y;

        if(changeSunPosition){
            var sunAngle = Astronomy.getSunAngle(Time.now(), fallback_position);

            x = _xCenter - R*Math.cos(sunAngle);
            y = _yCenter - R*Math.sin(sunAngle);
        }
        else{
            x = _xCenter - 0.7071*R;
            y = _yCenter - 0.7071*R;
        }

        return {:x => x, :y => y} as sunPosition;
    }

    function getAppSettings(){
        try{
            var lat = Properties.getValue("DefaultPositionLat");
            var lon = Properties.getValue("DefaultPositionLon");
            fallback_position = [(lat != null) ? lat : 51.5, (lon != null) ? lon : 0.001];
            
            var changeSun = Properties.getValue("DynamicSunPosition");
            changeSunPosition = (changeSun != null) ? changeSun : true;

            changeMoonPhase = Properties.getValue("DynamicMoonPhase");
            

            var enSave = Properties.getValue("EnergySavingMode");
            energySavingMode = (enSave != null) ? enSave : false;
        }
        catch(ex){
            System.println("ERROR -- SunOrMoon.getAppSettings -- " + ex.getErrorMessage());
            fallback_position = [51.5, 0.001];
            changeSunPosition = true;
            energySavingMode = false;
        }
    }
}