using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.Application;

var updateSunPosition as Lang.Boolean = true;

class SunOrMoon extends Ui.Drawable {

    var sunPosition;

    private var fallback_position;

    private var changeSunPosition;
    private var energySavingMode;

    private var mxCenter as Lang.Number;
    private var myCenter as Lang.Number;
    private var mradius as Lang.Number;
    
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);

        mxCenter = params[:xCenter] as Lang.Number;
        myCenter = params[:yCenter] as Lang.Number;
        mradius = params[:radius] as Lang.Number;

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

        //ritaglia la parte giusta di bitmap
        var Xcut = 20*phase;
        
        //posizione sullo schermo = 45°
        var R = mradius;
        
        var x = mxCenter - R*0.7071;
        var y = myCenter - R*0.7071;

        //disegna la parte della bitmap con la fase corrente
        dc.drawBitmap2(x-Xcut, y, icon, {:bitmapX => Xcut, :bitmapY => 0, :bitmapWidth => 20});

        
    }

    function drawStars(dc as Gfx.Dc) as Void {
        
        var stars = WatchUi.loadResource(Rez.Drawables.Stars);

        dc.drawBitmap(-10, -10, stars);
    }

    function drawSun(dc as Gfx.Dc){
        var position = sunPosition;

        if(updateSunPosition){
            position = getSunPosition(dc);
            sunPosition = position;
            updateSunPosition = false;
        }
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(position[:x], position[:y], 10);
    }

    typedef sunPosition as {
        :x as Lang.Numeric, 
        :y as Lang.Numeric
    };
    
    function getSunPosition(dc as Gfx.Dc) as sunPosition{
        var R = mradius;
        var x, y;

        if(changeSunPosition){
            var sunAngle = Astronomy.getSunAngle(Time.now(), fallback_position);

            x = mxCenter - R*Math.cos(sunAngle);
            y = myCenter - R*Math.sin(sunAngle);
        }
        else{
            x = mxCenter - 0.7071*R;
            y = myCenter - 0.7071*R;
        }

        return {:x => x, :y => y} as sunPosition;
    }

    function getAppSettings(){
        fallback_position = [Properties.getValue("DefaultPositionLat") as Lang.Float, Properties.getValue("DefaultPositionLon") as Lang.Float];
        changeSunPosition = Properties.getValue("DynamicSunPosition");

        energySavingMode = Application.Properties.getValue("EnergySavingMode");

    }
}