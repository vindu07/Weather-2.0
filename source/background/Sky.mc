using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Weather;
using Toybox.Position;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.Lang;

using Astronomy;


class Sky extends Ui.Drawable {

    private var minSinceSunriseUpdate as Lang.Number = 0;
    private var mheight;

    private var changeSkyColor;
    private var energySavingMode;
    
    
    private enum SKYCOLORS{

        SKY_COLOR_BLUE = 0x00aaff,
        SKY_COLOR_GREY = 0xaaaaaa,
        SKY_COLOR_SUNSET = 0xffaa55,
        SKY_COLOR_NIGHT = 0x000055
    }

    
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);
        getAppSettings();

        mheight = params[:height];
        
    }

    public function draw(dc as Gfx.Dc){
        
        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(!energySavingMode){    
            dc.setColor(getSkyColor(), Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(0, 0, dc.getWidth(), mheight);  
        }      
        
        minSinceSunriseUpdate += 1;
    }

    private function getSkyColor() as Gfx.ColorType{
        var color = SKY_COLOR_BLUE;//default
        
        try{

            var condition = (Weather.getCurrentConditions() != null) ? Weather.getCurrentConditions().condition : Weather.CONDITION_CLEAR;
            if(condition == null){
                System.println("WARNING -- Sky.getSkyColor -- cond. meteo non disponibili");
            }
        
            
            if(changeSkyColor){
                var isNight = !(Astronomy.isDay(Time.now()));       
                var isTwiLight = Astronomy.isTwilight(Time.now());
                var isCovered = WeatherMod.isCovered();
                
                
                
                if(isCovered){
                    color = SKY_COLOR_GREY;
                }
                if(isNight){
                    color = SKY_COLOR_NIGHT;
                }
                if(isTwiLight){
                    color = SKY_COLOR_SUNSET;
                }
            }

        }
        catch(ex){
            System.println("ERROR -- Sky.GetSkyColor -- " + ex.toString());
        }
        
        return color as Gfx.ColorType;
    }

    private function getAppSettings() as Void{
        changeSkyColor = Application.Properties.getValue("DynamicSkyColor");

        energySavingMode = Application.Properties.getValue("EnergySavingMode");
    }

}