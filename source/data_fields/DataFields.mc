using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
import Toybox.Application;


class DataFields extends Ui.Drawable {

    private var textColor as Gfx.ColorType = Gfx.COLOR_WHITE;
    private var FONT12 = Ui.loadResource(Rez.Fonts.FONT_12);
    private var INFO_FONT12 = Ui.loadResource(Rez.Fonts.INFO_FIELD_FONT_12);

    private var showFields as Lang.Boolean = false;

    private var mx;
    private var my;
    private var mwidth;
    private var mheight;
    //private var mroundRadius;
    private var msensor;
    private var mnumber as Lang.String = "1";
   
    
    typedef DataFieldsParams as {

        :identifier as Lang.String,
        :x as Lang.Number,
        :y as Lang.Number,
        :width as Lang.Number,
        :height as Lang.Number,
        :roundRadius as Lang.Number,
        :number as Lang.Number
    };
    
    function initialize(params as DataFieldsParams){
        Drawable.initialize(params);
        getAppSettings();

        mx = params[:x] as Lang.Number;
        my = params[:y] as Lang.Number;
        mwidth = params[:width] as Lang.Number;
        mheight = params[:height] as Lang.Number;
        mnumber = params[:number].toString() as Lang.String;
        msensor = Properties.getValue("DataField" + mnumber as Lang.String) as SensorMod.Sensortype;
    }

    function draw(dc as Gfx.Dc) as Void{

        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(showFields){
            
            var temp = SensorMod.getSensorDataAndTitle(msensor);
            //descrizione campo
            var title = temp[1];
    

            //fallback se dati null
            var data = temp[0];
            if(data == null){
                data = "--";
            }

            dc.setColor(self.textColor, Gfx.COLOR_BLACK);
            dc.drawText(mx+mwidth/2, my, FONT12, title, Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(mx+mwidth/2, my+mheight/2, INFO_FONT12, data, Gfx.TEXT_JUSTIFY_CENTER);
        }

    }

    function getAppSettings() as Void{
        textColor = Properties.getValue("FieldColor") as Gfx.ColorType;
        msensor = Properties.getValue("DataField" + mnumber) as SensorMod.Sensortype;

        showFields = Properties.getValue("ShowDataFields") as Lang.Boolean;
    }

}