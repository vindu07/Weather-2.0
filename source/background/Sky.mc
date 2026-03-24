using Toybox.Application;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.Weather;
using Toybox.WatchUi as Ui;


class Sky extends Ui.Drawable {

    private var _height;

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

        _height = params[:height];       
    }

    public function draw(dc as Gfx.Dc){
        
        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(!energySavingMode){    
            dc.setColor(getSkyColor(), Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(0, 0, dc.getWidth(), _height);  
        }      
        
    }

    private function getSkyColor() as Gfx.ColorType{
        var color = SKY_COLOR_BLUE; // default
        
        try{
            
            if(changeSkyColor && updateBackground){
                
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
                } // twilight wins even if the sky is covered
            }

        }
        catch(ex){
            System.println("ERROR -- Sky.GetSkyColor -- " + ex.toString());
        }
        
        return color as Gfx.ColorType;
    }

    private function getAppSettings() as Void{
        try{
            var changeSky = Application.Properties.getValue("DynamicSkyColor");
            changeSkyColor = (changeSky != null) ? changeSky : true;

            var enSave = Application.Properties.getValue("EnergySavingMode");
            energySavingMode = (enSave != null) ? enSave : false;
        }
        catch(ex){
            System.println("ERROR -- Sky.getAppSettings -- " + ex.getErrorMessage());
            changeSkyColor = true;
            energySavingMode = false;
        }
    }

}