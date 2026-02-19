using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
import Toybox.Application;


class InfoFields extends Ui.Drawable {

    private var textColor as Gfx.ColorType = Gfx.COLOR_WHITE;
    private var infoFont = WatchUi.loadResource(Rez.Fonts.INFO_FIELD_FONT_12);

    private var showFields as Lang.Boolean = false;

    private var mx;
    private var my;
    private var mwidth;
    private var mheight;
    //private var mroundRadius;
    private var msensor;
    private var mnumber as Lang.String = "1";
   
    
    typedef InfoFieldsParams as {

        :identifier as Lang.String,
        :x as Lang.Number,
        :y as Lang.Number,
        :width as Lang.Number,
        :height as Lang.Number,
        :roundRadius as Lang.Number,
        :number as Lang.Number
    };
    
    function initialize(params as InfoFieldsParams){
        Drawable.initialize(params);
        getAppSettings();

        mx = params[:x] as Lang.Number;
        my = params[:y] as Lang.Number;
        mwidth = params[:width] as Lang.Number;
        mheight = params[:height] as Lang.Number;
        //mroundRadius = params[:roundRadius] as Lang.Number;
        mnumber = params[:number] as Lang.String;
        msensor = Properties.getValue("InfoField" + mnumber as Lang.String) as SensorMod.Sensortype;
    }

    function draw(dc as Gfx.Dc) as Void{

        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(showFields){
            //fallback se dati null
            var data = SensorMod.getSensorInfo(msensor);
            if(data == null){
                data = "--";
            }

            dc.setColor(self.textColor, Gfx.COLOR_TRANSPARENT);
            //dc.drawRoundedRectangle(mx, my, mwidth, mheight, mroundRadius);
            dc.drawText(mx+mwidth/2, my+mheight/2, infoFont, data, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            dc.clearClip();
        }

    }

    function getAppSettings() as Void{
        textColor = Properties.getValue("FieldColor") as Gfx.ColorType;
        msensor = Properties.getValue("InfoField" + mnumber as Lang.String) as SensorMod.Sensortype;

        showFields = Properties.getValue("ShowInfoFields") as Lang.Boolean;
    }

}