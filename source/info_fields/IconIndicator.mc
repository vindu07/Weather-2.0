using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.WatchUi as Ui;


class IconIndicator extends Ui.Drawable {

    private var mx;
    private var my;
    private var mtype;

    private var showIcons as Lang.Boolean = false;

    private var mcolor = Gfx.COLOR_WHITE;
    private var weatherFont = WatchUi.loadResource(Rez.Fonts.WEATHER_ICONS_20);
    private var moonFont = WatchUi.loadResource(Rez.Fonts.MOON_ICONS_20);
    
    enum iconType{
        ICON_WEATHER,
        ICON_MOONPHASE,
        ICON_GPS,
        ICON_BLE_SILENT,
        ICON_BLE_WIFI,
        ICON_PHONE
    }
    
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);
        getAppSettings();

        mx = params[:x] as Lang.Number;
        my = params[:y] as Lang.Number;
        mtype = params[:type] as iconType;
    }

    function draw(dc as Gfx.Dc) as Void{

        if(SETTINGSCHANGED){
            getAppSettings();
        }

        dc.setColor(mcolor, Graphics.COLOR_TRANSPARENT);

        if(showIcons){
            switch(mtype){
                case ICON_WEATHER:
                    drawWeatherIcon(dc);
                    break;
                case ICON_MOONPHASE:
                    drawMoonIcon(dc);
                    break;
            }
        }
        
    }
    function drawWeatherIcon(dc as Gfx.Dc){
        try{
            var Condition = WeatherMod.getCondition();

            var iconChar = UtilsMod.toAsciiString(UtilsMod.toAsciiCode("A") + Condition);

            
            dc.drawText(mx, my, weatherFont, iconChar, Graphics.TEXT_JUSTIFY_CENTER);
        }
        catch(ex){
            System.println("ERROR -- IconIndicator.drawWeatherIcon -- " + ex.getErrorMessage());
        }
    }
    function drawMoonIcon(dc as Gfx.Dc){
        try{
            var phase = Astronomy.MoonPhase;
            
            dc.drawText(mx, my, moonFont, UtilsMod.toAsciiString( 65 + phase), Gfx.TEXT_JUSTIFY_CENTER);
        }
        catch(ex){
            System.println("ERROR -- IconIndicator.drawMoonIcon -- " + ex.getErrorMessage());
        }
    }


    function getAppSettings() as Void{
        try{
            var iconCol = Properties.getValue("IconColor");
            mcolor = (iconCol != null) ? iconCol : Gfx.COLOR_WHITE;
            
            var showIcons = Properties.getValue("ShowIcons");
            self.showIcons = (showIcons != null) ? showIcons : false;
        }
        catch(ex){
            System.println("ERROR -- IconIndicator.getAppSettings -- " + ex.getErrorMessage());
            mcolor = Gfx.COLOR_WHITE;
            self.showIcons = false;
        }
    }
}